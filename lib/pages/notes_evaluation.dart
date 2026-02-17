import 'package:flutter/material.dart';
import 'package:eschoolmobile/custom_widgets/app_bar.dart';
import 'package:eschoolmobile/custom_widgets/my_text.dart';
import 'package:eschoolmobile/custom_widgets/note_item.dart';
import 'package:eschoolmobile/custom_widgets/search_field.dart';
import 'package:eschoolmobile/models/evaluation.dart';
import 'package:eschoolmobile/models/note.dart';
import 'package:eschoolmobile/services/evaluation_service.dart';
import 'package:eschoolmobile/utils/theme/constantes/other_constantes.dart';

class NotesEvaluation extends StatefulWidget {
  const NotesEvaluation({super.key});

  @override
  State<NotesEvaluation> createState() => _NotesEvaluationState();
}

class _NotesEvaluationState extends State<NotesEvaluation> {
  late Evaluation _evaluation;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _evaluation = ModalRoute.of(context)!.settings.arguments as Evaluation;
    return Scaffold(
      appBar: MyAppBar(),
      body: Padding(
        padding: EdgeInsets.all(OtherConstantes.pagePadding),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: MyText(
                text:
                    "Notes du (de l') ${_evaluation.typeEvaluation} de ${_evaluation.cours} en ${_evaluation.classe}",
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  MyText(text: "Ponderation: "),
                  SizedBox(width: 10),
                  MyText(
                    text: "${_evaluation.ponderation}",
                    color: Colors.green,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: SearchField(onChange: (v) {}),
            ),
            _notesListView(),
          ],
        ),
      ),
    );
  }

  Widget _notesListView() {
    return FutureBuilder<List<Note>>(
      future: EvaluationService.instance.fetchNotes(context, _evaluation.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: CircularProgressIndicator(),
            ),
          ); // Loading state
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}")); // Error state
        } else {
          List<Note>? notes = snapshot.data;
          if (notes != null) {
            return Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (BuildContext context, index) {
                  Note note = notes[index];
                  return NoteItem(note: note, onSlected: (index) {});
                },
              ),
            );
          } else {
            return Center(child: Text("hahaha"));
          }
        }
      },
    );
  }
}
