import 'package:flutter/material.dart';
import 'package:rastro/models/shipping.dart';
import 'package:rastro/views/screens/home/widgets/search_bar_card.dart';
import 'package:rastro/views/screens/home/widgets/shipping_card_builder.dart';

class HomePage extends StatefulWidget {

    final List<Shipping> shippings;

    const HomePage({
        super.key,
        required this.shippings,
    });
    @override
    State<HomePage> createState() => _HomePage();
    
}

class _HomePage extends State<HomePage> {
    late List<Shipping> _filteredShippings;

    @override
    initState() {
        super.initState();
        _filteredShippings = widget.shippings;
    }    
    @override
    dispose() {
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: Color(0xFFE3E2E2),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.5, 56, 12.5, 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFC98643),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: SearchBarCard(
                      onSearchChanged: _filterShippings,
                    ),
                  ),
                ),
                Expanded(
                  child: ShippingCardBuilder(shippings: _filteredShippings)
                ),
              ],
            ),
          )
        );
    }

    void _filterShippings(String query){
      setState(() {
        if (query.isEmpty) {
          _filteredShippings = widget.shippings;
        } else {
          final lowerQuery = query.toLowerCase();

          _filteredShippings = widget.shippings.where((shipping) {
            final productMatch = shipping.productName.toLowerCase().contains(lowerQuery);
            final courierMatch = shipping.courier.toLowerCase().contains(lowerQuery);

            return productMatch || courierMatch;
          }).toList();
        }
      });
    }
}