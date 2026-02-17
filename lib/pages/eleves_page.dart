import 'package:flutter/material.dart';
import 'package:eschoolmobile/custom_widgets/classe_select_item.dart';
import 'package:eschoolmobile/custom_widgets/eleve_item.dart';
import 'package:eschoolmobile/custom_widgets/my_text.dart';
import 'package:eschoolmobile/custom_widgets/my_textfield.dart';
import 'package:eschoolmobile/helpers.dart';
import 'package:eschoolmobile/models/classe.dart';
import 'package:eschoolmobile/models/conduite.dart';
import 'package:eschoolmobile/models/creneau.dart';
import 'package:eschoolmobile/models/eleve.dart';
import 'package:eschoolmobile/models/periode.dart';
import 'package:eschoolmobile/models/trimestre.dart';
import 'package:eschoolmobile/providers/classes_provider.dart';
import 'package:eschoolmobile/services/classe_service.dart';
import 'package:eschoolmobile/services/conduite_service.dart';
import 'package:eschoolmobile/services/creneau_service.dart';
import 'package:eschoolmobile/services/eleve_service.dart';
import 'package:eschoolmobile/services/evaluation_service.dart';
import 'package:eschoolmobile/services/navigation_service.dart';
import 'package:eschoolmobile/services/snackbar_service.dart';
import 'package:eschoolmobile/utils/theme/constantes/colors_constantes.dart';
import 'package:eschoolmobile/utils/theme/constantes/icon_size_constantes.dart';
import 'package:eschoolmobile/utils/theme/constantes/other_constantes.dart';
import 'package:eschoolmobile/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class Eleves extends StatefulWidget {
  const Eleves({super.key});

  @override
  State<Eleves> createState() => _ElevesState();
}

class _ElevesState extends State<Eleves> {
  late List<Classe> classes;
  late ClassesProvider classesProvider;
  late Eleve eleve;

