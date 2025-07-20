// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:provider/provider.dart';

// Widget renderGoogleSignInButton(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double buttonWidth = screenWidth * 0.9;
//     final clientId =
//       '673131287683-5jjd1052v51h3de340oo2g7ampsbln2b.apps.googleusercontent.com';
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//       clientId:
//           '673131287683-5jjd1052v51h3de340oo2g7ampsbln2b.apps.googleusercontent.com',
//       scopes: [
//         'email',
//         'https://www.googleapis.com/auth/userinfo.profile',
//       ]);
//   GoogleSignInAccount? googleUser;
//     void googleSignIn() async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) {
//         return;
//       }
//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;
//       final String? authToken = googleAuth.idToken;
//       try {
//         final loginResponse = await AuthService.loginWithGoogle(authToken!);
//         Provider.of<AuthModel>(context, listen: false).login(loginResponse!);
//         Provider.of<UserModel>(context, listen: false).updateUserDetails(
//           userName: loginResponse.userName,
//           mobileNumber: loginResponse.mobileNumber,
//           stationCode: loginResponse.stationCode,
//           stationName: loginResponse.stationName,
//           token: loginResponse.token,
//           userType: loginResponse.userType,
//           refreshToken: loginResponse.refreshToken,
//         );
//         Navigator.pushReplacementNamed(context, Routes.home);
//       } catch (e) {
//         if (e is StateError && e.toString().contains('mounted')) {
//           print('Widget disposed before operation completes');
//         } else {
//           showErrorModal(context, '$e', "Error", () {
            
//           });
//         }
//       }
//     } catch (error) {
//       showErrorModal(context, '$error', "Error", () {
       
//       });
//     }
//   }
//     return OutlinedButton(
//       onPressed: googleSignIn,
//       style: OutlinedButton.styleFrom(
//         fixedSize: Size(buttonWidth, 50),
//         padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
//         shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Image.asset(
//             'assets/images/google.png',
//             height: 20.0,
//           ),
//           const SizedBox(width: 8.0),
//           const Text('Sign in with Google',style: TextStyle(
//                 fontWeight: FontWeight.bold
//               ),),
//         ],
//       ),
//     );
//   }