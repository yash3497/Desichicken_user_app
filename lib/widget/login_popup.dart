import 'package:delicious_app/views/start/login_screen.dart';
import 'package:flutter/material.dart';

//show login popup

showLoginPopup(BuildContext context) {
  return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Login"),
          content: Text("Please login to continue"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LogInScreen()));
                },
                child: Text("Login"))
          ],
        );
      });
}
