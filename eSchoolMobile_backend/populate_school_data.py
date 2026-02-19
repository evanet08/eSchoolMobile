"""
Script to populate school data: 3 students linked to test parent,
with evaluations, notes, and deliberations.
Run from eSchoolMobile_backend directory:
  python manage.py shell < populate_school_data.py
"""
import os, django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'monecole_ws.settings')
django.setup()

from datetime import date, timedelta
import random
from account_creation.models import (
    Annee, Parent, Eleve, EleveInscription, ClasseActive, Classes,
    Campus, ClasseCycleActif, ClasseCycle, Trimestre, Periode, Session,
    Cours, CoursParClasse, Evaluation, EleveNote, EleveNoteType,
    ClasseDeliberation, Mention
)

print("="*60)
print("POPULATING SCHOOL DATA")
print("="*60)

# ========================================
# Step 1: Get or create base data
# ========================================

# Academic year
annee, _ = Annee.objects.get_or_create(
    annee='2025-2026',
    defaults={
        'debut': 2025, 'fin': 2026,
        'etat_annee': 'Active',
        'date_ouverture': date(2025, 9, 1),
        'date_cloture': date(2026, 7, 31),
    }
)
print(f"✓ Year: {annee.annee} (id={annee.id_annee})")

# Campus
campus, _ = Campus.objects.get_or_create(
    campus='Campus Principal',
    defaults={'adresse': 'Bukavu, RDC', 'localisation': '-2.5083,28.8608'}
)
print(f"✓ Campus: {campus.campus} (id={campus.id_campus})")

# Cycle
cycle_obj, _ = ClasseCycle.objects.get_or_create(cycle='Secondaire')
cycle_actif, _ = ClasseCycleActif.objects.get_or_create(
    cycle_id=cycle_obj,
    id_annee=annee,
    id_campus=campus,
    defaults={'role': 'Cycle secondaire'}
)
print(f"✓ Cycle actif: {cycle_actif.id_cycle_actif}")

# Sessions
session_normale, _ = Session.objects.get_or_create(session='Normale')
session_rattrapage, _ = Session.objects.get_or_create(session='Rattrapage')
print(f"✓ Sessions: Normale(id={session_normale.id_session}), Rattrapage(id={session_rattrapage.id_session})")

# Trimestres
trimestre_names = ['1er Trimestre', '2ème Trimestre', '3ème Trimestre']
trimestre_dates = [
    (date(2025, 9, 1), date(2025, 11, 30)),
    (date(2025, 12, 1), date(2026, 2, 28)),
    (date(2026, 3, 1), date(2026, 5, 31)),
]
trimestres = []
for i, t_name in enumerate(trimestre_names):
    t, _ = Trimestre.objects.get_or_create(
        trimestre=t_name,
        defaults={
            'etat_trimestre': 'Clôturé' if i < 2 else 'En cours',
            'date_ouverture': trimestre_dates[i][0],
            'date_cloture': trimestre_dates[i][1],
        }
    )
    trimestres.append(t)
print(f"✓ {len(trimestres)} trimestres créés")

