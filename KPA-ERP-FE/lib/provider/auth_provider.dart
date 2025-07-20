import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kpa_erp/screens/Home_screen/home_screen.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.standard();
  final LocalAuthentication _localAuth = LocalAuthentication();

  User? user;
  bool isGoogleSigningIn = false;
  bool _useFingerprint = false;
  bool get isLoggedIn => user != null;
  bool get useFingerprint => _useFingerprint;

  bool _isEnabled = false;
  bool get isEnabled => _isEnabled;

  BiometricType? biometricType;

  AuthProvider() {
    _loadFingerprintPreference();
    _detectBiometricType();
  }

    Future<void> toggle(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    _isEnabled = value;
    await prefs.setBool('use_fingerprint', value);
    notifyListeners();
  }

  Future<void> _loadFingerprintPreference() async {
    final prefs = await SharedPreferences.getInstance();
    _useFingerprint = prefs.getBool('use_fingerprint') ?? false;
    notifyListeners();
  }

  Future<void> toggleFingerprint(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    _useFingerprint = value;
    await prefs.setBool('use_fingerprint', value);
    notifyListeners();
  }

  Future<void> _detectBiometricType() async {
    final types = await _localAuth.getAvailableBiometrics();
    if (types.contains(BiometricType.face)) {
      biometricType = BiometricType.face;
    } else if (types.contains(BiometricType.fingerprint)) {
      biometricType = BiometricType.fingerprint;
    }
    notifyListeners();
  }

  Future<void> loginWithFingerprint(BuildContext context) async {
    try {
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isAvailable = await _localAuth.isDeviceSupported();

      if (!canCheckBiometrics || !isAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometric not available')),
        );
        return;
      }

      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Scan your fingerprint to login',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fingerprint authentication failed')),
        );
      }
    } catch (e) {
      debugPrint("Fingerprint error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fingerprint login failed: ${e.toString()}")),
      );
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      isGoogleSigningIn = true;
      notifyListeners();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isGoogleSigningIn = false;
        notifyListeners();
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential authResult = await _auth.signInWithCredential(credential);
      user = authResult.user;

      isGoogleSigningIn = false;
      notifyListeners();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      isGoogleSigningIn = false;
      notifyListeners();

      debugPrint("Login failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: ${e.toString()}")),
      );
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    user = null;
    notifyListeners();
  }
}
