import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final void Function(String) onSaved;
  final void Function(String)? onChanged; // Added optional onChanged

  const PasswordField({
    Key? key, 
    required this.onSaved,
    this.onChanged, // Optional parameter
  }) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: 'Password *',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.black38,
            width: 2.0,
          ),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
      onSaved: (String? value) {
        widget.onSaved(value!);
      },
      onChanged: (String value) {
        // Call onChanged if provided
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
    );
  }
}