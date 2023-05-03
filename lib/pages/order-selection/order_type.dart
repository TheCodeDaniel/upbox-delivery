import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:page_transition/page_transition.dart';
import 'package:upbox/pages/order-selection/location_setter.dart';

class OrderType extends StatefulWidget {
  const OrderType({super.key});

  @override
  State<OrderType> createState() => _OrderTypeState();
}

class _OrderTypeState extends State<OrderType> {
  bool? _isChecked = false;
  bool? _isChecked2 = false;
  bool? _isChecked3 = false;

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
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 80, color: Colors.white),
              const Text(
                "Item type selection",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Select the category of your item",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 25),
              Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                height: 350,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      decoration: BoxDecoration(
                        border: _isChecked == true
                            ? Border.all(width: 2, color: Colors.orange)
                            : Border.all(
                                width: 2,
                                color: const Color.fromARGB(255, 232, 230, 230),
                              ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CheckboxListTile(
                        enableFeedback: true,
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          "Fragile products",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        value: _isChecked,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _isChecked = newValue;
                            _isChecked2 = false;
                            _isChecked3 = false;
                          });
                        },
                        activeColor: Colors.orange,
                        checkColor: Colors.white,
                        subtitle: const Text(
                            "select this option for fragile products"),
                        checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      decoration: BoxDecoration(
                        border: _isChecked2 == true
                            ? Border.all(width: 2, color: Colors.orange)
                            : Border.all(
                                width: 2,
                                color: const Color.fromARGB(255, 232, 230, 230),
                              ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CheckboxListTile(
                        enableFeedback: true,
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          "Semi-fragile products",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        value: _isChecked2,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _isChecked2 = newValue;
                            _isChecked = false;
                            _isChecked3 = false;
                          });
                        },
                        activeColor: Colors.orange,
                        checkColor: Colors.white,
                        subtitle:
                            const Text("select this option for semi-fragile"),
                        checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      decoration: BoxDecoration(
                        border: _isChecked3 == true
                            ? Border.all(width: 2, color: Colors.orange)
                            : Border.all(
                                width: 2,
                                color: const Color.fromARGB(255, 232, 230, 230),
                              ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CheckboxListTile(
                        enableFeedback: true,
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          "Non-fragile",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        value: _isChecked3,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _isChecked3 = newValue;
                            _isChecked = false;
                            _isChecked2 = false;
                          });
                        },
                        activeColor: Colors.orange,
                        checkColor: Colors.white,
                        subtitle:
                            const Text("select this option for non fragile"),
                        checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 8),
              ElevatedButton(
                onPressed: _isChecked == true ||
                        _isChecked2 == true ||
                        _isChecked3 == true
                    ? () {
                        if (_isChecked == true) {
                          SessionManager().set("item-type", 'fragile');
                        }
                        if (_isChecked2 == true) {
                          SessionManager().set("item-type", 'semi-fragile');
                        }
                        if (_isChecked3 == true) {
                          SessionManager().set("item-type", 'non-fragile');
                        }
                        Navigator.of(context).push(
                          PageTransition(
                            child: const LocSet(),
                            childCurrent: widget,
                            type: PageTransitionType.rightToLeftJoined,
                            duration: const Duration(milliseconds: 200),
                            reverseDuration: const Duration(milliseconds: 200),
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
                      "Continue",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
