import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kpa_erp/models/auth_model.dart';
import 'package:kpa_erp/models/user_model.dart';
import 'package:kpa_erp/provider/auth_provider.dart';
import 'package:kpa_erp/routes.dart';
import 'package:kpa_erp/services/authentication_services/auth_service.dart';
import 'package:kpa_erp/user_screen/widgets/login_page/mobile_login_button.dart';
import 'package:kpa_erp/user_screen/widgets/login_page/mobile_number_field.dart';
import 'package:kpa_erp/user_screen/widgets/login_page/password_field.dart';
import 'package:kpa_erp/user_screen/widgets/login_page/privacy_policies.dart';
import 'package:kpa_erp/user_screen/widgets/login_page/signup_button.dart';
import 'package:kpa_erp/utils/permission_handler_service.dart';
import 'package:kpa_erp/utils/show_location_permission_disclosure.dart';
import 'package:kpa_erp/widgets/error_modal.dart';
import 'package:kpa_erp/widgets/loader.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late String _mobileNumber;
  late String _password;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    PermissionHandlerService permissionService = PermissionHandlerService();
    bool isLocationGranted = await permissionService
        .isLocationPermissionGranted();
    // await permissionService.requestIgnoreBatteryOptimization();

    if (!isLocationGranted) {
      showLocationPermissionDisclosure(context, () async {
        bool isAccepted = await permissionService.requestLocationPermission(
          context,
        );
        // if (!isAccepted) {
        //   showErrorModal(context, 'Location permission is required to use this app.', "Permission Denied", () {});
        // }
      });
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      loader(context, "Logging in... Please wait.");
      final loginResponse = await AuthService.login(_mobileNumber, _password);
      final authModel = Provider.of<AuthModel>(context, listen: false);
      final userModel = Provider.of<UserModel>(context, listen: false);

      authModel.login(loginResponse!);
      userModel.updateUserDetails(
        userName: loginResponse.userName,
        mobileNumber: loginResponse.mobileNumber,
        stationCode: loginResponse.stationCode,
        stationName: loginResponse.stationName,
        token: loginResponse.token,
        userType: loginResponse.userType,
        refreshToken: loginResponse.refreshToken,
      );

      Navigator.of(context)
        ..pop()
        ..pushReplacementNamed(Routes.home);
    } catch (e) {
      Navigator.of(context).pop();
      if (!(e is StateError && e.toString().contains('mounted'))) {
        showErrorModal(context, '$e', "Error", () {});
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _forgotPass() {
    Navigator.pushReplacementNamed(context, Routes.forgotPassword);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth * 0.9;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            MobileNumberField(onSaved: (value) => _mobileNumber = value),
            const SizedBox(height: 20),
            PasswordField(onSaved: (value) => _password = value),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue.shade800,
                ),
                onPressed: _forgotPass,
                child: const Text('Forgot Password'),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade100,
                foregroundColor: Colors.black87,
                side: const BorderSide(color: Colors.black87, width: 0.5),
                fixedSize: Size(buttonWidth, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: _submitForm,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.black87)
                  : const Text(
                      'Log in',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            const Divider(color: Color.fromARGB(255, 191, 191, 191)),
            const SizedBox(height: 20),
            Column(
              children: [
                renderMobileLogInButton(context),
                const SizedBox(height: 12),

                if (!kIsWeb)
                  ElevatedButton(
                    onPressed: authProvider.isGoogleSigningIn
                        ? null
                        : () {
                            authProvider.signInWithGoogle(context);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      side: const BorderSide(
                        color: Color(0xFF313256),
                        width: 0.5,
                      ),
                    ),
                    child: authProvider.isGoogleSigningIn
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.black,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/google.png',
                                height: 24,
                                width: 24,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "Sign in with Google",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                  ),

                // const SizedBox(height: 15),
                // renderGoogleSignInButton(context),
                const SizedBox(height: 20),
                renderSignUpButton(context),
                const SizedBox(height: 20),
                privacyPolicyRender(context),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
