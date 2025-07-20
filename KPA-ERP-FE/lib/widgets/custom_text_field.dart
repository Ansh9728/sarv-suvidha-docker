import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String value;
  final TextEditingController? controller;
  final TextInputType keyboardType;  // Add this parameter

  const CustomTextField({
    super.key,
    required this.label,
    required this.value,
    this.controller,
    this.keyboardType = TextInputType.text, // Default is TextInputType.text
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller ?? TextEditingController(text: value),
      keyboardType: keyboardType,  // Pass the keyboardType to TextField
      decoration: InputDecoration(
        labelText: label,
        hintText: value,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
