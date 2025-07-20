import 'dart:async';
import 'dart:convert';

import 'package:kpa_erp/services/api_services/api_exception.dart';
import 'package:kpa_erp/services/api_services/api_service.dart';
import 'package:kpa_erp/types/user_types/login_mobile_request.dart';
import 'package:kpa_erp/types/user_types/login_request.dart';
import 'package:kpa_erp/types/user_types/login_response.dart';
import 'package:kpa_erp/types/user_types/signup_request.dart';

class AuthService {
  static Future<LoginResponse?> login(
    String mobileNumber,
    String password,
  ) async {
    try {
      final request =
          LoginRequest(mobileNumber: mobileNumber, password: password);
      final responseJson =
          await ApiService.post('/api/users/login/', request.toJson());
      print(responseJson);
      return LoginResponse.fromJson(responseJson);
    } on ApiException catch (e) {
      throw (e.message);
    } catch (e) {
      print(e);
      print("Error Occourded while login");
      return null;
    }
  }

  static Future<LoginResponse?> loginWithGoogle(
    String authToken,
  ) async {
    try {
      final responseJson = await ApiService.post(
          '/api/users/google/', {"auth_token": authToken});
      return LoginResponse.fromJson(responseJson);
    } on ApiException catch (e) {
      throw (e.message);
    } catch (e) {
      print(e);
      print("Error Occourded while login");
      return null;
    }
  }

  static Future<LoginResponse?> loginByMobile(
    String loginCode,
    String phone,
  ) async {
    try {
      final request = LoginMobileRequest(mobileNumber: phone, otp: loginCode);
      print(request);
      final responseJson = await ApiService.post(
          '/api/users/login-using-otp-verify/', request.toJson());
      return LoginResponse.fromJson(responseJson);
    } on ApiException catch (e) {
      throw (e.message);
    } catch (e) {
      print(e);
      print("Error Occourded while login");
      return null;
    }
  }

  static Future<String> signup(
      String mobileNumber,
      String fName,
      String mName,
      String lName,
      String email,
      String password,
      String rePassword,
      String userType,
      String division,
      String trains,
      String coaches,
      String depo,
      String empNumber,
      String zone,
      String whatsappNumber,
      String secondaryPhoneNumber,
      [String? createdBy,
      String? createdByUserRole]) async {
    try {
      final request = SignupRequest(
          fName: fName,
          mName: mName,
          lName: lName,
          email: email,
          phone: mobileNumber,
          whatsappNumber: whatsappNumber,
          secondaryPhoneNumber: secondaryPhoneNumber,
          password: password,
          rePassword: rePassword,
          userType: userType,
          division: division,
          trains: trains,
          coaches: coaches,
          depo: depo,
          empNumber: empNumber,
          zone: zone,
          createdBy: createdBy,
          createdByUserRole: createdByUserRole);
      final responseJson =
          await ApiService.post('/api/users/request-user/', request.toJson());
      return responseJson['message'] ?? 'Registration successful';
    } on DetailedApiException catch (e) {
      throw SignupDetailsException(message: e.message, details: e.details);
    } catch (e) {
      if (e is SignupDetailsException) {
        rethrow;
      }
      throw e.toString();
    }
  }

  static Future<String> addNewUser(
      String mobileNumber,
      String fName,
      String mName,
      String lName,
      String email,
      String password,
      String rePassword,
      String userType,
      String division,
      String trains,
      String coaches,
      String depo,
      String empNumber,
      String zone,
      String whatsappNumber,
      String secondaryPhoneNumber,
      [String? createdBy,
      String? createdByUserRole]) async {
    try {
      final request = SignupRequest(
          fName: fName,
          mName: mName,
          lName: lName,
          email: email,
          phone: mobileNumber,
          whatsappNumber: whatsappNumber,
          secondaryPhoneNumber: secondaryPhoneNumber,
          password: password,
          rePassword: rePassword,
          userType: userType,
          division: division,
          trains: trains,
          coaches: coaches,
          depo: depo,
          empNumber: empNumber,
          zone: zone,
          createdBy: createdBy,
          createdByUserRole: createdByUserRole);
      final responseJson =
          await ApiService.post('/api/users/add-new-user/', request.toJson());
      return responseJson['message'] ?? 'Registration successful';
    } on DetailedApiException catch (e) {
      throw SignupDetailsException(message: e.message, details: e.details);
    } catch (e) {
      if (e is SignupDetailsException) {
        rethrow;
      }
      throw e.toString();
    }
  }

