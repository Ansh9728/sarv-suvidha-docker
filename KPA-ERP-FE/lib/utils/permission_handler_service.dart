import 'package:permission_handler/permission_handler.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:universal_html/js.dart';
import 'package:permission_handler/permission_handler.dart' as permission_handler;

class PermissionHandlerService {
  Future<bool> requestLocationPermission(BuildContext context) async {
    PermissionStatus whenInUseStatus =
        await Permission.locationWhenInUse.request();

    if (whenInUseStatus.isGranted) {
      if (await Permission.locationAlways.isGranted) {
        _handlePermissionStatus(true, Permission.locationAlways);
        return true;
      } else {
        _handlePermissionStatus(false, Permission.locationAlways);
        await showLocationAlwaysDialog(context);
      }
    } else {
      _handlePermissionStatus(false, Permission.locationWhenInUse);
      return false;
    }

    return false;
  }

  Future<void> showLocationAlwaysDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.close, color: Colors.grey),
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Allow Location Access",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                "We need your device’s location to collect your location data, accurately track your train status in real time. You can revoke this permission anytime in your device’s settings.\n\nSelect 'Allow all the time' in settings.",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.battery_saver, color: Colors.green),
                  SizedBox(width: 6),
                  Text(
                    "Saves battery and mobile data",
                    style: TextStyle(color: Colors.green, fontSize: 13),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.touch_app, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Allow all the time",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("Deny"),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () async {
                        await launchAppSettings();  
                        Navigator.of(context).pop();
                      },
                      child: Text("Enable"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> isLocationPermissionGranted() async {
    return await Permission.locationWhenInUse.isGranted ||
        await Permission.locationAlways.isGranted;
  }

  void _handlePermissionStatus(bool isGranted, Permission permission) {
    if (!isGranted) {
      print('Permission for $permission denied.');
    } else {
      print('Permission for $permission granted.');
    }
  }

  Future<void> launchAppSettings() async {
    await permission_handler.openAppSettings();
  }

  Future<String> getPackageName() async {
    return "com.biputri.railops";
  }


}
