import 'dart:developer';

import 'package:delicious_app/utils/constants.dart';
import 'package:delicious_app/widget/custom_appbar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:share_plus/share_plus.dart';

class ReferAndEarnScreen extends StatelessWidget {
  const ReferAndEarnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppbar(title: 'Refer your friend', button: SizedBox()),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Image.asset('assets/images/refer1.png')),
          Text(
            'A friend in need is a friend indeed',
            style: bodyText20w700(color: black),
          ),
          addVerticalSpace(10),
          Text(
            'Your unique referral code is',
            style: bodyText14normal(color: black.withOpacity(0.7)),
          ),
          addVerticalSpace(20),
          DottedBorder(
            borderType: BorderType.RRect,
            color: primary,
            strokeWidth: 2,
            radius: Radius.circular(8),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Container(
                height: height(context) * 0.04,
                width: 100,
                color: ligthRed,
                child: Center(
                  child: Text(
                    'L5QC1664',
                    style: bodyText14w600(color: primary),
                  ),
                ),
              ),
            ),
          ),
          addVerticalSpace(15),
          Text(
            'Know more',
            style: bodyText20w700(color: black),
          ),
          addVerticalSpace(20),
          SizedBox(
            width: width(context) * 0.7,
            child: const Text(
              'Congratulations! The lorem ipsum is a placeholder text used in publishing and graphic design',
              textAlign: TextAlign.center,
            ),
          ),
          addVerticalSpace(40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
           /*   Container(
                height: 36,
                width: width(context) * 0.4,
                decoration: myOutlineBoxDecoration(1, black, 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/wp.png'),
                    addHorizontalySpace(5),
                    Text(
                      'Whatsapp',
                      style: bodyText14w600(color: black),
                    )
                  ],
                ),
              ),*/
              InkWell(
                onTap: (){
                  log("message");
                  Share.share('check out my website https://example.com');
                },
                child: Container(
                  height: 36,
                  width: width(context) * 0.4,
                  decoration: myOutlineBoxDecoration(1, black, 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.share),
                      addHorizontalySpace(5),
                      Text(
                        'More',
                        style: bodyText14w600(color: black),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
