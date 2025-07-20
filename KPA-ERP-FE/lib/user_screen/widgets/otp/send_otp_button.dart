import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';


class SendOtpButton extends StatefulWidget { 
  final void Function(bool) onSaved;
  final String ? mobileNumber;
  final String ? email;

  const SendOtpButton({Key? key, required this.onSaved, this.mobileNumber,this.email,}) : super(key: key);

  @override
  _SendOtpButton createState() => _SendOtpButton();
}

class _SendOtpButton extends State<SendOtpButton> {
  bool _isOtpSend=false;

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
        child: _isOtpSend
            ? const CircularProgressIndicator()
            : const Text('Send OTP'),
      ),
    );
  }
}
