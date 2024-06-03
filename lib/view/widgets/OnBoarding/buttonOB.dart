import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guidy/controllers/onBoardingController.dart';
import 'package:guidy/core/constants/AppColors.dart';
import 'package:guidy/core/constants/appTheme.dart';
import 'package:guidy/core/localization/changeLocale.dart';


class ButtonOB extends GetView<OnBoardingCtrl> {
  const ButtonOB({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.primaryColor,
      ),
      child: MaterialButton(
        padding: const EdgeInsets.symmetric(horizontal: 100),
        onPressed: () {
          controller.next();
        },
        child: GetBuilder<LocaleController>(builder: (controller2) {
          return Text(
            "continue".tr,
            style: controller2.myServices.sharedPref.getString("lang") == "ar"
                ? arabicTheme.textTheme.bodyText1!.copyWith(color: Colors.white)
                : englishTheme.textTheme.bodyText1!
                    .copyWith(color: Colors.white),
          );
        }),
      ),
    );
  }
}
