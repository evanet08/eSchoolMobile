import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:eschoolmobile/providers/authentication_provider.dart';
import 'package:eschoolmobile/utils/theme/constantes/other_constantes.dart';
import 'package:flutter_session_jwt/flutter_session_jwt.dart';
import 'package:eschoolmobile/services/utilisateur_service.dart';

class ParentService {
  static ParentService instance = ParentService();

  Future<List<Map<String, dynamic>>> fetchEnfants(BuildContext context) async {
    bool expired = await FlutterSessionJwt.isTokenExpired();
    if (expired) {
      if (context.mounted) UtilisateurService.instance.logout(context);
      return [];
    }
    try {
      final response = await http.get(
        Uri.parse("${OtherConstantes.baseUrl}parent/enfants"),
        headers: {
          "Authorization": "Bearer ${AuthenticationProvider.instance.token}",
        },
      );
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      }
    } catch (e) {
      debugPrint("Error fetching enfants: $e");
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> fetchEnfantNotes(
    BuildContext context,
    int idEleve,
  ) async {
    bool expired = await FlutterSessionJwt.isTokenExpired();
    if (expired) {
      if (context.mounted) UtilisateurService.instance.logout(context);
      return [];
    }
    try {
      final response = await http.get(
        Uri.parse("${OtherConstantes.baseUrl}parent/enfant/$idEleve/notes"),
        headers: {
          "Authorization": "Bearer ${AuthenticationProvider.instance.token}",
        },
      );
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      }
    } catch (e) {
      debugPrint("Error fetching notes: $e");
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> fetchEnfantEvaluations(
    BuildContext context,
    int idEleve,
  ) async {
    bool expired = await FlutterSessionJwt.isTokenExpired();
    if (expired) {
      if (context.mounted) UtilisateurService.instance.logout(context);
      return [];
    }
    try {
      final response = await http.get(
        Uri.parse(
          "${OtherConstantes.baseUrl}parent/enfant/$idEleve/evaluations",
        ),
        headers: {
          "Authorization": "Bearer ${AuthenticationProvider.instance.token}",
        },
      );
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      }
    } catch (e) {
      debugPrint("Error fetching evaluations: $e");
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> fetchEnfantCours(
    BuildContext context,
    int idEleve,
  ) async {
    bool expired = await FlutterSessionJwt.isTokenExpired();
    if (expired) {
      if (context.mounted) UtilisateurService.instance.logout(context);
      return [];
    }
    try {
      final response = await http.get(
        Uri.parse("${OtherConstantes.baseUrl}parent/enfant/$idEleve/cours"),
        headers: {
          "Authorization": "Bearer ${AuthenticationProvider.instance.token}",
        },
      );
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      }
    } catch (e) {
      debugPrint("Error fetching cours: $e");
    }
    return [];
  }

  Future<Map<String, dynamic>?> fetchEnfantBulletin(
    BuildContext context,
    int idEleve,
  ) async {
    bool expired = await FlutterSessionJwt.isTokenExpired();
    if (expired) {
      if (context.mounted) UtilisateurService.instance.logout(context);
      return null;
    }
    try {
      final response = await http.get(
        Uri.parse("${OtherConstantes.baseUrl}parent/enfant/$idEleve/bulletin"),
        headers: {
          "Authorization": "Bearer ${AuthenticationProvider.instance.token}",
        },
      );
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(json.decode(response.body));
      }
    } catch (e) {
      debugPrint("Error fetching bulletin: $e");
    }
    return null;
  }
}
