import 'package:flutter/material.dart';

class EmpNumberField extends StatefulWidget {
  final void Function(String) onSaved;
  final String userType;
  final List<String> empNumberList; // Pass the empNumberList to this widget
  final String? initialValue; // Optional initial value

  const EmpNumberField({
    super.key,
    required this.onSaved,
    required this.userType,
    required this.empNumberList, // Require empNumberList in the constructor
    this.initialValue, // Add optional initial value
  });

  @override
  _EmpNumberFieldState createState() => _EmpNumberFieldState();
}

class _EmpNumberFieldState extends State<EmpNumberField> {
  late TextEditingController _controller;
  String? _empNumber;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
    _empNumber = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant EmpNumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _controller.text = widget.initialValue ?? '';
      _empNumber = widget.initialValue;
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
        labelText: 'Employee Id *',
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
            color: Colors.blue,
            width: 2.0,
          ),
        ),
        suffixIcon: _empNumber != null && _empNumber!.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _controller.clear();
                    _empNumber = null;
                  });
                },
              )
            : null,
      ),
      validator: (value) {
        // Check if the entered emp_number already exists in the list
        if (widget.empNumberList.contains(value) && (widget.initialValue!=value)) {
          return 'Employee id is already taken by another user in selected depot';
        }

        return null;
      },
      onChanged: (String value) {
        setState(() {
          _empNumber = value;
        });
        widget.onSaved(value);
      },
    );
  }
}
