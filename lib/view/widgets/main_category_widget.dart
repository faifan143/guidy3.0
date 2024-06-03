import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guidy/controllers/main_screen_controller.dart';
import 'package:guidy/core/classes/AddType.dart';
import 'package:guidy/view/widgets/custom_popup_dialog.dart';
import 'package:iconly/iconly.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../core/constants/appTheme.dart';
import '../screens/main-screens/extras/in_category_screen.dart';

class MainCategoryWidget extends GetView<MainScreenController> {
  const MainCategoryWidget({
    super.key,
    required this.mainCategory,
    required this.colour,
  });

  final MapEntry<String, String> mainCategory;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    print(mainCategory);
    return Stack(
      children: [
        InkWell(
          onTap: () {
            Get.to(() => CategoryScreen(category: mainCategory.value));
          },
          child: Card(
            elevation: 20,
            shadowColor: colour,
            color: colour,
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      mainCategory.value,
                      textAlign: TextAlign.center,
                      style: englishTheme.textTheme.headline1!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (controller.isAdmin)
          Positioned(
            right: 5,
            top: 5,
            child: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => CustomPopupDialog(
                          label1: 'Main Category Name'.tr,
                          title1: 'Update Main Category'.tr,
                          addType: AddType.MAIN,
                          name: mainCategory.value,
                          onSubmit1: (p0) async {
                             controller.updateMainCategory( context : context,mainId: mainCategory.key, mainName: p0);
                          },
                        ));
              },
              child: Container(
                height: 40.h,
                width: 40.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withOpacity(0.4),
                ),
                child: const Icon(
                  IconlyBroken.edit_square,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        if (controller.isAdmin)
          Positioned(
            right: 5,
            top: 45,
            child: InkWell(
              onTap: () {
                Alert(
                  context: context,
                  type: AlertType.warning,
                  title: "Deletion".tr,
                  desc: "Do you want to delete it?".tr,
                  buttons: [
                    DialogButton(
                      onPressed: () async => await controller.deleteMain(context: context, mainId: mainCategory.key),
                      gradient: const LinearGradient(colors: [
                        Color.fromRGBO(0, 179, 134, 1.0),
                        Colors.greenAccent,
                      ]),
                      child: Text(
                        "Yes".tr,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 20),
                      ),
                    ),
                    DialogButton(
                      onPressed: () => Navigator.pop(context),
                      gradient: const LinearGradient(
                          colors: [Colors.pink, Colors.redAccent]),
                      child: Text(
                        "No".tr,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 20),
                      ),
                    )
                  ],
                ).show();
              },
              child: Container(
                height: 40.h,
                width: 40.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withOpacity(0.4),
                ),
                child: const Icon(
                  IconlyBroken.delete,
                  color: Colors.black,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
