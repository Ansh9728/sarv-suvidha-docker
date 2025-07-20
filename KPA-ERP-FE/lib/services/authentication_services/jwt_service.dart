import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for handling JWT token operations
/// Provides methods to decode JWT tokens and extract user information
class JwtService {
  /// Decode JWT token and extract payload
  /// Returns null if token is invalid or cannot be decoded
  static Map<String, dynamic>? decodeToken(String token) {
    try {
      // Remove 'Bearer ' prefix if present
      final cleanToken = token.startsWith('Bearer ') 
          ? token.substring(7) 
          : token;
      
      // Decode JWT token without verification (since we don't have the secret)
      final jwt = JWT.decode(cleanToken);
      
      if (jwt.payload is Map<String, dynamic>) {
        return jwt.payload as Map<String, dynamic>;
      }
      
      debugPrint('❌ JWT payload is not a valid Map');
      return null;
    } catch (e) {
      debugPrint('❌ Error decoding JWT token: $e');
      return null;
    }
  }
  
  /// Extract user ID from JWT token
  /// Checks multiple possible field names for user ID
  static String? extractUserId(String token) {
    try {
      final payload = decodeToken(token);
      if (payload == null) {
        debugPrint('❌ Cannot extract user ID: Invalid JWT payload');
        return null;
      }
      
      // Check various possible fields for user ID
      final userId = payload['user_id']?.toString() ??
          payload['id']?.toString() ??
          payload['userId']?.toString() ??
          payload['sub']?.toString(); // 'sub' is standard JWT subject claim
      
      if (userId != null) {
        debugPrint('✅ Extracted user ID from JWT: $userId');
        return userId;
      } else {
        debugPrint('❌ No user ID found in JWT payload');
        debugPrint('Available fields: ${payload.keys.toList()}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Error extracting user ID from JWT: $e');
      return null;
    }
  }
  
  /// Store user ID in SharedPreferences
  /// This ensures the user ID is available for other services
  static Future<bool> storeUserId(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', userId);
      debugPrint('✅ User ID stored in SharedPreferences: $userId');
      return true;
    } catch (e) {
      debugPrint('❌ Error storing user ID: $e');
      return false;
    }
  }
  
  /// Extract and store user ID from JWT token
  /// This is the main method to call after successful authentication
  static Future<bool> extractAndStoreUserId(String token) async {
    try {
      final userId = extractUserId(token);
      if (userId != null) {
        return await storeUserId(userId);
      }
      return false;
    } catch (e) {
      debugPrint('❌ Error in extractAndStoreUserId: $e');
      return false;
    }
  }
  
  /// Get stored user ID from SharedPreferences
  /// This is a helper method for other services to retrieve the user ID
  static Future<String?> getStoredUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      if (userId != null) {
        debugPrint('✅ Retrieved stored user ID: $userId');
      } else {
        debugPrint('❌ No user ID found in SharedPreferences');
      }
      return userId;
    } catch (e) {
      debugPrint('❌ Error getting stored user ID: $e');
      return null;
    }
  }
  
  /// Debug method to print JWT payload contents
  /// Useful for troubleshooting JWT token issues
  static void debugJwtPayload(String token) {
    try {
      final payload = decodeToken(token);
      if (payload != null) {
        debugPrint('🔍 JWT Payload Debug:');
        debugPrint('==========================================');
        payload.forEach((key, value) {
          debugPrint('$key: $value (${value.runtimeType})');
        });
        debugPrint('==========================================');
      } else {
        debugPrint('❌ Cannot debug JWT: Invalid payload');
      }
    } catch (e) {
      debugPrint('❌ Error debugging JWT payload: $e');
    }
  }
  
  /// Check if JWT token is expired
  /// Returns true if token is expired, false if valid, null if cannot determine
  static bool? isTokenExpired(String token) {
    try {
      final payload = decodeToken(token);
      if (payload == null) return null;
      
      final exp = payload['exp'];
      if (exp == null) return null;
      
      final expirationTime = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final now = DateTime.now();
      
      return now.isAfter(expirationTime);
    } catch (e) {
      debugPrint('❌ Error checking token expiration: $e');
      return null;
    }
  }
}
