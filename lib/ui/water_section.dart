import 'package:esp32sensor/ui/waterR.dart';
import "package:flutter/material.dart";

class WaterPage extends StatefulWidget {
  const WaterPage({super.key});

  @override
  State<WaterPage> createState() => _WaterPageState();
}

class _WaterPageState extends State<WaterPage> {
  String avgConcentration = '';
  String date = '';

  late String greeting;
  late int len;
  late Map<String, dynamic> jsonResponse;
  late String url;

  late String resistance = "";
  String mercuryIons = '0';
  String leadIons = '0';
  String arsenicIons = '0';

  int time = 11;
  @override
  void initState() {
    super.initState();
    super.initState();
    // print("calling data");
    // print("called data");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData(primaryColor: Colors.white, indicatorColor: Colors.white),
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
            "Water Sensor",
            style: TextStyle(
                fontFamily: 'JosefinSans',
                fontSize: MediaQuery.of(context).size.height * 0.03,
                color: Colors.white),
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
                        image: AssetImage("assets/images/waterIndustry.png"),
                        fit: BoxFit.contain)),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    onTap: (() {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const WaterR(
                                title: 'Mercury Ions',
                                dataParameter2: "field1",
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
                      child: Text(
                        'Mercury Ions',
                        style: TextStyle(
                            fontFamily: 'JosefinSans',
                            color: const Color.fromARGB(255, 8, 86, 50),
                            fontSize:
                                MediaQuery.of(context).size.height * 0.045,
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
                          builder: (context) => const WaterR(
                                title: 'Lead Ions',
                                dataParameter2: "field1",
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
                      child: Text(
                        'Lead Ions',
                        style: TextStyle(
                            fontFamily: 'JosefinSans',
                            color: const Color.fromARGB(255, 8, 86, 50),
                            fontSize:
                                MediaQuery.of(context).size.height * 0.045,
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
                          builder: (context) => const WaterR(
                                title: 'Arsenic Ions',
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
                      child: Text(
                        'Arsenic Ions',
                        style: TextStyle(
                            fontFamily: 'JosefinSans',
                            color: const Color.fromARGB(255, 8, 86, 50),
                            fontSize:
                                MediaQuery.of(context).size.height * 0.045,
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
