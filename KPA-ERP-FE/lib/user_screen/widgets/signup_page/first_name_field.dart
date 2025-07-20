import 'package:flutter/material.dart';

class FirstNameField extends StatefulWidget {
  final void Function(String) onSaved;
  final String? initialValue;

  const FirstNameField({super.key, required this.onSaved, this.initialValue});

  @override
  State<FirstNameField> createState() => _FirstNameFieldState();
}

class _FirstNameFieldState extends State<FirstNameField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void didUpdateWidget(covariant FirstNameField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _controller.text = widget.initialValue ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'First Name *',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.person, color: Colors.grey),
          onPressed: () {},
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your first name';
        }
        return null;
      },
      onSaved: (String? value) {
        if (value != null) {
          widget.onSaved(value);
        }
      },
    );
  }
}
