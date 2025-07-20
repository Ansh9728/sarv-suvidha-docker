import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpBox extends StatelessWidget {
  final void Function(String) onSaved;
  const OtpBox({super.key, required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return 
          SizedBox(
            height: 72,
            width: 45,
            child: TextFormField(
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter The Otp Digit';
                }
                return null;
              },
              onChanged: (String? value) {
                onSaved(value!);
              },
              
              
              textAlign: TextAlign.center,
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
              contentPadding: EdgeInsets.all(8), // Adjust padding as needed
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey), // Border color
                borderRadius: BorderRadius.circular(8), // Border radius
              ),
            ),
            ),
          );     
  }
}