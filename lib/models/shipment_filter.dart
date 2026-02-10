import 'package:equatable/equatable.dart';

class ShipmentFilter extends Equatable {
  final Set<String> statuses;
  final Set<String> couriers;
  final bool sortByDateAsc;

  const ShipmentFilter({
    this.statuses = const {},
    this.couriers = const {},
    this.sortByDateAsc = false,
  });

  ShipmentFilter copyWith({
    Set<String>? statuses,
    Set<String>? couriers,
    bool? sortByDateAsc,
  }) {
    return ShipmentFilter(
      statuses: statuses ?? this.statuses,
      couriers: couriers ?? this.couriers,
      sortByDateAsc: sortByDateAsc ?? this.sortByDateAsc,
    );
  }

  @override
  List<Object?> get props => [statuses, couriers, sortByDateAsc];
}
