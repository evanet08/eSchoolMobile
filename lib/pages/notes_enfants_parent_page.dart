import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:eschoolmobile/custom_widgets/cours_select_item.dart';
import 'package:eschoolmobile/custom_widgets/eleve_select_item.dart';
import 'package:eschoolmobile/custom_widgets/evaluation_parent_item.dart';
import 'package:eschoolmobile/custom_widgets/note_parent_item.dart';
import 'package:eschoolmobile/models/cours.dart';
import 'package:eschoolmobile/models/eleve.dart';
import 'package:eschoolmobile/models/evaluation.dart';
import 'package:eschoolmobile/models/note.dart';
import 'package:eschoolmobile/providers/classes_provider.dart';
import 'package:eschoolmobile/providers/eleves_provider.dart';
import 'package:eschoolmobile/services/cours_service.dart';
import 'package:eschoolmobile/services/evaluation_service.dart';
import 'package:eschoolmobile/services/navigation_service.dart';
import 'package:eschoolmobile/utils/theme/constantes/colors_constantes.dart';
import 'package:eschoolmobile/utils/theme/constantes/icon_size_constantes.dart';
import 'package:eschoolmobile/utils/theme/constantes/other_constantes.dart';
import 'package:eschoolmobile/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class NotesEnfantsParent extends StatefulWidget {
  final Function(bool) onScroll;
  const NotesEnfantsParent({super.key, required this.onScroll});

  @override
  State<NotesEnfantsParent> createState() => _NotesEnfantsParentState();
}

class _NotesEnfantsParentState extends State<NotesEnfantsParent> {
  late ClassesProvider classesProvider;
  late EleveProvider eleveProvider;
  late List<Evaluation>? evaluations;
  late ScrollController _scrollController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    EvaluationService.instance.fetchEvaluations(context).then((data) {
      setState(() {
        _isLoading = false;
        evaluations = data;
      });
    });
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        widget.onScroll(false);
      } else if (_scrollController.position.userScrollDirection ==
              ScrollDirection.forward ||
          _scrollController.position.userScrollDirection ==
              ScrollDirection.idle) {
        widget.onScroll(true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    classesProvider = Provider.of<ClassesProvider>(context);
    eleveProvider = Provider.of<EleveProvider>(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(OtherConstantes.pagePadding),
        child: Column(
          children: [
            _listElevesUI(),
            _listCoursesUI(),
            _isLoading
                ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: CircularProgressIndicator(),
                  ),
                )
                : _evaluationsListView(evaluations!),
          ],
        ),
      ),
    );
  }

  Widget _listElevesUI() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:
                    eleveProvider.eleves.map((Eleve eleve) {
                      return EleveSelectItem(
                        eleve: eleve,
                        onTap: () {
                          setState(() {
                            eleveProvider.eleve = eleve;
                            classesProvider.cours = null;
                            _isLoading = true;
                          });
                          CoursService.instance.fetchCours(context).then((
                            data,
                          ) {
                            classesProvider.courses = data;
                            EvaluationService.instance
                                .fetchEvaluations(context)
                                .then((data) {
                                  setState(() {
                                    _isLoading = false;
                                    evaluations = data;
                                  });
                                });
                          });
                        },
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listCoursesUI() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              color: ColorConstantes.whiteColor,
              border: Border.all(
                color:
                    classesProvider.cours == null
                        ? ColorConstantes.primaryColor
                        : ColorConstantes.greyColor,
                width: 2.0,
              ), // Optional: Add a background color
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  classesProvider.cours = null;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  AppLocalizations.of(context)!.all_courses,
                  style: TextStyle().copyWith(
                    color:
                        classesProvider.cours == null
                            ? ColorConstantes.primaryColor
                            : ColorConstantes.blackColor,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:
                    classesProvider.courses.map((Cours cours) {
                      return CoursSelectItem(
                        cours: cours,
                        onTap: () {
                          setState(() {
                            classesProvider.cours = cours;
                            _isLoading = true;
                          });
                          EvaluationService.instance
                              .fetchEvaluations(context)
                              .then((data) {
                                setState(() {
                                  _isLoading = false;
                                  evaluations = data;
                                });
                              });
                        },
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _evaluationsListView(List<Evaluation> evaluations) {
    return Expanded(
      child: ListView.builder(
        itemCount: evaluations.length,
        itemBuilder: (BuildContext context, index) {
          Evaluation evaluation = evaluations[index];
          return EvaluationParentItem(
            evaluation: evaluation,
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext ctx) {
                  return NoteEvaluationDialog(evaluation: evaluation);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class NoteEvaluationDialog extends StatefulWidget {
  final Evaluation evaluation;
  const NoteEvaluationDialog({super.key, required this.evaluation});

  @override
  State<NoteEvaluationDialog> createState() => _NoteEvaluationDialogState();
}

class _NoteEvaluationDialogState extends State<NoteEvaluationDialog> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        children: [_dialogTitleUI(), _notesListView(widget.evaluation)],
      ),
    );
  }

  Widget _dialogTitleUI() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              "Notes à l'(au) ${widget.evaluation.typeEvaluation} de ${widget.evaluation.cours} en ${widget.evaluation.classe}",
              textAlign: TextAlign.center,
            ),
          ),
          InkWell(
            onTap: () {
              NavigationService.instance.goBack();
            },
            child: Icon(
              Icons.cancel,
              color: ColorConstantes.redColor,
              size: IconSizeConstantes.medium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _notesListView(Evaluation evaluation) {
    return FutureBuilder<List<Note>>(
      future: EvaluationService.instance.fetchNotes(context, evaluation.id),
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
                  return note.idEleve == EleveProvider.instance.eleve!.id
                      ? NoteParentItem(note: note)
                      : SizedBox();
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
