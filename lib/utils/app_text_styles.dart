import 'package:flutter/material.dart';
import 'package:realtime_database_app/constants/app_constants.dart';

class AppTextStyles {
  static const lightTextStyle = TextStyle(
      color: Colors.black54,
      fontWeight: FontWeight.w300,
      fontSize: 14,
      fontFamily: AppConstants.robotoTextStyleString);

  static const boldTextStyle = TextStyle(
      fontSize: 20.0, fontWeight: FontWeight.w700, fontFamily: AppConstants.robotoTextStyleString, );

  static const boldWhiteTextStyle = TextStyle(
    fontSize: 18.0, fontWeight: FontWeight.w700, fontFamily: AppConstants.robotoTextStyleString, color: Colors.white);

  static const blackTextStyle = TextStyle(
    color: Colors.black,
    fontFamily: AppConstants.robotoTextStyleString,
    fontSize: 25.0,
    fontWeight: FontWeight.w900,
  );

  static const mediumTextStyle = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    fontFamily: AppConstants.robotoTextStyleString,
    color: Colors.black,
  );

  static const mediumWhiteTextStyle = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w500,
    fontFamily: AppConstants.robotoTextStyleString,
    color: Colors.white,
  );

  static const mediumBlackTextStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    fontFamily: AppConstants.robotoTextStyleString,
    color: Colors.black,
  );

  static const regularForSmallTextStyle =
  TextStyle( fontFamily: AppConstants.robotoTextStyleString,fontWeight: FontWeight.w400,fontSize: 14.0,);

  static const regularForLargeTextStyle =
  TextStyle( fontFamily: AppConstants.robotoTextStyleString,fontWeight: FontWeight.w400,fontSize: 20.0,color: Colors.black);

  static const boldColoredTextStyle = TextStyle(
    fontSize: 16.0, fontWeight: FontWeight.w700, fontFamily: AppConstants.robotoTextStyleString, color: Colors.black);
}
