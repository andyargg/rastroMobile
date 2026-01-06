import 'package:flutter/material.dart';
import 'package:rastro/models/shipping.dart';
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
    @override
    initState() {
        super.initState();
    }    
    @override
    dispose() {
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: Color(0xFFE3E2E2), 
          body: ShippingCardBuilder(shippings: widget.shippings)
        );
    }
}