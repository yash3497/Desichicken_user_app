import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious_app/utils/constants.dart';
import 'package:delicious_app/views/humburger_items/about_us_screen.dart';
import 'package:delicious_app/views/humburger_items/contact_us_screen.dart';
import 'package:delicious_app/views/humburger_items/faqs_screen.dart';
import 'package:delicious_app/views/humburger_items/fill_your_profile_screen.dart';
import 'package:delicious_app/views/humburger_items/refer_and_earn_screen.dart';
import 'package:delicious_app/views/humburger_items/save_address_screen.dart';
import 'package:delicious_app/views/orders/my_orders_screens.dart';
import 'package:delicious_app/views/start/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

var userDetail;

class MyDrawer extends StatefulWidget {
  MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  // final Stream<DocumentSnapshot<Map<String, dynamic>>> userDetails =
  //     FirebaseFirestore.instance
  //         .collection('Users')
  //         .doc(FirebaseAuth.instance.currentUser?.uid)
  //         .snapshots();

  getCurrentUser() {
    userDetail = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      log(value.data().toString());
      userDetail = value.data();
      userProfile = userDetail['image'];
      userName = userDetail['Name'];
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    getCurrentUser();
    log("${FirebaseAuth.instance.currentUser?.phoneNumber}");
    super.initState();
  }

  String userProfile = '';
  String userName = '';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          addVerticalSpace(20),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: white,
              radius: 30,
              child: userProfile != "" && userProfile != null
                  ? Image.network(userProfile)
                  : Image.asset(
                      'assets/images/myprofile.png',
                      fit: BoxFit.fill,
                    ),
            ),
            title: Text(userName != "" && userName != null ? userName : "Name"),
            subtitle: Text(
                "${FirebaseAuth.instance.currentUser?.phoneNumber ?? "+911111111111"}"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FillYourProfileScreen(
                            existing: true,
                          )));
            },
          ),
          addVerticalSpace(20),
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: Text(
              'Saved Addresses',
              style: bodyText14w600(color: black),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SavedAddressScreen()));
            },
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          // ListTile(
          //   leading: const Icon(Icons.account_balance_wallet_outlined),
          //   title: Text(
          //     'Wallet ',
          //     style: bodyText14w600(color: black),
          //   ),
          //   trailing: const Icon(Icons.arrow_forward_ios),
          //   onTap: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => const WalletScreen()));
          //   },
          // ),
          /*  const Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.notifications_none),
            title: Text(
              'Notification ',
              style: bodyText14w600(color: black),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const NotificationSettingsScreen()));
            },
          ),*/
          const Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag_outlined),
            title: Text(
              'My Orders',
              style: bodyText14w600(color: black),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyOrdersScreen()));
            },
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.report_gmailerrorred_outlined),
            title: Text(
              'About us',
              style: bodyText14w600(color: black),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AboutUsScreen()));
            },
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.call),
            title: Text(
              'Contact us',
              style: bodyText14w600(color: black),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ContactUs()));
            },
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: Text(
              'Refer and earn',
              style: bodyText14w600(color: black),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ReferAndEarnScreen()));
            },
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.help_outline_sharp),
            title: Text(
              'FAQs',
              style: bodyText14w600(color: black),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const FAQsScreen()));
            },
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: Text(
              'Logout',
              style: bodyText14w600(color: black),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () async {
              await FirebaseAuth.instance.signOut().then((value) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LogInScreen()));
              });
            },
          ),
        ],
      ),
    );
  }
}
