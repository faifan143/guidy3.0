import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guidy/controllers/onBoardingController.dart';
import 'package:guidy/core/constants/appTheme.dart';
import 'package:guidy/core/localization/changeLocale.dart';
import 'package:guidy/model/onBoarding.dart';



class SliderOB extends GetView<OnBoardingCtrl> {
  const SliderOB({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocaleController>(builder: (controller2) {
      return PageView.builder(
        onPageChanged: (value) => controller.onPageChanged(value),
        controller: controller.pageController,
        itemCount: onBoardingList.length,
        itemBuilder: (context, index) => Column(
          children: [
            Text(
              onBoardingList[index].title!,
              style: controller2.myServices.sharedPref.getString("lang") == "ar"
                  ? arabicTheme.textTheme.headline1
                  : englishTheme.textTheme.headline1,
            ),
            SizedBox(height: 30.h),
            Image.asset(
              onBoardingList[index].imgPath!,
              height: 280.h,
              width: 280.w,
            ),
            SizedBox(height: 50.h),
            Flexible(
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  onBoardingList[index].description!,
                  textAlign: TextAlign.center,
                  style:
                      controller2.myServices.sharedPref.getString("lang") == "ar"
                          ? arabicTheme.textTheme.bodyText2
                          : englishTheme.textTheme.bodyText2,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
