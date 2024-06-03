import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData englishTheme = ThemeData(
  fontFamily: "Nunito",
  textTheme:  TextTheme(
    headline1: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.black,
    ),
    headline2: TextStyle(fontSize: 26, color: Colors.black),
    bodyText1: TextStyle(
      height: 2.h,
      fontWeight: FontWeight.bold,
      fontSize: 17,
      color: Colors.black,
    ),
  ),
);

ThemeData arabicTheme = ThemeData(
  fontFamily: "Cairo",
  textTheme:  TextTheme(
    headline1: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.black,
    ),
    headline2: TextStyle(fontSize: 26, color: Colors.black),
    bodyText1: TextStyle(
      height: 2.h,
      fontWeight: FontWeight.bold,
      fontSize: 17,
      color: Colors.black,
    ),
  ),
);
