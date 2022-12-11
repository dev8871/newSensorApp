import 'package:esp32sensor/languages/LocalString.dart';
import 'package:esp32sensor/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'languages/LocalString.dart';

void main() {
  runApp(GetMaterialApp(
      translations: LocalString(),
      locale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      home: Homepage()));
}
