import 'package:equatable/equatable.dart';
import 'package:rastro/models/shipment.dart';
import 'package:rastro/models/shipment_filter.dart';
import 'package:rastro/services/tracking_service.dart';

sealed class ShipmentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ShipmentInitial extends ShipmentState {}

class ShipmentLoading extends ShipmentState {}

class ShipmentLoaded extends ShipmentState {
  final List<Shipment> shipments;
  final ShipmentFilter filter;
  final bool isAdding;

  ShipmentLoaded(this.shipments, {this.filter = const ShipmentFilter(), this.isAdding = false});

  @override
  List<Object?> get props => [shipments, filter, isAdding];
}

class ShipmentError extends ShipmentState {
  final String message;

  ShipmentError(this.message);

  @override
  List<Object?> get props => [message];
}

class ShipmentTracking extends ShipmentState {
  final Shipment shipment;

  ShipmentTracking(this.shipment);

  @override
  List<Object?> get props => [shipment];
}

class ShipmentTrackingResult extends ShipmentState {
  final TrackingResult result;
  final Shipment shipment;

  ShipmentTrackingResult(this.result, this.shipment);

  @override
  List<Object?> get props => [result, shipment];
}
