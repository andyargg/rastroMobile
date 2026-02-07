import 'package:flutter/material.dart';
import 'package:rastro/helpers/courier_assets.dart';
import 'package:rastro/models/shipping.dart';
import 'package:rastro/utils/styles/app_colors.dart';

class CourierBreakdown extends StatelessWidget {
  final List<Shipping> shippings;

  const CourierBreakdown({super.key, required this.shippings});

  @override
  Widget build(BuildContext context) {
    final total = shippings.length;
    final courierColors = [
      AppColors.primary,
      const Color(0xFF402E1B),
      const Color(0xFF7B7676),
    ];

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
              'Por empresa',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF402E1B),
              ),
            ),
            const SizedBox(height: 16),
            ...courierLogos.entries.toList().asMap().entries.map((entry) {
              final idx = entry.key;
              final courier = entry.value;
              final name = courier.key;
              final logoPath = courier.value;
              final count =
                  shippings.where((s) => s.courier == name).length;
              final fraction = total > 0 ? count / total : 0.0;
              final color = courierColors[idx % courierColors.length];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        logoPath,
                        width: 24,
                        height: 24,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 110,
                      child: Text(
                        name,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 8,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: fraction,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '$count',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
