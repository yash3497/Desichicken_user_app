import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious_app/utils/constants.dart';
import 'package:delicious_app/views/home/notification_screen.dart';
import 'package:delicious_app/views/home/sub_category_screen.dart';
import 'package:delicious_app/views/humburger_items/contact_us_screen.dart';
import 'package:delicious_app/widget/humburger_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../widget/add_to_cart.dart';
import '../../widget/custom_gradient_button.dart';
import '../../widget/slider_widget.dart';
import '../categories/vendor_product_screen.dart';
import '../my_cart/cart_tab_screen.dart';
import '../product_screen.dart';

var token;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

double latitude = 0;

double longitude = 0;

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  List imageList = [];
  List<String> allProductsList = [];

  Future<Position?> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    } else {
      // throw Exception('Error');
    }
    return await Geolocator.getCurrentPosition();
  }

  fetchCurrentLatLong() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((value) {
      latitude = value.latitude;
      longitude = value.longitude;

      if (mounted) {
        setState(() {});
      }
    });

    print(latitude);
    print(longitude);
  }

  List cartData = [];
  _fetchCartList() {
    FirebaseFirestore.instance
        .collection('Cart')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("products")
        .snapshots()
        .listen((event) {
      cartData.clear();

      for (var doc in event.docs) {
        cartData.add(doc.data());
      }
      if (mounted) {
        setState(() {});
      }
      log(cartList.toString());
    });
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    fillimagelist();
    populateNameList();
    determinePosition();
    fetchCurrentLatLong();
    fetchToken();
    _fetchCartList();
    super.initState();
  }

  fetchToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      token = value.toString();
      setState(() {});
    });
  }

  populateNameList() {
    FirebaseFirestore.instance
        .collection('product')
        .get()
        .then((value) => value.docs.forEach((element) {
              allProductsList.add(element['name']);
            }));
  }

  void fillimagelist() async {
    await FirebaseFirestore.instance
        .collection("CarouselImages")
        .get()
        .then((value) {
      imageList.clear();

      for (var doc in value.docs) {
        imageList.add(doc.data()["imageUrl"]);
        log(doc.data().toString());
      }
    });
    if (mounted) {
      setState(() {});
    }
  }

  final Stream<QuerySnapshot> categories =
      FirebaseFirestore.instance.collection('Categories').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _globalKey,
        drawer: MyDrawer(),
        bottomNavigationBar: Visibility(
          visible: cartData.isNotEmpty ? true : false,
          child: Container(
            height: height(context) * 0.1,
            width: width(context),
            padding: const EdgeInsets.only(top: 10, left: 15, right: 20),
            decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.grey,
                  )
                ],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceBetween,
              children: [
                ListTile(
                  leading: Icon(Icons.shopping_cart_outlined),
                  title: Text('${cartData.length} Items'),
                  trailing: Container(
                    width: width(context) * 0.4,
                    child: CustomButton(
                        buttonName: 'Go to Cart',
                        onClick: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyCartScreen()));
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(height(context) * 0.1),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25.0),
                        child: InkWell(
                            onTap: () {
                              _globalKey.currentState!.openDrawer();
                            },
                            child: Icon(Icons.menu)),
                      ),
                      // addHorizontalySpace(20),
                      Container(
                        padding: EdgeInsets.only(bottom: 21),
                        width: width(context) * 0.6,
                        child: Text(
                          'Find Your Favorite Food',
                          textAlign: TextAlign.center,
                          style: bodyText16w600(color: black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NotificationScreen()));
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: shadowDecoration(10, 1),
                            child: Icon(
                              Icons.notifications_outlined,
                              size: 30,
                              color: primary,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  /*  addVerticalSpace(10),
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SearchBar(),
                        // Container(

                        //   child: TextField(
                        //     onTap: () {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => SearchScreen()));
                        //     },
                          //   decoration: InputDecoration(
                          //       prefixIcon: Icon(
                          //         Icons.search,
                          //         color: primary,
                          //       ),
                          //       border: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(15),
                          //         borderSide: const BorderSide(
                          //           width: 0,
                          //           style: BorderStyle.none,
                          //         ),
                          //       ),
                          //       contentPadding:
                          //           const EdgeInsets.only(top: 12, left: 20),
                          //       filled: true,
                          //       hintStyle: TextStyle(color: ligthRed),
                          //       hintText: 'What do you want to order?',
                          //       fillColor:
                          //           const Color.fromRGBO(255, 187, 186, 0.2)),
                          // ),
                        // ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CategoryScreen(vendorName: "", category: "",vendorID: "",)));
                          },
                          child: Container(
                              height: height(context) * 0.055,
                              width: 50,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                // color: ligthRed,
                              ),
                              child: Center(
                                child: Image.asset('assets/images/filter.png'),
                              )),
                        )
                      ],
                    ),
                  ),*/
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.all(10),
                    child: SliderWidget(imageList: imageList)),
                addVerticalSpace(15),
                Text(
                  'Categories',
                  style: bodyText16w600(color: black),
                ),
                addVerticalSpace(10),
                SizedBox(
                  // height: height(context) * 0.38,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: categories,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text("Something wrong occurred");
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("Loading");
                        }

                        final data = snapshot.requireData;

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.size,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisExtent: height(context) * 0.18,
                            crossAxisSpacing: 20.0,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return CategoryTile(
                              imageURL: data.docs[index]['ImageURL'],
                              title: data.docs[index]['Name'],
                              categoryId:
                                  data.docs[index]['categoryId'].toString(),
                            );
                          },
                        );
                      }),
                  // child: GridView.builder(
                  //     physics: const NeverScrollableScrollPhysics(),
                  //     itemCount: homeCategoryList.length,
                  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //         crossAxisCount: 3,
                  //         crossAxisSpacing: 20,
                  //         mainAxisExtent: height(context) * 0.18),
                  //     itemBuilder: (context, index) {
                  //       return CategoryTile(title: title, imageURL: imageURL)
                  //     }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Today’s Deals',
                      style: bodyText16w600(color: black),
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => SearchResultsScreen(
                    //               category: 0,
                    //                   search: "",
                    //                   exclusive : true,
                    //                   title: 'Today’s Deals',
                    //                 )));
                    //   },
                    //   child: Text(
                    //     'View all',
                    //     style: bodyText14w600(color: primary),
                    //   ),
                    // ),
                  ],
                ),
                addVerticalSpace(10),
                SizedBox(
                  height: height(context) * 0.33,
                  child: HomeProductListWidget(
                    category: 0,
                  ),
                ),
                addVerticalSpace(15),
                Text(
                  'Best Sellers',
                  style: bodyText16w600(color: black),
                ),
                addVerticalSpace(10),
                SizedBox(
                  height: height(context) * 0.33,
                  child: HomeProductListWidget(
                    category: 1,
                  ),
                ),
                addVerticalSpace(height(context) * 0.05),
                const HomeBottomCheckedWidget(),
                addVerticalSpace(20),
                Padding(
                  padding:
                      EdgeInsets.only(left: width(context) * 0.17, bottom: 20),
                  child: SizedBox(
                    width: width(context) * 0.7,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ContactUs()));
                      },
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text:
                                'Didn’t find what you’re looking for?\n      Please contact us',
                            style: bodyText14w600(color: black)),
                        TextSpan(
                            text: ' click here!',
                            style: bodyText14w600(color: primary))
                      ])),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class HomeBottomCheckedWidget extends StatefulWidget {
  const HomeBottomCheckedWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeBottomCheckedWidget> createState() =>
      _HomeBottomCheckedWidgetState();
}

