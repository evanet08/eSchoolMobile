import 'package:eschoolmobile/models/classe.dart';
import 'package:eschoolmobile/models/utilisateur.dart';

class Eleve {
  int id;
  String noms;
  String prenom;
  Classe classe;
  Utilisateur? papa;
  Utilisateur? maman;
  String? adresse;

  Eleve(
    this.id,
    this.noms,
    this.prenom,
    this.classe, {
    this.adresse,
    this.papa,
    this.maman,
  });
}
