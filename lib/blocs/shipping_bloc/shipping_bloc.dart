import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rastro/blocs/shipping_bloc/events/shipping_event.dart';
import 'package:rastro/blocs/shipping_bloc/states/shipping_state.dart';
import 'package:rastro/models/shipping.dart';
import 'package:rastro/utils/enums/statuses.dart';

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
      productName: event.productName,
      courier: event.courier,
      description: event.description,
      status: ShippingStatus.pending,
      createdAt: DateTime.now(),
    );

    _allShippings.add(shipping);
    emit(ShippingLoadedState(List.from(_allShippings)));
  }

  void _onFilter(
    FilterShippings event,
    Emitter<ShippingState> emit,
  ) {
    if (event.query.isEmpty) {
      emit(ShippingLoadedState(List.from(_allShippings)));
      return;
    }

    final query = event.query.toLowerCase();
    final filtered = _allShippings.where((s) {
      return s.productName.toLowerCase().contains(query) ||
          s.courier.toLowerCase().contains(query);
    }).toList();

    emit(ShippingLoadedState(filtered));
  }

  Future<List<Shipping>> _fetchShippings() async {
    // todo: fetch from api/db
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }
}
