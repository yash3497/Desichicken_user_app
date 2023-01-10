import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious_app/utils/constants.dart';
import 'package:delicious_app/views/orders/order_status_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widget/BottomNavBar.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    fetchActiveOrders();
    fetchCompletedOrders();
    fetchCancelOrders();
    super.initState();
  }

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  var currentUid = FirebaseAuth.instance.currentUser!.uid;

  List activeOrderList = [];
  List completedOrderList = [];
  List cancelOrderList = [];

  fetchActiveOrders() {
    print(currentUid);
    firebaseFirestore
        .collection("Orders")
        .where("uid", isEqualTo: currentUid)
        .where("orderCompleted", isEqualTo: false)
        .where("orderCancelled", isEqualTo: false)
        .orderBy("orderId", descending: true)
        .snapshots()
        .listen((event) {
      activeOrderList.clear();
      for (var doc in event.docs) {
        activeOrderList.add(doc.data());
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  fetchCompletedOrders() {
    firebaseFirestore
        .collection("Orders")
        .where("uid", isEqualTo: currentUid)
        .where("orderCompleted", isEqualTo: true)
        .snapshots()
        .listen((event) {
      completedOrderList.clear();
      for (var doc in event.docs) {
        completedOrderList.add(doc.data());
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  fetchCancelOrders() {
    firebaseFirestore
        .collection("Orders")
        .where("uid", isEqualTo: currentUid)
        .where("orderCancelled", isEqualTo: true)
        .snapshots()
        .listen((event) {
      cancelOrderList.clear();
      for (var doc in event.docs) {
        cancelOrderList.add(doc.data());
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const BottomNavBar()));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "My Orders",
            style: bodyText16w600(color: Colors.black),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => BottomNavBar()));
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          shadowColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            SizedBox(
              height: height(context) * 0.04,
              child: TabBar(
                  controller: _tabController,
                  isScrollable: false,
                  indicatorColor: primary,
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: primary,
                  unselectedLabelColor: black.withOpacity(0.4),
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                  tabs: const [
                    Tab(
                      text: 'Active Order',
                    ),
                    Tab(
                      text: 'Completed',
                    ),
                    Tab(
                      text: 'Cancelled',
                    )
                  ]),
            ),
            Expanded(
                child: TabBarView(
              controller: _tabController,
              children: [
                ListView.builder(
                    itemCount: activeOrderList.length,
                    itemBuilder: (context, index) {
                      return MyOrdersDetails(
                        status: 'Active',
                        statusColor: primary,
                        returnWidget: const SizedBox(),
                        showDetailAndTrackButton: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OrderStatusScreen(
                                            productDetails:
                                                activeOrderList[index],
                                          )));
                            },
                            child: Text(
                              'Show full details',
                              style: bodyText14w600(color: primary),
                            )),
                        productDetails: activeOrderList[index],
                      );
                    }),
                SizedBox(
                  height: height(context) * 0.8,
                  child: ListView.builder(
                      itemCount: completedOrderList.length,
                      itemBuilder: (context, index) {
                        return MyOrdersDetails(
                          status: 'Completed',
                          statusColor: Colors.green,
                          returnWidget: Container(
                            height: 25,
                            width: width(context) * 0.25,
                            decoration: myOutlineBoxDecoration(1, primary, 10),
                            child: Center(
                                child: Text(
                              'Return',
                              style: bodytext12Bold(color: primary),
                            )),
                          ),
                          showDetailAndTrackButton: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OrderStatusScreen(
                                              productDetails:
                                                  completedOrderList[index],
                                            )));
                              },
                              child: Text(
                                'Show full details',
                                style: bodyText14w600(color: primary),
                              )),
                          productDetails: completedOrderList[index],
                        );
                      }),
                ),
                SizedBox(
                  height: height(context) * 0.8,
                  child: ListView.builder(
                      itemCount: cancelOrderList.length,
                      itemBuilder: (context, index) {
                        return MyOrdersDetails(
                          status: 'Cancelled',
                          statusColor: Colors.grey,
                          returnWidget: const SizedBox(),
                          showDetailAndTrackButton: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OrderStatusScreen(
                                              productDetails:
                                                  cancelOrderList[index],
                                            )));
                              },
                              child: Text(
                                'Show full details',
                                style: bodyText14w600(color: primary),
                              )),
                          productDetails: cancelOrderList[index],
                        );
                      }),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}

