import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious_app/views/start/login_screen.dart';
import 'package:delicious_app/views/start/otp_verify.dart';
import 'package:delicious_app/widget/custom_gradient_button.dart';
import 'package:delicious_app/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../utils/constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isCheck = false;
  bool isCheck2 = false;
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: [
        ShaderMask(
          child: const Image(
            image: AssetImage("assets/images/splash1.png"),
          ),
          shaderCallback: (Rect bounds) {
            return const LinearGradient(colors: [
              Color.fromRGBO(255, 255, 255, 1),
              Color.fromRGBO(255, 255, 255, 0)
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
                .createShader(bounds);
          },
        ),
        SizedBox(
          height: height(context) * 0.15,
          child: Image.asset('assets/images/mainlogo.png'),
        ),
        addVerticalSpace(height(context) * 0.08),
        Text(
          'Sign Up For Free',
          style: bodyText20w700(color: black),
        ),
        addVerticalSpace(20),
        CustomTextfield(
          hintext: 'Name',
          prefixIcon: Icon(
            Icons.person,
            color: primary.withOpacity(0.6),
          ),
        ),
        addVerticalSpace(15),
        CustomTextfield(
          inputType: TextInputType.number,
          controller: phonecontroller,
          hintext: 'Mobile Number',
          prefixIcon: Icon(
            Icons.call,
            color: primary.withOpacity(0.6),
          ),
        ),
        addVerticalSpace(20),
        Padding(
          padding: const EdgeInsets.only(left: 7.0),
          child: Row(
            children: [
              Checkbox(
                  value: isCheck,
                  // fillColor: MaterialStateProperty.resolveWith(Colors.red),
                  shape: CircleBorder(),
                  activeColor: primary.withOpacity(0.7),
                  onChanged: (val) {
                    isCheck = val!;
                    setState(() {});
                  }),
              Text('Keep Me Signed In')
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 7.0),
          child: Row(
            children: [
              Checkbox(
                  value: isCheck2,
                  // fillColor: MaterialStateProperty.resolveWith(Colors.red),
                  shape: CircleBorder(),
                  activeColor: primary.withOpacity(0.7),
                  onChanged: (val) {
                    isCheck2 = val!;
                    setState(() {});
                  }),
              Text('Email Me About Special Pricing')
            ],
          ),
        ),
        addVerticalSpace(height(context) * 0.08),
        CustomButton(
            buttonName: 'Create Account',
            onClick: () async {
              var response = await FirebaseFirestore.instance
                  .collection("users")
                  .where("Number", isEqualTo: "+91${phonecontroller.text}")
                  .get();

              if (response.docs.isNotEmpty) {
                Fluttertoast.showToast(msg: "You are already registered");
              } else {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OtpVerify(
                              phonenumber: phonecontroller.text,
                            )));
              }
            }),
        TextButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LogInScreen()));
            },
            child: Text(
              'Already have an account?',
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: primary),
            ))
      ]),
    ));
  }
}