class _HomeBottomCheckedWidgetState extends State<HomeBottomCheckedWidget> {
  bool ischecked1 = true;
  bool ischecked2 = true;
  bool ischecked3 = true;
  bool ischecked4 = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width(context),
      height: height(context) * 0.9,
      color: Color(0xFFF3F5F2),
      child: Column(
        children: [
          /*Container(
            height: height(context) * 0.26,
            width: width(context) * 0.8,
            decoration: myFillBoxDecoration(0, white, 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Every box contains meat that’s:',
                  style: bodyText16w600(color: primary),
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 15,
                      child: Checkbox(
                          value: true,
                          activeColor: primary,
                          onChanged: (val) {
                            ischecked1 = val!;

                            setState(() {});
                          }),
                    ),
                    SizedBox(
                      width: width(context) * 0.65,
                      child: Text(
                        'Vacuum sealed & maintained between 0-48*C',
                        style: bodyText11Small(color: black),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 15,
                      child: Checkbox(
                          value: true,
                          activeColor: primary,
                          onChanged: (val) {
                            ischecked2 = val!;

                            setState(() {});
                          }),
                    ),
                    SizedBox(
                      width: width(context) * 0.65,
                      child: Text(
                        'Fresh, pre-cut and pre-cleaned',
                        style: bodyText11Small(color: black),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 15,
                      child: Checkbox(
                          value: true,
                          activeColor: primary,
                          onChanged: (val) {
                            ischecked3 = val!;

                            setState(() {});
                          }),
                    ),
                    SizedBox(
                      width: width(context) * 0.65,
                      child: Text(
                        'Certified with over 150 rigorous quality checks',
                        style: bodyText11Small(color: black),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 15,
                      child: Checkbox(
                          value: true,
                          activeColor: primary,
                          onChanged: (val) {
                            ischecked4 = val!;

                            setState(() {});
                          }),
                    ),
                    SizedBox(
                      width: width(context) * 0.65,
                      child: Text(
                        'Free from artificial preservatives & antibiotic residue',
                        style: bodyText11Small(color: black),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          addVerticalSpace(10),*/
          Center(
              child: Image.asset(
            'assets/images/mainlogo.png',
            height: 150,
          )),
          addVerticalSpace(10),
          Image.asset('assets/images/homebottomimg.jpg'),
        ],
      ),
    );
  }
}

