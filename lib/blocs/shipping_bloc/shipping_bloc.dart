import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rastro/blocs/shipping_bloc/events/shipping_event.dart';
import 'package:rastro/blocs/shipping_bloc/states/shipping_state.dart';
import 'package:rastro/data/mock_data.dart';
import 'package:rastro/models/shipping.dart';
import 'package:rastro/models/shipping_filter.dart';
import 'package:rastro/utils/enums/statuses.dart';

class ShippingBloc extends Bloc<ShippingEvent, ShippingState> {
  ShippingBloc() : super(ShippingInitialState()) {
    on<LoadShippingEvent>(_onLoad);
    on<AddShipping>(_onAdd);
    on<SearchShippings>(_onSearch);
    on<ApplyFilter>(_onApplyFilter);
    on<ClearFilter>(_onClearFilter);
    on<EditShipping>(_onEdit);
    on<DeleteShipping>(_onDelete);
  }

  final List<Shipping> _allShippings = [];
  ShippingFilter _currentFilter = const ShippingFilter();
  String _searchQuery = '';

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

      emit(ShippingLoadedState(_applyAllFilters(), filter: _currentFilter));
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
    emit(ShippingLoadedState(_applyAllFilters(), filter: _currentFilter));
  }

  void _onSearch(
    SearchShippings event,
    Emitter<ShippingState> emit,
  ) {
    _searchQuery = event.query;
    emit(ShippingLoadedState(_applyAllFilters(), filter: _currentFilter));
  }

  void _onApplyFilter(
    ApplyFilter event,
    Emitter<ShippingState> emit,
  ) {
    _currentFilter = event.filter;
    emit(ShippingLoadedState(_applyAllFilters(), filter: _currentFilter));
  }

  void _onClearFilter(
    ClearFilter event,
    Emitter<ShippingState> emit,
  ) {
    _currentFilter = const ShippingFilter();
    _searchQuery = '';
    emit(ShippingLoadedState(_applyAllFilters(), filter: _currentFilter));
  }

  void _onEdit(
    EditShipping event,
    Emitter<ShippingState> emit,
  ) {
    final index = _allShippings.indexOf(event.original);
    if (index == -1) return;
    _allShippings[index] = event.updated;
    emit(ShippingLoadedState(_applyAllFilters(), filter: _currentFilter));
  }

  void _onDelete(
    DeleteShipping event,
    Emitter<ShippingState> emit,
  ) {
    _allShippings.remove(event.shipping);
    emit(ShippingLoadedState(_applyAllFilters(), filter: _currentFilter));
  }

  List<Shipping> _applyAllFilters() {
    var result = List<Shipping>.from(_allShippings);

    // status filter
    if (_currentFilter.statuses.isNotEmpty) {
      result = result
          .where((s) => _currentFilter.statuses.contains(s.status))
          .toList();
    }

    // courier filter
    if (_currentFilter.couriers.isNotEmpty) {
      result = result
          .where((s) => _currentFilter.couriers.contains(s.courier))
          .toList();
    }

    // search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((s) {
        return s.productName.toLowerCase().contains(query) ||
            s.courier.toLowerCase().contains(query);
      }).toList();
    }

    // date sort
    if (_currentFilter.sortByDateAsc) {
      result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    } else {
      result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return result;
  }

  Future<List<Shipping>> _fetchShippings() async {
    // todo: replace with api/db call
    return mockShippings;
  }
}
