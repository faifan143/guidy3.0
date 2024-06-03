import 'dart:typed_data';
import 'dart:math' as math;
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guidy/controllers/main_screen_controller.dart';
import 'package:guidy/model/shop_model.dart';
import 'package:guidy/view/screens/main-screens/extras/evaluates_screen.dart';
import 'package:guidy/view/screens/main-screens/extras/show_shop_offers.dart';
import 'package:guidy/view/screens/main-screens/shop_screens/update_shop.dart';
import 'package:guidy/view/widgets/reusable_button.dart';
import 'package:iconly/iconly.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../core/constants/AppColors.dart';
import '../../core/functions/signupSuccessful.dart';
import '../screens/main-screens/extras/ShowOnMapScreen.dart';
import 'custom_evaluate.dart';

class CustomShopWidget extends GetView<MainScreenController> {
  CustomShopWidget(
      {super.key, required this.shopModel, required this.isProfile});
  final ShopModel shopModel;
  bool isProfile = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: loadShopPicture(), // Call the asynchronous function
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child:
                  CircularProgressIndicator()); // Show loading indicator while waiting for the image
        } else if (snapshot.hasError) {
          return Text(
              'Error: ${snapshot.error}'); // Show error message if loading fails
        } else {
          return buildCardWithImage(
              imageData: snapshot.data,
              context: context); // Build the card with the loaded image
        }
      },
    );
  }

  Future<Uint8List?> loadShopPicture() async {

    return await controller.loadPicture(shopModel.shop_photos[math.Random()
        .nextInt(
            shopModel.shop_photos.length)]); // Load shop picture asynchronously
  }

  Widget buildCardWithImage(
      {required Uint8List? imageData, required BuildContext context}) {
    Get.put(MainScreenController());
    return GetBuilder<MainScreenController>(builder: (controller) {
      return Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
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
              Stack(
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(() => EvaluatesScreen(shopId: shopModel.shop_id,));
                    },
                    child: Container(
                      width: double.infinity,
                      height: 120.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: MemoryImage(imageData!), fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  if (!isProfile) ...[
                    Positioned(
                      height: 30.h,
                      width: shopModel.shop_rating == "1"
                          ? 28.w
                          : (shopModel.shop_rating == "2"
                              ? 42.w
                              : (shopModel.shop_rating == "3"
                                  ? 60.w
                                  : (shopModel.shop_rating == "4"
                                      ? 75.w
                                      : 90.w))),
                      top: 5,
                      left: 7,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20)),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: int.parse(shopModel.shop_rating),
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ),
                    if (!controller.isAdmin)
                      Positioned(
                        right: 5,
                        top: 5,
                        child: InkWell(
                          onTap: () async {
                            if (!controller
                                .isShopIdInFollowings(shopModel.shop_id)) {
                              bool isAdded = await controller.addFollow(
                                  context: context, shopId: shopModel.shop_id);
                              if (isAdded) {
                                await controller.fetchFollowings();
                                snackBar(
                                    context: context,
                                    contentType: ContentType.success,
                                    title: "Done...".tr,
                                    body: "Shop Added to Your Followings".tr);
                              } else {
                                snackBar(
                                    context: context,
                                    contentType: ContentType.failure,
                                    title: "Failed...".tr,
                                    body: "Shop Add to Followings Failed".tr);
                              }
                            }
                          },
                          child: Container(
                            height: 40.h,
                            width: 40.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white.withOpacity(0.4),
                            ),
                            child: controller
                                    .isShopIdInFollowings(shopModel.shop_id)
                                ? const Icon(
                                    IconlyBroken.tick_square,
                                    color: Colors.black,
                                  )
                                : const Icon(
                                    IconlyBroken.add_user,
                                    color: Colors.black,
                                  ),
                          ),
                        ),
                      ),
                    if (controller.isAdmin) ...[
                      Positioned(
                        right: 5,
                        top: 5,
                        child: InkWell(
                          onTap: () {
                            Get.to(
                                () => UpdateShopScreen(shopModel: shopModel));
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
                                  onPressed: () async =>
                                      await controller.deleteShop(
                                          context: context,
                                          shopId: shopModel.shop_id),
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
                  ],
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
              Column(
                children: [
                  InkWell(
                    onTap: () => Get.to(()=>EvaluatesScreen(shopId: shopModel.shop_id,)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 10.w,
                            ),
                            const Icon(
                              IconlyBroken.home,
                              size: 15,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              shopModel.shop_name,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 10.w,
                            ),
                            const Icon(
                              IconlyBroken.location,
                              size: 15,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              shopModel.shop_address,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 10.w,
                            ),
                            const Icon(
                              IconlyBroken.call,
                              size: 15,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              shopModel.shop_phone,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Column(
                    children: [
                      ReUsableButton(
                        fontSize: 12,
                        height: 10.h,
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.gradientDarkColor,
                            AppColors.gradientLightColor,
                          ],
                        ),
                        radius: 10,
                        text: "Show On Map".tr,
                        onPressed: () {
                          Get.to(() => GoogleMapScreen(shopModel: shopModel));
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ReUsableButton(
                              fontSize: 12,
                              height: 10.h,
                              colour: AppColors.gradientDarkColor,
                              radius: 10,
                              text: "Offers".tr,
                              onPressed: () {
                                Get.to(() => ShowShopOffers(
                                    shopId: shopModel.shop_id.toString()));
                              },
                            ),
                          ),
                          if (!controller.isAdmin)
                            SizedBox(
                              width: 5.w,
                            ),
                          if (!controller.isAdmin)
                            Expanded(
                              child: ReUsableButton(
                                fontSize: 12,
                                height: 10.h,
                                colour: AppColors.gradientLightColor,
                                radius: 10,
                                text: "Evaluate".tr,
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) =>
                                          CustomEvaluateWidget(
                                              shopModel: shopModel));
                                },
                              ),
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
