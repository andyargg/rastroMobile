import 'package:flutter/material.dart';
import 'package:rastro/helpers/courier_assets.dart';
import 'package:rastro/models/shipping.dart';

class ShippingCardBuilder extends StatelessWidget {
  final List<Shipping> shippings;

  const ShippingCardBuilder({
    super.key,
    required this.shippings,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.5),
        child: ListView.builder(
            itemCount: shippings.length,
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
                        courierLogos[shipping.courier]!,
                        width: 40,
                        height: 40,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.local_shipping, size: 40, color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shipping.productName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4,),
                        Text(
                          shipping.courier,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ))
                  ],
                ),
              );
            },
        )
    );
  }
}