import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:eschoolmobile/custom_widgets/cours_select_item.dart';
import 'package:eschoolmobile/custom_widgets/creneau_parent_item.dart';
import 'package:eschoolmobile/custom_widgets/eleve_select_item.dart';
import 'package:eschoolmobile/custom_widgets/my_textfield.dart';
import 'package:eschoolmobile/models/cours.dart';
import 'package:eschoolmobile/models/creneaux_journalier.dart';
import 'package:eschoolmobile/models/eleve.dart';
import 'package:eschoolmobile/providers/classes_provider.dart';
import 'package:eschoolmobile/providers/eleves_provider.dart';
import 'package:eschoolmobile/services/cours_service.dart';
import 'package:eschoolmobile/services/creneau_service.dart';
import 'package:eschoolmobile/l10n/app_localizations.dart';
import 'package:eschoolmobile/services/rapport_service.dart';
import 'package:eschoolmobile/utils/theme/constantes/colors_constantes.dart';
import 'package:eschoolmobile/utils/theme/constantes/icon_size_constantes.dart';
import 'package:eschoolmobile/utils/theme/constantes/other_constantes.dart';
import 'package:provider/provider.dart';

class CreneauxEnfantsparent extends StatefulWidget {
  final Function(bool) onScroll;
  const CreneauxEnfantsparent({super.key, required this.onScroll});

  @override
  State<CreneauxEnfantsparent> createState() => _CreneauxEnfantsparentState();
}

class _CreneauxEnfantsparentState extends State<CreneauxEnfantsparent> {
  late ClassesProvider classesProvider;
  late EleveProvider eleveProvider;
  late List<CreneauxJournalier>? creneaux;
  late ScrollController _scrollController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    CreneauService.instance.fetchCreneauxJournaliers(context).then((data) {
      setState(() {
        _isLoading = false;
        creneaux = data;
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

    RapportService.instance
        .fetchRapports(context, '2025-01-01', '2025-06-05')
        .then((rapports) => {print(rapports)})
        .catchError((err) => {print(err)});
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
            _searchField(),
            _isLoading
                ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: CircularProgressIndicator(),
                  ),
                )
                : _creneauxListView(creneaux!),
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
                            classesProvider.cours = null;
                            eleveProvider.eleve = eleve;
                            _isLoading = true;
                          });
                          CoursService.instance.fetchCours(context).then((
                            data,
                          ) {
                            classesProvider.courses = data;
                          });
                          CreneauService.instance
                              .fetchCreneauxJournaliers(context)
                              .then((data) {
                                setState(() {
                                  _isLoading = false;
                                  creneaux = data;
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
                  _isLoading = true;
                });
                CreneauService.instance.fetchCreneauxJournaliers(context).then((
                  data,
                ) {
                  setState(() {
                    _isLoading = false;
                    creneaux = data;
                  });
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
                          CreneauService.instance
                              .fetchCreneauxJournaliers(context)
                              .then((data) {
                                setState(() {
                                  _isLoading = false;
                                  creneaux = data;
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
          controller: _scrollController,
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
                          return CreneauParentItem(creneau: creneau);
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
