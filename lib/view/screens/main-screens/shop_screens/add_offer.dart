import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_selector/widget/flutter_single_select.dart';
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

class AddOfferScreen extends GetView<MainScreenController> {
  AddOfferScreen({super.key});
  final TextEditingController offerNameTextController = TextEditingController();
  final TextEditingController offerDescriptionTextController = TextEditingController();
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
          "Add Offer".tr,
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
              CustomSingleSelectField<dynamic>(
                items: controller.shopPhonePairs.toList(),
                title: "Available Shops".tr,
                onSelectionDone: (value) {
                  controller.offerData['shop_name'] = value.toString().split(' - ')[0];
                  controller.offerData['shop_phone'] = value.toString().split(' - ')[1];
                },
              ),
              SizedBox(height: 20.h),
              ReusableFormField(
                controller: offerNameTextController,
                label: 'Offer Name'.tr,
                onTyping: (p0) {
                  controller.offerData['offer_name'] = p0;
                },
                isPassword: false,
                icon: Icon(IconlyBroken.paper_negative),
                checkValidate: (String? x) {},
              ),
              SizedBox(height: 20.h),
              ReusableFormField(
                controller: offerDescriptionTextController,
                label: 'Offer Description'.tr,
                keyType: TextInputType.text,
                onTyping: (p0) {
                  controller.offerData['description'] = p0;
                },
                isPassword: false,
                icon: Icon(IconlyBroken.more_circle),
                checkValidate: (String? x) {},
              ),
              SizedBox(height: 20.h),
              Text("Offer Date :".tr),
              SizedBox(height: 20.h),
            CalendarDatePicker2(
              config:  CalendarDatePicker2Config(
                calendarType: CalendarDatePicker2Type.range,
              ),
              value: [],
              onValueChanged: (dates) => {
                if(dates.length == 1){
                  controller.offerData['start_date'] = dates[0],
                }else{
                  controller.offerData['expiration_date'] = dates[1],
                },
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
                    controller.selectedPhotosForOfferAdd =
                        pickedFiles.map((file) => File(file.path)).toList();
                  }
                },
                text: "Upload Offer Photos".tr,
                colour: Colors.teal,
                key: key,
                radius: 20,
                height: 15.h,
              ),


              SizedBox(height: 20.h),
              ReUsableButton(
                onPressed: () async {
                  if(await controller.addOffer(context)){
                    snackBar(
                        context: context,
                        contentType: ContentType.success,
                        title: "Done . . . ".tr,
                        body: "Offer Added Successfully".tr);
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
