import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rastro/blocs/shipment_bloc/events/shipment_event.dart';
import 'package:rastro/blocs/shipment_bloc/shipment_bloc.dart';
import 'package:rastro/blocs/shipment_bloc/states/shipment_state.dart';
import 'package:rastro/helpers/courier_assets.dart';
import 'package:rastro/models/shipment_filter.dart';
import 'package:rastro/utils/styles/app_colors.dart';
import 'package:rastro/utils/styles/app_styles.dart';

class ModalFilter extends StatefulWidget {
  const ModalFilter({super.key});

  @override
  State<ModalFilter> createState() => _ModalFilterState();
}

class _ModalFilterState extends State<ModalFilter> {
  late Set<String> _statuses;
  late Set<String> _couriers;
  late bool _sortByDateAsc;

  static const _statusOptions = ['Pendiente', 'En tránsito', 'Entregado'];

  @override
  void initState() {
    super.initState();
    final state = context.read<ShipmentBloc>().state;
    final current = state is ShipmentLoaded
        ? state.filter
        : const ShipmentFilter();
    _statuses = Set.from(current.statuses);
    _couriers = Set.from(current.couriers);
    _sortByDateAsc = current.sortByDateAsc;
  }

  void _toggleStatus(String status) {
    setState(() {
      if (_statuses.contains(status)) {
        _statuses.remove(status);
      } else {
        _statuses
          ..clear()
          ..add(status);
      }
    });
  }

  void _toggleCourier(String courier) {
    setState(() {
      if (_couriers.contains(courier)) {
        _couriers.remove(courier);
      } else {
        _couriers
          ..clear()
          ..add(courier);
      }
    });
  }

  void _clearAll() {
    setState(() {
      _statuses.clear();
      _couriers.clear();
      _sortByDateAsc = false;
    });
  }

  void _apply() {
    context.read<ShipmentBloc>().add(ApplyShipmentFilter(ShipmentFilter(
      statuses: Set.from(_statuses),
      couriers: Set.from(_couriers),
      sortByDateAsc: _sortByDateAsc,
    )));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.tertiary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Center(
            child: Text('Filtrar envíos', style: AppTextStyles.title),
          ),
          const SizedBox(height: 24),

          Text('Estado', style: AppTextStyles.label),
          const SizedBox(height: 10),
          _buildStatusChips(),
          const SizedBox(height: 20),

          Text('Empresa', style: AppTextStyles.label),
          const SizedBox(height: 10),
          _buildCourierChips(),
          const SizedBox(height: 20),

          Text('Fecha', style: AppTextStyles.label),
          const SizedBox(height: 10),
          _buildDateSort(),
          const SizedBox(height: 24),

          _buildActions(),
        ],
        ),
      ),
    );
  }

  Widget _buildStatusChips() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _statusOptions.map((status) {
        final isSelected = _statuses.contains(status);

        return GestureDetector(
          onTap: () => _toggleStatus(status),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.inputFill,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.divider,
                width: 1.5,
              ),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.textDark : AppColors.tertiary,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCourierChips() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: courierLogos.keys.map((courier) {
        final isSelected = _couriers.contains(courier);
        return GestureDetector(
          onTap: () => _toggleCourier(courier),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.inputFill,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.divider,
                width: 1.5,
              ),
            ),
            child: Text(
              courier,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.textDark : AppColors.tertiary,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDateSort() {
    return GestureDetector(
      onTap: () => setState(() => _sortByDateAsc = !_sortByDateAsc),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: _sortByDateAsc
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.inputFill,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _sortByDateAsc ? AppColors.primary : AppColors.divider,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.arrowUpDown,
              size: 16,
              color: _sortByDateAsc ? AppColors.textDark : AppColors.tertiary,
            ),
            const SizedBox(width: 8),
            Text(
              'Más antiguo primero',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _sortByDateAsc ? AppColors.textDark : AppColors.tertiary,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 52,
            child: OutlinedButton(
              onPressed: _clearAll,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'LIMPIAR',
                style: AppTextStyles.button.copyWith(color: AppColors.primary),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _apply,
              style: AppButtonStyles.primary,
              child: const Text('APLICAR', style: AppTextStyles.button),
            ),
          ),
        ),
      ],
    );
  }
}
