import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious_app/utils/constants.dart';
import 'package:delicious_app/views/home/home_screen.dart';
import 'package:delicious_app/views/humburger_items/save_address_screen.dart';
import 'package:delicious_app/views/my_cart/coupon_screen.dart';
import 'package:delicious_app/views/orders/my_orders_screens.dart';
import 'package:delicious_app/widget/BottomNavBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../widget/add_to_cart.dart';
import '../categories/vendor_category_screen.dart';

enum schedule { one, two }

class MyCartScreen extends StatefulWidget {
  const MyCartScreen({super.key});

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

double discount = 0;
List cartList = [];

class _MyCartScreenState extends State<MyCartScreen> {
  _getCartTotal() {
    cartamount = 0;
    FirebaseFirestore.instance
        .collection('Cart')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("products")
        .snapshots()
        .listen((value) {
      cartamount = 0;
      value.docs.forEach((element) {
        // print(element['name']);
        cartamount += double.parse((element['total'].toString()));
        print("-----------------");
        print(cartamount);

        // print(element['total']);
      });
      setState(() {});
    });
    // if (mounted) {
    //   setState(() {});
    // }
  }

  @override
  void initState() {
    _getCartTotal();
    _fetchCartList();
    fetchDeliveryFee();
    super.initState();
  }

  fetchDeliveryFee() {
    FirebaseFirestore.instance
        .collection("DeliveryFee")
        .doc("Fee")
        .get()
        .then((value) {
      if (mounted) {
        setState(() {});
        deliveryFee = double.parse(value.data()!["amount"].toString());
      }
    });
  }

  var value = schedule.one;
  num delivery = 0;
  num cartamount = 0;
  int qty = 1;
  int currentIndex = 0;
  int currentIndex2 = 0;
  final Stream<QuerySnapshot> cartProducts = FirebaseFirestore.instance
      .collection('Cart')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("products")
      .snapshots();

