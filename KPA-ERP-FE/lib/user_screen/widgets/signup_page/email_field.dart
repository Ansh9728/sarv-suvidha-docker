import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kpa_erp/services/otp_services/sign_up_otp.dart';
import 'package:kpa_erp/user_screen/widgets/otp/otp_boxes.dart';
import 'package:kpa_erp/widgets/error_modal.dart';
import 'package:kpa_erp/widgets/loader.dart';
import 'package:kpa_erp/widgets/success_modal.dart';

class EmailField extends StatefulWidget {
  final void Function(String email, bool isVerified) onSavedAndVerified;

  EmailField({super.key, required this.onSavedAndVerified});

  @override
  _EmailFieldState createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  final TextEditingController _emailController = TextEditingController();
  bool _isOtpSend = false;
  bool showOtpBox = false;
  String otp = '';
  bool _isOtpVerified = false;
  bool disableTextField = false;
  Timer? _timer;
  int _start = 60;

  void _sendOtp({required String type}) async {
    loader(context, "Sending OTP, Please Wait...");
    String value = _emailController.text.trim();
    try {
      final sendOtpResponse = await SignUpOtp.sendOtp(value, type);
      setState(() {
        _isOtpSend = true;
        showOtpBox = true;
        disableTextField = true;
        _startTimer();
      });
      Navigator.of(context).pop();
      showSuccessModal(
        context,
        sendOtpResponse,
        "Success",
        () {},
      );
    } catch (e) {
      Navigator.of(context).pop();
      showErrorModal(context, '$e', "Error", () {});
      if (e is StateError && e.toString().contains('mounted')) {
        print('Widget disposed before operation completes');
      } else {
        print('Send Otp Failed: $e');
      }
    }
  }

  void _verifyOtp(String type) async {
    loader(context, "Verifying OTP, Please Wait...");
    String value = _emailController.text.trim();
    try {
      final verifyOtpResponse = await SignUpOtp.veirfyOtp(value, otp, type);
      setState(() {
        _isOtpVerified = true;
        _timer?.cancel();
      });
      Navigator.of(context).pop();
      showSuccessModal(
        context,
        verifyOtpResponse,
        "Success",
        () {
          widget.onSavedAndVerified(value, _isOtpVerified);
        },
      );
    } catch (e) {
      Navigator.of(context).pop();
      showErrorModal(context, "$e", "Error", () {});
      if (e is StateError && e.toString().contains('mounted')) {
        print('Widget disposed before operation completes');
      } else {
        print('Verification Failed: $e');
      }
    }
  }

  void _startTimer() {
    setState(() {
      _start = 60;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_start > 0) {
          _start--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Column(
    children: [
      TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.blue,
              width: 2.0,
            ),
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8.0), // Reduce padding to minimize gap
            child: Row(
              mainAxisSize: MainAxisSize.min, // Adjust mainAxisSize
              children: [
                if (!_isOtpSend)
                  TextButton(
                    onPressed: () {
                      _sendOtp(type: 'email');
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      backgroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Send OTP'),
                  ),
                if (_isOtpSend && !_isOtpVerified) ...[
                  if (_start > 0)
                    Text(
                      'Resend OTP in $_start s',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    )
                  else
                    TextButton(
                      onPressed: () {
                        _sendOtp(type: 'email');
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        backgroundColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      child: const Text('Resend OTP'),
                    ),
                ],
                if (_isOtpVerified)
                  const Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 24,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Verified',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        readOnly: disableTextField,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          return null;
        },
        onSaved: (String? value) {
          widget.onSavedAndVerified(value!, _isOtpVerified);
        },
      ),
      if (showOtpBox && !_isOtpVerified) ...[
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OtpBoxes(
                  onSaved: (value) {
                      otp = value;
                      if (otp.length == 6) {
                        _verifyOtp('email'); 
                      }
                    },
                ),
            ),
            // const SizedBox(width: 8),
            // IconButton(
            //   icon: Icon(Icons.check, color: Colors.green),
            //   onPressed: () {
            //     _verifyOtp('email');
            //   },
            // ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.cancel, color: Colors.red),
              onPressed: () {
                setState(() {
                  disableTextField = false;
                  showOtpBox = false;
                  _isOtpSend = false;
                  _timer?.cancel(); // Cancel the timer if OTP is canceled
                });
              },
            ),
          ],
        )
      ],
    ],
  );
}
}
