// ignore_for_file: prefer_collection_literals, prefer_typing_uninitialized_variables, avoid_print
import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:upbox/pages/app_start.dart';
import 'package:upbox/services/local_notification_service.dart';
import 'package:upbox/services/location_service.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  final String sourceLocationName;
  final String destinationName;
  final String cNAme;
  final String sName;
  const MainScreen({
    super.key,
    required this.sourceLocationName,
    required this.destinationName,
    required this.cNAme,
    required this.sName,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var dName;
  var dPlate;
  var dRating;
  var dNumber;
  var dArrived;
  var dRides;
  var dId;
  getData() async {
    FirebaseFirestore.instance
        .collection('drivers')
        .where("driver_free", isEqualTo: 'true')
        .where("state", isEqualTo: widget.sName.trim())
        .where("number_verified", isEqualTo: true)
        .get()
        .then((value) {
      dName = value.docs[0]['name'];
      dPlate = value.docs[0]['plate_no'];
      dRating = value.docs[0]['rating'];
      dNumber = value.docs[0]['number'];
      dArrived = value.docs[0]['driver_arrived'];
      dRides = value.docs[0]['rides_count'];
      dId = value.docs[0]['id'];
    });
  }

  GeoPoint? dGeo;
  driverGeo() async {
    FirebaseFirestore.instance
        .collection('drivers')
        .where("id", isEqualTo: dId)
        .get()
        .then((value) {
      dGeo = value.docs[0]['driver_location'];
      print("driver latitude: ${dGeo!.latitude}");
      print("driver longitude: ${dGeo!.longitude}");
    });
  }

  void _showDialogCancelRide() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.topSlide,
      title: 'Cancel ride!',
      desc: 'Are you sure you want to cancel the ride?',
      btnOkOnPress: endRide,
      btnOkColor: Colors.orange,
      btnCancelOnPress: () {},
      btnCancelColor: const Color.fromARGB(255, 199, 199, 199),
    ).show();
  }

  void showDriverDetails() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(100, 237, 237, 237),
                      borderRadius: BorderRadius.circular(90),
                    ),
                    child: const Icon(Icons.person),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    dName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$dRides ride(s)",
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              Uri phoneDr = Uri.parse(
                                'tel:$dNumber',
                              );

                              if (await launchUrl(phoneDr)) {
                                debugPrint("Phone number is okay");
                              } else {
                                debugPrint('phone number errror');
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(100, 237, 237, 237),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Icon(Icons.call),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text("Call")
                        ],
                      ),
                      const SizedBox(width: 30),
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(100, 237, 237, 237),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(Icons.wifi_calling_3_rounded),
                          ),
                          const SizedBox(height: 5),
                          const Text("Internet call")
                        ],
                      ),
                    ],
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }

  void showReportRider() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.topSlide,
      title: 'Report rider!',
      desc: 'Report the rider to the closest auhority',
      btnOkOnPress: () {},
      btnOkColor: Colors.orange,
      btnCancelOnPress: () {},
      btnCancelColor: const Color.fromARGB(255, 199, 199, 199),
    ).show();
  }

  void rateRider() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                  "Ride success        "), // !important : don't edit the space
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close_rounded),
              )
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.star_border_rounded, size: 40),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.star_border_rounded, size: 40),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.star_border_rounded, size: 40),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.star_border_rounded, size: 40),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.star_border_rounded, size: 40),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  // Location functions -----------

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final Set<Marker> _markers = Set<Marker>();
  final Set<Polyline> _polylines = Set<Polyline>();

  // int _polylineIdCounter = 1;

  Future<dynamic> drawRide() async {
    NotificationService()
        .showNotification(title: "Upbox", body: "Rider has arrived");
    var directions = await LocationService().getDirection(
      widget.sourceLocationName.toString(),
      widget.destinationName.toString(),
    );
    _goToPlace(
      directions['start_location']['lat'],
      directions['start_location']['lng'],
      directions['bounds_ne'],
      directions['bounds_sw'],
    );

    _setPolyline(directions['polyline_decoded']);
  }

  Future<dynamic> trackRide() async {
    Fluttertoast.showToast(
      msg: "Finding a rider",
      gravity: ToastGravity.TOP,
    );
    BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'images/custom-icon.png',
    );
    Timer.periodic(const Duration(milliseconds: 1500), (timer) async {
      driverGeo();
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(dGeo!.latitude, dGeo!.longitude),
            zoom: 15.47,
            tilt: 50,
          ),
        ),
      );
      setState(() {
        _markers.add(
          Marker(
            visible: true,
            draggable: false,
            infoWindow: const InfoWindow(title: "Rider location"),
            markerId: const MarkerId('track_marker'),
            position: LatLng(dGeo!.latitude, dGeo!.longitude),
            icon: customIcon,
          ),
        );
      });
    });
    // lat and lng converter
  }

  void endRide() async {
    FirebaseFirestore.instance.collection('drivers').doc(dId).update({
      "driver_free": "true",
      "driver_arrived": "waiting",
    });
    _polylines.clear();
    _markers.clear();
    Fluttertoast.showToast(
      msg: "Upbox ride canceled",
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const AppStart();
        },
      ),
    );
  }

  void _setMarker(LatLng points) {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('marker'),
          position: points,
          infoWindow: InfoWindow(title: widget.sourceLocationName),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        ),
      );
    });
  }

  void _setPolyline(List<PointLatLng> points) {
    const String polylineIdval = 'polyline_1';
    // 'polyline_$_polylineIdCounter';
    // _polylineIdCounter++;

    _polylines.add(
      Polyline(
        polylineId: const PolylineId(polylineIdval),
        width: 6,
        color: Colors.orange,
        points: points
            .map(
              (point) => LatLng(point.latitude, point.longitude),
            )
            .toList(),
      ),
    );
  }

  // Ride distance in kilometres
  var km;

  getDis() async {
    var directions = await LocationService().getDirection(
      widget.sourceLocationName.toString(),
      widget.destinationName.toString(),
    );
    setState(() {
      km = directions['distance_km']['text'].toString();
    });

    debugPrint(directions['distance_km']['text']);
  }

  var price = double.parse('100');

  var conditionMet = false;

  @override
  void initState() {
    super.initState();
    getData();
    trackRide();
    getDis();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Upbox",
          style: TextStyle(fontSize: 25),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "${km ?? ''}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: dName != null &&
                dNumber != null &&
                dPlate != null &&
                dRating != null &&
                dId != null
            ? Stack(
                children: [
                  LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return SizedBox(
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('drivers')
                              .where("name", isEqualTo: dName)
                              .where("number", isEqualTo: dNumber)
                              .snapshots(),
                          builder: (context, snapshot) {
                            var status =
                                snapshot.data!.docs[0]['driver_arrived'];
                            GeoPoint geopoint =
                                snapshot.data!.docs[0]['driver_location'];
                            if (status == "true" && !conditionMet) {
                              FirebaseFirestore.instance
                                  .collection('drivers')
                                  .doc(dId!)
                                  .update({
                                "driver_free": "false",
                              });
                              drawRide();
                              conditionMet = true;
                            }
                            if (status == "complete") {
                              NotificationService().showNotification(
                                  title: "Upbox", body: "Ride is complete");
                              endRide();
                            }
                            return GoogleMap(
                              compassEnabled: false,
                              scrollGesturesEnabled: true,
                              tiltGesturesEnabled: false,
                              rotateGesturesEnabled: true,
                              zoomControlsEnabled: false,
                              zoomGesturesEnabled: false,
                              markers: _markers,
                              polylines: _polylines,
                              mapType: MapType.normal,
                              myLocationEnabled: false,
                              myLocationButtonEnabled: false,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  geopoint.latitude,
                                  geopoint.longitude,
                                ),
                                zoom: 15,
                              ),
                              onMapCreated:
                                  (GoogleMapController controller) async {
                                _controller.complete(controller);
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: 0.2,
                    minChildSize: 0.2,
                    maxChildSize: 0.42,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return SingleChildScrollView(
                        controller: scrollController,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(15, 0, 0, 0),
                                blurRadius: 12,
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 60,
                                height: 7,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color:
                                      const Color.fromARGB(255, 199, 199, 199),
                                ),
                              ),
                              const SizedBox(height: 19),

                              // 1st part start
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 5,
                                      bottom: 5,
                                      left: 12,
                                      right: 12,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(100, 237, 237, 237),
                                    ),
                                    child: Text(
                                      dPlate.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 23,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        child: Icon(
                                          Icons.currency_pound_outlined,
                                          color: Colors.orange,
                                        ),
                                      ),
                                      Text(
                                        price.toString(),
                                        style: const TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),

                              // 2nd Part
                              const SizedBox(height: 25),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: showDriverDetails,
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                              100,
                                              237,
                                              237,
                                              237,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: const Icon(Icons.person),
                                        ),
                                      ),
                                      Text(
                                        dName.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.orange,
                                            size: 12,
                                          ),
                                          Text(dRating.toString()),
                                        ],
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: showReportRider,
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                100, 237, 237, 237),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: const Icon(
                                              Icons.bike_scooter_outlined),
                                        ),
                                      ),
                                      const Text(
                                        "Report rider",
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                                      // The text widget below is a space
                                      const Text(""),
                                    ],
                                  )
                                ],
                              ),

                              const SizedBox(height: 15),

                              // third part
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                      ),
                                      Text(widget.sourceLocationName),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Icon(
                                        Icons.delivery_dining_outlined,
                                        color: Colors.orange,
                                      ),
                                      Text(widget.destinationName),
                                    ],
                                  )
                                ],
                              ),

                              // Fourth part,
                              const SizedBox(height: 15),
                              ElevatedButton(
                                onPressed: _showDialogCancelRide,
                                style: ButtonStyle(
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(10),
                                  ),
                                  // backgroundColor: MaterialStateProperty.all<Color>(),
                                  shadowColor: MaterialStateProperty.all<Color>(
                                      Colors.transparent),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: const BorderSide(
                                          color: Colors.transparent),
                                    ),
                                  ),
                                  elevation: MaterialStateProperty.all(0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Cancel ride",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // ending||
                            ],
                          ),
                        ),
                      );
                    },
                  )
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(strokeWidth: 7),
                    const Text("Searching for rider please"),
                    const SizedBox(height: 18),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "cancel search",
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _goToPlace(
    double lat,
    double lng,
    Map<String, dynamic> boundsNe,
    Map<String, dynamic> boundsSw,
  ) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lng),
          zoom: 15.47,
          tilt: 50,
        ),
      ),
    );

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
            northeast: LatLng(boundsNe['lat'], boundsNe['lng']),
          ),
          15),
    );

    _setMarker(LatLng(lat, lng));
  }
}
