import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:kpa_erp/provider/icf_wheel_provider.dart';
import 'package:kpa_erp/widgets/custom_dropdown.dart';
import 'package:kpa_erp/widgets/custom_text_field.dart';
import 'package:kpa_erp/widgets/custom_search_bar.dart';
import 'package:provider/provider.dart';

class IcfWheel extends StatelessWidget {
  const IcfWheel({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => IcfWheelProvider(),
      child: const IcfWheelView(),
    );
  }
}

class IcfWheelView extends StatefulWidget {
  const IcfWheelView({super.key});

  @override
  State<IcfWheelView> createState() => _IcfWheelViewState();
}

class _IcfWheelViewState extends State<IcfWheelView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<IcfWheelProvider>(context, listen: false);
      provider.initializeFields(_buildFields(provider));
    });
  }

  List<Map<String, Widget>> _buildFields(IcfWheelProvider p) {
    const sectionSpacing = SizedBox(height: 10);

    return [
      {
        "Tread Diameter (New)": CustomTextField(
          label: "Tread Diameter (New)",
          value: p.treadDiameterController.text,
          controller: p.treadDiameterController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
      },
      {"section": sectionSpacing},
      {
        "Last Shop Issue Size (Dia.)": CustomTextField(
          label: "Last Shop Issue Size (Dia.)",
          value: p.lastShopIssueController.text,
          controller: p.lastShopIssueController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
      },
      {"section": sectionSpacing},
      {
        "Condemning Dia.": CustomTextField(
          label: "Condemning Dia.",
          value: p.condemningDiaController.text,
          controller: p.condemningDiaController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
      },
      {"section": sectionSpacing},
      {
        "Wheel Gauge (IFD)": CustomTextField(
          label: "Wheel Gauge (IFD)",
          value: p.wheelGaugeController.text,
          controller: p.wheelGaugeController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
      },
      {"section": sectionSpacing},
      {
        "Permissible Variation - Same Axle": const CustomTextField(
          label: "Permissible Variation - Same Axle",
          value: "0.5",
        ),
      },
      {"section": sectionSpacing},
      {
        "Permissible Variation - Same Bogie": const CustomTextField(
          label: "Permissible Variation - Same Bogie",
          value: "5",
        ),
      },
      {"section": sectionSpacing},
      {
        "Permissible Variation - Same Coach": const CustomTextField(
          label: "Permissible Variation - Same Coach",
          value: "13",
        ),
      },
      {"section": sectionSpacing},
      {
        "Wheel Profile (RDSO 91146 Alt.2)": const CustomTextField(
          label: "Wheel Profile (RDSO 91146 Alt.2)",
          value: "29.4 Flange Thickness",
        ),
      },
      {"section": sectionSpacing},
      {
        "Intermediate WWP (RDSO 92082)": const CustomTextField(
          label: "Intermediate WWP (RDSO 92082)",
          value: "20 TO 28",
        ),
      },
      {"section": sectionSpacing},
      {
        "Bearing Seat Diameter": const CustomTextField(
          label: "Bearing Seat Diameter",
          value: "130.043 TO 130.068",
        ),
      },
      {"section": sectionSpacing},
      {
        "Roller Bearing Outer Dia": const CustomDropdownWithOther(
          label: "Roller Bearing Outer Dia",
          items: ["280 (+0.0/-0.035)"],
        ),
      },
      {"section": sectionSpacing},
      {
        "Roller Bearing Bore Dia": const CustomDropdownWithOther(
          label: "Roller Bearing Bore Dia",
          items: ["130 (+0.0/-0.025)"],
        ),
      },
      {"section": sectionSpacing},
      {
        "Roller Bearing Width": const CustomDropdownWithOther(
          label: "Roller Bearing Width",
          items: ["93 (+0/-0.250)"],
        ),
      },
      {"section": sectionSpacing},
      {
        "Axle Box Housing Bore Dia": const CustomDropdownWithOther(
          label: "Axle Box Housing Bore Dia",
          items: ["280 (+0.030/+0.052),"],
        ),
      },
      {"section": sectionSpacing},
      {
        "Wheel Disc Width": const CustomDropdownWithOther(
          label: "Wheel Disc Width",
          items: [
            "127 (+4/-0)",
            "275 (+0.0/-0.030)",
            "285 (+0.0/-0.040)",
            "290 (+0.0/-0.050)",
            "295 (+0.0/-0.060)",
            "300 (+0.0/-0.070)",
          ],
        ),
      },
    ];
  }

  Widget _summaryCard(IcfWheelProvider p) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
    elevation: 6,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.check_circle, color: Colors.green, size: 28),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Submitted Data",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: p.handleEdit,
                icon: const Icon(Icons.edit, color: Colors.indigo, size: 24),
                tooltip: 'Edit',
              ),
            ],
          ),
          const Divider(height: 24, thickness: 1),
          _summaryRow("From Number", p.treadDiameterController.text),
          _summaryRow("Last Shop Issue Size (Dia.)", p.lastShopIssueController.text),
          _summaryRow("Condemning Dia.", p.condemningDiaController.text),
          _summaryRow("Wheel Gauge (IFD)", p.wheelGaugeController.text),
        ],
      ),
    ),
  );
}

Widget _summaryRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            "$label:",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}
  

  void _showFilterDialog(BuildContext context, IcfWheelProvider provider) {
  showDialog(
    context: context,
    builder: (context) {
      final formNumberController = TextEditingController();
      final createdAtController = TextEditingController();
      final createdByController = TextEditingController();

      return AlertDialog(
        title: const Text('Filter Fields'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              label: 'Form Number',
              controller: formNumberController,
              value: '',
              keyboardType: TextInputType.numberWithOptions(),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  createdAtController.text = 
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                }
              },
              child: AbsorbPointer(
                child: CustomTextField(
                  label: 'Created At',
                  controller: createdAtController,
                  value: '',
                ),
              ),
            ),
            const SizedBox(height: 10),
            CustomTextField(
              label: 'Created By',
              controller: createdByController,
              value: '',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.applyFilter(
                formNumber: formNumberController.text,
                createdAt: createdAtController.text,
                createdBy: createdByController.text,
              );
              provider.showSummaryCard = formNumberController.text.isNotEmpty ||
                  createdAtController.text.isNotEmpty ||
                  createdByController.text.isNotEmpty;
              Navigator.of(context).pop();
            },
            child: const Text('Apply'),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<IcfWheelProvider>(context);

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
        title: const Text(
          "ICF Wheel Specs",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSearchBar(
                hintText: "Search fields...",
                controller: provider.searchController,
                onChanged: provider.filterFields,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () => _showFilterDialog(context, provider),
                ),
              ),
              const Gap(8),

              // Add Summary Card here after filter applied
              if (provider.showSummaryCard) _summaryCard(provider),

              const Divider(),
              const SizedBox(height: 30),
              ...provider.visibleFields.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: entry.values.first,
                ),
              ),
              const Gap(20),
              if (!provider.submitted || provider.isEditing)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => provider.handleSubmit(context),
                    icon: const Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Submit",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              if (provider.showSummaryCard) _summaryCard(provider),
            ],
          ),
        ),
      ),
    );
  }
}
