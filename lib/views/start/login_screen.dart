import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious_app/utils/constants.dart';
import 'package:delicious_app/views/start/otp_verify.dart';
import 'package:delicious_app/views/start/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../widget/custom_gradient_button.dart';
import '../../widget/custom_textfield.dart';
import '../humburger_items/fill_your_profile_screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  List<Map<String, String>> logInSliderList = [
    {'img': 'assets/images/login1.png', 'title': 'jhvecejhvfv'},
    {'img': 'assets/images/login1.png', 'title': 'jhvecejhvfv'},
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final _carouselController = CarouselController();

  int _currentPage = 0;
  late Timer _timer;
  PageController _pageController = PageController(
    initialPage: 0,
  );

  signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    //  final LoginResult result = await FacebookAuth.instance.login(
    //   permissions: ["email"]
    //  );
    //  final AuthCredential facebookCredential =
    //           FacebookAuthProvider.credential(result.accessToken!.token);

    //           await FirebaseAuth.instance.signInWithCredential(facebookCredential);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const FillYourProfileScreen(
                  existing: false,
                )));
  }

  signInWithGoogle() async {
    {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: <String>["email"]).signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const FillYourProfileScreen(
                    existing: false,
                  )));
    }
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(seconds: 1),
        curve: Curves.ease,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  TextEditingController phonecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ShaderMask(
            child: const Image(
              image: AssetImage("assets/images/splash1.png"),
            ),
            shaderCallback: (Rect bounds) {
              return const LinearGradient(colors: [
                Color.fromRGBO(255, 255, 255, 1),
                Color.fromRGBO(255, 255, 255, 0.1)
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
                  .createShader(bounds);
            },
          ),
          PageView(
            allowImplicitScrolling: true,
            controller: _pageController,
            onPageChanged: (i) {
              setState(() {
                // if (i == 2) {
                //   Navigator.push(context,
                //       MaterialPageRoute(builder: (context) => SignInScreen()));
                // }
              });
            },
            children: const [
              PageViewItemWidget(
                text: "Convenient & Reliable",
                text2:
                    "Order your favourite food & get it delivered at your doorsteps",
                assetUrl: 'assets/images/door.png',
              ),
              PageViewItemWidget(
                text: "Delicious is where Your Favourite Food Lives",
                text2: "Here you can find a dish for every taste. Enjoy!",
                assetUrl: 'assets/images/scroll2.png',
              ),
              PageViewItemWidget(
                text: "Find Your Favourite Food here",
                text2:
                    "Enjoy your favourite food with smooth food delivery at your doorstep",
                assetUrl: 'assets/images/scroll3.png',
              ),
              // SignInScreen()
            ],
          ),
          Positioned(
            top: height(context) * 0.39,
            left: width(context) * 0.45,
            child: SmoothPageIndicator(
              controller: _pageController,
              count: 3,
              axisDirection: Axis.horizontal,
              effect: SlideEffect(
                  spacing: 8.0,
                  radius: 4.0,
                  dotWidth: 8.0,
                  dotHeight: 7.0,
                  // paintStyle: PaintingStyle.stroke,
                  strokeWidth: 1.5,
                  dotColor: Colors.grey,
                  activeDotColor: primary),
            ),
          ),
          Positioned(
              top: height(context) * 0.36,
              child: Container(
                margin: const EdgeInsets.only(top: 50),
                height: height(context),
                width: width(context),
                decoration: BoxDecoration(
                    color: white,
                    boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.grey)]),
                child: Column(
                  children: [
                    addVerticalSpace(25),
                    Text(
                      'Login To Your Account',
                      style: bodyText16w600(color: black),
                    ),
                    addVerticalSpace(20),
                    CustomTextfield(
                      inputType: TextInputType.number,
                      controller: phonecontroller,
                      hintext: 'Enter Mobile Number',
                    ),
                    addVerticalSpace(15),
                    Text(
                      'OTP will be sent to above mobile number',
                      style: bodyText13normal(color: black),
                    ),
                    addVerticalSpace(50),
                    CustomButton(
                      buttonName: 'Send OTP',
                      onClick: () async {
                        
        /*                var response= await FirebaseFirestore.instance.collection("users")
                        .where("Number",isEqualTo: "+91${phonecontroller.text}").get();
                        
                        if(response.docs.isNotEmpty){
*/
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OtpVerify(
                                    phonenumber: phonecontroller.text,
                                  )));
                    /*    }else{
                          Fluttertoast.showToast(msg: "You are not registered");
                        }*/

                      },
                    ),
                    addVerticalSpace(height(context) * 0.06),
                    Text(
                      'Or Continue With',
                      style: bodytext12Bold(color: black),
                    ),
                    addVerticalSpace(25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            signInWithFacebook();
                          },
                          child: Container(
                            height: height(context) * 0.05,
                            width: width(context) * 0.38,
                            decoration: shadowDecoration(10, 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset('assets/images/fb.png'),
                                const Text('Facebook')
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            signInWithGoogle();
                          },
                          child: Container(
                            height: height(context) * 0.05,
                            width: width(context) * 0.38,
                            decoration: shadowDecoration(10, 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset('assets/images/google.png'),
                                const Text('Google')
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    addVerticalSpace(15),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()));
                        },
                        child: Text(
                          'Create New Account',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: primary),
                        ))
                  ],
                ),
              ))
        ],
      ),
    );
  }
}

class PageViewItemWidget extends StatelessWidget {
  final String text;
  final String text2;
  final String assetUrl;

  const PageViewItemWidget({
    Key? key,
    required this.text,
    required this.assetUrl,
    required this.text2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          addVerticalSpace(25),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SizedBox(
                height: height(context) * 0.2,
                child: Image.asset(
                  assetUrl,
                  fit: BoxFit.fill,
                )),
          ),
          addVerticalSpace(10),
          Container(
            width: width(context) * 0.9,
            child: Text(
              text,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: height(context) * 0.03,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: width(context) * 0.1),
            width: width(context),
            child: Text(
              text2,
              // style: bodyText1(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