  _fetchCartList() {
    FirebaseFirestore.instance
        .collection('Cart')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("products")
        .snapshots()
        .listen((event) {
      cartList.clear();
      for (var doc in event.docs) {
        cartList.add(doc.data());
        if (mounted) {
          setState(() {});
        }
      }
      log(cartList.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavBar()),
            (route) => false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Cart",
            style: bodyText16w600(color: Colors.black),
          ),
          shadowColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Order',
                      style: bodyText16w600(color: black),
                    ),
                    addVerticalSpace(15),
                    StreamBuilder<QuerySnapshot>(
                        stream: cartProducts,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text("Something wrong occurred");
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text("Loading");
                          }

                          var cartData = snapshot.requireData;

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: cartData.size,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1, childAspectRatio: 4),
                            itemBuilder: (BuildContext context, int index) {
                              return CartTile(
                                price: cartData.docs[index]['price'],
                                imageURL: cartData.docs[index]['image'],
                                name: cartData.docs[index]['name'],
                                desc: cartData.docs[index]['desc'],
                                id: cartData.docs[index]['productID'],
                                stock: cartData.docs[index]['stock'],
                                insideProduct: false,
                                weight: cartData.docs[index]['weight'],
                                netWeight: cartData.docs[index]['netWeight'],
                                cartList: cartData.docs,
                                catId: cartData.docs[index]['catId'],
                                vendorPrice: cartData.docs[index]
                                    ['vendorPrice'],
                              );
                            },
                          );
                        }),
                    /*   child: ListView.builder(
                        itemCount: 2,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Polutry Chicken',
                                          style: bodyText14w600(color: black),
                                        ),
                                        Text(
                                          '900gms I Net: 450gms',
                                          style: bodyText11Small(
                                              color: black.withOpacity(0.5)),
                                        ),
                                        addVerticalSpace(5),
                                        Row(
                                          children: [
                                            const Text(
                                              'Rs.250',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black26),
                                            ),
                                            addHorizontalySpace(5),
                                            Text(
                                              'Rs.200',
                                              style: bodyText14w600(
                                                  color: primary),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  addHorizontalySpace(40),
                                  SizedBox(
                                    width: width(context) * 0.23,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (qty > 1) {
                                                qty--;
                                              } else if (qty <= 1) {}
                                            });
                                          },
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            decoration: shadowDecoration(3, 1),
                                            child: Icon(f
                                              Icons.remove,
                                              color: primary,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          qty.toString(),
                                          style: bodyText20w700(color: black),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              qty++;
                                            });
                                          },
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            decoration: shadowDecoration(3, 1),
                                            child: Icon(
                                              Icons.add,
                                              color: primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const Divider(
                                thickness: 1,
                                height: 30,
                              )
                            ],
                          );
                        }),*/

                    GestureDetector(
                        onTap: _getCartTotal,
                        child: const Text("If total not updated click here")),
                    addVerticalSpace(15),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => BottomNavBar()));
                        },
                        child: Text(
                          '+ Add more items',
                          style: bodyText14w600(color: primary),
                        )),
                    addVerticalSpace(10),
                    Container(
                      padding: EdgeInsets.zero,
                      height: height(context) * 0.06,
                      width: width(context) * 0.93,
                      decoration: myOutlineBoxDecoration(0, black, 8),
                      child: ListTile(
                        leading: Image.asset('assets/images/promocode.png'),
                        title: Text(
                          'Apply Promo Code',
                          style: bodyText14w600(color: black),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: black,
                        ),
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CouponScreen())).then((value) {
                            discount = double.parse(value.toString());
                            if (mounted) {
                              setState(() {});
                            }
                            log(discount.toString());
                          });
                        },
                      ),
                    ),
                    addVerticalSpace(10),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0, left: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: height(context) * 0.15,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Item Total',
                                  style: bodyText14w600(color: black),
                                ),
                                Text(
                                  'Delivery',
                                  style: bodyText14w600(color: black),
                                ),
                                Text(
                                  'Total',
                                  style: bodyText16w600(color: black),
                                )
                              ],
                            ),
                          ),
                          PriceBox(cartamount: cartamount)
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 5,
                    ),
                    addVerticalSpace(10),
                    Text(
                      'Delivery',
                      style: bodyText16w600(color: black),
                    ),
                    addVerticalSpace(8),
                    const DeliveryScheduleBoxWidget(),
                  ],
                ),
              ),
              OrderPlacedWidget(
                cartamount: cartamount,
                deliveryFee: deliveryFee,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PriceBox extends StatefulWidget {
  final num cartamount;

  const PriceBox({super.key, required this.cartamount});

  @override
  State<PriceBox> createState() => _PriceBoxState();
}

double deliveryFee = 40;

class _PriceBoxState extends State<PriceBox> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height(context) * 0.15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Rs.${widget.cartamount}',
            style: bodyText14w600(color: black),
          ),
          cartList.isNotEmpty
              ? Text(
                  'Rs. $deliveryFee',
                  style: bodyText14w600(
                      color: black,
                      isShowing: cartList.isNotEmpty && widget.cartamount > 400
                          ? true
                          : false),
                )
              : SizedBox(),
          cartList.isNotEmpty
              ? Text(
                  'Rs.${(widget.cartamount) - (widget.cartamount) * (discount / 100) + (widget.cartamount <= 400 ? deliveryFee : 0)}',
                  style: bodyText16w600(color: primary),
                )
              : Text(
                  'Rs.${(widget.cartamount)}',
                  style: bodyText16w600(color: primary),
                )
        ],
      ),
    );
  }
}

class OrderPlacedWidget extends StatefulWidget {
  final num cartamount;
  final double deliveryFee;

  const OrderPlacedWidget({
    Key? key,
    required this.cartamount,
    required this.deliveryFee,
  }) : super(key: key);

  @override
  State<OrderPlacedWidget> createState() => _OrderPlacedWidgetState();
}

String currentAddress = "";
String oldAddress = "";
String currentAddressReferenceId = "";

class _OrderPlacedWidgetState extends State<OrderPlacedWidget> {
  final _razorpay = Razorpay();

