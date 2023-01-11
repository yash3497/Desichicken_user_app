import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious_app/utils/constants.dart';
import 'package:delicious_app/views/my_cart/cart_tab_screen.dart';
import 'package:delicious_app/widget/custom_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'categories/vendor_product_screen.dart';

class ProductScreen extends StatefulWidget {
  final String id;
  final String name;
  final String productType;

  const ProductScreen({
    super.key,
    required this.name,
    required this.id,
    required this.productType,
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int reviews = 90;
  int reviews2 = 70;
  int reviews3 = 50;
  int reviews4 = 30;
  int reviews5 = 10;
  List subCats = [];
  getSubCats() async {
    var a = await FirebaseFirestore.instance
        .collection("Products")
        .doc(widget.id)
        .get();
    String catId = a['categoryId'];
    var b = await FirebaseFirestore.instance
        .collection("SubCategories")
        .where("categoryId", isEqualTo: catId)
        .get();
    subCats = b.docs;
    print(subCats);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSubCats();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.id);
    final Stream<QuerySnapshot> products = FirebaseFirestore.instance
        .collection('Products')
        .where("id", isEqualTo: widget.id)
        .where("name", isEqualTo: widget.name)
        .snapshots();

    final Stream<QuerySnapshot> todaysDeals = FirebaseFirestore.instance
        .collection('TodaysDeal')
        .where("id", isEqualTo: widget.id)
        .where("name", isEqualTo: widget.name)
        .snapshots();
    final Stream<QuerySnapshot> bestSellers = FirebaseFirestore.instance
        .collection('BestSellers')
        .where("id", isEqualTo: widget.id)
        .where("name", isEqualTo: widget.name)
        .snapshots();

    return Scaffold(
        body: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: StreamBuilder<QuerySnapshot>(
          stream: widget.productType == "best"
              ? bestSellers
              : widget.productType == "today"
                  ? todaysDeals
                  : products,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("Something wrong occurred");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }

            final data = snapshot.data;

            return snapshot.hasData
                ? SafeArea(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: subCats.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => VendorProductScreen(
                                              category: subCats[index]['name'],
                                              vendorID: '',
                                              vendorName: '',
                                              subCategoryId: subCats[index]['subCategoryId'],
                                            )));
                                  },
                                  child: Card(

                                    elevation: 5,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 30,
                                          height: 35,
                                          child: Image.network(
                                            subCats[index]['name'],
                                          ),
                                        ),
                                        Text(subCats[index]['name']),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                        Container(
                          height: height(context) * 0.42,
                          width: width(context) * 1,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(data!.docs[0]['image']))),
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: SafeArea(
                                child: Column(
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.arrow_back,
                                          size: 30,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        Column(
                          children: [
                            Container(
                              width: width(context),
                              height: height(context) * 0.48,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 5,
                                      color: Colors.grey,
                                    )
                                  ],
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30))),
                              padding: const EdgeInsets.only(
                                  left: 15, top: 20, right: 15, bottom: 10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 25,
                                        width: width(context) * 0.22,
                                        decoration: myFillBoxDecoration(
                                            0, ligthRed.withOpacity(0.4), 20),
                                        child: Center(
                                          child: Text(
                                            'Popular',
                                            style:
                                                bodytext12Bold(color: primary),
                                          ),
                                        ),
                                      ),
                                      addHorizontalySpace(
                                          width(context) * 0.11),
                                      Text(
                                        widget.name,
                                        style: bodyText16w600(color: black),
                                      )
                                    ],
                                  ),
                                  addVerticalSpace(20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: height(context) * 0.13,
                                        width: width(context) * 0.26,
                                        decoration: shadowDecoration(10, 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Image.asset(
                                                'assets/images/original 3.png'),
                                            Text(
                                              '${data.docs[0]['pieces']} Pieces',
                                              style:
                                                  bodytext12Bold(color: black),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: height(context) * 0.12,
                                        width: width(context) * 0.26,
                                        decoration: shadowDecoration(10, 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Image.asset(
                                                'assets/images/original 2.png'),
                                            Text(
                                              '${data.docs[0]['serves']} Serves',
                                              style:
                                                  bodytext12Bold(color: black),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: height(context) * 0.12,
                                        width: width(context) * 0.26,
                                        decoration: shadowDecoration(10, 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Image.asset(
                                                'assets/images/original 1.png'),
                                            Text(
                                              '${data.docs[0]['weight']} gms ',
                                              textAlign: TextAlign.center,
                                              style:
                                                  bodytext12Bold(color: black),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  addVerticalSpace(15),
                                  // Text(
                                  //   data.docs[0]['discription'],
                                  //   style: bodyText12Small(color: black),
                                  // ),
                                  // addVerticalSpace(15),
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Text(
                                  //       'Customer Reviews',
                                  //       style: bodyText16w600(color: black),
                                  //     ),
                                  //     SizedBox(
                                  //       child: Row(
                                  //         children: [
                                  //           const Icon(
                                  //             Icons.star_half_rounded,
                                  //             color: Colors.green,
                                  //           ),
                                  //           Text(
                                  //             '4.8/5',
                                  //             style: bodyText16w600(color: black),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     )
                                  //   ],
                                  // ),
                                  // customerReviews(context),
                                  // addVerticalSpace(10),
                                  // SizedBox(
                                  //   height: height(context) * 0.43,
                                  //   child: ListView.builder(
                                  //       itemCount: 10,
                                  //       padding: EdgeInsets.zero,
                                  //       itemBuilder: (context, index) {
                                  //         return ListTile(
                                  //           leading: const CircleAvatar(
                                  //             backgroundImage: AssetImage(
                                  //                 'assets/images/review1.png'),
                                  //           ),
                                  //           title: Text(
                                  //             'Joan Perkins',
                                  //             style: bodyText14w600(color: black),
                                  //           ),
                                  //           subtitle: Row(
                                  //             children: [
                                  //               RatingBar.builder(
                                  //                 initialRating: 4.5,
                                  //                 minRating: 1,
                                  //                 itemSize: 20,
                                  //                 direction: Axis.horizontal,
                                  //                 allowHalfRating: true,
                                  //                 itemCount: 5,
                                  //                 unratedColor:
                                  //                     Colors.teal.shade100,
                                  //                 itemBuilder: (context, _) =>
                                  //                     const Icon(
                                  //                   Icons.star_rate_rounded,
                                  //                   color: Colors.teal,
                                  //                 ),
                                  //                 onRatingUpdate: (rating) {},
                                  //               ),
                                  //               Text('4.5')
                                  //             ],
                                  //           ),
                                  //           trailing: Text(
                                  //             '1 day ago',
                                  //             style: bodyText13normal(
                                  //                 color: black.withOpacity(0.6)),
                                  //           ),
                                  //         );
                                  //       }),
                                  // ),
                                ],
                              ),
                            ),
                            ProductPriceWidget(
                              price: double.parse(
                                  data.docs[0]['price'].toString()),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                : SizedBox();
          }),
      // Column(
      //   children: [
      //     Container(
      //       height: height(context) * 0.42,
      //       width: width(context) * 1,
      //       decoration: const BoxDecoration(
      //           image: DecorationImage(
      //               image: AssetImage('assets/images/productmain.png'))),
      //       child: IconButton(
      //           onPressed: () {
      //             Navigator.pop(context);
      //           },
      //           icon: SafeArea(
      //             child: Column(
      //               children: [
      //                 Row(
      //                   children: const [
      //                     Icon(
      //                       Icons.arrow_back,
      //                       size: 30,
      //                     ),
      //                   ],
      //                 ),
      //               ],
      //             ),
      //           )),
      //     ),
      //     Column(
      //       children: [
      //         Container(
      //           width: width(context),
      //           height: height(context) * 1.04,
      //           decoration: const BoxDecoration(
      //               color: Colors.white,
      //               boxShadow: [
      //                 BoxShadow(
      //                   blurRadius: 5,
      //                   color: Colors.grey,
      //                 )
      //               ],
      //               borderRadius: BorderRadius.only(
      //                   topLeft: Radius.circular(30),
      //                   topRight: Radius.circular(30))),
      //           padding: const EdgeInsets.only(
      //               left: 15, top: 20, right: 15, bottom: 10),
      //           child: Column(
      //             children: [
      //               Row(
      //                 children: [
      //                   Container(
      //                     height: 25,
      //                     width: width(context) * 0.22,
      //                     decoration: myFillBoxDecoration(
      //                         0, ligthRed.withOpacity(0.4), 20),
      //                     child: Center(
      //                       child: Text(
      //                         'Popular',
      //                         style: bodytext12Bold(color: primary),
      //                       ),
      //                     ),
      //                   ),
      //                   addHorizontalySpace(width(context) * 0.11),
      //                   Text(
      //                     'Poultry Chicken',
      //                     style: bodyText16w600(color: black),
      //                   )
      //                 ],
      //               ),
      //               addVerticalSpace(20),
      //               Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   Container(
      //                     height: height(context) * 0.12,
      //                     width: width(context) * 0.26,
      //                     decoration: shadowDecoration(10, 5),
      //                     child: Column(
      //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                       children: [
      //                         Image.asset('assets/images/original 3.png'),
      //                         Text(
      //                           '10-11 Pieces',
      //                           style: bodytext12Bold(color: black),
      //                         )
      //                       ],
      //                     ),
      //                   ),
      //                   Container(
      //                     height: height(context) * 0.12,
      //                     width: width(context) * 0.26,
      //                     decoration: shadowDecoration(10, 5),
      //                     child: Column(
      //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                       children: [
      //                         Image.asset('assets/images/original 2.png'),
      //                         Text(
      //                           '4 Serves',
      //                           style: bodytext12Bold(color: black),
      //                         )
      //                       ],
      //                     ),
      //                   ),
      //                   Container(
      //                     height: height(context) * 0.12,
      //                     width: width(context) * 0.26,
      //                     decoration: shadowDecoration(10, 5),
      //                     child: Column(
      //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                       children: [
      //                         Image.asset('assets/images/original 1.png'),
      //                         Text(
      //                           '900gms I Net: 450gms',
      //                           textAlign: TextAlign.center,
      //                           style: bodytext12Bold(color: black),
      //                         )
      //                       ],
      //                     ),
      //                   )
      //                 ],
      //               ),
      //               addVerticalSpace(15),
      //               Text(
      //                 'Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Ciceros De Finibus Bonorum et Malorum for use in a type specimen book.Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs.',
      //                 style: bodyText12Small(color: black),
      //               ),
      //               addVerticalSpace(15),
      //               Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   Text(
      //                     'Customer Reviews',
      //                     style: bodyText16w600(color: black),
      //                   ),
      //                   SizedBox(
      //                     child: Row(
      //                       children: [
      //                         const Icon(
      //                           Icons.star_half_rounded,
      //                           color: Colors.green,
      //                         ),
      //                         Text(
      //                           '4.8/5',
      //                           style: bodyText16w600(color: black),
      //                         ),
      //                       ],
      //                     ),
      //                   )
      //                 ],
      //               ),
      //               customerReviews(context),
      //               addVerticalSpace(10),
      //               SizedBox(
      //                 height: height(context) * 0.43,
      //                 child: ListView.builder(
      //                     itemCount: 10,
      //                     padding: EdgeInsets.zero,
      //                     itemBuilder: (context, index) {
      //                       return ListTile(
      //                         leading: const CircleAvatar(
      //                           backgroundImage:
      //                               AssetImage('assets/images/review1.png'),
      //                         ),
      //                         title: Text(
      //                           'Joan Perkins',
      //                           style: bodyText14w600(color: black),
      //                         ),
      //                         subtitle: Row(
      //                           children: [
      //                             RatingBar.builder(
      //                               initialRating: 4.5,
      //                               minRating: 1,
      //                               itemSize: 20,
      //                               direction: Axis.horizontal,
      //                               allowHalfRating: true,
      //                               itemCount: 5,
      //                               unratedColor: Colors.teal.shade100,
      //                               itemBuilder: (context, _) => const Icon(
      //                                 Icons.star_rate_rounded,
      //                                 color: Colors.teal,
      //                               ),
      //                               onRatingUpdate: (rating) {},
      //                             ),
      //                             Text('4.5')
      //                           ],
      //                         ),
      //                         trailing: Text(
      //                           '1 day ago',
      //                           style: bodyText13normal(
      //                               color: black.withOpacity(0.6)),
      //                         ),
      //                       );
      //                     }),
      //               ),
      //             ],
      //           ),
      //          ),
      //         const ProductBottomPriceManageWidget()
      //       ],
      //     ),
      //   ],
      // ),
      // ),
    ));
  }

  Column customerReviews(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text('Excellent '),
            SizedBox(
              height: 30,
              width: width(context) * 0.72,
              child: Slider(
                activeColor: Colors.green,
                value: reviews.toDouble(),
                onChanged: (value) {
                  reviews = value.toInt();
                },
                min: 1,
                max: 100,
              ),
            )
          ],
        ),
        Row(
          children: [
            const Text('Good        '),
            SizedBox(
              width: width(context) * 0.72,
              height: 10,
              child: Slider(
                activeColor: const Color.fromARGB(255, 185, 238, 39),
                value: reviews2.toDouble(),
                onChanged: (value) {
                  reviews2 = value.toInt();
                },
                min: 1,
                max: 100,
              ),
            )
          ],
        ),
        Row(
          children: [
            const Text('Average   '),
            SizedBox(
              width: width(context) * 0.72,
              height: 35,
              child: Slider(
                activeColor: Colors.yellow,
                value: reviews3.toDouble(),
                onChanged: (value) {
                  reviews3 = value.toInt();
                },
                min: 1,
                max: 100,
              ),
            )
          ],
        ),
        Row(
          children: [
            const Text('Poor         '),
            SizedBox(
              width: width(context) * 0.72,
              height: 20,
              child: Slider(
                activeColor: Colors.orange,
                value: reviews4.toDouble(),
                onChanged: (value) {
                  reviews4 = value.toInt();
                },
                min: 1,
                max: 100,
              ),
            )
          ],
        ),
        Row(
          children: [
            const Text('Very poor'),
            SizedBox(
              width: width(context) * 0.72,
              height: 30,
              child: Slider(
                activeColor: Colors.red,
                value: reviews5.toDouble(),
                onChanged: (value) {
                  reviews5 = value.toInt();
                },
                min: 1,
                max: 100,
              ),
            )
          ],
        )
      ],
    );
  }
}

class ProductPriceWidget extends StatefulWidget {
  final double price;

  const ProductPriceWidget({
    Key? key,
    required this.price,
  }) : super(key: key);

  @override
  State<ProductPriceWidget> createState() => _ProductPriceWidgetState();
}

class _ProductPriceWidgetState extends State<ProductPriceWidget> {
  int qty = 1;
  bool isShow = false;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price',
            style: bodyText14w600(color: black),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rs.${(widget.price) + 50} ',
                style: const TextStyle(decoration: TextDecoration.lineThrough),
              ),
              Text(
                'Rs. ${widget.price}',
                style: bodyText20w700(color: primary),
              ),
              const Spacer(),
              Container(
                width: width(context) * 0.4,
                child: CustomButton(
                    buttonName: 'Go to Cart',
                    onClick: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyCartScreen()));
                    }),
              )
            ],
          )
        ],
      ),
    );
  }
}
