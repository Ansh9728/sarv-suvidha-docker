import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kpa_erp/routes.dart';
import 'package:kpa_erp/services/otp_services/sign_up_otp.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LoginMobileScreen extends StatefulWidget {
  const LoginMobileScreen({super.key});

  @override
  _LoginMobileScreen createState() => _LoginMobileScreen();
}

class _LoginMobileScreen extends State<LoginMobileScreen> {
  final TextEditingController _mobileController = TextEditingController();
  late String _mobileNumber;
  String? value;
  String? type;
  bool _isLoading = false;
  bool _showErrorModal = false;
  String _errorMessage = '';
  String appVersion = '';
  
  @override
  void initState() {
    super.initState();
    _getAppVersion();
    _mobileController.addListener(() {
      if (_mobileController.text.length == 10 && !_isLoading) {
        _mobileNumber = _mobileController.text;
        _sendOtp();
      }
    });
  }

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        appVersion = packageInfo.version;
      });
    }
  }

  void _sendOtp() async {
    setState(() {
      _isLoading = true;
    });

    type = 'phone_number';
    value = _mobileNumber;

    try {
      final sendOtpResponse = await SignUpOtp.sendOtp(value!, type!);
      Navigator.pushReplacementNamed(context, Routes.otpEnter,
          arguments: _mobileNumber);
    } catch (e) {
      if (e is StateError && e.toString().contains('mounted')) {
        print('Widget disposed before operation completes');
      } else {
        print('Send Otp Failed: $e');
        _showErrorModalDialog(context, '$e');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorModalDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                setState(() {
                  _showErrorModal = false;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth * 0.8;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        title: SizedBox(
          height: MediaQuery.of(context).size.height * 2,
          child: Container(
            color: Colors.white.withOpacity(0.1),
            child: const Center(
              child: Text(
                'Mobile OTP Login',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
             
            ),
          ),
        ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, Routes.login);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30.0, top: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 2),
                Text(
                  'v$appVersion',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Please enter your phone number',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number',
                    hintText: 'Enter your 10-digit mobile number only',
                    hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 32),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}