  fetchCurrentAddress() {
    FirebaseFirestore.instance
        .collection('Addresses')
        .where('customerID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      currentAddress = value.docs.first.data()["wholeAddress"];
      oldAddress = value.docs.first.data()["wholeAddress"];
      setState(() {
        latitude = double.parse(value.docs.first.data()["lat"].toString());
        longitude = double.parse(value.docs.first.data()["lng"].toString());
        print("------------------");
        print(latitude);
      });
      currentAddressReferenceId = value.docs.first.id;
      setState(() {});
    });
  }

  _updateReferenceAddress() async {
    await FirebaseFirestore.instance
        .collection('Addresses')
        .doc(currentAddressReferenceId)
        .update({'wholeAddress': currentAddress});
  }

  late Timer _timer;

  @override
  void initState() {
    fetchCurrentAddress();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
    fetchUserDetails();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (currentAddress != oldAddress) {
        _updateReferenceAddress();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  var userDetails;
  String vendorId = '';
  String vendorNumber = '';

  fetchUserDetails() {
    userDetails = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        // .where('Number',
        // isEqualTo: FirebaseAuth.instance.currentUser!.phoneNumber)
        .get()
        .then((value) {
      userDetails = value.data();
      setState(() {});
      log(value.data().toString());
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    var orderId = "${DateTime.now().microsecondsSinceEpoch}";
    sendNotification(orderId, "New Order Successful", token);
    Map aa = {};
    for (var i in cartList) {
      String vId = i['vendorId'];
      if (aa[vId] != null) {
        List temp = aa[vId];
        temp.add(i);
        aa[vId] = temp;
      } else {
        List temp = [];
        temp.add(i);
        aa[vId] = temp;
      }
    }
    print(aa);
    for (var j in aa.keys) {
      FirebaseFirestore.instance.collection("Orders").doc().set({
        "pickupAddress": "",
        "deliveryAddress": currentAddress,
        "uid": FirebaseAuth.instance.currentUser?.uid,
        "customerName": userDetails["Name"] ?? "",
        "customerPhone": userDetails["Number"] ?? "",
        "customerLatlong": {"lat": latitude, "long": longitude},
        "denied": [],
        "rejectedBy": [],
        "deniedBy": false,
        "orderCompleted": false,
        "orderAccepted": false,
        "orderCancelled": false,
        "orderReturn": false,
        "orderProcess": false,
        "orderAccept": false,
        "orderShipped": false,
        "deliveryFees": widget.cartamount < 500 ? widget.deliveryFee : 0,
        "isPaid": true,
        "orderDenied": false,
        "totalAmount": ((widget.cartamount) -
            ((widget.cartamount) * (discount / 100)) +
            (widget.cartamount < 500 ? widget.deliveryFee : 0)),
        "createdAt": Timestamp.now(),
        "items": aa[j],
        "discount": (widget.cartamount) * (discount / 100),
        "paymentId": response.paymentId!,
        "paymentMethod": "ONLINE",
        "orderId": orderId,
        "status": "waiting", // whereIn: ["accepted", 'dispatched', 'picked']
        "vendorId": j,
        "deliveryPerson": "",
        "deliveryDate": SDate,
        "deliveryTime": Stime ?? DateTime.now().toString(),
        "vendorNumber": vendorNumber,
        "rating": "",
      });
    }
    for (var doc in vendorTokenList) {
      sendNotification(
          // "New Order Received", "\n by${userDetails["Name"]}", doc.trim());
          "New Order Received",
          "\n Desichikken",
          doc.trim());
    }
    // FirebaseFirestore.instance.collection("Orders").doc(orderId).set({
    //   "pickupAddress": "",
    //   "deliveryAddress": currentAddress,
    //   "uid": FirebaseAuth.instance.currentUser?.uid,
    //   "customerName": userDetails["Name"] ?? "",
    //   "customerPhone": userDetails["Number"] ?? "",
    //   "customerLatlong": {"lat": latitude, "long": longitude},
    //   "denied": [],
    //   "rejectedBy": [],
    //   "deniedBy": false,
    //   "orderCompleted": false,
    //   "orderAccepted": false,
    //   "orderCancelled": false,
    //   "orderReturn": false,
    //   "orderProcess": false,
    //   "orderAccept": false,
    //   "orderShipped": false,
    //   "deliveryFees": 50.0,
    //   "isPaid": true,
    //   "orderDenied": false,
    //   "totalAmount": ((widget.cartamount) -
    //       ((widget.cartamount) * (discount / 100)) +
    //       40),
    //   "createdAt": Timestamp.now(),
    //   "items": cartList,
    //   "discount": (widget.cartamount) * (discount / 100),
    //   "paymentId": response.paymentId!,
    //   "paymentMethod": "ONLINE",
    //   "orderId": orderId,
    //   "status": "waiting", // whereIn: ["accepted", 'dispatched', 'picked']
    //   "vendorId": "",
    //   "deliveryPerson": "",
    //   "deliveryDate": SDate,
    //   "deliveryTime": Stime ?? DateTime.now().toString(),
    //   "vendorNumber": vendorNumber,
    //   "rating": "",
    // }).then((value) {
    FirebaseFirestore.instance
        .collection('Cart')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("products")
        .get()
        .then((value) {
      final batch = FirebaseFirestore.instance.batch();

      for (var doc in value.docs) {
        batch.delete(doc.reference);
      }
      batch.commit();
    });
    FirebaseFirestore.instance.collection("Payments").doc(orderId).set({
      "orderId": orderId,
      "paymentId": response.paymentId!,
      "time": Timestamp.now(),
      "name": userDetails["Name"] ?? "",
      "amount":
          ((widget.cartamount) - ((widget.cartamount) * (discount / 100)) + 40),
      "vendorId": "",
      "uid": FirebaseAuth.instance.currentUser?.uid,
    }).then((value) {
      Fluttertoast.showToast(msg: "Order Successfully");

      // sendNotification(
      //     "New Order Received", "\n by${userDetails["Name"]}", doc.trim());
    });

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const MyOrdersScreen()));
    // });
  }

  List<String> vendorTokenList = [];

  Future<void> fetchIsVendorAvailable() async {
    vendorTokenList.clear();
    await FirebaseFirestore.instance.collection('vendors').get().then((value) {
      for (var doc in value.docs) {
        // log("distance${doc.data()}");

        if (doc.data().keys.contains("latitude") &&
            doc.data().keys.contains("longitude") &&
            doc.data().keys.contains("token")) {
          if ((calculateDistance(
                  latitude, longitude, doc["latitude"], doc["longitude"])) <=
              5) {
            vendorTokenList.add(doc.data()["token"]);
          }
        }
      }
    });
  }

  Future sendNotification(String title, String body, String token) async {
    String url = 'https://fcm.googleapis.com/fcm/send';

    String data;
    data = '{"notification": '
        '{"body": "$body", "title": "$title"}, "priority": "high",'
        ' "data": {"click_action": "FLUTTER_NOTIFICATION_CLICK"}, "to": "$token"}';
    String mykey =
        "AAAAGl6VFKY:APA91bHLSjT-_c5cG3wkr8Gop-bhV6_Y0gyRW29s7SZHLyxh8l9LgedxUKOTOd-NGXNBmZIhEtNyMsfTYJWxC39bQaB_OahvZwbWKFptvnshLKRz7cguBbPcIccd9pgVIoa2LCmubAWJ";
    final response = await http
        .post(
      Uri.parse(url),
      headers: <String, String>{
        "Content-Type": "application/json",
        "Keep-Alive": "timeout=5",
        "Authorization": "key=$mykey"
      },
      body: data,
    )
        .then((value) async {
      // await FirebaseFirestore.instance.collection("userNotification").add({
      //   "uid": FirebaseAuth.instance.currentUser?.uid,
      //   "createdAt": Timestamp.now(),
      //   "content": title + body
      // });
    });

    // print(response.body);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  final Stream<QuerySnapshot> address = FirebaseFirestore.instance
      .collection('Addresses')
      .where('customerID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .where('isDefault', isEqualTo: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    var options = {
      'key': 'rzp_test_E1MEHejU50nJcP',
      'amount': ((widget.cartamount) -
              ((widget.cartamount) * (discount / 100)) +
              40) *
          100,
      'name': 'Customer',
      'description': 'Test Payment',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'}
    };
    return Container(
      height: height(context) * 0.25,
      width: width(context),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: white,
          boxShadow: const [BoxShadow(blurRadius: 2, color: Colors.grey)],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: 'Deliver to: ',
                    style: bodyText12Small(color: black.withOpacity(0.4))),
                // TextSpan(text: 'John K.', style: bodyText14w600(color: black))
              ])),
              InkWell(
                onTap: () async {
                  await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SavedAddressScreen()))
                      .then((value) {
                    setState(() {
                      currentAddress = value["wholeAddress"];
                      latitude = double.parse(value["lat"]);
                      longitude = double.parse(value["lng"]);
                    });
                    log(currentAddress);
                  });
                },
                child: Text(
                  'Change',
                  style: bodyText14w600(color: primary),
                ),
              )
            ],
          ),
          addVerticalSpace(5),
          Text(currentAddress),
          const Divider(
            height: 30,
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pay using >',
                    style: bodyText12Small(color: black.withOpacity(0.4)),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  print('--------------');
                  print('latitute $latitude');
                  if (currentAddress == "") {
                    Fluttertoast.showToast(msg: "Please choose address");
                  } else if (deliveryOption == "Schedule" && Stime == null) {
                    Fluttertoast.showToast(
                        msg: "Please select delivery timing ");
                  } else if (cartList.isEmpty) {
                    Fluttertoast.showToast(msg: "your cart is empty");
                  } else {
                    fetchIsVendorAvailable().then((value) {
                      if (vendorTokenList.isNotEmpty) {
                        _razorpay.open(options);
                      } else {
                        Fluttertoast.showToast(
                            msg: "Service not available ( coming soon...)");
                      }
                    });
                  }
                },
                child: Container(
                  height: height(context) * 0.07,
                  width: width(context) * 0.5,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: myFillBoxDecoration(0, primary, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          cartList.isNotEmpty
                              ? Text(
                                  'Rs. ${(widget.cartamount) - ((widget.cartamount) * (discount / 100)) + (widget.cartamount < 500 ? widget.deliveryFee : 0)}',
                                  style: bodytext12Bold(color: white))
                              : Text(
                                  'Rs. ${(widget.cartamount) - ((widget.cartamount) * (discount / 100))}',
                                  style: bodytext12Bold(color: white)),
                          Text(
                            'Total',
                            style: bodyText12Small(color: white),
                          )
                        ],
                      ),
                      Text(
                        'Place Order >',
                        style: bodyText14w600(color: white),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class DeliveryScheduleBoxWidget extends StatefulWidget {
  const DeliveryScheduleBoxWidget({super.key});

  @override
  State<DeliveryScheduleBoxWidget> createState() =>
      _DeliveryScheduleBoxWidgetState();
}

var deliveryOption;

class _DeliveryScheduleBoxWidgetState extends State<DeliveryScheduleBoxWidget> {
  var value = schedule.one;
  int currentIndex = 0;
  int currentIndex2 = 0;
  bool isSwitch = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(10),
      height: isSwitch ? height(context) * 0.5 : height(context) * 0.17,
      width: width(context) * 0.96,
      decoration: shadowDecoration(10, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Instant Delivery',
                style: bodyText14w600(color: black),
              ),
              SizedBox(
                height: 20,
                child: Radio(
                    activeColor: primary,
                    value: schedule.one,
                    groupValue: value,
                    onChanged: (val) {
                      setState(() {
                        isSwitch = false;
                        deliveryOption = "Instant";
                      });
                      value = val as schedule;
                    }),
              )
            ],
          ),
          const Divider(
            height: 30,
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Scheduled Delivery',
                style: bodyText14w600(color: black),
              ),
              SizedBox(
                height: 10,
                child: Radio(
                    activeColor: primary,
                    value: schedule.two,
                    groupValue: value,
                    onChanged: (val) {
                      setState(() {
                        isSwitch = true;
                        deliveryOption = "Schedule";
                      });
                      value = val as schedule;
                    }),
              )
            ],
          ),
          if (isSwitch)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [addVerticalSpace(8), ScheduledDelivery()],
            )
        ],
      ),
    );
  }
}

