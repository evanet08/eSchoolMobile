class Evaluation {
  int id;
  int idClasse;
  int idCours;
  int idPeriode;
  int idTrimestre;
  int idSession;
  int idTypeEvaluation;
  String classe;
  String cours;
  String typeEvaluation;
  String periode;
  String trimestre;
  String session;
  int ponderation;
  String dateEvaluation;
  String? dateRemise;
  String contenuEvaluation;
  bool isExpanded;

  Evaluation(
    this.id,
    this.idClasse,
    this.idCours,
    this.idPeriode,
    this.idTrimestre,
    this.idSession,
    this.idTypeEvaluation,
    this.classe,
    this.cours,
    this.typeEvaluation,
    this.periode,
    this.trimestre,
    this.session,
    this.ponderation,
    this.dateEvaluation,
    this.dateRemise,
    this.contenuEvaluation, {
    this.isExpanded = true,
  });
}
