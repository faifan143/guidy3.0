import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guidy/controllers/onBoardingController.dart';
import 'package:guidy/core/constants/AppColors.dart';
import 'package:guidy/model/onBoarding.dart';


class indicatorOB extends StatelessWidget {
  const indicatorOB({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingCtrl>(builder: (controller) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(
            onBoardingList.length,
            (index) => AnimatedContainer(
              margin: const EdgeInsets.only(right: 3),
              duration: const Duration(milliseconds: 600),
              width: controller.currentPage == index ? 20.w : 6.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ],
      );
    });
  }
}
