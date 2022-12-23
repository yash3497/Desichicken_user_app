import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious_app/utils/constants.dart';
import 'package:delicious_app/views/humburger_items/add_address_screen.dart';
import 'package:delicious_app/widget/search_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/home_categorylist_model.dart';
import '../categories/vendor_product_screen.dart';
import '../product_screen.dart';

class SearchResultsScreen extends StatefulWidget {
  final num category;
  final String search;
  final bool exclusive;
  SearchResultsScreen({required this.title, required this.search, required this.exclusive, required this.category});

  String title;

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}
final Stream<QuerySnapshot> userDetails =
      FirebaseFirestore.instance.collection('Users').where('Number', isEqualTo: FirebaseAuth.instance.currentUser!.phoneNumber).snapshots();


final Stream<QuerySnapshot> address =
      FirebaseFirestore.instance.collection('Addresses').where('customerID', isEqualTo: FirebaseAuth.instance.currentUser!.uid).where('isDefault', isEqualTo: true).snapshots();

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  
  
  @override
  Widget build(BuildContext context) {
    
final Stream<QuerySnapshot> results =
      widget.exclusive ? widget.category==0 ? FirebaseFirestore.instance.collection('TodaysDeals').snapshots(): FirebaseFirestore.instance.collection('BestOffers').snapshots() :FirebaseFirestore.instance.collection('Products').where('searchCase', arrayContains: widget.search).snapshots();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height(context) * 0.11),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/review1.png'),
                    ),
                    addHorizontalySpace(3),
                    Container(
                      child: StreamBuilder<QuerySnapshot>(
                            stream: userDetails,
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return const Text("Something wrong occured");
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text("Loading");
                              }

                              final data = snapshot.requireData;
                                  return Text(/*data.docs[0]['Name']*/"kk");

                            }),
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Delivery to'),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AddNewAddressScreen()));
                          },
                          child: StreamBuilder<QuerySnapshot>(
                            stream: address,
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return const Text("Something wrong occured");
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text("Loading");
                              }

                              final data = snapshot.requireData;
                                  return Text(/*data.docs[0]['wholeAddress']*/"lk");

                            }),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const Divider(
                thickness: 2,
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SearchBar(),
                // Container(
                //   height: height(context) * 0.09,
                //   width: width(context) * 0.75,
                //   child: TextField(
                //     onTap: () {},
                //     decoration: InputDecoration(
                //         prefixIcon: Icon(
                //           Icons.search,
                //           color: primary,
                //         ),
                //         border: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(15),
                //           borderSide: const BorderSide(
                //             width: 0,
                //             style: BorderStyle.none,
                //           ),
                //         ),
                //         contentPadding:
                //             const EdgeInsets.only(top: 12, left: 20),
                //         filled: true,
                //         hintStyle: TextStyle(color: ligthRed),
                //         hintText: 'What do you want to order?',
                //         fillColor: const Color.fromRGBO(255, 187, 186, 0.2)),
                //   ),
                // ),
                Center(
                  child: Image.asset('assets/images/filter.png'),
                )
              ],
            ),
            addVerticalSpace(15),
            Text(
              widget.title,
              style: bodyText16w600(color: black),
            ),
            addVerticalSpace(10),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                            stream: results,
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
                                      crossAxisCount: 2,
                                      mainAxisExtent: height(context)*0.35,
                                      // crossAxisSpacing: 20.0,
                                    ),
                              itemBuilder: (BuildContext context, int index) {
                       
                                return ProductTile(name: data.docs[index]['name'], timing: data.docs[index]['timing'], weight:data.docs[index]['weight'], netWeight: data.docs[index]['netWeight'], price:data.docs[index]['price'], rating: data.docs[index]['ratings'], vendorID: data.docs[index]['vendorID'], imageURL: data.docs[index]['imageURL'],id: data.docs[index]['id'],desc: data.docs[index]['desc'],stock: data.docs[index]['stock'],);
                              },
                            );
                                
                            }),
                // GridView.builder(
                //     itemCount: prodList.length,
                //     gridDelegate:
                //         const SliverGridDelegateWithFixedCrossAxisCount(
                //             mainAxisSpacing: 7,
                //             crossAxisCount: 2,
                //             childAspectRatio: 0.70),
                //     itemBuilder: (context, index) {
                //       return InkWell(
                //         onTap: () => Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (ctx) => ProductScreen(name: "", id: "",))),
                //         child: Container(
                //           margin: const EdgeInsets.only(
                //               left: 7, right: 8, bottom: 7, top: 7),
                //           // color: ligthRed,
                //           height: height(context) * 0.3,
                //           width: width(context) * 0.5,
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
                //                   mainAxisAlignment:
                //                       MainAxisAlignment.spaceEvenly,
                //                   children: [
                //                     Row(
                //                       mainAxisAlignment:
                //                           MainAxisAlignment.spaceBetween,
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
                //                               0,
                //                               const Color.fromRGBO(
                //                                   251, 188, 4, 1),
                //                               5),
                //                           child: Row(
                //                             mainAxisAlignment:
                //                                 MainAxisAlignment.spaceEvenly,
                //                             children: [
                //                               Text(
                //                                 '4.4',
                //                                 style: bodyText12Small(
                //                                     color: white),
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
                //                           '20 mins   <1 Km',
                //                           style: bodyText11Small(
                //                               color: Colors.black38),
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
                //                           '900gms I \nNet: 450gms',
                //                           style: bodyText11Small(
                //                               color: Colors.black38),
                //                         )
                //                       ],
                //                     ),
                //                     Row(
                //                       mainAxisAlignment:
                //                           MainAxisAlignment.spaceBetween,
                //                       children: [
                //                         Text(
                //                           'Rs. 200',
                //                           style: bodytext12Bold(color: black),
                //                         ),
                //                         Container(
                //                           height: 21,
                //                           width: width(context) * 0.15,
                //                           decoration: myFillBoxDecoration(
                //                               0, primary, 5),
                //                           child: Center(
                //                             child: Text(
                //                               'ADD +',
                //                               style:
                //                                   bodyText11Small(color: white),
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
                //     })
                    )
          ],
        ),
      ),
    );
  }
}
