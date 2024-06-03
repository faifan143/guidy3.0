
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guidy/controllers/auth/login_controller.dart';
import 'package:guidy/core/constants/AppRoutes.dart';
import 'package:guidy/core/functions/validator.dart';
import 'package:guidy/core/localization/changeLocale.dart';
import 'package:guidy/core/services/sharedPreferences.dart';
import 'package:guidy/view/widgets/reusable_button.dart';
import 'package:guidy/view/widgets/reusable_form_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../core/functions/signupSuccessful.dart';



class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
    LocaleController localeController = Get.put(LocaleController());
    MyServices myServices = Get.find();
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<LoginController>(builder: (controller) {
        return ModalProgressHUD(
          inAsyncCall: controller.loading,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: controller.formState,
              child: ListView(
                children: [
                  SizedBox(
                    height: 200.h,
                  ),
                  ListTile(
                    title: Text(
                      "LOGIN".tr,
                      style: const TextStyle(fontSize: 28),
                    ),
                    subtitle: Text(
                      "Login now and share the moment with friends.".tr,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  ReusableFormField(
                    checkValidate: (value) {
                      return validator(
                          controller.myLoginEmail.text, 5, 100, "email");
                    },
                    isPassword: false,
                    label: "emailLabel".tr,
                    hint: "Enter your email".tr,
                    keyType: TextInputType.emailAddress,
                    icon: const Icon(Icons.email_outlined),
                    controller: controller.myLoginEmail,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  ReusableFormField(
                      checkValidate: (value) {
                        return validator(
                            controller.myLoginPassword.text, 5, 30, "password");
                      },
                      isPassword: controller.isPassword,
                      onTap: (() => controller.changePassState()),
                      controller: controller.myLoginPassword,
                      label: "PasswordLabel".tr,
                      hint: "Enter your password".tr,
                      keyType: TextInputType.text,
                      icon: const Icon(Icons.lock_outline)),
                   SizedBox(
                    height: 20.h,
                  ),
                  ReUsableButton(
                    text: "loginButton".tr,
                    height: 20.h,
                    radius: 10,
                    colour: Colors.blueAccent,
                    onPressed: () async {
                      var response = await controller.login(context);
                      if (response['state'] == 'success'){
                        Get.toNamed(AppRoutes.mainScreen);
                      }else{
                        snackBar(
                          context: context,
                          contentType: ContentType.failure,
                          title: "Failed logging in !!".tr,
                          body:
                              response['msg'],
                        );
                      }
                    },
                  ),
                   SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't Have An Account?".tr),
                      Text(" "),
                      InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.signup);
                        },
                        child: Text(
                          "SignUpText".tr,
                          style: const TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ],
                  ),
                   SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
