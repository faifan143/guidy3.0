import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

bool checkPasswordMatch(
    {required String password, required String rePassword, var context}) {
  if (password == rePassword) {
    return true;
  } else {
    final snackBar = SnackBar(
      content: AwesomeSnackbarContent(
        title: 'On Snap!'.tr,
        message: 'Password Mismatch'.tr,

        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
        contentType: ContentType.failure,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
    return false;
  }
}
