part of 'shipping_state.dart';

sealed class ShippingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ShippingInitialState extends ShippingState {}

class ShippingLoadingState extends ShippingState {}

class ShippingLoadedState extends ShippingState {
  final List<Shipping> shippings;

  ShippingLoadedState(this.shippings);

  @override
  List<Object?> get props => [shippings];
}

class ShippingErrorState extends ShippingState {
  final String message;

  ShippingErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
