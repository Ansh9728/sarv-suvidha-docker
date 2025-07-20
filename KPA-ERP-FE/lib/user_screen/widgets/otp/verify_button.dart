import 'package:flutter/material.dart';


class VerifyButton extends StatefulWidget { 
  final void Function(bool) onSaved;
  final String ? mobileNumber;
  final String ? email;
  final String otp;

  const VerifyButton({Key? key, required this.onSaved, this.mobileNumber,this.email,required this.otp}) : super(key: key);

  @override
  _VerifyButton createState() => _VerifyButton();
}

class _VerifyButton extends State<VerifyButton> {
  bool _isOtpVerified=false;
  @override
  Widget build(BuildContext context) {
    return
   Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          side: BorderSide(color: Colors.black, width: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          // if (widget.mobileNumber != null && widget.mobileNumber!.isNotEmpty) {
          //   _sendOtp('phone');
          // } else {
          //   _sendOtp('email');
          // }
        },
        child: _isOtpVerified
            ? const CircularProgressIndicator()
            : const Text('Verify OTP'),
      ),
    );
  }
}
