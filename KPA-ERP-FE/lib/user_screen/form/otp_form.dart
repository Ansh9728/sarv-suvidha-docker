import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kpa_erp/models/auth_model.dart';
import 'package:kpa_erp/models/user_model.dart';
import 'package:kpa_erp/routes.dart';
import 'package:kpa_erp/services/authentication_services/auth_service.dart';
import 'package:kpa_erp/services/otp_services/sign_up_otp.dart';
import 'package:kpa_erp/widgets/success_modal.dart';
import 'package:provider/provider.dart';

class OtpData extends StatefulWidget {
  final Function(String) onOtpChanged;

  const OtpData({Key? key, required this.onOtpChanged}) : super(key: key);

  @override
  OtpDataState createState() => OtpDataState();
}

class OtpDataState extends State<OtpData> {
  List<TextEditingController> controllers =
      List.generate(6, (index) => TextEditingController());
  List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    // Add listeners to controllers
    for (int i = 0; i < controllers.length; i++) {
      controllers[i].addListener(() => _onOtpChanged());
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged() {
    String otp = controllers.map((controller) => controller.text).join();
    widget.onOtpChanged(otp);
  }

  // Method to clear all OTP fields
  void clearOtp() {
    for (var controller in controllers) {
      controller.clear();
    }
    // Reset focus to first field
    if (mounted) {
      FocusScope.of(context).requestFocus(focusNodes[0]);
    }
  }

  // Handle backspace key press
  bool _handleKeyEvent(KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (controllers[index].text.isEmpty && index > 0) {
        // If current field is empty and backspace is pressed, move to previous field and clear it
        controllers[index - 1].clear();
        FocusScope.of(context).requestFocus(focusNodes[index - 1]);
        return true; // Consume the event
      } else if (controllers[index].text.isNotEmpty) {
        // If current field has content, clear it but stay in the same field
        controllers[index].clear();
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return Container(
          width: 45,
          height: 55,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) => _handleKeyEvent(event, index),
            child: TextField(
              controller: controllers[index],
              focusNode: focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter
                    .digitsOnly, // Restrict to numbers only
              ],
              maxLength: 1,
              decoration: const InputDecoration(
                counterText: "",
                border: InputBorder.none,
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  // When a digit is entered, move to next field if not the last one
                  if (index < 5) {
                    FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                  }
                }
              },
            ),
          ),
        );
      }),
    );
  }
}

class OtpForm extends StatefulWidget {
  const OtpForm({super.key});

  @override
  _OtpForm createState() => _OtpForm();
}

class _OtpForm extends State<OtpForm> {
  String otp = '';
  String? mobileNumber;
  bool _isLoadingConfirm = false;
  bool _isLoadingResend = false;
  bool _showModal = false;
  Timer? _timer;
  int _start = 60; // Timer for 1 minute (60 seconds)
  String? value;
  String? type;

  // Add a GlobalKey to control the OtpData widget
  final GlobalKey<OtpDataState> _otpDataKey = GlobalKey<OtpDataState>();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _isLoadingResend = true;
      _start = 60;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isLoadingResend = false;
        });
        timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as String?;
    if (args != null && mobileNumber == null) {
      setState(() {
        mobileNumber = args;
      });
    }
  }

  void _resendOtp() async {
    // Clear the OTP input field and reset the otp variable
    _otpDataKey.currentState?.clearOtp();
    setState(() {
      otp = '';
    });

    _startTimer();
    type = 'phone_number';
    value = mobileNumber;
    try {
      final sendOtpResponse = await SignUpOtp.sendOtp(value!, type!);
      showSuccessModal(context, 'OTP resent successfully', "Success", () {});
    } catch (e) {
      _showErrorModal(context, 'Failed to resend OTP: $e');
    }
  }

  void _showErrorModal(BuildContext context, String errorMessage) {
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

  void _submitOtp() async {
    setState(() {
      _isLoadingConfirm = true;
    });
    try {
      final loginResponse = await AuthService.loginByMobile(otp, mobileNumber!);
      Provider.of<AuthModel>(context, listen: false).login(loginResponse!);
      Provider.of<UserModel>(context, listen: false).updateUserDetails(
        userName: loginResponse.userName,
        mobileNumber: loginResponse.mobileNumber,
        stationCode: loginResponse.stationCode,
        stationName: loginResponse.stationName,
        token: loginResponse.token,
        userType: loginResponse.userType,
        refreshToken: loginResponse.refreshToken,
      );
      Navigator.pushReplacementNamed(context, Routes.home);
    } catch (e) {
      if (e is StateError && e.toString().contains('mounted')) {
        print('Widget disposed before operation completes');
      } else {
        print('Login Error: $e');
        _showErrorModal(context, '$e');
        // Clear OTP field when login fails due to incorrect OTP
        _otpDataKey.currentState?.clearOtp();
        setState(() {
          otp = '';
        });
      }
    } finally {
      setState(() {
        _isLoadingConfirm = false;
      });
    }
  }

  void _handleOtpChange(String newOtp) {
    setState(() {
      otp = newOtp;
    });
    if (otp.length == 6 && !_isLoadingConfirm) {
      _submitOtp();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth * 0.8; // Adjusted for column layout

    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OtpData(
            key: _otpDataKey,
            onOtpChanged: _handleOtpChange,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Column(
              children: [
                const SizedBox(height: 20), // Spacing between buttons
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1E88E5),
                    side: const BorderSide(color: Color(0xFF1E88E5)),
                    fixedSize: Size(buttonWidth, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isLoadingResend ? null : _resendOtp,
                  icon: const Icon(Icons.refresh, color: Color(0xFF1E88E5)),
                  label: _isLoadingResend
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 10),
                            Text(
                              'Resend ($_start)',
                              style: const TextStyle(
                                color: Color(
                                    0xFF1E88E5), // More visible text color
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : const Text(
                          'Resend',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E88E5), // More visible text color
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
