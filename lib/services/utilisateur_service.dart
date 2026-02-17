import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:eschoolmobile/custom_widgets/loading_indicator_dialog.dart';
import 'package:eschoolmobile/providers/account_creation_provider.dart';
import 'package:eschoolmobile/providers/authentication_provider.dart';
import 'package:eschoolmobile/services/navigation_service.dart';
import 'package:eschoolmobile/services/snackbar_service.dart';
import 'package:eschoolmobile/utils/theme/constantes/other_constantes.dart';
import '../models/utilisateur.dart';
import 'package:http/http.dart' as http;
import 'package:eschoolmobile/l10n/app_localizations.dart';
import 'package:flutter_session_jwt/flutter_session_jwt.dart';

class UtilisateurService {
  static UtilisateurService instance = UtilisateurService();
  UtilisateurService() {}

  String _formatPhoneNumber(String phone) {
    String p = phone.replaceAll(RegExp(r'\s+'), '');
    if (!p.startsWith('+')) {
      if (p.startsWith('0')) {
        p = '+243${p.substring(1)}';
      } else {
        p = '+243$p';
      }
    }
    return p;
  }

  Future<List<Utilisateur>> fetchUsers(BuildContext context) async {
    List<Utilisateur> users = [];
    http.Response response = await http.get(
      Uri.parse("${OtherConstantes.baseUrl}utilisateurs"),
      headers: {
        "Authorization": "Bearer ${AuthenticationProvider.instance.token}",
      },
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      for (var d in data["utilisateurs"]) {
        users.add(
          Utilisateur(
            d["_id"],
            d["noms_utilisateur"],
            d["username_utilisateur"],
            d["telephone_utilisateur"],
            "",
            "",
            "",
            "",
            "",
            "assets/profile.png",
          ),
        );
      }
    } else {
      if (context.mounted) {
        SnackBarService.instance.showSnackBarSuccess("");
      }
    }
    return users;
  }

