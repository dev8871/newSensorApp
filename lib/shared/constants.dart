import 'package:flutter/material.dart';

var textInputDecoration = InputDecoration(
    labelStyle: const TextStyle(
        fontFamily: 'JosefinSans', color: Color.fromARGB(255, 68, 158, 115)),
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Colors.white, width: 2.0)),
    focusedBorder: const OutlineInputBorder(
        borderSide:
            BorderSide(color: Color.fromARGB(255, 68, 158, 115), width: 2.0)));

Widget menuItem(String title, IconData menuIcon, Function ontap) {
  return Material(
    child: InkWell(
      onTap: ontap(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          Padding(
              padding: const EdgeInsets.all(18.0),
              child: Icon(
                menuIcon,
                size: 25.0,
                color: Colors.black54,
              )),
          Expanded(
              child: Text(
            title,
            style: const TextStyle(
                color: Colors.black54, fontSize: 16, fontFamily: 'JosefinSans'),
          ))
        ]),
      ),
    ),
  );
}
