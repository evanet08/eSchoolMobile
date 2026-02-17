import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:eschoolmobile/models/annee.dart';
import 'package:eschoolmobile/models/classe.dart';
import 'package:http/http.dart' as http;
import 'package:eschoolmobile/providers/account_creation_provider.dart';
import 'package:eschoolmobile/providers/authentication_provider.dart';
import 'package:eschoolmobile/services/utilisateur_service.dart';
import 'package:eschoolmobile/utils/theme/constantes/other_constantes.dart';
import 'package:flutter_session_jwt/flutter_session_jwt.dart';

class ClasseService {
  static ClasseService instance = ClasseService();
  ClasseService();

  Future<List<Classe>> fetchClasses(BuildContext context) async {
    List<Classe> classes = [];
    bool expired = await FlutterSessionJwt.isTokenExpired();
    if (expired) {
      if (context.mounted) {
        UtilisateurService.instance.logout(context);
      }
      return [];
    }
    http.Response response = await http.get(
      Uri.parse(
        "${OtherConstantes.baseUrl}personnel/attributions_cours_enseignant/${AccountCreationProvider.instance.anneeScolaire!.id}/0",
      ),
      headers: {
        "Authorization": "Bearer ${AuthenticationProvider.instance.token}",
      },
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      for (var d in data) {
        if (classes.isNotEmpty) {
          bool exist = false;
          for (var c in classes) {
            if (c.id == d["id_classe_id"]) {
              exist = true;
              break;
            }
          }
          if (!exist) {
            classes.add(
              Classe(
                d["id_classe_id"],
                d["classe_id"],
                d['classe'],
                d['id_annee_id'],
                d['annee'],
                d['id_cycle_id'],
                d['cycle'],
                d['id_campus_id'],
                d['campus'],
              ),
            );
          }
        } else {
          classes.add(
            Classe(
              d["id_classe_id"],
              d["classe_id"],
              d['classe'],
              d['id_annee_id'],
              d['annee'],
              d['id_cycle_id'],
              d['cycle'],
              d['id_campus_id'],
              d['campus'],
            ),
          );
        }
      }
    } else {}
    return classes;
  }

  Future<List<Annee>> fetchAnneesScolaires(BuildContext context) async {
    List<Annee> annees = [];
    bool expired = await FlutterSessionJwt.isTokenExpired();
    if (expired) {
      if (context.mounted) {
        UtilisateurService.instance.logout(context);
      }
      return [];
    }
    http.Response response = await http.get(
      Uri.parse("${OtherConstantes.baseUrl}annees_scolaires"),
      headers: {
        "Authorization": "Bearer ${AuthenticationProvider.instance.token}",
      },
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      for (var an in data) {
        annees.add(
          Annee(
            an['id_annee'],
            an['annee'],
            an['etat_annee'],
            an['date_ouverture'],
            an['date_cloture'],
          ),
        );
      }
    }
    AccountCreationProvider.instance.annees = annees;
    return annees;
  }
}
