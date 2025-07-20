import 'package:flutter/material.dart';
import 'package:kpa_erp/models/auth_model.dart';
import 'package:kpa_erp/routes.dart';
import 'package:kpa_erp/user_screen/form/signup_form.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String appVersion = '';
  @override
  void initState() {
    super.initState();
    _getAppVersion();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authModel = Provider.of<AuthModel>(context, listen: false);
      if (authModel.isAuthenticated) {
        Navigator.pushReplacementNamed(context, Routes.home);
      }
    });
  }

  Future<void> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        appVersion = packageInfo.version;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100, // Background color
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Container(
                  color: Colors.blue.shade100,
                  child: const Center(
                    child: Text(
                      'Sign Up to RailOps',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(40),
                    ),
                  ),
                  child: const SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SignupForm(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 45,
            right: 36,
            child: Text(
              'v$appVersion',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
