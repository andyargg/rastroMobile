import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SearchBarCard extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;

  const SearchBarCard({
    super.key,
    required this.onSearchChanged
  });

  @override
  State<SearchBarCard> createState() => _SearchBarCardState();
}


class _SearchBarCardState extends State<SearchBarCard> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onSearchChanged,
      decoration: InputDecoration(
        hintText: 'Buscar',
        hintStyle: TextStyle(
          color: Color(0xFFFFFFFF),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        prefixIcon: const Icon(
          LucideIcons.search,
          color: Color(0xFFFFFFFF),
          size: 25,
        ),
        suffixIcon: _controller.text.isNotEmpty
          ? IconButton(
            icon: const Icon(LucideIcons.x),
            color: Color(0xFFFFFFFF),
            onPressed: () {
              _controller.clear();
              widget.onSearchChanged('');
            },
          )
          : const Icon(
            LucideIcons.package,
            color: Color(0xFFFFFFFF),
          ),
        filled: true,
        fillColor: Color(0xFFC98643),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      )
    );
  }
}