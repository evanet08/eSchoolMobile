import 'package:flutter/material.dart';
import 'package:eschoolmobile/custom_widgets/classe_select_item.dart';
import 'package:eschoolmobile/custom_widgets/cours_select_item.dart';
import 'package:eschoolmobile/custom_widgets/evaluation_item.dart';
import 'package:eschoolmobile/custom_widgets/my_textfield.dart';
import 'package:eschoolmobile/models/classe.dart';
import 'package:eschoolmobile/models/cours.dart';
import 'package:eschoolmobile/models/evaluation.dart';
import 'package:eschoolmobile/providers/classes_provider.dart';
import 'package:eschoolmobile/services/cours_service.dart';
import 'package:eschoolmobile/services/evaluation_service.dart';
import 'package:eschoolmobile/services/navigation_service.dart';
import 'package:eschoolmobile/utils/theme/constantes/colors_constantes.dart';
import 'package:eschoolmobile/utils/theme/constantes/icon_size_constantes.dart';
import 'package:eschoolmobile/utils/theme/constantes/other_constantes.dart';
import 'package:eschoolmobile/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  late ClassesProvider classesProvider;
  int count = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    classesProvider = Provider.of<ClassesProvider>(context);
    return Scaffold(
      floatingActionButton:
          (classesProvider.classe != null && classesProvider.cours != null)
              ? _addEvaluationFloatingActionButton()
              : SizedBox(),
      body: Padding(
        padding: EdgeInsets.all(OtherConstantes.pagePadding),
        child: Column(
          children: [
            _listClassesUI(),
            _listCoursesUI(),
            _searchField(),
            FutureBuilder<List<Evaluation>>(
              future: EvaluationService.instance.fetchEvaluations(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: CircularProgressIndicator(),
                    ),
                  ); // Loading state
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  ); // Error state
                } else {
                  List<Evaluation>? evaluations = snapshot.data;
                  if (evaluations != null) {
                    return _evaluationsListView(evaluations);
                  } else {
                    return Center(child: Text("hahaha"));
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _listClassesUI() {
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
                    classesProvider.classe == null
                        ? ColorConstantes.primaryColor
                        : ColorConstantes.greyColor,
                width: 2.0,
              ), // Optional: Add a background color
            ),
            child: InkWell(
              onTap: () async {
                classesProvider.classe = null;
                classesProvider.cours = null;
                await CoursService.instance.fetchCours(context);
                setState(() {
                  classesProvider.classe = null;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  AppLocalizations.of(context)!.all_classes,
                  style: TextStyle().copyWith(
                    color:
                        classesProvider.classe == null
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
                    classesProvider.classes.map((Classe classe) {
                      return ClasseSelectItem(
                        classe: classe,
                        onTap: () async {
                          classesProvider.classe = classe;
                          await CoursService.instance.fetchCours(context);
                          setState(() {
                            classesProvider.classe = classe;
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

  Widget _searchField() {
    return MyTextField(
      label: AppLocalizations.of(context)!.research,
      placeholder: AppLocalizations.of(context)!.research,
      width: MediaQuery.of(context).size.width,
      prefixIcon: Icon(Icons.search, size: IconSizeConstantes.medium),
    );
  }

  Widget _evaluationsListView(List<Evaluation> evaluations) {
    return Expanded(
      child: ListView.builder(
        itemCount: evaluations.length,
        itemBuilder: (BuildContext context, index) {
          Evaluation evaluation = evaluations[index];
          return EvaluationItem(
            evaluation: evaluation,
            deleteEvaluation: () async {
              bool status = await EvaluationService.instance.deleteEvaluation(
                context,
                evaluation,
              );
              if (status) {
                setState(() {
                  count = 1;
                });
              }
            },
          );
        },
      ),
    );
  }

  Widget _addEvaluationFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        NavigationService.instance.navigateTo("new_evaluation");
      },
      child: Icon(Icons.add, size: IconSizeConstantes.medium),
    );
  }
}
