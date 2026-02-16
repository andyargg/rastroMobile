import 'package:flutter/material.dart';
import 'package:rastro/models/shipment.dart';
import 'package:rastro/views/screens/home/widgets/shipping_card.dart';

class ShippingCardBuilder extends StatelessWidget {
  final List<Shipment> shipments;
  final bool isAdding;

  const ShippingCardBuilder({
    super.key,
    required this.shipments,
    this.isAdding = false,
  });

  @override
  Widget build(BuildContext context) {
    final totalCount = shipments.length + (isAdding ? 1 : 0);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.5, vertical: 20),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 150),
        itemCount: totalCount,
        itemBuilder: (context, index) {
          if (isAdding && index == 0) {
            return const _LoadingCard();
          }
          final shipment = shipments[isAdding ? index - 1 : index];
          return ShippingCard(shipment: shipment);
        },
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 12),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: const AspectRatio(
        aspectRatio: 4 / 1,
        child: Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
        ),
      ),
    );
  }
}
