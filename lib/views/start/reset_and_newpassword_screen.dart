import 'package:delicious_app/views/start/login_screen.dart';
import 'package:delicious_app/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../utils/constants.dart';
import '../../widget/custom_gradient_button.dart';

class ResetAndNewPassWordScreen extends StatelessWidget {
  const ResetAndNewPassWordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        'Reset Password',
                        style: bodyText20w700(color: black),
                      ),
                      addVerticalSpace(10),
                      SizedBox(
                        width: width(context) * 0.85,
                        child: const Text(
                            'Set the new password for your account so you can login and access all the features.'),
                      ),
                    ],
                  ),
                )
              ],
            ),
            addVerticalSpace(20),
            Text(
              'Enter new password',
              style: bodyText14w600(color: black),
            ),
            addVerticalSpace(10),
            CustomTextfield(
              hintext: '',
              prefixIcon: Icon(
                Icons.lock,
                color: ligthRed,
              ),
              suffixIcon: Icon(Icons.remove_red_eye),
            ),
            addVerticalSpace(25),
            Text(
              'Confirm password',
              style: bodyText14w600(color: black),
            ),
            addVerticalSpace(10),
            CustomTextfield(
              hintext: '',
              prefixIcon: Icon(
                Icons.lock,
                color: ligthRed,
              ),
              suffixIcon: Icon(Icons.remove_red_eye),
            ),
            Spacer(),
            CustomButton(
                buttonName: 'Reset Password',
                onClick: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PasswordResetSuccesful()));
                }),
            addVerticalSpace(10)
          ],
        ),
      ),
    );
  }
}

class PasswordResetSuccesful extends StatelessWidget {
  const PasswordResetSuccesful({super.key});

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
                Color.fromRGBO(255, 255, 255, 0.1)
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
                  .createShader(bounds);
            },
          ),
          Image.asset('assets/images/succesicon.png'),
          addVerticalSpace(height(context) * 0.05),
          Text(
            'Congrats!',
            style: bodyText30W400(color: primary),
          ),
          addVerticalSpace(10),
          const Text(
            'Password reset succesful',
            style: TextStyle(
              fontSize: 23,
            ),
          ),
          Spacer(),
          SizedBox(
              width: width(context) * 0.4,
              child: CustomButton(
                  buttonName: 'Back',
                  onClick: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => LogInScreen())));
                  })),
          addVerticalSpace(40)
        ],
      ),
    );
  }
}
