import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FooterMenu extends StatelessWidget {
  final VoidCallback onTapProfile;
  final VoidCallback onTapAdd;
  final VoidCallback onTapFilter;

  const FooterMenu({
    super.key,
    required this.onTapProfile,
    required this.onTapAdd,
    required this.onTapFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFC98643),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(201, 134, 67, 0.25),
              offset: Offset(0, 4),
              blurRadius: 4,
            ),
          ],
        ),
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(LucideIcons.slidersHorizontal),
              style: IconButton.styleFrom(
                backgroundColor: Color(0xFFFFFFFF),
                padding: EdgeInsets.all(20),
                foregroundColor: Color(0xFFC98643),
                iconSize: 28,
              ),
              onPressed: onTapFilter,
            ),
            IconButton(
              icon: Icon(LucideIcons.plus),
              style: IconButton.styleFrom(
                backgroundColor: Color(0xFF402E1B),
                padding: EdgeInsets.all(22),
                foregroundColor: Color(0xFFC98643),
                iconSize: 32,
              ),
              onPressed: onTapAdd,
            ),
            IconButton(
              icon: Icon(LucideIcons.user),
              style: IconButton.styleFrom(
                backgroundColor: Color(0xFFFFFFFF),
                padding: EdgeInsets.all(20),
                foregroundColor: Color(0xFFC98643),
                iconSize: 28,
              ),
              onPressed: onTapProfile,
            ),
          ],
        ),
      ),
    );
  }
}
