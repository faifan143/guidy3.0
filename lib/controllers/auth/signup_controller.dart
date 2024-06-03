import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:guidy/core/constants/AppConnection.dart';
import 'package:guidy/core/functions/checkPasswordMatch.dart';
import 'package:guidy/core/functions/signupSuccessful.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../core/constants/AppRoutes.dart';

class SignupController extends GetxController {
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  TextEditingController myUsername = TextEditingController();
  TextEditingController myPhone = TextEditingController();
  TextEditingController myEmail = TextEditingController();
  TextEditingController myPassword = TextEditingController();
  TextEditingController myRePassword = TextEditingController();
  TextEditingController myAddress = TextEditingController();

  bool loading = false;
  bool isPassword = true;
  bool isRePassword = true;

  File? profileImage;
  var picker = ImagePicker();

  changePassState() {
    isPassword = !isPassword;
    update();
  }

  changeRePassState() {
    isRePassword = !isRePassword;
    update();
  }

  changeLoadingState() {
    loading = !loading;
    update();
  }

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      update();
    } else {
      update();
    }
  }

  Future<void> registerAdminPhone({
    required BuildContext context,
    required String email,
    required String phone,
  }) async {
    try {
      // Perform the request to register the admin and add the phone number
      var response = await http.post(
        Uri.parse(
            'http://${AppConnection.url}:${AppConnection.port}/auth/admin_phone_register'),
        body: {
          'email': email,
          'phone': phone,
        },
      );

      if (response.statusCode == 200) {
        print({'admin_phone_state': 'success'});
        snackBar(
          context: context,
          title: "Congrats !".tr,
          body: "Signed up successfully. Check your email to verify it.".tr,
          contentType: ContentType.success,
        );
        changeLoadingState();
        Get.offAllNamed(AppRoutes.login);
      } else {
        print({
          'admin_phone_state': 'fail',
          'message': 'Failed registering admin and phone number'
        });
        snackBar(
          context: context,
          title: "Oops !".tr,
          body: "Failed registering admin and phone number.".tr,
          contentType: ContentType.failure,
        );
        changeLoadingState();
      }
    } catch (error) {
      print('Error registering admin and phone number: $error');
      snackBar(
        context: context,
        title: "Oops !".tr,
        body: "An error occurred while registering admin and phone number.".tr,
        contentType: ContentType.failure,
      );
      changeLoadingState();
    }
  }

  Future<void> registerCustomerPhone({
    required BuildContext context,
    required String email,
    required String phone,
  }) async {
    try {
      var response = await http.post(
        Uri.parse(
            'http://${AppConnection.url}:${AppConnection.port}/auth/customer_phone_register'),
        body: {
          'email': email,
          'phone': phone,
        },
      );

      if (response.statusCode == 200) {
        print({'admin_phone_state': 'success'});
        snackBar(
          context: context,
          title: "Congrats !".tr,
          body: "Signed up successfully ...".tr,
          contentType: ContentType.success,
        );
        changeLoadingState();
        Get.offAllNamed(AppRoutes.login);
      } else {
        print({
          'admin_phone_state': 'fail',
          'message': 'Failed registering admin and phone number'
        });
        snackBar(
          context: context,
          title: "Oops !".tr,
          body: "Failed registering admin and phone number.".tr,
          contentType: ContentType.failure,
        );
        changeLoadingState();
      }
    } catch (error) {
      print('Error registering admin and phone number: $error');
      snackBar(
        context: context,
        title: "Oops !".tr,
        body: "An error occurred while registering admin and phone number.".tr,
        contentType: ContentType.failure,
      );
      changeLoadingState();
    }
  }

  Future<void> registerAdmin(BuildContext context) async {
    var dataState = formState.currentState;
    if (dataState!.validate() &&
        checkPasswordMatch(
            password: myPassword.text,
            rePassword: myRePassword.text,
            context: context)) {
      changeLoadingState();
      var uri = Uri.parse(
          'http://${AppConnection.url}:${AppConnection.port}/auth/admin_register');
      var request = http.MultipartRequest('POST', uri);
      request.fields['email'] = myEmail.text.trim();
      request.fields['name'] = myUsername.text.trim();
      request.fields['password'] = myPassword.text.trim();
      if (profileImage != null) {
        var fileStream =
            http.ByteStream(Stream.castFrom(profileImage!.openRead()));
        var length = await profileImage!.length();
        var multipartFile = http.MultipartFile('picture', fileStream, length,
            filename: profileImage!.path.split('/').last);
        request.files.add(multipartFile);
        try {
          var streamedResponse = await request.send();
          await http.Response.fromStream(streamedResponse).then((value) => {
                if (value.statusCode == 201)
                  {
                    registerAdminPhone(
                        context: context,
                        email: myEmail.text.trim(),
                        phone: myPhone.text.trim())
                  }
                else
                  {
                    print('Registration failed: ${value.body}'),
                    snackBar(
                        context: context,
                        title: "Oops !".tr,
                        body: "Registration failed  ..".tr,
                        contentType: ContentType.failure),
                    changeLoadingState()
                  }
              });
        } catch (e) {
          print('Error registering admin: $e   ');
          snackBar(
              context: context,
              title: "Oops !".tr,
              body: "Error registering admin  ..".tr,
              contentType: ContentType.failure);
          changeLoadingState();
        }
      } else {
        snackBar(
            context: context,
            title: "Oops !".tr,
            body: "Pick a Profile picture ..".tr,
            contentType: ContentType.warning);
        changeLoadingState();
      }
    }
  }

  Future<void> registerCustomer(BuildContext context) async {
    var dataState = formState.currentState;
    if (dataState!.validate() &&
        checkPasswordMatch(
            password: myPassword.text,
            rePassword: myRePassword.text,
            context: context)) {
      changeLoadingState();
      var uri = Uri.parse(
          'http://${AppConnection.url}:${AppConnection.port}/auth/customer_register');
      var request = http.MultipartRequest('POST', uri);
      request.fields['email'] = myEmail.text.trim();
      request.fields['name'] = myUsername.text.trim();
      request.fields['address'] = myAddress.text.trim();
      request.fields['password'] = myPassword.text.trim();
      request.fields['latitude'] = "0";
      request.fields['longitude'] = "0";

      if (profileImage != null) {
        var fileStream =
            http.ByteStream(Stream.castFrom(profileImage!.openRead()));
        var length = await profileImage!.length();
        var multipartFile = http.MultipartFile('picture', fileStream, length,
            filename: profileImage!.path.split('/').last);
        request.files.add(multipartFile);
        try {
          var streamedResponse = await request.send();
          await http.Response.fromStream(streamedResponse).then((value) => {
                if (value.statusCode == 201)
                  {
                    registerCustomerPhone(
                        context: context,
                        email: myEmail.text.trim(),
                        phone: myPhone.text.trim())
                  }
                else
                  {
                    print('Registration failed: ${value.body}'),
                    snackBar(
                        context: context,
                        title: "Oops !".tr,
                        body: "Registration failed  ..".tr,
                        contentType: ContentType.failure),
                    changeLoadingState()
                  }
              });
        } catch (e) {
          print('Error registering admin: $e   ');
          snackBar(
              context: context,
              title: "Oops !".tr,
              body: "Error registering admin  ..".tr,
              contentType: ContentType.failure);
          changeLoadingState();
        }
      } else {
        snackBar(
            context: context,
            title: "Oops !".tr,
            body: "Pick a Profile picture ..".tr,
            contentType: ContentType.warning);
        changeLoadingState();
      }
    }
  }

  Future<void> register(BuildContext context) async {
    RegExp regex = RegExp(r'\badmin@[\w.]+');
    if (regex.hasMatch(myEmail.text.trim())) {
      await registerAdmin(context);
    } else {
      await registerCustomer(context);
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}
