import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_theme/local_string.dart';
import 'package:test_theme/theme_provider.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          return GetMaterialApp(
            locale: notifier.vnLanguage == true
                ? const Locale('vi', 'VN')
                : const Locale('en', 'US'),
            translations: LocalString(),
            theme: notifier.darkTheme ? ThemeData.dark() : ThemeData.light(),
            home: const SettingsPage(),
          );
        },
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPage createState() => _SettingsPage();
}

String? _imagePath;

class _SettingsPage extends State<SettingsPage> {
  ThemeNotifier themeNotifier = ThemeNotifier();
  File? _image;

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('change_language'.tr),
        ),
        drawer: Drawer(
            child: ListView(
          children: [
            ListTile(
                title: Text(
                  'change_bg'.tr,
                  style: const TextStyle(fontSize: 18),
                ),
                onTap: () {
                  pickImage();
                }),
            Consumer<ThemeNotifier>(
              builder: (context, notifier, child) => ListTile(
                title: Row(
                  children: [
                    Text(
                      'change_mode'.tr,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const Spacer(),
                    Switch(
                      onChanged: (value) {
                        notifier.toggleTheme();
                      },
                      value: notifier.darkTheme,
                    ),
                  ],
                ),
              ),
            ),
            Consumer<ThemeNotifier>(
                builder: (context, notifier, child) => ListTile(
                      title: Row(
                        children: [
                          Text(
                            'change_language'.tr,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const Spacer(),
                          GestureDetector(
                            child: Container(
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: notifier.vnLanguage == false
                                  ? Image.asset(
                                      'assets/flat_vn.png',
                                    )
                                  : Image.asset(
                                      'assets/flat_en.png',
                                    ),
                            ),
                            onTap: () {
                              notifier.changeLanguage();
                              if (notifier.vnLanguage == true) {
                                Get.updateLocale(const Locale('vi', 'VN'));
                              } else {
                                Get.updateLocale(const Locale('en', 'US'));
                              }
                            },
                          )
                        ],
                      ),
                    ))
          ],
        )),
        body: Container(
          decoration: BoxDecoration(
              image: _imagePath != null
                  ? DecorationImage(
                      image: FileImage(
                        File(_imagePath!),
                      ),
                      fit: BoxFit.fill)
                  : null),
        ));
  }

  void pickImage() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
      _imagePath = _image!.path;
    });
    saveImage(_image!.path);
  }

  void saveImage(path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("save", path);
  }

  void loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _imagePath = prefs.getString("save")!;
    });
  }
}
