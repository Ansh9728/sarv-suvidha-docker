import 'package:flutter/material.dart';

class MobileField extends StatelessWidget {
  final void Function(String) onSaved;
  const MobileField({super.key, required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your mobile number';
        }
        return null;
      },
      onChanged: (String? value) {
        onSaved(value!);
      },
      decoration: InputDecoration(
        labelText: 'Mobile Number',
        labelStyle: const TextStyle(
          fontSize: 16, // Consistent font size with other text elements
          color: Color(0xFF313256), // Use primary color
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Consistent border radius
          borderSide: const BorderSide(
            color: Colors.grey, 
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF313256), // Use primary color
            width: 2.0, 
          ),
        ),
      ),
    );
  }
}