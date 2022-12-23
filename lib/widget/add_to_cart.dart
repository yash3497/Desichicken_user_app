import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious_app/services/cart_services.dart';
import 'package:delicious_app/widget/counter_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/constants.dart';

class AddtoCart extends StatefulWidget {
  final num price;
  final String imageURL;
  final String name;
  final String desc;

  // final List caseSearch;
  final String id;
  final num weight;
  final num netWeight;
  final num stock;
  final String vendorId;
  final bool insideProduct;

  const AddtoCart(
      {super.key,
      required this.vendorId,
      required this.insideProduct,
      required this.price,
      required this.name,
      required this.desc,
      required this.id,
      required this.stock,
      required this.imageURL,
      required this.weight,
      required this.netWeight});

  @override
  State<AddtoCart> createState() => _AddtoCartState();
}

class _AddtoCartState extends State<AddtoCart> {
  CartServices _cart = CartServices();
  bool _loading = true;
  bool _exist = false;
  bool stockAvailable = true;
  int count = 0;
  String docID = "";
  final CartServices _cartServices = CartServices();

  @override
  void initState() {
    getCartData();
    super.initState();
  }

  getCartData() async {
    final snapshot =
        await _cart.cart.doc(widget.vendorId).collection("products").get();
    await FirebaseFirestore.instance
        .collection("Cart")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("products")
        .where("productID", isEqualTo: widget.id)
        .where('name', isEqualTo: widget.name)
        .snapshots()
        .listen((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((element) {
                if ((element['productID'] == widget.id) &&
                    (element['name'] == widget.name)) {
                  if (mounted) {
                    setState(() {
                      _exist = true;
                      count = element['productQty'];
                      docID = element.id;
                    });
                  }
                }
              })
            });
    if (snapshot.docs.isEmpty) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    if (widget.stock == 0) {
      stockAvailable = false;
    }

    return _loading
        ? Container(
            height: 5,
            width: 5,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : _exist
            ? FittedBox(
                child: SizedBox(
                  width: width(context) * 0.24,
                  height: height(context) * 0.04,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          if (count > 1) {
                            count--;
                            // _updating = true;
                          } else if (count == 1) {
                            // isSlide = !isSlide;
                            count = 0;
                            _cartServices
                                .removeFromCart(uid, docID)
                                .then((value) {
                              if (mounted)
                                setState(() {
                                  _exist = false;
                                });
                            });
                            _cartServices.checkData(uid);
                          }
                          if (mounted) setState(() {});
                          if (count == 0) setState(() {});
                          if (count > 0) {
                            Fluttertoast.showToast(
                                msg: "Product removed",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            var total = widget.price * count;
                            _cartServices
                                .update(uid, '', count, docID, total.toString())
                                .then((value) {
                              if (mounted)
                                setState(() {
                                  _exist = false;
                                });
                            });
                          }
                        },
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: widget.insideProduct ? 34 : 26,
                        ),
                      ),
                      Text(
                        count.toString(),
                        style: TextStyle(
                          fontSize: widget.insideProduct ? 20 : 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (count == widget.stock) {
                            Fluttertoast.showToast(
                                msg: "Maximum Stock reached",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            count++;

                            // widget._updating = true;
                            _exist = true;
                            if (count >= 1) {}
                            if (mounted) setState(() {});
                            Fluttertoast.showToast(
                                msg: "Product added",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            var total = widget.price * count;
                            _cartServices
                                .update(uid, '', count, docID, total.toString())
                                .then((value) {
                              if (mounted)
                                setState(() {
                                  // widget._updating = false;
                                  _exist = false;
                                });
                            });
                          }
                        },
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: widget.insideProduct ? 36 : 26,
                        ),
                      )
                    ],
                  ),
                ),
              )
            : GestureDetector(
                onTap: (() {
                  Fluttertoast.showToast(
                      msg: "Product added to Cart",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  _cart.addtoCart(
                      widget.vendorId,
                      widget.imageURL,
                      widget.id,
                      widget.price,
                      widget.price,
                      widget.name,
                      widget.desc,
                      widget.stock,
                      widget.weight,
                      widget.netWeight);
                  if (mounted)
                    setState(() {
                      _exist = true;
                    });
                }),
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.white),
                ),
              );
  }
}