// cart tile

class CartTile extends StatefulWidget {
  final num price;
  final num vendorPrice;
  final String imageURL;
  final String name;
  final String desc;
  final String id;
  final num stock;
  final num weight;
  final num netWeight;
  final bool insideProduct;
  final List cartList;
  final String catId;

  const CartTile(
      {super.key,
      required this.price,
      required this.vendorPrice,
      required this.imageURL,
      required this.name,
      required this.desc,
      required this.id,
      required this.stock,
      required this.insideProduct,
      required this.weight,
      required this.netWeight,
      required this.cartList,
      required this.catId});

  @override
  State<CartTile> createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: shadowDecoration(15, 0),
                height: height(context) * 0.08,
                width: width(context) * 0.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    widget.imageURL,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              addHorizontalySpace(10),
              SizedBox(
                height: height(context) * 0.08,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.name,
                      style: bodyText14w600(color: black),
                    ),
                    Text(
                      '${widget.weight}gms I Net: ${widget.netWeight}gms',
                      style: bodyText11Small(color: black.withOpacity(0.5)),
                    ),
                    addVerticalSpace(5),
                    Row(
                      children: [
                        Text(
                          'Rs.${widget.price}',
                          style: bodyText14w600(color: primary),
                        )
                      ],
                    )
                  ],
                ),
              ),
              addHorizontalySpace(40),
              Container(
                height: 25,
                width: width(context) * 0.19,
                decoration: myFillBoxDecoration(0, primary, 5),
                child: Center(
                  child: AddtoCart(
                    vendorId: FirebaseAuth.instance.currentUser!.uid,
                    id: widget.id,
                    insideProduct: true,
                    price: widget.price,
                    name: widget.name,
                    desc: widget.desc,
                    stock: widget.stock,
                    imageURL: widget.imageURL,
                    weight: widget.weight,
                    netWeight: widget.netWeight,
                    catId: widget.catId,
                    vendorPrice: widget.vendorPrice,
                  ),
                ),
              ),

              // SizedBox(
              //   width: width(context) * 0.23,
              //   child: Row(
              //     mainAxisAlignment:
              //         MainAxisAlignment.spaceBetween,
              //     children: [
              //       InkWell(
              //         onTap: () {
              //           setState(() {
              //             if (qty > 1) {
              //               qty--;
              //             } else if (qty <= 1) {}
              //           });
              //         },
              //         child: Container(
              //           height: 25,
              //           width: 25,
              //           decoration: shadowDecoration(3, 1),
              //           child: Icon(
              //             Icons.remove,
              //             color: primary,
              //           ),
              //         ),
              //       ),
              //       Text(
              //         qty.toString(),
              //         style: bodyText20w700(color: black),
              //       ),
              //       InkWell(
              //         onTap: () {
              //           setState(() {
              //             qty++;
              //           });
              //         },
              //         child: Container(
              //           height: 25,
              //           width: 25,
              //           decoration: shadowDecoration(3, 1),
              //           child: Icon(
              //             Icons.add,
              //             color: primary,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
          const Divider(
            thickness: 1,
            height: 30,
          )
        ],
      ),
    );
  }
}

