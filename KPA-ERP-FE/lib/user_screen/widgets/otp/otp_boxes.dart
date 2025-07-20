import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

class OtpBoxes extends StatefulWidget {
  final void Function(String) onSaved;

  const OtpBoxes({
    Key? key,
    required this.onSaved,
  }) : super(key: key);

  @override
  _OtpBoxesState createState() => _OtpBoxesState();
}

class _OtpBoxesState extends State<OtpBoxes> {
  final TextEditingController _otpController = TextEditingController();
  String otp = '';
  bool isOtpCompleted = false;

  // Method to clear OTP input
  void clearOtp() {
    setState(() {
      _otpController.clear();
      otp = '';
      isOtpCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue, width: 2),
      ),
    );

    return Column(
      children: [
        Pinput(
          controller: _otpController,
          length: 6,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly, // Restrict to numbers only
          ],
          onChanged: (String? value) {
            setState(() {
              otp = value!;
              isOtpCompleted = value.length == 6;
            });
          },
          showCursor: true,
          onCompleted: (pin) {
            setState(() {
              otp = pin;
              isOtpCompleted = true;
              widget.onSaved(pin); // Save the OTP value when completed
            });
          },
        ),
        if (isOtpCompleted)
          TextButton(
            onPressed: () {
              clearOtp();
            },
            child: const Text('Re-enter OTP'),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }
}