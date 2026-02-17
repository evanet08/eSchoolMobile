import 'package:flutter/material.dart';
import 'package:eschoolmobile/models/annee.dart';

class AccountCreationProvider extends ChangeNotifier {
  String? phoneNumber;
  String? secretCode;
  String? typeUser;
  Annee? anneeScolaire;
  List<Annee> annees = [];
  static AccountCreationProvider instance = AccountCreationProvider();
  void setPhoneNumber(String phone) {
    phoneNumber = phone;
    notifyListeners();
  }

  void setSecretCode(String code) {
    secretCode = code;
    notifyListeners();
  }

  void setTypeUser(String type) {
    typeUser = type;
    notifyListeners();
  }
}
