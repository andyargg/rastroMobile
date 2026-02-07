import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rastro/utils/enums/statuses.dart';
import 'package:rastro/views/screens/dashboard/widgets/stat_card.dart';

class StatusSummaryRow extends StatelessWidget {
  final int total;
  final int delivered;
  final int inTransit;
  final int pending;

  const StatusSummaryRow({
    super.key,
    required this.total,
    required this.delivered,
    required this.inTransit,
    required this.pending,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth >= 600
            ? (constraints.maxWidth - 24) / 4
            : (constraints.maxWidth - 8) / 2;

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            SizedBox(
              width: cardWidth,
              child: StatCard(
                label: 'Total',
                count: total,
                color: const Color(0xFFC98643).withValues(alpha: 0.15),
                textColor: const Color(0xFF402E1B),
                icon: LucideIcons.package,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: StatCard(
                label: 'Entregados',
                count: delivered,
                color: ShippingStatus.delivered.getColor(),
                textColor: ShippingStatus.delivered.getTextColor(),
                icon: LucideIcons.checkCircle2,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: StatCard(
                label: 'En tránsito',
                count: inTransit,
                color: ShippingStatus.inTransit.getColor(),
                textColor: ShippingStatus.inTransit.getTextColor(),
                icon: LucideIcons.truck,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: StatCard(
                label: 'Pendientes',
                count: pending,
                color: ShippingStatus.pending.getColor(),
                textColor: ShippingStatus.pending.getTextColor(),
                icon: LucideIcons.clock,
              ),
            ),
          ],
        );
      },
    );
  }
}
