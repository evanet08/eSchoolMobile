import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:eschoolmobile/models/creneau.dart';
import 'package:eschoolmobile/models/creneaux_journalier.dart';
import 'package:http/http.dart' as http;
import 'package:eschoolmobile/providers/account_creation_provider.dart';
import 'package:eschoolmobile/providers/authentication_provider.dart';
import 'package:eschoolmobile/providers/classes_provider.dart';
import 'package:eschoolmobile/providers/eleves_provider.dart';
import 'package:eschoolmobile/services/utilisateur_service.dart';
import 'package:eschoolmobile/utils/theme/constantes/other_constantes.dart';
import 'package:flutter_session_jwt/flutter_session_jwt.dart';

class CreneauService {
  static CreneauService instance = CreneauService();
  CreneauService();
  Future<List<Creneau>> fetchCreneaux(BuildContext context) async {
    List<Creneau> creneaux = [];
    bool expired = await FlutterSessionJwt.isTokenExpired();
    if (expired) {
      if (context.mounted) {
        UtilisateurService.instance.logout(context);
      }
      return [];
    }
    http.Response response = await http.get(
      Uri.parse(
        AccountCreationProvider.instance.typeUser == "Teacher"
            ? "${OtherConstantes.baseUrl}personnel/creneaux_classes_enseignant/${AccountCreationProvider.instance.anneeScolaire!.id}/${ClassesProvider.instance.classe != null ? ClassesProvider.instance.classe!.id : 0}/${ClassesProvider.instance.cours != null ? ClassesProvider.instance.cours!.id : 0}"
            : "${OtherConstantes.baseUrl}personnel/creneaux_eleve/${AccountCreationProvider.instance.anneeScolaire!.id}/${EleveProvider.instance.eleve!.id}/${ClassesProvider.instance.cours != null ? ClassesProvider.instance.cours!.id : 0}",
      ),
      headers: {
        "Authorization": "Bearer ${AuthenticationProvider.instance.token}",
      },
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      for (var d in data) {
        creneaux.add(
          Creneau(
            d['id_horaire'],
            d['id_classe_id'],
            d['id_cours_id'],
            d['id_annee_id'],
            d['id_cycle_id'],
            d['id_campus_id'],
            d['jour'],
            d['debut'],
            d['fin'],
            d['cours'],
            d['classe'],
            d['annee'],
            d['cycle'],
            d['campus'],
            groupe: d['groupe'],
          ),
        );
      }
    } else {}
    return creneaux;
  }

  Future<List<CreneauxJournalier>> fetchCreneauxJournaliers(
    BuildContext context,
  ) async {
    List<Creneau> creneaux = await fetchCreneaux(context);
    List<Creneau> creneauxJr = [];
    List<CreneauxJournalier> creneauxJournaliers = [];

    CreneauxJournalier? creneauxJournalier;
    for (var (i, creneau) in creneaux.indexed) {
      if (creneauxJournalier != null &&
          creneauxJournalier.jour != creneau.jour) {
        creneauxJournalier.creneaux.addAll(creneauxJr);
        creneauxJournaliers.add(creneauxJournalier);
        creneauxJr.clear();
      }
      creneauxJournalier = CreneauxJournalier(creneau.jour, []);
      if (!creneauxJr.contains(creneau)) {
        creneauxJr.add(creneau);
      }
      if (i == creneaux.length - 1) {
        creneauxJournalier.creneaux.addAll(creneauxJr);
        creneauxJournaliers.add(creneauxJournalier);
        creneauxJr.clear();
      }
    }
    return creneauxJournaliers;
  }
}
