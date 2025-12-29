import 'package:flutter/material.dart';
import 'package:rastro/helpers/courier_assets.dart';
import 'package:rastro/models/shipping.dart';

class ShippingCard  extends StatelessWidget {
  final List<Shipping> shippings;

  const ShippingCard({
    super.key,
    required this.shippings,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.5),
            child: ListView.builder(
                itemCount: shippings.length + 1,
                itemBuilder: (context, index) {
                  final shipping = shippings[index];
                  return Card(
                    elevation: 4,
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    color: Colors.white,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            courierLogos[shipping.courier]!
                          )
                        )
                      ],
                    ),
                  );
                },
            )
        );
  }
}