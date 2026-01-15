import 'package:flutter/material.dart';

// app logo for auth screens
class LogoWidget extends StatelessWidget {
  final double size;

  const LogoWidget({super.key, this.size = 80});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Image.asset(
        'assets/logo/logo.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
