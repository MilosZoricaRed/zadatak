import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> cellDialog(context, data) async {
  if (!Platform.isIOS) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Alert Dialog"),
        content: Text(data),
        actions: <Widget>[
          Center(
            child: TextButton(
              child: const Text("Ok"),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ),
        ],
      ),
    );
  }

  return showCupertinoDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => CupertinoAlertDialog(
      title: const Text("Alert Dialog"),
      content: Text(data),
      actions: <Widget>[
        Center(
          child: CupertinoDialogAction(
            child: const Text("Ok"),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ),
      ],
    ),
  );
}
