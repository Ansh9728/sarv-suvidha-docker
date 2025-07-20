import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kpa_erp/models/auth_model.dart';
import 'package:kpa_erp/routes.dart';
import 'package:kpa_erp/user_screen/form/login_form.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String appVersion = '';
 @override
void initState() {
  super.initState();
  _getAppVersion();
  
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final prefs = await SharedPreferences.getInstance();
    final useFingerprint = prefs.getBool('use_fingerprint') ?? false;
    final storedLogin = prefs.getString('loginResponse');

    final authModel = Provider.of<AuthModel>(context, listen: false);

    if (authModel.isAuthenticated) {
      Navigator.pushReplacementNamed(context, Routes.home);
      return;
    }

    if (useFingerprint && storedLogin != null) {
      final localAuth = LocalAuthentication();

      final isSupported = await localAuth.isDeviceSupported();
      final canAuthenticate = await localAuth.canCheckBiometrics;

      if (isSupported && canAuthenticate) {
        try {
          final didAuthenticate = await localAuth.authenticate(
            localizedReason: 'Login using fingerprint',
            options: const AuthenticationOptions(stickyAuth: true),
          );

          if (didAuthenticate) {
            final decoded = jsonDecode(storedLogin);
            authModel.setFromStoredLogin(decoded);
            Navigator.pushReplacementNamed(context, Routes.home);
          }
        } on PlatformException catch (e) {
          debugPrint('⚠️ Biometric auth error: ${e.message}');
          // Optionally show a fallback UI or toast
        }
      } else {
        debugPrint('❌ Biometrics not supported or not set up.');
        // You could prompt user to set up biometrics or fallback to PIN login
      }
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
      backgroundColor: Colors.blue.shade100,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Container(
                  color: Colors.white.withOpacity(0.1),
                  child: const Center(
                    child: Text(
                      'Welcome to KPA-ERP',
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
                        LoginForm(),
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
