# PRRO

A Flutter application that supports two backend environments: a **production** backend (real API) and a **mock** backend (fake/in-memory data for development and testing).

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) `3.44.6` (or a compatible stable channel)
- Java 17 (for Android builds)
- An IDE such as VS Code or Android Studio with the Flutter plugin

### Install dependencies

```bash
flutter pub get
```

## Building

### Production APK (real backend)

```bash
flutter build apk --release --target-platform=android-arm64 --dart-define=BACKEND_TYPE=real
```

### Mock APK (optional, local/distribution)

```bash
flutter build apk --release --target-platform=android-arm64 --dart-define=BACKEND_TYPE=mock
```

## Running the App

### Mock environment (default, local development)

```bash
flutter run --dart-define=BACKEND_TYPE=mock
```

This is the default if no `BACKEND_TYPE` is provided.

### Production environment

```bash
flutter run --dart-define=BACKEND_TYPE=real
```

## CI / CD

GitHub Actions (`.github/workflows/flutter_ci.yml`) builds **only the production (real) APK**:

- Triggered on every push and pull request
- Sets up Java 17 and Flutter `3.44.6`
- Runs `flutter pub get`, `flutter analyze`, and `flutter test`
- Builds a release ARM64 APK with `--dart-define=BACKEND_TYPE=real`
- Uploads the artifact as `app-prod-release`

The mock build is intentionally not part of CI; it is available locally via the command above.

## Project Structure

- `lib/config/backend_config.dart` — backend selection logic
- `lib/` — application source code (features, state management, services)
- `test/` — unit and widget tests

## Screens

![alt text](images/image-6.png)

![alt text](images/image-1.png)

![alt text](images/image-4.png)

![alt text](images/image-7.png)
