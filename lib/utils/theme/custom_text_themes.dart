import 'package:flutter/material.dart';
import 'package:eschoolmobile/utils/theme/constantes/colors_constantes.dart';
import 'package:eschoolmobile/utils/theme/constantes/font_size_constantes.dart';

class TTextTheme {
  TTextTheme._();
  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: TextStyle().copyWith(
      fontSize: FontSizeConstantes.largeFontsize,
      fontWeight: FontWeight.bold,
      color: ColorConstantes.blackColor,
    ),
    headlineMedium: TextStyle().copyWith(
      fontSize: FontSizeConstantes.mediumFontsize,
      fontWeight: FontWeight.w600,
      color: ColorConstantes.blackColor,
    ),
    headlineSmall: TextStyle().copyWith(
      fontSize: FontSizeConstantes.smallFontsize,
      fontWeight: FontWeight.w600,
      color: ColorConstantes.blackColor,
    ),
    titleLarge: TextStyle().copyWith(
      fontSize: FontSizeConstantes.largeFontsize,
      fontWeight: FontWeight.bold,
      color: ColorConstantes.blackColor,
    ),
    titleMedium: TextStyle().copyWith(
      fontSize: FontSizeConstantes.mediumFontsize,
      fontWeight: FontWeight.w600,
      color: ColorConstantes.blackColor,
    ),
    titleSmall: TextStyle().copyWith(
      fontSize: FontSizeConstantes.smallFontsize,
      fontWeight: FontWeight.w600,
      color: ColorConstantes.blackColor,
    ),
    bodyLarge: TextStyle().copyWith(
      fontSize: FontSizeConstantes.largeFontsize,
      fontWeight: FontWeight.bold,
      color: ColorConstantes.blackColor,
    ),
    bodyMedium: TextStyle().copyWith(
      fontSize: FontSizeConstantes.mediumFontsize,
      fontWeight: FontWeight.w600,
      color: ColorConstantes.blackColor,
    ),
    bodySmall: TextStyle().copyWith(
      fontSize: FontSizeConstantes.smallFontsize,
      fontWeight: FontWeight.w600,
      color: ColorConstantes.blackColor,
    ),
    labelLarge: TextStyle().copyWith(
      fontSize: FontSizeConstantes.largeFontsize,
      fontWeight: FontWeight.bold,
      color: ColorConstantes.blackColor,
    ),
    labelMedium: TextStyle().copyWith(
      fontSize: FontSizeConstantes.mediumFontsize,
      fontWeight: FontWeight.w600,
      color: ColorConstantes.blackColor,
    ),
    labelSmall: TextStyle().copyWith(
      fontSize: FontSizeConstantes.smallFontsize,
      fontWeight: FontWeight.w600,
      color: ColorConstantes.blackColor,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: TextStyle().copyWith(
      fontSize: FontSizeConstantes.largeFontsize,
      fontWeight: FontWeight.bold,
      color: ColorConstantes.whiteColor,
    ),
    headlineMedium: TextStyle().copyWith(
      fontSize: FontSizeConstantes.mediumFontsize,
      fontWeight: FontWeight.w600,
      color: ColorConstantes.whiteColor,
    ),
    headlineSmall: TextStyle().copyWith(
      fontSize: FontSizeConstantes.smallFontsize,
      fontWeight: FontWeight.w600,
      color: ColorConstantes.whiteColor,
    ),
    titleLarge: TextStyle().copyWith(
      fontSize: FontSizeConstantes.largeFontsize,
      fontWeight: FontWeight.bold,
      color: ColorConstantes.whiteColor,
    ),
    titleMedium: TextStyle().copyWith(
      fontSize: FontSizeConstantes.mediumFontsize,
      fontWeight: FontWeight.w600,
      color: ColorConstantes.whiteColor,
    ),
    titleSmall: TextStyle().copyWith(
      fontSize: FontSizeConstantes.smallFontsize,
      fontWeight: FontWeight.w600,
      color: ColorConstantes.whiteColor,
    ),
    bodyLarge: TextStyle().copyWith(
      fontSize: FontSizeConstantes.largeFontsize,
      fontWeight: FontWeight.bold,
      color: ColorConstantes.whiteColor,
    ),
    bodyMedium: TextStyle().copyWith(
      fontSize: FontSizeConstantes.mediumFontsize,
      fontWeight: FontWeight.w600,
      color: ColorConstantes.whiteColor,
    ),
    bodySmall: TextStyle().copyWith(
      fontSize: FontSizeConstantes.smallFontsize,
      fontWeight: FontWeight.w600,
      color: ColorConstantes.whiteColor,
    ),
    labelLarge: TextStyle().copyWith(
      fontSize: FontSizeConstantes.largeFontsize,
      fontWeight: FontWeight.bold,
      color: ColorConstantes.whiteColor,
    ),
    labelMedium: TextStyle().copyWith(
      fontSize: FontSizeConstantes.mediumFontsize,
      fontWeight: FontWeight.w600,
      color: ColorConstantes.whiteColor,
    ),
    labelSmall: TextStyle().copyWith(
      fontSize: FontSizeConstantes.smallFontsize,
      fontWeight: FontWeight.w600,
      color: ColorConstantes.whiteColor,
    ),
  );
}
