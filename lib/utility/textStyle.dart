import 'package:flutter/material.dart';

TextStyle regularTextStyle({
  required Color textColor,
  required double fontSize,
  String? fontFamily,
  FontWeight fontWeight = FontWeight.normal,
}) {
  return TextStyle(
    color: textColor,
    fontSize: fontSize,
    fontFamily: fontFamily,
    fontWeight: fontWeight,
  );
}

TextStyle mediumTextStyle({
  required Color textColor,
  required double fontSize,
  String? fontFamily,
  FontWeight fontWeight = FontWeight.w500,
}) {
  return TextStyle(
    color: textColor,
    fontSize: fontSize,
    fontFamily: fontFamily,
    fontWeight: fontWeight,
  );
}

TextStyle LargeTextStyle({
  required Color textColor,
  required double fontSize,
  String? fontFamily,
  FontWeight fontWeight = FontWeight.w900,
}) {
  return TextStyle(
    color: textColor,
    fontSize: fontSize,
    fontFamily: fontFamily,
    fontWeight: fontWeight,
  );
}

