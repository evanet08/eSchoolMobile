import 'package:flutter/material.dart';
import 'package:eschoolmobile/models/language.dart';
import '../main.dart';

class LanguageProvider extends ChangeNotifier {
  Language language = Language("Français", "fr", "assets/images/france.png");
  static LanguageProvider instance = LanguageProvider();
  void changeLanguage(BuildContext context, Language language) {
    this.language = language;
    MyApp.setLocale(context, Locale(language.code));
    notifyListeners();
  }
}

