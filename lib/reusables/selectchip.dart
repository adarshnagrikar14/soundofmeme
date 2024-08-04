import 'package:flutter/material.dart';

class SelectChip extends StatefulWidget {
  final List<ChipItem> items;
  final Function(ChipItem) onItemSelected;

  const SelectChip({
    super.key,
    required this.items,
    required this.onItemSelected,
  });

  @override
  _SelectChipState createState() => _SelectChipState();
}

class _SelectChipState extends State<SelectChip> {
  ChipItem? _selectedItem;

  @override
  Widget build(BuildContext context) {
    Color blueColor = const Color.fromARGB(255, 30, 45, 80);

    return Wrap(
      spacing: 8.0,
      children: widget.items.map((item) {
        return ChoiceChip(
          avatar: Icon(
            item.imageUrl,
            size: 24.0,
            color: Colors.white60,
          ),
          label: Text(
            "\t${item.title}",
          ),
          padding: const EdgeInsets.all(10.0),
          labelPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
          selected: false,
          onSelected: (selected) {
            setState(() {
              _selectedItem = selected ? item : null;
            });
            widget.onItemSelected(_selectedItem!);
          },
          selectedColor: Colors.white10,
          backgroundColor: blueColor,
          labelStyle: const TextStyle(
            color: Colors.white70,
          ),
        );
      }).toList(),
    );
  }
}

class ChipItem {
  final IconData imageUrl;
  final String title;

  ChipItem({
    required this.imageUrl,
    required this.title,
  });
}
