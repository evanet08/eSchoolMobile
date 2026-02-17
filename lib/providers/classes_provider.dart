import 'package:flutter/material.dart';
import 'package:eschoolmobile/models/classe.dart';
import 'package:eschoolmobile/models/cours.dart';
import 'package:eschoolmobile/services/classe_service.dart';
import 'package:eschoolmobile/services/cours_service.dart';

class ClassesProvider extends ChangeNotifier {
  List<Classe> classes = [];
  List<Cours> courses = [];
  Classe? classe;
  Cours? cours;
  static ClassesProvider instance = ClassesProvider();

  Future<void> getClassesAndCourses(BuildContext context) async {
    classes = await ClasseService.instance.fetchClasses(context);
    courses = await CoursService.instance.fetchCours(context);
    notifyListeners();
  }

  void selectClasse(Classe classe) async {
    this.classe = classe;
    notifyListeners();
  }

  void selectCours(Cours cours) {
    this.cours = cours;
    notifyListeners();
  }
}
