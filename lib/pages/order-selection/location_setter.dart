import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:upbox/pages/maps_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:upbox/services/location_service.dart';

class LocSet extends StatefulWidget {
  const LocSet({super.key});

  @override
  State<LocSet> createState() => _LocSetState();
}

class _LocSetState extends State<LocSet> {
  TextEditingController inputOne = TextEditingController();
  TextEditingController inputTwo = TextEditingController();

  bool _isbtnActive = false;

  String? countryName;
  String? state;

  void locationData() async {
    try {
      var url = Uri.parse('http://ip-api.com/json');
      Response response = await http.get(url);
      Map data = json.decode(response.body);
      // Getting the variables from the API
      String country = data['country'];
      String region = data['regionName'];
      String city = data['city'];

      setState(() {
        countryName = country;
        state = city;
      });
      debugPrint(region);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  var placeList = [
    'Area one',
    'Area 11',
    'Area 22',
  ];
  @override
  void initState() {
    super.initState();
    locationData();
  }

  Future<dynamic> getLocationSuggestion(String query) async {
    var key = LocationService().key;
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$key');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      final places = json.decode(response.body);

      var result = {
        'places_prediction1': places['predictions'][0]['description'],
        'places_prediction2': places['predictions'][1]['description'],
        'places_prediction3': places['predictions'][2]['description'] ?? '',
        'places_prediction4': places['predictions'][3]['description'] ?? '',
      };

      // setState(() {
      //   placeList = result;
      // });

      // ignore: avoid_print
      print(result);
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
        ),
        elevation: 0,
        iconTheme: const IconThemeData(size: 30),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: const Text(
          "UpBox",
          style: TextStyle(
            fontSize: 26,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 80, color: Colors.white),
              const Text(
                "Enter location",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Enter the pick up and delivery location of your item",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              Align(
                child: TextFormField(
                  controller: inputOne,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(23),
                    hintText: "Enter pick up location",
                    prefixIcon: const Icon(Icons.pedal_bike_sharp),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) async {
                    await getLocationSuggestion(value);
                  },
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                  },
                ),
              ),
              const SizedBox(height: 40),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    _isbtnActive = value.length >= 5 ? true : false;
                  });
                },
                controller: inputTwo,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(23),
                  hintText: "Enter delivery location",
                  prefixIcon: const Icon(Icons.delivery_dining_sharp),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 3),
              Container(
                alignment: const Alignment(0, 0.7),
                child: ElevatedButton(
                  onPressed: _isbtnActive == true
                      ? () {
                          Navigator.of(context).push(
                            PageTransition(
                              child: MainScreen(
                                sourceLocationName: inputOne.text,
                                destinationName: inputTwo.text,
                                cNAme: countryName.toString(),
                                sName: state.toString(),
                              ),
                              childCurrent: widget,
                              type: PageTransitionType.rightToLeftJoined,
                              duration: const Duration(milliseconds: 200),
                              reverseDuration:
                                  const Duration(milliseconds: 200),
                            ),
                          );
                        }
                      : null,
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(20),
                    ),
                    // backgroundColor: MaterialStateProperty.all<Color>(),
                    shadowColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                    elevation: MaterialStateProperty.all(0),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Continue with this location",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
