import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:guidy/core/services/sharedPreferences.dart';
import 'package:guidy/model/onBoarding.dart';

import '../core/constants/AppRoutes.dart';


abstract class OnBoardingController extends GetxController {
  next();
  onPageChanged(int index);
  skip();
}

class OnBoardingCtrl extends OnBoardingController {
  int currentPage = 0;
  late PageController pageController;
  MyServices myServices = Get.find();

  @override
  void onInit() {
    pageController = PageController();
    super.onInit();
  }

  @override
  skip() {
    currentPage = onBoardingList.length - 1;
    pageController.animateToPage(
      currentPage,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
    myServices.sharedPref.setString("onBoarded", "1");
    update();
  }

  @override
  next() {
    currentPage++;
    if (currentPage > onBoardingList.length - 1) {
      myServices.sharedPref.setString("onBoarded", "1");
      Get.offAllNamed(AppRoutes.login);
    } else {
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  onPageChanged(int index) {
    currentPage = index;
    update();
  }
}
