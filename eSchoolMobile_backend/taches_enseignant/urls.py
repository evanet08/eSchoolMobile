
from django.urls import path
from . import views

urlpatterns = [
    path('attributions_cours_enseignant/<int:id_annee>/<int:id_classe>', views.getAttributionsCoursEnseignant,name='attributions_cours_enseignant'),
    path('cours_eleve/<int:id_annee>/<int:id_eleve>', views.getCoursEleve,name='cours_eleve'),
    path('attributions_cours_enseignant_classe/<int:id_annee>/<int:id_classe>', views.getAttributionsCoursEnseignantByClass,name='attributions_cours_enseignant_classe'),
    path('classes_enseignant/<int:id_annee>',views.getClassesEnseignant,name="classes_enseignant"),
    path('creneaux_classes_enseignant/<int:id_annee>/<int:id_classe>/<int:id_cours>', views.getCreneauxClassesEnseignant,name='creneaux_classes_enseignant'),
    path('creneaux_eleve/<int:id_annee>/<int:id_eleve>/<int:id_cours>', views.getCreneauxEleve,name='creneaux_eleve'),
    path('evaluations/<int:id_annee>/<int:id_classe>/<int:id_cours>', views.afficherEvaluations,name='evaluations'),
    path('evaluations_eleve/<int:id_annee>/<int:id_eleve>/<int:id_cours>', views.afficherEvaluationsEleve,name='evaluations_eleve'),
    path('types_evaluations',views.afficherTypesEvaluations,name='types_evaluations'),
    path('trimestres',views.afficherTrimestres,name='trimestres'),
    path('periodes',views.afficherPeriodes,name='periodes'),
    path('sessions',views.afficherSessions,name='sessions'),
    path('eleves/<int:id_annee>/<int:id_classe>',views.getEleves,name='eleves'),
    path('enregistrer_presences',views.enregistrerPresences,name='enregistrer_presences'),
    path('enregistrer_evaluation',views.enregistrerEvaluation,name='enregistrer_evaluation'),
    path('modifier_evaluation/<int:id_evaluation>',views.modifierEvaluation,name='modifier_evaluation'),
    path('supprimer_evaluation/<int:id_evaluation>',views.supprimerEvaluation,name='supprimer_evaluation'),
    path('enregistrer_notes',views.enregistrerNotesEvaluation,name='enregistrer_notes'),
    path('afficher_notes_evaluation/<int:id_evaluation>',views.afficherNotesEvaluation,name='afficher_notes_evaluation'),
    path('enregistrer_conduite',views.enregistrerConduite,name='enregistrer_conduite'),
    path('presences/<int:id_creneau>',views.afficherPresences,name='presences'),
    path('conduites/<int:id_annee>/<int:id_classe>',views.afficherConduites,name='conduites'),
    path('conduites_eleve/<int:id_annee>/<int:id_eleve>/<int:id_cours>',views.afficherConduitesEleve,name='conduites_eleve'),
    path('rapports_periodique/<int:id_eleve>/<int:id_cours>/<str:debut>/<str:fin>/<int:id_annee>',views.afficher_rapports_periodique,name='rapports_periodique'),
    path('toggle_presence/<int:id_creneau>/<int:id_eleve>',views.togglePresenceStatus,name='toggle_presence'),
    path('download_file/<str:file_name>',views.download_file,name='download_file')
]