import 'package:flutter/material.dart';
import 'package:eschoolmobile/models/eleve.dart';
import 'package:eschoolmobile/services/eleve_service.dart';

class EleveProvider extends ChangeNotifier {
  List<Eleve> eleves = [];
  Eleve? eleve;
  static EleveProvider instance = EleveProvider();

  Future<void> getEleves(BuildContext context) async {
    eleves = await EleveService.instance.fetchEleves(context);
    if (eleves.isNotEmpty) {
      eleve = eleves[0];
    } else {
      eleve = null;
    }
    notifyListeners();
  }

  void selectEleve(Eleve eleve) {
    this.eleve = eleve;
    notifyListeners();
  }
}
