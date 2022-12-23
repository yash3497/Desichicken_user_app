import 'dart:developer';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious_app/utils/constants.dart';
import 'package:delicious_app/views/categories/vendor_product_screen.dart';
import 'package:flutter/material.dart';

import '../home/home_screen.dart';

// distance calculation

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = math.cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * math.asin(math.sqrt(a));
}

class VendorCategoryScreen extends StatefulWidget {
  final String category;

  const VendorCategoryScreen({
    super.key,
    required this.category,
  });

  @override
  State<VendorCategoryScreen> createState() => _VendorCategoryScreenState();
}

class _VendorCategoryScreenState extends State<VendorCategoryScreen> {
  @override
  void initState() {
    super.initState();
    fetchVendorData();
  }

  // fetch vendors by category

  List<dynamic> vendorsList = [];

  fetchVendorData() async {
    await FirebaseFirestore.instance
        .collection('vendors')
        // .where("categoryId",isEqualTo: widget.categoryId.toString())
        .where("categoryName", isEqualTo: widget.category.toString())
        .get()
        .then((value) {
      for (var doc in value.docs) {
        //Geolocator.distanceBetween(latitude, longitude, latitude, longitude);
        // vendorsList.add(doc.data());
        if ((calculateDistance(
                latitude, longitude, doc["latitude"], doc["longitude"])) <=
            5) {
          vendorsList.add(doc.data());
          setState(() {});
        }

        log(calculateDistance(
                latitude, longitude, doc["latitude"], doc["longitude"])
            .toString());
      }

      log(vendorsList.toString());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios)),
          title: Text(
            '${widget.category}  Vendors',
            style: bodyText16w600(color: black),
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  color: primary,
                ))
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
                height: height(context),
                child: GridView.builder(
                    itemCount: vendorsList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 10,
                            crossAxisCount: 2,
                            childAspectRatio: 0.90),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => VendorProductScreen(
                                        vendorName: vendorsList[index]
                                            ["marketName"],
                                        vendorID: vendorsList[index]
                                            ["vendorId"],
                                        category: widget.category,
                                        subCategoryId: '',
                                      )));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 7, right: 8, bottom: 7, top: 7),
                          height: height(context) * 0.14,
                          width: width(context) * 0.5,
                          decoration: shadowDecoration(15, 5),
                          child: Column(
                            children: [
                              SizedBox(
                                height: height(context) * 0.1,
                                width: width(context) * 0.45,
                                child: Image.network(
                                  vendorsList[index]["image"] == ""
                                      ? "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/"
                                          "No_image_available.svg/2048px-No_image_available.svg.png"
                                      : vendorsList[index]["image"],
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                height: height(context) * 0.13,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: width(context) * 0.25,
                                          child: Text(
                                            vendorsList[index]["marketName"],
                                            style: bodyText14w600(color: black),
                                          ),
                                        ),
                                        Container(
                                          height: 21,
                                          width: width(context) * 0.15,
                                          decoration: myFillBoxDecoration(
                                              0,
                                              const Color.fromRGBO(
                                                  251, 188, 4, 1),
                                              5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                "${vendorsList[index]["rating"]}",
                                                style: bodyText12Small(
                                                    color: white),
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
                                        addHorizontalySpace(5),
                                        Text(
                                          '${vendorsList[index]["timing"]} mins',
                                          style: bodyText11Small(
                                              color: Colors.black38),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }))));
  }
}
