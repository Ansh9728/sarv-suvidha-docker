import 'package:flutter/material.dart';

class MiddleNameField extends StatefulWidget {
  final void Function(String) onSaved;
  final String? initialValue;

  const MiddleNameField({super.key, required this.onSaved, this.initialValue});

  @override
  State<MiddleNameField> createState() => _MiddleNameFieldState();
}

class _MiddleNameFieldState extends State<MiddleNameField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void didUpdateWidget(covariant MiddleNameField oldWidget) {
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
        labelText: 'Middle Name',
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
      onSaved: (String? value) {
        if (value != null) {
          widget.onSaved(value);
        }
      },
    );
  }
}
