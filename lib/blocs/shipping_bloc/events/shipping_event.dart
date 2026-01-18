part of '../shipping_event.dart';

sealed class ShippingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadShippingEvent extends ShippingEvent {
  final StackRouter router;

  LoadShippingEvent({
    required this.router,
  });

  @override
  List<Object?> get props => [router];
}

class AddShipping extends ShippingEvent {
  final String name;
  final String trackingCode;
  final String courier;

  AddShipping({
    required this.name,
    required this.trackingCode,
    required this.courier,
  });

  @override
  List<Object?> get props => [name, trackingCode, courier];
}

class FilterShippings extends ShippingEvent {
  final String query;

  FilterShippings(this.query);

  @override
  List<Object?> get props => [query];
}
