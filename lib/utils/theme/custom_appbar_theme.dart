import 'package:flutter/material.dart';
import 'package:eschoolmobile/utils/theme/constantes/colors_constantes.dart';
import 'package:eschoolmobile/utils/theme/custom_text_themes.dart';

class TAppBarTheme {
  TAppBarTheme._();

  static AppBarTheme lightAppBarTheme = AppBarTheme(
    backgroundColor: ColorConstantes.primaryColor,
    toolbarHeight: 50.0,
    elevation: 0.0,
    titleTextStyle: TTextTheme.lightTextTheme.headlineMedium,
    toolbarTextStyle: TTextTheme.lightTextTheme.headlineMedium,
    iconTheme: IconThemeData(color: ColorConstantes.blackColor),
    actionsIconTheme: IconThemeData(color: ColorConstantes.blackColor),
    centerTitle: true,
  );

  static AppBarTheme darkAppBarTheme = AppBarTheme(
    backgroundColor: ColorConstantes.primaryColorDark,
    toolbarHeight: 50.0,
    elevation: 0.0,
    titleTextStyle: TTextTheme.lightTextTheme.headlineMedium,
    toolbarTextStyle: TTextTheme.lightTextTheme.headlineMedium,
    iconTheme: IconThemeData(color: ColorConstantes.whiteColor),
    actionsIconTheme: IconThemeData(color: ColorConstantes.whiteColor),
    centerTitle: true,
  );
}
