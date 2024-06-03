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
import 'package:guidy/model/offer_model.dart';
import 'package:guidy/view/widgets/reusable_button.dart';
import 'package:guidy/view/widgets/reusable_form_field.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/AppColors.dart';
import '../../../../core/constants/appTheme.dart';
import '../../map_screen.dart';

class UpdateOfferScreen extends GetView<MainScreenController> {
  UpdateOfferScreen({super.key,required this.offerModel});
  final TextEditingController offerNameTextController = TextEditingController();
  final TextEditingController offerDescriptionTextController = TextEditingController();

  final OfferModel offerModel;
  @override
  Widget build(BuildContext context) {
    offerNameTextController.text = offerModel.offerName;
    offerDescriptionTextController.text = offerModel.description;
    DateTime startDate = offerModel.startDate ;
    DateTime expirationDate = offerModel.expirationDate ;

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
          "Update Offer".tr,
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
                controller: offerNameTextController,
                label: 'Offer Name'.tr,
                isPassword: false,
                icon: const Icon(IconlyBroken.paper_negative),
                checkValidate: (String? x) {},
              ),
              SizedBox(height: 20.h),
              ReusableFormField(
                controller: offerDescriptionTextController,
                label: 'Offer Description'.tr,
                keyType: TextInputType.text,
                isPassword: false,
                icon: const Icon(IconlyBroken.more_circle),
                checkValidate: (String? x) {},
              ),
              SizedBox(height: 20.h),
               Text("Offer Expiration Date :".tr),
              SizedBox(height: 20.h),
              CalendarDatePicker2(
                config:  CalendarDatePicker2Config(
                  calendarType: CalendarDatePicker2Type.single,
                ),
                value: [
                  expirationDate,
                ],
                onValueChanged: (dates) => {
                  expirationDate = dates[0]!,
                },
              ),
              SizedBox(height: 20.h),
              ReUsableButton(
                onPressed: () async {
                  if(await controller.updateOffer(offerId: offerModel.offerId,offerName:offerNameTextController.text.trim() ,description: offerDescriptionTextController.text.trim(),expirationDate: expirationDate.toString() )){
                    snackBar(
                        context: context,
                        contentType: ContentType.success,
                        title: "Done . . . ".tr,
                        body: "Offer Updated Successfully".tr);
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
