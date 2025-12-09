import 'dart:developer';

import 'package:flutter/material.dart';

Future<bool> showCommonDialog({
  required BuildContext context,
  String title = "Confirm",
  String message = "Are you sure?",
  String cancelText = "Cancel",
  String confirmText = "OK",
  bool showCancelBtn = true,
  Color confirmColor = Colors.red,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        if (showCancelBtn) TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(cancelText),),
        TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(confirmText, style: TextStyle(color: confirmColor),),),
      ],
    ),
  );
  log("result = $result");
  return result ?? false;
}
