import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Widget? suffixIcon; // Add this line

  const CustomSearchBar({
    super.key,
    required this.hintText,
    required this.controller,
    this.onChanged,
    this.suffixIcon, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: suffixIcon, // Add this line
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