class HomeProductListWidget extends StatefulWidget {
  final int category;

  HomeProductListWidget({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<HomeProductListWidget> createState() => _HomeProductListWidgetState();
}

class _HomeProductListWidgetState extends State<HomeProductListWidget> {
  // final Stream<QuerySnapshot> todaysDeals =
  //     FirebaseFirestore.instance.collection('TodaysDeal').snapshots();

  // final Stream<QuerySnapshot> bestSellers =
  //     FirebaseFirestore.instance.collection('BestSellers').snapshots();

  List data = [];
  _fetchTodayData() async {
    await FirebaseFirestore.instance
        .collection('TodaysDeal')
        .get()
        .then((value) {
      setState(() {
        data = value.docs;
      });
    });
  }

  _fetchBestSellerData() async {
    await FirebaseFirestore.instance
        .collection('BestSellers')
        .get()
        .then((value) {
      setState(() {
        data = value.docs;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.category == 0 ? _fetchTodayData() : _fetchBestSellerData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            if (widget.category == 0) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => ProductScreen(
                            name: data[index]['name'],
                            id: data[index]['id'],
                            productType: 'today',
                          )));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => ProductScreen(
                            name: data[index]['name'],
                            id: data[index]['id'],
                            productType: 'best',
                          )));
            }
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: shadowDecoration(15, 5),
            width: width(context) * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height(context) * 0.13,
                  width: width(context),
                  child: Image.network(
                    data[index]['image'],
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  // height: height(context) * 0.17,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: width(context) * 0.3,
                            child: Text(
                              data[index]['name'],
                              style: bodyText14w600(color: black),
                            ),
                          ),
                          Container(
                            decoration: myFillBoxDecoration(
                                0, const Color.fromRGBO(251, 188, 4, 1), 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  data[index]['ratings'].toString(),
                                  style: bodyText12Small(color: white),
                                ),
                                Icon(
                                  Icons.star,
                                  size: 15,
                                  color: white,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.timer,
                            size: 18,
                            color: Colors.yellow,
                          ),
                          Text(
                            '${data[index]['timing']} mins   <1 Km',
                            style: bodyText11Small(color: Colors.black38),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.monitor_weight,
                            size: 18,
                            color: Colors.red,
                          ),
                          Text(
                            '${data[index]['weight']}gms I \nNet: ${data[index]['netWeight']}gms',
                            style: bodyText11Small(color: Colors.black38),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rs. ${data[index]['price']}',
                            style: bodytext12Bold(color: black),
                          ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: myFillBoxDecoration(0, primary, 5),
                            child: Center(
                              child: AddtoCart(
                                vendorId: data[index]['vendorID'],
                                id: data[index]['id'],
                                insideProduct: false,
                                price: data[index]['price'],
                                name: data[index]['name'],
                                desc: data[index]['discription'],
                                stock: data[index]['stock'],
                                imageURL: data[index]['image'],
                                weight: data[index]['weight'],
                                netWeight: data[index]['netWeight'],
                                catId: data[index]['catId'],
                                vendorPrice: data[index]['vendorPrice'],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )

            /*     ProductTile(
                name: data[index]['name'],
                timing: data[index]['timing'],
                weight: data[index]['weight'],
                netWeight: data[index]['netWeight'],
                price: data[index]['price'],
                rating: data[index]['ratings'],
                vendorID: data[index]['vendorID'],
                imageURL: data[index]['image'],
                id: data[index]['id'],
                desc: data[index]['desc'],
                stock: data[index]['stock'],
              )*/

            ;
      },
    );
  }
  // ListView.builder(
  //     itemCount: prodList.length,
  //     scrollDirection: Axis.horizontal,
  //     itemBuilder: (context, index) {
  //       return InkWell(
  //         onTap: () => Navigator.push(
  //             context, MaterialPageRoute(builder: (ctx) => ProductScreen(name: "",id: "",))),
  //         child: Container(
  //           margin: EdgeInsets.only(left: 7, right: 20, bottom: 7, top: 7),
  //           // color: ligthRed,
  //           height: height(context) * 0.3,
  //           width: width(context) * 0.45,
  //           decoration: shadowDecoration(15, 5),
  //           child: Column(
  //             children: [
  //               SizedBox(
  //                 height: height(context) * 0.13,
  //                 width: width(context) * 0.45,
  //                 child: Image.asset(
  //                   prodList[index],
  //                   fit: BoxFit.fill,
  //                 ),
  //               ),
  //               Container(
  //                 padding: EdgeInsets.symmetric(horizontal: 5),
  //                 height: height(context) * 0.15,
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: [
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         SizedBox(
  //                           width: width(context) * 0.2,
  //                           child: Text(
  //                             'Goat Curry Cut',
  //                             style: bodyText14w600(color: black),
  //                           ),
  //                         ),
  //                         Container(
  //                           height: 21,
  //                           width: width(context) * 0.15,
  //                           decoration: myFillBoxDecoration(
  //                               0, const Color.fromRGBO(251, 188, 4, 1), 5),
  //                           child: Row(
  //                             mainAxisAlignment:
  //                                 MainAxisAlignment.spaceEvenly,
  //                             children: [
  //                               Text(
  //                                 '4.4',
  //                                 style: bodyText12Small(color: white),
  //                               ),
  //                               Icon(
  //                                 Icons.star,
  //                                 size: 15,
  //                                 color: white,
  //                               )
  //                             ],
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                     Row(
  //                       children: [
  //                         const Icon(
  //                           Icons.timer,
  //                           size: 18,
  //                           color: Colors.yellow,
  //                         ),
  //                         Text(
  //                           '20 mins    <1 Km',
  //                           style: bodyText11Small(color: Colors.black38),
  //                         )
  //                       ],
  //                     ),
  //                     Row(
  //                       children: [
  //                         const Icon(
  //                           Icons.monitor_weight,
  //                           size: 18,
  //                           color: Colors.red,
  //                         ),
  //                         Text(
  //                           '900gms I Net: 450gms',
  //                           style: bodyText11Small(color: Colors.black38),
  //                         )
  //                       ],
  //                     ),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Text(
  //                           'Rs. 200',
  //                           style: bodytext12Bold(color: black),
  //                         ),
  //                         Container(
  //                           height: 21,
  //                           width: width(context) * 0.15,
  //                           decoration: myFillBoxDecoration(0, primary, 5),
  //                           child: Center(
  //                             child: Text(
  //                               'ADD +',
  //                               style: bodyText11Small(color: white),
  //                             ),
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       );
  //     });

}

// category tile

class CategoryTile extends StatefulWidget {
  final String title;
  final String imageURL;
  final String categoryId;

  CategoryTile(
      {super.key,
      required this.title,
      required this.imageURL,
      required this.categoryId});

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  var fcategories = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // for direct product screen
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VendorProductScreen(
                      category: widget.categoryId,
                      vendorID: "",
                      vendorName: "",
                      subCategoryId: '',
                    )));
        // for going to vendor screen
        /*     Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    VendorCategoryScreen(category: widget.title,)));*/
        /*     Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    VendorCategoryScreen(category: widget.title,)));*/
      },
      child: Column(
        children: [
          Container(
            height: height(context) * 0.12,
            width: width(context) * 0.25,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                image: DecorationImage(
                    image: NetworkImage(widget.imageURL), fit: BoxFit.fill)),
          ),
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: bodyText13normal(color: black),
          )
        ],
      ),
    );
  }
}
