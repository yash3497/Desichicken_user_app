import 'package:delicious_app/utils/constants.dart';
import 'package:delicious_app/views/home/home_screen.dart';
import 'package:delicious_app/views/start/login_screen.dart';
import 'package:delicious_app/widget/BottomNavBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:simple_gradient_text/simple_gradient_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) =>
          FirebaseAuth.instance.currentUser==null?LogInScreen(): BottomNavBar()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ShaderMask(
            child: const Image(
              image: AssetImage("assets/images/splash1.png"),
            ),
            shaderCallback: (Rect bounds) {
              return const LinearGradient(colors: [
                Color.fromRGBO(255, 255, 255, 1),
                Color.fromRGBO(255, 255, 255, 0.5)
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
                  .createShader(bounds);
            },
          ),
          addVerticalSpace(height(context) * 0.14),
          SizedBox(
            height: height(context) * 0.18,
            child: Image.asset('assets/images/mainlogo.png'),
          ),
        ],
      ),
    );
  }
}
