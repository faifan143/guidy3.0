import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:guidy/core/constants/AppRoutes.dart';
import 'package:guidy/core/services/sharedPreferences.dart';



class MyOnBoardingMiddleware extends GetMiddleware {
  @override
  int? get priority => 2;
  MyServices myServices = Get.find();
  @override
  RouteSettings? redirect(String? route) {
    if (myServices.sharedPref.getString("onBoarded") == "1") {
      return const RouteSettings(name: AppRoutes.login);
    }
  }
}

class MyLoginMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;
  MyServices myServices = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    if (myServices.sharedPref.getString("logged") == "1") {
      return const RouteSettings(name: AppRoutes.mainScreen);
    }
  }
}

