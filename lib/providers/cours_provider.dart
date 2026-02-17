import 'package:flutter/material.dart';
import 'package:eschoolmobile/models/cours.dart';
import 'package:eschoolmobile/services/cours_service.dart';

class CoursProvider extends ChangeNotifier {
  List<Cours> courses = [];
  Cours? cours;
  static CoursProvider instance = CoursProvider();

  Future<void> getCourses(BuildContext context) async {
    courses = await CoursService.instance.fetchCours(context);
    notifyListeners();
  }

  void selectCours(Cours cours) {
    this.cours = cours;
    notifyListeners();
  }
}
