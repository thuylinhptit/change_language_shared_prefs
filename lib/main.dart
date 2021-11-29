
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_theme/local_string.dart';
import 'package:test_theme/shared_prefs.dart';
import 'package:test_theme/theme_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          print("check: ");
         // print(notifier.vnLanguage);
          print(notifier.darkTheme);
          return GetMaterialApp(
            locale: notifier.vnLanguage ?  Locale('vi','VN'):  Locale('en','US'),
            translations: LocalString(),
            theme: notifier.darkTheme ? ThemeData.dark() : ThemeData.light(),
            home: SettingsPage(),
          );
        },
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  ThemeNotifier themeNotifier = ThemeNotifier();
  File? imageFile;

  loadImageFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final imageKeyValue = prefs.getString(IMAGE_KEY);
    if (imageKeyValue != null) {
      final imageString = await ImageSharedPrefs.loadImageFromPrefs();
      setState(() {
        imageFile = ImageSharedPrefs.imageFrom64BaseString(imageString!);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadImageFromPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  Text('change_language'.tr),
        ),
        drawer: Drawer(
            child: ListView(
              children: [
                ListTile(
                    title:  Text('change_bg'.tr, style: const TextStyle( fontSize: 18),),
                    onTap:(){
                      _getFromGallery();
                    }
                ),
                Consumer<ThemeNotifier>(
                  builder:(context, notifier, child) =>
                      ListTile(
                        title: Row(
                          children: [
                            Text('change_mode'.tr, style: const TextStyle(  fontSize: 18),),
                            const Spacer(),
                            Switch(
                              onChanged:(value){
                                notifier.toggleTheme();
                                print(notifier.darkTheme);
                              },
                              value: notifier.darkTheme ,
                            ),
                          ],
                        ),
                      ),
                ),
                Consumer<ThemeNotifier>(
                    builder: (context,notifier, child) =>
                        ListTile(
                          title: Row(
                            children:  [
                              Text('change_language'.tr, style: const TextStyle(  fontSize: 18),),
                              const Spacer(),
                              GestureDetector(
                                child: Container(
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: notifier.vnLanguage == true ? Image.asset('assets/flat_vn.png',) : Image.asset('assets/flat_en.png',),
                                ),
                                onTap: (){
                                  notifier.changeLanguage();
                                  if( notifier.vnLanguage == true ){
                                    Get.updateLocale(const Locale('vi','VN'));
                                  }
                                  else{
                                    Get.updateLocale(const Locale('en','US'));
                                  }
                                },
                              )
                            ],
                          ),
                        )
                )
              ],
            )
        ),
        body: Container(
            child: imageFile == null
                ? Container(
            ): Image.file(
              imageFile!,
              fit: BoxFit.cover,
            )
        )
    );
  }
  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      ImageSharedPrefs.saveImageToPrefs(
          ImageSharedPrefs.base64String(imageFile!.readAsBytesSync()));
    }
  }
}