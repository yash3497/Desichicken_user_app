import 'package:delicious_app/widget/custom_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/constants.dart';
import 'add_new_address_screen.dart';

// import 'add_new_address_screen.dart';

class ChooseDeliveryLocation extends StatefulWidget {
  final CameraPosition position;
  final Set<Marker> markersList;
  final String location;
  const ChooseDeliveryLocation(
      {super.key,
      required this.position,
      required this.markersList,
      required this.location});

  @override
  State<ChooseDeliveryLocation> createState() => _ChooseDeliveryLocationState();
}

class _ChooseDeliveryLocationState extends State<ChooseDeliveryLocation> {
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
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
                  width: width(context) * 0.1,
                ),
                Text(
                  'Choose Delivery Location',
                  style: TextStyle(
                      color: primary,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          )),
      body: Column(
        children: [
          Container(
            height: height(context) * 0.6,
            width: width(context),
            child: GoogleMap(
              initialCameraPosition: widget.position,
              markers: widget.markersList,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  mapController = controller;
                });
              },
            ),
          ),
          Container(
            color: Colors.white,
            height: height(context) * 0.2,
            padding: EdgeInsets.all(10),
            width: width(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: primary,
                      size: 40,
                    ),
                    SizedBox(
                      width: width(context) * 0.7,
                      child: Text(
                        widget.location,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
                CustomButton(
                    buttonName: 'Confirm Location',
                    onClick: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddNewAddressScreen(
                                  existingDetials: [],
                                  isDefault: false,
                                  addressDocID: "not applicable",
                                  existing: false,
                                  lat: widget.position.target.latitude
                                      .toString(),
                                  lng: widget.position.target.longitude
                                      .toString())));
                    }),
                // GestureDetector(
                //   onTap: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => AddNewAddressScreen(
                //                 existingDetials: [],
                //                 isDefault: false,
                //                 addressDocID: "not applicable",
                //                 existing: false,
                //                 lat: widget.position.target.latitude.toString(),
                //                 lng: widget.position.target.longitude
                //                     .toString())));
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
                //         'Confirm Location',
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
          )
        ],
      ),
    );
  }
}