class MyOrdersDetails extends StatefulWidget {
  const MyOrdersDetails({
    super.key,
    required this.status,
    required this.statusColor,
    required this.showDetailAndTrackButton,
    required this.returnWidget,
    required this.productDetails,
  });

  final String status;
  final Color statusColor;
  final Widget showDetailAndTrackButton;
  final Widget returnWidget;
  final Map productDetails;

  @override
  State<MyOrdersDetails> createState() => _MyOrdersDetailsState();
}

class _MyOrdersDetailsState extends State<MyOrdersDetails> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(10),
          height: !isOpen ? height(context) * 0.16 : height(context) * 0.6,
          width: width(context) * 0.93,
          decoration: shadowDecoration(10, 2),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order ID- ${widget.productDetails["orderId"]}',
                        style: bodyText11Small(color: black),
                      ),
                      Container(
                        height: 33,
                        width: width(context) * 0.3,
                        decoration:
                            myFillBoxDecoration(0, widget.statusColor, 10),
                        child: Center(
                          child: Text(
                            widget.status,
                            style: bodyText14w600(color: white),
                          ),
                        ),
                      )
                    ],
                  ),
                  Text(
                    '${widget.productDetails["items"].length} Item(s) Order Placed',
                    style: bodyText14w600(color: black),
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  if (isOpen)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Date & Time',
                              style: bodyText12Small(
                                  color: black.withOpacity(0.5)),
                            ),
                            Text(
                              widget.productDetails["createdAt"]
                                  .toDate()
                                  .toString()
                                  .substring(0, 16),
                              style: bodytext12Bold(color: black),
                            ),
                          ],
                        ),
                        addVerticalSpace(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Your Order',
                              style: bodyText16w600(color: black),
                            ),
                            widget.returnWidget
                          ],
                        ),
                        addVerticalSpace(10),
                        SizedBox(
                          height: height(context) * 0.16,
                          child: ListView.builder(
                              itemCount: widget.productDetails["items"].length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          decoration: shadowDecoration(15, 0),
                                          height: height(context) * 0.08,
                                          width: width(context) * 0.18,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.network(
                                              widget.productDetails["items"]
                                                  [index]["image"],
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
                                                widget.productDetails["items"]
                                                    [index]["name"],
                                                style: bodyText14w600(
                                                    color: black),
                                              ),
                                              Text(
                                                '${widget.productDetails["items"][index]["weight"]} gms',
                                                style: bodyText11Small(
                                                    color:
                                                        black.withOpacity(0.5)),
                                              ),
                                              addVerticalSpace(5),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Rs.${widget.productDetails["items"][index]["price"] + 50}',
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black26),
                                                  ),
                                                  addHorizontalySpace(5),
                                                  Text(
                                                    'Rs.${widget.productDetails["items"][index]["price"]}',
                                                    style: bodyText14w600(
                                                        color: primary),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        addHorizontalySpace(30),
                                        Container(
                                          height: 30,
                                          width: width(context) * 0.2,
                                          decoration: shadowDecoration(7, 1),
                                          child: Center(
                                              child: Text(
                                            'Qty- ${widget.productDetails["items"][index]["productQty"]}',
                                            style: bodytext12Bold(color: black),
                                          )),
                                        )
                                      ],
                                    ),
                                    const Divider(
                                      thickness: 1,
                                      height: 21,
                                    )
                                  ],
                                );
                              }),
                        ),
                        addVerticalSpace(5),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Delivery',
                                    style: bodyText14w600(color: black),
                                  ),
                                  Text(
                                    'Rs. ${widget.productDetails["deliveryFees"]}',
                                    style: bodyText14w600(color: black),
                                  )
                                ],
                              ),
                              const Divider(
                                thickness: 1,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                        Center(child: widget.showDetailAndTrackButton),
                      ],
                    ),
                  Center(
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            isOpen = !isOpen;
                          });
                        },
                        child: Icon(
                          isOpen ? Icons.expand_less : Icons.expand_more,
                          size: 40,
                          color: black.withOpacity(0.6),
                        )),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