  @override
  void initState() {
    super.initState();
    ClasseService.instance.fetchClasses(context).then((data) {
      setState(() {
        classes = data;
      });
    });
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
            MyTextField(
              label: AppLocalizations.of(context)!.research,
              placeholder: AppLocalizations.of(context)!.research,
              width: MediaQuery.of(context).size.width,
              prefixIcon: Icon(Icons.search, size: IconSizeConstantes.medium),
            ),
            FutureBuilder<List<Eleve>>(
              future: EleveService.instance.fetchEleves(context),
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
                  List<Eleve>? eleves = snapshot.data;
                  if (eleves != null) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: eleves.length,
                        itemBuilder: (BuildContext context, index) {
                          Eleve eleve = eleves[index];
                          return EleveItem(
                            eleve: eleve,
                            onSlected: (index) {
                              if (index == 1) {
                                NavigationService.instance.navigateTo(
                                  "profile_eleve",
                                  args: eleve,
                                );
                              } else if (index == 2) {
                                if (ClassesProvider.instance.classe == null) {
                                  SnackBarService.instance.showSnackBarError(
                                    "Veuillez selectionner une classe",
                                  );
                                  return;
                                }
                                this.eleve = eleve;
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext ctx) {
                                    return ConduiteDialog(eleve: eleve);
                                  },
                                );
                              }
                            },
                          );
                        },
                      ),
                    );
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
              onTap: () {
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
                        onTap: () {
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
}

class ConduiteDialog extends StatefulWidget {
  final Eleve eleve;
  const ConduiteDialog({super.key, required this.eleve});

  @override
  State<ConduiteDialog> createState() => _ConduiteDialogState();
}

class _ConduiteDialogState extends State<ConduiteDialog> {
  List<Creneau> creneaux = [];
  List<Trimestre> trimestres = [];
  Trimestre? _trimestre;

  List<Periode> periodes = [];
  Periode? _periode;
  Creneau? _creneau;
  int quote = 10;
  String? _motif;

  @override
  void initState() {
    super.initState();
    CreneauService.instance.fetchCreneaux(context).then((data) {
      setState(() {
        creneaux = data;
      });
    });

    EvaluationService.instance.fetchTrimestres(context).then((trims) {
      setState(() {
        trimestres = trims;
      });
    });
    EvaluationService.instance.fetchPeriodes(context).then((pers) {
      setState(() {
        periodes = pers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Column(
        children: [
          _dialogTitleUI(),
          _creneauSelectUI(),
          _trimestreSelectUI(),
          _periodeSelectUI(),
          _conduiteRatingsUI(),
          _commentTextFieldUI(),
          _applyButtonUI(),
        ],
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
              AppLocalizations.of(
                context,
              )!.behavior_of("${widget.eleve.noms} ${widget.eleve.prenom}"),
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

  Widget _trimestreSelectUI() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: MyText(text: "Trimestre:"),
          ),
          Expanded(
            child: DropdownButton<Trimestre>(
              value: _trimestre,
              hint: Text(AppLocalizations.of(context)!.select_item),
              items:
                  trimestres.map<DropdownMenuItem<Trimestre>>((
                    Trimestre value,
                  ) {
                    return DropdownMenuItem<Trimestre>(
                      value: value,
                      child: MyText(text: value.designation),
                    );
                  }).toList(),
              onChanged: (Trimestre? newValue) {
                setState(() {
                  _trimestre = newValue;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _periodeSelectUI() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: MyText(text: "Période:"),
          ),
          Expanded(
            child: DropdownButton<Periode>(
              value: _periode,
              hint: Text(AppLocalizations.of(context)!.select_item),
              items:
                  periodes.map<DropdownMenuItem<Periode>>((Periode value) {
                    return DropdownMenuItem<Periode>(
                      value: value,
                      child: MyText(text: value.designation),
                    );
                  }).toList(),
              onChanged: (Periode? newValue) {
                setState(() {
                  _periode = newValue;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _conduiteRatingsUI() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Align(
        alignment: Alignment.topRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.ratings),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            quote = 1;
                          });
                        },
                        child: Image.asset(
                          quote < 1
                              ? "assets/images/star_black.png"
                              : "assets/images/star_yellow.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            quote = 2;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Image.asset(
                            quote < 2
                                ? "assets/images/star_black.png"
                                : "assets/images/star_yellow.png",
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            quote = 3;
                          });
                        },
                        child: Image.asset(
                          quote < 3
                              ? "assets/images/star_black.png"
                              : "assets/images/star_yellow.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            quote = 4;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Image.asset(
                            quote < 4
                                ? "assets/images/star_black.png"
                                : "assets/images/star_yellow.png",
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            quote = 5;
                          });
                        },
                        child: Image.asset(
                          quote < 5
                              ? "assets/images/star_black.png"
                              : "assets/images/star_yellow.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    Helpers.getMentionConduiteStrByValue(context, quote),
                    style: TextStyle().copyWith(
                      color:
                          quote < 3
                              ? ColorConstantes.redColor
                              : Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _creneauSelectUI() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppLocalizations.of(context)!.schedule),
          DropdownButton<Creneau>(
            value: _creneau,
            hint: Text(AppLocalizations.of(context)!.select_item),
            items:
                creneaux.map<DropdownMenuItem<Creneau>>((Creneau value) {
                  return DropdownMenuItem<Creneau>(
                    value: value,
                    child: Text(
                      "${value.cours}: ${value.jour}, ${value.heureDebut}-${value.heureFin}",
                    ),
                  );
                }).toList(),
            onChanged: (Creneau? newValue) {
              setState(() {
                _creneau = newValue;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _commentTextFieldUI() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: MyTextField(
        label:
            "${AppLocalizations.of(context)!.comment} (${AppLocalizations.of(context)!.optional})",
        placeholder: AppLocalizations.of(context)!.comment,
        width: MediaQuery.of(context).size.width,
        height: 80.0,
        maxLines: 10,
        onChanged: (input) {
          _motif = input;
        },
      ),
    );
  }

  Widget _applyButtonUI() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        onPressed: () {
          if (_creneau == null) {
            SnackBarService.instance.showSnackBarError(
              "Veuillez selectionner le créneau",
            );
            return;
          }
          if (_trimestre == null) {
            SnackBarService.instance.showSnackBarError(
              "Veuillez selectionner le trimestre",
            );
            return;
          }
          if (_periode == null) {
            SnackBarService.instance.showSnackBarError(
              "Veuillez selectionner la période",
            );
            return;
          }
          if (_motif == null) {
            SnackBarService.instance.showSnackBarError(
              "Veuillez compléter le motif quotation de la conduite",
            );
            return;
          }
          Conduite conduite = Conduite(
            0,
            _creneau!,
            Helpers.convertDateToString(DateTime.now(), 'dd/MM/YYYY'),
            widget.eleve,
            mention: quote,
            motif: _motif,
          );
          ConduiteService.instance
              .enregistrerConduite(
                context,
                conduite,
                _periode!.id,
                _trimestre!.id,
              )
              .then((value) {
                if (value) {
                  NavigationService.instance.goBack();
                }
              });
        },
        style: ButtonStyle().copyWith(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.grey; // When pressed
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
            AppLocalizations.of(context)!.apply,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
