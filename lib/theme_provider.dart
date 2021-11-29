import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.indigo,
    accentColor: Colors.pink,
    scaffoldBackgroundColor: Color(0xfff1f1f1)
);

ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.indigo,
  accentColor: Colors.pink,
);

class ThemeNotifier extends ChangeNotifier{
  final String key = "theme";
  final String keyLanguage = "language";
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late bool _darkTheme;
  late bool _vnLanguage;
  bool get darkTheme => _darkTheme;
  bool get vnLanguage => _vnLanguage;

  ThemeNotifier() {
    _darkTheme = true;
    _vnLanguage = true;
    _loadFromPrefs();
  }

  toggleTheme(){
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  changeLanguage(){
    _vnLanguage = !_vnLanguage;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    SharedPreferences prefs = await _prefs;
    if(prefs == null)
      prefs  = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    SharedPreferences prefs = await _prefs;
    await _initPrefs();
    _darkTheme = prefs.getBool(key) ?? true;
    _vnLanguage = prefs.getBool(keyLanguage) ?? true;
    notifyListeners();
  }

  _saveToPrefs() async {
    SharedPreferences prefs = await _prefs;
    await _initPrefs();
    prefs.setBool(key, _darkTheme);
    prefs.setBool(keyLanguage, _vnLanguage);
  }
}