import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class TrainNumberDropdown extends StatefulWidget {
  final void Function(List<String>) onSaved;
  final List<String> trainList;
  final List<String>? initialValue;

  const TrainNumberDropdown({
    Key? key,
    required this.onSaved,
    required this.trainList,
    this.initialValue,
  }) : super(key: key);

  @override
  _TrainNumberDropdown createState() => _TrainNumberDropdown();
}

class _TrainNumberDropdown extends State<TrainNumberDropdown> {
  List<String> _selectedTrainNumbers = [];
  List<DropdownItem<Train>> TrainItems = [];
  final controller = MultiSelectController<Train>();

  bool _selectAllTriggered = false;
  Set<Train> _previousSelection = Set<Train>();
  bool _isSelectingAll = false;
  bool _initialSelectionDone = false;

  @override
  void initState() {
    super.initState();
    _loadTrains();
  }

  @override
  void didUpdateWidget( TrainNumberDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.trainList != widget.trainList) {
      _loadTrains();
    }
  }

  Future<void> _loadTrains() async {
    final divisions = await fetchDepots();
    setState(() {
      TrainItems = divisions;
      controller.setItems(TrainItems);
      _applyInitialSelection();
    });
  }

  void _applyInitialSelection() {
    if (!_initialSelectionDone && widget.initialValue != null && widget.initialValue!.isNotEmpty && TrainItems.isNotEmpty) {
      Future.delayed(Duration.zero, () {
        final itemsToSelect = TrainItems.where((item) => 
          widget.initialValue!.contains(item.value.name) && 
          item.value.name != 'Select All').toList();

        if (itemsToSelect.isNotEmpty) {
          controller.selectWhere((item) => 
            widget.initialValue!.contains(item.value.name) && 
            item.value.name != 'Select All');

          setState(() {
            _selectedTrainNumbers = widget.initialValue!;
            _previousSelection = Set<Train>.from(
              itemsToSelect.map((item) => item.value)
            );
          });

          widget.onSaved(_selectedTrainNumbers);
        }
        _initialSelectionDone = true;
      });
    }
  }

  Future<List<DropdownItem<Train>>> fetchDepots() async {
    List<DropdownItem<Train>> TrainItems = widget.trainList
        .asMap()
        .entries
        .map((entry) => DropdownItem<Train>(
              label: entry.value,
              value: Train(name: entry.value, id: entry.key + 1),
            ))
        .toList();

    TrainItems.insert(
      0,
      DropdownItem<Train>(
          label: 'All', value: Train(name: 'Select All', id: 0)),
    );
    return TrainItems;
  }

  @override
  Widget build(BuildContext context) {
    return MultiDropdown<Train>(
        items: TrainItems,
        controller: controller,
        enabled: TrainItems.isNotEmpty,
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
          hintText: 'Select Train Numbers',
          hintStyle: const TextStyle(color: Colors.black54),
          showClearIcon: true,
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
          marginTop: 2,
          maxHeight: 300,
          header: Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Select Trains from the list',
              style: TextStyle(
                fontSize: 12,
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
            return 'Please select at least one Train';
          }
          return null;
        },
        onSelectionChange: (selectedItems) {
          final selectedItemsSet = Set<Train>.from(selectedItems);
          final addedItems = selectedItemsSet.difference(_previousSelection);
          final removedItems = _previousSelection.difference(selectedItemsSet);

          if (addedItems.contains(Train(name: 'Select All', id: 0))) {
            if (!_isSelectingAll) {
              _isSelectingAll = true;
              setState(() {
                controller.selectAll();
              });
              return;
            }
          } else if (removedItems
              .contains(Train(name: 'Select All', id: 0))) {
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
                _selectedTrainNumbers = selectedItems
                                  .where((item) => item.name != 'Select All')
                                  .map((item) => item.name)
                                  .toList();
              });
              widget.onSaved(_selectedTrainNumbers);
              print(_selectedTrainNumbers);
          }

          if (!(selectedItemsSet.length == 1 &&
              selectedItemsSet.contains(Train(name: 'Select All', id: 0)))) {
            _previousSelection = selectedItemsSet;
          }
        },
      );
  }
}

class Train {
  final String name;
  final int id;

  Train({required this.name, required this.id});

  @override
  String toString() {
    return 'Train(name: $name, id: $id)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Train && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

