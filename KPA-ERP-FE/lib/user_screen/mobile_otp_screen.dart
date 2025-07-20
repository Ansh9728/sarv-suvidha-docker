import 'package:flutter/material.dart';
import 'package:kpa_erp/user_screen/form/otp_form.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MobileOtpScreen extends StatefulWidget {
  const MobileOtpScreen({Key? key}) : super(key: key);

  @override
  _MobileOtpScreenState createState() => _MobileOtpScreenState();
}

class _MobileOtpScreenState extends State<MobileOtpScreen> {
  String appVersion = '';

  @override
  void initState() {
    super.initState();
    _getAppVersion();
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
    final String mobileNumber = ModalRoute.of(context)?.settings.arguments as String;
    
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
            Navigator.pushReplacementNamed(context, '/mobile-login');
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           const Center(
            child: Text(
                  "Enter OTP",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold
                  ),
             
                ),
            ),
            const SizedBox(height: 16),
            Text(
              'Please enter the OTP sent to your mobile number: $mobileNumber',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const OtpForm(),
          ],
        ),
      ),
    );
  }
}