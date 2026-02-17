import 'package:flutter/material.dart';
import 'package:eschoolmobile/custom_widgets/classe_select_item.dart';
import 'package:eschoolmobile/custom_widgets/conduite_item.dart';
import 'package:eschoolmobile/custom_widgets/cours_select_item.dart';
import 'package:eschoolmobile/custom_widgets/my_textfield.dart';
import 'package:eschoolmobile/models/classe.dart';
import 'package:eschoolmobile/models/conduite.dart';
import 'package:eschoolmobile/models/cours.dart';
import 'package:eschoolmobile/providers/classes_provider.dart';
import 'package:eschoolmobile/services/conduite_service.dart';
import 'package:eschoolmobile/services/cours_service.dart';
import 'package:eschoolmobile/utils/theme/constantes/colors_constantes.dart';
import 'package:eschoolmobile/utils/theme/constantes/icon_size_constantes.dart';
import 'package:eschoolmobile/l10n/app_localizations.dart';
import 'package:eschoolmobile/utils/theme/constantes/other_constantes.dart';
import 'package:provider/provider.dart';

class Conduites extends StatefulWidget {
  const Conduites({super.key});

  @override
  State<Conduites> createState() => _ConduitesState();
}

class _ConduitesState extends State<Conduites> {
  late List<Classe> classes;
  late ClassesProvider classesProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    classesProvider = Provider.of<ClassesProvider>(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(OtherConstantes.pagePadding),
        child: Column(
          children: [
            _listClassesUI(),
            _searchField(),
            FutureBuilder<List<Conduite>>(
              future: ConduiteService.instance.fetchConduites(context),
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
                  List<Conduite>? conduites = snapshot.data;
                  if (conduites != null) {
                    return _conduitesListView(conduites);
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

  Widget _conduitesListView(List<Conduite> conduites) {
    return Expanded(
      child: ListView.builder(
        itemCount: conduites.length,
        itemBuilder: (BuildContext context, index) {
          Conduite conduite = conduites[index];
          return ConduiteItem(conduite: conduite);
        },
      ),
    );
  }
}
