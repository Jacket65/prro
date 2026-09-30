#!/usr/bin/env bash
#
# Feature-first layer boundaries for prro.
#
# Plain `rg`, no analyzer-coupled dependency (D7): `custom_lint`/`module_boundary`
# pin the `analyzer` package, and pubspec.yaml already documents a
# freezed/auto_route_generator analyzer conflict, so adding one risks breaking
# `pub get`.
#
# Prints `file:line: rule — <target>` for every violation and exits 1.
# Generated sources are skipped: di.config.dart and app_router.gr.dart are
# build_runner output that legitimately imports every feature.
#
# Run from anywhere: ./tool/check_boundaries.sh

set -uo pipefail
cd "$(dirname "$0")/.."

VIOLATIONS=0

# report <file> <rule> <detail>
report() {
  local file="$1" rule="$2" detail="$3" line
  line=$(rg -n --no-heading -m1 -F "$detail" "$file" | cut -d: -f1)
  printf '%s:%s: %s — %s\n' "$file" "${line:-1}" "$rule" "$detail"
  VIOLATIONS=$((VIOLATIONS + 1))
}

# feature_of <path-or-uri> -> feature name, or empty when not under features/
feature_of() {
  echo "$1" | sed -nE 's#.*package:prro/features/([^/]+)/.*#\1#p; s#^lib/features/([^/]+)/.*#\1#p'
}

SOURCES=$(find lib test -name '*.dart' \
  -not -name 'di.config.dart' \
  -not -name 'app_router.gr.dart' \
  -not -name '*.g.dart' \
  -not -name '*.freezed.dart' | sort)

# targets_of <file> -> the `package:prro/...` targets it imports, one per line
targets_of() {
  rg -o --no-line-number 'package:prro/[^'"'"']*' "$1" 2>/dev/null
}

while read -r file; do
  layer=other
  case "$file" in
    */domain/*)       layer=domain ;;
    */data/*)         layer=data ;;
    */presentation/*) layer=presentation ;;
  esac

  # R4 — the layer-first `data/` tree is gone; nothing may still point at it.
  while read -r target; do
    [ -n "$target" ] || continue
    case "$target" in
      package:prro/data/*)
        report "$file" "R4" "$target"
        ;;
    esac
  done < <(targets_of "$file")

  # R6 — domain code stays framework-free.
  if [ "$layer" = domain ]; then
    while read -r bad; do
      [ -n "$bad" ] || continue
      # The one deliberate exception: ItemsRepositoryI.searchProducts takes a
      # dio CancelToken so a superseded search can be aborted. Aliasing it to
      # Object? would be type-unsafe, so the import stays and this file is
      # allowlisted instead.
      if [ "$bad" = "package:dio/dio.dart" ] &&
         [ "$file" = "lib/features/seller/domain/repositories/items_repository_i.dart" ]; then
        continue
      fi
      report "$file" "R6" "$bad"
    done < <(rg -o --no-line-number 'package:(dio|http|freezed|get_it)/[^'"'"']*' "$file" 2>/dev/null)
  fi

  while read -r target; do
    [ -n "$target" ] || continue

    case "$layer" in
      domain)
        case "$target" in
          */presentation/*|package:prro/core/di/*|package:prro/core/router/*)
            report "$file" "R1" "$target"
            ;;
        esac
        # A contract may name its own feature's wire DTOs (D9: the freezed
        # models stay in data/models and are not duplicated into domain).
        # Reaching into *another* feature's data/ is not allowed, with the one
        # documented exception below.
        case "$target" in
          */data/*)
            own=$(feature_of "$file")
            other=$(feature_of "$target")
            if [ "$own" = "$other" ]; then
              case "$target" in
                */data/models/*) ;;
                *) report "$file" "R1" "$target" ;;
              esac
            elif [ "$file" = "lib/features/seller/domain/payment/handlers/terminal_payment_handler.dart" ] &&
                 [ "$target" = "package:prro/features/payment/data/models/payment_request.dart" ]; then
              : # documented: the seller handler builds the payment wire request
            else
              report "$file" "R1" "$target"
            fi
            ;;
        esac
        ;;

      data)
        case "$target" in
          */presentation/*)
            report "$file" "R2" "$target"
            ;;
        esac
        case "$target" in
          package:prro/features/*)
            own=$(feature_of "$file")
            other=$(feature_of "$target")
            if [ -n "$own" ] && [ "$own" != "$other" ]; then
              report "$file" "R2" "$target"
            fi
            ;;
        esac
        ;;

      presentation)
        case "$target" in
          package:prro/features/*)
            own=$(feature_of "$file")
            other=$(feature_of "$target")
            [ -n "$other" ] || continue
            [ "$own" = "$other" ] && continue
            case "$target" in
              # The two documented seller edges: the cashier name / logout
              # trigger come from auth, and seller_screen hosts the shift flow.
              package:prro/features/auth/presentation/bloc/*)
                [ "$own" = seller ] || report "$file" "R3" "$target"
                ;;
              package:prro/features/shift/presentation/cubit/*|package:prro/features/shift/presentation/widgets/*)
                [ "$own" = seller ] || report "$file" "R3" "$target"
                ;;
              */presentation/*|*/data/*)
                report "$file" "R3" "$target"
                ;;
            esac
            ;;
        esac
        ;;
    esac
  done < <(targets_of "$file")
done <<< "$SOURCES"

# R5 — core/ is the shared layer and must not reach into features, except the
# app-wide fake backend and the two composition roots (di, router).
while read -r file; do
  case "$file" in
    lib/core/*) ;;
    *) continue ;;
  esac
  case "$file" in
    lib/core/mock/*|lib/core/di/*|lib/core/router/*) continue ;;
  esac
  while read -r target; do
    case "$target" in
      package:prro/features/*) report "$file" "R5" "$target" ;;
    esac
  done < <(targets_of "$file")
done <<< "$(find lib -name '*.dart' -not -name '*.g.dart' -not -name '*.freezed.dart' | sort)"

if [ "$VIOLATIONS" -gt 0 ]; then
  printf '\n%d layer-boundary violation(s).\n' "$VIOLATIONS"
  exit 1
fi

echo "layer boundaries OK"
