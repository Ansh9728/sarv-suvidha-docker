import 'package:flutter/material.dart';
import 'package:kpa_erp/routes.dart';
import 'package:kpa_erp/services/otp_services/sign_up_otp.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});
  @override
  _ForgotPasswordForm createState() => _ForgotPasswordForm();
}

class _ForgotPasswordForm extends State<ForgotPasswordForm> {
  String? _value;
  bool _isLoading = false;
  final String _type = 'forgot_password_otp';
  bool _showModal = false;

  void sendMail() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final sendOtpResponse = await SignUpOtp.sendOtp(_value!, _type);
      setState(() {
        _isLoading = false;
      });
      _showErrorModal(context, sendOtpResponse);
      Future.delayed(const Duration(seconds: 4), () {
        Navigator.pushReplacementNamed(context, Routes.login);
      });
    } catch (e) {
      _showErrorModal(context, '$e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorModal(BuildContext context, String errorMessage) {
    String dialogTitle;
    String dialogMessage;

    if (errorMessage == 'Password reset email sent successfully') {
      dialogTitle = 'Success';
      dialogMessage = errorMessage;
    } else if (errorMessage == 'Unexpected null value.') {
      dialogTitle = 'Error';
      dialogMessage = 'Enter a valid email address';
    } else {
      dialogTitle = 'Error';
      dialogMessage = errorMessage;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(dialogTitle),
          content: Text(dialogMessage),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                setState(() {
                  _showModal = false;
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child:Padding(padding: const EdgeInsets.all(10),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50.0), // Adjusted space for better layout
            const Text(
              "Forgotten your password? Enter your email address below, and we'll email instructions for setting a new one.",
              style: TextStyle(
                  fontSize: 16.0, color: Colors.black87), // Blue text color
              textAlign: TextAlign.center, // Center the text
            ),
            const SizedBox(height: 32.0),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle:
                    TextStyle(color: Colors.black87), // Blue label color
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(0xFF1E88E5)), // Blue border when focused
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (String? value) {
                _value = value!;
              },
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:Colors.blue.shade100, // Blue background color
                foregroundColor: Colors.black87,
                fixedSize: Size(buttonWidth, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                side: const BorderSide(color: Colors.black87, width: 0.5), // Border
              ),
              onPressed: _isLoading ? null : sendMail,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Send Verification Mail',
                      style: TextStyle(
                        fontSize: 16, // Consistent font size
                      ),
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
