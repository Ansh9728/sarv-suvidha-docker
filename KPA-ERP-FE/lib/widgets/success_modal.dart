import 'package:flutter/material.dart';

void showSuccessModal(BuildContext context, String errorMessage, String messageType, VoidCallback onClose,) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(messageType),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/Verified.gif' , height: 150,width: 150,color: Colors.blue,),
            const SizedBox(height: 10),
            Text(errorMessage),
          ],
        ),
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
