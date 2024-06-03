import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guidy/controllers/onBoardingController.dart';
import 'package:guidy/core/constants/AppColors.dart';
import 'package:guidy/core/constants/appTheme.dart';
import 'package:guidy/core/localization/changeLocale.dart';



class skipButtonOB extends StatelessWidget {
  const skipButtonOB({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final OnBoardingCtrl controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          controller.skip();
        },
        child: GetBuilder<LocaleController>(builder: (controller2) {
          return Text(
            "skip".tr,
            style: controller2.myServices.sharedPref.getString("lang") == "ar"
                ? arabicTheme.textTheme.bodyText1!.copyWith(
                    color: AppColors.primaryColor, fontWeight: FontWeight.w400)
                : englishTheme.textTheme.bodyText1!.copyWith(
                    color: AppColors.primaryColor, fontWeight: FontWeight.w400),
          );
        }),
      ),
    );
  }
}
