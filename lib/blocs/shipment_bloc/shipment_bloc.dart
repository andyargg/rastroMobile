import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rastro/blocs/shipment_bloc/events/shipment_event.dart';
import 'package:rastro/blocs/shipment_bloc/states/shipment_state.dart';
import 'package:rastro/models/shipment.dart';
import 'package:rastro/models/shipment_filter.dart';
import 'package:rastro/services/shipment_service.dart';
import 'package:rastro/services/tracking_service.dart';

class ShipmentBloc extends Bloc<ShipmentEvent, ShipmentState> {
  final ShipmentService _service;
  final TrackingService _trackingService;

  ShipmentBloc({ShipmentService? service, TrackingService? trackingService})
      : _service = service ?? ShipmentService(),
        _trackingService = trackingService ?? TrackingService(),
        super(ShipmentInitial()) {
    on<LoadShipments>(_onLoad);
    on<AddShipment>(_onAdd);
    on<SearchShipments>(_onSearch);
    on<ApplyShipmentFilter>(_onApplyFilter);
    on<ClearShipmentFilter>(_onClearFilter);
    on<EditShipment>(_onEdit);
    on<DeleteShipment>(_onDelete);
    on<TrackShipment>(_onTrack);
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
      // track shipment first to get real status and dates
      String status = event.status;
      DateTime entryDate = DateTime.now();
      DateTime? exitDate;

      try {
        final trackingResult = await _trackingService.track(
          trackingNumber: event.trackingNumber,
          courier: _courierToSlug(event.courier),
        );

        if (trackingResult.success && trackingResult.events.isNotEmpty) {
          status = trackingResult.status;

          // entry_date = oldest event (last in list)
          final oldestEvent = trackingResult.events.last;
          entryDate = _parseDate(oldestEvent.date) ?? DateTime.now();

          // exit_date = newest event date if status is "Entregado"
          if (status.toLowerCase() == 'entregado') {
            final newestEvent = trackingResult.events.first;
            exitDate = _parseDate(newestEvent.date);
          }
        }
      } catch (_) {
        // tracking failed, use defaults
      }

      final shipment = await _service.create(
        name: event.name,
        trackingNumber: event.trackingNumber,
        courier: event.courier,
        status: status,
        entryDate: entryDate,
        exitDate: exitDate,
      );
      _allShipments.insert(0, shipment);
      emit(ShipmentLoaded(_applyAllFilters(), filter: _currentFilter));
    } catch (e) {
      emit(ShipmentError(e.toString()));
    }
  }

  // convert courier display name to API slug
  String _courierToSlug(String courier) {
    const map = {
      'Correo Argentino': 'correo-argentino',
      'Andreani': 'andreani',
      'OCA': 'oca',
    };
    return map[courier] ?? courier.toLowerCase().replaceAll(' ', '-');
  }

  // parse date from "dd-MM-yyyy" format
  DateTime? _parseDate(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]), // year
          int.parse(parts[1]), // month
          int.parse(parts[0]), // day
        );
      }
    } catch (_) {}
    return null;
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

  Future<void> _onTrack(
    TrackShipment event,
    Emitter<ShipmentState> emit,
  ) async {
    emit(ShipmentTracking(event.shipment));

    try {
      final result = await _trackingService.track(
        trackingNumber: event.shipment.trackingNumber,
        courier: _courierToSlug(event.shipment.courier),
      );

      if (result.success && result.status.isNotEmpty) {
        final updated = event.shipment.copyWith(status: result.status);
        await _service.update(updated);

        final index = _allShipments.indexWhere((s) => s.id == updated.id);
        if (index != -1) {
          _allShipments[index] = updated;
        }

        emit(ShipmentTrackingResult(result, updated));
      } else {
        emit(ShipmentTrackingResult(result, event.shipment));
      }
    } catch (e) {
      emit(ShipmentError(e.toString()));
    }
  }
}
