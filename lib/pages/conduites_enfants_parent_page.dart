import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:eschoolmobile/custom_widgets/conduite_enfant_parent_item.dart';
import 'package:eschoolmobile/custom_widgets/cours_select_item.dart';
import 'package:eschoolmobile/custom_widgets/eleve_select_item.dart';
import 'package:eschoolmobile/models/conduite.dart';
import 'package:eschoolmobile/models/cours.dart';
import 'package:eschoolmobile/models/eleve.dart';
import 'package:eschoolmobile/providers/authentication_provider.dart';
import 'package:eschoolmobile/providers/classes_provider.dart';
import 'package:eschoolmobile/providers/eleves_provider.dart';
import 'package:eschoolmobile/services/conduite_service.dart';
import 'package:eschoolmobile/services/cours_service.dart';
import 'package:eschoolmobile/utils/theme/constantes/colors_constantes.dart';
import 'package:eschoolmobile/l10n/app_localizations.dart';
import 'package:eschoolmobile/utils/theme/constantes/other_constantes.dart';
import 'package:provider/provider.dart';

class ConduitesEntantsParent extends StatefulWidget {
  final Function(bool) onScroll;
  const ConduitesEntantsParent({super.key, required this.onScroll});

  @override
  State<ConduitesEntantsParent> createState() => _ConduitesEntantsParentState();
}

class _ConduitesEntantsParentState extends State<ConduitesEntantsParent> {
  late List<Eleve> classes;
  List<Conduite>? conduites;
  late AuthenticationProvider authenticationProvider;
  late ClassesProvider classesProvider;
  late EleveProvider eleveProvider;
  late ScrollController _scrollController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    ConduiteService.instance.fetchConduites(context).then((data) {
      setState(() {
        _isLoading = false;
        conduites = data;
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
    authenticationProvider = Provider.of<AuthenticationProvider>(context);
    classesProvider = Provider.of<ClassesProvider>(context);
    eleveProvider = Provider.of<EleveProvider>(context);
    return DefaultTabController(
      length: 5,
      child: Scaffold(
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
                  : _conduitesEnfantsParentListView(conduites!),
            ],
          ),
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
                            ConduiteService.instance
                                .fetchConduites(context)
                                .then((data) {
                                  setState(() {
                                    _isLoading = false;
                                    conduites = data;
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
                ConduiteService.instance.fetchConduites(context).then((data) {
                  setState(() {
                    _isLoading = false;
                    conduites = data;
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
                          });
                          ConduiteService.instance.fetchConduites(context).then(
                            (data) {
                              setState(() {
                                _isLoading = false;
                                conduites = data;
                              });
                            },
                          );
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

  Widget _conduitesEnfantsParentListView(
    List<Conduite> conduitesEntantsParent,
  ) {
    return Expanded(
      child: ListView.builder(
        itemCount: conduitesEntantsParent.length,
        controller: _scrollController,
        itemBuilder: (BuildContext context, index) {
          Conduite conduite = conduitesEntantsParent[index];
          return ConduiteEnfantParentItem(conduite: conduite);
        },
      ),
    );
  }
}
