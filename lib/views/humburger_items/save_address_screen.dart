import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious_app/utils/constants.dart';
import 'package:delicious_app/views/humburger_items/add_address_screen.dart';
import 'package:delicious_app/views/start/map_screen.dart';
import 'package:delicious_app/widget/address_tile.dart';
import 'package:delicious_app/widget/custom_gradient_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../widget/custom_appbar.dart';
import '../../widget/login_popup.dart';

class SavedAddressScreen extends StatefulWidget {
  SavedAddressScreen({super.key});

  @override
  State<SavedAddressScreen> createState() => _SavedAddressScreenState();
}

class _SavedAddressScreenState extends State<SavedAddressScreen> {
  @override
  void initState() {
    _getDefaultID();
    // TODO: implement initState
    super.initState();
  }

  String currDefaultID = "";

  final Stream<QuerySnapshot> addresses = FirebaseFirestore.instance
      .collection('Addresses')
      .where('customerID',
          isEqualTo: FirebaseAuth.instance.currentUser != null
              ? FirebaseAuth.instance.currentUser?.uid
              : "")
      .snapshots();

  _getDefaultID() {
    FirebaseFirestore.instance
        .collection('Addresses')
        .where('customerID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) => value.docs.forEach((element) {
              // print(element['name']);
              if (element['isDefault'] == true) currDefaultID = element.id;
              print(currDefaultID);
              setState(() {});
              // print(element['total']);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppbar(title: 'Saved Address', button: SizedBox()),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: addresses,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Something wrong occurred");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }

                  final data = snapshot.requireData;
                  print(data.docs.length);

                  return GridView.builder(
                    shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.size,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1, childAspectRatio: 3.7),
                    itemBuilder: (BuildContext context, int index) {
                      print(data.docs[index]['wholeAddress']);
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context, {
                            "wholeAddress": data.docs[index]['wholeAddress'],
                            "lat": data.docs[index]['lat'],
                            "lng": data.docs[index]['lng'],
                          });
                        },
                        child: AddressTile(
                            currDefaultID: currDefaultID,
                            lat: data.docs[index]['lat'],
                            addressDocID: data.docs[index].id,
                            lng: data.docs[index]['lng'],
                            existing: true,
                            isDefault: data.docs[index]['isDefault'],
                            existingDetials: [
                              data.docs[index]['Address1'],
                              data.docs[index]['Address2'],
                              data.docs[index]['Pincode'],
                              data.docs[index]['State'],
                              data.docs[index]['Locality'],
                              data.docs[index]['Landmark'],
                              data.docs[index]['city']
                            ],
                            address: data.docs[index]['wholeAddress'],
                            tag: data.docs[index]['tag']),
                      );
                    },
                  );
                }),
            // ListView.builder(
            //     itemCount: addressList.length,
            //     itemBuilder: (context, index) {
            //       return
            //     })
          ),
          CustomButton(
              buttonName: 'Add New Address',
              onClick: () {
                if (FirebaseAuth.instance.currentUser == null) {
                  showLoginPopup(context);
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MapScreen()));
                }
              }),
          addVerticalSpace(20)
        ],
      ),
    );
  }
}
