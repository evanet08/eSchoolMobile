import 'package:flutter/material.dart';
import 'package:eschoolmobile/custom_widgets/app_bar.dart';
import 'package:eschoolmobile/custom_widgets/my_text.dart';
import 'package:eschoolmobile/custom_widgets/my_textfield.dart';
import 'package:eschoolmobile/custom_widgets/nouvelle_note_item.dart';
import 'package:eschoolmobile/helpers.dart';
import 'package:eschoolmobile/models/evaluation.dart';
import 'package:eschoolmobile/models/note.dart';
import 'package:eschoolmobile/providers/account_creation_provider.dart';
import 'package:eschoolmobile/providers/classes_provider.dart';
import 'package:eschoolmobile/services/evaluation_service.dart';
import 'package:eschoolmobile/services/snackbar_service.dart';
import 'package:eschoolmobile/utils/theme/constantes/colors_constantes.dart';
import 'package:eschoolmobile/utils/theme/constantes/icon_size_constantes.dart';
import 'package:eschoolmobile/utils/theme/constantes/other_constantes.dart';
import 'package:eschoolmobile/l10n/app_localizations.dart';

class EnregistrementNotes extends StatefulWidget {
  const EnregistrementNotes({super.key});

  @override
  State<EnregistrementNotes> createState() => _EnregistrementNotesState();
}

class _EnregistrementNotesState extends State<EnregistrementNotes> {
  late Evaluation evaluation;
  List<Note> notes = [];
  @override
  Widget build(BuildContext context) {
    evaluation = ModalRoute.of(context)!.settings.arguments as Evaluation;
    if (notes.isEmpty) {
      EvaluationService.instance.fetchElevesForNotes(context, evaluation).then((
        data,
      ) {
        setState(() {
          notes = data;
        });
      });
    }
    return Scaffold(
      appBar: MyAppBar(),
      body: Padding(
        padding: EdgeInsets.all(OtherConstantes.pagePadding),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context)!.enregistrement_note_title(
                  evaluation.classe,
                  evaluation.cours,
                ),
              ),
            ),
            _ponderationsPageUI(),
            _searchField(),
            Expanded(
              child: Column(
                children: [_notesListView(notes), _insertButtonUI()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ponderationsPageUI() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(AppLocalizations.of(context)!.maximum),
          SizedBox(width: 20.0),
          MyText(text: "${evaluation.ponderation}"),
        ],
      ),
    );
  }

  Widget _searchField() {
    return MyTextField(
      label: AppLocalizations.of(context)!.research,
      placeholder: AppLocalizations.of(context)!.research,
      width: MediaQuery.of(context).size.width,
      prefixIcon: Icon(Icons.search, size: IconSizeConstantes.medium),
    );
  }

  Widget _insertButtonUI() {
    return ElevatedButton(
      onPressed: () {
        List<Map> nouvellesNotes = [];
        for (var note in notes) {
          if (note.note > -1) {
            nouvellesNotes.add({
              "date_saisie": Helpers.convertDateToString(
                DateTime.now(),
                'dd/MM/YYYY',
              ),
              "note": note.note,
              "id_annee": AccountCreationProvider.instance.anneeScolaire!.id,
              "id_campus": ClassesProvider.instance.classe!.idCampus,
              "id_classe": note.idClasse,
              "id_cours": note.idCours,
              "id_cycle": ClassesProvider.instance.classe!.idCycle,
              "id_eleve": note.idEleve,
              "id_type_note": note.idTypeNote,
              "id_evaluation": evaluation.id,
              "id_periode": note.idPeriode,
              "id_session": note.idSession,
              "id_trimestre": note.idTrimestre,
            });
          }
        }
        if (nouvellesNotes.isEmpty) {
          SnackBarService.instance.showSnackBarError(
            "Veuillez compléter les notes",
          );
          return;
        }
        EvaluationService.instance.enregistrerNotesEvaluation(
          context,
          nouvellesNotes,
        );
      },
      style: ButtonStyle().copyWith(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.pressed)) {
            return Colors.grey;
          }
          return ColorConstantes.primaryColor;
        }),
        side: WidgetStateProperty.resolveWith<BorderSide>((states) {
          if (states.contains(WidgetState.pressed)) {
            return BorderSide(color: Colors.grey, width: 1.0);
          }
          return BorderSide(color: ColorConstantes.primaryColor, width: 1.0);
        }),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Text(
          AppLocalizations.of(context)!.save,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _notesListView(List<Note> notes) {
    return Expanded(
      child: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (BuildContext context, index) {
          Note note = notes[index];
          return NouvelleNoteItem(note: note);
        },
      ),
    );
  }
}
