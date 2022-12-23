import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious_app/views/start/add_new_address_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../utils/constants.dart';
import 'BottomNavBar.dart';

class AddressTile extends StatefulWidget {
  final String lat;
  final String lng;
  final List<String> existingDetials;
  final bool existing;
  final String addressDocID;
  final String currDefaultID;
  final bool isDefault;
  final String address;
  final String tag;

  const AddressTile(
      {super.key,
      required this.address,
      required this.tag,
      required this.lat,
      required this.lng,
      required this.existingDetials,
      required this.existing,
      required this.isDefault,
      required this.addressDocID,
      required this.currDefaultID});

  @override
  State<AddressTile> createState() => _AddressTileState();
}

class _AddressTileState extends State<AddressTile> {
  setDefault() async {
    if (widget.currDefaultID == "") {
    } else {
      print(widget.currDefaultID);
      await FirebaseFirestore.instance
          .collection('Addresses')
          .doc(widget.currDefaultID)
          .update({'isDefault': false});
    }
    await FirebaseFirestore.instance
        .collection('Addresses')
        .doc(widget.addressDocID)
        .update({'isDefault': true});

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => BottomNavBar(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        addVerticalSpace(10),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: primary,
            radius: 30,
            child: Icon(
              Icons.location_on_rounded,
              color: white,
              size: 30,
            ),
          ),
          title: Text(
            widget.tag,
            style: bodyText16w600(color: black),
          ),
          subtitle: Text(
            widget.address,
            style: bodyText12Small(color: black.withOpacity(0.5)),
          ),
          trailing: SizedBox(
            width: width(context) * 0.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => AddNewAddressScreen(
                                lat: widget.lat,
                                lng: widget.lng,
                                existing: widget.existing,
                                addressDocID: widget.addressDocID,
                                isDefault: widget.isDefault,
                                existingDetials: widget.existingDetials)));
                  },
                  child: Icon(
                    Icons.edit,
                    color: primary,
                  ),
                ),
                InkWell(
                  onTap: () {
                    FirebaseFirestore.instance
                        .collection("Addresses")
                        .doc(widget.addressDocID)
                        .delete();
                  },
                  child: Icon(
                    Icons.delete,
                    color: primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        widget.isDefault
            ? Container(child: Text("Already Default"))
            : GestureDetector(
                onTap: setDefault,
                child: Container(
                  child: Text("Set as default"),
                ),
              )
      ],
    );
  }
}
