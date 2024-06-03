import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guidy/controllers/onBoardingController.dart';
import 'package:guidy/view/widgets/OnBoarding/buttonOB.dart';
import 'package:guidy/view/widgets/OnBoarding/indicatorOB.dart';
import 'package:guidy/view/widgets/OnBoarding/skipButtonOB.dart';
import 'package:guidy/view/widgets/OnBoarding/sliderOB.dart';


class OnBoarding extends StatelessWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OnBoardingCtrl controller = Get.put(OnBoardingCtrl());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          skipButtonOB(controller: controller),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 40.h),
            const Expanded(
              flex: 3,
              child: SliderOB(),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  const indicatorOB(),
                  const Spacer(flex: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      const ButtonOB(),
                      SizedBox(width: 0.w),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
