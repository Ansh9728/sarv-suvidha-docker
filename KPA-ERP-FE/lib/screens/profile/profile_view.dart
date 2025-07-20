import 'package:flutter/material.dart';
import 'package:kpa_erp/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:kpa_erp/models/auth_model.dart';
import 'package:kpa_erp/routes.dart';
import 'package:kpa_erp/services/authentication_services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      final authModel = Provider.of<AuthModel>(context, listen: false);
      try {
        await AuthService.logout(
          authModel.loginResponse!.refreshToken,
          authModel.loginResponse!.token,
        );
      } catch (_) {}
      await authModel.logout();
      Navigator.pushReplacementNamed(context, Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authModel = Provider.of<AuthModel>(context);
    final user = authModel.loginResponse;

    // Check if user or required data is missing
    final bool isDataMissing =
        user == null ||
        user.userName.trim().isEmpty ||
        user.mobileNumber.trim().isEmpty ||
        user.userType.trim().isEmpty;

    if (isDataMissing) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          backgroundColor: Colors.indigo,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.person_off, size: 80, color: Colors.grey),
              SizedBox(height: 20),
              Text(
                "⚠️ No profile data available",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    // ✅ Original Profile UI below
    return Scaffold(
      backgroundColor: Colors.white,
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
          title: const Text(
            "Profile",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildReadOnlyField(label: "User Name", value: user.userName),
                _buildReadOnlyField(
                  label: "Mobile Number",
                  value: user.mobileNumber,
                ),
                _buildReadOnlyField(
                  label: "WhatsApp Number",
                  value: user.whatsappNumber,
                ),
                _buildReadOnlyField(label: "User Type", value: user.userType),
                Consumer<AuthProvider>(
                  builder: (context, fp, _) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              'Enable Fingerprint Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Switch.adaptive(
                            value: fp.isEnabled,
                            onChanged: (val) => fp.toggle(val),
                            activeColor: Colors.indigo,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _confirmLogout(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        controller: TextEditingController(text: value),
      ),
    );
  }
}
