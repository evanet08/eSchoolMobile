
import os
import django
import sys
from datetime import date

sys.path.append('/home/drevaristen/Desktop/eSchoolMobile/eSchoolMobile_backend')
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'monecole_ws.settings')
django.setup()

from django.contrib.auth.hashers import make_password
from django.contrib.auth.models import User
from account_creation.models import (
    Annee, Campus, Classes, ClasseCycle, ClasseCycleActif, ClasseActive,
    Parent, Eleve, ParentOperation, Personnel, PersonnelCategorie,
    PersonnelType, PosteAdministratif, Diplome, Specialite, Vacation,
    Trimestre, EleveInscription, TacheEnseignant
)
# from taches_enseignant.models import TacheEnseignant

def run():
    print("Starting data seeding...")

    # 1. Basic Structure
    annee, _ = Annee.objects.get_or_create(id_annee=1, defaults={
        'debut': 2025, 'fin': 2026, 'annee': '2025-2026',
        'etat_annee': 'Ouverte', 'date_ouverture': date(2025, 9, 1), 'date_cloture': date(2026, 6, 30)
    })
    
    campus, _ = Campus.objects.get_or_create(id_campus=1, defaults={
        'campus': 'Campus Test', 'adresse': 'Adresse Test'
    })

    cycle, _ = ClasseCycle.objects.get_or_create(id_cycle=1, defaults={'cycle': 'Cycle Secondaire'})
    classe, _ = Classes.objects.get_or_create(id_classe=1, defaults={'classe': '7ème Année'})
    
    cycle_actif, _ = ClasseCycleActif.objects.get_or_create(id_cycle_actif=1, defaults={
        'cycle_id': cycle, 'id_annee': annee, 'id_campus': campus
    })
    
    classe_active, _ = ClasseActive.objects.get_or_create(id_classe_active=1, defaults={
        'id_campus': campus, 'id_annee': annee, 'cycle_id': cycle_actif,
        'classe_id': classe, 'groupe': 'A', 'isterminale': 0
    })

    trimestre, _ = Trimestre.objects.get_or_create(id_trimestre=1, defaults={
        'trimestre': '1er Trimestre', 'etat_trimestre': 'Actif', 'date_ouverture': date(2025,9,1), 'date_cloture': date(2025,12,31)
    })

    # 2. Operations (Palettes)
    print("Populating Operations...")
    ops = [
        ('Visualiser les Notes', 'VIEW_GRADES', 'grade'),
        ('Vérifier les Présences', 'VIEW_ATTENDANCE', 'event_available'),
        ('Effectuer un Paiement', 'MAKE_PAYMENT', 'payments'),
        ('Historique des Paiements', 'PAYMENT_HISTORY', 'receipt_long'),
        ('Messagerie École', 'COMMUNICATION', 'chat'),
        ('Calendrier Scolaire', 'CALENDAR', 'calendar_month'),
        ('Suivi Discipline', 'DISCIPLINE', 'gavel'),
        ('Documents Administratifs', 'DOCUMENTS', 'description'),
        ('Menu de la Cantine', 'CANTINE', 'restaurant'),
        ('Transport Scolaire', 'TRANSPORT', 'directions_bus'),
    ]
    for lib, code, icon in ops:
        ParentOperation.objects.get_or_create(libelle_operation=lib, defaults={'code_action': code, 'icone_name': icon})

    taches = [
        'Gestion des Présences', 'Saisie des Notes', 'Communications aux Parents',
        'Gestion de l\'Horaire', 'Attribution des Devoirs', 'Calendrier des Examens',
        'Suivi des Bulletins', 'Discipline et Conduite'
    ]
    for t in taches:
        TacheEnseignant.objects.get_or_create(tache=t)

    postes = [
        'Agent Comptable', 'Directeur d\'École', 'Superviseur Pédagogique', 'Secrétaire Administratif',
        'Préfet des Études', 'Proviseur', 'Intendant', 'Bibliothécaire', 'Animateur Culturel', 'Directeur de Discipline'
    ]
    for p in postes:
        PosteAdministratif.objects.get_or_create(poste=p)

    # 3. Users
    print("Creating Users...")
    
    # Parent
    parent_pass = make_password('123456')
    parent, created = Parent.objects.get_or_create(telephone='+243000000000', defaults={
        'nom': 'TEST', 'prenom': 'Parent', 'email': 'parent_test@example.com', 'password': parent_pass
    })
    if not created:
        parent.password = parent_pass
        parent.save()

    # Students
    students_data = [
        ('Student1', 'Test', 'M', 'student1@test.com', '+243000000001'),
        ('Student2', 'Test', 'F', 'student2@test.com', '+243000000002'),
    ]
    for nom, prenom, genre, email, tel in students_data:
        eleve, _ = Eleve.objects.get_or_create(email=email, defaults={
            'nom': nom, 'prenom': prenom, 'genre': genre, 'telephone': tel,
            'password': parent_pass, 'id_parent': parent, 'date_naissance': date(2010,1,1)
        })
        # Inscription
        EleveInscription.objects.get_or_create(id_eleve=eleve, id_annee=annee, defaults={
             'date_inscription': date.today(), 'id_campus': campus, 'id_classe': classe_active,
             'id_classe_cycle': cycle_actif, 'id_trimestre': trimestre, 'status': 1, 'redoublement': 0, 'isdelegue': 0
        })

    # Teacher
    teacher_user, _ = User.objects.get_or_create(username='teacher@test.com', defaults={
        'first_name': 'Enseignant', 'last_name': 'Test', 'email': 'teacher@test.com', 'is_staff': True
    })
    teacher_user.set_password('123456')
    teacher_user.save()

    # Personnel Categories/Types
    cat, _ = PersonnelCategorie.objects.get_or_create(id_personnel_category=1, defaults={'categorie': 'Enseignant', 'sigle': 'ENS'})
    ptype, _ = PersonnelType.objects.get_or_create(id_type_personnel=1, defaults={'type': 'Permanent', 'sigle': 'P'})
    spec, _ = Specialite.objects.get_or_create(id_specialite=1, defaults={'specialite': 'Maths', 'sigle': 'M'})
    vac, _ = Vacation.objects.get_or_create(id_vacation=1, defaults={'vacation': 'Journée'})
    dip, _ = Diplome.objects.get_or_create(id_diplome=1, defaults={'diplome': 'Licence', 'sigle': 'L'})

    Personnel.objects.update_or_create(matricule='T001', defaults={
        'genre': 'M', 'etat_civil': 'Célibataire', 'type_identite': 'ID', 'telephone': '+243111111111',
        'province': 'Kinshasa', 'commune': 'Gombe', 'zone': 'Z1', 'addresse': 'Adresse Teacher',
        'user': teacher_user, 'id_categorie': cat, 'id_personnel_type': ptype,
        'id_specialite': spec, 'id_vacation': vac, 'id_diplome': dip,
        'en_fonction': 1, 'is_verified': 1, 'ismaitresse': 0, 'isinstiteur': 0, 
        'isdaf': 0, 'isdirecteur': 0, 'isuser': 1
    })

    # Admin
    admin_user, _ = User.objects.get_or_create(username='admin@test.com', defaults={
        'first_name': 'Admin', 'last_name': 'Test', 'email': 'admin@test.com', 'is_staff': True, 'is_superuser': True
    })
    admin_user.set_password('123456')
    admin_user.save()

    poste, _ = PosteAdministratif.objects.get_or_create(id_posteAdministratif=2, defaults={'poste': 'Directeur'})
    
    Personnel.objects.update_or_create(matricule='A001', defaults={
        'genre': 'M', 'etat_civil': 'Marié', 'type_identite': 'ID', 'telephone': '+243222222222',
        'province': 'Kinshasa', 'commune': 'Gombe', 'zone': 'Z1', 'addresse': 'Adresse Admin',
        'user': admin_user, 'id_categorie': cat, 'id_personnel_type': ptype,
        'id_specialite': spec, 'id_vacation': vac, 'id_diplome': dip, 'id_posteAdministratif': poste,
        'en_fonction': 1, 'is_verified': 1, 'ismaitresse': 0, 'isinstiteur': 0, 
        'isdaf': 0, 'isdirecteur': 1, 'isuser': 1
    })

    print("Seeding completed successfully!")

if __name__ == '__main__':
    run()
