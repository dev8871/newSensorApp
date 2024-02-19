import 'dart:async';
import 'dart:convert';
import 'package:esp32sensor/services/createPdf.dart';
import 'package:quickalert/quickalert.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BioR extends StatefulWidget {
  final String title;
  final String dataParameter2;
  final String referenceRange;

  const BioR(
      {super.key,
      required this.title,
      required this.dataParameter2,
      required this.referenceRange});

  @override
  State<BioR> createState() => _BioRState();
}

class _BioRState extends State<BioR> {
  late List<LiveData> chartData;
  late Map<String, dynamic> dailyJsonResponse;
  List<HistoryData> fullData = [];
  List<HistoryData> dailyData = [];
  List<HistoryData> weeklyData = [];
  List<HistoryData> monthlyData = [];
  List<HistoryData> historyData = [];
  late ChartSeriesController _chartSeriesController;
  String concSimplified = "";
  String doubleconc = "";
  Color graphColor = const Color.fromARGB(255, 152, 151, 151);
  String graphLabel = "...";
  // Color.fromARGB(255, 68, 158, 115)
  bool timerOff = false;
  String avgConcentration = '';
  String date = '';
  Timer _timer = Timer.periodic(const Duration(seconds: 5), (timer) {});

  late String greeting;
  late int len;
  late Map<String, dynamic> jsonResponse;
  late String url;
  String concentration = '0';
  String humidity = '0';
  String temperature = '0';

