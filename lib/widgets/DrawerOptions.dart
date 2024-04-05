import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DrawerOption extends StatelessWidget {
  DrawerOption(
      {super.key,
      required this.ontap,
      required this.title,
      required this.icon});
  VoidCallback ontap;
  String title;
  Icon icon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          Padding(padding: const EdgeInsets.all(18.0), child: icon),
          Expanded(
              child: Text(
            title,
            style: const TextStyle(
                color: Colors.black54, fontSize: 16, fontFamily: 'JosefinSans'),
          ))
        ]),
      ),
    );
  }
}
