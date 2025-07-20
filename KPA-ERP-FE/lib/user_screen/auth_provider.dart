// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthProvider extends ChangeNotifier {
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   User? user;
//   final LocalAuthentication _auth = LocalAuthentication();

//   bool isAuthenticated = false;
//   bool showPasswordFallback = false;
//   String password = '';
//   BiometricType? biometricType;
//   bool _isGoogleSigningIn = false;
//   bool get isGoogleSigningIn => _isGoogleSigningIn;
//   LoginProvider() {
//     _detectBiometricType();
//   }
   

//     bool _isEnabled = false;
//   bool get isEnabled => _isEnabled;

//   FingerprintProvider() {
//     _loadPreference();
//   }

//   Future<void> _loadPreference() async {
//     final prefs = await SharedPreferences.getInstance();
//     _isEnabled = prefs.getBool('use_fingerprint') ?? false;
//     notifyListeners();
//   }

//   Future<void> toggle(bool value) async {
//     final prefs = await SharedPreferences.getInstance();
//     _isEnabled = value;
//     await prefs.setBool('use_fingerprint', value);
//     notifyListeners();
//   }
  
//   Future<void> _detectBiometricType() async {
//     final types = await _auth.getAvailableBiometrics();
//     if (types.contains(BiometricType.face)) {
//       biometricType = BiometricType.face;
//     } else if (types.contains(BiometricType.fingerprint)) {
//       biometricType = BiometricType.fingerprint;
//     }
//     notifyListeners();
//   }

// Future<void> signInWithGoogle(BuildContext context) async {
//   _isGoogleSigningIn = true;
//   notifyListeners();

//   try {
//     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

//     if (googleUser == null) {
//       _showSnackBar(context, "Google sign-in cancelled");
//       _isGoogleSigningIn = false;
//       notifyListeners();
//       return;
//     }

//     final GoogleSignInAuthentication googleAuth =
//         await googleUser.authentication;

//     final credential = firebase_auth.GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );

//     final firebaseUser = await firebase_auth.FirebaseAuth.instance
//         .signInWithCredential(credential);

//     if (firebaseUser.user != null) {
//       final displayName = firebaseUser.user?.displayName ?? "User";

//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('user_name', displayName);

//       user = User(firstName: displayName);

//       _isGoogleSigningIn = false;
//       notifyListeners();

//       _showSnackBar(context, "Signed in as $displayName");
//       Navigator.of(context).pushReplacementNamed(Routes.attendance);
//     } else {
//       _isGoogleSigningIn = false;
//       notifyListeners();
//       _showSnackBar(context, "Google sign-in failed");
//     }
//   } catch (e) {
//     _isGoogleSigningIn = false;
//     notifyListeners();
//     _showSnackBar(context, "Google sign-in error: ${e.toString()}");
//   }
// }

//   void setPassword(String value) {
//     password = value;
//     notifyListeners();
//   }

//   void loginWithPassword(BuildContext context) {
//     if (password == '1234') {
//       isAuthenticated = true;
//       notifyListeners();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Login Successful')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Invalid PIN')),
//       );
//     }
//   }

//   void showPinFallback() {
//     showPasswordFallback = true;
//     notifyListeners();
//   }

//   Future<void> logout() async {
//     isAuthenticated = false;
//     password = '';
//     showPasswordFallback = false;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('remember_me');
//     notifyListeners();
//   }

// //   Future<void> signInWithGoogle(BuildContext context) async {
// //   _isGoogleSigningIn = true;
// //   notifyListeners();

// //   try {
// //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

// //     if (googleUser == null) {
// //       _showSnackBar(context, "Google sign-in cancelled");
// //       _isGoogleSigningIn = false;
// //       notifyListeners();
// //       return;
// //     }

// //     final GoogleSignInAuthentication googleAuth =
// //         await googleUser.authentication;

// //     final credential = firebase_auth.GoogleAuthProvider.credential(
// //       accessToken: googleAuth.accessToken,
// //       idToken: googleAuth.idToken,
// //     );

// //     final firebaseUser = await firebase_auth.FirebaseAuth.instance
// //         .signInWithCredential(credential);

// //     if (firebaseUser.user != null) {
// //       final displayName = firebaseUser.user?.displayName ?? "User";

// //       final prefs = await SharedPreferences.getInstance();
// //       await prefs.setString('user_name', displayName);

// //       user = User(firstName: displayName);

// //       _isGoogleSigningIn = false;
// //       notifyListeners();

// //       _showSnackBar(context, "Signed in as $displayName");
// //       Navigator.of(context).pushReplacementNamed(Routes.attendance);
// //     } else {
// //       _isGoogleSigningIn = false;
// //       notifyListeners();
// //       _showSnackBar(context, "Google sign-in failed");
// //     }
// //   } catch (e) {
// //     _isGoogleSigningIn = false;
// //     notifyListeners();
// //     _showSnackBar(context, "Google sign-in error: ${e.toString()}");
// //   }
// // }

//   void _showSnackBar(BuildContext context, String message) {
//     final snackBar = SnackBar(
//       content: Text(message),
//       behavior: SnackBarBehavior.floating,
//       backgroundColor: Colors.deepPurple,
//       duration: const Duration(seconds: 3),
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
// }
