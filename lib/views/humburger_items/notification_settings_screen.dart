import 'package:delicious_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../widget/custom_appbar.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool isSwitch = true;

  bool isSwitch2 = true;
  bool isSwitch3 = false;
  bool isSwitch4 = true;
  bool isSwitch5 = false;
  bool isSwitch6 = false;
  bool isSwitch7 = true;
  bool isSwitch8 = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppbar(title: 'Notification', button: SizedBox()),
      ),
      body: Column(
        children: [
          SwitchListTile(
              title: Text(
                'General Notification',
                style: bodyText16w600(color: black),
              ),
              activeColor: primary,
              value: isSwitch,
              onChanged: (bool value) {
                setState(() {
                  isSwitch = value;
                });
              }),
          SwitchListTile(
              title: Text(
                'Sound',
                style: bodyText16w600(color: black),
              ),
              activeColor: primary,
              value: isSwitch2,
              onChanged: (bool value) {
                setState(() {
                  isSwitch2 = value;
                });
              }),
          SwitchListTile(
              title: Text(
                'Vibrate',
                style: bodyText16w600(color: black),
              ),
              activeColor: primary,
              value: isSwitch3,
              onChanged: (bool value) {
                setState(() {
                  isSwitch3 = value;
                });
              }),
          SwitchListTile(
              title: Text(
                'Special Offers',
                style: bodyText16w600(color: black),
              ),
              activeColor: primary,
              value: isSwitch4,
              onChanged: (bool value) {
                setState(() {
                  isSwitch4 = value;
                });
              }),
          SwitchListTile(
              title: Text(
                'Payments',
                style: bodyText16w600(color: black),
              ),
              activeColor: primary,
              value: isSwitch5,
              onChanged: (bool value) {
                setState(() {
                  isSwitch5 = value;
                });
              }),
          SwitchListTile(
              title: Text(
                'Cashback',
                style: bodyText16w600(color: black),
              ),
              activeColor: primary,
              value: isSwitch6,
              onChanged: (bool value) {
                setState(() {
                  isSwitch6 = value;
                });
              }),
          SwitchListTile(
              title: Text(
                'App Updates',
                style: bodyText16w600(color: black),
              ),
              activeColor: primary,
              value: isSwitch7,
              onChanged: (bool value) {
                setState(() {
                  isSwitch7 = value;
                });
              }),
          SwitchListTile(
              title: Text(
                'New Service Available',
                style: bodyText16w600(color: black),
              ),
              activeColor: primary,
              value: isSwitch8,
              onChanged: (bool value) {
                setState(() {
                  isSwitch8 = value;
                });
              }),
        ],
      ),
    );
  }
}
