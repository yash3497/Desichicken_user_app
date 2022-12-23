import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious_app/widget/BottomNavBar.dart';
import 'package:delicious_app/widget/custom_gradient_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../utils/constants.dart';

class AddNewAddressScreen extends StatefulWidget {
  final String lat;
  final String lng;
  final List<String> existingDetials;
  final bool existing;
  final bool isDefault;
  final String addressDocID;
  const AddNewAddressScreen(
      {super.key,
      required this.lat,
      required this.lng,
      required this.existing,
      required this.addressDocID,
      required this.isDefault,
      required this.existingDetials});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  List addressplace = ['Home', 'Office', 'Others'];
  int currentIndex = 0;

  final TextEditingController addressController = TextEditingController();
  final TextEditingController streeController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController StateController = TextEditingController();
  final TextEditingController localityController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  String? _currentAddress;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        addressController.text = place.name.toString();
        cityController.text = place.subAdministrativeArea.toString();
        pincodeController.text = place.postalCode.toString();
        StateController.text = place.administrativeArea.toString();
        landmarkController.text = place.locality.toString();
        // _currentAddress =
        //     '${place.name}, ${place.locality}, ${place.subAdministrativeArea}, ${place.postalCode}';
        //     print(_currentAddress);
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  saveAddress(bool existing, String userID) async {
    if (existing) {
      String address1 = addressController.text.isEmpty
          ? widget.existingDetials[0]
          : addressController.text;
      String address2 = streeController.text.isEmpty
          ? widget.existingDetials[1]
          : streeController.text;
      String pincode = pincodeController.text.isEmpty
          ? widget.existingDetials[2]
          : pincodeController.text;
      String state = StateController.text.isEmpty
          ? widget.existingDetials[3]
          : StateController.text;
      String city = cityController.text.isEmpty
          ? widget.existingDetials[6]
          : cityController.text;
      String landmark = landmarkController.text.isEmpty
          ? widget.existingDetials[5]
          : landmarkController.text;
      String locality = localityController.text.isEmpty
          ? widget.existingDetials[0]
          : addressController.text;
      String wholeAddress = address1 +
          " " +
          address2 +
          " " +
          locality +
          " " +
          landmark +
          " " +
          pincode +
          " " +
          city +
          " " +
          state;

      await FirebaseFirestore.instance
          .collection("Addresses")
          .doc(widget.addressDocID)
          .set({
        'Address1': addressController.text.isEmpty
            ? widget.existingDetials[0]
            : addressController.text,
        'Address2': streeController.text.isEmpty
            ? widget.existingDetials[1]
            : streeController.text,
        'Pincode': pincodeController.text.isEmpty
            ? widget.existingDetials[2]
            : pincodeController.text,
        'State': StateController.text.isEmpty
            ? widget.existingDetials[3]
            : StateController.text,
        'customerID': userID,
        'city': cityController.text.isEmpty
            ? widget.existingDetials[6]
            : cityController.text,
        'Landmark': landmarkController.text.isEmpty
            ? widget.existingDetials[5]
            : landmarkController.text,
        'Locality': localityController.text.isEmpty
            ? widget.existingDetials[0]
            : addressController.text,
        'isDefault': widget.isDefault,
        'lat': widget.lat,
        'lng': widget.lng,
        'tag': addressplace[currentIndex],
        'wholeAddress': wholeAddress
      });
      Fluttertoast.showToast(
          msg: "Updated Address",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      String wholeAddress = addressController.text +
          " " +
          streeController.text +
          " " +
          localityController.text +
          " " +
          pincodeController.text +
          " " +
          cityController.text +
          " " +
          StateController.text;
      print(wholeAddress);
      await FirebaseFirestore.instance.collection("Addresses").doc().set({
        'Address1': addressController.text,
        'Address2': streeController.text,
        'Pincode': pincodeController.text,
        'State': StateController.text,
        'customerID': userID,
        'wholeAddress': wholeAddress,
        'city': cityController.text,
        'Landmark': landmarkController.text,
        'Locality': localityController.text,
        'isDefault': widget.isDefault,
        'lat': widget.lat,
        'lng': widget.lng,
        'tag': addressplace[currentIndex]
      });
      Fluttertoast.showToast(
          msg: "Added Address",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => BottomNavBar(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    final uid = user!.uid;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Container(
            height: height(context) * 0.13,
            // decoration: gradientBoxDecoration(yellowLinerGradient(), 0),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: primary,
                    )),
                SizedBox(
                  width: width(context) * 0.15,
                ),
                Text(
                  'Add New Address',
                  style: TextStyle(
                      color: primary,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height(context) * 0.1,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: addressplace.length,
                  itemBuilder: (ctx, i) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              currentIndex = i;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 18, top: 20),
                            height: 35,
                            width: width(context) * 0.25,
                            decoration: currentIndex == i
                                ? BoxDecoration(
                                    // gradient: yellowLinerGradient(),
                                    borderRadius: BorderRadius.circular(6))
                                : BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: const [
                                        BoxShadow(
                                            blurRadius: 1, color: Colors.grey)
                                      ]),
                            child: Center(
                                child: Text(
                              addressplace[i],
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            )),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
            CustomTextFeild(
              controller: addressController,
              hinttext: widget.existing
                  ? widget.existingDetials[0] == ""
                      ? 'Address (House No,Building)'
                      : widget.existingDetials[0]
                  : 'Address (House No,Building)',
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextFeild(
              controller: streeController,
              hinttext: widget.existing
                  ? widget.existingDetials[1] == ""
                      ? 'Address(Street,Area)'
                      : widget.existingDetials[1]
                  : 'Address (Street,Area)',
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: width(context) * 0.4,
                  child: CustomTextFeild(
                    hinttext: widget.existing
                        ? widget.existingDetials[2] == ""
                            ? 'Pincode'
                            : widget.existingDetials[2]
                        : 'Pincode',
                    controller: pincodeController,
                  ),
                ),
                SizedBox(
                  width: width(context) * 0.4,
                  child: CustomTextFeild(
                    hinttext: widget.existing
                        ? widget.existingDetials[3] == ""
                            ? 'State'
                            : widget.existingDetials[3]
                        : 'State',
                    controller: StateController,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextFeild(
              hinttext: widget.existing
                  ? widget.existingDetials[4] == ""
                      ? 'Locality/Town'
                      : widget.existingDetials[4]
                  : 'Locality/Town',
              controller: localityController,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextFeild(
              hinttext: widget.existing
                  ? widget.existingDetials[5] == ""
                      ? 'Landmark'
                      : widget.existingDetials[5]
                  : 'Landmark',
              controller: landmarkController,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextFeild(
              hinttext: widget.existing
                  ? widget.existingDetials[6] == ""
                      ? 'City'
                      : widget.existingDetials[6]
                  : 'City',
              controller: cityController,
            ),
            const SizedBox(
              height: 40,
            ),
            CustomButton(
                buttonName: 'Save',
                onClick: () {
                  addressController.text.isEmpty ||
                          streeController.text.isEmpty ||
                          pincodeController.text.isEmpty ||
                          StateController.text.isEmpty ||
                          localityController.text.isEmpty ||
                          landmarkController.text.isEmpty ||
                          cityController.text.isEmpty
                      ? Fluttertoast.showToast(
                          msg: 'Please fill all the fields')
                      : widget.existing
                          ? saveAddress(widget.existing, uid)
                          : saveAddress(widget.existing, uid);
                }),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
                buttonName: 'Use Current Location',
                onClick: _getCurrentPosition),
            // GestureDetector(
            //   onTap: () {
            //     saveAddress(widget.existing, uid);
            //     Navigator.pushAndRemoveUntil(
            //       context,
            //       MaterialPageRoute(
            //         builder: (BuildContext context) => BottomNavBar(),
            //       ),
            //       (route) => false,
            //     );
            //   },
            //   child: Container(
            //     width: width(context) * 0.9,
            //     height: height(context) * 0.05,
            //     decoration: BoxDecoration(
            //         // gradient: yellowLinerGradient(),
            //         boxShadow: [
            //           BoxShadow(
            //               color: Colors.black.withOpacity(0.2),
            //               blurRadius: 3,
            //               offset: Offset(0.5, 4)),
            //         ], borderRadius: BorderRadius.circular(30)),
            //     child: const Center(
            //       child: Text(
            //         'Save',
            //         style: TextStyle(
            //             color: Colors.white,
            //             fontWeight: FontWeight.w600,
            //             fontSize: 18),
            //       ),
            //     ),
            //   ),
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
            // GestureDetector(
            //   onTap: _getCurrentPosition,
            //   child: Container(
            //     width: width(context) * 0.9,
            //     height: height(context) * 0.05,
            //     decoration: BoxDecoration(
            //         // gradient: yellowLinerGradient(),
            //         boxShadow: [
            //           BoxShadow(
            //               color: Colors.black.withOpacity(0.2),
            //               blurRadius: 3,
            //               offset: Offset(0.5, 4)),
            //         ], borderRadius: BorderRadius.circular(30)),
            //     child: const Center(
            //       child: Text(
            //         'Use Current Location',
            //         style: TextStyle(
            //             color: Colors.white,
            //             fontWeight: FontWeight.w600,
            //             fontSize: 18),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class CustomTextFeild extends StatelessWidget {
  const CustomTextFeild({required this.hinttext, this.controller});
  final String hinttext;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height(context) * 0.06,
      width: width(context) * 0.9,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding: EdgeInsets.only(top: 6, left: 20),
            filled: true,
            hintStyle: TextStyle(color: Colors.grey[800]),
            hintText: hinttext,
            fillColor: Colors.white70),
      ),
    );
  }
}
