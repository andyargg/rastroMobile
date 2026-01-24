import 'package:equatable/equatable.dart';
import 'package:rastro/models/shipping.dart';
import 'package:rastro/models/shipping_filter.dart';

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

class SearchShippings extends ShippingEvent {
  final String query;

  SearchShippings(this.query);

  @override
  List<Object?> get props => [query];
}

class ApplyFilter extends ShippingEvent {
  final ShippingFilter filter;

  ApplyFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

class ClearFilter extends ShippingEvent {}

class EditShipping extends ShippingEvent {
  final Shipping original;
  final Shipping updated;

  EditShipping({required this.original, required this.updated});

  @override
  List<Object?> get props => [original, updated];
}

class DeleteShipping extends ShippingEvent {
  final Shipping shipping;

  DeleteShipping(this.shipping);

  @override
  List<Object?> get props => [shipping];
}
