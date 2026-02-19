from django.urls import path
from . import views
urlpatterns = [
    path('annees_scolaires', views.getAnneesScolaires, name='annees_scolaires'),
    path('verification_user_by_phone/<str:phoneNumber>/<str:typeUser>',views.verificationUserByPhoneNumber,name="verification_user_by_phone"),
    path('verification_user_by_secret_code/<str:phoneNumber>/<str:code>/<str:typeUser>',views.verificationUserBySecretCode,name="verification_user_by_secret_code"),
    path('create_user_account/<str:code>/<str:typeUser>',views.creationCompteUser,name="create_user_account"),
    path('login',views.login,name="login"),
    path('teacher_tasks', views.getTeacherTasks, name='teacher_tasks'),
    path('admin_postes', views.getPostesAdministratifs, name='admin_postes'),
    path('parent_operations', views.getParentOperations, name='parent_operations'),
    path('utilisateurs', views.getUtilisateurs, name='utilisateurs'),
    # Parent-specific endpoints
    path('parent/enfants', views.getParentEnfants, name='parent_enfants'),
    path('parent/enfant/<int:id_eleve>/notes', views.getEnfantNotes, name='enfant_notes'),
    path('parent/enfant/<int:id_eleve>/evaluations', views.getEnfantEvaluations, name='enfant_evaluations'),
    path('parent/enfant/<int:id_eleve>/cours', views.getEnfantCours, name='enfant_cours'),
    path('parent/enfant/<int:id_eleve>/bulletin', views.getEnfantBulletin, name='enfant_bulletin'),
]