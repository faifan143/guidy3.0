import 'dart:typed_data';
import 'dart:math' as math;
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guidy/controllers/main_screen_controller.dart';
import 'package:guidy/core/functions/signupSuccessful.dart';
import 'package:guidy/model/offer_model.dart';
import 'package:guidy/view/screens/main-screens/shop_screens/update_offer.dart';
import 'package:guidy/view/widgets/reusable_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:iconly/iconly.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:io';

import '../../core/constants/AppColors.dart';

class CustomOfferWidget extends GetView<MainScreenController> {
  const CustomOfferWidget(
      {Key? key, required this.offerModel})
      : super(key: key);
  final OfferModel offerModel;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: loadShopPicture(), // Call the asynchronous function
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child:
                  CircularProgressIndicator());
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
    return await controller.loadPicture(offerModel.offerPhotos[math.Random()
        .nextInt(offerModel
            .offerPhotos.length)]); // Load offer picture asynchronously
  }

  Widget buildCardWithImage(
      {required Uint8List? imageData, required BuildContext context}) {
    Get.put(MainScreenController());
    return GetBuilder<MainScreenController>(builder: (controller) {
      print(offerModel.offerId);
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
                  Container(
                    width: double.infinity,
                    height: 150.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          image: MemoryImage(imageData!), fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                      top: 5,
                      left: 5,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          "${"Days Left".tr} : ${offerModel.getDaysDifference()}",
                          style: const TextStyle(color: Colors.black),
                        ),
                      )),
                  if (controller.isAdmin)
                    Positioned(
                      right: 5,
                      top: 5,
                      child: InkWell(
                        onTap: () {
                          Get.to(()=>UpdateOfferScreen(offerModel: offerModel));
                        },
                        child: Container(
                          height: 40.h,
                          width: 40.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white.withOpacity(0.4),
                          ),
                          child:const Icon(
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
                                onPressed: () async =>  await controller.deleteOffer(context: context, offerId: offerModel.offerId),
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
                          child:const Icon(
                            IconlyBroken.delete,
                            color: Colors.black,
                          ),
                        ),
                      ),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offerModel.offerName,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Text(
                      offerModel.description,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Expanded(
                    child: ReUsableButton(
                      colour: AppColors.gradientDarkColor,
                      height: 10.h,
                      radius: 10,
                      text: "Show Photos".tr,
                      onPressed: () async {
                        List<String> imageFilePaths = offerModel.offerPhotos;

                        List<Uint8List?> imageBytesList = [];
                        for (String filePath in imageFilePaths) {
                          Uint8List? bytes =
                              await controller.loadPicture(filePath);
                          imageBytesList.add(bytes);
                        }
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: CarouselSlider(
                                options: CarouselOptions(
                                  aspectRatio: 16 / 16,
                                  enlargeCenterPage: true,
                                  autoPlay: true,
                                ),
                                items: imageBytesList.map((bytes) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: bytes != null
                                            ? Image.memory(
                                                bytes,
                                                fit: BoxFit.cover,
                                              )
                                            :  Center(
                                                child: Text(
                                                    'Failed to load image'.tr),
                                              ),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        );
                      },
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  if(!controller.isAdmin)
                    Expanded(
                    child: ReUsableButton(
                      colour: AppColors.gradientLightColor,
                      height: 10.h,
                      radius: 10,
                      text: controller.isOfferIdInFavorites(offerModel.offerId)
                          ? "In Favorites".tr
                          : "Add To Favorites".tr,
                      onPressed: () async {
                        if (!controller
                            .isOfferIdInFavorites(offerModel.offerId)) {
                          bool isAdded = await controller.addFavorite(
                              context: context, offerId: offerModel.offerId);
                          if (isAdded) {
                            await controller.fetchFavorite();
                            snackBar(
                                context: context,
                                contentType: ContentType.success,
                                title: "Done...".tr,
                                body: "Offer Added to Your Favorites".tr);
                          } else {
                            snackBar(
                                context: context,
                                contentType: ContentType.failure,
                                title: "Failed...".tr,
                                body: "Offer Add to Favorites Failed".tr);
                          }
                        }
                      },
                      fontSize: 10,
                    ),
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
