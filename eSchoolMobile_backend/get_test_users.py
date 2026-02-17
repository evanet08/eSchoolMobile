import os
import django
import json

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'monecole_ws.settings')
django.setup()

from account_creation.models import Parent, Eleve, Personnel, AuthUser

def get_samples():
    print("--- PARENTS ---")
    parents = Parent.objects.all()[:3]
    for p in parents:
        print(f"Name: {p.nom} {p.prenom}, Email: {p.email}, Phone: {p.telephone}")

    print("\n--- STUDENTS ---")
    students = Eleve.objects.exclude(password__isnull=True).exclude(password="")[:3]
    for s in students:
        print(f"Name: {s.nom} {s.prenom}, Email: {s.email}, Phone: {s.telephone}")

    print("\n--- PERSONNEL (TEACHERS/ADMIN) ---")
    personnel = Personnel.objects.select_related('user').all()[:5]
    for p in personnel:
        role = "Admin" if p.id_posteAdministratif else "Teacher"
        print(f"Name: {p.user.first_name} {p.user.last_name}, Username/Email: {p.user.username}, Role: {role}")

if __name__ == "__main__":
    get_samples()
