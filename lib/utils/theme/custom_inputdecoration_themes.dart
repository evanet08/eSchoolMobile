import 'package:flutter/material.dart';
import 'package:eschoolmobile/utils/theme/constantes/colors_constantes.dart';

class TInputDecorationTheme {
  TInputDecorationTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    hintStyle: const TextStyle(color: Colors.grey, fontSize: 12.0),
    border: OutlineInputBorder(
      borderSide: BorderSide(width: 0, color: ColorConstantes.blackColor),
      borderRadius: BorderRadius.circular(5.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 0, color: ColorConstantes.primaryColorDark),
      borderRadius: BorderRadius.circular(5.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 0, color: ColorConstantes.primaryColorDark),
      borderRadius: BorderRadius.circular(5.0),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 0, color: ColorConstantes.redColor),
      borderRadius: BorderRadius.circular(5.0),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    hintStyle: const TextStyle(color: Colors.grey, fontSize: 12.0),
    border: OutlineInputBorder(
      borderSide: BorderSide(width: 0, color: ColorConstantes.whiteColor),
      borderRadius: BorderRadius.circular(5.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 0, color: ColorConstantes.primaryColor),
      borderRadius: BorderRadius.circular(5.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 0, color: ColorConstantes.primaryColor),
      borderRadius: BorderRadius.circular(5.0),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 0, color: ColorConstantes.redColorDark),
      borderRadius: BorderRadius.circular(5.0),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
  );
}
