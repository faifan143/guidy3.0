import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guidy/core/classes/AddType.dart';
import 'package:guidy/core/functions/signupSuccessful.dart';
import 'package:guidy/main.dart';
import 'package:guidy/view/screens/main-screens/shop_screens/add_shop.dart';
import 'package:guidy/view/widgets/custom_popup_dialog.dart';

import '../../controllers/main_screen_controller.dart';
import '../../view/screens/main-screens/shop_screens/add_offer.dart';

void showContextMenu(BuildContext context, Offset globalPosition) {
  MainScreenController mainScreenController = Get.put(MainScreenController());
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context); // Close the context menu
            showDialog(
              context: context,
              builder: (BuildContext context) => CustomPopupDialog(
                title1: "Insert a new main category".tr,
                label1: "Main-Category".tr,
                onSubmit1: (value) {
                   mainScreenController.addMainCat(context, value);
                }, addType: AddType.MAIN,
              ),
            );
          },
          child: Text('Add Main Category'.tr),
        ),

        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context); // Close the context menu
            showDialog(
                context: context,
                builder: (context) => CustomPopupDialog(
                    label1: "Subcategory".tr,
                    title1: "Insert a new subcategory".tr,
                    onSubmit1: (value) {
                      mainScreenController.addSubcat(context, value);
                    }, addType: AddType.SUB,));
          },
          child: Text('Add Subcategory'.tr),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context); //
            Get.to(()=>AddShopScreen());
          },
          child: Text('Add Shop'.tr),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            Get.to(()=>AddOfferScreen());
            },
          child: Text('Add Offer'.tr),
        ),
        // Add more actions as needed
      ],
    ),
  );
}
