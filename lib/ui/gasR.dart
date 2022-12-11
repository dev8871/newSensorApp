import 'dart:async';
import 'dart:convert';

import 'package:esp32sensor/services/data.dart';
import 'package:esp32sensor/ui/gas_section.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:get/get.dart';

class GasR extends StatefulWidget {
  final String title;
  final double baseResistence = 0.25;

  const GasR({super.key, required this.title});

  @override
  State<GasR> createState() => _GasRState();
}

class _GasRState extends State<GasR> {
  late String greeting;
  late int len;
  late Map<String, dynamic> jsonResponse;
  late final String url;
  Data currentData = Data();
  late String resistance = "";
  double concentration = 0;

  @override
  void initState() {
    super.initState();
    // print("calling data");
    _loadData();
    // print("called data");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: reload(),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => GasPage()));
          },
        ),
        title: Text(widget.title.tr),
        backgroundColor: Color.fromARGB(255, 68, 158, 115),
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 100, bottom: 30),
            child: Text(
              "Concentration".tr,
              style: const TextStyle(
                  fontSize: 25.0,
                  color: Color.fromARGB(255, 68, 158, 115),
                  fontFamily: 'JosefinSans',
                  letterSpacing: 2.0),
            ),
          ),
          SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0.0,
                maximum: 100.00,
                interval: 10.0,
                ranges: <GaugeRange>[
                  GaugeRange(
                    startValue: 0.250,
                    endValue: 20,
                    rangeOffset: -5.0,
                    startWidth: 20,
                    endWidth: 20,
                    label: "Pure".tr,
                    labelStyle: GaugeTextStyle(color: Colors.white),
                    gradient: const SweepGradient(colors: [
                      Colors.greenAccent,
                      Color.fromARGB(255, 70, 164, 119),
                    ]),
                  ),
                  GaugeRange(
                    startValue: 20,
                    endValue: 40,
                    startWidth: 20,
                    endWidth: 20,
                    rangeOffset: -5.0,
                    label: "Good".tr,
                    labelStyle: GaugeTextStyle(color: Colors.white),
                    gradient: const SweepGradient(colors: [
                      Color.fromARGB(255, 70, 164, 119),
                      Color.fromARGB(255, 133, 207, 83),
                    ]),
                  ),
                  GaugeRange(
                    label: 'Moderate'.tr,
                    labelStyle: GaugeTextStyle(color: Colors.white),
                    startValue: 40,
                    endValue: 60,
                    startWidth: 20,
                    endWidth: 20,
                    rangeOffset: -5.0,
                    gradient: const SweepGradient(colors: [
                      Color.fromARGB(255, 133, 207, 83),
                      Color.fromARGB(255, 193, 206, 98),
                    ]),
                  ),
                  GaugeRange(
                    label: 'Unhealthy'.tr,
                    labelStyle: GaugeTextStyle(color: Colors.white),
                    startValue: 60,
                    endValue: 80,
                    startWidth: 20,
                    endWidth: 20,
                    rangeOffset: -5.0,
                    gradient: const SweepGradient(colors: [
                      Color.fromARGB(255, 193, 206, 98),
                      Color.fromARGB(255, 225, 175, 48),
                    ]),
                  ),
                  GaugeRange(
                    label: 'Hazardous'.tr,
                    labelStyle: GaugeTextStyle(color: Colors.white),
                    startValue: 80,
                    endValue: 100,
                    startWidth: 20,
                    endWidth: 20,
                    rangeOffset: -5.0,
                    gradient: const SweepGradient(colors: [
                      Color.fromARGB(255, 225, 175, 48),
                      Color.fromARGB(255, 240, 72, 72),
                    ]),
                  ),
                ],
                pointers: <GaugePointer>[
                  NeedlePointer(
                    value: concentration,
                    enableAnimation: true,
                  )
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    widget: Text(
                      '$concentration PPM',
                      style: TextStyle(color: Color.fromARGB(255, 52, 106, 80)),
                    ),
                    positionFactor: 0.5,
                    angle: 90,
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget reload() {
    return FloatingActionButton.extended(
      elevation: 10.0,
      onPressed: _loadData,
      icon: const Icon(Icons.update),
      label: Text('Update'),
      backgroundColor: Colors.red,
    );
  }

  Future<void> _loadData() async {
    url = "https://api.thingspeak.com/channels/1807598/feeds.json?results=1";

    Timer.periodic(Duration(seconds: 5), (timer) async {
      if (!currentData.status) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
      }

      //http request

      http.Response response = await http.get(Uri.parse(url));

      // Stop Timer
      // if(condition) {
      //   timer.cancel();
      // }

      if (response.statusCode == 200) {
        setState(() {
          jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
          print(jsonResponse);
          resistance = jsonResponse["feeds"][0]["field1"];

          if (int.parse(resistance) >= 4000000) {
            concentration = 100.00;
          } else if (int.parse(resistance) >= 3800000) {
            concentration = 75.00;
          } else if (int.parse(resistance) >= 3500000) {
            concentration = 50.00;
          } else if (int.parse(resistance) >= 3000000) {
            concentration = 30.00;
          } else if (int.parse(resistance) >= 2000000) {
            concentration = 20.00;
          } else if (int.parse(resistance) >= 1000000) {
            concentration = 10.00;
          } else if (int.parse(resistance) >= 40000) {
            concentration = 0.250;
          }

          currentData.setLoaded();
          // resistance = jsonResponse["feeds"[2]];
        });
      }
    });
  }

// class GasR extends StatefulWidget {
//   const GasR({super.key});

//   @override
//   State<GasR> createState() => _GasRState();
// }

// class _GasRState extends State<GasR> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.of(context)
//                 .push(MaterialPageRoute(builder: (context) => Homepage()));
//           },
//         ),
//         title: Text("Gas"),
//         backgroundColor: Color.fromARGB(255, 68, 158, 115),
//       ),
//     );
//   }
// }
}
