import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:eschoolmobile/custom_widgets/loading_indicator_dialog.dart';
import 'package:eschoolmobile/models/appel.dart';
import 'package:eschoolmobile/models/classe.dart';
import 'package:eschoolmobile/models/creneau.dart';
import 'package:eschoolmobile/models/eleve.dart';
import 'package:eschoolmobile/models/utilisateur.dart';
import 'package:http/http.dart' as http;
import 'package:eschoolmobile/providers/account_creation_provider.dart';
import 'package:eschoolmobile/providers/authentication_provider.dart';
import 'package:eschoolmobile/providers/classes_provider.dart';
import 'package:eschoolmobile/services/snackbar_service.dart';
import 'package:eschoolmobile/services/utilisateur_service.dart';
import 'package:eschoolmobile/utils/theme/constantes/other_constantes.dart';
import 'package:eschoolmobile/l10n/app_localizations.dart';
import 'package:flutter_session_jwt/flutter_session_jwt.dart';

class PresenceService {
  static PresenceService instance = PresenceService();
  PresenceService();
  Future<int> enregistrerPresences(
    BuildContext context,
    List<Appel> appels,
  ) async {
    bool expired = await FlutterSessionJwt.isTokenExpired();
    if (expired) {
      if (context.mounted) {
        UtilisateurService.instance.logout(context);
      }
      return -1;
    }
    LoadingIndicatorDialog().show(
      context,
      text: AppLocalizations.of(context)!.wait,
    );
    List<dynamic> apps = [];
    for (var app in appels) {
      apps.add({
        'est_present': app.estPresent ? 1 : 0,
        'id_eleve': app.eleve.id,
        'id_creneau': app.creneau.id,
      });
    }
    http.Response response = await http.post(
      Uri.parse("${OtherConstantes.baseUrl}/personnel/enregistrer_presences"),
      body: jsonEncode(apps),
    );
    LoadingIndicatorDialog().dismiss();
    var data = jsonDecode(response.body);
    if (response.statusCode == 201) {
      if (context.mounted) {
        SnackBarService.instance.showSnackBarSuccess(data['message']);
      }
    } else {
      if (context.mounted) {
        SnackBarService.instance.showSnackBarError(data['message']);
      }
    }
    return response.statusCode;
  }

  Future<List<Appel>> fetchAppels(Creneau creneau) async {
    List<Appel> appels = [];
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
        appels.add(
          Appel(
            creneau,
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
            "",
          ),
        );
      }
    } else {}
    return appels;
  }

  Future<List<Appel>> fetchPresences(Creneau creneau) async {
    List<Appel> presences = [];
    http.Response response = await http.get(
      Uri.parse("${OtherConstantes.baseUrl}personnel/presences/${creneau.id}"),
      headers: {
        "Authorization": "Bearer ${AuthenticationProvider.instance.token}",
      },
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      for (var d in data) {
        presences.add(
          Appel(
            creneau,
            Eleve(
              d['id_eleve_id'],
              d['nom'],
              d['prenom'],
              Classe(
                creneau.idClasse,
                0,
                creneau.classe,
                creneau.idAnnee,
                creneau.annee,
                creneau.idCycle,
                creneau.cycle,
                creneau.idCampus,
                creneau.campus,
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
    } else {}
    return presences;
  }

  Future<int> toogglePresenceStatus(int idCreneau, int idEleve) async {
    http.Response response = await http.get(
      Uri.parse(
        "${OtherConstantes.baseUrl}personnel/toggle_presence/$idCreneau/$idEleve",
      ),
      headers: {
        "Authorization": "Bearer ${AuthenticationProvider.instance.token}",
      },
    );
    var data = json.decode(response.body);
    if (response.statusCode == 201) {
      SnackBarService.instance.showSnackBarSuccess(data['message']);
    } else {
      SnackBarService.instance.showSnackBarError(data['message']);
    }
    return response.statusCode;
  }
}
