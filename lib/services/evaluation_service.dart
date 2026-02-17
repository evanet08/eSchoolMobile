import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_session_jwt/flutter_session_jwt.dart';
import 'package:eschoolmobile/custom_widgets/loading_indicator_dialog.dart';
import 'package:eschoolmobile/helpers.dart';
import 'package:eschoolmobile/models/eleve.dart';
import 'package:eschoolmobile/models/evaluation.dart';
import 'package:eschoolmobile/models/note.dart';
import 'package:eschoolmobile/models/periode.dart';
import 'package:eschoolmobile/models/session.dart';
import 'package:eschoolmobile/models/trimestre.dart';
import 'package:eschoolmobile/models/type_evaluation.dart';
import 'package:eschoolmobile/providers/account_creation_provider.dart';
import 'package:eschoolmobile/providers/authentication_provider.dart';
import 'package:eschoolmobile/providers/classes_provider.dart';
import 'package:eschoolmobile/providers/eleves_provider.dart';
import 'package:eschoolmobile/services/eleve_service.dart';
import 'package:eschoolmobile/services/navigation_service.dart';
import 'package:eschoolmobile/services/snackbar_service.dart';
import 'package:eschoolmobile/services/utilisateur_service.dart';
import 'package:http/http.dart' as http;
import 'package:eschoolmobile/utils/theme/constantes/other_constantes.dart';
import 'package:eschoolmobile/l10n/app_localizations.dart';

class EvaluationService {
  static EvaluationService instance = EvaluationService();
  EvaluationService();

