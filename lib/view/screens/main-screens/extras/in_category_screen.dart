import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guidy/model/shop_model.dart';
import 'package:iconly/iconly.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../../controllers/main_screen_controller.dart';
import '../../../../core/classes/AddType.dart';
import '../../../../core/constants/AppColors.dart';
import '../../../../core/constants/appTheme.dart';
import '../../../widgets/custom_popup_dialog.dart';
import '../../../widgets/custom_shop.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key, required this.category}) : super(key: key);
  final String category;

  @override
  Widget build(BuildContext context) {
    Get.put(MainScreenController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GetBuilder<MainScreenController>(
          builder: (controller) {
            List<dynamic> subCategories =
                controller.formattedCategories[category] ?? [];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    if (subCategories.isEmpty || subCategories[0] == 'null')
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: MediaQuery.sizeOf(context).height / 2.6),
                        child: Center(
                          child: Text(
                            "No Subcategories".tr,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    if (subCategories.isNotEmpty && subCategories[0] != 'null')
                      for (int i = 0; i < subCategories.length; i++) ...[
                        if (controller.subShopsMap[subCategories[i]] != null)
                          Column(
                            children: [
                              Row(
                                children: [
                                  Card(
                                    elevation: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Text(
                                        "${subCategories[i]}".tr,
                                        style: englishTheme.textTheme.bodyText1!
                                            .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.gradientDarkColor,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),

                                  if(controller.isAdmin)
                                  SizedBox(width: 5.w),
                                  if(controller.isAdmin)
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              CustomPopupDialog(
                                                label1: 'Subcategory Name'.tr,
                                                title1: 'Update Subcategory'.tr,
                                                addType: AddType.MAIN,
                                                name: subCategories[i],
                                                onSubmit1: (p0) async {
                                                  controller.updateSubcategory(
                                                      context: context,
                                                      subId: controller
                                                          .subcategories.keys
                                                          .firstWhere((id) =>
                                                              controller
                                                                      .subcategories[
                                                                  id] ==
                                                              subCategories[i]),
                                                      subName: p0);
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
                                  if(controller.isAdmin)
                                  SizedBox(width: 5.w),
                                  if(controller.isAdmin)
                                  InkWell(
                                    onTap: () {
                                      Alert(
                                        context: context,
                                        type: AlertType.warning,
                                        title: "Deletion".tr,
                                        desc: "Do you want to delete it?".tr,
                                        buttons: [
                                          DialogButton(
                                            onPressed: () async =>
                                                await controller.deleteSub(
                                                    context: context,
                                                    subId: controller
                                                        .subcategories.keys
                                                        .firstWhere((id) =>
                                                            controller
                                                                    .subcategories[
                                                                id] ==
                                                            subCategories[i])),
                                            gradient:
                                                const LinearGradient(colors: [
                                              Color.fromRGBO(0, 179, 134, 1.0),
                                              Colors.greenAccent,
                                            ]),
                                            child: Text(
                                              "Yes".tr,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                          ),
                                          DialogButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            gradient: const LinearGradient(
                                                colors: [
                                                  Colors.pink,
                                                  Colors.redAccent
                                                ]),
                                            child: Text(
                                              "No".tr,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
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
                                ],
                              ),
                              SizedBox(
                                height: 350.h,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: controller
                                              .subShopsMap[subCategories[i]] !=
                                          null
                                      ? controller
                                          .subShopsMap[subCategories[i]].length
                                      : 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (controller
                                            .subShopsMap[subCategories[i]] !=
                                        null) {
                                      final shops = controller
                                          .subShopsMap[subCategories[i]];
                                      ShopModel shopModel =
                                          ShopModel.fromJson(shops[index]);
                                      return SizedBox(
                                          width: 340.w,
                                          child: CustomShopWidget(
                                            shopModel: shopModel,
                                            isProfile: false,
                                          ));
                                    } else {
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal:
                                                MediaQuery.sizeOf(context)
                                                        .width /
                                                    2.6),
                                        child: Center(
                                          child: Text("No Shops".tr,
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.5))),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                      ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ShopDetailsWidget extends StatelessWidget {
  final String subcategory;
  final List<Map<String, dynamic>> shops;

  const ShopDetailsWidget({
    Key? key,
    required this.subcategory,
    required this.shops,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subcategory: $subcategory',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: shops.length,
            itemBuilder: (context, index) {
              final shop = shops[index];
              return ListTile(
                title: Text(shop['shop_name'] ?? ''),
                subtitle: Text('Phone: ${shop['shop_phone']}'),
                trailing: Text('Rating: ${shop['shop_rating']}'),
                onTap: () {
                  // Handle onTap event if needed
                },
              );
            },
          ),
        ),
        const Divider(), // Optional: Add a divider between subcategories
      ],
    );
  }
}
