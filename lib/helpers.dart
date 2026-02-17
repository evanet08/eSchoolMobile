import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:eschoolmobile/custom_widgets/language_item.dart';
import 'package:eschoolmobile/custom_widgets/my_text.dart';
import 'package:eschoolmobile/models/language.dart';
import 'package:eschoolmobile/utils/theme/constantes/enums_constantes.dart';
import 'package:eschoolmobile/utils/theme/constantes/strings_constantes.dart';
import 'package:eschoolmobile/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Helpers {
  static const platform = MethodChannel('qrCode');

  static PopupMenuItem buildPopupLanguageMenuItem(Language language) {
    return PopupMenuItem(
      value: language,
      child: LanguageItem(language: language),
    );
  }

  static PopupMenuItem buildPopupDateElementItem(String value) {
    return PopupMenuItem(
      value: value,
      child: ListTile(title: MyText(text: value)),
    );
  }

  static String getMentionConduiteStr(
    BuildContext context,
    MentionConduite mention,
  ) {
    return mention == MentionConduite.tresBien
        ? StringConstantes.tresBien
        : mention == MentionConduite.bien
        ? StringConstantes.bien
        : mention == MentionConduite.satisfaisante
        ? StringConstantes.satisfaisante
        : mention == MentionConduite.mauvaise
        ? StringConstantes.mauvaise
        : mention == MentionConduite.tresMauvaise
        ? StringConstantes.tresMauvaise
        : "";
  }

  static String getMentionConduiteStrByValue(
    BuildContext context,
    int mention,
  ) {
    return mention == 5
        ? StringConstantes.tresBien
        : mention == 4
        ? StringConstantes.bien
        : mention == 3
        ? StringConstantes.satisfaisante
        : mention == 2
        ? StringConstantes.mauvaise
        : mention == 1
        ? StringConstantes.tresMauvaise
        : "";
  }

  static String getMentionNoteStr(BuildContext context, MentionNote mention) {
    return mention == MentionNote.tresBien
        ? StringConstantes.tresBien
        : mention == MentionNote.bien
        ? StringConstantes.bien
        : mention == MentionNote.excellent
        ? AppLocalizations.of(context)!.excellent
        : mention == MentionNote.mediocre
        ? StringConstantes.mediocre
        : mention == MentionNote.satisfaisant
        ? StringConstantes.satisfaisante
        : "";
  }

  static String convertEndateToFrdate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  }

  static String convertDateToString(DateTime date, String format) {
    return DateFormat(format).format(date);
  }

  static Duration differenceBetweenTwoDates(DateTime date1, DateTime date2) {
    return date1.difference(date2);
  }

  static Future<void> saveFMCToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  static Future<String?> getFMCToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }
}
