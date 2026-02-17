import 'package:flutter/material.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:eschoolmobile/helpers.dart';
import 'package:eschoolmobile/models/evaluation.dart';
import 'package:eschoolmobile/providers/classes_provider.dart';
import 'package:eschoolmobile/services/file_service.dart';
import 'package:eschoolmobile/services/navigation_service.dart';
import 'package:eschoolmobile/utils/theme/constantes/font_size_constantes.dart';
import 'package:eschoolmobile/utils/theme/constantes/icon_size_constantes.dart';

class EvaluationItem extends StatelessWidget {
  final Evaluation evaluation;
  final Function()? deleteEvaluation;
  const EvaluationItem({
    super.key,
    required this.evaluation,
    this.deleteEvaluation,
  });

  @override
  Widget build(BuildContext context) {
    int maxSteps = 0;
    if (evaluation.dateRemise != null && evaluation.dateRemise != "") {
      maxSteps =
          Helpers.differenceBetweenTwoDates(
            DateTime.parse(evaluation.dateRemise!),
            DateTime.parse(evaluation.dateEvaluation),
          ).inDays;
    }
    int currentStep = 0;
    if (evaluation.dateRemise != null && evaluation.dateRemise != "") {
      currentStep =
          Helpers.differenceBetweenTwoDates(
            DateTime.now(),
            DateTime.parse(evaluation.dateEvaluation),
          ).inDays;
    }
    double pourcentage = 100 * currentStep / maxSteps;

    return PopupMenuButton(
      onSelected: (value) {
        for (var classe in ClassesProvider.instance.classes) {
          if (classe.id == evaluation.idClasse) {
            ClassesProvider.instance.classe = classe;
          }
        }
        switch (value) {
          case 1:
            NavigationService.instance.navigateTo(
              "new_evaluation",
              args: evaluation,
            );
            break;
          case 2:
            FileService.instance.downloadFile(
              context,
              evaluation.contenuEvaluation,
            );
            break;
          case 3:
            NavigationService.instance.navigateTo(
              'notes_evaluation',
              args: evaluation,
            );
            break;
          case 4:
            NavigationService.instance.navigateTo(
              'enregistrement_notes',
              args: evaluation,
            );
            break;
          case 5:
            deleteEvaluation != null ? deleteEvaluation!() : () {};
            break;
        }
      },
      itemBuilder:
          (BuildContext context) => [
            PopupMenuItem(
              value: 1,
              child: Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: Colors.blue,
                    size: IconSizeConstantes.small,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Modifier",
                    style: TextStyle().copyWith(
                      color: Colors.blue,
                      fontSize: FontSizeConstantes.mediumFontsize,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 2,
              child: Row(
                children: [
                  Icon(
                    Icons.download,
                    color: Colors.black,
                    size: IconSizeConstantes.small,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Télécharger le questionnaire",
                    style: TextStyle().copyWith(
                      color: Colors.black,
                      fontSize: FontSizeConstantes.mediumFontsize,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 3,
              child: Row(
                children: [
                  Icon(
                    Icons.note,
                    color: Colors.black,
                    size: IconSizeConstantes.small,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Voir les notes",
                    style: TextStyle().copyWith(
                      color: Colors.black,
                      fontSize: FontSizeConstantes.mediumFontsize,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 4,
              child: Row(
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.black,
                    size: IconSizeConstantes.small,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Transcrire les notes",
                    style: TextStyle().copyWith(
                      color: Colors.black,
                      fontSize: FontSizeConstantes.mediumFontsize,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 5,
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: IconSizeConstantes.small,
                  ),
                  Text(
                    "Supprimer l'évaluation",
                    style: TextStyle().copyWith(
                      color: Colors.red,
                      fontSize: FontSizeConstantes.smallFontsize,
                    ),
                  ),
                ],
              ),
            ),
          ],
      child: Card(
        elevation: 0,
        color: Colors.white70,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "${evaluation.typeEvaluation} de ${evaluation.cours}",
                              textAlign: TextAlign.center,
                              style: TextStyle().copyWith(
                                color: Colors.black,
                                fontSize: FontSizeConstantes.mediumFontsize,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Text(
                            "${evaluation.ponderation} points",
                            style: TextStyle().copyWith(
                              color: Theme.of(context).primaryColor,
                              fontSize: FontSizeConstantes.smallFontsize,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Text(
                              Helpers.convertEndateToFrdate(
                                evaluation.dateEvaluation,
                              ),
                              style: TextStyle().copyWith(
                                color: Colors.blue,
                                fontSize: FontSizeConstantes.smallFontsize,
                              ),
                            ),
                          ),

                          evaluation.dateRemise != null &&
                                  evaluation.dateRemise != "" &&
                                  maxSteps > 0
                              ? Expanded(
                                child: Stack(
                                  children: [
                                    LinearProgressBar(
                                      maxSteps: maxSteps,
                                      backgroundColor: Colors.grey,
                                      progressColor:
                                          pourcentage <= 50
                                              ? Colors.blue
                                              : pourcentage > 50 &&
                                                  pourcentage <= 70
                                              ? Colors.orange
                                              : pourcentage >= 100
                                              ? Colors.grey
                                              : Colors.red,
                                      currentStep: currentStep,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      bottom: 10,
                                      child: Center(
                                        child:
                                            pourcentage < 100
                                                ? Text(
                                                  "Dans ${maxSteps - currentStep} jours",
                                                  style: TextStyle().copyWith(
                                                    color: Colors.black,
                                                    fontSize:
                                                        FontSizeConstantes
                                                            .smallFontsize,
                                                  ),
                                                )
                                                : Icon(
                                                  Icons.cancel_outlined,
                                                  color: Colors.red,
                                                  size: 25,
                                                ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : const SizedBox(),
                          evaluation.dateRemise != null &&
                                  evaluation.dateRemise != ""
                              ? Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(
                                  Helpers.convertEndateToFrdate(
                                    evaluation.dateRemise!,
                                  ),
                                  style: TextStyle().copyWith(
                                    color: Colors.red,
                                    fontSize: FontSizeConstantes.smallFontsize,
                                  ),
                                ),
                              )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.more_vert, color: Colors.black, size: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
