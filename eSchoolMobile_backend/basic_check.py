
import os
import django
import sys

# Add project root to path
sys.path.append('/home/drevaristen/Desktop/eSchoolMobile/eSchoolMobile_backend')
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'monecole_ws.settings')
django.setup()

from account_creation.models import ParentOperation
# Note: TacheEnseignant and PosteAdministratif might be in different apps or same
# Based on earlier views.py: from .models import TacheEnseignant, PosteAdministratif in account_creation/views.py?
# views.py lines 266/273 import them locally. check models.py

try:
    from taches_enseignant.models import TacheEnseignant
except ImportError:
    try:
        from account_creation.models import TacheEnseignant
    except:
        print("Could not import TacheEnseignant")
        TacheEnseignant = None

try:
    from account_creation.models import PosteAdministratif
except:
     print("Could not import PosteAdministratif")
     PosteAdministratif = None

def check():
    print("--- DATA CHECK ---")
    
    # Parent Operations
    count_parent = ParentOperation.objects.count()
    print(f"Parent Operations: {count_parent}")
    if count_parent == 0:
        print("WARNING: Parent Operations table is empty!")

    # Teacher Tasks
    if TacheEnseignant:
        count_teacher = TacheEnseignant.objects.count()
        print(f"Teacher Tasks: {count_teacher}")
        if count_teacher == 0:
             print("WARNING: Teacher Tasks table is empty!")
    
    # Admin Posts
    if PosteAdministratif:
        count_admin = PosteAdministratif.objects.count()
        print(f"Admin Posts: {count_admin}")
        if count_admin == 0:
             print("WARNING: Admin Posts table is empty!")

if __name__ == '__main__':
    check()
