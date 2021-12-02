import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.indigo,
    accentColor: Colors.pink,
    scaffoldBackgroundColor: Color(0xfff1f1f1));

ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.indigo,
  accentColor: Colors.pink,
);

class ThemeNotifier extends ChangeNotifier {
  final String keyTheme = "theme";
  final String keyLanguage = "language";
  late bool _darkTheme;
  late bool _vnLanguage;

  bool get darkTheme => _darkTheme;

  bool get vnLanguage => _vnLanguage;

  ThemeNotifier() {
    _darkTheme = true;
    _vnLanguage = true;
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;
    notifyListeners();
    _saveToPrefs();
  }

  changeLanguage() {
    _vnLanguage = !_vnLanguage;
    notifyListeners();
    _saveToPrefs();
  }

  loadFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _darkTheme = prefs.getBool(keyTheme) ?? true;
    _vnLanguage = prefs.getBool(keyLanguage) ?? true;
    notifyListeners();
  }

  _saveToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(keyTheme, _darkTheme);
    prefs.setBool(keyLanguage, _vnLanguage);
  }
}
