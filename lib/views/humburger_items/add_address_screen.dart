import 'package:delicious_app/utils/constants.dart';
import 'package:delicious_app/views/humburger_items/save_address_screen.dart';
import 'package:delicious_app/widget/custom_gradient_button.dart';
import 'package:delicious_app/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../widget/custom_appbar.dart';

class AddNewAddressScreen extends StatefulWidget {
  const AddNewAddressScreen({super.key});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  bool isShow = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppbar(title: 'Add Address', button: SizedBox()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height(context) * 0.89,
              width: width(context) * 1,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/Maps.png'))),
              child: Column(
                children: [
                  Spacer(),
                  !isShow
                      ? Container(
                          height: height(context) * 0.56,
                          width: width(context),
                          decoration: BoxDecoration(
                              color: white,
                              boxShadow: [
                                BoxShadow(color: Colors.grey, blurRadius: 5)
                              ],
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                CustomTextfield(
                                    hintext: 'Search for area/Locality'),
                                SizedBox(
                                  height: height(context) * 0.05,
                                  child: TextField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText:
                                            'Flat no / Building name / Streer name',
                                        contentPadding:
                                            EdgeInsets.only(left: 20),
                                        hintStyle: bodyText13normal(
                                            color: black.withOpacity(0.5))),
                                  ),
                                ),
                                const Divider(
                                  thickness: 1,
                                ),
                                SizedBox(
                                  height: height(context) * 0.05,
                                  child: TextField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Landmark',
                                        contentPadding:
                                            EdgeInsets.only(left: 20),
                                        hintStyle: bodyText13normal(
                                            color: black.withOpacity(0.5))),
                                  ),
                                ),
                                const Divider(
                                  thickness: 1,
                                ),
                                SizedBox(
                                  height: height(context) * 0.05,
                                  child: TextField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'City',
                                        contentPadding:
                                            EdgeInsets.only(left: 20),
                                        hintStyle: bodyText13normal(
                                            color: black.withOpacity(0.5))),
                                  ),
                                ),
                                const Divider(
                                  thickness: 1,
                                ),
                                SizedBox(
                                  height: height(context) * 0.05,
                                  child: TextField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Email',
                                        contentPadding:
                                            EdgeInsets.only(left: 20),
                                        hintStyle: bodyText13normal(
                                            color: black.withOpacity(0.5))),
                                  ),
                                ),
                                const Divider(
                                  thickness: 1,
                                ),
                                SizedBox(
                                  height: height(context) * 0.05,
                                  child: TextField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Full Name',
                                        contentPadding:
                                            EdgeInsets.only(left: 20),
                                        hintStyle: bodyText13normal(
                                            color: black.withOpacity(0.5))),
                                  ),
                                ),
                                const Divider(
                                  thickness: 1,
                                ),
                                SizedBox(
                                  height: height(context) * 0.05,
                                  child: TextField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Mobile Number',
                                        contentPadding:
                                            EdgeInsets.only(left: 20),
                                        hintStyle: bodyText13normal(
                                            color: black.withOpacity(0.5))),
                                  ),
                                ),
                                const Divider(
                                  thickness: 1,
                                ),
                                CustomButton(
                                    buttonName: 'Save & Proceed',
                                    onClick: () {
                                      setState(() {
                                        isShow = !isShow;
                                      });
                                    })
                              ],
                            ),
                          ),
                        )
                      : Container(
                          height: height(context) * 0.3,
                          width: width(context),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: white,
                              boxShadow: [
                                BoxShadow(color: Colors.grey, blurRadius: 5)
                              ],
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15))),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Search for Area/Locality',
                                  style:
                                      bodyText13normal(color: Colors.black54),
                                ),
                                addVerticalSpace(10),
                                Text(
                                  'Mahadev Gopal Patil road, Mahadev Gopal Patil..............',
                                  style: bodyText14w600(color: Colors.black),
                                ),
                                Divider(
                                  thickness: 1,
                                ),
                                addVerticalSpace(10),
                                Text(
                                  'Flat no / Building name / Street name',
                                  style:
                                      bodyText13normal(color: Colors.black54),
                                ),
                                SizedBox(
                                  height: height(context) * 0.05,
                                  child: TextField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '12',
                                        // contentPadding: EdgeInsets.only(left: 20),
                                        hintStyle: bodyText14w600(
                                            color: black.withOpacity(0.5))),
                                  ),
                                ),
                                const Divider(
                                  thickness: 1,
                                ),
                                addVerticalSpace(10),
                                CustomButton(
                                    buttonName: "Done",
                                    onClick: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SavedAddressScreen()));
                                    })
                              ]),
                        )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
