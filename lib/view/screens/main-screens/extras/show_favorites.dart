import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guidy/controllers/main_screen_controller.dart';
import 'package:guidy/view/widgets/custom_offer.dart';

import '../../../../core/constants/AppColors.dart';
import '../../../../core/constants/appTheme.dart';
import '../../../../model/offer_model.dart';

class ShowFavorites extends StatelessWidget {
  const ShowFavorites({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainScreenController>(
        init: MainScreenController(),
        builder: (controller) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
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
                          "Favorites".tr,
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
                  future: controller.fetchFavorites(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          "No Favorites".tr,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      );
                    } else {
                      final List<OfferModel> favorites = snapshot.data!;
                      return SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.8, // Example: 80% of available height
                        child: ListView.builder(
                          itemCount: favorites.length,
                          itemBuilder: (context, index) {
                            final offer = favorites[index];
                            return SizedBox(
                              height: 300.h,
                              child: CustomOfferWidget(
                                offerModel: offer,
                              ),
                            );
                          },
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
    });
  }
}