  Future<List<Evaluation>> fetchEvaluations(BuildContext context) async {
    List<Evaluation> evaluations = [];
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
            ? "${OtherConstantes.baseUrl}personnel/evaluations/${AccountCreationProvider.instance.anneeScolaire!.id}/${ClassesProvider.instance.classe != null ? ClassesProvider.instance.classe!.id : 0}/${ClassesProvider.instance.cours != null ? ClassesProvider.instance.cours!.id : 0}"
            : "${OtherConstantes.baseUrl}personnel/evaluations_eleve/${AccountCreationProvider.instance.anneeScolaire!.id}/${EleveProvider.instance.eleve != null ? EleveProvider.instance.eleve!.id : 0}/${ClassesProvider.instance.cours != null ? ClassesProvider.instance.cours!.id : 0}",
      ),
      headers: {
        "Authorization": "Bearer ${AuthenticationProvider.instance.token}",
      },
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      for (var d in data) {
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
    } else {}
    return evaluations;
  }

  Future<List<TypeEvaluation>> fetchTypesEvaluations(
    BuildContext context,
  ) async {
    List<TypeEvaluation> typesEvaluations = [];
    bool expired = await FlutterSessionJwt.isTokenExpired();
    if (expired) {
      if (context.mounted) {
        UtilisateurService.instance.logout(context);
      }
      return [];
    }
    http.Response response = await http.get(
      Uri.parse("${OtherConstantes.baseUrl}personnel/types_evaluations"),
      headers: {
        "Authorization": "Bearer ${AuthenticationProvider.instance.token}",
      },
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      for (var d in data) {
        typesEvaluations.add(TypeEvaluation(d['id_type_note'], d['type']));
      }
    } else {}
    return typesEvaluations;
  }

  Future<List<Trimestre>> fetchTrimestres(BuildContext context) async {
    List<Trimestre> trimestres = [];
    bool expired = await FlutterSessionJwt.isTokenExpired();
    if (expired) {
      if (context.mounted) {
        UtilisateurService.instance.logout(context);
      }
      return [];
    }
    http.Response response = await http.get(
      Uri.parse("${OtherConstantes.baseUrl}personnel/trimestres"),
      headers: {
        "Authorization": "Bearer ${AuthenticationProvider.instance.token}",
      },
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      for (var d in data) {
        trimestres.add(Trimestre(d['id_trimestre'], d['trimestre']));
      }
    } else {}
    return trimestres;
  }

  Future<List<Periode>> fetchPeriodes(BuildContext context) async {
    List<Periode> periodes = [];
    bool expired = await FlutterSessionJwt.isTokenExpired();
    if (expired) {
      if (context.mounted) {
        UtilisateurService.instance.logout(context);
      }
      return [];
    }
    http.Response response = await http.get(
      Uri.parse("${OtherConstantes.baseUrl}personnel/periodes"),
      headers: {
        "Authorization": "Bearer ${AuthenticationProvider.instance.token}",
      },
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      for (var d in data) {
        periodes.add(Periode(d['id_periode'], d['periode']));
      }
    } else {}
    return periodes;
  }

  Future<List<Session>> fetchSessions(BuildContext context) async {
    List<Session> sessions = [];
    bool expired = await FlutterSessionJwt.isTokenExpired();
    if (expired) {
      if (context.mounted) {
        UtilisateurService.instance.logout(context);
      }
      return [];
    }
    http.Response response = await http.get(
      Uri.parse("${OtherConstantes.baseUrl}personnel/sessions"),
      headers: {
        "Authorization": "Bearer ${AuthenticationProvider.instance.token}",
      },
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      for (var d in data) {
        sessions.add(Session(d['id_session'], d['session']));
      }
    } else {}
    return sessions;
  }

  Future<List<Note>> fetchElevesForNotes(
    BuildContext context,
    Evaluation evaluation,
  ) async {
    List<Note> notes = [];
    List<Eleve> eleves = await EleveService.instance.fetchEleves(context);
    for (var eleve in eleves) {
      notes.add(
        Note(
          0,
          evaluation.id,
          evaluation.ponderation,
          eleve.id,
          evaluation.idClasse,
          evaluation.idCours,
          evaluation.idPeriode,
          evaluation.idTrimestre,
          evaluation.idSession,
          evaluation.idTypeEvaluation,
          -1,
          "${eleve.noms} ${eleve.prenom}",
          evaluation.classe,
          evaluation.cours,
          evaluation.typeEvaluation,
          evaluation.periode,
          evaluation.trimestre,
          evaluation.session,
          Helpers.convertDateToString(DateTime.now(), 'dd/MM/YYYY'),
        ),
      );
    }
    return notes;
  }

  Future<List<Note>> fetchNotes(BuildContext context, int idEvaluation) async {
    List<Note> notes = [];
    bool expired = await FlutterSessionJwt.isTokenExpired();
    if (expired) {
      if (context.mounted) {
        UtilisateurService.instance.logout(context);
      }
      return [];
    }
    http.Response response = await http.get(
      Uri.parse(
        "${OtherConstantes.baseUrl}personnel/afficher_notes_evaluation/$idEvaluation",
      ),
      headers: {
        "Authorization": "Bearer ${AuthenticationProvider.instance.token}",
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      for (var d in data) {
        notes.add(
          Note(
            d['id_note'],
            d['id_evaluation_id'],
            d['ponderation'],
            d['id_eleve_id'],
            d['id_classe_active_id'],
            d['id_cours_classe_id'],
            d['id_periode_id'],
            d['id_trimestre_id'],
            d['id_session_id'],
            d['id_type_note_id'],
            double.parse(d['note']),
            "${d['nom']} ${d['prenom']}",
            d['classe'],
            d['cours'],
            d['type_note'],
            d['periode'],
            d['trimestre'],
            d['session'],
            d['date_saisie'],
          ),
        );
      }
    } else {}
    return notes;
  }

  void addEvaluation(BuildContext context, Evaluation evaluation) async {
    bool expired = await FlutterSessionJwt.isTokenExpired();
    if (expired) {
      if (context.mounted) {
        UtilisateurService.instance.logout(context);
      }
    }
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("${OtherConstantes.baseUrl}personnel/enregistrer_evaluation"),
    );
    request.headers['Authorization'] =
        "Bearer ${AuthenticationProvider.instance.token}";

    if (context.mounted) {
      LoadingIndicatorDialog().show(
        context,
        text: AppLocalizations.of(context)!.wait,
      );
    }
    request.fields['ponderation'] = "${evaluation.ponderation}";
    request.fields['date_remise'] = "${evaluation.dateRemise}";
    request.fields['date_evaluation'] = evaluation.dateEvaluation;
    request.fields['id_annee'] =
        "${AccountCreationProvider.instance.anneeScolaire!.id}";
    request.fields['id_classe'] = "${evaluation.idClasse}";
    request.fields['id_cours'] = "${evaluation.idCours}";
    request.fields['id_type_evaluation'] = "${evaluation.idTypeEvaluation}";
    request.fields['id_periode'] = "${evaluation.idPeriode}";
    request.fields['id_trimestre'] = "${evaluation.idTrimestre}";
    request.fields['id_session'] = "${evaluation.idSession}";
    request.fields['id_cycle'] = "${ClassesProvider.instance.classe!.idCycle}";
    request.fields['id_campus'] =
        "${ClassesProvider.instance.classe!.idCampus}";

    request.files.add(
      await http.MultipartFile.fromPath(
        'questionnaire',
        evaluation.contenuEvaluation,
      ),
    );
    var response = await request.send();
    if (response.statusCode == 201) {
      if (context.mounted) {
        LoadingIndicatorDialog().dismiss();
        var res = await http.Response.fromStream(response);
        SnackBarService.instance.showSnackBarSuccess(
          jsonDecode(res.body)["message"],
        );
        NavigationService.instance.goBack();
      }
      return;
    }
    if (context.mounted) {
      LoadingIndicatorDialog().dismiss();
      var res = await http.Response.fromStream(response);
      SnackBarService.instance.showSnackBarError(
        jsonDecode(res.body)["message"],
      );
    }
  }

  void updateEvaluation(
    BuildContext context,
    Evaluation evaluation,
    File? file,
  ) async {
    bool expired = await FlutterSessionJwt.isTokenExpired();
    if (expired) {
      if (context.mounted) {
        UtilisateurService.instance.logout(context);
      }
    }
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        "${OtherConstantes.baseUrl}personnel/modifier_evaluation/${evaluation.id}",
      ),
    );
    request.headers['Authorization'] =
        "Bearer ${AuthenticationProvider.instance.token}";

    if (context.mounted) {
      LoadingIndicatorDialog().show(
        context,
        text: AppLocalizations.of(context)!.wait,
      );
    }
    request.fields['ponderation'] = "${evaluation.ponderation}";
    request.fields['date_remise'] = "${evaluation.dateRemise}";
    request.fields['date_evaluation'] = evaluation.dateEvaluation;
    request.fields['id_classe'] = "${evaluation.idClasse}";
    request.fields['id_cours'] = "${evaluation.idCours}";
    request.fields['id_type_evaluation'] = "${evaluation.idTypeEvaluation}";
    request.fields['id_periode'] = "${evaluation.idPeriode}";
    request.fields['id_trimestre'] = "${evaluation.idTrimestre}";
    request.fields['id_session'] = "${evaluation.idSession}";
    request.fields['id_cycle'] = "${ClassesProvider.instance.classe!.idCycle}";
    request.fields['id_campus'] =
        "${ClassesProvider.instance.classe!.idCampus}";

    if (file != null) {
      request.files.add(
        await http.MultipartFile.fromPath('questionnaire', file.path),
      );
    }

    var response = await request.send();
    if (response.statusCode == 201) {
      if (context.mounted) {
        LoadingIndicatorDialog().dismiss();
        var res = await http.Response.fromStream(response);
        SnackBarService.instance.showSnackBarSuccess(
          jsonDecode(res.body)["message"],
        );
        NavigationService.instance.goBack();
      }

      return;
    }
    if (context.mounted) {
      LoadingIndicatorDialog().dismiss();
      var res = await http.Response.fromStream(response);
      SnackBarService.instance.showSnackBarError(
        jsonDecode(res.body)["message"],
      );
    }
  }

  Future<bool> deleteEvaluation(
    BuildContext context,
    Evaluation evaluation,
  ) async {
    bool expired = await FlutterSessionJwt.isTokenExpired();
    if (expired) {
      if (context.mounted) {
        UtilisateurService.instance.logout(context);
      }
    }
    if (context.mounted) {
      LoadingIndicatorDialog().show(
        context,
        text: AppLocalizations.of(context)!.wait,
      );
    }
    http.Response response = await http.get(
      Uri.parse(
        "${OtherConstantes.baseUrl}personnel/supprimer_evaluation/${evaluation.id}",
      ),
      headers: {
        "Authorization": "Bearer ${AuthenticationProvider.instance.token}",
      },
    );
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      if (context.mounted) {
        LoadingIndicatorDialog().dismiss();
        SnackBarService.instance.showSnackBarSuccess(data["message"]);
      }
      return true;
    }
    if (context.mounted) {
      LoadingIndicatorDialog().dismiss();
      SnackBarService.instance.showSnackBarError(data["message"]);
    }
    return false;
  }

  void enregistrerNotesEvaluation(BuildContext context, List<Map> notes) async {
    http.Response response = await http.post(
      Uri.parse("${OtherConstantes.baseUrl}/personnel/enregistrer_notes"),
      body: jsonEncode({"notes": notes}),
    );
    var data = jsonDecode(response.body);
    if (response.statusCode == 201) {
      if (context.mounted) {
        SnackBarService.instance.showSnackBarSuccess(data["message"]);
        NavigationService.instance.goBack();
      }
    } else {
      if (context.mounted) {
        SnackBarService.instance.showSnackBarError(data["message"]);
      }
    }
  }
}
