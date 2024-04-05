import 'package:flutter/material.dart';

// ignore: camel_case_types, must_be_immutable
class sensorButton extends StatelessWidget {
  sensorButton({
    required this.ontap,
    required this.title,
    required this.imageAdd,
    required this.titleSize,
    super.key,
  });

  VoidCallback ontap;
  String title;
  String imageAdd;
  double titleSize;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: ontap,
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
                  image: DecorationImage(
                      image: AssetImage(imageAdd), fit: BoxFit.cover)),
              height: MediaQuery.of(context).size.height * 0.12,
              width: MediaQuery.of(context).size.width * 0.25,
              alignment: Alignment.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
                fontFamily: 'JosefinSans',
                color: const Color.fromARGB(255, 78, 181, 131),
                fontSize: MediaQuery.of(context).size.height * titleSize),
          ),
        ),
      ],
    );
  }
}