# Periodes
periode_names = ['P1', 'P2', 'P3', 'P4', 'P5', 'P6']
periodes = []
for p_name in periode_names:
    p, _ = Periode.objects.get_or_create(
        periode=p_name,
        defaults={
            'etat_periode': 'Active',
            'id_trimestre': trimestres[min(len(periodes)//2, 2)],
        }
    )
    periodes.append(p)
print(f"✓ {len(periodes)} périodes créées")

# Note types
note_types_data = [
    ('Interrogation', 'INT'),
    ('Travail Pratique', 'TP'),
    ('Travaux Dirigés', 'TD'),
    ('Examen', 'EX'),
]
note_types = {}
for nt_name, nt_sigle in note_types_data:
    nt, _ = EleveNoteType.objects.get_or_create(
        sigle=nt_sigle,
        defaults={'type': nt_name}
    )
    note_types[nt_sigle] = nt
print(f"✓ {len(note_types)} types de notes")

# Mentions
mentions_data = [
    ('Très Bien', 'TB', 80, 100),
    ('Bien', 'B', 70, 79.9),
    ('Assez Bien', 'AB', 60, 69.9),
    ('Satisfaisant', 'S', 50, 59.9),
    ('Insuffisant', 'I', 0, 49.9),
]
for m_name, m_abbr, m_min, m_max in mentions_data:
    Mention.objects.get_or_create(
        abbreviation=m_abbr,
        defaults={'mention': m_name, 'min': m_min, 'max': m_max}
    )
print("✓ Mentions créées")

# ========================================
# Step 2: Create classes
# ========================================
classes_data = ['6ème A', '5ème B', '4ème A']
classes_actives = []
for cl_name in classes_data:
    cl, _ = Classes.objects.get_or_create(classe=cl_name)
    ca, _ = ClasseActive.objects.get_or_create(
        id_campus=campus,
        id_annee=annee,
        cycle_id=cycle_actif,
        classe_id=cl,
        defaults={'groupe': '', 'isterminale': 0}
    )
    classes_actives.append(ca)
    print(f"  ✓ Classe: {cl_name} (active id={ca.id_classe_active})")

# ========================================
# Step 3: Create courses for each class
# ========================================
courses_per_class = {
    '6ème A': [('Mathématiques', 20), ('Français', 20), ('Sciences', 20), ('Histoire-Géo', 20), ('Anglais', 20)],
    '5ème B': [('Mathématiques', 20), ('Français', 20), ('Physique-Chimie', 20), ('SVT', 20), ('Anglais', 20)],
    '4ème A': [('Mathématiques', 20), ('Français', 20), ('Physique', 20), ('Chimie', 20), ('Informatique', 20)],
}

cours_par_classes = {}  # keyed by (classe_index, cours_name)
for i, ca in enumerate(classes_actives):
    cl_name = classes_data[i]
    cours_list = courses_per_class[cl_name]
    for c_name, pond in cours_list:
        cours_obj, _ = Cours.objects.get_or_create(
            cours=c_name,
            defaults={'code_cours': c_name[:3].upper()}
        )
        cpc, _ = CoursParClasse.objects.get_or_create(
            id_cours=cours_obj,
            id_classe=ca,
            id_annee=annee,
            id_campus=campus,
            id_cycle=cycle_actif,
            defaults={'ponderation': pond, 'cm': 10, 'td': 5, 'tp': 3, 'tpe': 2}
        )
        cours_par_classes[(i, c_name)] = cpc
    print(f"  ✓ {len(cours_list)} cours pour {cl_name}")

# ========================================
# Step 4: Get or create parent
# ========================================
parent = Parent.objects.first()
if not parent:
    parent = Parent.objects.create(
        nom='MUTOMBO',
        prenom='Jean-Pierre',
        telephone='+243991234567',
        email='parent@test.com',
        password='pbkdf2_sha256$',
        code_secret_parent='1234',
    )
print(f"✓ Parent: {parent.nom} {parent.prenom} (id={parent.id_parent})")

# ========================================
# Step 5: Create 3 students linked to parent
# ========================================
students_data = [
    {'nom': 'MUTOMBO', 'prenom': 'Grace', 'genre': 'F', 'date_naissance': date(2010, 3, 15), 'matricule': 'ELV-001', 'classe_idx': 0},
    {'nom': 'MUTOMBO', 'prenom': 'David', 'genre': 'M', 'date_naissance': date(2011, 7, 22), 'matricule': 'ELV-002', 'classe_idx': 1},
    {'nom': 'MUTOMBO', 'prenom': 'Esther', 'genre': 'F', 'date_naissance': date(2012, 11, 8), 'matricule': 'ELV-003', 'classe_idx': 2},
]

eleves = []
for s in students_data:
    eleve, created = Eleve.objects.get_or_create(
        nom=s['nom'],
        prenom=s['prenom'],
        matricule=s['matricule'],
        defaults={
            'genre': s['genre'],
            'date_naissance': s['date_naissance'],
            'nom_pere': parent.nom,
            'prenom_pere': parent.prenom,
            'telephone': parent.telephone,
            'id_parent': parent,
            'code_secret_parent': parent.code_secret_parent,
            'code_secret_eleve': f'ELV{s["matricule"][-3:]}',
        }
    )
    if not created and eleve.id_parent != parent:
        eleve.id_parent = parent
        eleve.save()
    eleves.append(eleve)
    
    # Create inscription
    ca = classes_actives[s['classe_idx']]
    EleveInscription.objects.get_or_create(
        id_eleve=eleve,
        id_annee=annee,
        id_classe=ca,
        defaults={
            'date_inscription': date(2025, 9, 1),
            'id_campus': campus,
            'id_classe_cycle': cycle_actif,
            'id_trimestre': trimestres[0],
            'status': 1,
            'redoublement': 0,
            'isdelegue': 0,
        }
    )
    action = "créé" if created else "existant"
    print(f"  ✓ Élève {action}: {eleve.nom} {eleve.prenom} -> {classes_data[s['classe_idx']]}")

# ========================================
# Step 6: Create evaluations and notes
# ========================================
random.seed(42)  # Reproducible

eval_count = 0
note_count = 0

for s_idx, eleve in enumerate(eleves):
    ca = classes_actives[students_data[s_idx]['classe_idx']]
    cl_name = classes_data[students_data[s_idx]['classe_idx']]
    courses = courses_per_class[cl_name]
    
    for c_name, pond in courses:
        cpc = cours_par_classes[(students_data[s_idx]['classe_idx'], c_name)]
        
        # Create evaluations for each period & type
        for p_idx, periode in enumerate(periodes[:4]):  # First 4 periods
            for nt_sigle, nt_obj in note_types.items():
                # Determine ponderation per type
                eval_pond = {'INT': 10, 'TP': 10, 'TD': 15, 'EX': 20}
                ep = eval_pond.get(nt_sigle, 10)
                
                eval_month_offsets = [9, 10, 11, 12]  # Sep, Oct, Nov, Dec
                eval_month = eval_month_offsets[p_idx]
                eval_year = 2025
                eval_date = date(eval_year, eval_month, 10 + random.randint(0, 15))
                
                evaluation, ev_created = Evaluation.objects.get_or_create(
                    id_cours_classe=cpc,
                    id_classe_active=ca,
                    id_type_note=nt_obj,
                    id_periode=periode,
                    id_annee=annee,
                    id_session=session_normale,
                    id_trimestre=trimestres[min(p_idx//2, 2)],
                    defaults={
                        'title': f'{nt_obj.type} - {c_name} - {periode.periode}',
                        'ponderer_eval': ep,
                        'date_eval': eval_date,
                        'date_soumission': eval_date + timedelta(days=7),
                        'contenu_evaluation': '',
                        'id_campus': campus,
                        'id_cycle_actif': cycle_actif,
                    }
                )
                if ev_created:
                    eval_count += 1
                
                # Create note for this student
                # Generate realistic note based on student profile
                base_score = {0: 0.72, 1: 0.58, 2: 0.65}  # Average percentage per student
                variability = random.uniform(-0.15, 0.15)
                score_pct = max(0.2, min(1.0, base_score[s_idx] + variability))
                note_value = round(score_pct * ep, 1)
                
                note, n_created = EleveNote.objects.get_or_create(
                    id_evaluation=evaluation,
                    id_eleve=eleve,
                    defaults={
                        'date_saisie': eval_date + timedelta(days=3),
                        'note': note_value,
                        'id_annee': annee,
                        'id_campus': campus,
                        'id_classe_active': ca,
                        'id_cours_classe': cpc,
                        'id_cycle_actif': cycle_actif,
                        'id_type_note': nt_obj,
                        'id_periode': periode,
                        'id_session': session_normale,
                        'id_trimestre': trimestres[min(p_idx//2, 2)],
                    }
                )
                if n_created:
                    note_count += 1

print(f"\n✓ {eval_count} évaluations créées")
print(f"✓ {note_count} notes créées")

# ========================================
# Step 7: Create deliberations
# ========================================
for ca in classes_actives:
    ClasseDeliberation.objects.get_or_create(
        id_classe=ca,
        id_annee=annee,
        id_session=session_normale,
        defaults={
            'date_deliberation': date(2026, 1, 15),
            'showresults': 1,
            'showsresultsenordre': 1,
            'id_campus': campus,
            'id_cycle': cycle_actif,
        }
    )
print("✓ Délibérations créées pour toutes les classes")

# ========================================
# Summary
# ========================================
print("\n" + "="*60)
print("SUMMARY")
print("="*60)
print(f"Parent: {parent.nom} {parent.prenom} (id={parent.id_parent})")
print(f"Children: {len(eleves)}")
for e in eleves:
    n_count = EleveNote.objects.filter(id_eleve=e).count()
    insc = EleveInscription.objects.filter(id_eleve=e).first()
    cl = Classes.objects.get(id_classe=insc.id_classe.classe_id_id) if insc else None
    print(f"  - {e.nom} {e.prenom} ({e.genre}) | {cl.classe if cl else 'N/A'} | {n_count} notes")
print(f"Total evaluations: {Evaluation.objects.count()}")
print(f"Total notes: {EleveNote.objects.count()}")
print(f"Total deliberations: {ClasseDeliberation.objects.count()}")
print("="*60)
print("DONE!")
