import 'package:flutter/material.dart';

class AppController extends ChangeNotifier {
  bool isDarkTheme = false;

  static var instance;

  void toggleTheme() {
    isDarkTheme = !isDarkTheme;
    notifyListeners();
  }
}
