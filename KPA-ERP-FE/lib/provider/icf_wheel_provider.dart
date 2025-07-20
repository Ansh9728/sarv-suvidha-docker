import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IcfWheelProvider extends ChangeNotifier {
  bool submitted = false;
  bool isEditing = false;
  bool showSummaryCard = false;
bool showFilterCard = false;  // for filter summary card

  final searchController = TextEditingController();
  final treadDiameterController = TextEditingController(text: "915 (900-1000)");
  final lastShopIssueController = TextEditingController(text: "837 (800-900)");
  final condemningDiaController = TextEditingController(text: "825 (800-900)");
  final wheelGaugeController = TextEditingController(text: "1600 (+2,-1)");

  final List<Map<String, Widget>> allFields = [];
  List<Map<String, Widget>> visibleFields = [];

  String filterFormNumber = '';
  String filterCreatedAt = '';
  String filterCreatedBy = '';

  void initializeFields(List<Map<String, Widget>> fields) {
    allFields.clear();
    allFields.addAll(fields);
    visibleFields = List.from(allFields);
    notifyListeners();
  }

  void filterFields(String query) {
    visibleFields = query.isEmpty
        ? List.from(allFields)
        : allFields
            .where((field) => field.keys.first.toLowerCase().contains(query.toLowerCase()))
            .toList();
    notifyListeners();
  }

  void applyFilter({String formNumber = '', String createdAt = '', String createdBy = ''}) {
    filterFormNumber = formNumber;
    filterCreatedAt = createdAt;
    filterCreatedBy = createdBy;

    // Example condition for demonstration, adjust logic according to your actual data
    showSummaryCard = formNumber.isNotEmpty || createdAt.isNotEmpty || createdBy.isNotEmpty;

    notifyListeners();
  }

  // void handleSubmit(BuildContext context) {
  //   submitted = true;
  //   isEditing = false;
  //   notifyListeners();
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text("Wheel spec form submitted successfully.")),
  //   );
  // }

  Future<void> handleSubmit(BuildContext context) async {
  submitted = true;
  isEditing = false;
  notifyListeners();

  // Prepare your form data
  final Map<String, dynamic> data = {
  "form_number": "FORM1239", // dynamic
  "submitted_by": "Test Doe", // dynamic
  "submitted_date": DateTime.now().toIso8601String(), // should be outside `fields`
  "fields": {
    "treadDiameter": treadDiameterController.text,
    "lastShopIssue": lastShopIssueController.text,
    "condemningDia": condemningDiaController.text,
    "wheelGauge": wheelGaugeController.text,
    "axleBoxHousingBoreDia": "VALUE",
    "bearingSeatDiameter": "130.043 TO 130.068",
    "intermediateWWP": "VALUE",
    "lastShopIssueSize": "VALUE",
    "rollerBearingBoreDia": "VALUE",
    "rollerBearingOuterDia": "VALUE",
    "rollerBearingWidth": "VALUE",
    "treadDiameterNew": "VALUE",
    "variationSameAxle": "VALUE",
    "variationSameBogie": "VALUE",
    "variationSameCoach": "VALUE",
    "wheelDiscWidth": "VALUE",
    "wheelProfile": "29.4 Flange Thickness"
  }
};



  try {
    final response = await http.post(
      // Uri.parse('http://<YOUR_BACKEND_HOST>:<PORT>/api/checksheet/'), // <-- Replace with your endpoint
      Uri.parse('http://localhost:7777/api/forms/wheel-specifications'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Wheel specification submitted successfully.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Wheel specification Submission failed: ${response.body}")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  }
}


  void handleEdit() {
    isEditing = true;
    notifyListeners();
  }
}
