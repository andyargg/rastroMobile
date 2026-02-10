import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rastro/blocs/shipment_bloc/events/shipment_event.dart';
import 'package:rastro/blocs/shipment_bloc/states/shipment_state.dart';
import 'package:rastro/models/shipment.dart';
import 'package:rastro/models/shipment_filter.dart';
import 'package:rastro/services/shipment_service.dart';

class ShipmentBloc extends Bloc<ShipmentEvent, ShipmentState> {
  final ShipmentService _service;

  ShipmentBloc({ShipmentService? service})
      : _service = service ?? ShipmentService(),
        super(ShipmentInitial()) {
    on<LoadShipments>(_onLoad);
    on<AddShipment>(_onAdd);
    on<SearchShipments>(_onSearch);
    on<ApplyShipmentFilter>(_onApplyFilter);
    on<ClearShipmentFilter>(_onClearFilter);
    on<EditShipment>(_onEdit);
    on<DeleteShipment>(_onDelete);
  }

  List<Shipment> _allShipments = [];
  ShipmentFilter _currentFilter = const ShipmentFilter();
  String _searchQuery = '';

  Future<void> _onLoad(
    LoadShipments event,
    Emitter<ShipmentState> emit,
  ) async {
    emit(ShipmentLoading());

    try {
      final shipments = await _service.getAll();
      _allShipments = shipments;
      emit(ShipmentLoaded(_applyAllFilters(), filter: _currentFilter));
    } catch (e) {
      emit(ShipmentError(e.toString()));
    }
  }

  Future<void> _onAdd(
    AddShipment event,
    Emitter<ShipmentState> emit,
  ) async {
    try {
      final shipment = await _service.create(
        name: event.name,
        courier: event.courier,
        description: event.description,
        status: event.status,
      );
      _allShipments.insert(0, shipment);
      emit(ShipmentLoaded(_applyAllFilters(), filter: _currentFilter));
    } catch (e) {
      emit(ShipmentError(e.toString()));
    }
  }

  void _onSearch(
    SearchShipments event,
    Emitter<ShipmentState> emit,
  ) {
    _searchQuery = event.query;
    emit(ShipmentLoaded(_applyAllFilters(), filter: _currentFilter));
  }

  void _onApplyFilter(
    ApplyShipmentFilter event,
    Emitter<ShipmentState> emit,
  ) {
    _currentFilter = event.filter;
    emit(ShipmentLoaded(_applyAllFilters(), filter: _currentFilter));
  }

  void _onClearFilter(
    ClearShipmentFilter event,
    Emitter<ShipmentState> emit,
  ) {
    _currentFilter = const ShipmentFilter();
    _searchQuery = '';
    emit(ShipmentLoaded(_applyAllFilters(), filter: _currentFilter));
  }

  Future<void> _onEdit(
    EditShipment event,
    Emitter<ShipmentState> emit,
  ) async {
    try {
      final updated = await _service.update(event.updated);
      final index = _allShipments.indexWhere((s) => s.id == updated.id);
      if (index != -1) {
        _allShipments[index] = updated;
      }
      emit(ShipmentLoaded(_applyAllFilters(), filter: _currentFilter));
    } catch (e) {
      emit(ShipmentError(e.toString()));
    }
  }

  Future<void> _onDelete(
    DeleteShipment event,
    Emitter<ShipmentState> emit,
  ) async {
    try {
      await _service.delete(event.id);
      _allShipments.removeWhere((s) => s.id == event.id);
      emit(ShipmentLoaded(_applyAllFilters(), filter: _currentFilter));
    } catch (e) {
      emit(ShipmentError(e.toString()));
    }
  }

  List<Shipment> _applyAllFilters() {
    var result = List<Shipment>.from(_allShipments);

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
        return s.name.toLowerCase().contains(query) ||
            s.courier.toLowerCase().contains(query);
      }).toList();
    }

    // date sort
    if (_currentFilter.sortByDateAsc) {
      result.sort((a, b) => a.entryDate.compareTo(b.entryDate));
    } else {
      result.sort((a, b) => b.entryDate.compareTo(a.entryDate));
    }

    return result;
  }
}
