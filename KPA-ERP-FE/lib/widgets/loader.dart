import 'package:flutter/material.dart';

void loader(BuildContext context, String errorMessage,) {
  showDialog(
    context: context,
    barrierDismissible:false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), 
        ),
        content:  Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const CircularProgressIndicator(),
            const SizedBox(width:20),
            Text(errorMessage,textAlign: TextAlign.center ,),
          ],
        ),
      );
    },
  );
}
