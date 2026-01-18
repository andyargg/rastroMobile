import 'package:equatable/equatable.dart';

sealed class ShippingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadShippingEvent extends ShippingEvent {}

class AddShipping extends ShippingEvent {
  final String productName;
  final String courier;
  final String? description;

  AddShipping({
    required this.productName,
    required this.courier,
    this.description,
  });

  @override
  List<Object?> get props => [productName, courier, description];
}

class FilterShippings extends ShippingEvent {
  final String query;

  FilterShippings(this.query);

  @override
  List<Object?> get props => [query];
}
