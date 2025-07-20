import 'package:flutter/material.dart';
import 'package:kpa_erp/routes.dart';

Widget renderMobileLogInButton(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth * 0.9;
    void _otpLogIn() async {
      await Navigator.pushReplacementNamed(context, Routes.mobileLogin);
    }
    return OutlinedButton(
      style: ElevatedButton.styleFrom(
        // backgroundColor: Color.fromARGB(255, 255, 255, 255),
        foregroundColor: const Color(0xFF313256),
        fixedSize: Size(buttonWidth, 50),
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      ),
      onPressed: _otpLogIn,
      child: const Text(
              'Log in with Mobile Number',
              style: TextStyle(
                // fontWeight: FontWeight.bold
              ),
            ),
    );
  }