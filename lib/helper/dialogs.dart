import 'package:flutter/material.dart';

class Dialogs {
  static void showSnackbar(BuildContext context, String msg) {
    if (context.mounted) {
      final snackBar = SnackBar(
        content: Text(
          msg,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo.withOpacity(0.4),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        dismissDirection: DismissDirection.horizontal,
        elevation: 1,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  static void showProgressbar(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => Center(
            child: SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 6,
                  color: Colors.indigo.withOpacity(0.4),
                ))));
  }
}
