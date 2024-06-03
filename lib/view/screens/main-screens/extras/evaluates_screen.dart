import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guidy/controllers/main_screen_controller.dart';
import 'package:guidy/model/evaluate_model.dart';
import 'package:guidy/view/widgets/custom_evaluation.dart';

import '../../../../core/constants/AppColors.dart';
import '../../../../core/constants/appTheme.dart';

class EvaluatesScreen extends GetView<MainScreenController> {
  const EvaluatesScreen( {required this.shopId,super.key});
final String shopId;
  @override
  Widget build(BuildContext context) {
    Get.put(MainScreenController());
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: ListView(
            children: [
              Row(
                children: [
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text(
                        "Evaluations".tr,
                        style: englishTheme.textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.gradientDarkColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              FutureBuilder<List<EvaluateModel>>(
                future: controller.getEvaluations(shopId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    final List<EvaluateModel> evaluations = snapshot.data!;
                    return evaluations.isNotEmpty ? SizedBox(
                      height: 790.h,
                      child: ListView.separated(
                          itemCount: evaluations.length,
                          separatorBuilder: (context, index) => SizedBox(height: 20.h),
                          itemBuilder: (context, index) => CustomEvaluationWidget(evaluationModel: evaluations[index]),
                      ),
                    ):SizedBox(
                      height: MediaQuery.sizeOf(context).height/2,
                      child:  Center(
                        child: Text("No Evaluations".tr , style: TextStyle(color: Colors.black.withOpacity(0.5))),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
