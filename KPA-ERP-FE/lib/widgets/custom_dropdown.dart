import 'package:flutter/material.dart';

class CustomDropdownWithOther extends StatefulWidget {
  final String label;
  final List<String> items;
  final bool enableColoredDropdown;

  const CustomDropdownWithOther({
    super.key,
    required this.label,
    required this.items,
    this.enableColoredDropdown = false,
  });

  @override
  State<CustomDropdownWithOther> createState() => _CustomDropdownWithOtherState();
}

class _CustomDropdownWithOtherState extends State<CustomDropdownWithOther> {
  String? selectedValue;
  final TextEditingController otherController = TextEditingController();
  bool showOtherField = false;

  @override
  void initState() {
    super.initState();

    final dropdownItems = [...widget.items, 'Other'];

    // ✅ Ensure selectedValue is in dropdownItems list
    selectedValue = dropdownItems.contains(widget.items.first)
        ? widget.items.first
        : dropdownItems.first;
  }

  Color _getTextColor(String item) {
    if (!widget.enableColoredDropdown) return Colors.black;

    switch (item.toUpperCase()) {
      case 'GOOD':
        return Colors.green;
      case 'WORN OUT':
        return Colors.orange;
      case 'DAMAGED':
        return Colors.red;
      case 'CRACKED':
        return Colors.red;
      case 'BENT':
        return Colors.orange;
      case 'WORN':
        return Colors.orange;
      case 'MISALIGN':
        return Colors.orange;
      case 'CORRODED':
        return Colors.orange;
      case 'OTHER':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dropdownItems = [...widget.items.toSet(), 'Other']; // ✅ remove duplicates

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: widget.label,
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
          value: dropdownItems.contains(selectedValue) ? selectedValue : null, // ✅ safe fallback
          dropdownColor: widget.enableColoredDropdown ? Colors.black : null,
          items: dropdownItems.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  color: _getTextColor(item),
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedValue = value;
              showOtherField = value == 'Other';
              if (!showOtherField) otherController.clear();
            });
          },
        ),
        if (showOtherField)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: TextField(
              controller: otherController,
              decoration: InputDecoration(
                labelText: "Custom ${widget.label}",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
