import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upbox/pages/authentication/otp_screen.dart';

class NumberRegister extends StatefulWidget {
  const NumberRegister({super.key});

  @override
  State<NumberRegister> createState() => _NumberRegisterState();
}

class _NumberRegisterState extends State<NumberRegister> {
  final TextEditingController _phoneNumber = TextEditingController();
  bool _isbtnActive = false;

  final FocusNode inpLoad = FocusNode();

  // ignore: prefer_typing_uninitialized_variables
  late var cCode;

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
                        "Phone number Verfication",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "verfiy phone number to continue",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        height: 70,
                        color: Colors.transparent,
                      ),
                      TextFormField(
                        focusNode: inpLoad,
                        onChanged: (value) {
                          setState(() {
                            _isbtnActive = value.length >= 10 ? true : false;
                          });
                        },
                        controller: _phoneNumber,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          hintText: "Phone number",
                          // prefix: CountryCodePicker(
                          //   initialSelection: "NG",
                          //   onInit: (value) async {
                          //     setState(() {
                          //       cCode = value!.dialCode;
                          //     });
                          //   },
                          //   onChanged: (value) {
                          //     setState(() {
                          //       cCode = value.dialCode;
                          //     });
                          //   },
                          // ),
                        ),
                      ),
                      Container(
                        height: 60,
                        color: Colors.transparent,
                      ),
                      ElevatedButton(
                        onPressed: _isbtnActive == true
                            ? () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return OTPscreen(
                                        code: '+234',
                                        phonenumber: _phoneNumber.text,
                                      );
                                    },
                                  ),
                                );
                              }
                            : null,
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(20),
                          ),
                          shadowColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                          elevation: MaterialStateProperty.all(0),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
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
