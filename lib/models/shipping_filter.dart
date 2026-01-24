import 'package:equatable/equatable.dart';
import 'package:rastro/utils/enums/statuses.dart';

// filter configuration for shipping list
class ShippingFilter extends Equatable {
  final Set<ShippingStatus> statuses;
  final Set<String> couriers;
  final bool sortByDateAsc;

  const ShippingFilter({
    this.statuses = const {},
    this.couriers = const {},
    this.sortByDateAsc = false,
  });

  ShippingFilter copyWith({
    Set<ShippingStatus>? statuses,
    Set<String>? couriers,
    bool? sortByDateAsc,
  }) {
    return ShippingFilter(
      statuses: statuses ?? this.statuses,
      couriers: couriers ?? this.couriers,
      sortByDateAsc: sortByDateAsc ?? this.sortByDateAsc,
    );
  }

  @override
  List<Object?> get props => [statuses, couriers, sortByDateAsc];
}
