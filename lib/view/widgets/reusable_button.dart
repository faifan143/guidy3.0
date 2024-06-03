import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guidy/core/constants/appTheme.dart';

import '../../core/localization/changeLocale.dart';


class ReUsableButton extends StatelessWidget {
  ReUsableButton({
    Key? key,
    this.onPressed,
    this.text,
    this.colour,
    this.radius,
    this.gradient,
    this.height, this.fontSize,
  }) : super(key: key);
  final VoidCallback? onPressed;
  final String? text;
  final Color? colour;
  Gradient? gradient;
  final double? fontSize;
  double? height = 20.h;
  double? radius = 20;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      elevation: 4,
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: gradient,
            borderRadius: BorderRadius.circular(radius!), color: colour),
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: height!),
        child: GetBuilder<LocaleController>(builder: (controller2) {
          return Text(
            text!,
            textAlign: TextAlign.center,
            style:  arabicTheme.textTheme.bodyText1!.copyWith(color: Colors.white,fontSize: fontSize),
          );
        }),
      ),
    );
  }
}
