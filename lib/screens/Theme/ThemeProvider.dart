// ignore_for_file: file_names, unnecessary_import

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasktroveprojects/screens/Theme/DarkMode.dart';
import 'package:tasktroveprojects/screens/Theme/LightMode.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = LightMode;
  final String _themePreferenceKey = 'themePreference';

  ThemeProvider() {
    _loadTheme();
  }

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == DarkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    _saveTheme(themeData);
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == LightMode) {
      themeData = DarkMode;
    } else {
      themeData = LightMode;
    }
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool(_themePreferenceKey) ?? false;
    themeData = isDarkMode ? DarkMode : LightMode;
  }

  Future<void> _saveTheme(ThemeData themeData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = themeData == DarkMode;
    await prefs.setBool(_themePreferenceKey, isDarkMode);
  }
}