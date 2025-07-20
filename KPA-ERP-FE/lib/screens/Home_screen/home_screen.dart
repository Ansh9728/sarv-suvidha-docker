import 'package:flutter/material.dart';
import 'package:kpa_erp/models/auth_model.dart';
import 'package:kpa_erp/provider/auth_provider.dart';
import 'package:kpa_erp/routes.dart';
import 'package:kpa_erp/screens/profile/profile_view.dart';
import 'package:kpa_erp/services/authentication_services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final formNumberController = TextEditingController();
  final inspectionByController = TextEditingController();
  final inspectionDateController = TextEditingController();

  bool showSummary = false;
  bool submitted = false;
  bool isLoadingSummary = false;
  @override
  void initState() {
    super.initState();
    _loadFormData();
  }

  Future<void> _loadFormData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      formNumberController.text = prefs.getString('') ?? '';
      inspectionByController.text = prefs.getString('') ?? '';
      inspectionDateController.text = prefs.getString('') ?? '';
      showSummary = prefs.getBool('formSubmitted') ?? false;
    });
  }

  Future<void> _saveFormData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('formNumber', formNumberController.text.trim());
    await prefs.setString('inspectionBy', inspectionByController.text.trim());
    await prefs.setString(
      'inspectionDate',
      inspectionDateController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Form data saved successfully")),
    );

    setState(() {
      isLoadingSummary = true;
      submitted = true;
    });

    // Simulate loading
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoadingSummary = false;
    });
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate:
          DateTime.tryParse(inspectionDateController.text) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      inspectionDateController.text = DateFormat('yyyy-MM-dd').format(date);
      setState(() {});
    }
  }

  Future<void> _logout(BuildContext context) async {
    final authModel = Provider.of<AuthModel>(context, listen: false);
    try {
      await AuthService.logout(
        authModel.loginResponse!.refreshToken,
        authModel.loginResponse!.token,
      );
    } catch (_) {}
    authModel.logout();
    Navigator.pushReplacementNamed(context, Routes.login);
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.pop(context);
    Navigator.pushNamed(context, route);
  }

  bool get isFormValid =>
      formNumberController.text.trim().isNotEmpty &&
      inspectionByController.text.trim().isNotEmpty &&
      inspectionDateController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final authModel = Provider.of<AuthModel>(context);
    final googleUser = Provider.of<AuthProvider>(context).user;
    final userName =
        googleUser?.displayName ?? authModel.loginResponse?.userName ?? "User";

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3F51B5), Color(0xFF2196F3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Home",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Text(
                "Welcome, $userName 👋",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
              }
            ),
          ],
        ),
      ),
      drawer: _buildDrawer(context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                _modernTextField(formNumberController, "Form Number"),
                const SizedBox(height: 14),

                _modernTextField(inspectionByController, "Inspection By"),
                const SizedBox(height: 14),

                GestureDetector(
                  onTap: _pickDate,
                  child: AbsorbPointer(
                    child: _modernTextField(
                      inspectionDateController,
                      "Inspection Date",
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isFormValid ? _saveFormData : null,
                    icon: const Icon(Icons.save),
                    label: const Text("Submit"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                if (submitted)
                  isLoadingSummary
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : _buildSummaryCard(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _modernTextField(
    TextEditingController controller,
    String label, {
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: label == "Form Number"
          ? TextInputType.number
          : TextInputType.text,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.indigo),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3F51B5), Color(0xFF2196F3)],
              ),
            ),
            child: Text(
              'KPA-ERP',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('Wheel Specification Form'),
            onTap: () => _navigateTo(context, Routes.wheelSpecForm),
          ),
          ListTile(
            leading: const Icon(Icons.build_circle_outlined),
            title: const Text('Bogie Checksheet Form'),
            onTap: () => _navigateTo(context, Routes.bogieChecksheetForm),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Colors.blueGrey.shade50,
      margin: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "📋 Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const Divider(),
            _summaryRow("Form Number", formNumberController.text),
            _summaryRow("Inspection By", inspectionByController.text),
            _summaryRow("Inspection Date", inspectionDateController.text),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}
