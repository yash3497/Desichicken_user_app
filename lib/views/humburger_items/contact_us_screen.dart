import 'package:delicious_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          addVerticalSpace(20),
          Stack(
            children: [
              ShaderMask(
                child: const Image(
                  image: AssetImage("assets/images/splash1.png"),
                ),
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(colors: [
                    Color.fromRGBO(255, 255, 255, 1),
                    Color.fromRGBO(255, 255, 255, 0.3)
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
                      .createShader(bounds);
                },
              ),
              Positioned(
                top: 33,
                left: 40,
                child: Row(
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back_ios)),
                    addHorizontalySpace(width(context) * 0.2),
                    Text(
                      'Contact us',
                      style: bodyText16w600(color: black),
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(
              height: height(context) * 0.15,
              child: Image.asset('assets/images/contactus.png')),
          addVerticalSpace(15),
          Text(
            'That’s a magnetic urge to get in touch with us!',
            style: bodyText13normal(color: black),
          ),
          addVerticalSpace(height(context) * 0.05),
          InkWell(
            onTap: () async {
              String email = 'test@gmail.com';
              String subject = 'This is a test email';
              String body = 'This is a test email body';

              String emailUrl = "mailto:$email?subject=$subject&body=$body";

              if (await canLaunchUrl(Uri.parse(emailUrl))) {
                await launchUrl(Uri.parse(emailUrl));
              } else {
                throw "Error occured sending an email";
              }
            },
            child: Container(
              height: height(context) * 0.06,
              width: width(context) * 0.9,
              decoration: myOutlineBoxDecoration(1, primary, 10),
              child: Center(
                child: Text(
                  'Drop us a line',
                  style: bodyText16w600(color: black),
                ),
              ),
            ),
          ),
          addVerticalSpace(15),
          InkWell(
            onTap: () async {
              String telephoneNumber = '+9147012345678';
              String telephoneUrl = "tel:$telephoneNumber";
              if (await canLaunchUrl(Uri.parse(telephoneUrl))) {
              await launchUrl(Uri.parse(telephoneUrl));
              } else {
              throw "Error occurred trying to call that number.";
              }
            },
            child: Container(
              height: height(context) * 0.06,
              width: width(context) * 0.9,
              decoration: myOutlineBoxDecoration(1, primary, 10),
              child: Center(
                child: Text(
                  'Call us',
                  style: bodyText16w600(color: black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
