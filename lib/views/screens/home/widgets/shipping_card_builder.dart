import 'package:flutter/material.dart';
import 'package:rastro/models/shipment.dart';
import 'package:rastro/views/screens/home/widgets/shipping_card.dart';

class ShippingCardBuilder extends StatelessWidget {
  final List<Shipment> shipments;

  const ShippingCardBuilder({
    super.key,
    required this.shipments,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.5, vertical: 20),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 150),
        itemCount: shipments.length,
        itemBuilder: (context, index) {
          final shipment = shipments[index];
          return ShippingCard(shipment: shipment);
        },
      ),
    );
  }
}
