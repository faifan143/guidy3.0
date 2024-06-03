import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guidy/controllers/main_screen_controller.dart';
import 'package:guidy/core/classes/FilterType.dart';
import 'package:guidy/core/constants/AppColors.dart';
import 'package:guidy/core/constants/appTheme.dart';
import 'package:guidy/view/widgets/custom_offer.dart';
import 'package:guidy/view/widgets/custom_shop.dart';
import 'package:iconly/iconly.dart';

import '../../../model/offer_model.dart';
import '../../../model/shop_model.dart';

class HomeScreen extends GetView<MainScreenController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MainScreenController());
    return GetBuilder<MainScreenController>(builder: (controller) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                      "Offers".tr,
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
            FutureBuilder<List<OfferModel>>(
                future: controller.getShopOffers(
                    shopId: "*",
                    token:
                        controller.myServices.sharedPref.getString("token")!),
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
                    final List<OfferModel> offers = snapshot.data!;
                    return offers.isNotEmpty
                        ? SizedBox(
                            height: 300.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: offers.length,
                              itemBuilder: (context, index) {
                                final OfferModel offer = offers[index];
                                return SizedBox(
                                  width: 380.w,
                                  child: CustomOfferWidget(
                                    offerModel: offer,
                                  ),
                                );
                              },
                            ),
                          )
                        : SizedBox(
                            height: 150.h,
                            child: Center(
                              child: Text("No Offers Available".tr,
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.5))),
                            ),
                          );
                  }
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Card(
                  elevation: 5,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      "All Shops".tr,
                      style: englishTheme.textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.gradientDarkColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 15),
                  child: CustomDropdownButton2(
                    buttonWidth: 30,
                    buttonHeight: 30,
                    buttonPadding: EdgeInsets.zero,
                    iconSize: 30,
                    buttonDecoration: const BoxDecoration(
                        border: Border.fromBorderSide(BorderSide.none)),
                    icon: const Icon(IconlyBroken.more_square),
                    dropdownItems:  [
                      'Default'.tr,
                      'Nearest'.tr,
                      'Highly Rated'.tr,
                      'Cheapest'.tr
                    ],
                    value: controller.selectedValue,
                    onChanged: (val) => controller.changeFilterMode(val!),
                    hint: '',
                  ),
                ),
              ],
            ),
            FutureBuilder<List<ShopModel>>(
              future: controller.filteringMode == FilterType.NEAR
                  ? controller.fetchNearestShops()
                  : controller.filteringMode == FilterType.CHEAP
                      ? controller.fetchCheapestShops()
                      : controller.filteringMode == FilterType.RATE
                          ? controller.fetchShopsByOverallRating()
                          : controller.getShopPhonePairs(),
              builder: (context, snapshot) {
                print(controller.filteringMode);
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  final List<ShopModel> shops = snapshot.data!;
                  return shops.isNotEmpty
                      ? SizedBox(
                          height: 350.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: shops.length,
                            itemBuilder: (BuildContext context, int index) {
                              ShopModel shopModel = shops[index];

                              return SizedBox(
                                  width: 340.w,
                                  child: CustomShopWidget(
                                    shopModel: shopModel,
                                    isProfile: false,
                                  ));
                            },
                          ),
                        )
                      : SizedBox(
                          height: 300.h,
                          child: Center(
                            child: Text("No Shops Available".tr,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.5))),
                          ));
                }
              },
            ),
            SizedBox(
              height: 100.h,
            ),
          ],
        ),
      );
    });
  }
}
