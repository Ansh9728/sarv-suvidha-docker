import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class DepotDropdown extends StatefulWidget {
  final void Function(String) onSaved;
  final List<String> depots;
  final String? initialValue;

  const DepotDropdown({
    Key? key,
    required this.onSaved,
    required this.depots,
    this.initialValue,
  }) : super(key: key);

  @override
  _DepotDropdown createState() => _DepotDropdown();
}

class _DepotDropdown extends State<DepotDropdown> {
  String? _selectedDepot;
  List<DropdownItem<Depot>> depotItems = [];
  final controller = MultiSelectController<Depot>();
  bool _isInitialized = false;
  Set<Depot> _previousSelection = Set<Depot>();
  bool _isSelectingAll = false;

  @override
  void initState() {
    super.initState();
    _loadDepots();
  }

  @override
  void didUpdateWidget(DepotDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.depots != widget.depots) {
      _loadDepots();
    }
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _selectedDepot) {
      _applyInitialValue();
    }
  }

  Future<void> _loadDepots() async {
    try {
      final depots = await fetchDepots();
      setState(() {
        depotItems = depots;
        controller.setItems(depotItems);
        _applyInitialValue();
        _isInitialized = true;
      });
    } catch (e) {
      print("Error fetching depots: $e");
    }
  }

  void _applyInitialValue() {
    if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
      final initialDepots = widget.initialValue!.split(',');
      controller.selectWhere((item) =>
          initialDepots.contains(item.value.name) && item.value.id != 0);
      _selectedDepot = widget.initialValue!;
    } else {
      controller.clearAll();
      _selectedDepot = '';
    }
  }

  Future<List<DropdownItem<Depot>>> fetchDepots() async {
    List<DropdownItem<Depot>> divisionItems = widget.depots
        .asMap()
        .entries
        .map((entry) => DropdownItem<Depot>(
              label: entry.value,
              value: Depot(name: entry.value, id: entry.key + 1),
            ))
        .toList();

    divisionItems.insert(
      0,
      DropdownItem<Depot>(
          label: 'All', value: Depot(name: 'Select All', id: 0)),
    );
    return divisionItems;
  }

  @override
  Widget build(BuildContext context) {
    return MultiDropdown<Depot>(
      items: depotItems,
      controller: controller,
      enabled: depotItems.isNotEmpty,
      searchEnabled: true,
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
       
        labelText: 'Depot *',
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
        borderRadius:  BorderRadius.all(Radius.circular(12)),
        header:  Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Select depot from the list',
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
          return 'Please select at least one depot';
        }
        return null;
      },
      onSelectionChange: (selectedItems) {
        if (!_isInitialized) return; // Prevent changes during initialization

        final selectedItemsSet = Set<Depot>.from(selectedItems);
        final addedItems = selectedItemsSet.difference(_previousSelection);
        final removedItems = _previousSelection.difference(selectedItemsSet);

        // Handle "Select All" functionality
        if (addedItems.contains(Depot(name: 'Select All', id: 0))) {
          if (!_isSelectingAll) {
            _isSelectingAll = true;
            setState(() {
              controller.selectAll();
            });
            return;
          }
        } else if (removedItems.contains(Depot(name: 'Select All', id: 0))) {
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

        setState(() {
          _selectedDepot = selectedItemsSet
              .where((item) => item.name != 'Select All')
              .map((item) => item.name)
              .toList()
              .join(',');
        });
        widget.onSaved(_selectedDepot!);

        if (!(selectedItemsSet.length == 1 &&
            selectedItemsSet.contains(Depot(name: 'Select All', id: 0)))) {
          _previousSelection = selectedItemsSet;
        }
      },
    );
  }
}

class Depot {
  final String name;
  final int id;

  Depot({required this.name, required this.id});

  @override
  String toString() {
    return 'Depot(name: $name, id: $id)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Depot && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
