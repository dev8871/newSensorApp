import 'package:esp32sensor/authentication/authenticate.dart';
import 'package:esp32sensor/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/appUser.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<appUser>(context);
    // return either home or authenticate widget
    if (user.uid == '') {
      return const Authenticate();
    } else {
      return const Homepage();
    }
  }
}
