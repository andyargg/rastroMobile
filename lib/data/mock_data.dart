import 'package:rastro/models/shipping.dart';

final List<Shipping> mockShippings = [
  Shipping(
    productName: 'iPhone 15 Pro',
    status: 'En tránsito',
    description: 'Llega entre el 23 y 25 de diciembre',
    courier: 'Correo Argentino',
  ),
  Shipping(
    productName: 'Zapatillas Nike',
    status: 'En preparación',
    description: null,
    courier: 'Andreani',
  ),
  Shipping(
    productName: 'Teclado Mecánico',
    status: 'Entregado',
    description: 'Recibido por: Juan',
    courier: 'OCA',
  ),
  Shipping(
    productName: 'Monitor Samsung 27"',
    status: 'En camino',
    description: 'Salió del centro de distribución',
    courier: 'Andreani',
  ),
  Shipping(
    productName: 'Auriculares Sony',
    status: 'Pendiente de retiro',
    courier: 'Correo Argentino',
  ),
];
