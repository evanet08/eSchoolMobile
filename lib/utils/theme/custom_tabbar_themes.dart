import 'package:flutter/material.dart';
import 'package:eschoolmobile/utils/theme/constantes/colors_constantes.dart';
import 'package:eschoolmobile/utils/theme/constantes/font_size_constantes.dart';

class TTabBarTheme {
  TTabBarTheme._();

  static TabBarThemeData lightTabBarTheme = TabBarThemeData(
    indicatorColor: ColorConstantes.accentColor,
    labelStyle: TextStyle(
      color: ColorConstantes.primaryColor,
      fontSize: FontSizeConstantes.smallFontsize,
      fontWeight: FontWeight.bold,
    ),
    unselectedLabelStyle: TextStyle(
      color: ColorConstantes.greyColor,
      fontSize: FontSizeConstantes.smallFontsize,
      fontWeight: FontWeight.normal,
    ),
  );

  static TabBarThemeData darkTabBarTheme = TabBarThemeData(
    indicatorColor: ColorConstantes.accentColor,
    labelStyle: TextStyle(
      color: ColorConstantes.primaryColorDark,
      fontSize: FontSizeConstantes.smallFontsize,
      fontWeight: FontWeight.bold,
    ),
    unselectedLabelStyle: TextStyle(
      color: ColorConstantes.blackColor,
      fontSize: FontSizeConstantes.smallFontsize,
      fontWeight: FontWeight.normal,
    ),
  );
}
