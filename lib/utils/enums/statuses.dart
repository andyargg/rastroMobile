import 'package:flutter/material.dart';

enum ShippingStatus {
  delivered,
  inTransit,
  pending,
}

extension ShippingStatusExtension on ShippingStatus {
  Color getColor() {
    switch (this) {
      case ShippingStatus.delivered:
        return Color(0xFFBAFFC9);
      case ShippingStatus.inTransit:
        return Color(0xFFFBE580);
      case ShippingStatus.pending:
        return Colors.grey.shade200;
    }
  }

  String getLabel() {
    switch (this) {
      case ShippingStatus.delivered:
        return 'Entregado';
      case ShippingStatus.inTransit:
        return 'En tránsito';
      case ShippingStatus.pending:
        return 'Pendiente';
    }
  }

  Color getTextColor() {
    switch (this) {
      case ShippingStatus.delivered:
        return const Color(0xFF3B7924);
      case ShippingStatus.inTransit:
        return const Color(0xFF72821A);
      case ShippingStatus.pending:
        return const Color.fromARGB(255, 62, 62, 62);
    }
  }

  Color getShadowColor() {
    switch (this) {
      case ShippingStatus.delivered:
        return const Color(0xFFB3E8BF);
      case ShippingStatus.inTransit:
        return const Color.fromRGBO(239, 255, 114, 0.22);
      case ShippingStatus.pending:
        return const Color.fromRGBO(128, 128, 128, 0.25);
    }
  }
}