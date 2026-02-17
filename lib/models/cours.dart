class Cours {
  int id;
  int idAnnee;
  int idCycle;
  int idCampus;
  int idCours;
  String designation;
  String annee;
  String cycle;
  String campus;
  int ponderation;
  int? cm;
  int? td;
  int? tp;
  int? tpe;

  Cours(
    this.id,
    this.idCours,
    this.designation,
    this.cm,
    this.td,
    this.tp,
    this.tpe,
    this.ponderation,
    this.idAnnee,
    this.annee,
    this.idCycle,
    this.cycle,
    this.idCampus,
    this.campus,
  );
}