  int last_concentration = 0;
  int time = 11;
  int j = 0;
  Future<void> updatingHistoryData() async {
    List months = [
      " ",
      "Jan",
      "Feb",
      "Mar",
      "April",
      "May",
      "June",
      "July",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    // if ("field1" == "field3") {
    //   url =
    //       "https://thingspeak.com/channels/2186816/field/3.json?average=daily&round=0";
    // } else if ("field1" == "field4") {
    //   url =
    //       "https://thingspeak.com/channels/2186816/field/4.json?average=daily&round=0";
    // } else {
    //   url =
    //       "https://thingspeak.com/channels/2186816/field/5.json?average=daily&round=0";
    // }
    url =
        "https://thingspeak.com/channels/2303264/field/5.json?average=daily&round=0";
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        dailyJsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        int length = dailyJsonResponse["feeds"].length;

        print('length = $length');
        for (int i = 9; i >= 0; i--) {
          try {
            concentration = '0';
            if (dailyJsonResponse["feeds"][length - 1]["field1"] != null) {
              concentration = dailyJsonResponse["feeds"][length - 1]["field1"];
            }
          } catch (e) {
            print(e.toString());
          }
          DateTime date = DateTime.parse(
              dailyJsonResponse["feeds"][length - 1 - i]["created_at"]);
          if (int.parse(concentration) > 500) {
            concentration = '500';
          }
          dailyData.add(HistoryData(
              '${date.day} ${months[date.month]}', int.parse(concentration)));
        }
        for (int i = 70; i > 0; i = i - 7) {
          int avgVal = 0;
          for (int j = i; j > i - 7 && j > 0; j--) {
            int myValue = 0;
            try {
              if (i < length &&
                  dailyJsonResponse["feeds"][length - j]["field1"] != null) {
                concentration =
                    dailyJsonResponse["feeds"][length - j]["field1"];
                myValue = int.parse(concentration);
              }
            } catch (e) {
              print(e.toString());
            }
            avgVal += myValue;
          }
          int weeklyAvg = (avgVal / 7).round();
          if (weeklyAvg > 500) {
            weeklyAvg = 500;
          }
          weeklyData.add(HistoryData('${i / 7} Week', weeklyAvg));
        }

        int currentmonth = 0, monthCount = 0, avgValue = 0;
        for (int k = 0; k < length; k++) {
          int myValue1 = 0;
          DateTime date =
              DateTime.parse(dailyJsonResponse["feeds"][k]["created_at"]);
          int month = date.month;
          try {
            if (dailyJsonResponse["feeds"][k]["field1"] != null) {
              concentration = dailyJsonResponse["feeds"][k]["field1"];

              myValue1 = int.parse(concentration);
            }
          } catch (e) {
            myValue1 = 0;
          }
          if (k == 0) {
            currentmonth = month;
          } else if (currentmonth != month || k == length - 1) {
            int monthlyAvg = (avgValue / monthCount).round();
            monthCount = 0;
            avgValue = 0;
            if (monthlyAvg > 500) {
              monthlyAvg = 500;
            }
            monthlyData.add(HistoryData('${months[currentmonth]}', monthlyAvg));
            currentmonth = month;
          }
          avgValue += myValue1;
          monthCount++;
        }
      });
    }
    concentration = '0';
  }

  @override
  void initState() {
    print("field1");
    updatingHistoryData();
    chartData = getChartData();

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

  void showAlert() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      text: "Warning_msg".tr,
      title: "Warning".tr,
      titleColor: Colors.red,
      confirmBtnText: 'Okay'.tr,
      //confirmBtnColor: Colors.green
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
              width: MediaQuery.of(context).size.width * 0.3,
              child: FloatingActionButton.extended(
                heroTag: "btn1",
                elevation: 10.0,
                onPressed: () {
                  setState(() {
                    temperature = '0';
                    humidity = '0';
                    time = 11;
                    concentration = '0';
                    chartData = [
                      LiveData(0, 0),
                      LiveData(1, 0),
                      LiveData(2, 0),
                      LiveData(3, 0),
                      LiveData(4, 0),
                      LiveData(5, 0),
                      LiveData(6, 0),
                      LiveData(7, 0),
                      LiveData(8, 0),
                      LiveData(9, 0),
                      LiveData(10, 0),
                    ];
                  });
                },
                icon: const Icon(
                  Icons.update,
                  color: Color.fromARGB(255, 68, 158, 115),
                ),
                label: Text(
                  'Update',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 68, 158, 115),
                      fontSize: MediaQuery.of(context).size.height * 0.018),
                ),
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              timerOff = true;
              Navigator.pop(context);
            });
          },
        ),
        title: Text(
          widget.title.tr,
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.025,
              fontWeight: FontWeight.bold,
              letterSpacing: 1),
        ),
        backgroundColor: const Color.fromARGB(255, 68, 158, 115),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              "Concentration".tr,
              style: const TextStyle(
                  fontSize: 40.0,
                  color: Color.fromARGB(255, 68, 158, 115),
                  fontFamily: 'JosefinSans',
                  letterSpacing: 2.0),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.white,
                        width: 3.0,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(18),
                    color: Color.fromARGB(255, 23, 102, 65),
                  ),
                  child: Center(
                    child: Text(
                      doubleconc == "" ? "... µA" : '$doubleconc µA',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'JosefinSans',
                          fontSize: MediaQuery.of(context).size.height * 0.07),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.white, width: 3.0, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(18),
              color: graphColor,
            ),
            child: Center(
              child: Text(
                // doubleconc == "" ? "... µA" : '$doubleconc µA',
                graphLabel,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'JosefinSans',
                    fontSize: MediaQuery.of(context).size.height * 0.06,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: FloatingActionButton.extended(
                    heroTag: "btn2",
                    elevation: 10.0,
                    onPressed: () {
                      updatingHistoryData();
                      setState(() {
                        historyData = dailyData;
                      });
                      var index = 0;
                      String xAxisTitle = "Date";
                      showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return SimpleDialog(
                                title: const Text(
                                  "History",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 68, 158, 115),
                                      fontFamily: 'JosefinSans'),
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        TextButton(
                                            style: TextButton.styleFrom(
                                                elevation: 6.0,
                                                shadowColor:
                                                    const Color.fromARGB(
                                                        255, 144, 142, 142),
                                                // disabledBackgroundColor:
                                                //     const Color.fromARGB(255, 68, 158, 115),
                                                backgroundColor: index == 0
                                                    ? const Color.fromARGB(
                                                        255, 68, 158, 115)
                                                    : const Color.fromARGB(
                                                        255, 255, 255, 255)),
                                            onPressed: () {
                                              setState(() {
                                                xAxisTitle = "Date";
                                                index = 0;
                                                historyData = dailyData;
                                              });
                                            },
                                            child: Text(
                                              "Daily",
                                              style: TextStyle(
                                                  color: (index == 0)
                                                      ? const Color.fromARGB(
                                                          255, 255, 255, 255)
                                                      : const Color.fromARGB(
                                                          255, 68, 158, 115),
                                                  fontFamily: 'JosefinSans',
                                                  fontWeight: FontWeight.w200),
                                            )),
                                        TextButton(
                                            style: TextButton.styleFrom(
                                                elevation: 6.0,
                                                shadowColor:
                                                    const Color.fromARGB(
                                                        255, 144, 142, 142),
                                                // disabledBackgroundColor:
                                                //     const Color.fromARGB(255, 68, 158, 115),
                                                backgroundColor: (index == 1)
                                                    ? const Color.fromARGB(
                                                        255, 68, 158, 115)
                                                    : const Color.fromARGB(
                                                        255, 255, 255, 255)),
                                            onPressed: () {
                                              setState(() {
                                                xAxisTitle = "Past Weeks";
                                                index = 1;
                                                historyData = weeklyData;
                                              });
                                            },
                                            child: Text(
                                              "Weekly",
                                              style: TextStyle(
                                                  color: (index == 1)
                                                      ? const Color.fromARGB(
                                                          255, 255, 255, 255)
                                                      : const Color.fromARGB(
                                                          255, 68, 158, 115),
                                                  fontFamily: 'JosefinSans',
                                                  fontWeight: FontWeight.w200),
                                            )),
                                        TextButton(
                                            style: TextButton.styleFrom(
                                                elevation: 6.0,
                                                shadowColor:
                                                    const Color.fromARGB(
                                                        255, 144, 142, 142),
                                                // disabledBackgroundColor:
                                                //     const Color.fromARGB(255, 68, 158, 115),
                                                backgroundColor: (index == 2)
                                                    ? const Color.fromARGB(
                                                        255, 68, 158, 115)
                                                    : const Color.fromARGB(
                                                        255, 255, 255, 255)),
                                            onPressed: () {
                                              setState(() {
                                                xAxisTitle = "Past Months";
                                                index = 2;
                                                historyData = monthlyData;
                                              });
                                            },
                                            child: Text(
                                              "Monthly",
                                              style: TextStyle(
                                                  color: (index == 2)
                                                      ? const Color.fromARGB(
                                                          255, 255, 255, 255)
                                                      : const Color.fromARGB(
                                                          255, 68, 158, 115),
                                                  fontFamily: 'JosefinSans',
                                                  fontWeight: FontWeight.w200),
                                            )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      width: MediaQuery.of(context).size.width *
                                          0.95,
                                      child: SfCartesianChart(
                                        primaryXAxis: CategoryAxis(
                                            labelRotation: -90,
                                            interval: 1.0,
                                            title: AxisTitle(
                                                text: xAxisTitle,
                                                textStyle: const TextStyle(
                                                    fontSize: 12.0,
                                                    color: Color.fromARGB(
                                                        255, 68, 158, 115),
                                                    fontFamily:
                                                        'JosefinSans'))),
                                        primaryYAxis: NumericAxis(
                                            interval: 5.0,
                                            title: AxisTitle(
                                                text:
                                                    'Average Concentration (PPM)',
                                                textStyle: const TextStyle(
                                                    fontSize: 12.0,
                                                    color: Color.fromARGB(
                                                        255, 68, 158, 115),
                                                    fontFamily:
                                                        'JosefinSans'))),
                                        series: <ChartSeries>[
                                          StackedColumnSeries<HistoryData,
                                                  String>(
                                              color: const Color.fromARGB(
                                                  255, 68, 158, 115),
                                              dataSource: historyData,
                                              xValueMapper:
                                                  (HistoryData history, _) =>
                                                      history.date,
                                              yValueMapper:
                                                  (HistoryData history, _) =>
                                                      history.concentration)
                                        ],
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        right: 15),
                                    child: TextButton(
                                        style: TextButton.styleFrom(
                                            elevation: 8.0,
                                            shadowColor: const Color.fromARGB(
                                                255, 144, 142, 142),
                                            // disabledBackgroundColor:
                                            //     const Color.fromARGB(255, 68, 158, 115),
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 68, 158, 115)),
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text(
                                          "Okay",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontFamily: 'JosefinSans',
                                              fontWeight: FontWeight.w400),
                                        )),
                                  )
                                ],
                              );
                            });
                          });
                    },
                    icon: const Icon(Icons.calendar_month, color: Colors.white),
                    label: const Text(
                      'History',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'JosefinSans',
                          fontSize: 15.0),
                    ),
                    backgroundColor: const Color.fromARGB(255, 68, 158, 115)),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: FloatingActionButton.extended(
                    onPressed: () {
                      CreatePdf().createPDF(
                          'Bio Sensor',
                          widget.title,
                          humidity,
                          temperature,
                          concentration,
                          widget.referenceRange);
                    },
                    icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                    label: const Text(
                      'Generate',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'JosefinSans',
                          fontSize: 15.0),
                    ),
                    backgroundColor: const Color.fromARGB(255, 238, 119, 55)),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _loadData() async {
    url = "https://api.thingspeak.com/channels/2303264/feeds.json?results";

    //http request

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200 && timerOff == false) {
      setState(() {
        jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        int length = jsonResponse["feeds"].length;

        try {
          if (jsonResponse["feeds"][length - 1]["field1"] != null) {
            concentration = jsonResponse["feeds"][length - 1]["field1"];
            int i = 0;
            int clength = concentration.length;

            // print(uricAcid);
            concSimplified = "";
            while (concentration[i] != '.' && i < clength) {
              concSimplified += concentration[i];
              i++;
            }
            i = 0;
            doubleconc = "";
            while (concentration[i] != '\r' && i < clength) {
              doubleconc += concentration[i];
              i++;
            }
            concentration = concSimplified;
            // print("length= $length conc= $uricAcidSimplified");
          }
          setState(() {
            if (doubleconc == "") {
              graphColor = const Color.fromARGB(255, 255, 255, 255);
              graphLabel = "...";
            } else if (double.parse(doubleconc) < 20) {
              graphColor = Color.fromARGB(255, 68, 158, 115);
              graphLabel = "Pure";
            } else if (double.parse(doubleconc) < 40) {
              graphColor = Color.fromARGB(255, 233, 249, 8);
              graphLabel = "Good";
            } else if (double.parse(doubleconc) < 60) {
              graphColor = Color.fromARGB(255, 255, 191, 0);
              graphLabel = "Moderate";
            } else if (double.parse(doubleconc) < 80) {
              graphColor = Colors.orange;
              graphLabel = "Unhealthy";
            } else if (double.parse(doubleconc) < 40) {
              graphColor = Colors.red;
              graphLabel = "Hazardous";
            }
          });
        } catch (e) {
          print(e.toString());
        }
        // try {
        //   if (jsonResponse["feeds"][length - 1]["field1"] !=
        //       null) {
        //     concentration =
        //         jsonResponse["feeds"][length - 1]["field1"];
        //   } else {
        //     concentration = last_concentration.toString();
        //     print("Null value from Thingspeak: ");
        //   }
        // } catch (e) {
        //   print(e.toString());
        // }
        // try {
        //   if (jsonResponse["feeds"][length - 1]["field1"] != null) {
        //     temperature = jsonResponse["feeds"][length - 1]["field1"];
        //   }
        // } catch (e) {
        //   print(e.toString());
        // }
        // try {
        //   if (jsonResponse["feeds"][length - 1]["field2"] != null) {
        //     humidity = jsonResponse["feeds"][length - 1]["field2"];
        //   }
        // } catch (e) {
        //   print(e.toString());
        // }

        // print(concentration);

        if (int.parse(concentration) >= 100 &&
            timerOff == false &&
            last_concentration != concentration) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            padding: const EdgeInsets.all(16.0),
            content: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 90,
                  // MediaQuery.of(context).size.height * 0.10,
                  // width: MediaQuery.of(context).size.width * 0.80,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 217, 25, 25),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: const Row(
                    children: [
                      SizedBox(
                        width: 4,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 50.0, top: 12),
                            child: Text(
                              "Warning!",
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontStyle: FontStyle.normal),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 50.0, top: 8),
                            child: Text(
                              "The concentration is in hazardous range",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20)),
                    child: SvgPicture.asset(
                      'assets/images/bubbles.svg',
                      height: 48,
                      width: 40,
                      color: const Color.fromARGB(255, 161, 20, 10),
                    ),
                  ),
                ),
                Positioned(
                  top: -20,
                  left: 0,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/fail.svg",
                        color: const Color.fromARGB(255, 161, 20, 10),
                        height: 45,
                      ),
                      Positioned(
                        top: 12,
                        child: SvgPicture.asset("assets/images/close.svg",
                            height: 12),
                      ),
                    ],
                  ),
                )
              ],
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ));
        }
        last_concentration = int.parse(concentration);

        chartData.add(LiveData(time++, int.parse(concentration)));
        chartData.removeAt(0);
        _chartSeriesController.updateDataSource(
            addedDataIndex: chartData.length - 1, removedDataIndex: 0);
        // to not display warning if concentration does not change
      });
    }
  }

  List<LiveData> getChartData() {
    return <LiveData>[
      LiveData(0, 0),
      LiveData(1, 0),
      LiveData(2, 0),
      LiveData(3, 0),
      LiveData(4, 0),
      LiveData(5, int.parse(concentration)),
      LiveData(6, int.parse(concentration)),
      LiveData(7, int.parse(concentration)),
      LiveData(8, int.parse(concentration)),
      LiveData(9, int.parse(concentration)),
      LiveData(10, int.parse(concentration)),
    ];
  }
}

class LiveData {
  LiveData(this.time, this.conc);
  final int time;
  final int conc;
}

class HistoryData {
  HistoryData(this.date, this.concentration);
  final String date;
  final int concentration;
}
