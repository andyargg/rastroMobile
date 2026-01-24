import 'package:equatable/equatable.dart';
import 'package:rastro/models/shipping.dart';
import 'package:rastro/models/shipping_filter.dart';

sealed class ShippingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ShippingInitialState extends ShippingState {}

class ShippingLoadingState extends ShippingState {}

class ShippingLoadedState extends ShippingState {
  final List<Shipping> shippings;
  final ShippingFilter filter;

  ShippingLoadedState(this.shippings, {this.filter = const ShippingFilter()});

  @override
  List<Object?> get props => [shippings, filter];
}

class ShippingErrorState extends ShippingState {
  final String message;

  ShippingErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
