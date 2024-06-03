import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guidy/core/constants/AppColors.dart';
import 'package:guidy/core/constants/AppRoutes.dart';
import 'package:guidy/view/screens/main-screens/extras/show_favorites.dart';
import 'package:guidy/view/screens/main-screens/extras/show_shop_offers.dart';
import 'package:guidy/view/widgets/custom_shop.dart';
import 'package:iconly/iconly.dart';
import 'package:restart_app/restart_app.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../../controllers/main_screen_controller.dart';
import '../../../core/classes/logo-painter.dart';
import '../../../core/constants/appTheme.dart';
import '../../../core/localization/changeLocale.dart';
import '../../../core/services/sharedPreferences.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MainScreenController());
    return GetBuilder<MainScreenController>(builder: (controller) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              SizedBox(
                height: 200.h,
                width: double.infinity,
                child: CustomPaint(
                  painter: LogoPainter(),
                  size: const Size(400, 195),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(65),
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(4, 4),
                            blurRadius: 5,
                            color: AppColors.gradientDarkColor,
                          )
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 65,
                        backgroundImage: MemoryImage(controller.myProfilePic!),
                      ),
                    ),
                  ),
                  const Spacer(flex: 1),
                  Column(
                    children: [
                      SizedBox(height: 15.h),
                      Row(
                        children: [
                          Row(
                            children: [
                              Text(
                                controller.myUser!.username,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(color: Colors.white),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              const Icon(
                                Icons.check_circle,
                                color: Colors.lightBlue,
                                size: 16,
                              )
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 10.w),
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                controller.myUser!.email!,
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${"Phone".tr} : 0${controller.myUser!.phone}",
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                      if (controller.myServices.sharedPref
                              .getString("isAdmin") ==
                          "false")
                        Text(
                          "     ${"Address".tr} : ${controller.myUser!.address}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.white),
                        ),
                    ],
                  ),
                  const Spacer(flex: 1),
                ],
              ),
            ]),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 20.h),
                  if (!controller.isAdmin)
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (controller.isAdmin) {
                                controller.changePage(3);
                              } else {
                                controller.changePage(3);
                              }
                            },
                            child: Card(
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              shadowColor: AppColors.gradientDarkColor,
                              color: AppColors.gradientDarkColor,
                              child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${"Following".tr} : ${controller.followings.length}",
                                        textAlign: TextAlign.center,
                                        style: englishTheme.textTheme.headline1!
                                            .copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Get.to(() => ShowFavorites());
                            },
                            child: Card(
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              shadowColor: AppColors.gradientLightColor,
                              color: AppColors.gradientLightColor,
                              child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${"Favorites".tr} : ${controller.favorites.length}",
                                        textAlign: TextAlign.center,
                                        style: englishTheme.textTheme.headline1!
                                            .copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (!controller.isAdmin)
                    SizedBox(
                      height: 20.h,
                    ),
                  if (!controller.isAdmin)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.gradientDarkColor,
                            AppColors.gradientLightColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(
                            15), // Same as the shape's borderRadius
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Recently Searched For :".tr,
                                textAlign: TextAlign.center,
                                style:
                                    englishTheme.textTheme.headline1!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              controller.recently_Searched != null
                                  ? SizedBox(
                                      width: 340.w,
                                      child: CustomShopWidget(
                                        shopModel:
                                            controller.recently_Searched!,
                                        isProfile: true,
                                      ))
                                  : SizedBox(
                                      height: 20.h,
                                      child: Text("No Recent Searches".tr,
                                          style: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(0.5))),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (!controller.isAdmin)
                    SizedBox(
                      height: 20.h,
                    ),
                  if (!controller.isAdmin)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.gradientDarkColor,
                            AppColors.gradientLightColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(
                            15), // Same as the shape's borderRadius
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Recently Evaluated :".tr,
                                textAlign: TextAlign.center,
                                style:
                                    englishTheme.textTheme.headline1!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              controller.recently_Evaluated != null
                                  ? SizedBox(
                                      width: 340.w,
                                      child: CustomShopWidget(
                                        shopModel:
                                            controller.recently_Evaluated!,
                                        isProfile: true,
                                      ))
                                  : SizedBox(
                                      height: 20.h,
                                      child: Text("No Recent Evaluations".tr,
                                          style: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(0.5))),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (!controller.isAdmin) SizedBox(height: 20.h),
                  InkWell(
                    onTap: () {
                      Alert(
                        context: context,
                        type: AlertType.warning,
                        title: "change language".tr,
                        desc: "Do you want to change the language?".tr,
                        buttons: [
                          DialogButton(
                            child: Text(
                              "Yes".tr,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () {
                              LocaleController locale =
                              Get.put(LocaleController());
                              locale.changeLocale(locale
                                  .myServices.sharedPref
                                  .getString("lang") ==
                                  "en"
                                  ? "ar"
                                  : "en");
                              Get.back();
                            },
                            gradient: LinearGradient(colors: [
                              Color.fromRGBO(0, 179, 134, 1.0),
                              Colors.greenAccent,
                            ]),
                          ),
                          DialogButton(
                            child: Text(
                              "No".tr,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () => Navigator.pop(context),
                            gradient: LinearGradient(
                                colors: [Colors.pink, Colors.redAccent]),
                          )
                        ],
                      ).show();
                    },
                    child: Card(
                      elevation: 20,
                      shadowColor: AppColors.gradientDarkColor,
                      color: AppColors.gradientDarkColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            15), // Adjust the radius as needed
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.gradientDarkColor,
                              AppColors.gradientLightColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(
                              15), // Same as the shape's borderRadius
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Change Language".tr,
                                textAlign: TextAlign.center,
                                style:
                                    englishTheme.textTheme.headline1!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  InkWell(
                    onTap: () {
                      Alert(
                        context: context,
                        type: AlertType.warning,
                        title: "Sign out".tr,
                        desc: "Do you want to Sign out?".tr,
                        buttons: [
                          DialogButton(
                            onPressed: ()  {
                              MyServices myServices = Get.find();
                              myServices.sharedPref.setString("logged", "0");
                              myServices.sharedPref.setString("token", "");
                              myServices.sharedPref.setString("user_model", "");
                              myServices.sharedPref
                                  .setString("recently_evaluated", "");
                              myServices.sharedPref
                                  .setString("recently_searched", "");
                              Get.offAllNamed(AppRoutes.login);
                            },
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
                    child: Card(
                      elevation: 20,
                      shadowColor: AppColors.gradientDarkColor,
                      color: AppColors.gradientDarkColor,
                      // Set the color to transparent
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            15), // Adjust the radius as needed
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.gradientDarkColor,
                              AppColors.gradientLightColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(
                              15), // Same as the shape's borderRadius
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Sign Out".tr,
                                textAlign: TextAlign.center,
                                style:
                                    englishTheme.textTheme.headline1!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                ],
              ),
            ),
            SizedBox(
              height: 100.h,
            )
          ],
        ),
      );
    });
  }
}
