import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:upbox/services/auth.dart';
import 'package:upbox/services/widget_tree.dart';

class OTPscreen extends StatefulWidget {
  final String phonenumber;
  final String code;
  const OTPscreen({
    super.key,
    required this.phonenumber,
    required this.code,
  });

  @override
  State<OTPscreen> createState() => _OTPscreenState();
}

class _OTPscreenState extends State<OTPscreen> {
  TextEditingController one = TextEditingController();
  TextEditingController two = TextEditingController();
  TextEditingController three = TextEditingController();
  TextEditingController four = TextEditingController();
  TextEditingController five = TextEditingController();
  TextEditingController six = TextEditingController();

  final User? user = Auth().currentUser;

  final FocusNode inpNode = FocusNode();

  // ignore: prefer_typing_uninitialized_variables
  var verificationCode;

  // verify number
  void verifyPhone() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.code + widget.phonenumber,
        verificationCompleted: (phoneAuthCredential) {
          debugPrint("all done");
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint(e.message);
        },
        codeSent: ((verificationId, forceResendingToken) {
          setState(() {
            verificationCode = verificationId;
          });
          debugPrint(verificationCode);
        }),
        codeAutoRetrievalTimeout: (verificationId) {
          setState(() {
            verificationCode = verificationId;
          });
        },
        timeout: const Duration(seconds: 120),
      );
    } catch (e) {
      debugPrint("Caught error: $e");
    }
  }

  String? userId = FirebaseAuth.instance.currentUser?.uid;

  int timeLeft = 120;
  void startCountDown() {
    Timer.periodic(const Duration(seconds: 120), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft = timeLeft - 1;
        });
      } else {
        timer.cancel();
      }
    });
  }

  Widget timeWidg() {
    if (timeLeft == 0) {
      return TextButton(
          onPressed: () {
            verifyPhone();
          },
          child: const Text("Resend OTP"));
    } else {
      return Text("code will expire in ${timeLeft.toString()} second(s)");
    }
  }

  @override
  void initState() {
    super.initState();
    verifyPhone();
    startCountDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Container(
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.transparent,
                  height: 140,
                  // color: Colors.transparent,
                  child: Image.asset(
                    "images/top.png",
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "OTP verfication",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text(
                            "enter the otp sent to",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            widget.phonenumber,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 70,
                        color: Colors.transparent,
                      ),
                      Form(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 68,
                              width: 42.67,
                              child: TextFormField(
                                focusNode: inpNode,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                controller: one,
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                                style: Theme.of(context).textTheme.titleLarge,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 68,
                              width: 42.67,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                controller: two,
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                                style: Theme.of(context).textTheme.titleLarge,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 68,
                              width: 42.67,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                controller: three,
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                                style: Theme.of(context).textTheme.titleLarge,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 68,
                              width: 42.67,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                controller: four,
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                                style: Theme.of(context).textTheme.titleLarge,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 68,
                              width: 42.67,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                controller: five,
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                                style: Theme.of(context).textTheme.titleLarge,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 68,
                              width: 42.67,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                controller: six,
                                onEditingComplete: () async {
                                  try {
                                    final AuthCredential credentials =
                                        PhoneAuthProvider.credential(
                                      verificationId: verificationCode,
                                      smsCode: (one.text +
                                          two.text +
                                          three.text +
                                          four.text +
                                          five.text +
                                          six.text),
                                    );
                                    await FirebaseAuth.instance.currentUser!
                                        .linkWithCredential(credentials)
                                        .then((value) {
                                      FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(userId)
                                          .update({
                                        "phonenumber":
                                            widget.code + widget.phonenumber,
                                        "phoneNumberVerification": true,
                                      }).then((value) {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (BuildContext context) {
                                              return const WidgetTree();
                                            },
                                          ),
                                        );
                                      });
                                    });
                                  } on FirebaseException catch (e) {
                                    debugPrint(e.toString());
                                    final snack = SnackBar(
                                      content: Text(e.message.toString()),
                                      duration: const Duration(seconds: 5),
                                      action: SnackBarAction(
                                        label: "close",
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                        },
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snack);
                                  }
                                },
                                style: Theme.of(context).textTheme.titleLarge,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      timeWidg(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
