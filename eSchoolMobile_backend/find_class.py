import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'monecole_ws.settings')
django.setup()

from account_creation.models import ClasseActive, Eleve, EleveNote, Personnel, AttributionCours
from django.db.models import Count

def find_class():
    print("--- SEARCHING FOR SUITABLE CLASS ---")
    # Classes with at least 3 students
    classes = ClasseActive.objects.annotate(student_count=Count('eleveinscription')).filter(student_count__gte=3)
    
    for c in classes:
        # Check if there are notes for this class
        notes_count = EleveNote.objects.filter(id_classe_active=c).count()
        if notes_count > 0:
            print(f"Class ID: {c.id_classe_active}, Students: {c.student_count}, Notes: {notes_count}")
            
            # Find students in this class
            students = Eleve.objects.filter(eleve_inscription__id_classe=c)[:5]
            print(f"  Sample students: {[s.nom for s in students]}")
            
            # Find teacher for this class (if any)
            attributions = AttributionCours.objects.filter(id_classe=c)
            if attributions.exists():
                for a in attributions:
                    print(f"  Teacher: {a.id_personnel.user.first_name} {a.id_personnel.user.last_name}")
            return c.id_classe_active
    return None

if __name__ == "__main__":
    find_class()
