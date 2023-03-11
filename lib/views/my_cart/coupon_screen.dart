import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../utils/constants.dart';
import '../../widget/custom_appbar.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  double discount = 0;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final controller = TextEditingController();

  var currentUid = FirebaseAuth.instance.currentUser!.uid;
  List couponList = [];

  fetchCoupons() {
    firebaseFirestore.collection("Coupons").snapshots().listen((event) {
      couponList.clear();
      for (var doc in event.docs) {
        couponList.add(doc.data());
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    fetchCoupons();
    super.initState();
  }

  Future<double> fetchDiscount(String code) async {
    double discountX = 0;
    var doc = await firebaseFirestore
        .collection("Coupons")
        .where('couponCode', isEqualTo: code)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        Fluttertoast.showToast(msg: 'Invalid Coupon Code');
        discountX = 0;
      } else {
        discountX =
            double.parse(value.docs[0].data()['discountRate'].toString());
      }
    });
    return discountX;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppbar(title: 'Coupons', button: SizedBox()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: height(context) * 0.05,
                  width: width(context) * 0.6,
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Coupon Code',
                        contentPadding: EdgeInsets.only(left: 20),
                        hintStyle: bodyText13normal(color: black)),
                  ),
                ),
                TextButton(
                    onPressed: () async {
                      discount = await fetchDiscount(controller.text);
                      log(discount.toString());
                      if (discount > 0) {
                        Navigator.pop(context, discount);
                      }
                    },
                    child: Text(
                      'Apply',
                      style: bodyText14w600(color: primary),
                    ))
              ],
            ),
            const Divider(
              thickness: 1,
            ),
            addVerticalSpace(15),
            Text(
              'Available Coupons',
              style: bodyText16w600(color: black),
            ),
            addVerticalSpace(20),
            Expanded(
                child: ListView.builder(
                    itemCount: couponList.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (ctx, i) {
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Get ${couponList[i]["discountRate"]} % Off',
                              style: bodyText14w600(color: black),
                            ),
                            addVerticalSpace(15),
                            SizedBox(
                              width: width(context) * 0.75,
                              child: RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: '${couponList[i]["descText"]}',
                                    style: bodyText13normal(
                                        color: black.withOpacity(0.7))),
                                // TextSpan(
                                //     text: ' +MORE',
                                //     style: bodyText13normal(color: primary))
                              ])),
                            ),
                            addVerticalSpace(10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DottedBorder(
                                  borderType: BorderType.RRect,
                                  color: primary,
                                  strokeWidth: 2,
                                  radius: Radius.circular(8),
                                  child: Container(
                                    height: height(context) * 0.037,
                                    width: 100,
                                    color: ligthRed,
                                    child: Center(
                                      child: Text(
                                        '${couponList[i]["couponCode"]}',
                                        style: bodyText13normal(color: primary),
                                      ),
                                    ),
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {
                                      discount = double.parse(couponList[i]
                                              ["discountRate"]
                                          .toString());
                                      controller.text = couponList[i]
                                              ["couponCode"]
                                          .toString();
                                      setState(() {});
                                    },
                                    child: Text(
                                      'Apply',
                                      style: bodyText14w600(color: primary),
                                    ))
                              ],
                            ),
                            const Divider(
                              height: 20,
                              thickness: 1,
                            ),
                          ],
                        ),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
