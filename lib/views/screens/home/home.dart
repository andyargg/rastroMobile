import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:rastro/data/mock_data.dart';
import 'package:rastro/models/shipping.dart';
import 'package:rastro/routes/app_router.dart';
import 'package:rastro/views/screens/home/widgets/footer_menu.dart';
import 'package:rastro/views/screens/home/widgets/search_bar_card.dart';
import 'package:rastro/views/screens/home/widgets/shipping_card_builder.dart';

@RoutePage()
class HomePage extends StatefulWidget {

    const HomePage({super.key});

    @override
    State<HomePage> createState() => _HomePage();

}

class _HomePage extends State<HomePage> {
    late List<Shipping> _filteredShippings;
    final List<Shipping> _shippings = mockShippings;

    @override
    initState() {
        super.initState();
        _filteredShippings = _shippings;
    }    
    @override
    dispose() {
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        final router = AutoRouter.of(context);
        return Scaffold(
          backgroundColor: Color(0xFFE3E2E2),
          body: SafeArea(
            child: Stack(
              children: [
                Column(
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
                FooterMenu(
                  onTapProfile: () => router.push(
                    const ProfileRoute()
                  ),
                ),
              ],
            ),
          )
        );
    }

    void _filterShippings(String query){
      setState(() {
        if (query.isEmpty) {
          _filteredShippings = _shippings;
        } else {
          final lowerQuery = query.toLowerCase();

          _filteredShippings = _shippings.where((shipping) {
            final productMatch = shipping.productName.toLowerCase().contains(lowerQuery);
            final courierMatch = shipping.courier.toLowerCase().contains(lowerQuery);

            return productMatch || courierMatch;
          }).toList();
        }
      });
    }
}