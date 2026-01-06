import 'package:flutter/material.dart';
import 'package:rastro/models/shipping.dart';
import 'package:rastro/views/screens/home/widgets/shipping_card.dart';

class ShippingCardBuilder extends StatelessWidget {
  final List<Shipping> shippings;

  const ShippingCardBuilder({
    super.key,
    required this.shippings,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.5, vertical: 20),
      child: ListView.builder(
        itemCount: shippings.length,
        itemBuilder: (context, index) {
          final shipping = shippings[index];
          return ShippingCard(shipping: shipping);
        },
      ),
    );
  }
}