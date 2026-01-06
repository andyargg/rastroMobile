import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rastro/helpers/courier_assets.dart';
import 'package:rastro/models/shipping.dart';
import 'package:rastro/utils/enums/statuses.dart';

class ShippingCard extends StatelessWidget {
  final Shipping shipping;

  const ShippingCard({
    super.key,
    required this.shipping,
  });

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
            Expanded(
              flex: 15,
              child: ClipRRect(
                borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
                child: Image.asset(
                  courierLogos[shipping.courier]!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.local_shipping, size: 40, color: Colors.black),
                ),
              ),
            ),
            SizedBox(width: 10,),
            Expanded(
              flex: 85,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          shipping.productName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF000000),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          shipping.courier,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy').format(shipping.createdAt),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF999999),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: shipping.status.getColor(),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      shipping.status.getLabel(),
                      style: TextStyle(
                        color: shipping.status.getTextColor(),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
