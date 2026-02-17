import 'package:eschoolmobile/models/creneau.dart';
import 'package:eschoolmobile/models/eleve.dart';

class Appel {
  Creneau creneau;
  Eleve eleve;
  String dateAppel;
  bool estPresent;

  Appel(this.creneau, this.eleve, this.dateAppel, {this.estPresent = false});
}
