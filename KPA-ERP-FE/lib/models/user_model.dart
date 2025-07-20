import 'package:flutter/foundation.dart';
import 'package:kpa_erp/types/user_types/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserModel extends ChangeNotifier {
  String _userName = '';
  final String _userId = '';
  String _mobileNumber = '';
  String _whatsappNumber = '';
  int _stationCode = 0;
  String _stationName = '';
  String _email = '';
  String _token = '';
  String _userType = '';
  String _refreshToken = '';
  LoginResponse? _loginResponse;
  String _trainNo = '';
  String _selectedDate = '';

  String get userName => _userName;
  String get userId => _userId;
  String get mobileNumber => _mobileNumber;
  String get whatsappNumber => _whatsappNumber;
  int get stationCode => _stationCode;
  String get stationName => _stationName;
  String get email => _email;
  String get token => _token;
  String get refreshToken => _refreshToken;
  String get userType => _userType;
  String get trainNo => _trainNo;
  String get selectedDate => _selectedDate;

  UserModel() {
    loadUserData();
  }

  Future <void> setTrainNo(String trainNo) async {
    _trainNo = trainNo;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('trainNo', trainNo);
    notifyListeners();
  }

  Future<void> setSelectedDate(String date) async {
    _selectedDate = date;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedDate', date);
    notifyListeners();
  }

  Future<void> updateUserDetails({
    String? userName,
    String? email,
    String? mobileNumber,
    String? whatsappNumber,
    int? stationCode,
    String? stationName,
    String? token,
    String? userType,
    String? refreshToken,
    String? trainNo,
    String? selectedDate,
  }) async {
    _userName = userName ?? _userName;
    _email = email ?? _email;
    _mobileNumber = mobileNumber ?? _mobileNumber;
    _whatsappNumber = whatsappNumber ?? _whatsappNumber;
    _stationCode = stationCode ?? _stationCode;
    _stationName = stationName ?? _stationName;
    _token = token ?? _token;
    _userType = userType ?? _userType;
    _refreshToken = refreshToken ?? _refreshToken;
    _trainNo = trainNo ?? _trainNo;
    _selectedDate = selectedDate ?? _selectedDate;
    notifyListeners();
    await _saveUserData();
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (_loginResponse != null) {
      prefs.setString('loginResponse', jsonEncode(_loginResponse!.toJson()));
      prefs.setString('trainNo', _trainNo);
      prefs.setString('selectedDate', _selectedDate);
    }
  }

  String get trimmedUserName {
    return userName.length > 11
        ? userName.substring(0, userName.length - 11)
        : userName;
  }
Future<void> loadUserData() async {
  final prefs = await SharedPreferences.getInstance();
  final loginResponseJson = prefs.getString('loginResponse');
  final googleUserName = prefs.getString('user_name');
  final googleUserEmail = prefs.getString('user_email');

  if (loginResponseJson != null) {
    final decoded = jsonDecode(loginResponseJson);
    _loginResponse = LoginResponse.forState(decoded);
    _userName = _loginResponse!.userName;
    _token = _loginResponse!.token;
    _mobileNumber = _loginResponse!.mobileNumber;
    _whatsappNumber = _loginResponse!.whatsappNumber;
    _stationCode = _loginResponse!.stationCode;
    _stationName = _loginResponse!.stationName;
    _userType = _loginResponse!.userType;
    _refreshToken = _loginResponse!.refreshToken;

    // ✅ Save these again to ensure persistent fingerprint login
    await prefs.setBool('is_logged_in', true);
    await prefs.setString('user_name', _loginResponse!.userName);
    await prefs.setString('loginResponse', jsonEncode(_loginResponse!.toJson()));

    print('Loaded user from loginResponse: $_userName');
  } else if (googleUserName != null && googleUserEmail != null) {
    _userName = googleUserName;
    _email = googleUserEmail;
    _userType = '';
    print('Loaded user from Google sign-in: $_userName');
  } else {
    print('No loginResponse or Google user found');
  }

  _trainNo = prefs.getString('trainNo') ?? '';
  _selectedDate = prefs.getString('selectedDate') ?? '';
  notifyListeners();
}

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('loginResponse');
    prefs.remove('trainNo');
    prefs.remove('selectedDate');
    _userName = '';
    _mobileNumber = '';
    _whatsappNumber = '';
    _stationCode = 0;
    _stationName = '';
    _email = '';
    _token = '';
    _userType = '';
    _refreshToken = '';
    _trainNo = '';
    _selectedDate = '';
    notifyListeners();
  }
}
