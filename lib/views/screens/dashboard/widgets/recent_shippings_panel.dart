import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rastro/models/shipment.dart';
import 'package:rastro/routes/app_router.dart';
import 'package:rastro/utils/styles/app_colors.dart';

class RecentShippingsPanel extends StatelessWidget {
  final List<Shipment> recentShipments;

  const RecentShippingsPanel({super.key, required this.recentShipments});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Envios recientes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF402E1B),
              ),
            ),
            const SizedBox(height: 12),
            ...recentShipments.map((s) => _buildShipmentRow(s)),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.router.push(const HomeRoute()),
                child: const Text(
                  'Ver todos',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShipmentRow(Shipment s) {
    final dateStr = DateFormat('dd/MM').format(s.entryDate);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: s.statusColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: s.statusTextColor,
                width: 1.5,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${s.courier} · $dateStr',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: s.statusColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              s.status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: s.statusTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
