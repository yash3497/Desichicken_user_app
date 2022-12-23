import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious_app/utils/constants.dart';
import 'package:delicious_app/views/humburger_items/contact_us_screen.dart';
import 'package:delicious_app/widget/custom_appbar.dart';
import 'package:delicious_app/widget/custom_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class OrderStatusScreen extends StatefulWidget {
  final Map productDetails;

  const OrderStatusScreen({super.key, required this.productDetails});

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  @override
  void initState() {
    // Future.delayed(const Duration(seconds: 2), () {
    //   showRatingDeliveryBoy(context);
    // });
    super.initState();
    log(widget.productDetails["orderId"]);
    fetchOrderDetails(widget.productDetails["orderId"]);
  }

  var orderDetais;

  fetchOrderDetails(orderId) async {
    await FirebaseFirestore.instance
        .collection("Orders")
        .doc(orderId)
        .get()
        .then((value) {
      log(value.data().toString());
      orderDetais = value.data();
      if (mounted) {
        setState(() {});
      }
    });
  }

  updateOrderRating(String orderId, String rating) async {
    print('calling');
    await FirebaseFirestore.instance.collection("Orders").doc(orderId).update({
      "rating": rating,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: CustomAppbar(
            title: 'Order Status',
            button: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ContactUs()));
                },
                child: Text(
                  'HELP',
                  style: bodyText14w600(color: primary),
                ))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Order',
                style: bodyText16w600(color: black),
              ),
              addVerticalSpace(15),
              SizedBox(
                height: height(context) * 0.2,
                child: ListView.builder(
                    itemCount: widget.productDetails["items"].length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: shadowDecoration(15, 0),
                                height: height(context) * 0.08,
                                width: width(context) * 0.2,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.asset(
                                    'assets/images/chicken1.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              addHorizontalySpace(10),
                              SizedBox(
                                height: height(context) * 0.08,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      widget.productDetails["items"][index]
                                          ["name"],
                                      style: bodyText14w600(color: black),
                                    ),
                                    Text(
                                      '${widget.productDetails["items"][index]["weight"]}gms',
                                      style: bodyText11Small(
                                          color: black.withOpacity(0.5)),
                                    ),
                                    addVerticalSpace(5),
                                    Row(
                                      children: [
                                        // const Text(
                                        //   'Rs.250',
                                        //   style: TextStyle(
                                        //       fontSize: 12,
                                        //       decoration:
                                        //           TextDecoration.lineThrough,
                                        //       fontWeight: FontWeight.w500,
                                        //       color: Colors.black26),
                                        // ),
                                        // addHorizontalySpace(5),
                                        Text(
                                          'Rs.${widget.productDetails["items"][index]["price"]}',
                                          style: bodyText14w600(color: primary),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              addHorizontalySpace(40),
                              Container(
                                height: 30,
                                width: width(context) * 0.2,
                                decoration: shadowDecoration(7, 1),
                                child: Center(
                                    child: Text(
                                  'Qty-${widget.productDetails["items"][index]["productQty"]}',
                                  style: bodytext12Bold(color: black),
                                )),
                              )
                            ],
                          ),
                          const Divider(
                            thickness: 1,
                            height: 30,
                          )
                        ],
                      );
                    }),
              ),
              addVerticalSpace(25),
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(1),
                height: height(context) * 0.16,
                width: width(context) * 0.93,
                decoration: shadowDecoration(10, 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Item Total',
                          style: bodyText14w600(color: black),
                        ),
                        Text(
                          'Rs.${widget.productDetails["totalAmount"] - widget.productDetails["deliveryFees"]}',
                          style: bodyText14w600(color: black),
                        )
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delivery',
                          style: bodyText14w600(color: black),
                        ),
                        Text(
                          'Rs.${widget.productDetails["deliveryFees"]}',
                          style: bodyText14w600(color: black),
                        )
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: bodyText16w600(color: black),
                        ),
                        Text(
                          'Rs.${widget.productDetails["totalAmount"]}',
                          style: bodyText16w600(color: primary),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              addVerticalSpace(15),
              orderDetais != null
                  ? StepperProgressWidget(
                      stepperDetails: {
                        "acceptTime":
                            orderDetais["acceptTime"] ?? "Order not accepted",
                        "deliveryTime":
                            orderDetais["deliveryTime"] ?? "In Process",
                        "deliveryDate": orderDetais["deliveryDate"],
                        "orderId": orderDetais["orderId"],
                        "orderCompleted": orderDetais["orderCompleted"],
                      },
                    )
                  : SizedBox(),
              addVerticalSpace(15),
              Container(
                margin: const EdgeInsets.all(1),
                height: height(context) * 0.09,
                width: width(context) * 0.93,
                decoration: shadowDecoration(10, 2),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
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
                              text: widget.productDetails["deliveryPerson"],
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
              ),
              addVerticalSpace(15),
              Container(
                margin: const EdgeInsets.all(2),
                padding: const EdgeInsets.only(top: 12),
                height: height(context) * 0.22,
                width: width(context) * 0.93,
                decoration: shadowDecoration(10, 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Rate Order',
                      style: bodyText20w700(color: black),
                    ),
                    const Divider(
                      // height: 30,
                      thickness: 1,
                    ),
                    Text(
                      'How is the order?',
                      style: bodyText20w700(color: black),
                    ),
                    Text(
                      'Please rate order here....',
                      style: bodyText14normal(color: black),
                    ),
                    RatingBar.builder(
                      initialRating: orderDetais['rating'] != ""
                          ? double.parse(orderDetais['rating'])
                          : 4,
                      minRating: 1,
                      ignoreGestures:
                          orderDetais['rating'] != "" ? true : false,
                      itemSize: 40,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      unratedColor: Colors.grey.shade300,
                      itemBuilder: (context, _) => Icon(
                        Icons.star_rate_rounded,
                        color: primary,
                      ),
                      onRatingUpdate: (rating) {
                        updateOrderRating(
                            orderDetais['orderId'], rating.toString());
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showRatingDeliveryBoy(BuildContext context) {
    return showModalBottomSheet(
      context: context,

      backgroundColor: Colors.white,
      //elevates modal bottom screen
      elevation: 10,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        return Container(
          height: height(context) * 0.5,
          padding: const EdgeInsets.all(15),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              addVerticalSpace(15),
              Text(
                'Rate Delivery Boy',
                style: bodyText20w700(color: black),
              ),
              const Divider(
                height: 30,
                thickness: 1,
              ),
              addVerticalSpace(10),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/vendor.png'),
                    ),
                    addHorizontalySpace(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rajesh Kumar',
                          style: bodyText16w600(color: black),
                        ),
                        Text(
                          'Member Since: July 16, 2020',
                          style: bodyText13normal(
                              color: Colors.black.withOpacity(0.6)),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: primary,
                        ),
                        Text(
                          '4.8',
                          style: bodyText14w600(color: black),
                        )
                      ],
                    )
                  ],
                ),
              ),
              addVerticalSpace(25),
              Text(
                'How is your product?',
                style: bodyText20w700(color: black),
              ),
              addVerticalSpace(8),
              Text(
                'Please rate you Amaze Fresh....',
                style: bodyText14w600(color: black),
              ),
              addVerticalSpace(20),
              RatingBar.builder(
                initialRating: 4.5,
                minRating: 1,
                itemSize: 50,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                unratedColor: Colors.teal.shade100,
                itemBuilder: (context, _) => Icon(
                  Icons.star_rate_rounded,
                  color: primary,
                ),
                onRatingUpdate: (rating) {},
              ),
              const Divider(
                thickness: 1,
              ),
              addVerticalSpace(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: height(context) * 0.06,
                      width: width(context) * 0.42,
                      decoration: myFillBoxDecoration(
                          0, const Color.fromRGBO(255, 170, 190, 1), 15),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: bodyText14w600(color: black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: height(context) * 0.06,
                      width: width(context) * 0.42,
                      child: CustomButton(
                          buttonName: 'Submit',
                          onClick: () {
                            Navigator.pop(context);
                          }))
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class StepperProgressWidget extends StatefulWidget {
  final Map stepperDetails;

  const StepperProgressWidget({super.key, required this.stepperDetails});

  @override
  State<StepperProgressWidget> createState() => _StepperProgressWidgetState();
}

class _StepperProgressWidgetState extends State<StepperProgressWidget> {
  int current_step = 0;

  Future<dynamic> showCancel(BuildContext context) {
    return showModalBottomSheet(
      context: context,

      backgroundColor: Colors.white,
      //elevates modal bottom screen
      elevation: 10,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        return Container(
          height: height(context) * 0.2,
          padding: const EdgeInsets.all(15),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              addVerticalSpace(15),
              Text(
                'Cancel my order',
                style: bodyText20w700(color: black),
              ),
              const Divider(
                height: 30,
                thickness: 1,
              ),
              addVerticalSpace(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: height(context) * 0.06,
                      width: width(context) * 0.42,
                      decoration: myFillBoxDecoration(
                          0, const Color.fromRGBO(255, 170, 190, 1), 15),
                      child: Center(
                        child: Text(
                          'No',
                          style: bodyText14w600(color: black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: height(context) * 0.06,
                      width: width(context) * 0.42,
                      child: CustomButton(
                          buttonName: 'Yes',
                          onClick: () {
                            FirebaseFirestore.instance
                                .collection("Orders")
                                .doc(widget.stepperDetails["orderId"])
                                .update({"orderCancelled": true}).then((value) {
                              Navigator.pop(context);
                            });
                          }))
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Step> steps = [
      Step(
        state: StepState.complete,
        title: FittedBox(
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  showCancel(context);
                },
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: 'Order Confirmed', style: TextStyle(color: black)),
                  !widget.stepperDetails['orderCompleted']
                      ? const TextSpan(
                          text: '\nCancel order',
                          style: TextStyle(fontSize: 12, color: Colors.orange))
                      : TextSpan(text: ''),
                ])),
              ),
              addHorizontalySpace(20),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: '${widget.stepperDetails["acceptTime"].toString()}\n',
                    style: TextStyle(color: black)),
                /*     const TextSpan(
                      text: '\n2:35 AM',
                      style: TextStyle(fontSize: 12, color: Colors.black54))*/
              ])),
            ],
          ),
        ),
        content: const Text(''),
        isActive: true,
      ),
      Step(
        state: StepState.complete,
        title: FittedBox(
          child: Row(
            children: [
              RichText(
                  text: TextSpan(children: [
                TextSpan(text: 'Shipped  ', style: TextStyle(color: black)),
                const TextSpan(
                    text: '\nTrack your order',
                    style: TextStyle(fontSize: 12, color: Colors.black54))
              ])),
              addHorizontalySpace(20),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text:
                        '${widget.stepperDetails["deliveryTime"].toString()}\n',
                    style: TextStyle(color: black)),
                /*const TextSpan(
                        text: '\n1:35 AM',
                        style: TextStyle(fontSize: 12, color: Colors.black54))*/
              ])),
            ],
          ),
        ),
        content: const Text(''),
        isActive: true,
      ),
      Step(
        title: FittedBox(
          child: Row(
            children: [
              RichText(
                  text: TextSpan(children: [
                TextSpan(text: 'Delivered    ', style: TextStyle(color: black)),
                const TextSpan(
                    text: '\nItem delivered',
                    style: TextStyle(fontSize: 12, color: Colors.black54))
              ])),
              addHorizontalySpace(25),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text:
                        '${widget.stepperDetails["deliveryDate"].toString()}\n',
                    style: TextStyle(color: black)),
                /*  const TextSpan(
                        text: '\nExpected',
                        style: TextStyle(fontSize: 12, color: Colors.black54))*/
              ])),
            ],
          ),
        ),
        content: const Text(''),
        state: StepState.complete,
        isActive: true,
      ),
    ];

    return Container(
      margin: const EdgeInsets.all(1),
      padding: const EdgeInsets.all(10),
      height: height(context) * 0.35,
      width: width(context) * 0.93,
      decoration: shadowDecoration(10, 2),
      child: Theme(
        data: ThemeData(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: const Color.fromRGBO(42, 217, 87, 1),
              ),
        ),
        child: Stepper(
          physics: const NeverScrollableScrollPhysics(),
          controlsBuilder: (context, details) {
            return Container();
          },
          currentStep: this.current_step,
          steps: steps,
          type: StepperType.vertical,
          onStepTapped: (step) {
            setState(() {
              current_step = step;
            });
          },
          onStepContinue: () {
            setState(() {
              if (current_step < steps.length - 1) {
                current_step = current_step + 1;
              } else {
                current_step = 0;
              }
            });
          },
          onStepCancel: () {
            setState(() {
              if (current_step > 0) {
                current_step = current_step - 1;
              } else {
                current_step = 0;
              }
            });
          },
        ),
      ),
    );
  }
}
