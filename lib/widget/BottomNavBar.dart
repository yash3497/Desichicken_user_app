import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious_app/utils/constants.dart';
import 'package:delicious_app/views/home/chat_help_screen.dart';
import 'package:delicious_app/widget/humburger_screen.dart';
import 'package:delicious_app/views/my_cart/cart_tab_screen.dart';
import 'package:delicious_app/views/home/home_screen.dart';
import 'package:delicious_app/views/orders/my_orders_screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const MyCartScreen(),
    const MyOrdersScreen(),
    const ChatWithOne()
  ];

  Future<bool> _onWillPop() async {
    // This dialog will exit your app on saying yes
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex > 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        }
        if (_selectedIndex == 0) {
          return _onWillPop();
        }
        return true;
      },
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              child: GNav(
                rippleColor: Colors.grey[300]!,
                // hoverColor: Colors.red,
                tabBorderRadius: 15,
                gap: 6,
                activeColor: darkRed,
                iconSize: 25,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                duration: const Duration(milliseconds: 400),
                // tabBackgroundColor: Colors.red[100]!,
                // color: Colors.green,
                tabBackgroundGradient: tabGradient(),
                tabs: [
                  GButton(
                    icon: Icons.home,
                    text: 'Home',
                    iconColor: ligthRed,
                  ),
                  GButton(
                    icon: Icons.shopping_cart_rounded,
                    text: 'My Cart',
                    iconColor: ligthRed,
                  ),
                  GButton(
                    icon: Icons.calendar_month_outlined,
                    text: 'My Orders',
                    iconColor: ligthRed,
                  ),
                  GButton(
                    icon: Icons.message_sharp,
                    text: 'Help',
                    iconColor: ligthRed,
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
        // floatingActionButton: FloatingActionButton(onPressed: (){
        //   sendNotification("title", "body");
        // },child:const Icon(Icons.add)),
      ),
    );
  }
}

class RadiantGradientMask extends StatelessWidget {
  RadiantGradientMask({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const RadialGradient(
        center: Alignment.center,
        radius: 0.5,
        colors: [Colors.blue, Colors.red],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}
