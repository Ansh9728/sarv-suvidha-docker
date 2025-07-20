import 'package:flutter/material.dart';

void showLocationPermissionDisclosure(BuildContext context, Function onAccept) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Location Access Required'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                'RailOps needs access to your location to provide real-time train tracking and notifications, '
                'even when the app is closed. This helps us keep you updated with your journey status.'),
            SizedBox(height: 16),
            Text(
              'We will collect location data in the background to ensure accurate tracking and schedule alerts.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog if the user cancels
            },
            child: Text('Decline'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              onAccept(); // Continue to request permission
            },
            child: Text('Accept'),
          ),
        ],
      );
    },
  );
}
