import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:eschoolmobile/models/classe.dart';
import 'package:eschoolmobile/models/eleve.dart';
import 'package:eschoolmobile/models/utilisateur.dart';
import 'package:http/http.dart' as http;
import 'package:eschoolmobile/providers/account_creation_provider.dart';
import 'package:eschoolmobile/providers/authentication_provider.dart';
import 'package:eschoolmobile/providers/classes_provider.dart';
import 'package:eschoolmobile/services/utilisateur_service.dart';
import 'package:eschoolmobile/utils/theme/constantes/other_constantes.dart';
import 'package:flutter_session_jwt/flutter_session_jwt.dart';

class EleveService {
  static EleveService instance = EleveService();
  EleveService();
  Future<List<Eleve>> fetchEleves(BuildContext context) async {
    List<Eleve> eleves = [];
    bool expired = await FlutterSessionJwt.isTokenExpired();
    if (expired) {
      if (context.mounted) {
        UtilisateurService.instance.logout(context);
      }
      return [];
    }
    http.Response response = await http.get(
      Uri.parse(
        "${OtherConstantes.baseUrl}personnel/eleves/${AccountCreationProvider.instance.anneeScolaire!.id}/${ClassesProvider.instance.classe != null ? ClassesProvider.instance.classe!.id : 0}",
      ),
      headers: {
        "Authorization": "Bearer ${AuthenticationProvider.instance.token}",
      },
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      for (var d in data) {
        eleves.add(
          Eleve(
            d['id_eleve_id'],
            d['nom'],
            d['prenom'],
            Classe(
              d["id_classe_id"],
              d["classe_id"],
              d['classe'],
              d['id_annee_id'],
              d['annee'],
              d['id_classe_cycle_id'],
              d['cycle'],
              d['id_campus_id'],
              d['campus'],
            ),
            adresse: "Commune ${d['commune'] ?? ''}, zone ${d['zone'] ?? ''}",
            papa: Utilisateur(
              0,
              d['nom_pere'] ?? '',
              d['prenom_pere'] ?? '',
              d['telephone'] ?? '',
              "",
              "",
              "",
              "",
              "",
              "",
            ),
            maman: Utilisateur(
              0,
              d['nom_meere'] ?? '',
              d['prenom_mere'] ?? '',
              d['telephone'] ?? '',
              "",
              "",
              "",
              "",
              "",
              "",
            ),
          ),
        );
      }
    } else {}
    return eleves;
  }
}
