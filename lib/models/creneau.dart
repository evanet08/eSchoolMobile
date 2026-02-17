class Creneau {
  int id;
  int idClasse;
  int idCours;
  int idAnnee;
  int idCycle;
  int idCampus;
  String jour;
  String heureDebut;
  String heureFin;
  String cours;
  String classe;
  String annee;
  String? groupe;
  String cycle;
  String campus;

  Creneau(
    this.id,
    this.idClasse,
    this.idCours,
    this.idAnnee,
    this.idCycle,
    this.idCampus,

    this.jour,
    this.heureDebut,
    this.heureFin,
    this.cours,
    this.classe,
    this.annee,
    this.cycle,
    this.campus, {
    this.groupe,
  });
  get date => null;

  @override
  bool operator ==(Object other) => other is Creneau && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
