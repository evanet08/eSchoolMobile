import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:eschoolmobile/custom_widgets/app_bar.dart';
import 'package:eschoolmobile/custom_widgets/loading_indicator_dialog.dart';
import 'package:eschoolmobile/custom_widgets/my_btn.dart';
import 'package:eschoolmobile/custom_widgets/my_text.dart';
import 'package:eschoolmobile/helpers.dart';
import 'package:eschoolmobile/models/evaluation.dart';
import 'package:eschoolmobile/models/periode.dart';
import 'package:eschoolmobile/models/session.dart';
import 'package:eschoolmobile/models/trimestre.dart';
import 'package:eschoolmobile/models/type_evaluation.dart';
import 'package:eschoolmobile/l10n/app_localizations.dart';
import 'package:eschoolmobile/providers/classes_provider.dart';
import 'package:eschoolmobile/services/evaluation_service.dart';
import 'package:eschoolmobile/services/snackbar_service.dart';

class NouvelleEvaluation extends StatefulWidget {
  const NouvelleEvaluation({super.key});

  @override
  State<NouvelleEvaluation> createState() => _NouvelleEvaluationState();
}

class _NouvelleEvaluationState extends State<NouvelleEvaluation> {
  late GlobalKey<FormState> _formKey;
  List<TypeEvaluation> typesEvaluations = [];
  TypeEvaluation? _typeEvaluation;

  List<Trimestre> trimestres = [];
  Trimestre? _trimestre;

  List<Periode> periodes = [];
  Periode? _periode;

  List<Session> sessions = [];
  Session? _session;

  DateTime dateEvaluation = DateTime.now();
  DateTime? dateRemise;
  File? file;
  FilePickerResult? fileResult;
  Evaluation? evaluation;
  int _ponderation = 0;
  _NouvelleEvaluationState() {
    _formKey = GlobalKey<FormState>();
  }

