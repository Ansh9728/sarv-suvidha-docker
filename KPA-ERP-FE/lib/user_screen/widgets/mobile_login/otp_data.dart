import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpData extends StatefulWidget {
  const OtpData({super.key, required this.onOtpChanged});
  final void Function(String) onOtpChanged;

  @override
  _OtpData createState() => _OtpData();
}

class _OtpData extends State<OtpData> {
  String otp = '';

  void updateOtp(String pin) {
    setState(() {
      otp = pin;
    });
    widget.onOtpChanged(otp);
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

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
    );

    return Center(
      child: Pinput(
        length: 6,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        submittedPinTheme: submittedPinTheme,
        showCursor: true,
        onChanged: (String pin) {
          updateOtp(pin);
        },
        onCompleted: (pin) {
          updateOtp(pin);
        },
      ),
    );
  }
}