  Future<dynamic> verificationUtilisateur(
    BuildContext context,
    String phone,
    String typeUser,
  ) async {
    try {
      String formattedPhone = _formatPhoneNumber(phone);
      print("Starting verification for $formattedPhone ($typeUser)");
      http.Response response = await http.get(
        Uri.parse(
          "${OtherConstantes.baseUrl}verification_user_by_phone/$formattedPhone/$typeUser",
        ),
      ).timeout(const Duration(seconds: 15));
      
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        if (context.mounted) {
          AccountCreationProvider.instance.setPhoneNumber(phone);
          SnackBarService.instance.showSnackBarSuccess(
            "Numéro de téléphone reconnu, vous pouvez continuer",
          );
        }
        AccountCreationProvider.instance.setPhoneNumber(phone);
        NavigationService.instance.navigateToReplacement(
          'check_verification_code',
          args: OtherConstantes.creatingAccount,
        );
      } else {
        var data = jsonDecode(response.body);
        if (context.mounted) {
          SnackBarService.instance.showSnackBarError(
            data["message"] ?? "Erreur de vérification",
          );
        }
      }
    } catch (e) {
      print("Verification Error: $e");
      if (context.mounted) {
        SnackBarService.instance.showSnackBarError("Erreur de connexion : $e");
      }
    }
  }

  Future<dynamic> verificationCodeSecret(
    BuildContext context,
    String code,
  ) async {
    try {
      LoadingIndicatorDialog().show(
        context,
        text: AppLocalizations.of(context)!.wait,
      );
      http.Response response = await http.get(
        Uri.parse(
          "${OtherConstantes.baseUrl}verification_user_by_secret_code/${AccountCreationProvider.instance.phoneNumber}/$code/${AccountCreationProvider.instance.typeUser}",
        ),
      ).timeout(const Duration(seconds: 15));
      
      LoadingIndicatorDialog().dismiss();
      print("Secret code verification status: ${response.statusCode}");

      if (response.statusCode == 200) {
        AccountCreationProvider.instance.setSecretCode(code);
        NavigationService.instance.navigateToReplacement(
          'new_password',
          args: code,
        );
      } else {
        var data = jsonDecode(response.body);
        if (context.mounted) {
          SnackBarService.instance.showSnackBarError(data['message']);
        }
      }
    } catch (e) {
      LoadingIndicatorDialog().dismiss();
      print("Secret Code Error: $e");
      if (context.mounted) {
        SnackBarService.instance.showSnackBarError("Erreur : $e");
      }
    }
  }

  Future<dynamic> createCompteUser(
    BuildContext context,
    String password,
  ) async {
    try {
      LoadingIndicatorDialog().show(
        context,
        text: AppLocalizations.of(context)!.wait,
      );
      http.Response response = await http.put(
        Uri.parse(
          "${OtherConstantes.baseUrl}create_user_account/${AccountCreationProvider.instance.secretCode}/${AccountCreationProvider.instance.typeUser}",
        ),
        body: jsonEncode({
          "password": password,
          "phone": "${AccountCreationProvider.instance.phoneNumber}",
        }),
      ).timeout(const Duration(seconds: 15));
      
      LoadingIndicatorDialog().dismiss();
      if (response.statusCode == 201) {
        NavigationService.instance.navigateToReplacement('');
      } else {
        var data = jsonDecode(response.body);
        if (context.mounted) {
           SnackBarService.instance.showSnackBarError(data['message'] ?? "Erreur");
        }
      }
    } catch (e) {
      LoadingIndicatorDialog().dismiss();
      if (context.mounted) {
        SnackBarService.instance.showSnackBarError("Erreur : $e");
      }
    }
  }

  void login(
    BuildContext context,
    String email,
    String password,
    String typeUser,
    String fMCToken,
  ) async {
    try {
      AuthenticationProvider.instance.status =
          AuthenticationStatus.Authenticating;
      AuthenticationProvider.instance.notify();

      print("Logging in as $email ($typeUser)");
      String loginIdentifier = email;
      if (typeUser == "Parent" || typeUser == "Student") {
        if (RegExp(r'^[0-9]+$').hasMatch(email.replaceAll(RegExp(r'\s+'), ''))) {
          loginIdentifier = _formatPhoneNumber(email);
          print("Formatted login identifier to $loginIdentifier");
        }
      }

      http.Response response = await http.post(
        Uri.parse("${OtherConstantes.baseUrl}login"),
        body: jsonEncode({
          "email": loginIdentifier,
          "password": password,
          "type_user": typeUser,
          "fcm_token": fMCToken,
        }),
      ).timeout(const Duration(seconds: 20));

      print("Login response: ${response.statusCode}");
      print("Login body: ${response.body}");

      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var user = jsonDecode(data["user"]);
        AuthenticationProvider.instance.utilisateur = Utilisateur(
          user["id"],
          user["first_name"],
          user["last_name"],
          "",
          "",
          "",
          "",
          "",
          "",
          "",
        );
        AuthenticationProvider.instance.token = data["access_token"];
        await FlutterSessionJwt.saveToken(data["access_token"]!);

        AuthenticationProvider.instance.status =
            AuthenticationStatus.Authenticated;
        if (context.mounted) {
          SnackBarService.instance.showSnackBarSuccess(data["message"]);
        }
        
        switch (typeUser) {
          case 'Teacher':
            NavigationService.instance.navigateToReplacement('dashboard_teacher');
            break;
          case 'Parent':
            NavigationService.instance.navigateToReplacement('dashboard_parent');
            break;
          case 'Administrative':
            NavigationService.instance.navigateToReplacement('dashboard_admin');
            break;
          case 'Student':
            NavigationService.instance.navigateToReplacement('annees');
            break;
          default:
            NavigationService.instance.navigateToReplacement('annees');
        }
      } else {
        AuthenticationProvider.instance.status = AuthenticationStatus.Error;
        if (context.mounted) {
          SnackBarService.instance.showSnackBarError(data["message"] ?? "Erreur de connexion");
        }
      }
    } catch (e) {
      print("Login Error: $e");
      AuthenticationProvider.instance.status = AuthenticationStatus.Error;
      if (context.mounted) {
        SnackBarService.instance.showSnackBarError("Erreur : $e");
      }
    }
    AuthenticationProvider.instance.notify();
  }

  void logout(BuildContext context) async {
    LoadingIndicatorDialog().show(
      context,
      text: AppLocalizations.of(context)!.logging_out,
    );
    bool expired = await FlutterSessionJwt.isTokenExpired();
    if (expired == true) {
      SnackBarService.instance.showSnackBarError(
        AppLocalizations.of(context)!.session_expired,
      );
    }
    await FlutterSessionJwt.deleteToken();
    AuthenticationProvider.instance.setupLogoutvalues();
    LoadingIndicatorDialog().dismiss();
    NavigationService.instance.navigateToReplacement('');
  }
}
