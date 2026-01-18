import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rastro/blocs/shipping_bloc/events/shipping_event.dart';
import 'package:rastro/models/shipping.dart';


class ShippingBloc extends Bloc<ShippingEvent, ShippingState> {
  ShippingBloc() : super(ShippingInitialState()) {
    on<LoadShippingEvent>(_onLoad);
    on<AddShipping>(_onAdd);
    on<FilterShippings>(_onFilter);
  }

  final List<Shipping> _allShippings = [];

  Future<void> _onLoad(
    LoadShippingEvent event,
    Emitter<ShippingState> emit,
  ) async {
    emit(ShippingLoadingState());

    try {
      final shippings = await _fetchShippings();
      _allShippings
        ..clear()
        ..addAll(shippings);

      emit(ShippingLoadedState(List.from(_allShippings)));
    } catch (e) {
      emit(ShippingErrorState(e.toString()));
    }
  }

  void _onAdd(
    AddShipping event,
    Emitter<ShippingState> emit,
  ) {
    final shipping = Shipping(
      name: event.name,
      trackingCode: event.trackingCode,
      courier: event.courier,
    );

    _allShippings.add(shipping);
    emit(ShippingLoadedState(List.from(_allShippings)));
  }

  void _onFilter(
    FilterShippings event,
    Emitter<ShippingState> emit,
  ) {
    final filtered = _allShippings.where((s) {
      return s.name.contains(event.query) ||
          s.trackingCode.contains(event.query) ||
          s.courier.contains(event.query);
    }).toList();

    emit(ShippingLoadedState(filtered));
  }

  Future<List<Shipping>> _fetchShippings() async {
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }
}
