import 'package:flutter/material.dart';
import 'package:kpa_erp/routes.dart';

Widget renderSignUpButton(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double buttonWidth = screenWidth * 0.9;
  void _signUp() {
    Navigator.pushNamed(context, Routes.signUp);
  }

  return OutlinedButton(
    style: OutlinedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.blue,
      fixedSize: Size(buttonWidth, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    onPressed: _signUp,
    child: const Text('New User? Sign Up Here',style: TextStyle(
              ),),
  );
}
