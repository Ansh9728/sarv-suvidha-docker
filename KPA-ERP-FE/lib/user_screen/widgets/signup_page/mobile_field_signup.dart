import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:kpa_erp/services/otp_services/sign_up_otp.dart';
import 'package:kpa_erp/user_screen/widgets/otp/otp_boxes.dart';
import 'package:kpa_erp/widgets/error_modal.dart';
import 'package:kpa_erp/widgets/loader.dart';
import 'package:kpa_erp/widgets/success_modal.dart';

class MobileFieldSignup extends StatefulWidget {
  final void Function(String mobile, bool isVerified) onSavedAndVerified;
  final String? labelText; // Add labelText parameter

  const MobileFieldSignup({
    super.key, 
    required this.onSavedAndVerified,
    this.labelText, // Make it optional with default value
  });

  @override
  _MobileFieldSignup createState() => _MobileFieldSignup();
}

class _MobileFieldSignup extends State<MobileFieldSignup> {
  final TextEditingController _mobileController = TextEditingController();
  bool _isOtpSend = false;
  bool showOtpBox = false;
  String otp = '';
  bool _isOtpVerified = false;
  bool disableTextField = false;
  Timer? _timer;
  int _start = 0;

  // Keep existing methods unchanged...
  void _startTimer() {
    _start = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _sendOtp({required String type}) async {
    loader(context, "Sending OTP, Please Wait...");
    String value = _mobileController.text.trim();
    try {
      final sendOtpResponse = await SignUpOtp.sendOtp(value, type);
      setState(() {
        _isOtpSend = true;
        showOtpBox = true;
        disableTextField = true;
      });
      _startTimer();
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
    String value = _mobileController.text.trim();
    try {
      final verifyOtpResponse = await SignUpOtp.veirfyOtp(value, otp, type);
      setState(() {
        _isOtpVerified = true;
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
            controller: _mobileController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            decoration: InputDecoration(
              labelText: widget.labelText ?? 'Mobile Number *', // Use provided labelText or default
              hintText: 'Enter your 10-digit mobile number only',
              hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
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
              suffixIcon: SizedBox(
                width: 160,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!_isOtpSend)
                      Container(
                        margin: const EdgeInsets.only(right: 8.0),
                        child: TextButton(
                          onPressed: () {
                            _sendOtp(type: 'phone');
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Colors.blue, width: 2),
                            textStyle: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold , color: Colors.black),
                          ),
                          child: const Text('Send OTP'),
                        ),
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
                            _sendOtp(type: 'phone');
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            backgroundColor: Colors.white,
                            textStyle: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          child: const Text('Resend OTP'),
                        ),
                    ],
                    if (_isOtpVerified)
                      const Row(
                        mainAxisSize: MainAxisSize.min,
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
                return 'Please enter your mobile number';
              }
              return null;
            },
            onSaved: (String? value) {
              widget.onSavedAndVerified(value!, _isOtpVerified);
            },
            onChanged: (value) {
              if (value.length == 10 && !_isOtpSend) {
                _sendOtp(type: 'phone');
              }
            }),
        if (showOtpBox && !_isOtpVerified) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OtpBoxes(onSaved: (value) {
                  otp = value;
                  if (otp.length == 6) {
                    _verifyOtp('phone');
                  }
                }),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.cancel, color: Colors.red),
                onPressed: () {
                  setState(() {
                    disableTextField = false;
                    showOtpBox = false;
                    _isOtpSend = false;
                    _timer?.cancel();
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