import 'package:flutter/material.dart';
import 'package:eschoolmobile/models/utilisateur.dart';
import 'package:eschoolmobile/providers/classes_provider.dart';
import 'package:eschoolmobile/providers/eleves_provider.dart';

enum AuthenticationStatus {
  NotAuthenticated,
  Authenticating,
  Authenticated,
  UserNotFind,
  Error,
}

class AuthenticationProvider extends ChangeNotifier {
  Utilisateur? utilisateur;
  String? token;
  AuthenticationStatus status = AuthenticationStatus.NotAuthenticated;
  static AuthenticationProvider instance = AuthenticationProvider();

  void setupLogoutvalues() {
    utilisateur = null;
    token = null;
    ClassesProvider.instance.classes = [];
    ClassesProvider.instance.classe = null;
    ClassesProvider.instance.cours = null;
    EleveProvider.instance.eleve = null;
    status = AuthenticationStatus.NotAuthenticated;
  }

  void notify() {
    notifyListeners();
  }
}
