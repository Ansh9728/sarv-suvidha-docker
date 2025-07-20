import 'dart:math';

import 'package:kpa_erp/services/api_services/api_exception.dart';
import 'package:kpa_erp/services/api_services/api_service.dart';
import 'package:kpa_erp/services/authentication_services/auth_service.dart';
import 'package:kpa_erp/types/user_types/update_request_response.dart';

class UpdateUserService {
  // Submit a new user update request
  static Future<Map<String, dynamic>> submitUpdateRequest(
    final String token,
    final Map<String, dynamic> updateData,
  ) async {
    try {
      final request = {
        'token': token,
        ...updateData,
      };

      final responseJson = await ApiService.put('/api/users/update/', request);

      return {
        'message': responseJson['message'],
        'requestId': responseJson['request_id'],
        'userIdBeingUpdated': responseJson['user_id_being_updated'],
      };
    } on DetailedApiException catch (e) {
      throw SignupDetailsException(message: e.message, details: e.details);
    } catch (e) {
      if (e is SignupDetailsException) {
        rethrow;
      }
      throw e.toString();
    }
  }

  // Get all pending update requests
  static Future<UpdateRequestResponse> getUpdateRequests(final String token,
      {final String? userId}) async {
    try {
      final String endpoint =
          userId != null ? '/api/users/updates/$userId/' : '/api/users/update/';

      final responseJson = await ApiService.get(endpoint, {'token': token});

      return UpdateRequestResponse.fromJson(responseJson);
    } on ApiException catch (e) {
      throw (e.message);
    } catch (e) {
      print("Detailed error: $e");
      print("Error occurred while fetching update requests");

      throw "Failed to fetch update requests";
    }
  }

  // Mark update requests as seen for a specific user
  static Future<String> markRequestsAsSeen(
    final String token,
    final String userId,
  ) async {
    try {
      final request = {'token': token};
      final responseJson =
          await ApiService.post('/api/users/updates/$userId/', request);

      return responseJson['message'];
    } on ApiException catch (e) {
      throw (e.message);
    } catch (e) {
      print(e);
      print("Error occurred while marking requests as seen");
      throw "Failed to mark requests as seen";
    }
  }

  // Process (approve/deny) a specific update request
  static Future<Map<String, dynamic>> processUpdateRequest(
    final String token,
    final String requestId,
    final String action, // "APPROVE" or "DENY"
  ) async {
    try {
      final request = {
        'token': token,
        'q': action,
      };

      final responseJson = await ApiService.post(
          '/api/users/update-requests/$requestId/', request);

      final result = {
        'message': responseJson['message'],
        'userIdBeingUpdated': responseJson['user_id_being_updated'],
      };

      // If the request was approved and user data was returned
      if (action == "APPROVE" && responseJson.containsKey('user')) {
        result['user'] = UserResponse.fromJson(responseJson['user']);
        result['changedFields'] = responseJson['changed_fields'];
        if (responseJson.containsKey('updated_by')) {
          result['updatedBy'] = responseJson['updated_by'];
        }
      }

      return result;
    } on ApiException catch (e) {
      throw (e.message);
    } catch (e) {
      print(e);
      throw "Failed to process update request";
    }
  }
}

// Model for submitting update request
class UpdateUserRequest {
  final String token;
  final Map<String, dynamic> data;

  UpdateUserRequest({
    required this.token,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      ...data,
    };
  }
}

// Model for approving/denying requests
class UpdateRequestActionRequest {
  final String token;
  final String q; // "APPROVE" or "DENY"

  UpdateRequestActionRequest({
    required this.token,
    required this.q,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'q': q,
    };
  }
}
