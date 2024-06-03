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
import 'package:guidy/model/shop_model.dart';
import 'package:guidy/view/widgets/reusable_button.dart';
import 'package:guidy/view/widgets/reusable_form_field.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/AppColors.dart';
import '../../../../core/constants/appTheme.dart';
import '../../map_screen.dart';

class UpdateShopScreen extends GetView<MainScreenController> {
  UpdateShopScreen({super.key, required this.shopModel});
  final ShopModel shopModel;
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController phoneTextController = TextEditingController();
  final TextEditingController addressTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    nameTextController.text = shopModel.shop_name;
    phoneTextController.text = shopModel.shop_phone;
    addressTextController.text = shopModel.shop_address;
    String lat = shopModel.latitude;
    String long = shopModel.longitude;

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
          "Update Shop".tr,
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
              ReusableFormField(
                controller: nameTextController,
                label: 'Shop Name'.tr,
                isPassword: false,
                icon: Icon(IconlyBroken.work),
                checkValidate: (String? x) {},
              ),
              SizedBox(height: 20.h),
              ReusableFormField(
                controller: phoneTextController,
                label: 'Shop phone'.tr,
                keyType: TextInputType.phone,
                isPassword: false,
                icon: Icon(IconlyBroken.call),
                checkValidate: (String? x) {},
              ),
              SizedBox(height: 20.h),
              ReusableFormField(
                controller: addressTextController,
                label: 'Shop address'.tr,
                isPassword: false,
                icon: Icon(IconlyBroken.location),
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
                    lat = selectedLocation.latitude.toString();
                    long = selectedLocation.longitude.toString();
                  }
                },
              ),
              SizedBox(height: 20.h),
              ReUsableButton(
                onPressed: () async {
                  if (await controller.updateShop(
                      shopId: shopModel.shop_id,
                      shopName: nameTextController.text.trim(),
                      shopPhone: phoneTextController.text.trim(),
                      shopAddress: addressTextController.text.trim(),
                      lat: lat,
                      long: long)) {
                    snackBar(
                        context: context,
                        contentType: ContentType.success,
                        title: "Done . . . ".tr,
                        body: "Shop Updated Successfully".tr);
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
