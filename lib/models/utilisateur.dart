class Utilisateur {
  int id;
  String noms;
  String prenoms;
  String telephone;
  String dateNaissance;
  String lieuNaissance;
  String province;
  String ville;
  String idPicture;
  String profilePicture;
  bool sosFriend;
  bool checked;

  Utilisateur(
    this.id,
    this.noms,
    this.prenoms,
    this.telephone,
    this.dateNaissance,
    this.lieuNaissance,
    this.province,
    this.ville,
    this.idPicture,
    this.profilePicture, {
    this.sosFriend = false,
    this.checked = false,
  });
}
