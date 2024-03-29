import 'dart:developer';

import 'package:delicious_app/utils/constants.dart';
import 'package:delicious_app/views/home/home_screen.dart';
import 'package:delicious_app/views/humburger_items/fill_your_profile_screen.dart';
import 'package:delicious_app/widget/custom_gradient_button.dart';
import 'package:delicious_app/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_google_places/flutter_google_places.dart';

import '../../widget/BottomNavBar.dart';
import 'choose_location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late CameraPosition initialCameraPosition;
  @override
  void initState() {
    _handleLocationPermission();
    // TODO: implement initState
    super.initState();
    initialCameraPosition =
        CameraPosition(target: LatLng(latitude, longitude), zoom: 14.0);
    _fetchCurrentAddress();
  }

  GoogleMapController? mapController;
  Set<Marker> markersList = {};
  CameraPosition? cameraPosition;

  final Mode _mode = Mode.overlay;

  String location = "";
  var newlatlang = LatLng(latitude, longitude);

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

  _fetchCurrentAddress() async {
    log("latitude: $latitude");
    log("longitude: $longitude");
    List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude, longitude,
        localeIdentifier: 'en_IN');
    setState(() {
      location =
          "${placemarks[0].name}, ${placemarks[0].locality}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}";
    });
  }

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
                  width: width(context) * 0.2,
                ),
                Text(
                  'Search Place',
                  style: TextStyle(
                      color: primary,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: height(context) * 0.6,
                width: width(context),
                child: GoogleMap(
                  initialCameraPosition: initialCameraPosition,
                  markers: markersList,
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    setState(() {
                      mapController = controller;
                    });
                  },
                ),
              ),
              InkWell(
                  onTap: () async {
                    var place = await PlacesAutocomplete.show(
                        radius: 10,
                        context: context,
                        apiKey: 'AIzaSyACO-bM2g99iSEeT5XU7jYditz2U4RRafs',
                        mode: Mode.overlay,
                        types: [],
                        strictbounds: false,
                        components: [Component(Component.country, 'in')],
                        //google_map_webservice package
                        onError: (err) {
                          print("Places Error: ${err.errorMessage}");
                        });

                    if (place != null) {
                      setState(() {
                        location = place.description.toString();
                      });

                      //form google_maps_webservice package
                      final plist = GoogleMapsPlaces(
                        apiKey: "AIzaSyAuny-ypKqnRF4BRhNtPECpmZcHn3N8mNA",
                        apiHeaders: await const GoogleApiHeaders().getHeaders(),
                        //from google_api_headers package
                      );
                      String placeid = place.placeId ?? "0";
                      final detail = await plist.getDetailsByPlaceId(placeid);
                      final geometry = detail.result.geometry!;
                      final lat = geometry.location.lat;
                      final lang = geometry.location.lng;
                      setState(() {
                        newlatlang = LatLng(lat, lang);
                      });

                      markersList.clear();
                      markersList.add(Marker(
                          markerId: const MarkerId("0"),
                          position: LatLng(lat, lang),
                          infoWindow: InfoWindow(title: location)));

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChooseDeliveryLocation(
                                    position: CameraPosition(
                                        target: newlatlang, zoom: 17),
                                    markersList: markersList,
                                    location: detail.result.formattedAddress
                                        .toString(),
                                  )));
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Card(
                      child: Container(
                          padding: EdgeInsets.all(0),
                          width: MediaQuery.of(context).size.width - 40,
                          child: ListTile(
                            title: Text(
                              location,
                              style: TextStyle(fontSize: 18),
                            ),
                            trailing: Column(
                              children: [
                                Icon(Icons.search),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChooseDeliveryLocation(
                                                    position: CameraPosition(
                                                        target: newlatlang,
                                                        zoom: 17),
                                                    markersList: markersList,
                                                    location: location,
                                                  )));
                                    },
                                    child: Icon(Icons.send)),
                              ],
                            ),
                            dense: true,
                          )),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
