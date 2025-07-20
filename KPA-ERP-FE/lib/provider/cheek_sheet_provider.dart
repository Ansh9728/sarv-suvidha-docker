// checksheet_form_provider.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChecksheetFormProvider extends ChangeNotifier {
  final TextEditingController bogieNoController = TextEditingController();
  final TextEditingController makerYearBuiltController =
      TextEditingController();
  final TextEditingController incomingDivDateController =
      TextEditingController();
  final TextEditingController deficitComponentsController =
      TextEditingController();
  final TextEditingController dateOfIohController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  bool submitted = false;
  bool isEditing = false;

  List<Map<String, Widget>> allFields = [];
  List<Map<String, Widget>> visibleFields = [];

  void initializeFields(List<Map<String, Widget>> fields) {
    allFields = fields;
    visibleFields = List.from(fields);
    notifyListeners();
  }
  // Add to class ChecksheetFormProvider

  DateTime? fromDate;
  DateTime? toDate;
  String filterBogieNo = "";
  String sortBy = "Date"; // or "Bogie No"
  bool sortAsc = true;

  bool get hasFilter =>
      filterBogieNo.isNotEmpty || fromDate != null || toDate != null;

  List<Map<String, String>> filteredData = [];

  void applyFilter() {
    // Sample dummy data to simulate actual submission storage
    final allData = [
      {
        "bogieNo": bogieNoController.text,
        "maker": makerYearBuiltController.text,
        "deficit": deficitComponentsController.text,
        "date": incomingDivDateController.text,
      },
    ];

    filteredData = allData.where((entry) {
      final entryDate = DateTime.tryParse(entry["date"] ?? "");
      final matchBogie =
          filterBogieNo.isEmpty || entry["bogieNo"]!.contains(filterBogieNo);
      final matchFrom =
          fromDate == null ||
          (entryDate != null &&
              entryDate.isAfter(fromDate!.subtract(const Duration(days: 1))));
      final matchTo =
          toDate == null ||
          (entryDate != null &&
              entryDate.isBefore(toDate!.add(const Duration(days: 1))));
      return matchBogie && matchFrom && matchTo;
    }).toList();

    // Sorting
    filteredData.sort((a, b) {
      int cmp;
      if (sortBy == "Date") {
        cmp = (DateTime.tryParse(a["date"] ?? "") ?? DateTime(2000)).compareTo(
          DateTime.tryParse(b["date"] ?? "") ?? DateTime(2000),
        );
      } else {
        cmp = a["bogieNo"]!.compareTo(b["bogieNo"]!);
      }
      return sortAsc ? cmp : -cmp;
    });

    notifyListeners();
  }

  void clearFilter() {
    filterBogieNo = "";
    fromDate = null;
    toDate = null;
    filteredData = [];
    notifyListeners();
  }

  void setSortBy(String key, bool ascending) {
    sortBy = key;
    sortAsc = ascending;
    applyFilter();
  }

  // void handleSubmit(BuildContext context) {
  //   submitted = true;
  //   isEditing = false;
  //   notifyListeners();
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text("Wheel spec form submitted successfully.")),
  //   );
  // }

  void handleSubmit(BuildContext context) async {
  submitted = true;
  isEditing = false;
  notifyListeners();

  // Prepare the payload
  final payload = {
  "bmbcChecksheet": {
    "adjustingTube": "Damaged",
    "cylinderBody": "WornOut",
    "pistonTrunnion": "Good",
    "plungerSpring": "Good"
  },
  "bogieChecksheet": {
    "axleGuide": "Worn",
    "bogieFrameCondition": "Good",
    "bolster": "Good",
    "bolsterSuspensionBracket": "Cracked",
    "lowerSpringSeat": "Good"
  },
  "bogieDetails": {
    "bogieNo": "BG1234",
    "dateOfIOH": "2025-07-01",
    "deficitComponents": "None",
    "incomingDivAndDate": "2025-06-25",
    "makerYearBuilt": "RDSO/2018"
  },
  "formNumber": "BOGIE-2025-008",
  "inspectionBy": "user_id_456",
  "inspectionDate": "2025-07-03"
};



  try {
    final response = await http.post(
      Uri.parse("http://localhost:7777/api/forms/bogie-checksheet"), // Replace with your backend URL
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(payload),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("bogie Form submitted successfully.")),
      );
      bogieNoController.clear();
      makerYearBuiltController.clear();
      incomingDivDateController.clear();
      deficitComponentsController.clear();
      dateOfIohController.clear();
    } else {
      final error = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${error['detail'] ?? 'Unknown error'}")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Bogie Submission failed: $e")),
    );
  }
  }



  void handleEdit() {
    isEditing = true;
    notifyListeners();
  }

  void filterFields(String query) {
    if (query.isEmpty) {
      visibleFields = List.from(allFields);
    } else {
      visibleFields =
          allFields
              .where(
                (field) => field.keys.first.toLowerCase().contains(
                  query.toLowerCase(),
                ),
              )
              .toList()
            ..addAll(
              allFields.where(
                (field) => !field.keys.first.toLowerCase().contains(
                  query.toLowerCase(),
                ),
              ),
            );
    }
    notifyListeners();
  }

  Future<void> pickDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      controller.text = pickedDate.toIso8601String().split('T').first;
      notifyListeners();
    }
  }
}
