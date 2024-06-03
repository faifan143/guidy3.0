import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guidy/controllers/main_screen_controller.dart';
import 'package:guidy/model/evaluate_model.dart';
import 'package:iconly/iconly.dart';
import '../../core/constants/AppColors.dart';
import '../../core/constants/appTheme.dart';


class CustomEvaluationWidget extends GetView<MainScreenController> {
  CustomEvaluationWidget({super.key, required this.evaluationModel});
  final EvaluateModel evaluationModel;
  @override
  Widget build(BuildContext context) {
    Get.put(MainScreenController());
    return GetBuilder<MainScreenController>(builder: (controller) {
      return Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient:  LinearGradient(colors: [
              AppColors.gradientDarkColor.withOpacity(0.7),
              AppColors.gradientLightColor.withOpacity(0.7),
            ]),
            boxShadow: const [
              BoxShadow(
                offset: Offset(4, 1),
                blurRadius: 5,
                color: Colors.grey,
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      const Icon(
                        IconlyBroken.message,
                        size: 15,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        evaluationModel.custEmail,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      width: double.infinity,
                      height: 1.h,
                      color: Colors.grey[300],
                    ),
                  ),

                  Row(
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                              width: 300.w,
                              child: const Text("Prices Feedback :" , style: TextStyle(color: Colors.white),)),
                          Text(
                            evaluationModel.pricesFeedback,
                            style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                              width: 300.w,
                              child:  Text("Prices Rating :".tr , style: TextStyle(color: Colors.white),)),
                          Text(
                            evaluationModel.priceRating.toString(),
                            style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                              width: 300.w,
                              child:  Text("Products Quality Feedback :".tr, style: TextStyle(color: Colors.white),)),
                          Text(
                            evaluationModel.productsQualityFeedback,
                            style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.white),
                          ),
                        ],
                      ),

                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                              width: 300.w,
                              child: Text("Service Quality Feedback :".tr, style: TextStyle(color: Colors.white),)),
                          Text(
                            evaluationModel.serviceQualityFeedback,
                            style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                              width: 300.w,
                              child:  Text("Overall Rating :".tr, style: TextStyle(color: Colors.white),)),
                          Text(
                            evaluationModel.overallRating.toString(),
                            style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
