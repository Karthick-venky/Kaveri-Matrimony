import 'package:flutter/material.dart';
import 'global.dart';

class CommonSnackBar {
  static void show(BuildContext context, {required String message, Color? backgroundColor, Duration duration = const Duration(seconds: 2),}) {

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(message, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),),
            ],
          ),
          backgroundColor: backgroundColor ?? MyColors.snackBarColor,
          duration: duration,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      );
  }
}
