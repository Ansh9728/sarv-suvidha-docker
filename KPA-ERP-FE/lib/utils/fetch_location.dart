// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';

// import 'package:permission_handler/permission_handler.dart';

// import 'package:workmanager/workmanager.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LocationTracker {
//   static const fetchLocationTask = "fetchLocationTask";
//   static const notificationChannelId = 'location_service_channel';
//   static const notificationChannelName = 'Location Service';
//   static const notificationId = 888;

//   static Future<void> initialize() async {
//     await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
//   }

//   static Future<bool> checkAndRequestPermissions() async {
//     final locationStatus = await Permission.location.request();
//     if (!locationStatus.isGranted) {
//       return false;
//     }

//     if (Platform.isAndroid) {
//       final backgroundStatus = await Permission.locationAlways.request();
//       if (!backgroundStatus.isGranted) {
//         return false;
//       }
//     }

//     final notificationStatus = await Permission.notification.request();
//     if (!notificationStatus.isGranted) {
//       return false;
//     }

//     return true;
//   }

//   static Future<void> startTracking() async {
//     await Workmanager().registerPeriodicTask(
//       "periodicLocationTask",
//       fetchLocationTask,
//       frequency: const Duration(minutes: 15),
//       existingWorkPolicy: ExistingWorkPolicy.replace,
//       constraints: Constraints(
//         networkType: NetworkType.connected,
//         requiresBatteryNotLow: false,
//         requiresCharging: false,
//         requiresDeviceIdle: false,
//         requiresStorageNotLow: false,
//       ),
//       backoffPolicy: BackoffPolicy.exponential,
//       backoffPolicyDelay: const Duration(minutes: 1),
//     );

//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isTracking', true);
//   }

//   static Future<void> stopTracking() async {
//     await Workmanager().cancelAll();

//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isTracking', false);
//   }
// }

// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     // Phase 3.2: Enhanced callback dispatcher with notification processing
//     if (task == LocationTracker.fetchLocationTask) {
//       try {
//         final prefs = await SharedPreferences.getInstance();
//         final isTracking = prefs.getBool('isTracking') ?? false;

//         if (!isTracking) {
//           return Future.value(false);
//         }

//         // Request location permission again as it might have been revoked
//         final locationPermission = await Geolocator.checkPermission();
//         if (locationPermission == LocationPermission.denied ||
//             locationPermission == LocationPermission.deniedForever) {
//           return Future.value(false);
//         }

//         Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.medium,
//         );

//         String? token = prefs.getString('authToken');
//         if (token == null) {
//           print('Error: No auth token found.');
//           return Future.value(false);
//         }

//         int retryCount = 0;
//         bool success = false;
//         String? lastErrorMessage;

//         while (retryCount < 3 && !success) {
//           try {
//             String responseMessage =
//                 await LocationService.addCurrentUserLocation(
//               token,
//               position.latitude.toString(),
//               position.longitude.toString(),
//             );
//             print('✅ GPS Upload: $responseMessage');
//             success = true;
//           } catch (e) {
//             lastErrorMessage = e.toString();

//             // Handle specific location service errors
//             if (e.toString().contains('USER_NOT_INSIDE_TRAIN')) {
//               print('❌ GPS Upload: User not inside train - $e');
//               // Don't retry for this type of error
//               break;
//             } else if (e.toString().contains('API_ERROR')) {
//               print(
//                   '❌ GPS Upload: API error (attempt ${retryCount + 1}/3) - $e');
//             } else {
//               print('❌ GPS Upload: Error (attempt ${retryCount + 1}/3) - $e');
//             }

//             retryCount++;
//             if (retryCount < 3) {
//               await Future.delayed(
//                   Duration(seconds: pow(2, retryCount).toInt()));
//             }
//           }
//         }

//         // Log final result
//         if (!success && lastErrorMessage != null) {
//           print(
//               '❌ GPS Upload: Failed after $retryCount attempts - $lastErrorMessage');
//         }

//         // After successful GPS upload, call the /notify Cloud Function
//         if (success) {
//           await _callNotifyCloudFunction(prefs, position, token);
//         }

//         return Future.value(success);
//       } catch (e) {
//         print('Error occurred while fetching location or sending data: $e');
//         return Future.value(false);
//       }
//     }
//     // Phase 3.2: Handle background notification processing tasks
//     else if (task == NotificationBackgroundService.notificationProcessingTask) {
//       return await NotificationBackgroundService
//           .processBackgroundNotifications();
//     }
//     // Phase 3.2: Handle proximity monitoring tasks
//     else if (task == NotificationBackgroundService.proximityMonitoringTask) {
//       return await NotificationBackgroundService.processProximityMonitoring();
//     }

//     return Future.value(true);
//   });
// }

// /// Helper function to call the /notify Cloud Function after GPS upload
// Future<void> _callNotifyCloudFunction(
//   SharedPreferences prefs,
//   Position position,
//   String authToken,
// ) async {
//   try {
//     // Get user data from SharedPreferences
//     final String? userId = await _getUserId(prefs);
//     final String? trainNumber = await _getTrainNumber(prefs);

//     if (userId == null || userId.isEmpty) {
//       print('📍 Notify: Skipped - No user ID found');
//       return;
//     }

//     // Get current date
//     final String currentDate =
//         FirebaseCloudFunctionService.getCurrentDateString();

//     // Get FCM token (only if not already in Firestore)
//     String? fcmToken;
//     try {
//       fcmToken = await FcmTokenService.getFcmToken();
//     } catch (e) {
//       print('📍 Notify: Warning - Could not get FCM token: $e');
//     }

//     // Call the Cloud Function
//     final result = await FirebaseCloudFunctionService.callNotifyFunction(
//       userId: userId,
//       trainNumber: trainNumber ?? '',
//       date: currentDate,
//       lat: position.latitude.toString(),
//       lng: position.longitude.toString(),
//       fcmToken: fcmToken,
//     );

//     // Log the result based on status
//     final status = result['status'] as String;
//     final message = result['message'] as String;

//     switch (status) {
//       case 'sent':
//         print('📍 Notify: Sent - $message');
//         break;
//       case 'skipped':
//         print('📍 Notify: Skipped - $message');
//         break;
//       case 'error':
//         print('📍 Notify: Error - $message');
//         break;
//       default:
//         print('📍 Notify: Unknown status - $status: $message');
//     }
//   } catch (e) {
//     print('📍 Notify: Error calling Cloud Function: $e');
//   }
// }

// /// Get user ID from SharedPreferences or login response (updated to use JWT-extracted user ID)
// Future<String?> _getUserId(SharedPreferences prefs) async {
//   try {
//     // First try to get JWT-extracted user ID (most reliable)
//     final jwtUserId = await JwtService.getStoredUserId();
//     if (jwtUserId != null) {
//       return jwtUserId;
//     }

//     // Fallback: try to get user ID from login response
//     final loginResponseJson = prefs.getString('loginResponse');
//     if (loginResponseJson != null) {
//       final loginData = json.decode(loginResponseJson);
//       // Check various possible fields for user ID
//       return loginData['user_id']?.toString() ??
//           loginData['id']?.toString() ??
//           loginData['userId']?.toString();
//     }

//     // Last fallback: try direct user_id key
//     return prefs.getString('user_id');
//   } catch (e) {
//     print('📍 Error getting user ID: $e');
//     return null;
//   }
// }

// /// Get train number from SharedPreferences
// Future<String?> _getTrainNumber(SharedPreferences prefs) async {
//   try {
//     return prefs.getString('trainNo');
//   } catch (e) {
//     print('📍 Error getting train number: $e');
//     return null;
//   }
// }
