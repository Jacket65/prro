import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:prro/core/json.dart';

part 'retail_outlet.freezed.dart';
part 'retail_outlet.g.dart';

/// A retail outlet (торговельна точка) managed from the admin panel.
///
/// Mirrors `GET /retail-outlets` payloads wrapped in `{ "data": [...] }`.
/// Field parsing is tolerant (via [parseInt]/[parseString]) so a partial or
/// legacy backend response never crashes the list.
@freezed
abstract class RetailOutlet with _$RetailOutlet {
  const factory RetailOutlet({
    required int id,
    required String name,
    String? address,
    String? city,
    bool? isActive,
  }) = _RetailOutlet;

  factory RetailOutlet.fromJson(Map<String, dynamic> json) =>
      _$RetailOutletFromJson(json);
}
