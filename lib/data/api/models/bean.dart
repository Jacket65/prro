import 'package:equatable/equatable.dart';
import 'package:prro/core/json.dart';

/// A coffee bean a cashier can pick for a drink (e.g. "Арабіка Колумбія").
/// Beans don't change the price for now, but mirror the option shape so a
/// surcharge can be added later if the backend introduces one.
class Bean extends Equatable {
  const Bean({required this.id, required this.name});

  factory Bean.fromJson(Map<String, dynamic> json) {
    return Bean(
      id: parseInt(json['id']),
      name: (json['name'] ?? '').toString(),
    );
  }
  final int id;
  final String name;

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  @override
  List<Object?> get props => [id, name];
}

/// A category of beans (Купаж / Ароматизовані / Арабіка / Без кофеїну). The
/// cashier expands a group and picks one specific bean; selection is single
/// across all groups.
class BeanGroup extends Equatable {
  const BeanGroup({
    required this.id,
    required this.name,
    this.beans = const [],
  });

  factory BeanGroup.fromJson(Map<String, dynamic> json) {
    return BeanGroup(
      id: parseInt(json['id']),
      name: (json['name'] ?? '').toString(),
      beans: (json['beans'] as List<dynamic>? ?? const [])
          .whereType<Map<dynamic, dynamic>>()
          .map((m) => Bean.fromJson(m.cast<String, dynamic>()))
          .toList(),
    );
  }
  final int id;
  final String name;
  final List<Bean> beans;

  @override
  List<Object?> get props => [id, name, beans];
}
