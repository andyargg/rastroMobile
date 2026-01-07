import 'package:flutter/material.dart';

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
          color: Color(0xFFFFFFFF)
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: Color(0xFFFFFFFF),
        ),
        suffixIcon: _controller.text.isNotEmpty
          ? IconButton(
            icon: const Icon(Icons.clear),
            color: Color(0xFFFFFFFF),
            onPressed: () {
              _controller.clear();
              widget.onSearchChanged('');
            },
          )
          : const Icon(
            Icons.inventory_2,
            color: Color(0xFFFFFFFF),
          ),
        filled: true,
        fillColor: Color(0xFFC98643),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      )
    );
  }
}