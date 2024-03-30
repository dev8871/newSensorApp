import 'dart:async';
import 'dart:convert';

import 'package:esp32sensor/ui/bioR.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;

class BioPage extends StatefulWidget {
  const BioPage({super.key});

  @override
  State<BioPage> createState() => _BioPageState();
}

class _BioPageState extends State<BioPage> {
  String avgConcentration = '';
  String date = '';
  Timer _timer = Timer.periodic(const Duration(seconds: 5), (timer) {});

  late String greeting;
  late int len;
  late Map<String, dynamic> jsonResponse;
  late String url;

  late String resistance = "";
  String uricAcid = '0';
  String glucose = '0';
  String caffeine = '0';
  String humidity = '0';
  String temperature = '0';

  int time = 11;
  @override
  void initState() {
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
    url = "https://api.thingspeak.com/channels/2303264/feeds.json?results";

    //http request

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        int length = jsonResponse["feeds"].length;

        try {
          if (jsonResponse["feeds"][length - 1]["field1"] != null) {
            uricAcid = jsonResponse["feeds"][length - 1]["field1"];
            String uricAcidSimplified = "";
            int i = 0;
            // print(uricAcid);
            while (uricAcid[i] != '\r') {
              uricAcidSimplified += uricAcid[i];
              i++;
            }
            uricAcid = uricAcidSimplified;
            // print("length= $length conc= $uricAcidSimplified");
          }
        } catch (e) {
          print(e.toString());
        }
        // try {
        //   if (jsonResponse["feeds"][length - 1]["field2"] != null) {
        //     glucose = jsonResponse["feeds"][length - 1]["field2"];
        //   }
        // } catch (e) {
        //   print(e.toString());
        // }
        // try {
        //   if (jsonResponse["feeds"][length - 1]["field3"] != null) {
        //     caffeine = jsonResponse["feeds"][length - 1]["field3"];
        //   }
        // } catch (e) {
        //   print("empty value for caffeine");
        // }
        // try {
        //   if (jsonResponse["feeds"][length - 1]["field4"] != null) {
        //     temperature = jsonResponse["feeds"][length - 1]["field4"];
        //   }
        // } catch (e) {
        //   print(e.toString());
        // }
        // try {
        //   if (jsonResponse["feeds"][length - 1]["field5"] != null) {
        //     humidity = jsonResponse["feeds"][length - 1]["field5"];
        //   }
        // } catch (e) {
        //   print(e.toString());
        // }
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
            "Bio Sensor",
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
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * 0.9,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/medicalIndustry.png"),
                        fit: BoxFit.contain)),
              ),
              // Text(
              //   "message_gas".tr,
              //   style: TextStyle(
              //       fontFamily: 'JosefinSans',
              //       color: const Color.fromARGB(255, 78, 181, 131),
              //       fontSize: MediaQuery.of(context).size.height * 0.05),
              // ),

              // Padding(
              //   padding: const EdgeInsets.all(5),
              //   child: Material(
              //     elevation: 2,
              //     borderRadius: BorderRadius.circular(15),
              //     child: Container(
              //       height: MediaQuery.of(context).size.height * 0.62,
              //       width: MediaQuery.of(context).size.width * 0.9,
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(15),
              //         color: Color.fromARGB(255, 255, 255, 255),
              //       ),
              //       child: Column(
              //           mainAxisAlignment: MainAxisAlignment.spaceAround,
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: [

              //           ]),
              //     ),
              //   ),
              // ),

              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    onTap: (() {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const BioR(
                                title: 'Uric Acid',
                                dataParameter2: "field3",
                                referenceRange: '140-430',
                              )));
                    }),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.18,
                      width: MediaQuery.of(context).size.width * 0.9,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              width: 2.0,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white),
                      child: Row(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.width * 0.4,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/uricAcid.png"),
                                    fit: BoxFit.contain)),
                          ),
                          Text(
                            'Uric Acid',
                            style: TextStyle(
                                fontFamily: 'JosefinSans',
                                color: const Color.fromARGB(255, 8, 86, 50),
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.045,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
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
                          builder: (context) => const BioR(
                                title: 'Glucose',
                                dataParameter2: "field2",
                                referenceRange: '390-710',
                              )));
                    }),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.18,
                      width: MediaQuery.of(context).size.width * 0.9,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              width: 2.0,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white),
                      child: Row(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.13,
                            width: MediaQuery.of(context).size.width * 0.4,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage("assets/images/glucose.png"),
                                    fit: BoxFit.contain)),
                          ),
                          Text(
                            'Glucose',
                            style: TextStyle(
                                fontFamily: 'JosefinSans',
                                color: const Color.fromARGB(255, 8, 86, 50),
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.045,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
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
                          builder: (context) => const BioR(
                                title: 'Caffeine',
                                dataParameter2: "field1",
                                referenceRange: '',
                              )));
                    }),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.18,
                      width: MediaQuery.of(context).size.width * 0.9,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              width: 2.0,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white),
                      child: Row(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.13,
                            width: MediaQuery.of(context).size.width * 0.4,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/caffeine.png"),
                                    fit: BoxFit.contain)),
                          ),
                          Text(
                            'Caffeine',
                            style: TextStyle(
                                fontFamily: 'JosefinSans',
                                color: const Color.fromARGB(255, 8, 86, 50),
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.045,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
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
