// ignore_for_file: unused_field, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:upbox/services/auth.dart';

class EditAccount extends StatefulWidget {
  const EditAccount({super.key});

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  final User? user = Auth().currentUser;

  var name;
  var email;
  Future<dynamic> getUserFromFB() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: user!.uid)
        .get()
        .then((value) {
      name = value.docs[0]['username'];
      email = value.docs[0]['email'];
    });
  }

  Future<dynamic> updateData(name, email) async {
    if (name == '' || email == '') {
      Fluttertoast.showToast(
        msg: "No changes made",
        backgroundColor: Colors.black,
        gravity: ToastGravity.TOP,
      );
    } else {
      try {
        FirebaseAuth.instance.currentUser?.updateEmail(email);
      } on FirebaseException catch (e) {
        if (e.code == "email-already-in-use") {
          Fluttertoast.showToast(
            msg: "Sorry, this email is already in use",
            backgroundColor: Colors.orange,
          );
        } else if (e.code == "invalid-email") {
          Fluttertoast.showToast(
            msg: "Invalid email",
            backgroundColor: Colors.orange,
          );
        } else if (e.code == "requires-recent-login") {
          Fluttertoast.showToast(
            msg: "please logout and re-login and try again",
            backgroundColor: Colors.orange,
          );
        } else {
          FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
            'username': name,
            'email': email,
          });
          FirebaseAuth.instance.currentUser?.updateDisplayName(name);
          Fluttertoast.showToast(
            msg: "Profile updated successfully",
            backgroundColor: Colors.orange,
          );
          Navigator.of(context).pop();
        }
      }
    }
  }

  final TextEditingController _nameUpdate = TextEditingController();
  final TextEditingController _emailUpdate = TextEditingController();

  @override
  void initState() {
    getUserFromFB();
    super.initState();
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
        centerTitle: true,
        title: const Text(
          "Edit profile",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 175,
                  height: 175,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 238, 235, 235),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.dreamstime.com%2Fstock-illustration-vector-icon-user-avatar-web-site-mobile-app-man-face-flat-style-social-network-profile-image45836554&psig=AOvVaw2XpISv6ux3534b5gF2fKpf&ust=1682599185516000&source=images&cd=vfe&ved=0CBEQjRxqFwoTCPiTscjIx_4CFQAAAAAdAAAAABAE',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Text("PUBLIC INFORMATION"),
              const SizedBox(height: 5),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "First name",
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Phone number",
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.all(20),
                  ),
                  shadowColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                  elevation: MaterialStateProperty.all(0),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: const BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Update",
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
        ),
      ),
    );
  }
}
