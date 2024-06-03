import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shaky_animated_listview/widgets/animated_gridview.dart';
import 'dart:math' as math;
import '../../../controllers/main_screen_controller.dart';
import '../../../core/constants/AppColors.dart';
import '../../../core/constants/appTheme.dart';
import '../../widgets/main_category_widget.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MainScreenController());
    return GetBuilder<MainScreenController>(builder: (controller) {
      return ListView(
        children: [
          Row(
            children: [
              Card(
                elevation: 5,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    "Main Categories".tr,
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
          SizedBox(
            height: 10.h,
          ),
          controller.mainCategories.entries.isNotEmpty ?
          AnimatedGridView(
            shrinkWrap: true,
            duration: 100,
            crossAxisCount: 2,
            mainAxisExtent: 256,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            children: [
              ...controller.mainCategories.entries
                  .map(
                    (mainCategory) => MainCategoryWidget(
                      mainCategory: mainCategory,
                      colour:
                          Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                              .withOpacity(1.0),
                    ),
                  )
                  .toList(),
            ],
          ):Container(
              margin: EdgeInsets.only(top: MediaQuery.sizeOf(context).height/3),
              child: Center(child: Text("No Main Categories".tr,style: TextStyle(color: Colors.black.withOpacity(0.5)),))),
           SizedBox(
            height: 100.h,
          ),
        ],
      );
    });
  }
}
