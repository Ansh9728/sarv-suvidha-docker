import 'package:flutter/foundation.dart';
import 'package:kpa_erp/services/authentication_services/jwt_service.dart';
import 'package:kpa_erp/types/user_types/login_response.dart';
import 'package:kpa_erp/utils/fetch_location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:workmanager/workmanager.dart';

class AuthModel extends ChangeNotifier {
  bool _isAuthenticated = false;
  LoginResponse? _loginResponse;

  bool get isAuthenticated => _isAuthenticated;
  LoginResponse? get loginResponse => _loginResponse;

  AuthModel() {
    loadAuthState();
  }

  Future<void> login(LoginResponse loginResponse) async {
    _isAuthenticated = true;
    _loginResponse = loginResponse;

    // Extract and store user ID from JWT token
    if (loginResponse.token.isNotEmpty) {
      debugPrint('🔍 Extracting user ID from JWT token...');
      JwtService.debugJwtPayload(loginResponse.token);
      await JwtService.extractAndStoreUserId(loginResponse.token);
    }

    // if (!kIsWeb) {
    //   await LocationTracker.startTracking();
    // }

    notifyListeners();
    await _saveAuthState();
  }

  Future<void> signup() async {
    _isAuthenticated = false;
    _loginResponse = null;
    notifyListeners();
  }
Future<void> setFromStoredLogin(Map<String, dynamic> json) async {
  _loginResponse = LoginResponse.forState(json);
  _isAuthenticated = true;

  // Store the user ID again from token
  if (_loginResponse!.token.isNotEmpty) {
    JwtService.debugJwtPayload(_loginResponse!.token);
    await JwtService.extractAndStoreUserId(_loginResponse!.token);
  }

  // if (!kIsWeb) {
  //   await LocationTracker.startTracking();
  // }

  notifyListeners();
  await _saveAuthState();
}



 Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  final useFingerprint = prefs.getBool('use_fingerprint') ?? false;

  _isAuthenticated = false;
  _loginResponse = null;
  notifyListeners();

  if (!useFingerprint) {
    await _clearAuthState(); 
  } else {
    // only clear partial state
    prefs.remove('isAuthenticated');
    prefs.remove('authToken');
  }

  // if (!kIsWeb) {
  //   await LocationTracker.stopTracking();
  // }
}

  Future<void> _saveAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isAuthenticated', _isAuthenticated);
    if (_loginResponse != null) {
      prefs.setString('loginResponse', jsonEncode(_loginResponse!.toJson()));
      prefs.setString('authToken', _loginResponse!.token);
    }
  }

  Future<void> loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    if (_isAuthenticated) {
      final loginResponseJson = prefs.getString('loginResponse');
      if (loginResponseJson != null) {
        _loginResponse = LoginResponse.forState(jsonDecode(loginResponseJson));
      }
    }
    notifyListeners();
  }

  Future<void> _clearAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('isAuthenticated');
    prefs.remove('loginResponse');
    prefs.remove('lastRoute');
    prefs.remove('authToken');
    prefs.remove('user_id'); // Clear stored user ID
    await Workmanager().cancelAll();
  }
}
