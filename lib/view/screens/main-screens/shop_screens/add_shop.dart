import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guidy/controllers/main_screen_controller.dart';
import 'package:guidy/core/functions/signupSuccessful.dart';
import 'package:guidy/view/widgets/reusable_button.dart';
import 'package:guidy/view/widgets/reusable_form_field.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/AppColors.dart';
import '../../../../core/constants/appTheme.dart';
import '../../map_screen.dart';

class AddShopScreen extends GetView<MainScreenController> {
  AddShopScreen({super.key});
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController phoneTextController = TextEditingController();
  final TextEditingController addressTextController = TextEditingController();
  final TextEditingController ratingTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              IconlyBroken.arrow_left,
              color: AppColors.gradientDarkColor,
            )),
        title: Text(
          "Add Shop".tr,
          style: englishTheme.textTheme.headline1!.copyWith(
              fontWeight: FontWeight.w300, color: AppColors.gradientDarkColor),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: ListView(
            children: [
              SizedBox(height: 10.h),
              Text("Available Subcategories :".tr),
              SizedBox(height: 10.h),
              MultiSelectContainer(
                itemsDecoration: MultiSelectDecorations(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.green.withOpacity(0.2),
                      Colors.grey.withOpacity(0.1),
                    ]),
                    border: Border.all(color: Colors.green[200]!),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  selectedDecoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.green, Colors.lightGreen],
                    ),
                    border: Border.all(color: Colors.green[700]!),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  disabledDecoration: BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(color: Colors.grey[500]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: controller.subcategories.entries
                    .map((subcategory) =>
                    MultiSelectCard(value: subcategory, label: subcategory.value))
                    .toList(),
                onChange: (allSelectedItems, selectedItem) {
                    print(controller.subcategories.values);
                  List<MapEntry<String,String>> subs = allSelectedItems;
                  List<String> subsValues = [];
                  subs.forEach((sub) {
                    subsValues.add(sub.value);
                  });
                  controller.shopData['subcategories'] = subsValues;
                },
              ),
              SizedBox(height: 20.h),
              ReusableFormField(
                controller: nameTextController,
                label: 'Shop Name'.tr,
                onTyping: (p0) {
                  controller.shopData['shop_name'] = p0;
                },
                isPassword: false,
                icon: Icon(IconlyBroken.work),
                checkValidate: (String? x) {},
              ),
              SizedBox(height: 20.h),
              ReusableFormField(
                controller: phoneTextController,
                label: 'Shop phone'.tr,
                keyType: TextInputType.phone,
                onTyping: (p0) {
                  controller.shopData['shop_phone'] = p0;
                },
                isPassword: false,
                icon: Icon(IconlyBroken.call),
                checkValidate: (String? x) {},
              ),
              SizedBox(height: 20.h),
              ReusableFormField(
                controller: addressTextController,
                label: 'Shop address'.tr,
                onTyping: (p0) {
                  controller.shopData['shop_address'] = p0;
                },
                isPassword: false,
                icon: Icon(IconlyBroken.location),
                checkValidate: (String? x) {},
              ),
              SizedBox(height: 20.h),
              ReusableFormField(
                controller: ratingTextController,
                label: 'Shop rating'.tr,
                keyType: TextInputType.number,
                onTyping: (p0) {
                  controller.shopData['shop_rating'] = p0;
                },
                isPassword: false,
                icon: Icon(IconlyBroken.star),
                checkValidate: (String? x) {},
              ),
              SizedBox(height: 20.h),
              ReUsableButton(
                text: "X Point The Location X".tr,
                height: 15,
                radius: 20,
                key: key,
                colour: Colors.deepPurple,
                onPressed: () async {
                  final selectedLocation = await Navigator.push<LatLng>(
                    context,
                    MaterialPageRoute(builder: (context) => MapScreen()),
                  );
                  if (selectedLocation != null) {
                    controller.shopData['lat'] = selectedLocation.latitude;
                    controller.shopData['long'] = selectedLocation.longitude;
                  }
                },
              ),
              SizedBox(height: 20.h),
              ReUsableButton(
                onPressed: () async {
                  List<XFile>? pickedFiles = await ImagePicker().pickMultiImage(
                    imageQuality: 100, // Adjust image quality as needed
                  );

                  if (pickedFiles != null) {
                    // Convert pickedFiles to List<File> and update selectedPhotos list
                    controller.selectedPhotosForShopAdd =
                        pickedFiles.map((file) => File(file.path)).toList();
                  }
                },
                text: "Upload Shop Photos".tr,
                colour: Colors.teal,
                key: key,
                radius: 20,
                height: 15,
              ),
              SizedBox(height: 20.h),
              ReUsableButton(
                onPressed: () async {
                  if(await controller.addShop(context)){
                    snackBar(
                      context: context,
                        contentType: ContentType.success,
                        title: "Done . . . ".tr,
                        body: "Shop Added Successfully".tr);
                    Future.delayed(Duration(seconds: 2));
                    Navigator.pop(context);
                  }
                },
                text: "Submit".tr,
                colour: Colors.blueGrey,
                key: key,
                radius: 20,
                height: 15.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
