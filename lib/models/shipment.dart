import 'package:flutter/material.dart';

class Shipment {
  final String id;
  final String name;
  final String? description;
  final String status;
  final String courier;
  final DateTime entryDate;
  final DateTime? exitDate;

  const Shipment({
    required this.id,
    required this.name,
    this.description,
    required this.status,
    required this.courier,
    required this.entryDate,
    this.exitDate,
  });

  factory Shipment.fromJson(Map<String, dynamic> json) {
    return Shipment(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      status: json['status'] as String,
      courier: json['courier'] as String,
      entryDate: DateTime.parse(json['entry_date'] as String),
      exitDate: json['exit_date'] != null
          ? DateTime.parse(json['exit_date'] as String)
          : null,
    );
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'name': name,
      'description': description,
      'status': status,
      'courier': courier,
      'entry_date': entryDate.toIso8601String(),
      'exit_date': exitDate?.toIso8601String(),
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name,
      'description': description,
      'status': status,
      'courier': courier,
      'exit_date': exitDate?.toIso8601String(),
    };
  }

  Shipment copyWith({
    String? name,
    String? description,
    String? status,
    String? courier,
    DateTime? exitDate,
  }) {
    return Shipment(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      courier: courier ?? this.courier,
      entryDate: entryDate,
      exitDate: exitDate ?? this.exitDate,
    );
  }

  // color helpers
  bool get isDelivered => status.toLowerCase() == 'entregado';

  Color get statusColor => isDelivered
      ? const Color(0xFFBAFFC9)
      : const Color(0xFFFBE580);

  Color get statusTextColor => isDelivered
      ? const Color(0xFF3B7924)
      : const Color(0xFF72821A);

  Color get statusShadowColor => isDelivered
      ? const Color(0xFFB3E8BF)
      : const Color.fromRGBO(239, 255, 114, 0.22);
}
