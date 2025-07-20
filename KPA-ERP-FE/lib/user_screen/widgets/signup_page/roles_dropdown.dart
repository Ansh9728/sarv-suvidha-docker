import 'package:flutter/material.dart';

class RolesDropdown extends StatefulWidget {
  final void Function(String) onSaved;
  final String? initialValue;

  const RolesDropdown({Key? key, required this.onSaved, this.initialValue}) : super(key: key);

  @override
  _RolesDropdownState createState() => _RolesDropdownState();
}

class _RolesDropdownState extends State<RolesDropdown> {
  late String _selectedRole;
  final List<String> _roles = [
    'coach attendent',
    'contractor',
    'contractor admin',
    'EHK',
    'OBHS',
    'railway admin',
    'railway officer',
    's2 admin',
    'war room user',
    'write read',
    'passenger'
  ];

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.initialValue ?? _roles.first; // Use initial value if provided
  }

  @override
  void didUpdateWidget(covariant RolesDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      setState(() {
        _selectedRole = widget.initialValue ?? _roles.first;
      });
    }
  }

  InputDecoration textFieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: textFieldDecoration('Select Role'),
      value: _selectedRole,
      items: _roles.map((role) {
        return DropdownMenuItem<String>(
          value: role,
          child: Text(role),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedRole = value!;
        });
        widget.onSaved(value!);
      },
    );
  }
}
