import 'package:equatable/equatable.dart';
import 'package:rastro/models/shipment.dart';
import 'package:rastro/models/shipment_filter.dart';

sealed class ShipmentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ShipmentInitial extends ShipmentState {}

class ShipmentLoading extends ShipmentState {}

class ShipmentLoaded extends ShipmentState {
  final List<Shipment> shipments;
  final ShipmentFilter filter;

  ShipmentLoaded(this.shipments, {this.filter = const ShipmentFilter()});

  @override
  List<Object?> get props => [shipments, filter];
}

class ShipmentError extends ShipmentState {
  final String message;

  ShipmentError(this.message);

  @override
  List<Object?> get props => [message];
}
