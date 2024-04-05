import 'package:flutter/material.dart';

class Beakers extends StatefulWidget {
  const Beakers({
    super.key,
    required this.doubleconc,
    required this.index,
  });

  final String doubleconc;
  final int index;

  @override
  State<Beakers> createState() => _BeakersState();
}

class _BeakersState extends State<Beakers> {
  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
        color: Colors.white,
        fontFamily: 'JosefinSans',
        fontSize: MediaQuery.of(context).size.height * 0.017);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.25,
          height: MediaQuery.of(context).size.height * 0.1,
          decoration: BoxDecoration(
            border: Border.all(
                color: Colors.white, width: 3.0, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 23, 102, 65),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Beaker ${widget.index}",
                    style: textStyle.copyWith(
                        fontSize: MediaQuery.of(context).size.height * 0.015)),
                Text(
                  widget.doubleconc == ""
                      ? "... KΩ"
                      : '${widget.doubleconc} KΩ',
                  style: textStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
