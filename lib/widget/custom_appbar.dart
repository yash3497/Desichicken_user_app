import 'package:flutter/material.dart';

import '../utils/constants.dart';

class CustomAppbar extends StatelessWidget {
  CustomAppbar({required this.title, this.button});

  final String title;
  final Widget? button;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: white,
      elevation: 0,
      centerTitle: true,
      title: Text(
        title,
        style: bodyText16w600(color: black),
      ),
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: black,
          )),
      actions: [button!],
    );
  }
}
