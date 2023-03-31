import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious_app/utils/constants.dart';
import 'package:delicious_app/views/home/search_screen.dart';
import 'package:delicious_app/widget/search_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widget/add_to_cart.dart';
import '../../widget/custom_gradient_button.dart';
import '../home/search_result_screen.dart';
import '../my_cart/cart_tab_screen.dart';
import '../product_screen.dart';

class VendorProductScreen extends StatefulWidget {
  final String vendorName;
  final String category;
  final String vendorID;
  final String subCategoryId;

  const VendorProductScreen(
      {super.key,
      required this.category,
      required this.vendorID,
      required this.vendorName,
      required this.subCategoryId});

  @override
  State<VendorProductScreen> createState() => _VendorProductScreenState();
}

class _VendorProductScreenState extends State<VendorProductScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  void initState() {
    getSubCats();
    fetchProducts();
    _fetchCartList();
    super.initState();
  }

  // fetch product
  List<dynamic> productList = [];
  List subCats = [];
  int selectedIndex = 0;

  fetchProducts({String? sub}) {
    setState(() {
      productList.clear();
    });
    print(sub);
    if (sub != null) {
      firebaseFirestore
          .collection("Products")
          .where("categoryId", isEqualTo: int.parse(widget.category))
          .where("subCategoryId", isEqualTo: int.parse(sub))
          .get()
          .then((value) {
        for (var doc in value.docs) {
          productList.add(doc.data());
          if (mounted) {
            setState(() {});
          }
        }
      });
    } else {
      print(widget.category);
      firebaseFirestore
          .collection("Products")
          // .where("vendorId", isEqualTo: widget.vendorID)
          .where("categoryId", isEqualTo: int.parse(widget.category))
          .get()
          .then((value) {
        print(value.docs);
        for (var doc in value.docs) {
          productList.add(doc.data());
          print(productList);
          if (mounted) {
            setState(() {});
          }
        }
      });
    }
  }

  _fetchCartList() {
    FirebaseFirestore.instance
        .collection('Cart')
        .doc(FirebaseAuth.instance.currentUser?.uid)
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

  getSubCats() async {
    var b = await FirebaseFirestore.instance
        .collection("SubCategories")
        .where("categoryId", isEqualTo: int.parse(widget.category))
        .get();
    subCats.add({"name": "All"});
    subCats.addAll(b.docs);
    setState(() {});
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
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          title: Text(
            widget.vendorName,
            style: TextStyle(color: black),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(
                  //   builder: (context) {
                  //     return const SearchBar();
                  //   },
                  // ));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchResultsScreen(
                                exclusive: false,
                                category: 0,
                                search: "",
                                title: '',
                              )));
                },
                icon: Icon(
                  Icons.search,
                  color: primary,
                ))
          ],
        ),
        body: Column(
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
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                        fetchProducts(
                            sub: index == 0
                                ? null
                                : subCats[index]['subCategoryId']);
                      },
                      child: Card(
                        elevation: 5,
                        child: Container(
                          color: selectedIndex == index ? Colors.red : null,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                index == 0
                                    ? const SizedBox()
                                    : SizedBox(
                                        width: 30,
                                        height: 35,
                                        child: Image.network(
                                          subCats[index]['image'],
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                SizedBox(
                                    width: index == 0 ? 50 : null,
                                    child: Center(
                                        child: Text(
                                      subCats[index]['name'],
                                      style: TextStyle(
                                          color: selectedIndex == index
                                              ? Colors.white
                                              : null),
                                    ))),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: height(context) * 0.74,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: productList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4),
                itemBuilder: (BuildContext context, int index) {
                  return ProductTile(
                    name: productList[index]['name'],
                    timing: productList[index]['timing'],
                    weight: productList[index]['weight'],
                    netWeight: productList[index]['weight'] + 50,
                    price: productList[index]['price'],
                    rating: productList[index]['rating'],
                    vendorID: productList[index]['vendorId'],
                    imageURL: productList[index]['image'],
                    id: productList[index]['id'] ?? "10",
                    desc: productList[index]['description'] ?? "",
                    stock: productList[index]['stock'],
                    catId: productList[index]['categoryId'].toString(),
                    vendorPrice: productList[index]['vendorPrice'],
                  );
                },
              ),
            )
          ],
        ),
        bottomNavigationBar: Visibility(
          visible: cartList.isNotEmpty ? true : false,
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
                  title: Text('${cartList.length} Items'),
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
        ));
  }
}

class ProductTile extends StatefulWidget {
  final String imageURL;
  final String vendorID;
  final String name;
  final String id;
  final num timing;
  final num weight;
  final num netWeight;
  final String desc;
  final num stock;
  final num price;
  final num vendorPrice;
  final num rating;
  final String catId;

  const ProductTile({
    super.key,
    required this.name,
    required this.timing,
    required this.weight,
    required this.netWeight,
    required this.price,
    required this.rating,
    required this.vendorID,
    required this.imageURL,
    required this.id,
    required this.desc,
    required this.stock,
    required this.catId,
    required this.vendorPrice,
  });

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (ctx) => ProductScreen(
                    name: widget.name,
                    id: widget.id,
                    productType: 'normal',
                  ))),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: shadowDecoration(15, 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height(context) * 0.13,
              width: width(context),
              child: Image.network(
                widget.imageURL,
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
                          widget.name,
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
                              widget.rating.toString(),
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
                        '${widget.timing} mins   <1 Km',
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
                        '${widget.weight}gms I \nNet: ${widget.netWeight}gms',
                        style: bodyText11Small(color: Colors.black38),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rs. ${widget.price}',
                        style: bodytext12Bold(color: black),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: myFillBoxDecoration(0, primary, 5),
                        child: Center(
                          child: AddtoCart(
                            vendorId: widget.vendorID,
                            id: widget.id,
                            insideProduct: false,
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
  }
}
