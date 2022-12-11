import 'package:esp32sensor/ui/waterR.dart';
import 'package:esp32sensor/ui/home.dart';
import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';

import '../services/storage.dart';
import 'package:get/get.dart';

class waterPage extends StatefulWidget {
  const waterPage({Key? key}) : super(key: key);

  @override
  State<waterPage> createState() => _waterPageState();
}

class _waterPageState extends State<waterPage> {
  final _dataFrom = GlobalKey<FormState>();

  // save data and change page
  void _saveData() async {
    if (_dataFrom.currentState!.validate()) {
      print('Valid');

      // save data
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(StorageKeys.CHANNEL_ID, "1807598");
      prefs.setInt(StorageKeys.FIELD_COUNT, 3);
      prefs.setBool(StorageKeys.SAVE_STATUS, true);

      // change page
      // Navigator.pop(context);
      // Navigator.pushNamed(context, '/sub');
    } else {
      print('Invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _saveData();
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Homepage()));
          },
        ),
        title: Text(
          "water".tr,
          style: TextStyle(fontFamily: 'JosefinSans'),
        ),
        backgroundColor: const Color.fromARGB(255, 78, 181, 131),
      ),
      backgroundColor: Colors.lightGreenAccent.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: InkWell(
                onTap: (() {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const waterR(
                            title: 'CO2',
                          )));
                }),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.7,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromARGB(255, 78, 181, 131)),
                  child: Text(
                    "CO2",
                    style: TextStyle(
                        fontFamily: 'JosefinSans',
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: MediaQuery.of(context).size.height * 0.03),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: InkWell(
                onTap: (() {
                  _saveData();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const waterR(
                            title: 'NO2',
                          )));
                }),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.7,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromARGB(255, 78, 181, 131)),
                  child: Text(
                    "NO2",
                    style: TextStyle(
                        fontFamily: 'JosefinSans',
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: MediaQuery.of(context).size.height * 0.03),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: InkWell(
                onTap: (() {
                  _saveData();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const waterR(
                            title: 'SO2',
                          )));
                }),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.7,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromARGB(255, 78, 181, 131)),
                  child: Text(
                    "SO2",
                    style: TextStyle(
                        fontFamily: 'JosefinSans',
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: MediaQuery.of(context).size.height * 0.03),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
