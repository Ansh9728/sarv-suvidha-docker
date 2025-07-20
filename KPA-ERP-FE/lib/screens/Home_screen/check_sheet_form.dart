import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:kpa_erp/provider/cheek_sheet_provider.dart';
import 'package:provider/provider.dart';
import 'package:kpa_erp/widgets/custom_dropdown.dart';
import 'package:kpa_erp/widgets/custom_search_bar.dart';
import 'package:kpa_erp/widgets/custom_text_field.dart';

class ChecksheetFormScreen extends StatelessWidget {
  const ChecksheetFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChecksheetFormProvider(),
      child: const ChecksheetFormView(),
    );
  }
}

class ChecksheetFormView extends StatefulWidget {
  const ChecksheetFormView({super.key});

  @override
  State<ChecksheetFormView> createState() => _ChecksheetFormViewState();
}

class _ChecksheetFormViewState extends State<ChecksheetFormView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ChecksheetFormProvider>(context, listen: false);
      provider.initializeFields(_buildFieldWidgets(provider));
    });
  }

  List<Map<String, Widget>> _buildFieldWidgets(ChecksheetFormProvider provider) {
    const sectionSpacing = SizedBox(height: 8);
    return [
      {"section": sectionSpacing},
      {
        "Bogie Details": const Text("Bogie Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      },
      {"section": sectionSpacing},
      {
        "Bogie No.": CustomTextField(
          label: "Bogie No.",
          value: "",
          controller: provider.bogieNoController,
          keyboardType: TextInputType.number,
        ),
      },
      {"section": sectionSpacing},
      {
        "Maker & Year Built": CustomTextField(
          label: "Maker & Year Built",
          value: "",
          controller: provider.makerYearBuiltController,
        ),
      },
      {"section": sectionSpacing},
      {
        "Incoming Div. & Date": GestureDetector(
          onTap: () => provider.pickDate(context, provider.incomingDivDateController),
          child: AbsorbPointer(
            child: TextField(
              controller: provider.incomingDivDateController,
              decoration: _dateDecoration("Incoming Div. & Date"),
            ),
          ),
        ),
      },
      {"section": sectionSpacing},
      {
        "Deficit of component (if any)": CustomTextField(
          label: "Deficit of component (if any)",
          value: "",
          controller: provider.deficitComponentsController,
        ),
      },
      {"section": sectionSpacing},
      {
        "Date of IOH": GestureDetector(
          onTap: () => provider.pickDate(context, provider.dateOfIohController),
          child: AbsorbPointer(
            child: TextField(
              controller: provider.dateOfIohController,
              decoration: _dateDecoration("Date of IOH"),
            ),
          ),
        ),
      },
      {"section": sectionSpacing},
      {"divider": const Divider(height: 20)},
      {"section": sectionSpacing},
      {
        "Bogie Checksheet": const Text("Bogie Checksheet", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      },
      {"section": sectionSpacing},
      {
        "Bogie Frame Condition": const CustomDropdownWithOther(
          label: "Bogie Frame Condition",
          items: ["Overaged", "Cracked", "Worn out", "Good"],
          enableColoredDropdown: true,
        ),
      },
      {"section": sectionSpacing},
      {
        "Bolster": const CustomDropdownWithOther(
          label: "Bolster",
          items: ["Cracked", "Bent", "Good"],
          enableColoredDropdown: true,
        ),
      },
      {"section": sectionSpacing},
      {
        "Bolster Suspension Bracket": const CustomDropdownWithOther(
          label: "Bolster Suspension Bracket",
          items: ["Cracked", "Corroded", "Good"],
          enableColoredDropdown: true,
        ),
      },
      {"section": sectionSpacing},
      {
        "Lower Spring Seat": const CustomDropdownWithOther(
          label: "Lower Spring Seat",
          items: ["Cracked", "Worn out", "Good"],
          enableColoredDropdown: true,
        ),
      },
      {"section": sectionSpacing},
      {
        "Axle Guide": const CustomDropdownWithOther(
          label: "Axle Guide",
          items: ["Worn", "Misalign", "Good"],
          enableColoredDropdown: true,
        ),
      },
      {"section": sectionSpacing},
      {
        "Axle Guide Assembly": const CustomDropdownWithOther(
          label: "Axle Guide Assembly",
          items: ["Worn out", "Damaged", "Good"],
          enableColoredDropdown: true,
        ),
      },
      {"section": sectionSpacing},
      {
        "Protective Tubes": const CustomDropdownWithOther(
          label: "Protective Tubes",
          items: ["Cracked", "Good"],
          enableColoredDropdown: true,
        ),
      },
      {"section": sectionSpacing},
      {
        "Anchor Links": const CustomDropdownWithOther(
          label: "Anchor Links",
          items: ["Damaged", "Good"],
          enableColoredDropdown: true,
        ),
      },
      {"section": sectionSpacing},
      {
        "Side Bearer": const CustomDropdownWithOther(
          label: "Side Bearer",
          items: ["Damaged", "Good"],
          enableColoredDropdown: true,
        ),
      },
      {"section": sectionSpacing},
      {"divider": const Divider(height: 32)},
      {"section": sectionSpacing},
      {
        "BMBC Checksheet": const Text("BMBC Checksheet", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      },
      {"section": sectionSpacing},
      {
        "Cylinder Body & Dome Cover": const CustomDropdownWithOther(
          label: "Cylinder Body & Dome Cover",
          items: ["GOOD", "WORN OUT", "DAMAGED"],
          enableColoredDropdown: true,
        ),
      },
      {"section": sectionSpacing},
      {
        "Piston & Trunnion Body": const CustomDropdownWithOther(
          label: "Piston & Trunnion Body",
          items: ["GOOD", "WORN OUT", "DAMAGED"],
          enableColoredDropdown: true,
        ),
      },
      {"section": sectionSpacing},
      {
        "Adjusting Tube and Screw": const CustomDropdownWithOther(
          label: "Adjusting Tube and Screw",
          items: ["GOOD", "WORN OUT", "DAMAGED"],
          enableColoredDropdown: true,
        ),
      },
      {"section": sectionSpacing},
      {
        "Plunger Spring": const CustomDropdownWithOther(
          label: "Plunger Spring",
          items: ["GOOD", "WORN OUT", "DAMAGED"],
          enableColoredDropdown: true,
        ),
      },
      {"section": sectionSpacing},
      {
        "Tee Bolt, Hex Nut": const CustomDropdownWithOther(
          label: "Tee Bolt, Hex Nut",
          items: ["GOOD", "WORN OUT", "DAMAGED"],
          enableColoredDropdown: true,
        ),
      },
      {"section": sectionSpacing},
      {
        "Pawl and Pawl Spring": const CustomDropdownWithOther(
          label: "Pawl and Pawl Spring",
          items: ["GOOD", "WORN OUT", "DAMAGED"],
          enableColoredDropdown: true,
        ),
      },
      {"section": sectionSpacing},
      {
        "Dust Excluder": const CustomDropdownWithOther(
          label: "Dust Excluder",
          items: ["GOOD", "WORN OUT", "DAMAGED"],
          enableColoredDropdown: true,
        ),
      },
    ];
  }

  InputDecoration _dateDecoration(String label) => InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        suffixIcon: const Icon(Icons.calendar_today),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      );

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChecksheetFormProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3F51B5), Color(0xFF2196F3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        title: const Text("ICF Bogie Checksheet",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12, offset: const Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSearchBar(
                hintText: "Search fields...",
                controller: provider.searchController,
                onChanged: provider.filterFields,
              ),
              const Gap(8),
              const Divider(),
              const SizedBox(height: 30),
              ...provider.visibleFields.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: entry.values.first,
                ),
              ),
              if (!provider.submitted || provider.isEditing)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => provider.handleSubmit(context),
                    icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                    label: const Text("Submit", style: TextStyle(fontSize: 16, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                    ),
                  ),
                ),
              if (provider.submitted && !provider.isEditing) _buildSummaryCard(provider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(ChecksheetFormProvider provider) {
    return Card(
      margin: const EdgeInsets.only(top: 24),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                const Text("Submitted Data", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(
                  onPressed: provider.handleEdit,
                  icon: const Icon(Icons.edit, color: Colors.indigo),
                  tooltip: 'Edit',
                ),
              ],
            ),
            const Divider(),
            _summaryRow("Tread Diameter (New)", provider.bogieNoController.text),
            _summaryRow("Last Shop Issue Size (Dia.)", provider.makerYearBuiltController.text),
            _summaryRow("Condemning Dia.", provider.deficitComponentsController.text),
            _summaryRow("Wheel Gauge (IFD)", provider.deficitComponentsController.text),
          ],
        ),
      ),
    );
  }
  Widget _buildFilterBar(ChecksheetFormProvider provider) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Filter & Sort", style: TextStyle(fontWeight: FontWeight.bold)),
      const Gap(8),
      Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(labelText: "Search by Bogie No."),
              onChanged: (value) {
                provider.filterBogieNo = value;
              },
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () async {
              provider.fromDate = await _pickDate(context, provider.fromDate);
              provider.toDate = await _pickDate(context, provider.toDate);
              provider.applyFilter();
            },
            child: const Text("Filter"),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: provider.clearFilter,
            icon: const Icon(Icons.clear),
            tooltip: "Clear Filter",
          ),
        ],
      ),
      Row(
        children: [
          const Text("Sort by: "),
          DropdownButton<String>(
            value: provider.sortBy,
            items: const [
              DropdownMenuItem(value: "Date", child: Text("Date")),
              DropdownMenuItem(value: "Bogie No", child: Text("Bogie No")),
            ],
            onChanged: (val) {
              if (val != null) provider.setSortBy(val, provider.sortAsc);
            },
          ),
          IconButton(
            icon: Icon(provider.sortAsc ? Icons.arrow_upward : Icons.arrow_downward),
            onPressed: () {
              provider.setSortBy(provider.sortBy, !provider.sortAsc);
            },
          ),
        ],
      ),
    ],
  );
}

Future<DateTime?> _pickDate(BuildContext context, DateTime? initialDate) {
  return showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime.now(),
  );
}


  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }
}
