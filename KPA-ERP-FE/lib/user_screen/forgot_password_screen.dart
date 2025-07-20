import 'package:flutter/material.dart';
import 'form/forgot_password_form.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forgotten Password',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon:const Icon(Icons.arrow_back), 
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: ForgotPasswordForm(),
      ),
    );
  }
}