import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guidy/core/constants/appTheme.dart';
import 'package:guidy/core/services/sharedPreferences.dart';

class LocaleController extends GetxController {
  Locale? language;
  MyServices myServices = Get.find();

  ThemeData appTheme = englishTheme;

  changeLocale(String langCode) {
    Locale locale = Locale(langCode);
    myServices.sharedPref.setString("lang", langCode);
    appTheme = langCode == "ar" ? arabicTheme : englishTheme;
    Get.changeTheme(appTheme);
    Get.updateLocale(locale);
  }

  @override
  void onInit() {
    if (myServices.sharedPref.getString("lang") == "ar") {
      language = Locale("ar");
      appTheme = arabicTheme;
    } else if (myServices.sharedPref.getString("lang") == "en") {
      language = Locale("en");
      appTheme = englishTheme;
    } else {
      language = Locale(Get.deviceLocale!.languageCode);
      appTheme = englishTheme;
    }
    super.onInit();
  }
}