  static Future<String> update_user(
      String mobileNumber,
      String fName,
      String mName,
      String lName,
      String email,
      String password,
      String rePassword,
      String userType,
      String division,
      String trains,
      String coaches,
      String depo,
      String empNumber,
      String zone,
      String whatsappNumber,
      String secondaryPhoneNumber,
      [String? createdBy,
      String? createdByUserRole]) async {
    try {
      final request = SignupRequest(
          fName: fName,
          mName: mName,
          lName: lName,
          email: email,
          phone: mobileNumber,
          whatsappNumber: whatsappNumber,
          secondaryPhoneNumber: secondaryPhoneNumber,
          password: password,
          rePassword: rePassword,
          userType: userType,
          division: division,
          trains: trains,
          coaches: coaches,
          depo: depo,
          empNumber: empNumber,
          zone: zone,
          createdBy: createdBy,
          createdByUserRole: createdByUserRole);

      final responseJson =
          await ApiService.post('/api/users/update-user/', request.toJson());
      return responseJson['message'];
    } 
     on DetailedApiException catch (e) {
      throw SignupDetailsException(message: e.message, details: e.details);
    } catch (e) {
      if (e is SignupDetailsException) {
        rethrow;
      }
      throw e.toString();
    }
  }

  static Future<Map<String, dynamic>> getUserByMobile(
    String _mobileNumber,
    String token,
  ) async {
    try {
      final Map<String, dynamic> requestData = {
        'phone': _mobileNumber,
      };

      final responseJson = await ApiService.post(
        '/api/users/get-user/',
        requestData,
      );

      // Check if 'data' exists and is a Map
      if (responseJson['data'] is Map<String, dynamic>) {
        return responseJson['data'] as Map<String, dynamic>;
      } else {
        throw Exception('No user data found in response');
      }
    } on ApiException catch (e) {
      throw Exception(e.message); // Propagate API-specific errors
    } catch (e) {
      throw Exception('Error fetching user: ${e.toString()}');
    }
  }

  static Future<String> logout(
    String refreshToken,
    String token,
  ) async {
    try {
      final request = {'refresh_token': refreshToken, 'token': token};
      final response = await ApiService.delete('/api/users/logout/', request);
      return response["message"];
    } on ApiException catch (e) {
      throw (e.message);
    } catch (e) {
      return "Error Occourded while Logout";
    }
  }



  static Future<String> sendDeactivationOTP(String token, String email) async {
    try {
        final responseJson = await ApiService.post(
        '/api/users/profile/edit-profile/deactivate-account/verify-otp/',
        {'token': token,"email": email},
      );
      return responseJson['message']; 
    } catch (e) {
      throw e.toString();
    }
  }

    static Future<String> verifyDeactivationOTP(String token, Map<String, dynamic> data) async {
    try {
        final responseJson = await ApiService.post(
        '/api/users/profile/edit-profile/deactivate-account/confirm-otp/',
        {'token': token, ...data},
      );
      return responseJson['message']; 
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<String> deactivateAccount(String token) async {
    try {
      final request = {'token': token};
      final response = await ApiService.post(
          '/api/users/profile/edit-profile/deactivate-account/', request);
      return response["message"];
    } on ApiException catch (e) {
      throw (e.message);
    } catch (e) {
      return "Deactivation failed";
    }
  }
}

class SignupDetailsException implements Exception {
  final String message;
  final Map<String, dynamic> details;

  SignupDetailsException({required this.message, required this.details});

  @override
  String toString() {
    return message;
  }
}
