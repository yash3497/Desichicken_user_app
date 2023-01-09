import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../views/my_cart/cart_tab_screen.dart';

class CartServices {
  CollectionReference cart = FirebaseFirestore.instance.collection("Cart");

  Future<void> addtoCart(
      String uid,
      String image,
      String id,
      num price,
      num total,
      String name,
      String desc,
      num stock,
      num weight,
      num netWeight,
      String catId,
      ) {
    print("add to cart");
    cart.doc(FirebaseAuth.instance.currentUser!.uid).set({
      "customerID": FirebaseAuth.instance.currentUser!.uid,
    });
    // print("loading");
    // print(uid);
    return cart
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('products')
        .add({
      "image": image,
      "stock": stock,
      "weight": weight,
      "netWeight": netWeight,
      "productID": id,
      "vendorId": uid,
      "price": price,
      'total': price,
      "name": name,
      "desc": desc,
      'productQty': 1,
      "catId":catId,
    });
  }

  Future<void> update(
      String uid, String pid, num qty, String docID, String price) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("Cart")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("products")
        .doc(docID);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      if (!snapshot.exists) {
        throw Exception("Product does not exist");
      }

      transaction
          .update(documentReference, {'productQty': qty, 'total': price});

      return qty;
    }).then((value) {
      _fetchCartList();
    }).catchError((error) => print("Failed due to error : $error"));
  }

  Future<void> removeFromCart(String uid, String docID) async {
    cart.doc(uid).collection("products").doc(docID).delete();
  }

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
      }
    });
  }

  Future<void> clearCart(String uid) async {
    print("cleared cart");

    cart
        .doc(uid)
        .collection('products')
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs.forEach((element) {
              // print(element.id);
              cart.doc(uid).collection('products').doc(element.id).delete();
            }));
    FirebaseFirestore.instance.collection("Cart").doc(uid).delete();
    // final snapshot = await FirebaseFirestore.instance.collection("Cart").doc(uid).collection("products").get();
    // snapshot.docs.clear();
  }

  Future<void> checkData(String uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("Cart")
        .doc(uid)
        .collection("products")
        .get();
    if (snapshot.docs.isEmpty) {
      FirebaseFirestore.instance.collection("Cart").doc(uid).delete();
      _fetchCartList();
    }
  }

  Future<double> getCartTotal(String uid) async {
    var carttotal = 0.0;
    QuerySnapshot snapshot = await cart.doc(uid).collection('products').get();
    if (snapshot == null) {
      return 0.0;
    }
    snapshot.docs.forEach((element) {
      carttotal += int.parse(element['total']);
    });
    return carttotal;
  }
}
