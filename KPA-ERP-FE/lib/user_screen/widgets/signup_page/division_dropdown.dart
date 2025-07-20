import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class DivisionDropdown extends StatefulWidget {
  final void Function(String) onSaved;
  final List<String> divisions;
  final String? initialValue;

  const DivisionDropdown({
    Key? key,
    required this.onSaved,
    required this.divisions,
    this.initialValue,
  }) : super(key: key);

  @override
  _DivisionDropdownState createState() => _DivisionDropdownState();
}

class _DivisionDropdownState extends State<DivisionDropdown> {
  String _selectedDivision = '';
  List<DropdownItem<Division>> divisionItems = [];
  final controller = MultiSelectController<Division>();
  Set<Division> _previousSelection = Set<Division>();
  bool _isSelectingAll = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadDivisions();
  }

  @override
  void didUpdateWidget(DivisionDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.divisions != widget.divisions) {
      _loadDivisions();
    }
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _selectedDivision) {
      _applyInitialValue();
    }
  }

  Future<void> _loadDivisions() async {
    try {
      final divisions = await fetchDivisions();
      setState(() {
        divisionItems = divisions;
        controller.setItems(divisionItems);
        _applyInitialValue();
        _isInitialized = true;
      });
    } catch (e) {
      print("Error fetching divisions: $e");
    }
  }

  void _applyInitialValue() {
    if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
      final initialDivisions = widget.initialValue!.split(',');
      controller.selectWhere((item) =>
          initialDivisions.contains(item.value.name) && item.value.id != 0);
      _selectedDivision = widget.initialValue!;
    } else {
      controller.clearAll();
      _selectedDivision = '';
    }
  }

  Future<List<DropdownItem<Division>>> fetchDivisions() async {
    List<DropdownItem<Division>> divisionItems = widget.divisions
        .asMap()
        .entries
        .map((entry) => DropdownItem<Division>(
              label: entry.value,
              value: Division(name: entry.value, id: entry.key + 1),
            ))
        .toList();

    divisionItems.insert(
      0,
      DropdownItem<Division>(
          label: 'All', value: Division(name: 'Select All', id: 0)),
    );

    return divisionItems;
  }

  @override
  Widget build(BuildContext context) {
    return MultiDropdown<Division>(
      items: divisionItems,
      controller: controller,
      enabled: divisionItems.isNotEmpty,
      searchEnabled: true,
      // Adjusting chip decoration to be more subtle
      chipDecoration: ChipDecoration(
        backgroundColor: Colors.white,
        border: Border.all(
          color: Colors.blue,
          width: 1.0,
        ),
        wrap: false,
        runSpacing: 4,
        spacing: 8,
      ),
      fieldDecoration: FieldDecoration(
        hintText: 'Divisions',
        labelText: 'Divisions *',
        hintStyle: const TextStyle(color: Colors.black54, fontSize: 12),
        labelStyle: const TextStyle(color: Colors.black87, fontSize: 16),
        showClearIcon: true,
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
      ),
      dropdownDecoration: const DropdownDecoration(
        // preferredDirection: DropdownDirection.bottom,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        header: Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Select Divisions from the list',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      dropdownItemDecoration: DropdownItemDecoration(
        selectedIcon: const Icon(Icons.check_box, color: Colors.green),
        disabledIcon: Icon(Icons.lock, color: Colors.grey.shade300),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select at least one division';
        }
        return null;
      },
      onSelectionChange: (selectedItems) {
        final selectedItemsSet = Set<Division>.from(selectedItems);
        final addedItems = selectedItemsSet.difference(_previousSelection);
        final removedItems = _previousSelection.difference(selectedItemsSet);

        if (addedItems.contains(Division(name: 'Select All', id: 0))) {
          if (!_isSelectingAll) {
            _isSelectingAll = true;
            setState(() {
              controller.selectAll();
            });
            return;
          }
        } else if (removedItems.contains(Division(name: 'Select All', id: 0))) {
          if (_isSelectingAll) {
            _isSelectingAll = false;
            setState(() {
              controller.clearAll();
            });
            return;
          }
        } else if (_isSelectingAll && removedItems.isNotEmpty) {
          _isSelectingAll = false;
          setState(() {
            controller.clearAll();
            controller.selectWhere((item) =>
                selectedItemsSet.contains(item.value) && item.value.id != 0);
          });
          return;
        }

        if (selectedItems != null) {
          setState(() {
            _selectedDivision = selectedItems
                .where((item) => item.name != 'Select All')
                .map((item) => item.name)
                .toList()
                .join(',');
          });
          widget.onSaved(_selectedDivision);
          // print(_selectedDivision);
        }

        if (!(selectedItemsSet.length == 1 &&
            selectedItemsSet.contains(Division(name: 'Select All', id: 0)))) {
          _previousSelection = selectedItemsSet;
        }
      },
    );
  }
}

class Division {
  final String name;
  final int id;

  Division({required this.name, required this.id});

  @override
  String toString() {
    return 'Division(name: $name, id: $id)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Division && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
