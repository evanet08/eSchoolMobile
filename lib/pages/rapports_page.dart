import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:eschoolmobile/custom_widgets/conduite_enfant_parent_item.dart';
import 'package:eschoolmobile/custom_widgets/cours_select_item.dart';
import 'package:eschoolmobile/custom_widgets/eleve_select_item.dart';
import 'package:eschoolmobile/custom_widgets/evaluation_parent_item.dart';
import 'package:eschoolmobile/custom_widgets/presence_item.dart';
import 'package:eschoolmobile/helpers.dart';
import 'package:eschoolmobile/models/appel.dart';
import 'package:eschoolmobile/models/conduite.dart';
import 'package:eschoolmobile/models/cours.dart';
import 'package:eschoolmobile/models/eleve.dart';
import 'package:eschoolmobile/models/evaluation.dart';
import 'package:eschoolmobile/models/rapport.dart';
import 'package:eschoolmobile/pages/notes_enfants_parent_page.dart';
import 'package:eschoolmobile/providers/authentication_provider.dart';
import 'package:eschoolmobile/providers/classes_provider.dart';
import 'package:eschoolmobile/providers/eleves_provider.dart';
import 'package:eschoolmobile/services/cours_service.dart';
import 'package:eschoolmobile/services/rapport_service.dart';
import 'package:eschoolmobile/utils/theme/constantes/colors_constantes.dart';
import 'package:eschoolmobile/l10n/app_localizations.dart';
import 'package:eschoolmobile/utils/theme/constantes/other_constantes.dart';
import 'package:provider/provider.dart';

class RapportsPage extends StatefulWidget {
  final Function(bool) onScroll;
  const RapportsPage({super.key, required this.onScroll});

  @override
  State<RapportsPage> createState() => _RapportsPageState();
}

class _RapportsPageState extends State<RapportsPage> {
  late List<Eleve> classes;
  List<Conduite>? conduites;
  List<Appel>? presences;
  List<Evaluation>? evaluations;
  List<Rapport> rapports = [];
  late AuthenticationProvider authenticationProvider;
  late ClassesProvider classesProvider;
  late EleveProvider eleveProvider;
  late ScrollController _scrollController;
  bool _isLoading = true;
  String startDate = "2025-01-01";
  String endDate = Helpers.convertDateToString(DateTime.now(), 'yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    fetchData(startDate, endDate);
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

  void fetchData(String startDate, String endDate) {
    setState(() {
      _isLoading = true;
      rapports = [];
    });
    RapportService.instance.fetchRapports(context, startDate, endDate).then((
      data,
    ) {
      rapports.add(
        Rapport(
          headerValue: "Conduites",
          data: data['conduites'],
          isExpanded: true,
        ),
      );
      rapports.add(Rapport(headerValue: "Présences", data: data['presences']));
      rapports.add(
        Rapport(headerValue: "Evaluations", data: data['evaluations']),
      );

      setState(() {
        _isLoading = false;
        rapports;
      });
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
                  : Expanded(
                    child: ListView.builder(
                      itemCount: rapports.length,
                      controller: _scrollController,
                      itemBuilder: (BuildContext content, int index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(
                            0.0,
                            0.0,
                            0.0,
                            5.0,
                          ),
                          child: ExpansionPanelList(
                            expansionCallback: (int index2, bool isExpanded) {
                              setState(() {
                                rapports[index].isExpanded = isExpanded;
                              });
                            },
                            expandedHeaderPadding: EdgeInsets.zero,
                            children: [
                              ExpansionPanel(
                                headerBuilder: (
                                  BuildContext context,
                                  bool isExpanded,
                                ) {
                                  return SizedBox(
                                    height: 5.0,
                                    child: ListTile(
                                      title: Text(
                                        rapports[index].headerValue,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  );
                                },
                                body: Container(
                                  height: 110.0 * rapports[index].data.length,
                                  color: Colors.white,
                                  child: ListView.builder(
                                    itemCount: rapports[index].data.length,
                                    itemBuilder: (
                                      BuildContext ctx,
                                      int index2,
                                    ) {
                                      if (rapports[index].data[index2]
                                          is Evaluation) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: EvaluationParentItem(
                                            evaluation:
                                                rapports[index].data[index2],
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                builder: (BuildContext ctx) {
                                                  return NoteEvaluationDialog(
                                                    evaluation:
                                                        rapports[index]
                                                            .data[index2],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        );
                                      } else if (rapports[index].data[index2]
                                          is Appel) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: PresenceItem(
                                            presence:
                                                rapports[index].data[index2],
                                            onChanged: (pres) => {},
                                          ),
                                        );
                                      } else {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ConduiteEnfantParentItem(
                                            conduite:
                                                rapports[index].data[index2],
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                isExpanded: rapports[index].isExpanded,
                                backgroundColor: Colors.grey,
                                canTapOnHeader: true,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

              /*Column(
                      children: [
                        _conduitesEnfantsParentListView(conduites ?? []),
                        _presenceParentListView(presences ?? []),
                        _evaluationParentListView(evaluations ?? []),
                      ],
                    ),*/
            ],
          ),
        ),
      ),
    );
  }

  Widget _listElevesUI() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.04,
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
                            fetchData(startDate, endDate);
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
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.04,
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
                  fetchData(startDate, endDate);
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
                            fetchData(startDate, endDate);
                          },
                        );
                      }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _conduitesEnfantsParentListView(List<Conduite> conduites) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: ListView.builder(
        itemCount: conduites.length,
        itemBuilder: (BuildContext context, index) {
          Conduite conduite = conduites[index];
          return ConduiteEnfantParentItem(conduite: conduite);
        },
      ),
    );
  }

  Widget _evaluationParentListView(List<Evaluation> evaluations) {
    return ExpansionPanelList(
      elevation: 1,
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          evaluations[panelIndex].isExpanded = !isExpanded;
        });
      },

      children:
          evaluations.map<ExpansionPanel>((Evaluation evaluation) {
            return ExpansionPanel(
              headerBuilder: (context, isExpanded) {
                return ListTile(title: Text('Evaluations'));
              },
              body: EvaluationParentItem(
                evaluation: evaluation,
                onTap: () => {},
              ),
              isExpanded: evaluation.isExpanded,
            );
          }).toList(),
    );
  }

  Widget _presenceParentListView(List<Appel> presences) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: ListView.builder(
        itemCount: presences.length,
        itemBuilder: (BuildContext context, index) {
          Appel presence = presences[index];
          return PresenceItem(presence: presence, onChanged: (value) => {});
        },
      ),
    );
  }
}
