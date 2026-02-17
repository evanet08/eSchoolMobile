import 'package:flutter/material.dart';
import 'package:eschoolmobile/custom_widgets/classe_select_item.dart';
import 'package:eschoolmobile/custom_widgets/cours_select_item.dart';
import 'package:eschoolmobile/custom_widgets/creneau_item.dart';
import 'package:eschoolmobile/custom_widgets/my_textfield.dart';
import 'package:eschoolmobile/models/classe.dart';
import 'package:eschoolmobile/models/cours.dart';
import 'package:eschoolmobile/models/creneaux_journalier.dart';
import 'package:eschoolmobile/providers/classes_provider.dart';
import 'package:eschoolmobile/services/cours_service.dart';
import 'package:eschoolmobile/services/creneau_service.dart';
import 'package:eschoolmobile/l10n/app_localizations.dart';
import 'package:eschoolmobile/utils/theme/constantes/colors_constantes.dart';
import 'package:eschoolmobile/utils/theme/constantes/icon_size_constantes.dart';
import 'package:eschoolmobile/utils/theme/constantes/other_constantes.dart';
import 'package:provider/provider.dart';

class Creneaux extends StatefulWidget {
  const Creneaux({super.key});

  @override
  State<Creneaux> createState() => _CreneauxState();
}

class _CreneauxState extends State<Creneaux> {
  late ClassesProvider classesProvider;
  @override
  Widget build(BuildContext context) {
    classesProvider = Provider.of<ClassesProvider>(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(OtherConstantes.pagePadding),
        child: Column(
          children: [
            _listClassesUI(),
            _listCoursesUI(),
            _searchField(),
            FutureBuilder<List<CreneauxJournalier>>(
              future: CreneauService.instance.fetchCreneauxJournaliers(context),
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
                  List<CreneauxJournalier>? creneauxJournaliers = snapshot.data;
                  if (creneauxJournaliers != null) {
                    return _creneauxListView(creneauxJournaliers);
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
                await CreneauService.instance.fetchCreneauxJournaliers(context);
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
                          classesProvider.cours = null;
                          await CoursService.instance.fetchCours(context);
                          await CreneauService.instance
                              .fetchCreneauxJournaliers(context);
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
              onTap: () async {
                setState(() {
                  classesProvider.cours = null;
                });

                await CreneauService.instance.fetchCreneauxJournaliers(context);
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
                        onTap: () async {
                          classesProvider.cours = cours;
                          await CreneauService.instance
                              .fetchCreneauxJournaliers(context);
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

  Widget _creneauxListView(List<CreneauxJournalier> creneauxJournaliers) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: ListView.builder(
          itemCount: creneauxJournaliers.length,
          itemBuilder: (BuildContext context, index) {
            CreneauxJournalier creneauxJournalier = creneauxJournaliers[index];
            return Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: ColorConstantes.greyColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(creneauxJournalier.jour),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children:
                        creneauxJournalier.creneaux.map((creneau) {
                          return CreneauItem(creneau: creneau);
                        }).toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
