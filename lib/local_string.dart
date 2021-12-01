import 'package:get/get.dart';

class LocalString extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'theme': 'Theme',
          'change_language': 'Change Language',
          'change_bg': 'Change background',
          'change_mode': 'Change Mode',
        },
        'vi_VN': {
          'theme': 'Chế độ',
          'change_language': 'Thay đổi ngôn ngữ',
          'change_bg': 'Thay đổi hình nền',
          'change_mode': 'Thay đổi chế độ'
        }
      };
}
