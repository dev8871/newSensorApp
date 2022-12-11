import 'package:esp32sensor/ui/gas_section.dart';
import 'package:esp32sensor/ui/soil_section.dart';
import 'package:esp32sensor/ui/water_section.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';

class Homepage extends StatelessWidget {
  Homepage({Key? key}) : super(key: key);

  final List locale = const [
    {'name': "ENGLISH", "locale": Locale('en', 'US')},
    {'name': "हिन्दी", "locale": Locale('hi', 'IN')},
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
            title: const Text(
              "Choose language",
              style: TextStyle(fontFamily: "JosefinSans"),
            ),
            content: Container(
              // alignment: Alignment.center,
              width: double.maxFinite,
              child: Container(
                // height: MediaQuery.of(context).size.height * 0.1,
                child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: GestureDetector(
                            onTap: () {
                              updatelanguage(locale[index]['locale']);
                            },
                            child: Text(locale[index]['name'])),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(color: Colors.blue);
                    },
                    itemCount: locale.length),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text(
          'title'.tr,
          style: TextStyle(
            fontFamily: 'JosefinSans',
            fontSize: 25.0,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 68, 158, 115),
      ),
      backgroundColor: Color.fromARGB(255, 252, 255, 249),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.30,
                width: MediaQuery.of(context).size.width * 0.80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    image: const DecorationImage(
                        image: AssetImage("assets/images/farmindustry.png"),
                        fit: BoxFit.contain)),
              ),
              Text(
                "Choose a sensor".tr,
                style: TextStyle(
                    fontFamily: 'JosefinSans',
                    color: Color.fromARGB(255, 78, 181, 131),
                    fontSize: MediaQuery.of(context).size.height * 0.05),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      InkWell(
                        onTap: (() {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => waterPage()));
                        }),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.white,
                                  width: 2.0,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(15),
                              image: const DecorationImage(
                                  image: AssetImage("assets/images/water.png"),
                                  fit: BoxFit.cover)),
                          height: MediaQuery.of(context).size.height * 0.12,
                          width: MediaQuery.of(context).size.width * 0.25,
                          alignment: Alignment.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "water".tr,
                          style: TextStyle(
                              fontFamily: 'JosefinSans',
                              color: Color.fromARGB(255, 78, 181, 131),
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => soilPage()));
                        }),
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
                                  image: AssetImage("assets/images/soil.png"),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Agriculture".tr,
                          style: TextStyle(
                              fontFamily: 'JosefinSans',
                              color: Color.fromARGB(255, 78, 181, 131),
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => GasPage()));
                        }),
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
                                  image: AssetImage("assets/images/gas.png"),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "gas".tr,
                          style: TextStyle(
                              fontFamily: 'JosefinSans',
                              color: Color.fromARGB(255, 78, 181, 131),
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.03),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      builddialog(context);
                    },
                    child: Text(
                      "Change Language".tr,
                      style: TextStyle(fontFamily: "JosefinSans"),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
