# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = True` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models
from django.contrib.auth.models import User


class Annee(models.Model):
    id_annee = models.AutoField(primary_key=True)
    debut = models.IntegerField(blank=True, null=True)
    fin = models.IntegerField(blank=True, null=True)
    annee = models.CharField(max_length=20)
    etat_annee = models.CharField(max_length=50)
    date_ouverture = models.DateField()
    date_cloture = models.DateField()

    class Meta:
        managed = True
        db_table = 'annee'


class AnneePeriode(models.Model):
    id_periode = models.AutoField(primary_key=True)
    periode = models.CharField(max_length=50)
    debut = models.DateField(blank=True, null=True)
    fin = models.DateField(blank=True, null=True)
    id_annee = models.ForeignKey(Annee, models.DO_NOTHING)
    id_campus = models.ForeignKey('Campus', models.DO_NOTHING)
    id_classe = models.ForeignKey('ClasseActive', models.DO_NOTHING)
    id_cycle = models.ForeignKey('ClasseCycleActif', models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'annee_periode'


class AnneeTrimestre(models.Model):
    id_trimestre = models.AutoField(primary_key=True)
    debut = models.DateField(blank=True, null=True)
    fin = models.DateField(blank=True, null=True)
    id_annee = models.ForeignKey(Annee, models.DO_NOTHING)
    id_campus = models.ForeignKey('Campus', models.DO_NOTHING)
    id_classe = models.ForeignKey('ClasseActive', models.DO_NOTHING)
    id_cycle = models.ForeignKey('ClasseCycleActif', models.DO_NOTHING)
    trimestre = models.ForeignKey('Trimestre', models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'annee_trimestre'


class AttributionCours(models.Model):
    id_attribution = models.AutoField(primary_key=True)
    id_annee = models.ForeignKey(Annee, models.DO_NOTHING)
    attribution_type = models.ForeignKey('AttributionType', models.DO_NOTHING)
    id_campus = models.ForeignKey('Campus', models.DO_NOTHING)
    id_classe = models.ForeignKey('ClasseActive', models.DO_NOTHING)
    id_cycle = models.ForeignKey('ClasseCycleActif', models.DO_NOTHING)
    id_cours = models.ForeignKey('CoursParClasse', models.DO_NOTHING)
    id_personnel = models.ForeignKey('Personnel', models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'attribution_cours'


class AttributionType(models.Model):
    id_attribution_type = models.AutoField(primary_key=True)
    attribution_type = models.CharField(max_length=250)

    class Meta:
        managed = True
        db_table = 'attribution_type'


# Removed Auth models to avoid conflict with django.contrib.auth


class Campus(models.Model):
    id_campus = models.AutoField(primary_key=True)
    campus = models.CharField(max_length=50)
    adresse = models.CharField(max_length=255)
    localisation = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'campus'


class ClasseActive(models.Model):
    id_classe_active = models.AutoField(primary_key=True)
    id_campus = models.ForeignKey(Campus, models.DO_NOTHING)
    id_annee = models.ForeignKey(Annee, models.DO_NOTHING)
    cycle_id = models.ForeignKey('ClasseCycleActif', models.DO_NOTHING)
    classe_id = models.ForeignKey('Classes', models.DO_NOTHING)
    groupe = models.CharField(max_length=10, blank=True, null=True)
    isterminale = models.IntegerField(db_column='isTerminale')  # Field name made lowercase.

    class Meta:
        managed = True
        db_table = 'classe_active'


class ClasseActiveResponsable(models.Model):
    id_classe_active_resp = models.AutoField(primary_key=True)
    id_annee = models.ForeignKey(Annee, models.DO_NOTHING)
    id_campus = models.ForeignKey(Campus, models.DO_NOTHING)
    id_classe = models.ForeignKey(ClasseActive, models.DO_NOTHING)
    id_cycle = models.ForeignKey('ClasseCycleActif', models.DO_NOTHING)
    id_personnel = models.ForeignKey('Personnel', models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'classe_active_responsable'


class ClasseCycle(models.Model):
    id_cycle = models.AutoField(primary_key=True)
    cycle = models.CharField(max_length=200)

    class Meta:
        managed = True
        db_table = 'classe_cycle'


class ClasseCycleActif(models.Model):
    id_cycle_actif = models.AutoField(primary_key=True)
    role = models.CharField(max_length=255, blank=True, null=True)
    cycle_id = models.ForeignKey(ClasseCycle, models.DO_NOTHING)
    id_annee = models.ForeignKey(Annee, models.DO_NOTHING)
    id_campus = models.ForeignKey(Campus, models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'classe_cycle_actif'


class ClasseDeliberation(models.Model):
    id_deliberation = models.AutoField(primary_key=True)
    date_deliberation = models.DateField()
    showresults = models.IntegerField(db_column='showResults')  # Field name made lowercase.
    showsresultsenordre = models.IntegerField(db_column='showsResultsEnOrdre')  # Field name made lowercase.
    id_annee = models.ForeignKey(Annee, models.DO_NOTHING)
    id_campus = models.ForeignKey(Campus, models.DO_NOTHING)
    id_classe = models.ForeignKey(ClasseActive, models.DO_NOTHING)
    id_cycle = models.ForeignKey(ClasseCycleActif, models.DO_NOTHING)
    id_session = models.ForeignKey('Session', models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'classe_deliberation'


class ClasseSection(models.Model):
    id_section = models.AutoField(primary_key=True)
    section = models.CharField(max_length=100)
    id_annee = models.ForeignKey(Annee, models.DO_NOTHING)
    id_campus = models.ForeignKey(Campus, models.DO_NOTHING)
    id_classe = models.ForeignKey(ClasseActive, models.DO_NOTHING)
    id_cycle = models.ForeignKey(ClasseCycleActif, models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'classe_section'


class Classes(models.Model):
    id_classe = models.AutoField(primary_key=True)
    classe = models.CharField(max_length=50)

    class Meta:
        managed = True
        db_table = 'classes'


class Cours(models.Model):
    id_cours = models.AutoField(primary_key=True)
    cours = models.CharField(max_length=150)
    code_cours = models.CharField(max_length=15, blank=True, null=True)
    domaine = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'cours'


class CoursParClasse(models.Model):
    id_cours_classe = models.AutoField(primary_key=True)
    ponderation = models.IntegerField(blank=True, null=True)
    cm = models.IntegerField(db_column='CM', blank=True, null=True)  # Field name made lowercase.
    td = models.IntegerField(db_column='TD', blank=True, null=True)  # Field name made lowercase.
    tp = models.IntegerField(db_column='TP', blank=True, null=True)  # Field name made lowercase.
    tpe = models.IntegerField(db_column='TPE', blank=True, null=True)  # Field name made lowercase.
    id_annee = models.ForeignKey(Annee, models.DO_NOTHING)
    id_campus = models.ForeignKey(Campus, models.DO_NOTHING)
    id_classe = models.ForeignKey(ClasseActive, models.DO_NOTHING)
    id_cours = models.ForeignKey(Cours, models.DO_NOTHING)
    id_cycle = models.ForeignKey(ClasseCycleActif, models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'cours_par_classe'


class CoursParCycle(models.Model):
    id_cours_cycle = models.AutoField(primary_key=True)
    cours_id = models.ForeignKey(Cours, models.DO_NOTHING)
    cycle_id = models.ForeignKey(ClasseCycleActif, models.DO_NOTHING)
    id_annee = models.ForeignKey(Annee, models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'cours_par_cycle'
        unique_together = (('cours_id', 'cycle_id', 'id_annee'),)


class DeliberationAnnuelleConditions(models.Model):
    id_decision = models.AutoField(primary_key=True)
    sigle = models.CharField(max_length=10)
    decision = models.CharField(max_length=50)
    pourcentage_requis_reussite = models.IntegerField()
    max_echecs_acceptable = models.IntegerField()
    seuil_profondeur_echec = models.IntegerField()
    sanction_disciplinaire = models.CharField(max_length=10)
    id_finalite = models.ForeignKey('DeliberationAnnuelleFinalites', models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'deliberation_annuelle_conditions'


class DeliberationAnnuelleFinalites(models.Model):
    id_finalite = models.AutoField(primary_key=True)
    finalite = models.CharField(max_length=50)
    droit_avancement = models.IntegerField()

    class Meta:
        managed = True
        db_table = 'deliberation_annuelle_finalites'


class DeliberationAnnuelleResultats(models.Model):
    id_deliberation = models.AutoField(primary_key=True)
    groupe = models.CharField(max_length=3)
    pourcentage = models.FloatField()
    id_annee = models.ForeignKey(Annee, models.DO_NOTHING)
    id_campus = models.ForeignKey(Campus, models.DO_NOTHING)
    id_classe = models.ForeignKey(ClasseActive, models.DO_NOTHING)
    id_cycle = models.ForeignKey(ClasseCycleActif, models.DO_NOTHING)
    id_decision = models.ForeignKey(DeliberationAnnuelleConditions, models.DO_NOTHING)
    id_eleve = models.ForeignKey('Eleve', models.DO_NOTHING)
    id_mention = models.ForeignKey('Mention', models.DO_NOTHING)
    id_session = models.ForeignKey('Session', models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'deliberation_annuelle_resultats'


class DeliberationPeriodiqueResultats(models.Model):
    id_deliberation = models.AutoField(primary_key=True)
    pourcentage = models.FloatField()
    id_annee = models.ForeignKey(Annee, models.DO_NOTHING)
    id_campus = models.ForeignKey(Campus, models.DO_NOTHING)
    id_classe = models.ForeignKey(ClasseActive, models.DO_NOTHING)
    id_cycle = models.ForeignKey(ClasseCycleActif, models.DO_NOTHING)
    id_decision = models.ForeignKey(DeliberationAnnuelleConditions, models.DO_NOTHING)
    id_eleve = models.ForeignKey('Eleve', models.DO_NOTHING)
    id_mention = models.ForeignKey('Mention', models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'deliberation_periodique_resultats'


class DeliberationTrimistrielleResultats(models.Model):
    id_deliberation = models.AutoField(primary_key=True)
    groupe = models.CharField(max_length=3)
    pourcentage = models.FloatField()
    id_annee = models.ForeignKey(Annee, models.DO_NOTHING)
    id_campus = models.ForeignKey(Campus, models.DO_NOTHING)
    id_classe = models.ForeignKey(ClasseActive, models.DO_NOTHING)
    id_cycle = models.ForeignKey(ClasseCycleActif, models.DO_NOTHING)
    id_decision = models.ForeignKey(DeliberationAnnuelleConditions, models.DO_NOTHING)
    id_eleve = models.ForeignKey('Eleve', models.DO_NOTHING)
    id_mention = models.ForeignKey('Mention', models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'deliberation_trimistrielle_resultats'


class Diplome(models.Model):
    id_diplome = models.AutoField(primary_key=True)
    diplome = models.CharField(unique=True, max_length=50)
    sigle = models.CharField(unique=True, max_length=10)

    class Meta:
        managed = True
        db_table = 'diplome'


# Removed Django models to avoid conflict


class Ecole(models.Model):
    id_ecole = models.AutoField(primary_key=True)
    nom_ecole = models.CharField(max_length=250)
    sigle = models.CharField(max_length=50)
    telephone = models.CharField(max_length=50)
    email = models.CharField(max_length=50)
    domaine = models.CharField(max_length=50)
    site = models.CharField(max_length=50)
    logo_ecole = models.CharField(max_length=100, blank=True, null=True)
    logo_ministere = models.CharField(max_length=100, blank=True, null=True)
    siege = models.CharField(max_length=50)
    fax = models.CharField(max_length=20)
    representant = models.CharField(max_length=50)
    b_postale = models.CharField(max_length=50)
    emplacement = models.CharField(max_length=50)

    class Meta:
        managed = True
        db_table = 'ecole'


class Parent(models.Model):
    id_parent = models.AutoField(primary_key=True)
    nom = models.CharField(max_length=250)
    prenom = models.CharField(max_length=250)
    telephone = models.CharField(unique=True, max_length=128)
    email = models.CharField(unique=True, max_length=254, blank=True, null=True)
    password = models.CharField(max_length=300)
    code_secret_parent = models.CharField(max_length=250, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'parent'

class ParentOperation(models.Model):
    id_operation = models.AutoField(primary_key=True)
    libelle_operation = models.CharField(max_length=250)
    code_action = models.CharField(max_length=100, blank=True, null=True)
    icone_name = models.CharField(max_length=100, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'parent_operations'

class Eleve(models.Model):
    id_eleve = models.AutoField(primary_key=True)
    nom = models.CharField(max_length=250)
    prenom = models.CharField(max_length=50)
    genre = models.CharField(max_length=50)
    etat_civil = models.CharField(max_length=50, blank=True, null=True)
    code_eleve = models.CharField(max_length=250, blank=True, null=True)
    code_annee = models.IntegerField(blank=True, null=True)
    matricule = models.CharField(max_length=50, blank=True, null=True)
    nom_pere = models.CharField(max_length=200, blank=True, null=True)
    prenom_pere = models.CharField(max_length=200, blank=True, null=True)
    nom_mere = models.CharField(max_length=200, blank=True, null=True)
    prenom_mere = models.CharField(max_length=200, blank=True, null=True)
    email = models.CharField(max_length=254, blank=True, null=True)
    email_parent = models.CharField(max_length=254, blank=True, null=True)
    password_parent = models.CharField(max_length=300, blank=True, null=True)
    password = models.CharField(max_length=300, blank=True, null=True)
    tutaire = models.CharField(max_length=250, blank=True, null=True)
    telephone = models.CharField(max_length=128, blank=True, null=True)
    date_naissance = models.DateField(blank=True, null=True)
    naissance_region = models.CharField(max_length=30, blank=True, null=True)
    naissance_pays = models.CharField(max_length=30, blank=True, null=True)
    naissance_province = models.CharField(max_length=30, blank=True, null=True)
    naissance_commune = models.CharField(max_length=30, blank=True, null=True)
    naissance_zone = models.CharField(max_length=30, blank=True, null=True)
    province_actuelle = models.CharField(max_length=20, blank=True, null=True)
    commune_actuelle = models.CharField(max_length=20, blank=True, null=True)
    zone_actuelle = models.CharField(max_length=20, blank=True, null=True)
    imageurl = models.CharField(db_column='imageUrl', max_length=100, blank=True, null=True)  # Field name made lowercase.
    nationalite = models.CharField(max_length=50, blank=True, null=True)
    professionpere = models.CharField(db_column='professionPere', max_length=100, blank=True, null=True)  # Field name made lowercase.
    professionmere = models.CharField(db_column='professionMere', max_length=100, blank=True, null=True)  # Field name made lowercase.
    profsion_tutaire = models.CharField(max_length=100, blank=True, null=True)
    idelivrancelieuetdate = models.CharField(db_column='IDelivranceLieuEtDate', max_length=100, blank=True, null=True)  # Field name made lowercase.
    code_secret_parent = models.CharField(max_length=250, blank=True, null=True)
    code_secret_eleve = models.CharField(max_length=250, blank=True, null=True)
    id_parent = models.ForeignKey('Parent', models.DO_NOTHING, db_column='id_parent', blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'eleve'


class EleveConduite(models.Model):
    id_eleve_conduite = models.AutoField(primary_key=True)
    motif = models.CharField(max_length=255)
    quote = models.PositiveIntegerField()
    id_annee = models.ForeignKey(Annee, models.DO_NOTHING)
    id_campus = models.ForeignKey(Campus, models.DO_NOTHING)
    id_classe = models.ForeignKey(ClasseActive, models.DO_NOTHING)
    id_cycle = models.ForeignKey(ClasseCycleActif, models.DO_NOTHING)
    id_eleve = models.ForeignKey(Eleve, models.DO_NOTHING)
    id_horaire = models.ForeignKey('Horaire', models.DO_NOTHING)
    id_periode = models.ForeignKey('Periode', models.DO_NOTHING)
    id_session = models.ForeignKey('Session', models.DO_NOTHING)
    id_trimestre = models.ForeignKey('Trimestre', models.DO_NOTHING)
    date_enregistrement = models.DateField()

    class Meta:
        managed = True
        db_table = 'eleve_conduite'


class EleveInscription(models.Model):
    id_inscription = models.AutoField(primary_key=True)
    date_inscription = models.DateField()
    id_annee = models.ForeignKey(Annee, models.DO_NOTHING)
    id_campus = models.ForeignKey(Campus, models.DO_NOTHING)
    id_classe = models.ForeignKey(ClasseActive, models.DO_NOTHING)
    id_classe_cycle = models.ForeignKey(ClasseCycleActif, models.DO_NOTHING)
    id_eleve = models.ForeignKey(Eleve, models.DO_NOTHING)
    id_trimestre = models.ForeignKey('Trimestre', models.DO_NOTHING)
    status = models.IntegerField()
    redoublement = models.IntegerField()
    isdelegue = models.IntegerField(db_column='isDelegue')  # Field name made lowercase.

    class Meta:
        managed = True
        db_table = 'eleve_inscription'


class EleveNote(models.Model):
    id_note = models.AutoField(primary_key=True)
    date_saisie = models.DateField()
    note = models.DecimalField(max_digits=5, decimal_places=2, blank=True, null=True)
    id_annee = models.ForeignKey(Annee, models.DO_NOTHING)
    id_campus = models.ForeignKey(Campus, models.DO_NOTHING)
    id_classe_active = models.ForeignKey(ClasseActive, models.DO_NOTHING)
    id_cours_classe = models.ForeignKey(CoursParClasse, models.DO_NOTHING)
    id_cycle_actif = models.ForeignKey(ClasseCycleActif, models.DO_NOTHING)
    id_eleve = models.ForeignKey(Eleve, models.DO_NOTHING)
    id_type_note = models.ForeignKey('EleveNoteType', models.DO_NOTHING)
    id_evaluation = models.ForeignKey('Evaluation', models.DO_NOTHING)
    id_periode = models.ForeignKey('Periode', models.DO_NOTHING)
    id_session = models.ForeignKey('Session', models.DO_NOTHING)
    id_trimestre = models.ForeignKey('Trimestre', models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'eleve_note'


class EleveNoteType(models.Model):
    id_type_note = models.AutoField(primary_key=True)
    type = models.CharField(max_length=250)
    sigle = models.CharField(max_length=50)

    class Meta:
        managed = True
        db_table = 'eleve_note_type'


class Evaluation(models.Model):
    id_evaluation = models.AutoField(primary_key=True)
    title = models.CharField(max_length=200)
    ponderer_eval = models.PositiveIntegerField()
    date_eval = models.DateField()
    date_soumission = models.DateField(blank=True, null=True)
    contenu_evaluation = models.CharField(max_length=100)
    id_annee = models.ForeignKey(Annee, models.DO_NOTHING)
    id_campus = models.ForeignKey(Campus, models.DO_NOTHING)
    id_classe_active = models.ForeignKey(ClasseActive, models.DO_NOTHING)
    id_cours_classe = models.ForeignKey(CoursParClasse, models.DO_NOTHING)
    id_cycle_actif = models.ForeignKey(ClasseCycleActif, models.DO_NOTHING)
    id_type_note = models.ForeignKey(EleveNoteType, models.DO_NOTHING)
    id_periode = models.ForeignKey('Periode', models.DO_NOTHING)
    id_session = models.ForeignKey('Session', models.DO_NOTHING)
    id_trimestre = models.ForeignKey('Trimestre', models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'evaluation'


class Horaire(models.Model):
    id_horaire = models.AutoField(primary_key=True)
    jour = models.CharField(max_length=100)
    debut = models.CharField(max_length=100)
    fin = models.CharField(max_length=100)
    id_annee = models.ForeignKey(Annee, models.DO_NOTHING)
    id_campus = models.ForeignKey(Campus, models.DO_NOTHING)
    id_classe = models.ForeignKey(ClasseActive, models.DO_NOTHING)
    id_cours = models.ForeignKey(CoursParClasse, models.DO_NOTHING)
    id_cycle = models.ForeignKey(ClasseCycleActif, models.DO_NOTHING)
    id_horaire_type = models.ForeignKey('HoraireType', models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'horaire'


class HorairePresence(models.Model):
    id_horaire_presence = models.AutoField(primary_key=True)
    present_ou_absent = models.IntegerField()
    date_presence = models.DateField()
    si_absent_motif = models.CharField(max_length=255, blank=True, null=True)
    id_eleve = models.ForeignKey(Eleve, models.DO_NOTHING)
    id_horaire = models.ForeignKey(Horaire, models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'horaire_presence'


class HoraireType(models.Model):
    id_horaire_type = models.AutoField(primary_key=True)
    horaire_type = models.CharField(max_length=200)

    class Meta:
        managed = True
        db_table = 'horaire_type'


class Mention(models.Model):
    id_mention = models.AutoField(primary_key=True)
    mention = models.CharField(max_length=30)
    abbreviation = models.CharField(max_length=5)
    min = models.FloatField()
    max = models.FloatField()

    class Meta:
        managed = True
        db_table = 'mention'


class Module(models.Model):
    id_module = models.AutoField(primary_key=True)
    module = models.CharField(max_length=100)
    description = models.TextField(blank=True, null=True)
    url_name = models.CharField(max_length=100, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'module'


class Periode(models.Model):
    id_periode = models.AutoField(primary_key=True)
    periode = models.CharField(max_length=20)
    etat_periode = models.CharField(max_length=50)
    id_trimestre = models.ForeignKey('Trimestre', models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'periode'


class Personnel(models.Model):
    id_personnel = models.AutoField(primary_key=True)
    codeannee = models.CharField(db_column='codeAnnee', max_length=200, blank=True, null=True)  # Field name made lowercase.
    matricule = models.CharField(unique=True, max_length=20)
    date_naissance = models.DateField(blank=True, null=True)
    genre = models.CharField(max_length=22)
    etat_civil = models.CharField(max_length=200)
    type_identite = models.CharField(max_length=200)
    numero_identite = models.CharField(max_length=20, blank=True, null=True)
    telephone = models.CharField(max_length=128, blank=True, null=True)
    region = models.CharField(max_length=200, blank=True, null=True)
    pays = models.CharField(max_length=200, blank=True, null=True)
    province = models.CharField(max_length=200)
    commune = models.CharField(max_length=200)
    code_secret = models.TextField(blank=True, null=True)
    zone = models.CharField(max_length=200)
    addresse = models.CharField(max_length=200)
    imageurl = models.CharField(db_column='imageUrl', max_length=100, blank=True, null=True)  # Field name made lowercase.
    ismaitresse = models.IntegerField(db_column='isMaitresse')  # Field name made lowercase.
    isinstiteur = models.IntegerField(db_column='isInstiteur')  # Field name made lowercase.
    isdaf = models.IntegerField(db_column='isDAF')  # Field name made lowercase.
    isdirecteur = models.IntegerField(db_column='isDirecteur')  # Field name made lowercase.
    isuser = models.IntegerField(db_column='isUser')  # Field name made lowercase.
    en_fonction = models.IntegerField()
    is_verified = models.IntegerField()
    id_diplome = models.ForeignKey(Diplome, models.DO_NOTHING)
    user = models.OneToOneField(User, models.DO_NOTHING)
    id_categorie = models.ForeignKey('PersonnelCategorie', models.DO_NOTHING)
    id_personnel_type = models.ForeignKey('PersonnelType', models.DO_NOTHING)
    id_specialite = models.ForeignKey('Specialite', models.DO_NOTHING)
    id_vacation = models.ForeignKey('Vacation', models.DO_NOTHING)
    id_posteAdministratif = models.ForeignKey('PosteAdministratif', models.DO_NOTHING, db_column='id_posteAdministratif', blank=True, null=True)
    id_tache = models.ForeignKey('TacheEnseignant', models.DO_NOTHING, db_column='id_tache', blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'personnel'


class PersonnelCategorie(models.Model):
    id_personnel_category = models.AutoField(primary_key=True)
    categorie = models.CharField(unique=True, max_length=50)
    sigle = models.CharField(max_length=10, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'personnel_categorie'


class PosteAdministratif(models.Model):
    id_posteAdministratif = models.AutoField(primary_key=True)
    poste = models.CharField(max_length=255)

    class Meta:
        managed = True
        db_table = 'personnel_posteAdministratif'


class TacheEnseignant(models.Model):
    id_tache = models.AutoField(primary_key=True)
    tache = models.CharField(max_length=255)

    class Meta:
        managed = True
        db_table = 'personnelEnseignant_Taches'


class PersonnelType(models.Model):
    id_type_personnel = models.AutoField(primary_key=True)
    type = models.CharField(unique=True, max_length=50)
    sigle = models.CharField(unique=True, max_length=50)

    class Meta:
        managed = True
        db_table = 'personnel_type'


class Prestation(models.Model):
    id_prestation = models.AutoField(primary_key=True)
    heured = models.CharField(db_column='heureD', max_length=20)  # Field name made lowercase.
    heuref = models.CharField(db_column='heureF', max_length=20)  # Field name made lowercase.
    id_horaire = models.IntegerField()
    id_etudiant = models.IntegerField()
    id_personnel = models.ForeignKey(Personnel, models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'prestation'


class Salle(models.Model):
    id_salle = models.AutoField(primary_key=True)
    salle = models.CharField(max_length=250)
    partage = models.IntegerField()
    capacite = models.IntegerField()
    id_annee = models.ForeignKey(Annee, models.DO_NOTHING)
    id_campus = models.ForeignKey(Campus, models.DO_NOTHING)
    id_classe = models.ForeignKey(ClasseActive, models.DO_NOTHING)
    id_cycle = models.ForeignKey(ClasseCycleActif, models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'salle'


class Session(models.Model):
    id_session = models.AutoField(primary_key=True)
    session = models.CharField(unique=True, max_length=20)

    class Meta:
        managed = True
        db_table = 'session'


class Specialite(models.Model):
    id_specialite = models.AutoField(primary_key=True)
    specialite = models.CharField(max_length=200)
    sigle = models.CharField(max_length=10)

    class Meta:
        managed = True
        db_table = 'specialite'


class Trimestre(models.Model):
    id_trimestre = models.AutoField(primary_key=True)
    trimestre = models.CharField(max_length=20)
    etat_trimestre = models.CharField(max_length=50)
    date_ouverture = models.DateField()
    date_cloture = models.DateField()

    class Meta:
        managed = True
        db_table = 'trimestre'


class UserEnseignement(models.Model):
    id_user_enseignant = models.AutoField(primary_key=True)
    canmodify = models.IntegerField(db_column='canModify')  # Field name made lowercase.
    canonlyview = models.IntegerField(db_column='canOnlyView')  # Field name made lowercase.
    classe_id = models.ForeignKey(ClasseActive, models.DO_NOTHING)
    cycle_id = models.ForeignKey(ClasseCycleActif, models.DO_NOTHING)
    id_annee = models.ForeignKey(Annee, models.DO_NOTHING)
    id_campus = models.ForeignKey(Campus, models.DO_NOTHING)
    id_personnel = models.ForeignKey(Personnel, models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'user_enseignement'


class UserModule(models.Model):
    id_user_module = models.AutoField(primary_key=True)
    is_active = models.IntegerField()
    module = models.ForeignKey(Module, models.DO_NOTHING)
    user = models.ForeignKey(Personnel, models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'user_module'


class UsersOtherModule(models.Model):
    id_user_per_module = models.AutoField(primary_key=True)
    id_module = models.IntegerField()
    user = models.IntegerField()
    id_personnel = models.ForeignKey(Personnel, models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'users_other_module'


class Vacation(models.Model):
    id_vacation = models.AutoField(primary_key=True)
    vacation = models.CharField(max_length=20)
    sigle = models.CharField(max_length=10)

    class Meta:
        managed = True
        db_table = 'vacation'
