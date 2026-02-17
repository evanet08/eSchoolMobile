import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:eschoolmobile/models/cours.dart';
import 'package:http/http.dart' as http;
import 'package:eschoolmobile/providers/account_creation_provider.dart';
import 'package:eschoolmobile/providers/authentication_provider.dart';
import 'package:eschoolmobile/providers/classes_provider.dart';
import 'package:eschoolmobile/providers/eleves_provider.dart';
import 'package:eschoolmobile/services/utilisateur_service.dart';
import 'package:eschoolmobile/utils/theme/constantes/other_constantes.dart';
import 'package:flutter_session_jwt/flutter_session_jwt.dart';

class CoursService {
  static CoursService instance = CoursService();
  CoursService();

  Future<List<Cours>> fetchCours(BuildContext context) async {
    List<Cours> cours = [];
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
            ? "${OtherConstantes.baseUrl}personnel/attributions_cours_enseignant/${AccountCreationProvider.instance.anneeScolaire!.id}/${ClassesProvider.instance.classe != null ? ClassesProvider.instance.classe!.id : 0}"
            : "${OtherConstantes.baseUrl}personnel/cours_eleve/${AccountCreationProvider.instance.anneeScolaire!.id}/${EleveProvider.instance.eleve != null ? EleveProvider.instance.eleve!.id : 0}",
      ),
      headers: {
        "Authorization": "Bearer ${AuthenticationProvider.instance.token}",
      },
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      for (var d in data) {
        cours.add(
          Cours(
            d['id_cours_id'],
            d['cours_id'],
            d['cours'],
            AccountCreationProvider.instance.typeUser == "Teacher"
                ? d['cm']
                : 0,
            AccountCreationProvider.instance.typeUser == "Teacher"
                ? d['td']
                : 0,
            AccountCreationProvider.instance.typeUser == "Teacher"
                ? d['tp']
                : 0,
            AccountCreationProvider.instance.typeUser == "Teacher"
                ? d['tpe']
                : 0,
            AccountCreationProvider.instance.typeUser == "Teacher"
                ? d['ponderation']
                : 0,
            AccountCreationProvider.instance.typeUser == "Teacher"
                ? d['id_annee_id']
                : 0,
            AccountCreationProvider.instance.typeUser == "Teacher"
                ? d['annee']
                : "",
            AccountCreationProvider.instance.typeUser == "Teacher"
                ? d['id_cycle_id']
                : 0,
            AccountCreationProvider.instance.typeUser == "Teacher"
                ? d['cycle']
                : "",
            AccountCreationProvider.instance.typeUser == "Teacher"
                ? d['id_campus_id']
                : 0,
            AccountCreationProvider.instance.typeUser == "Teacher"
                ? d['campus']
                : "",
          ),
        );
      }
      ClassesProvider.instance.courses = cours;
    } else {}
    return cours;
  }
}
