import 'package:rastro/models/shipping.dart';
import 'package:rastro/utils/enums/statuses.dart';

final List<Shipping> mockShippings = [
  Shipping(
    productName: 'iPhone 15 Pro',
    status: ShippingStatus.inTransit,
    description: 'Llega entre el 23 y 25 de diciembre',
    courier: 'Correo Argentino',
    createdAt: DateTime(2025, 12, 20),
  ),
  Shipping(
    productName: 'Zapatillas Nike',
    status: ShippingStatus.pending,
    description: null,
    courier: 'Andreani',
    createdAt: DateTime(2026, 1, 3),
  ),
  Shipping(
    productName: 'Teclado Mecánico',
    status: ShippingStatus.delivered,
    description: 'Recibido por: Juan',
    courier: 'Andreani',
    createdAt: DateTime(2025, 12, 15),
  ),
  Shipping(
    productName: 'Monitor Samsung 27"',
    status: ShippingStatus.inTransit,
    description: 'Salió del centro de distribución',
    courier: 'Andreani',
    createdAt: DateTime(2026, 1, 2),
  ),
  Shipping(
    productName: 'Auriculares Sony',
    status: ShippingStatus.pending,
    courier: 'Correo Argentino',
    createdAt: DateTime(2026, 1, 4),
  ),
];
