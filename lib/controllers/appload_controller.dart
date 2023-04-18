import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppLoadController extends GetxController {
  static AppLoadController? _instance;

  static AppLoadController getInstance() {
    _instance ??= AppLoadController();
    return _instance!;
  }

  Color themeColor = const Color(0xFFFFC93C);
  String fcmToken = "";

}