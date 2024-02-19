// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:esp32sensor/ui/agriR.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;

class AgriculturePage extends StatefulWidget {
  const AgriculturePage({Key? key}) : super(key: key);

  @override
  State<AgriculturePage> createState() => _AgriculturePageState();
}

class _AgriculturePageState extends State<AgriculturePage> {
  String avgConcentration = '';
  String date = '';
  Timer _timer = Timer.periodic(Duration(seconds: 5), (timer) {});

  late String greeting;
  late int len;
  late Map<String, dynamic> jsonResponse;
  late String url;

  String potassium = "";
  int concentration = 0;
  String phosphorous = '0';
  String nitrogen = '0';
  String humidity = '0';
  String temperature = '0';

  int time = 11;
  @override
  void initState() {
    _loadData();
    _timer = Timer.periodic(
        const Duration(seconds: 5), (Timer timer) => _loadData());
    super.initState();
    super.initState();
    // print("calling data");
    // print("called data");
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    url = "https://api.thingspeak.com/channels/2186816/feeds.json?results";

    //http request

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        int length = jsonResponse["feeds"].length;

        try {
          if (jsonResponse["feeds"][length - 1]["field1"] != null) {
            temperature = jsonResponse["feeds"][length - 1]["field1"];
          }
        } catch (e) {
          print(e.toString());
        }
        try {
          if (jsonResponse["feeds"][length - 1]["field2"] != null) {
            humidity = jsonResponse["feeds"][length - 1]["field2"];
          }
        } catch (e) {
          print(e.toString());
        }
        try {
          if (jsonResponse["feeds"][length - 1]["field3"] != null) {
            nitrogen = jsonResponse["feeds"][length - 1]["field3"];
          }
        } catch (e) {
          print("empty value for nitrogen");
        }
        try {
          if (jsonResponse["feeds"][length - 1]["field4"] != null) {
            phosphorous = jsonResponse["feeds"][length - 1]["field4"];
          }
        } catch (e) {
          print(e.toString());
        }
        try {
          if (jsonResponse["feeds"][length - 1]["field5"] != null) {
            potassium = jsonResponse["feeds"][length - 1]["field5"];
          }
        } catch (e) {
          print(e.toString());
        }
        // print(butane);
        // print(carbonDioxide);
        // print(temperature);
        // print(humidity);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: SizedBox(
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          title: Text(
            "Agriculture",
            style: TextStyle(
                fontFamily: 'JosefinSans',
                fontSize: MediaQuery.of(context).size.height * 0.03),
          ),
          backgroundColor: const Color.fromARGB(255, 78, 181, 131),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: Container(
          alignment: Alignment.center,
          color: const Color.fromARGB(255, 232, 241, 236),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text(
              //   "message_gas".tr,
              //   style: TextStyle(
              //       fontFamily: 'JosefinSans',
              //       color: const Color.fromARGB(255, 78, 181, 131),
              //       fontSize: MediaQuery.of(context).size.height * 0.05),
              // ),

              Padding(
                padding: const EdgeInsets.all(5),
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.62,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromARGB(255, 8, 86, 50),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.18,
                            width: MediaQuery.of(context).size.width * 0.80,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/agricultureIndustry.png"),
                                    fit: BoxFit.contain)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(10.0),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.23,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.23,
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 233, 231, 231),
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              '$temperature °C',
                                              style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 40, 132, 90),
                                                  fontFamily: 'JosefinSans',
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.018),
                                            ),
                                            Text(
                                              '$humidity RH%',
                                              style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 40, 132, 90),
                                                  fontFamily: 'JosefinSans',
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.018),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        'Temp. and RH%',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'JosefinSans',
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.018),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(10.0),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.23,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.23,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: Text(
                                          '$nitrogen PPM',
                                          style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 40, 132, 90),
                                              fontFamily: 'JosefinSans',
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.023),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Nitrogen (N)',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'JosefinSans',
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(10.0),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.23,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.23,
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 40, 132, 90),
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: Text(
                                          '$phosphorous PPM',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'JosefinSans',
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.021),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Phosphorous (P)',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'JosefinSans',
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(10.0),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.23,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.23,
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 68, 158, 115),
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: Text(
                                          '$potassium PPM',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'JosefinSans',
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.021),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Potassium (K)",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'JosefinSans',
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    onTap: (() {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AgriR(
                                title: 'Nitrogen',
                                dataParameter2: "field3",
                                referenceRange: '',
                              )));
                    }),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.075,
                      width: MediaQuery.of(context).size.width * 0.9,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              width: 2.0,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white),
                      child: Text(
                        'Nitrogen (N)',
                        style: TextStyle(
                            fontFamily: 'JosefinSans',
                            color: const Color.fromARGB(255, 8, 86, 50),
                            fontSize:
                                MediaQuery.of(context).size.height * 0.021,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    onTap: (() {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AgriR(
                                title: 'Phosphorous',
                                dataParameter2: "field4",
                                referenceRange: '',
                              )));
                    }),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.075,
                      width: MediaQuery.of(context).size.width * 0.9,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              width: 2.0,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white),
                      child: Text(
                        'Phosphorous (P)',
                        style: TextStyle(
                            fontFamily: 'JosefinSans',
                            color: const Color.fromARGB(255, 8, 86, 50),
                            fontSize:
                                MediaQuery.of(context).size.height * 0.021,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    onTap: (() {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AgriR(
                                title: 'Potassium',
                                dataParameter2: "field5",
                                referenceRange: '',
                              )));
                    }),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.075,
                      width: MediaQuery.of(context).size.width * 0.9,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              width: 2.0,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white),
                      child: Text(
                        'Potassium (K)',
                        style: TextStyle(
                            fontFamily: 'JosefinSans',
                            color: const Color.fromARGB(255, 8, 86, 50),
                            fontSize:
                                MediaQuery.of(context).size.height * 0.021,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
