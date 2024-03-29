import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious_app/views/humburger_items/fill_your_profile_screen.dart';
import 'package:delicious_app/views/start/map_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../utils/constants.dart';
import '../../widget/BottomNavBar.dart';
import '../../widget/custom_gradient_button.dart';
import '../../widget/humburger_screen.dart';

class EditProfileOTPVerify extends StatefulWidget {
  final String phonenumber;
  final Map data;
  final String uid;

  EditProfileOTPVerify(
      {super.key,
      required this.phonenumber,
      required this.data,
      required this.uid});

  @override
  State<EditProfileOTPVerify> createState() => _EditProfileOTPVerifyState();
}

class _EditProfileOTPVerifyState extends State<EditProfileOTPVerify> {
  final TextEditingController _controller1 = TextEditingController();

  final TextEditingController _controller2 = TextEditingController();

  final TextEditingController _controller3 = TextEditingController();

  final TextEditingController _controller4 = TextEditingController();

  final TextEditingController _controller5 = TextEditingController();

  final TextEditingController _controller6 = TextEditingController();

  List<String> otp = <String>[];

  String verificationIDrecieved = "";

  String verificationCode = "";

  bool otpCodeCorrect = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  void verifyNumber(BuildContext context) {
    Fluttertoast.showToast(msg: 'Otp Sent');
    String phone = widget.phonenumber;
    auth.verifyPhoneNumber(
        phoneNumber: "+91$phone",
        verificationCompleted: (PhoneAuthCredential credential) async {
          // auth.currentUser!.;
          print(widget.uid);
          auth.currentUser!.updatePhoneNumber(credential).then((value) async {
            print("done");
          });
          FirebaseFirestore.instance.collection("Users").doc(widget.uid).set({
            "Email": widget.data["Email"],
            "Name": widget.data["Name"],
            "Surname": widget.data["SurName"],
            "Number": auth.currentUser!.phoneNumber,
            "userID": auth.currentUser!.uid,
            "token": msgToken,
            "image": widget.data["image"],
          }, SetOptions(merge: true)).then((value) {
            userDetail['Name'] = widget.data["Name"];
            userDetail['Surname'] = widget.data["Surname"];
            userDetail["Email"] = widget.data["Email"];
            userDetail["image"] = widget.data["image"];
            userDetail["Number"] = auth.currentUser!.phoneNumber;
            Navigator.pop(context);
          });
          // auth.signInWithCredential(credential).then((value) async {

          // });
        },
        verificationFailed: (FirebaseAuthException exception) {
          // print(exception.message);
        },
        codeSent: (String verificationID, int? resendToken) {
          setState(() {
            verificationCode = verificationID;
          });
          // Navigator.push(context,
          //                   MaterialPageRoute(builder: (context) => OtpScreen(phonenumber: phonenumber,verificationIDrecieved: verificationIDrecieved,)));
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            verificationCode = verificationID;
          });
        },
        timeout: const Duration(seconds: 60));
  }

  void verifyCode(BuildContext context, String number) async {
    try {
      var otpstring = otp.join("");

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationCode, smsCode: otpstring);
      bool found = false;
      String curruserID = "";

      // await auth.signInWithCredential(credential).then((value) async {
      // if (value.user != null) {
      //   curruserID = value.user!.uid;
      print(widget.uid);
      auth.currentUser!.updatePhoneNumber(credential).then((value) async {
        print("done");
      });
      FirebaseFirestore.instance.collection("Users").doc(widget.uid).set({
        "Email": widget.data["Email"],
        "Name": widget.data["Name"],
        "Surname": widget.data["SurName"],
        "Number": auth.currentUser!.phoneNumber,
        "userID": auth.currentUser!.uid,
        "token": msgToken,
        "image": widget.data["image"],
      }, SetOptions(merge: true)).then((value) {
        userDetail['Name'] = widget.data["Name"];
        userDetail['Surname'] = widget.data["Surname"];
        userDetail["Email"] = widget.data["Email"];
        userDetail["image"] = widget.data["image"];
        userDetail["Number"] = auth.currentUser!.phoneNumber;
        Navigator.pop(context);
      });
      //   }
      // });
    } catch (e) {
      FocusScope.of(context).unfocus();
      log(e.toString());
    }
  }

  late Timer _timer;
  String _start = '1:30';
  int time = 90;
  formatedTime({required int timeInSecond}) {
    int sec = time % 60;
    int min = (time / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }

  @override
  void initState() {
    verifyNumber(context);
    // TODO: implement initState
    super.initState();

    //create a 1:30 minute timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        time--;
        if (time >= 0) {
          _start = formatedTime(timeInSecond: time);
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              ShaderMask(
                child: const Image(
                  image: AssetImage("assets/images/splash1.png"),
                ),
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(colors: [
                    Color.fromRGBO(255, 255, 255, 0.5),
                    Color.fromRGBO(255, 255, 255, 0)
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
                      .createShader(bounds);
                },
              ),
              Positioned(
                top: height(context) * 0.07,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: primary,
                          )),
                      addVerticalSpace(15),
                      Text(
                        'Enter 6-digit Verification code',
                        style: bodyText20w700(color: black),
                      ),
                      addVerticalSpace(10),
                      SizedBox(
                        width: width(context) * 0.7,
                        child: Text(
                            'Code send to  ${widget.phonenumber} .This code will expire in $_start'),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          addVerticalSpace(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: height(context) * 0.06,
                width: width(context) * 0.12,
                decoration: myOutlineBoxDecoration(0, Colors.black38, 10),
                child: Center(
                    child: TextField(
                        onChanged: (value) {
                          if (value.length == 1) {
                            otp.add(value);
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        controller: _controller1,
                        maxLength: 1,
                        autofocus: true,
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        ))),
              ),
              Container(
                height: height(context) * 0.06,
                width: width(context) * 0.12,
                decoration: myOutlineBoxDecoration(0, Colors.black38, 10),
                child: Center(
                    child: TextField(
                        onChanged: (value) {
                          if (value.length == 1) {
                            otp.add(value);
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        controller: _controller2,
                        maxLength: 1,
                        autofocus: true,
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        ))),
              ),
              Container(
                height: height(context) * 0.06,
                width: width(context) * 0.12,
                decoration: myOutlineBoxDecoration(0, Colors.black38, 10),
                child: Center(
                    child: TextField(
                        onChanged: (value) {
                          if (value.length == 1) {
                            otp.add(value);
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        controller: _controller3,
                        maxLength: 1,
                        autofocus: true,
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        ))),
              ),
              Container(
                height: height(context) * 0.06,
                width: width(context) * 0.12,
                decoration: myOutlineBoxDecoration(0, Colors.black38, 10),
                child: Center(
                    child: TextField(
                        onChanged: (value) {
                          if (value.length == 1) {
                            otp.add(value);
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        controller: _controller4,
                        maxLength: 1,
                        autofocus: true,
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        ))),
              ),
              Container(
                height: height(context) * 0.06,
                width: width(context) * 0.12,
                decoration: myOutlineBoxDecoration(0, Colors.black38, 10),
                child: Center(
                    child: TextField(
                        onChanged: (value) {
                          if (value.length == 1) {
                            otp.add(value);
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        controller: _controller5,
                        maxLength: 1,
                        autofocus: true,
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        ))),
              ),
              Container(
                height: height(context) * 0.06,
                width: width(context) * 0.12,
                decoration: myOutlineBoxDecoration(0, Colors.black38, 10),
                child: Center(
                    child: TextField(
                        onChanged: (value) {
                          if (value.length == 1) {
                            otp.add(value);
                          }
                        },
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        controller: _controller6,
                        maxLength: 1,
                        autofocus: true,
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        ))),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
                onPressed: () {
                  verifyNumber(context);
                  setState(() {
                    time = 90;
                    _start = '1:30';
                  });
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => ForgotPassword()));
                },
                child: Text(
                  'Resend Otp',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                      color: primary),
                )),
          ),
          const Spacer(),
          CustomButton(
              buttonName: 'Verify',
              onClick: () {
                verifyCode(context, widget.phonenumber);
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => FillYourProfileScreen()));
              }),
          addVerticalSpace(10)
        ],
      ),
    );
  }
}