class ScheduledDelivery extends StatefulWidget {
  const ScheduledDelivery({Key? key}) : super(key: key);

  @override
  State<ScheduledDelivery> createState() => _ScheduledDeliveryState();
}

String? selectSlot;

class _ScheduledDeliveryState extends State<ScheduledDelivery> {
  DateTime date = DateTime.now();

  final List _tablist = [
    DateFormat('EEEE,d,MMM,yyy').format(DateTime.now()),
    DateFormat('EEEE,d,MMM,yyy')
        .format(DateTime.now().add(const Duration(days: 1))),
    DateFormat('EEEE,d,MMM,yyy')
        .format(DateTime.now().add(const Duration(days: 2))),
  ];

/*
  selectDate() {
    DateTime now = DateTime.now();
    DateTime startTime = DateTime(now.year, now.month, now.day, 6, 0, 0);
    DateTime endTime = DateTime(now.year, now.month, now.day, 22, 0, 0);
    Duration step = Duration(hours: 2);

    List<String> timeSlots = [];

    while (startTime.isBefore(endTime)) {
      DateTime timeIncrement = startTime.add(step);
      timeSlots.add(DateFormat.Hm().format(timeIncrement));
      startTime = timeIncrement;
    }

    log(timeSlots.toString());
  }
*/

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _tablist.length,
        child: Column(
          children: [
            TabBar(
                isScrollable: true,
                onTap: (index) {
                  print(index);
                  setState(() {
                    if (index == 0) {
                      DateFormat('EEEE,d,MMM,yyy').format(DateTime.now());
                      setState(() {
                        SDate =
                            DateFormat('EEEE,d,MMM,yyy').format(DateTime.now());
                      });
                    } else if (index == 1) {
                      DateFormat('EEEE,d,MMM,yyy')
                          .format(DateTime.now().add(const Duration(days: 1)));
                      setState(() {
                        SDate = DateFormat('EEEE,d,MMM,yyy').format(
                            DateTime.now().add(const Duration(days: 1)));
                      });
                    } else if (index == 1) {
                      DateFormat('EEEE,d,MMM,yyy')
                          .format(DateTime.now().add(const Duration(days: 2)));
                      setState(() {
                        SDate = DateFormat('EEEE,d,MMM,yyy').format(
                            DateTime.now().add(const Duration(days: 2)));
                      });
                      print(index);
                    }
                  });
                },
                indicatorWeight: 0,
                indicatorPadding: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                indicatorColor: Colors.black,
                unselectedLabelColor: Colors.black,
                indicator: BoxDecoration(
                    color: primary, borderRadius: BorderRadius.circular(8)),
                // labelStyle: bodyText2Bold(context: context, color: primary),
                // unselectedLabelStyle: bodyText2(context: context),
                tabs: _tablist.map((e) {
                  return Tab(
                    child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: primary)),
                        child: Text(e)),
                  );
                }).toList()),
            SizedBox(
              height: height(context) * 0.3,
              child: TabBarView(children: [
                tommorrowDate(DateTime.now()),
                tommorrowDate(DateTime.now()
                    .add(const Duration(days: 1))
                    .subtract(Duration(
                      hours: DateTime.now().hour,
                      minutes: DateTime.now().minute,
                    ))),
                tommorrowDate(DateTime.now()
                    .add(const Duration(days: 2))
                    .subtract(Duration(
                      hours: DateTime.now().hour,
                      minutes: DateTime.now().minute,
                    ))),
              ]),
            ),
          ],
        ));
  }

  Widget tommorrowDate(DateTime now) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                'Select date and time',
                // style: bodyText1(context: context, color: textLightColor),
              ),
              const SizedBox(
                height: 20,
              ),
              GridView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 4.5),
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (DateTime(now.year, now.month, now.day, now.hour,
                                    now.minute, now.second)
                                .isBefore(DateTime(
                                    now.year, now.month, now.day, 10, 0, 0)) ==
                            true) {
                          selectSlot = '8 AM - 10 AM';
                          Stime = selectSlot;
                          log("HI ${selectSlot}");
                        }

                        log("HI ${DateTime.now()}");
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: selectSlot == '8 AM - 10 AM'
                                  ? primary
                                  : textLightColor),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        '8 AM - 10 AM',
                        style: bodyText1(
                            context: context,
                            color: selectSlot == '8 AM - 10 AM'
                                ? primary
                                : textLightColor),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (DateTime(now.year, now.month, now.day, now.hour,
                                    now.minute, now.second)
                                .isBefore(DateTime(
                                    now.year, now.month, now.day, 12, 0, 0)) ==
                            true) {
                          Stime = selectSlot;
                          selectSlot = '10 AM - 12 PM';
                        }
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: selectSlot == '10 AM - 12 PM'
                                  ? primary
                                  : textLightColor),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        '10 AM - 12 PM',
                        style: bodyText1(
                            context: context,
                            color: selectSlot == '10 AM - 12 PM'
                                ? primary
                                : textLightColor),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (DateTime(now.year, now.month, now.day, now.hour,
                                    now.minute, now.second)
                                .isBefore(DateTime(
                                    now.year, now.month, now.day, 14, 0, 0)) ==
                            true) {
                          Stime = selectSlot;
                          selectSlot = '12 PM - 2 PM';
                        }
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: selectSlot == '12 PM - 2 PM'
                                  ? primary
                                  : textLightColor),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        '12 PM - 2 PM',
                        style: bodyText1(
                            context: context,
                            color: selectSlot == '12 PM - 2 PM'
                                ? primary
                                : textLightColor),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (DateTime(now.year, now.month, now.day, now.hour,
                                    now.minute, now.second)
                                .isBefore(DateTime(
                                    now.year, now.month, now.day, 16, 0, 0)) ==
                            true) {
                          Stime = selectSlot;
                          selectSlot = '2 PM - 4 PM';
                        }
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: selectSlot == '2 PM - 4 PM'
                                  ? primary
                                  : textLightColor),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        '2 PM - 4 PM',
                        style: bodyText1(
                            context: context,
                            color: selectSlot == '2 PM - 4 PM'
                                ? primary
                                : textLightColor),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (DateTime(now.year, now.month, now.day, now.hour,
                                    now.minute, now.second)
                                .isBefore(DateTime(
                                    now.year, now.month, now.day, 18, 0, 0)) ==
                            true) {
                          Stime = selectSlot;
                          selectSlot = '4 PM - 6 PM';
                        }
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: selectSlot == '4 PM - 6 PM'
                                  ? primary
                                  : textLightColor),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        '4 PM - 6 PM',
                        style: bodyText1(
                            context: context,
                            color: selectSlot == '4 PM - 6 PM'
                                ? primary
                                : textLightColor),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (DateTime(now.year, now.month, now.day, now.hour,
                                    now.minute, now.second)
                                .isBefore(DateTime(
                                    now.year, now.month, now.day, 20, 0, 0)) ==
                            true) {
                          Stime = selectSlot;
                          selectSlot = '6 PM - 8 PM';
                        }
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: selectSlot == '6 PM - 8 PM'
                                  ? primary
                                  : textLightColor),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        '6 PM - 8 PM',
                        style: bodyText1(
                            context: context,
                            color: selectSlot == '6 PM - 8 PM'
                                ? primary
                                : textLightColor),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (DateTime(now.year, now.month, now.day, now.hour,
                                    now.minute, now.second)
                                .isBefore(DateTime(
                                    now.year, now.month, now.day, 22, 0, 0)) ==
                            true) {
                          Stime = selectSlot;
                          selectSlot = '8 PM - 10 PM';
                        }
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: selectSlot == '8 PM - 10 PM'
                                  ? primary
                                  : textLightColor),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        '8 PM - 10 PM',
                        style: bodyText1(
                            context: context,
                            color: selectSlot == '8 PM - 10 PM'
                                ? primary
                                : textLightColor),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (DateTime(now.year, now.month, now.day, now.hour,
                                    now.minute, now.second)
                                .isBefore(DateTime(
                                    now.year, now.month, now.day, 24, 0, 0)) ==
                            true) {
                          Stime = selectSlot;
                          selectSlot = '10 PM - 11 PM';
                        }
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: selectSlot == '10 PM - 11 PM'
                                  ? primary
                                  : textLightColor),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        '10 PM - 11 PM',
                        style: bodyText1(
                            context: context,
                            color: selectSlot == '10 PM - 11 PM'
                                ? primary
                                : textLightColor),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
