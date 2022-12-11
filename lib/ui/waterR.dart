import 'dart:async';
import 'dart:convert';

import 'package:esp32sensor/services/data.dart';
import 'package:esp32sensor/ui/water_section.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_gauges/gauges.dart';

class waterR extends StatefulWidget {
  final String title;

  const waterR({super.key, required this.title});

  @override
  State<waterR> createState() => _waterRState();
}

class _waterRState extends State<waterR> {
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
                .push(MaterialPageRoute(builder: (context) => waterPage()));
          },
        ),
        title: Text(widget.title),
        backgroundColor: Color.fromARGB(255, 68, 158, 115),
      ),
      backgroundColor: Colors.lightGreenAccent.shade100,
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 100, bottom: 30),
            child: Text(
              "Concentration",
              style: TextStyle(
                  fontSize: 20.0,
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
                    label: "Pure",
                    endValue: 5,
                    color: Colors.greenAccent,
                  ),
                  GaugeRange(
                    startValue: 5,
                    label: "Good",
                    endValue: 20,
                    color: Color.fromARGB(255, 52, 106, 80),
                  ),
                  GaugeRange(
                    label: 'Moderate',
                    startValue: 20,
                    endValue: 40,
                    color: Color.fromARGB(255, 193, 206, 98),
                  ),
                  GaugeRange(
                    label: 'Unhealthy',
                    startValue: 40,
                    endValue: 70,
                    color: Color.fromARGB(255, 225, 175, 48),
                  ),
                  GaugeRange(
                    label: 'Hazardous',
                    startValue: 70,
                    endValue: 100,
                    color: Color.fromARGB(255, 240, 72, 72),
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

// class waterR extends StatefulWidget {
//   const waterR({super.key});

//   @override
//   State<waterR> createState() => _waterRState();
// }

// class _waterRState extends State<waterR> {
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
//         title: Text("water"),
//         backgroundColor: Color.fromARGB(255, 68, 158, 115),
//       ),
//     );
//   }
// }
}
