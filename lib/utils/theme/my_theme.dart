import 'package:flutter/material.dart';
import 'package:eschoolmobile/utils/theme/constantes/colors_constantes.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:eschoolmobile/utils/theme/custom_appbar_theme.dart';
import 'package:eschoolmobile/utils/theme/custom_elevated_button_themes.dart';
import 'package:eschoolmobile/utils/theme/custom_inputdecoration_themes.dart';
import 'package:eschoolmobile/utils/theme/custom_tabbar_themes.dart';
import 'package:eschoolmobile/utils/theme/custom_text_themes.dart';

class MyTheme {
  MyTheme._();
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: ColorConstantes.primaryColor,
    hintColor: Colors.grey,
    indicatorColor: ColorConstantes.primaryColorDark,
    scaffoldBackgroundColor: ColorConstantes.whiteColor,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    textTheme: GoogleFonts.interTextTheme(TTextTheme.lightTextTheme),
    inputDecorationTheme: TInputDecorationTheme.lightInputDecorationTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButton,
    tabBarTheme: TTabBarTheme.lightTabBarTheme,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    primaryColor: ColorConstantes.primaryColorDark,
    hintColor: Colors.black,
    indicatorColor: ColorConstantes.primaryColor,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    textTheme: GoogleFonts.interTextTheme(TTextTheme.darkTextTheme),
    inputDecorationTheme: TInputDecorationTheme.darkInputDecorationTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButton,
    tabBarTheme: TTabBarTheme.darkTabBarTheme,
  );
}
