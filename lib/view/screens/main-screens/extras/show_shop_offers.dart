import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guidy/controllers/main_screen_controller.dart';
import 'package:guidy/model/offer_model.dart';
import 'package:guidy/view/widgets/custom_offer.dart';

import '../../../../core/constants/AppColors.dart';
import '../../../../core/constants/appTheme.dart';

class ShowShopOffers extends StatelessWidget {
  final String shopId;

  const ShowShopOffers({Key? key, required this.shopId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainScreenController controller = Get.put(MainScreenController());
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
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
                    shopId: shopId,
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
                    print(offers.map((e) => e.offerName).toList());
                    return offers.isNotEmpty
                        ? SizedBox(
                            height: 790.h,
                            child: ListView.separated(
                              itemCount: offers.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 20.h),
                              itemBuilder: (context, index) =>
                                  SizedBox(
                                    height: 300.h,
                                    child: CustomOfferWidget(
                                        offerModel: offers[index]),
                                  ),
                            ),
                          )
                        : SizedBox(
                            height: MediaQuery.sizeOf(context).height / 2,
                            child: Center(
                              child: Text("No Offers".tr,
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.5))),
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
//
// FutureBuilder<List<OfferModel>>(
// future: controller.getShopOffers(
// shopId: shopId,
// token: controller.myServices.sharedPref.getString("token")!),
// builder:(context, snapshot) {
// if (snapshot.connectionState == ConnectionState.waiting) {
// return const Center(
// child: CircularProgressIndicator(),
// );
// } else if (snapshot.hasError) {
// return Center(
// child: Text('Error: ${snapshot.error}'),
// );
// } else {
// final List<OfferModel> offers = snapshot.data!;
// return offers.isNotEmpty ? SizedBox(
// height: 790.h,
// child: ListView.separated(
// itemCount: offers.length,
// separatorBuilder: (context, index) => SizedBox(height: 20.h),
// itemBuilder: (context, index) => CustomOfferWidget(offerModel: offers[index]),
// ),
// ):SizedBox(
// height: MediaQuery.sizeOf(context).height/2,
// child: Center(
// child: Text("No Offers" , style: TextStyle(color: Colors.black.withOpacity(0.5))),
// ),
// );
// }
// },
