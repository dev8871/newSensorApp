import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 236, 236, 235),
      child: const Center(
          child: SpinKitChasingDots(
        color: Color.fromARGB(255, 68, 158, 115),
        size: 75.0,
      )),
    );
  }
}
