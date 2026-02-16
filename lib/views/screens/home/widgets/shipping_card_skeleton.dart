import 'package:flutter/material.dart';
import 'package:rastro/views/widgets/shimmer_box.dart';

class ShippingCardSkeleton extends StatelessWidget {
  const ShippingCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 12),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: AspectRatio(
        aspectRatio: 4 / 1,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Courier image placeholder
            const Expanded(
              flex: 15,
              child: ShimmerBox(
                width: double.infinity,
                height: double.infinity,
                borderRadius: 0,
              ),
            ),
            const SizedBox(width: 10),
            // Content area
            Expanded(
              flex: 85,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          // Name
                          ShimmerBox(width: 120, height: 14),
                          // Courier
                          ShimmerBox(width: 80, height: 12),
                          // Dates
                          ShimmerBox(width: 160, height: 10),
                        ],
                      ),
                    ),
                  ),
                  // Status badge placeholder
                  const ShimmerBox(
                    width: 70,
                    height: 32,
                    borderRadius: 0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a scrollable list of skeleton cards for loading state.
  static Widget list({int count = 6}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.5, vertical: 20),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 150),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: count,
        itemBuilder: (context, index) => const ShippingCardSkeleton(),
      ),
    );
  }
}
