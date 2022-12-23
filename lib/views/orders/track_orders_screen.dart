import 'package:delicious_app/utils/constants.dart';
import 'package:delicious_app/views/humburger_items/contact_us_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../widget/custom_appbar.dart';

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen({super.key});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  int reviews = 80;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppbar(
          title: 'Track Orders',
          button: SizedBox(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: Text(
                'Order #1223537448',
                style: bodyText16w600(color: black),
              ),
              subtitle: Text(
                '08:00 P.M.   2 Item, Rs. 440',
                style: bodyText13normal(color: black.withOpacity(0.5)),
              ),
              trailing: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ContactUs()));
                },
                child: Text(
                  'HELP',
                  style: bodyText16w600(color: primary),
                ),
              ),
            ),
            SizedBox(
              height: height(context) * 0.55,
              width: width(context),
              child: Image.asset(
                'assets/images/map.png',
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Delivering in ',
                        style: bodyText14normal(color: Colors.black45),
                      ),
                      Text(
                        '10 Mins',
                        style: bodyText14w600(color: Colors.black),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                    width: width(context),
                    child: Slider(
                      activeColor: primary,
                      value: reviews.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          reviews = value.toInt();
                        });
                      },
                      min: 1,
                      max: 100,
                    ),
                  ),
                  Text(
                    'Your order is on the way',
                    style: bodyText14w600(color: black),
                  ),
                  addVerticalSpace(10),
                  Container(
                    margin: EdgeInsets.all(8),
                    height: height(context) * 0.08,
                    width: width(context) * 0.93,
                    decoration: shadowDecoration(10, 2),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/rajesh.png'),
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Rajesh Kumar ',
                                style: bodyText14w600(color: black)),
                            TextSpan(
                                text:
                                    'is your delivery boy \ncontact him and get details of your order',
                                style: bodyText13normal(color: black))
                          ])),
                          Icon(
                            Icons.call,
                            color: primary,
                          )
                        ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
