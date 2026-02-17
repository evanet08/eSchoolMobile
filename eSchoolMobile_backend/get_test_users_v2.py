import os
import django

# Manually set database env vars if possible, or just skip dotenv
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'monecole_ws.settings')

# Mock dotenv.load_dotenv
import sys
class MockDotEnv:
    def load_dotenv(self, *args, **kwargs):
        pass
sys.modules['dotenv'] = MockDotEnv()

django.setup()

from account_creation.models import Parent, Eleve, Personnel
from django.contrib.auth.models import User

def get_samples():
    print("--- PARENTS ---")
    try:
        parents = Parent.objects.all()[:3]
        for p in parents:
            print(f"Name: {p.nom} {p.prenom}, Email: {p.email}, Phone: {p.telephone}")
    except Exception as e:
        print(f"Error fetching parents: {e}")

    print("\n--- STUDENTS ---")
    try:
        students = Eleve.objects.exclude(password__isnull=True).exclude(password="")[:3]
        for s in students:
            print(f"Name: {s.nom} {s.prenom}, Email: {s.email}, Phone: {s.telephone}")
    except Exception as e:
        print(f"Error fetching students: {e}")

    print("\n--- PERSONNEL (TEACHERS/ADMIN) ---")
    try:
        personnel_list = Personnel.objects.select_related('user').all()[:5]
        for p in personnel_list:
            role = "Admin" if p.id_posteAdministratif else "Teacher"
            print(f"Name: {p.user.first_name} {p.user.last_name}, Username/Email: {p.user.username}, Role: {role}")
    except Exception as e:
        print(f"Error fetching personnel: {e}")

if __name__ == "__main__":
    get_samples()