  @override
  void initState() {
    super.initState();
    EvaluationService.instance.fetchTypesEvaluations(context).then((types) {
      setState(() {
        typesEvaluations = types;
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

    EvaluationService.instance.fetchSessions(context).then((sess) {
      setState(() {
        sessions = sess;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    evaluation = ModalRoute.of(context)!.settings.arguments as Evaluation?;
    if (evaluation != null) {
      dateEvaluation = DateTime.parse(evaluation!.dateEvaluation);
      dateRemise =
          evaluation!.dateRemise != null
              ? DateTime.parse(evaluation!.dateRemise!)
              : null;
      for (var type in typesEvaluations) {
        if (type.id == evaluation!.idTypeEvaluation) {
          _typeEvaluation = type;
          break;
        }
      }
      for (var trim in trimestres) {
        if (trim.id == evaluation!.idTrimestre) {
          _trimestre = trim;
          break;
        }
      }
      for (var per in periodes) {
        if (per.id == evaluation!.idPeriode) {
          _periode = per;
          break;
        }
      }
      for (var sess in sessions) {
        if (sess.id == evaluation!.idSession) {
          _session = sess;
          break;
        }
      }
      _ponderation = evaluation!.ponderation;
    }
    return Scaffold(
      appBar: MyAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          onChanged: () {
            _formKey.currentState!.save();
          },
          child: ListView(
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: MyText(
                    text:
                        evaluation == null
                            ? "Nouvelle évaluation au cours de ${ClassesProvider.instance.cours!.designation}"
                            : "Modification de ${evaluation!.typeEvaluation} de ${evaluation!.cours}",
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              _typeEvaluationSelectUI(),
              _trimestreSelectUI(),
              _periodeSelectUI(),
              _sessionSelectUI(),
              _ponderationUI(),
              _datePassationEvaluationUI(),
              _dateRemiseEvaluationUI(),
              _selectQuestionnaire(),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: MyButton(
                  text:
                      evaluation == null
                          ? AppLocalizations.of(context)!.save
                          : "Modifier",
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  fontSize: 12.0,
                  textColor: Colors.white,
                  onPressed: () {
                    _saveEvaluation();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _typeEvaluationSelectUI() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: MyText(text: "Type d'évaluation:"),
          ),
          Expanded(
            child: DropdownButton<TypeEvaluation>(
              value: _typeEvaluation,
              hint: Text(AppLocalizations.of(context)!.select_item),
              items:
                  typesEvaluations.map<DropdownMenuItem<TypeEvaluation>>((
                    TypeEvaluation value,
                  ) {
                    return DropdownMenuItem<TypeEvaluation>(
                      value: value,
                      child: MyText(text: value.designation),
                    );
                  }).toList(),
              onChanged: (TypeEvaluation? newValue) {
                setState(() {
                  _typeEvaluation = newValue;
                  if (evaluation != null) {
                    evaluation!.idTypeEvaluation = newValue!.id;
                  }
                });
              },
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
                _formKey.currentState!.save();
                setState(() {
                  _trimestre = newValue;
                  if (evaluation != null) {
                    evaluation!.idTrimestre = newValue!.id;
                  }
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
                _formKey.currentState!.save();
                setState(() {
                  _periode = newValue;
                  if (evaluation != null) {
                    evaluation!.idPeriode = newValue!.id;
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _sessionSelectUI() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: MyText(text: "Session:"),
          ),
          Expanded(
            child: DropdownButton<Session>(
              value: _session,
              hint: Text(AppLocalizations.of(context)!.select_item),
              items:
                  sessions.map<DropdownMenuItem<Session>>((Session value) {
                    return DropdownMenuItem<Session>(
                      value: value,
                      child: MyText(text: value.designation),
                    );
                  }).toList(),
              onChanged: (Session? newValue) {
                _formKey.currentState!.save();
                setState(() {
                  _session = newValue;
                  if (evaluation != null) {
                    evaluation!.idSession = newValue!.id;
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _datePassationEvaluationUI() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: MyText(text: "Date d'évaluation:"),
          ),
          InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime(
                  dateEvaluation.year + 10,
                  dateEvaluation.month,
                  dateEvaluation.day,
                ),
              );
              if (picked != null) {
                setState(() {
                  dateEvaluation = picked;
                  if (evaluation != null) {
                    evaluation!.dateEvaluation = Helpers.convertDateToString(
                      picked,
                      'dd/MM/YYYY',
                    );
                  }
                });
              }
            },
            child: Row(
              children: [
                Icon(Icons.calendar_month, size: 15),
                MyText(
                  text: Helpers.convertEndateToFrdate(
                    Helpers.convertDateToString(dateEvaluation, 'dd/MM/YYYY'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateRemiseEvaluationUI() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: MyText(text: "Date de remise de l'évaluation:"),
          ),
          InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime(
                  dateEvaluation.year + 10,
                  dateEvaluation.month,
                  dateEvaluation.day,
                ),
              );
              if (picked != null) {
                setState(() {
                  dateRemise = picked;
                  if (evaluation != null) {
                    evaluation!.dateRemise = Helpers.convertDateToString(
                      picked,
                      'dd/MM/YYYY',
                    );
                  }
                });
              }
            },
            child: Row(
              children: [
                Icon(Icons.calendar_month, size: 15),
                MyText(
                  text:
                      dateRemise == null
                          ? ""
                          : Helpers.convertEndateToFrdate(
                            Helpers.convertDateToString(
                              dateRemise!,
                              'dd/MM/YYYY',
                            ),
                          ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectQuestionnaire() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: MyText(text: "Questionnaire:"),
          ),
          InkWell(
            onTap: () async {
              LoadingIndicatorDialog().show(
                context,
                text: AppLocalizations.of(context)!.wait,
              );
              fileResult = await FilePicker.platform.pickFiles(
                allowedExtensions: ['pdf', 'docx', 'doc'],
                type: FileType.custom,
              );
              LoadingIndicatorDialog().dismiss();
              if (fileResult != null) {
                setState(() {
                  file = File(fileResult!.files.first.path!);
                });
              } else {
                SnackBarService.instance.showSnackBarError(
                  "Aucun fichier selectionné",
                );
              }
            },
            child: Row(
              children: [
                Icon(Icons.attach_file, size: 15),
                MyText(
                  text:
                      file != null
                          ? fileResult!.names.first!
                          : "fichier pdf/docx/doc",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ponderationUI() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: MyText(text: "Pondération:"),
          ),
          SizedBox(
            width: 100,
            height: 25,
            child: TextFormField(
              onChanged: (input) {
                if (input.isNotEmpty) {
                  _formKey.currentState!.save();
                  setState(() {
                    try {
                      _ponderation = int.parse(input);
                    } catch (e) {
                      _ponderation = 0;
                    } finally {
                      if (evaluation != null) {
                        evaluation!.ponderation = _ponderation;
                      }
                    }
                  });
                }
              },
              validator:
                  (value) =>
                      value == null || value.isEmpty
                          ? AppLocalizations.of(
                            context,
                          )!.empty_conf_password_alert
                          : null,
              initialValue:
                  evaluation != null ? evaluation!.ponderation.toString() : "",
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.number,
              cursorColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _saveEvaluation() {
    if (_formKey.currentState!.validate()) {
      if (_typeEvaluation == null) {
        SnackBarService.instance.showSnackBarError(
          "Veuillez selectionner le type d'évaluation",
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
      if (_session == null) {
        SnackBarService.instance.showSnackBarError(
          "Veuillez selectionner la session",
        );
        return;
      }
      if (_ponderation <= 0) {
        SnackBarService.instance.showSnackBarError(
          "Veuillez saisir la pondération de l'évaluation",
        );
        return;
      }
      if (evaluation == null && file == null) {
        SnackBarService.instance.showSnackBarError(
          "Veuillez charger le questionnaire",
        );
        return;
      }
      if (evaluation == null) {
        EvaluationService.instance.addEvaluation(
          context,
          Evaluation(
            0,
            ClassesProvider.instance.classe!.id,
            ClassesProvider.instance.cours!.id,
            _periode!.id,
            _trimestre!.id,
            _session!.id,
            _typeEvaluation!.id,
            ClassesProvider.instance.classe!.designation,
            ClassesProvider.instance.cours!.designation,
            _typeEvaluation!.designation,
            _periode!.designation,
            _trimestre!.designation,
            _session!.designation,
            _ponderation,
            Helpers.convertDateToString(dateEvaluation, 'dd/MM/YYYY'),
            dateRemise != null
                ? Helpers.convertDateToString(dateRemise!, 'dd/MM/YYYY')
                : Helpers.convertDateToString(DateTime.now(), 'dd/MM/YYYY'),
            file!.path,
          ),
        );
      } else {
        evaluation!.idPeriode = _periode!.id;
        evaluation!.idTrimestre = _trimestre!.id;
        evaluation!.idSession = _session!.id;
        evaluation!.idTypeEvaluation = _typeEvaluation!.id;
        evaluation!.ponderation = _ponderation;
        evaluation!.dateEvaluation = Helpers.convertDateToString(
          dateEvaluation,
          'dd/MM/YYYY',
        );
        evaluation!.dateRemise =
            dateRemise != null
                ? Helpers.convertDateToString(dateRemise!, 'dd/MM/YYYY')
                : evaluation!.dateRemise;
        EvaluationService.instance.updateEvaluation(context, evaluation!, file);
      }
    } else {
      SnackBarService.instance.showSnackBarError(
        "Veuillez saisir la pondération de l'évaluation",
      );
    }
  }
}
