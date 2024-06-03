import 'package:get/get.dart';

validator(var val, int min, int max, var type) {
  if (type == "username") {
    if (!GetUtils.isUsername(val)) {
      return "Invalid Username".tr;
    }
  }
  if (type == "email") {
    if (!GetUtils.isEmail(val)) {
      return "Invalid Email".tr;
    }
  }
  if (type == "phone") {
    if (!GetUtils.isPhoneNumber(val)) {
      return "Invalid Phone".tr;
    }
  }

  if (val.isEmpty) {
    return "Can't be empty".tr;
  }

  if (val.length < min) {
    return "Can't be less than possible".tr;
  }
  if (val.length > max) {
    return "Can't be more than possible".tr;
  }
}
