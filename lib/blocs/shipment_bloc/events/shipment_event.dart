import 'package:equatable/equatable.dart';
import 'package:rastro/models/shipment.dart';
import 'package:rastro/models/shipment_filter.dart';

sealed class ShipmentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadShipments extends ShipmentEvent {}

class AddShipment extends ShipmentEvent {
  final String name;
  final String courier;
  final String? description;
  final String status;

  AddShipment({
    required this.name,
    required this.courier,
    this.description,
    this.status = 'Pendiente',
  });

  @override
  List<Object?> get props => [name, courier, description, status];
}

class SearchShipments extends ShipmentEvent {
  final String query;

  SearchShipments(this.query);

  @override
  List<Object?> get props => [query];
}

class ApplyShipmentFilter extends ShipmentEvent {
  final ShipmentFilter filter;

  ApplyShipmentFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

class ClearShipmentFilter extends ShipmentEvent {}

class EditShipment extends ShipmentEvent {
  final Shipment updated;

  EditShipment(this.updated);

  @override
  List<Object?> get props => [updated];
}

class DeleteShipment extends ShipmentEvent {
  final String id;

  DeleteShipment(this.id);

  @override
  List<Object?> get props => [id];
}
