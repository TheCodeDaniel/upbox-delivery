import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:upbox/pages/account/edit_account.dart';
import 'package:upbox/pages/intro-screens/onboarding_screen.dart';
import 'package:upbox/services/auth.dart';
import 'package:upbox/services/storage_service.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final User? user = Auth().currentUser;

  void _showSignOut() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.topSlide,
      title: 'Confirm logout!',
      desc: 'Are you sure you want to logout?',
      btnOkOnPress: signOut,
      btnOkColor: Colors.black,
      btnCancelOnPress: () {},
      btnCancelColor: const Color.fromARGB(255, 199, 199, 199),
    ).show();
  }

  Future<void> signOut() async {
    Fluttertoast.showToast(
      msg: "You have been logged out",
      textColor: Colors.white,
      gravity: ToastGravity.TOP,
      toastLength: Toast.LENGTH_SHORT,
    );
    await Auth().signOut().then(
          (value) => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return const OnboardingScreen();
              },
            ),
          ),
        );
  }

  Future<void> deleteAccount() async {
    Fluttertoast.showToast(
      msg: "Account deleted, We hope to see you again in the future",
      textColor: Colors.white,
      gravity: ToastGravity.TOP,
      toastLength: Toast.LENGTH_SHORT,
    );
    await FirebaseAuth.instance.currentUser!.delete().then((value) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return const OnboardingScreen();
          },
        ),
      );
    });
  }

  // ignore: prefer_typing_uninitialized_variables
  var imageName;
  getImage() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: user!.uid)
        .get()
        .then((value) {
      setState(() {
        imageName = value.docs[0]['image_url'];
      });

      debugPrint('image url is :  $imageName');
    });
  }

  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");

  final Storage storage = Storage();

  @override
  void initState() {
    getImage();
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
        title: const Text(
          "Profile",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                PageTransition(
                  child: const EditAccount(),
                  childCurrent: widget,
                  type: PageTransitionType.fade,
                  duration: const Duration(seconds: 0),
                  reverseDuration: const Duration(seconds: 0),
                ),
              );
            },
            icon: const Icon(
              Icons.edit,
              size: 20,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(height: 50),
              Center(
                child: Column(
                  children: [
                    FutureBuilder(
                      future: storage.downloadUrl("$imageName"),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return IconButton(
                            color: Colors.black,
                            icon: const Icon(Icons.person),
                            onPressed: () async {
                              final result =
                                  await FilePicker.platform.pickFiles(
                                allowMultiple: false,
                                type: FileType.custom,
                                allowedExtensions: ['png', 'jpg'],
                              );

                              if (result == null) {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("No file selected"),
                                  ),
                                );
                                // ignore: avoid_returning_null_for_void
                                return null;
                              }

                              final path = result.files.single.path!;
                              final fileName = result.files.single.name;

                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user!.uid)
                                  .update({'image_url': user!.uid + fileName});
                              storage
                                  .uploadFile(path, user!.uid + fileName)
                                  .then((value) {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Image saved successfully"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              });
                            },
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Container(
                          width: 75,
                          height: 75,
                          color: const Color.fromARGB(255, 198, 197, 197),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(snapshot.data!),
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 5),
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection("users")
                          .where("id", isEqualTo: user!.uid)
                          .get(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          var name =
                              snapshot.data!.docs[0]['username'].toString();
                          return Text(
                            name,
                            style: const TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        return const Text(
                          "error",
                          style: TextStyle(color: Colors.red),
                        );
                      },
                    ),
                    Text(
                      user?.email ?? 'Loading...',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .where("id", isEqualTo: user!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(
                            '${snapshot.error}',
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("Loading....");
                        }
                        Widget numbVer() {
                          if (snapshot.data!.docs[0]['phoneNumberVerification']
                                  .toString() ==
                              "true") {
                            return const Text(
                              "Verified",
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            );
                          } else {
                            return GestureDetector(
                              onTap: () {
                                // verify phone number if not verified
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.5),
                                ),
                                child: const Text(
                                  "un-verified",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            );
                          }
                        }

                        return ListTile(
                          leading: const Icon(Icons.phone_iphone_outlined),
                          title: Text(
                            snapshot.data!.docs[0]['phonenumber'].toString(),
                          ),
                          trailing: numbVer(),
                          onTap: () {},
                        );
                      },
                    ),
                    const Divider(
                      height: 10,
                    ),
                    ListTile(
                      leading: const Icon(Icons.language),
                      title: const Text("Language"),
                      subtitle: const Text("English - US"),
                      onTap: () {},
                    ),
                    const Divider(
                      height: 10,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.login_outlined,
                        size: 21,
                      ),
                      title: const Text(
                        "Log - out",
                        style: TextStyle(fontSize: 19),
                      ),
                      // subtitle: const Text("logout of your account"),
                      onTap: () {
                        _showSignOut();
                      },
                    )
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
