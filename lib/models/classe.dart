class Classe {
  int id;
  int idAnnee;
  int idCycle;
  int idCampus;
  int idClasse;
  String designation;
  String annee;
  String? groupe;
  String cycle;
  String campus;

  Classe(
    this.id,
    this.idClasse,
    this.designation,
    this.idAnnee,
    this.annee,
    this.idCycle,
    this.cycle,
    this.idCampus,
    this.campus, {
    this.groupe,
  });
}
