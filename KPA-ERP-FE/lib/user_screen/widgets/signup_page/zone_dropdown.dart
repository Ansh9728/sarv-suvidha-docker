import 'package:flutter/material.dart';
import 'package:kpa_erp/services/train_service_signup.dart';
import 'package:kpa_erp/types/zone_division_type.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class ZoneDropdown extends StatefulWidget {
  final void Function(String) onSaved;
  final String? initialValue;

  const ZoneDropdown({
    Key? key,
    required this.onSaved,
    this.initialValue,
  }) : super(key: key);

  @override
  _ZoneDropdownState createState() => _ZoneDropdownState();
}

class _ZoneDropdownState extends State<ZoneDropdown> {
  String _selectedZone = '';
  List<ZoneDivision> zoneList = [];
  List<DropdownItem<ZoneDivision>> zoneItems = [];
  final controller = MultiSelectController<ZoneDivision>();
  Set<ZoneDivision> _previousSelection = Set<ZoneDivision>();
  bool _isInitialized = false;
  bool _isSelectingAll = false;

  
  @override
  void initState() {
    super.initState();
    _loadZones();
  }

  @override
  void didUpdateWidget(ZoneDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only reload zones if the initialValue changed and is different from our current selection
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _selectedZone) {
      _applyInitialValue();
    }
  }

  Future<void> _loadZones() async {
    try {
      

      List<ZoneDivision> zones = await TrainServiceSignup.getZones();

      setState(() {
        zoneList = zones;
        zoneItems = zones
            .map(
              (zone) => DropdownItem<ZoneDivision>(
                label: zone.code,
                value: zone,
              ),
            )
            .toList()
          ..sort((a, b) => a.label.compareTo(b.label));

        
        zoneItems.insert(0,
          DropdownItem<ZoneDivision>(
            label: 'All',
            value: ZoneDivision(code: '0', name: 'Select All'),
          ));

        controller.setItems(zoneItems);
        _applyInitialValue();
        _isInitialized = true;
       
      });
    } catch (e) {
      print("Error fetching zones: $e");
      
    }
  }

  void _applyInitialValue() {
    if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
      final initialZones = widget.initialValue!.split(',');
      controller.selectWhere((item) => initialZones.contains(item.value.code));
      _selectedZone = widget.initialValue!;
    } else {
      controller.clearAll();
      _selectedZone = '';
    }
  }

  @override
  Widget build(BuildContext context) {
   

    return MultiDropdown<ZoneDivision>(
      items: zoneItems,
      controller: controller,
      enabled: zoneItems.isNotEmpty,
      searchEnabled: true,
      // Adjusting chip decoration to be more subtle
      chipDecoration: ChipDecoration(
        backgroundColor: Colors.white,
        border: Border.all(
          color: Colors.blue.shade300,
          width: 1.0,
        ),
        wrap: false,
        runSpacing: 4,
        spacing: 8,
      ),
      // Matching the DropdownButtonFormField style
      fieldDecoration: FieldDecoration(
        hintText: 'Zone',
        labelText: 'Zone *',
        hintStyle: const TextStyle(color: Colors.black54, fontSize: 12),
        labelStyle: const TextStyle(color: Colors.black87, fontSize: 16),
        showClearIcon: true,
        padding:const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade600),
        ),
      ),
      // Simplifying the dropdown appearance
      dropdownDecoration: const DropdownDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        header: Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Select Zone',
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
          return 'Please select at least one zone';
        }
        return null;
      },
      onSelectionChange: (selectedItems) {
  if (!_isInitialized) return;

  final selectedSet = Set<ZoneDivision>.from(selectedItems);
  final isSelectAllSelected = selectedSet.any((z) => z.code == "0");
  final totalSelectableCount = zoneItems.length - 1; // excluding 'Select All'

  if (isSelectAllSelected && !_isSelectingAll) {
    _isSelectingAll = true;
    setState(() {
      controller.selectWhere((item) => item.value.code != "0"); // select all except 'Select All'
    });
    return;
  }

  if (!isSelectAllSelected && _isSelectingAll) {
    _isSelectingAll = false;
    setState(() {
      controller.clearAll();
    });
    return;
  }

  if (_isSelectingAll &&
      selectedSet.length < totalSelectableCount) {
    _isSelectingAll = false;
  }

  setState(() {
    _selectedZone = selectedSet
        .where((item) => item.code != '0')
        .map((item) => item.code)
        .join(',');
    _previousSelection = selectedSet;
  });

  widget.onSaved(_selectedZone);
},

    );
  }
}

extension on DropdownItem<ZoneDivision> {
  String toLowerCase() {
    return value.code.toLowerCase();
  }
}
