import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guidy/controllers/auth/signup_controller.dart';
import 'package:guidy/core/functions/validator.dart';
import 'package:guidy/view/screens/auth/login.dart';
import 'package:guidy/view/widgets/reusable_button.dart';
import 'package:guidy/view/widgets/reusable_form_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';



class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(SignupController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<SignupController>(builder: (controller) {
        return ModalProgressHUD(
          inAsyncCall: controller.loading,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: controller.formState,
              child: ListView(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  ListTile(
                    title: Text(
                      "SignUpText".tr,
                      style: const TextStyle(fontSize: 28),
                    ),
                    subtitle: Text(
                      "Signup now and share the moment with friends.".tr,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                   SizedBox(height: 50.h),
                  ReusableFormField(
                    checkValidate: (value) {
                      return validator(
                          controller.myUsername.text, 3, 50, "username");
                    },
                    isPassword: false,
                    label: "Username".tr,
                    controller: controller.myUsername,
                    hint: "Enter your username".tr,
                    keyType: TextInputType.text,
                    icon: const Icon(Icons.person_outline),
                  ),
                   SizedBox(
                    height: 20.h,
                  ),
                  // here the picked image should be shown
                  controller.profileImage != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(10), // Adjust the border radius as needed
                    child: Image.file(
                      controller.profileImage!,
                      width: 150.w, // Adjust width as needed
                      height: 150.h, // Adjust height as needed
                      fit: BoxFit.cover,
                    ),
                  ) : Container(),
                   SizedBox(
                    height: 20.h,
                  ),
                  ReUsableButton(
                    height: 20.h,
                    radius: 10,
                    onPressed: () {
                      controller.getProfileImage();
                    },
                    colour: Colors.deepPurpleAccent,
                    text: "Pick Profile Image".tr,
                  ),
                   SizedBox(
                    height: 20.h,
                  ),
                  ReusableFormField(
                    checkValidate: (value) {
                      return validator(
                          controller.myPhone.text, 10, 10, "phone");
                    },
                    isPassword: false,
                    controller: controller.myPhone,
                    label: "Phone".tr,
                    hint: "Enter your phone".tr,
                    keyType: TextInputType.phone,
                    icon: const Icon(Icons.phone_outlined),
                  ),
                   SizedBox(
                    height: 20.h,
                  ),
                  ReusableFormField(
                    checkValidate: (value) {
                      return validator(
                          controller.myEmail.text, 5, 100, "email");
                    },
                    isPassword: false,
                    label: "emailLabel".tr,
                    hint: "Enter your email".tr,
                    keyType: TextInputType.emailAddress,
                    icon: const Icon(Icons.email_outlined),
                    controller: controller.myEmail,
                  ),
                   SizedBox(
                    height: 20.h,
                  ),
                  ReusableFormField(
                    checkValidate: (value) {
                      return validator(
                          controller.myPassword.text, 5, 30, "password");
                    },
                    label: "PasswordLabel".tr,
                    hint: "Enter your password".tr,
                    keyType: TextInputType.text,
                    isPassword: controller.isPassword,
                    onTap: () {
                      controller.changePassState();
                    },
                    icon: const Icon(Icons.lock_outline),
                    controller: controller.myPassword,
                  ),
                   SizedBox(
                    height: 20.h,
                  ),
                  ReusableFormField(
                    checkValidate: (value) {
                      return validator(
                          controller.myRePassword.text, 5, 30, "password");
                    },
                    label: "Re-Password".tr,
                    hint: "Re-Enter your password".tr,
                    keyType: TextInputType.text,
                    isPassword: controller.isRePassword,
                    onTap: () {
                      controller.changeRePassState();
                    },
                    icon: const Icon(Icons.lock_outline),
                    controller: controller.myRePassword,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  ReusableFormField(
                    checkValidate: (value) {
                      return validator(
                          controller.myAddress.text, 3, 30, "address");
                    },
                    label: "Address".tr,
                    hint: "Enter Your Address".tr,
                    keyType: TextInputType.text,
                    isPassword: false,
                    icon: const Icon(Icons.location_city),
                    controller: controller.myAddress,
                  ),
                   SizedBox(
                    height: 20.h,
                  ),
                  ReUsableButton(
                    text: "SignUp as a user".tr,
                    height: 10.h,
                    radius: 10,
                    colour: Colors.blueAccent,
                    onPressed: () async {
                      await controller.register(context);
                    },
                  ),
                   SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already Have An Account?".tr),
                      const Text(" "),
                      InkWell(
                        onTap: () {
                          Get.off(const LoginScreen());
                        },
                        child: Text(
                          "LOGIN".tr,
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
