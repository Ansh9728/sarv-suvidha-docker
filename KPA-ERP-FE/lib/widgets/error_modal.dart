import 'package:flutter/material.dart';

void showErrorModal(BuildContext context, String errorMessage, String messageType, VoidCallback onClose) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title:  Text(messageType),
        content: Text(errorMessage),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              onClose();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
