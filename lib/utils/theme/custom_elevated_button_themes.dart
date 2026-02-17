import 'package:flutter/material.dart';
import 'package:eschoolmobile/utils/theme/constantes/colors_constantes.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._();

  static ElevatedButtonThemeData lightElevatedButton = ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(ColorConstantes.whiteColor),
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.pressed)) {
          return Colors.grey; // When pressed
        }
        return ColorConstantes.primaryColorDark;
      }),
      elevation: WidgetStateProperty.all(0.0),
      side: WidgetStateProperty.resolveWith<BorderSide>((states) {
        if (states.contains(WidgetState.pressed)) {
          return BorderSide(color: Colors.grey, width: 1.0);
        }
        return BorderSide(color: ColorConstantes.primaryColorDark, width: 1.0);
      }),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    ),
  );

  static ElevatedButtonThemeData darkElevatedButton = ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(ColorConstantes.whiteColor),
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.pressed)) {
          return Colors.grey; // When pressed
        }
        return ColorConstantes.primaryColor;
      }),
      elevation: WidgetStateProperty.all(0.0),
      side: WidgetStateProperty.resolveWith<BorderSide>((states) {
        if (states.contains(WidgetState.pressed)) {
          return BorderSide(color: Colors.grey, width: 1.0);
        }
        return BorderSide(color: ColorConstantes.primaryColor, width: 1.0);
      }),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    ),
  );
}
