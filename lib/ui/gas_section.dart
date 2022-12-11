import 'package:esp32sensor/ui/gasR.dart';
import 'package:esp32sensor/ui/home.dart';
import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';

import '../services/storage.dart';
import 'package:get/get.dart';

class GasPage extends StatefulWidget {
  const GasPage({Key? key}) : super(key: key);

  @override
  State<GasPage> createState() => _GasPageState();
}

class _GasPageState extends State<GasPage> {
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
          "gas".tr,
          style: TextStyle(fontFamily: 'JosefinSans'),
        ),
        backgroundColor: const Color.fromARGB(255, 78, 181, 131),
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Choose a gas".tr,
              style: TextStyle(
                  fontFamily: 'JosefinSans',
                  color: Color.fromARGB(255, 78, 181, 131),
                  fontSize: MediaQuery.of(context).size.height * 0.05),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.30,
              width: MediaQuery.of(context).size.width * 0.80,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  image: const DecorationImage(
                      image: AssetImage("assets/images/gasindustry.png"),
                      fit: BoxFit.contain)),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: InkWell(
                onTap: (() {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GasR(
                            title: 'CO2'.tr,
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
                    "CO2".tr,
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
                      builder: (context) => GasR(
                            title: 'NO2'.tr,
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
                    "NO2".tr,
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
                      builder: (context) => GasR(
                            title: 'SO2'.tr,
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
                    "SO2".tr,
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
