import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session_jwt/flutter_session_jwt.dart';
import 'package:eschoolmobile/custom_widgets/loading_indicator_dialog.dart';
import 'package:eschoolmobile/helpers.dart';
import 'package:eschoolmobile/models/classe.dart';
import 'package:eschoolmobile/models/conduite.dart';
import 'package:eschoolmobile/models/creneau.dart';
import 'package:eschoolmobile/models/eleve.dart';
import 'package:eschoolmobile/providers/account_creation_provider.dart';
import 'package:eschoolmobile/providers/authentication_provider.dart';
import 'package:eschoolmobile/providers/classes_provider.dart';
import 'package:eschoolmobile/providers/eleves_provider.dart';
import 'package:eschoolmobile/services/snackbar_service.dart';
import 'package:eschoolmobile/services/utilisateur_service.dart';
import 'package:http/http.dart' as http;
import 'package:eschoolmobile/utils/theme/constantes/other_constantes.dart';
import 'package:eschoolmobile/l10n/app_localizations.dart';

class ConduiteService {
  static ConduiteService instance = ConduiteService();
  ConduiteService();
  Future<List<Conduite>> fetchConduites(BuildContext context) async {
    List<Conduite> conduites = [];
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
            ? "${OtherConstantes.baseUrl}personnel/conduites/${AccountCreationProvider.instance.anneeScolaire!.id}/${ClassesProvider.instance.classe != null ? ClassesProvider.instance.classe!.id : 0}"
            : "${OtherConstantes.baseUrl}personnel/conduites_eleve/${AccountCreationProvider.instance.anneeScolaire!.id}/${EleveProvider.instance.eleve != null ? EleveProvider.instance.eleve!.id : 0}/${ClassesProvider.instance.cours != null ? ClassesProvider.instance.cours!.id : 0}",
      ),
      headers: {
        "Authorization": "Bearer ${AuthenticationProvider.instance.token}",
      },
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      for (var d in data) {
        conduites.add(
          Conduite(
            d['id_eleve_conduite'],
            Creneau(
              d['id_horaire_id'],
              d['id_classe_id'],
              d['cours_id'],
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
    } else {}
    return conduites;
  }

  Future<bool> enregistrerConduite(
    BuildContext context,
    Conduite conduite,
    int idPeriode,
    int idTrimestre,
  ) async {
    if (context.mounted) {
      LoadingIndicatorDialog().show(
        context,
        text: AppLocalizations.of(context)!.wait,
      );
    }

    bool expired = await FlutterSessionJwt.isTokenExpired();
    if (expired) {
      if (context.mounted) {
        UtilisateurService.instance.logout(context);
      }
      return false;
    }

    http.Response response = await http.post(
      Uri.parse("${OtherConstantes.baseUrl}personnel/enregistrer_conduite"),
      body: jsonEncode({
        "motif": conduite.motif,
        "quote": conduite.mention,
        "id_annee": AccountCreationProvider.instance.anneeScolaire!.id,
        "id_campus": ClassesProvider.instance.classe!.idCampus,
        "id_classe": ClassesProvider.instance.classe!.id,
        "id_cycle": ClassesProvider.instance.classe!.idCycle,
        "id_eleve": conduite.eleve.id,
        "id_creneau": conduite.creneau.id,
        "id_periode": idPeriode,
        "id_trimestre": idTrimestre,
      }),
    );

    if (context.mounted) {
      LoadingIndicatorDialog().dismiss();
    }

    if (response.statusCode == 201) {
      SnackBarService.instance.showSnackBarSuccess(
        jsonDecode(response.body)["message"],
      );
      return true;
    }
    if (context.mounted) {
      SnackBarService.instance.showSnackBarError(
        jsonDecode(response.body)["message"],
      );
    }
    return false;
  }
}
