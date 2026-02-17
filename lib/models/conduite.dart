import 'package:eschoolmobile/models/creneau.dart';
import 'package:eschoolmobile/models/eleve.dart';

class Conduite {
  int id;
  int mention;
  String date;
  Creneau creneau;
  Eleve eleve;
  String? motif;
  Conduite(
    this.id,
    this.creneau,
    this.date,
    this.eleve, {
    this.mention = 5,
    this.motif,
  });
}
