import 'package:flutter/material.dart';

class LastNameField extends StatefulWidget {
  final void Function(String) onSaved;
  final String? initialValue;

  const LastNameField({super.key, required this.onSaved, this.initialValue});

  @override
  State<LastNameField> createState() => _LastNameFieldState();
}

class _LastNameFieldState extends State<LastNameField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void didUpdateWidget(covariant LastNameField oldWidget) {
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
        labelText: 'Last Name *',
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
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your last name';
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
