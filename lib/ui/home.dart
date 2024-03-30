import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esp32sensor/authentication/changePassword.dart';
import 'package:esp32sensor/intro_slider.dart';
import 'package:esp32sensor/services/editProfile.dart';
import 'package:esp32sensor/ui/About_us.dart';
import 'package:esp32sensor/ui/Bio_section.dart';
import 'package:esp32sensor/ui/agriculture_section.dart';
import 'package:esp32sensor/ui/gas_section.dart';
import 'package:esp32sensor/ui/water_section.dart';
import 'package:esp32sensor/video/videoStream.dart';
import 'package:firebase_auth/firebase_auth.dart';

import "package:flutter/material.dart";
import 'package:get/get.dart';

import '../services/auth.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  String name = '';
  String email = '';
  String channel = '';
  String mobile = '';
  String uid = '';
  Future<dynamic> gettingUserData() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();
    setState(() {
      name = (snap.data() as Map<String, dynamic>)["Name"];
      email = (snap.data() as Map<String, dynamic>)["email"];
      channel = (snap.data() as Map<String, dynamic>)["channel"];
      mobile = (snap.data() as Map<String, dynamic>)["mobile"];
      uid = (snap.data() as Map<String, dynamic>)["uid"];
      print(name);
      print(email);
    });
    return snap;
  }

  @override
  void initState() {
    gettingUserData();
    super.initState();
  }

  final AuthService _auth = AuthService();

  final List locale = const [
    {'name': "ENGLISH", "locale": Locale('en', 'US')},
    {'name': "हिन्दी", "locale": Locale('hi', 'IN')},
    {'name': "ಕನ್ನಡ", "locale": Locale('kan', 'KAR')},
    {'name': "தமிழ்", "locale": Locale('tam', 'TN')},
  ];

  updatelanguage(Locale locale) {
    Get.back();
    Get.updateLocale(locale);
  }

  builddialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: Text(
              "Choose language".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: "JosefinSans"),
            ),
            content: SizedBox(
              // alignment: Alignment.center,
              width: double.maxFinite,
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                            onTap: () {
                              updatelanguage(locale[index]['locale']);
                            },
                            child: Text(locale[index]['name'])),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(color: Colors.blue);
                  },
                  itemCount: locale.length),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              color: const Color.fromARGB(255, 78, 181, 131),
              width: double.infinity,
              height: 200,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    height: 100,
                    decoration: BoxDecoration(
                        border: Border.all(width: 2.0, color: Colors.white),
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                            image: AssetImage('assets/images/soil.png'))),
                  ),
                  Text(name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20.0,
                          fontFamily: 'JosefinSans')),
                  Text(
                    email,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w200,
                        fontSize: 15.0,
                        fontFamily: 'JosefinSans'),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 15.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfile(
                                    name: name,
                                    mobile: mobile,
                                    channel: channel,
                                    email: email,
                                    uid: uid,
                                  )));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Icon(
                              Icons.edit_note_sharp,
                              size: 25.0,
                              color: Colors.black54,
                            )),
                        Expanded(
                            child: Text(
                          "Edit Profile".tr,
                          style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontFamily: 'JosefinSans'),
                        ))
                      ]),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChangePassword()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        const Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Icon(
                              Icons.lock_open_sharp,
                              size: 25.0,
                              color: Colors.black54,
                            )),
                        Expanded(
                            child: Text(
                          "Change Password".tr,
                          style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontFamily: 'JosefinSans'),
                        ))
                      ]),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      builddialog(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        const Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Icon(
                              Icons.text_format_outlined,
                              size: 25.0,
                              color: Colors.black54,
                            )),
                        Expanded(
                            child: Text(
                          "Change Language".tr,
                          style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontFamily: 'JosefinSans'),
                        ))
                      ]),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const IntroSliderPage()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        const Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Icon(
                              Icons.question_answer_outlined,
                              size: 25.0,
                              color: Colors.black54,
                            )),
                        Expanded(
                            child: Text(
                          "How to use".tr,
                          style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontFamily: 'JosefinSans'),
                        ))
                      ]),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MyWidget()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        const Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Icon(
                              Icons.video_camera_front_outlined,
                              size: 25.0,
                              color: Colors.black54,
                            )),
                        Expanded(
                            child: Text(
                          "Demo Video".tr,
                          style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontFamily: 'JosefinSans'),
                        ))
                      ]),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AboutUs()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        const Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Icon(
                              Icons.info,
                              size: 25.0,
                              color: Colors.black54,
                            )),
                        Expanded(
                            child: Text(
                          "About Us".tr,
                          style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontFamily: 'JosefinSans'),
                        ))
                      ]),
                    ),
                  ),
                ],
              ),
            )
          ],
        )),
      ),
      appBar: AppBar(
        title: Text(
          'title'.tr,
          style: TextStyle(
              fontFamily: 'JosefinSans',
              fontSize: MediaQuery.of(context).size.height * 0.03,
              color: Colors.white),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: FloatingActionButton.extended(
                elevation: 10.0,
                onPressed: () async {
                  return _auth.signOut();
                },
                icon: const Icon(
                  Icons.logout,
                  color: Color.fromARGB(255, 68, 158, 115),
                ),
                label: Text(
                  "Logout".tr,
                  style: TextStyle(
                      color: const Color.fromARGB(255, 68, 158, 115),
                      fontFamily: 'JosefinSans',
                      fontSize: MediaQuery.of(context).size.height * 0.015),
                ),
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          )
        ],
        backgroundColor: const Color.fromARGB(255, 68, 158, 115),
      ),
      backgroundColor: const Color.fromARGB(255, 252, 255, 249),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 0.80,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/farmindustry.png"),
                      fit: BoxFit.contain)),
            ),
            Text(
              "message".tr,
              style: TextStyle(
                  fontFamily: 'JosefinSans',
                  color: const Color.fromARGB(255, 78, 181, 131),
                  fontSize: MediaQuery.of(context).size.height * 0.05),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        InkWell(
                          onTap: (() {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const BioPage()));
                          }),
                          child: Material(
                            elevation: 6,
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white,
                                      width: 2.0,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(15),
                                  image: const DecorationImage(
                                      image:
                                          AssetImage("assets/images/bio.png"),
                                      fit: BoxFit.cover)),
                              height: MediaQuery.of(context).size.height * 0.12,
                              width: MediaQuery.of(context).size.width * 0.25,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Bio Sensor",
                            style: TextStyle(
                                fontFamily: 'JosefinSans',
                                color: const Color.fromARGB(255, 78, 181, 131),
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: (() {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const AgriculturePage();
                            }));
                          }),
                          child: Material(
                            elevation: 6,
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.12,
                              width: MediaQuery.of(context).size.width * 0.25,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white,
                                      width: 2.0,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(15),
                                  image: const DecorationImage(
                                      image:
                                          AssetImage("assets/images/soil.png"),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "soil".tr,
                            style: TextStyle(
                                fontFamily: 'JosefinSans',
                                color: const Color.fromARGB(255, 78, 181, 131),
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        InkWell(
                          onTap: (() {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const GasPage();
                            }));
                          }),
                          child: Material(
                            elevation: 6,
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.12,
                              width: MediaQuery.of(context).size.width * 0.25,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white,
                                      width: 2.0,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(15),
                                  image: const DecorationImage(
                                      image:
                                          AssetImage("assets/images/gas.png"),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "gas".tr,
                            style: TextStyle(
                                fontFamily: 'JosefinSans',
                                color: const Color.fromARGB(255, 78, 181, 131),
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.03),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: (() {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const WaterPage();
                            }));
                          }),
                          child: Material(
                            elevation: 6,
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.12,
                              width: MediaQuery.of(context).size.width * 0.25,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white,
                                      width: 2.0,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(15),
                                  image: const DecorationImage(
                                      image:
                                          AssetImage("assets/images/water.png"),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Water",
                            style: TextStyle(
                                fontFamily: 'JosefinSans',
                                color: const Color.fromARGB(255, 78, 181, 131),
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.03),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      builddialog(context);
                    },
                    child: Text(
                      "Change Language".tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: "JosefinSans",
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          shadowColor: Colors.black),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const IntroSliderPage()));
                      },
                      child: Text(
                        "How to Use?".tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontFamily: "JosefinSans",
                            color: Color.fromARGB(255, 78, 181, 131)),
                      )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
