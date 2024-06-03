import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guidy/controllers/main_screen_controller.dart';
import 'package:guidy/core/constants/AppColors.dart';
import 'package:guidy/core/constants/AppRoutes.dart';
import 'package:guidy/core/constants/appTheme.dart';
import 'package:guidy/core/functions/restarter.dart';
import 'package:iconly/iconly.dart';

import '../../core/functions/ios13_pull_down_menu.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(MainScreenController());
    return GetBuilder<MainScreenController>(builder: (controller) {
      return RefreshIndicator(
        onRefresh: () => Future.delayed(const Duration(seconds: 1),
            () => controller.update()),
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: Align(
              alignment: Alignment.center,
              child: Text("Guidy".tr,
                  textAlign: TextAlign.center,
                  style: englishTheme.textTheme.displayLarge!.copyWith(
                      fontWeight: FontWeight.w300,
                      color: AppColors.gradientDarkColor)),
            ),
            leadingWidth: 76.w,
            elevation: 2,
            actions: [
              Stack(alignment: Alignment.center, children: [
                IconButton(
                  onPressed: () {
                    RestartWidget.restartApp(context);
                    // Get.toNamed(AppRoutes.notification);
                  },
                  icon: const Icon(IconlyBroken.notification),
                  color: AppColors.gradientDarkColor,
                ),
                if (controller.hasNotification == true)
                  Positioned(
                    right: 13,
                    top: 12,
                    child: Container(
                      height: 8.h,
                      width: 8.w,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
              ]),
              IconButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.searchScreen);
                },
                icon: const Icon(IconlyBroken.search),
                color: AppColors.gradientDarkColor,
              ),
            ],
          ),
          body: SafeArea(
            child: controller.screens[controller.currentPage],
          ),
          floatingActionButton: SizedBox(
            height: 123,
            child: DotNavigationBar(
              currentIndex: !controller.isAdmin && controller.currentPage > 2
                  ? controller.currentPage - 1
                  : (controller.isAdmin && controller.currentPage > 2
                      ? 3
                      : controller.currentPage),
              backgroundColor: Colors.white,
              onTap: (p0) {
                if (controller.isAdmin) {
                  if (p0 == 2) {
                    showContextMenu(context, Offset.infinite);
                  } else {
                    controller.changePage(p0 < 2 ? p0 : 4);
                  }
                } else {
                  controller.changePage(p0 < 2 ? p0 : p0 + 1);
                }
              },
              enableFloatingNavBar: true,
              items: [
                DotNavigationBarItem(
                  icon: const Icon(IconlyBroken.home),
                  selectedColor: const Color(0xff009FFD),
                ),
                DotNavigationBarItem(
                  icon: const Icon(IconlyBroken.category),
                  selectedColor: Colors.pink,
                ),
                if (controller.isAdmin)
                  DotNavigationBarItem(
                    icon: const Icon(IconlyBroken.plus),
                    selectedColor: Colors.green,
                  ),
                if (!controller.isAdmin)
                  DotNavigationBarItem(
                    icon: const Icon(IconlyBroken.filter),
                    selectedColor: Colors.deepPurple,
                  ),
                DotNavigationBarItem(
                  icon: const Icon(IconlyBroken.profile),
                  selectedColor: Colors.orangeAccent,
                ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      );
    });
  }
}
