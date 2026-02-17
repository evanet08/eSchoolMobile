import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_jwt/flutter_session_jwt.dart';
import 'package:eschoolmobile/helpers.dart';
import 'package:eschoolmobile/models/appel.dart';
import 'package:eschoolmobile/models/classe.dart';
import 'package:eschoolmobile/models/conduite.dart';
import 'package:eschoolmobile/models/creneau.dart';
import 'package:eschoolmobile/models/eleve.dart';
import 'package:eschoolmobile/models/evaluation.dart';
import 'package:eschoolmobile/models/utilisateur.dart';
import 'package:eschoolmobile/providers/account_creation_provider.dart';
import 'package:eschoolmobile/providers/authentication_provider.dart';
import 'package:eschoolmobile/providers/classes_provider.dart';
import 'package:eschoolmobile/providers/eleves_provider.dart';
import 'package:eschoolmobile/services/utilisateur_service.dart';
import 'package:http/http.dart' as http;
import 'package:eschoolmobile/utils/theme/constantes/other_constantes.dart';

class RapportService {
  static RapportService instance = RapportService();
  RapportService();
  Future<Map<String, dynamic>> fetchRapports(
    BuildContext context,
    String debut,
    String fin,
  ) async {
    Map<String, dynamic> rapports = {};
    List<Evaluation> evaluations = [];
    List<Appel> presences = [];
    List<Conduite> conduites = [];
    bool expired = await FlutterSessionJwt.isTokenExpired();
    if (expired) {
      if (context.mounted) {
        UtilisateurService.instance.logout(context);
      }
      return rapports;
    }

    http.Response response = await http.get(
      Uri.parse(
        "${OtherConstantes.baseUrl}personnel/rapports_periodique/${EleveProvider.instance.eleve != null ? EleveProvider.instance.eleve!.id : 0}/${ClassesProvider.instance.cours != null ? ClassesProvider.instance.cours!.id : 0}/$debut/$fin/${AccountCreationProvider.instance.anneeScolaire!.id}",
      ),
      headers: {
        "Authorization": "Bearer ${AuthenticationProvider.instance.token}",
      },
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var dataEval = data['evaluations'];
      var dataCond = data['conduites'];
      var dataPres = data['presences'];

      for (var d in dataEval) {
        evaluations.add(
          Evaluation(
            d['id_evaluation'],
            d['id_classe_active_id'],
            d['id_cours_classe_id'],
            d['id_periode_id'],
            d['id_trimestre_id'],
            d['id_session_id'],
            d['id_type_note_id'],
            d['classe'],
            d['cours'],
            d['type_evaluation'],
            d['periode'],
            d['trimestre'],
            d['session'],
            d['ponderer_eval'],
            d['date_eval'],
            d['date_soumission'],
            d['contenu_evaluation'],
          ),
        );
      }

      for (var d in dataCond) {
        conduites.add(
          Conduite(
            d['id_eleve_conduite'],
            Creneau(
              d['id_horaire_id'],
              d['id_classe_id'],
              0,
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
            ),
            Helpers.convertEndateToFrdate(d['date_enregistrement']),
            Eleve(
              d['id_eleve_id'],
              d['nom'],
              d['prenom'],
              Classe(
                d['id_classe_id'],
                0,
                d['classe'],
                d['id_annee_id'],
                d['annee'],
                d['id_cycle_id'],
                d['cycle'],
                d['id_campus_id'],
                d['campus'],
              ),
            ),
            mention: d['quote'],
            motif: d['motif'],
          ),
        );
      }

      for (var d in dataPres) {
        presences.add(
          Appel(
            Creneau(
              d['id_horaire_id'],
              d['id_classe'],
              d['id_cours'],
              d['id_annee'],
              d['id_cycle'],
              d['id_campus'],
              d['jour'],
              d['debut'],
              d['fin'],
              d['cours'],
              d['classe'],
              d['annee'],
              d['cycle'],
              d['campus'],
            ),
            Eleve(
              d['id_eleve_id'],
              d['nom'],
              d['prenom'],
              Classe(
                d['id_classe'],
                0,
                d['classe'],
                d['id_annee'],
                d['annee'],
                d['id_cycle'],
                d['cycle'],
                d['id_campus'],
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
            "",
            estPresent: d['present_ou_absent'] == 1 ? true : false,
          ),
        );
      }
      rapports['evaluations'] = evaluations;
      rapports['conduites'] = conduites;
      rapports['presences'] = presences;
    } else {}
    return rapports;
  }
}
