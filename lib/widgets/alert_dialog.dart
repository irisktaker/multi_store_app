
import 'package:flutter/cupertino.dart';

class MyAlertDialog {
  static void showMyDialog(
      context, {
        required String title,
        required String content,
        required Function() tabNo,
        required Function() tabYes,
      }) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              child: const Text('No'),
              onPressed: tabNo,
            ),
            CupertinoDialogAction(
              child: const Text('Yes'),
              isDestructiveAction: true,
              onPressed: tabYes,
            ),
          ],
        );
      },
    );
  }
}
