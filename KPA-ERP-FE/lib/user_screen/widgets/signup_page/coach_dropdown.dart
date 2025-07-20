import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';


class CoachDropdown extends StatefulWidget {
  final void Function(List<String>) onSaved;
  final List<String> coachList;

  const CoachDropdown({
    Key? key,
    required this.onSaved,
    required this.coachList,
  }) : super(key: key);

  @override
  _CoachDropdown createState() => _CoachDropdown();
}

class _CoachDropdown extends State<CoachDropdown> {
  List<String> _selectedCoachNumbers = [];
  List<DropdownItem<Coach>> coachItems = [];
  final controller = MultiSelectController<Coach>();

  bool _selectAllTriggered = false;
  Set<Coach> _previousSelection = Set<Coach>();
  bool _isSelectingAll = false;


  @override
  void didUpdateWidget( CoachDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.coachList != widget.coachList) {
      _loadCoaches();
    }
  }

  Future<void> _loadCoaches() async {
    final coaches = await fetchCoaches();
    setState(() {
      coachItems = coaches;
      controller.setItems(coachItems);
    });
  }

  Future<List<DropdownItem<Coach>>> fetchCoaches() async {
    List<DropdownItem<Coach>> TrainItems = widget.coachList
        .asMap()
        .entries
        .map((entry) => DropdownItem<Coach>(
              label: entry.value,
              value: Coach(name: entry.value, id: entry.key + 1),
            ))
        .toList();

    TrainItems.insert(
      0,
      DropdownItem<Coach>(
          label: 'Select All', value: Coach(name: 'Select All', id: 0)),
    );
    return TrainItems;
  }


  @override
  Widget build(BuildContext context) {
    return MultiDropdown<Coach>(
        items: coachItems,
        controller: controller,
        enabled: coachItems.isNotEmpty,
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
          hintText: 'Select Coaches',
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
              'Select Coaches from the list',
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
            return 'Please select at least one coach';
          }
          return null;
        },
        onSelectionChange: (selectedItems) {
          final selectedItemsSet = Set<Coach>.from(selectedItems);
          final addedItems = selectedItemsSet.difference(_previousSelection);
          final removedItems = _previousSelection.difference(selectedItemsSet);

          if (addedItems.contains(Coach(name: 'Select All', id: 0))) {
            if (!_isSelectingAll) {
              _isSelectingAll = true;
              setState(() {
                controller.selectAll();
              });
              return;
            }
          } else if (removedItems
              .contains(Coach(name: 'Select All', id: 0))) {
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
                _selectedCoachNumbers = selectedItems
                                  .where((item) => item.name != 'Select All')
                                  .map((item) => item.name)
                                  .toList();
              });
              widget.onSaved(_selectedCoachNumbers);
              // print(_selectedCoachNumbers);
          }

          if (!(selectedItemsSet.length == 1 &&
              selectedItemsSet.contains(Coach(name: 'Select All', id: 0)))) {
            _previousSelection = selectedItemsSet;
          }
        },
      );
  }
}

class Coach {
  final String name;
  final int id;

  Coach({required this.name, required this.id});

  @override
  String toString() {
    return 'Coach(name: $name, id: $id)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Coach && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
