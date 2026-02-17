import json
from django.views.decorators.csrf import csrf_exempt
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from django.contrib.auth import authenticate
from django.contrib.auth.models import User
from rest_framework_simplejwt.tokens import RefreshToken
from django.forms import model_to_dict
from django.http import JsonResponse
from django.contrib.auth.hashers import make_password,check_password
from django.db.models import Q
from .models import Annee, Eleve, Personnel, Parent, ParentOperation
import random
from monecole_ws.utils import send_whatssap_message
import firebase_admin
from firebase_admin import credentials,messaging

@api_view(["GET"])
@permission_classes([IsAuthenticated])
def getAnneesScolaires(request):
    try:
        annees = list(Annee.objects.values())
        return JsonResponse(annees,safe=False,status=200)
    except Exception:
        JsonResponse({"message": "Token invalide ou expiré"},safe=False,status=401) 

def verificationUserByPhoneNumber(request,phoneNumber,typeUser):
    parent = None
    personnel = None
    eleve = None
    code = None

    match typeUser:
        case "Parent":
            parent = Eleve.objects.filter(telephone=phoneNumber).first()
        case "Teacher":
            personnel = Personnel.objects.filter(telephone=phoneNumber).first()    
        case "Student":
            eleve = Eleve.objects.filter(telephone=phoneNumber).first()

    if parent is not None or personnel is not None or eleve is not None:
            char = list('0123456789')
            code = ""
            for i in range(4):
                    code += random.choice(char)
           # message = "Votre code de vérification pour la création de compte Mon Ecole est: "+code
            hashCode = make_password(code)
            
            if parent is not None:     
                parent.code_secret_parent = hashCode
                parent.save()
                send_whatssap_message(code,phoneNumber) 
                return JsonResponse(model_to_dict(parent),safe=False,status=200)
            
            if personnel is not None:  
                personnel.code_secret = hashCode 
                personnel.save()
                send_whatssap_message(code,phoneNumber) 
                return JsonResponse(model_to_dict(personnel),safe=False,status=200)
            if eleve is not None:
                eleve.code_secret_eleve = hashCode
                eleve.save()
                send_whatssap_message(code,phoneNumber) 
                return JsonResponse(model_to_dict(eleve),safe=False,status=200)
    
    return JsonResponse({"message":"Vous n'êtes pas reconnus"},safe=False,status=404)     
   
def verificationUserBySecretCode(request,phoneNumber,code,typeUser):
    
    parent = None
    personnel = None
    eleve = None

    match typeUser:
        case "Parent":
            parent = Eleve.objects.filter(telephone=phoneNumber).first()
        case "Teacher":
            personnel = Personnel.objects.filter(telephone=phoneNumber).first()    
        case "Student":
            eleve = Eleve.objects.filter(telephone=phoneNumber).first()

    if eleve is not None and check_password(code,eleve.code_secret_eleve):
       return JsonResponse({"message":"Vous êtes reconnus en tant qu'élève"},safe=False,status=200)
    if parent is not None and check_password(code,parent.code_secret_parent):
       return JsonResponse({"message":"Vous êtes reconnus en tant que parent de l'élève "+parent.nom+" "+parent.prenom},safe=False,status=200)
    if personnel is not None and check_password(code,personnel.code_secret):
       return JsonResponse({"message":"Vous êtes reconnus en tant que personnel de l'école"},safe=False,status=200)
    return JsonResponse({"message":"Code hahahha"},safe=False,status=400) 

@csrf_exempt
def creationCompteUser(request,code,typeUser):
    data = json.loads(request.body)
    parent = None
    personnel = None
    eleve = None

    match typeUser:
        case "Parent":
            parent = Eleve.objects.filter(telephone=data.get("phone")).first()
        case "Teacher":
            personnel = Personnel.objects.filter(telephone=data.get("phone")).select_related('user').first()    
        case "Student":
            eleve = Eleve.objects.filter(telephone=data.get("phone")).first()
    if parent is not None and check_password(str(code),parent.code_secret_parent):
        parents = Eleve.objects.filter(telephone=parent.telephone)
        parents.update(
            password_parent=make_password(data.get("password")),
            code_secret_parent=None
        )
        return JsonResponse({"message":"Votre compte parent est crée avec succès"},safe=False,status=201)
    if personnel is not None and check_password(code,personnel.code_secret):
        personnel.user.password = make_password(data.get("password"))
        personnel.code_secret = None
        personnel.user.save()
        personnel.save()
        return JsonResponse({"message":"Votre compte en tant que personnel de l'école est crée avec succès"},safe=False,status=201)
    if eleve is not None and check_password(code,eleve.code_secret_eleve):
        eleve.password = make_password(data.get("password"))
        eleve.code_secret_eleve = None
        eleve.save()
        return JsonResponse({"message":"Votre compte élève est crée avec succès"},safe=False,status=201)
    
    return JsonResponse({"message":"Informations invalides"},safe=False,status=404)

@csrf_exempt
def login(request):
    try:
        print(f"DEBUG: Login request body: {request.body}")
        data = json.loads(request.body)
    except Exception as e:
        print(f"DEBUG: JSON Parse error: {e}")
        return JsonResponse({"message": "Invalid JSON body"}, status=400)

    match data.get("type_user"):
        case "Parent":
            parent = Parent.objects.filter(Q(email=data.get("email")) | Q(telephone=data.get("email"))).first()
            if parent is not None:
                if check_password(data.get("password"), parent.password):
                    # For simple JWT, we need a Django User. Using the dummy User ID=1 if not linked.
                    django_user = User.objects.filter(id=1).first() 
                    if not django_user:
                         # Fallback if ID 1 doesn't exist, try getting any user or create one (safety check)
                        django_user = User.objects.first()

                    refresh = RefreshToken.for_user(django_user)
                    
                    # Inject custom claims
                    refresh["custom_user_id"] = parent.id_parent
                    refresh["custom_user_type"] = "Parent"

                    user_data = {
                        "id": parent.id_parent,
                        "first_name": parent.nom,
                        "last_name": parent.prenom,
                        "email": parent.email,
                        "telephone": parent.telephone
                    }
                    
                    return JsonResponse({
                        "message": "Login successful",
                        "access_token": str(refresh.access_token),
                        "refresh_token": str(refresh),
                        "user": json.dumps(user_data, default=str)
                    }, status=200)
                else:
                    return JsonResponse({"message": "Mot de passe invalide"}, status=400)
            else:
                return JsonResponse({"message": "E-mail ou téléphone invalide"}, status=400)
            
        case "Student":
            eleve = Eleve.objects.filter(Q(email=data.get("email")) | Q(telephone=data.get("email"))).first()
            if eleve is not None:
                if check_password(data.get("password"),eleve.password):
                    django_user = User.objects.filter(id=1).first()
                    if not django_user:
                        django_user = User.objects.first()

                    refresh = RefreshToken.for_user(django_user)

                    # Inject custom claims
                    refresh["custom_user_id"] = eleve.id_eleve
                    refresh["custom_user_type"] = "Student"
                    
                    user_data = {
                        "id": eleve.id_eleve,
                        "first_name": eleve.nom,
                        "last_name": eleve.prenom,
                        "email": eleve.email,
                        "telephone": eleve.telephone
                    }
                    
                    return JsonResponse({
                        "message": "Login successful",
                        "access_token": str(refresh.access_token),
                        "refresh_token": str(refresh),
                        "user": json.dumps(user_data, default=str)
                    }, status=200)
                else:
                    return JsonResponse({"message": "Mot de passe invalide"}, status=400)
            else:
                return JsonResponse({"message": "E-mail ou téléphone invalide"}, status=400)

        case "Teacher":
            user = authenticate(request, username=data.get("email"), password=data.get("password"))
            if user is not None:
                    refresh = RefreshToken.for_user(user)
                    # For teacher, standard user ID is fine, but for consistency we can add claims or just rely on user_id
                    refresh["custom_user_id"] = user.id
                    refresh["custom_user_type"] = "Teacher"
                    
                    user_data = {
                        "id": user.id,
                        "first_name": user.first_name,
                        "last_name": user.last_name,
                        "email": user.email,
                    }
                    
                    return JsonResponse({
                    "message": "Vous êtes connectés",
                    "access_token": str(refresh.access_token),
                    "refresh_token": str(refresh),
                    "user": json.dumps(user_data, default=str),
                }, status=200)
            else:
                return JsonResponse({"message": "E-mail et/ou mot de passe invalide"}, status=400)

        case "Administrative":
            user = authenticate(request, username=data.get("email"), password=data.get("password"))
            if user is not None:
                # Vérifier si c'est un personnel administratif
                personnel = Personnel.objects.filter(user=user).first()
                if personnel and personnel.id_posteAdministratif:
                    refresh = RefreshToken.for_user(user)
                    refresh["custom_user_id"] = user.id
                    refresh["custom_user_type"] = "Administrative"
                    
                    user_data = {
                        "id": user.id,
                        "first_name": user.first_name,
                        "last_name": user.last_name,
                        "email": user.email,
                    }
                    
                    return JsonResponse({
                        "message": "Connexion administrative réussie",
                        "access_token": str(refresh.access_token),
                        "refresh_token": str(refresh),
                        "user": json.dumps(user_data, default=str),
                    }, status=200)
                else:
                    return JsonResponse({"message": "Accès refusé : Profil administratif non trouvé"}, status=403)
            else:
                return JsonResponse({"message": "E-mail et/ou mot de passe invalide"}, status=400)

        case _: return JsonResponse({"message": "Type d'utilisateur invalide"}, status=400)


def send_push_notification(title, body, registration_token):
    message = messaging.Message(
        notification=messaging.Notification(
            title=title,
            body=body,
        ),
        token=registration_token,
    )
    response = messaging.send(message)

# Nouveaux endpoints pour les palettes d'activités
@api_view(["GET"])
@permission_classes([IsAuthenticated])
def getTeacherTasks(request):
    from .models import TacheEnseignant
    taches = list(TacheEnseignant.objects.values())
    return JsonResponse(taches, safe=False, status=200)

@api_view(["GET"])
@permission_classes([IsAuthenticated])
def getPostesAdministratifs(request):
    from .models import PosteAdministratif
    postes = list(PosteAdministratif.objects.values())
    return JsonResponse(postes, safe=False, status=200)

@api_view(["GET"])
@permission_classes([IsAuthenticated])
def getParentOperations(request):
    from .models import ParentOperation
    operations = list(ParentOperation.objects.values())
    return JsonResponse(operations, safe=False, status=200)
@api_view(["GET"])
@permission_classes([IsAuthenticated])
def getUtilisateurs(request):
    try:
        # Extract custom claims from the token
        token = request.auth
        # SimpleJWT validates the token, so we can trust claims if present
        # Note: request.auth is the AccessToken object which behaves like a dict
        
        user_type = token.payload.get('custom_user_type')
        user_id = token.payload.get('custom_user_id')

        if not user_type or not user_id:
             return JsonResponse({"message": "Token invalide (informations utilisateur manquantes)"}, status=401)
        
        users_list = []
        
        if user_type == 'Parent':
            parent = Parent.objects.filter(id_parent=user_id).first()
            if parent:
                # Add Parent Profile
                users_list.append({
                    "_id": str(parent.id_parent), # Cast to string if app expects consistency
                    "noms_utilisateur": f"{parent.nom} {parent.prenom}",
                    "username_utilisateur": parent.telephone,
                    "telephone_utilisateur": parent.telephone,
                    "type_utilisateur": "Parent",
                    "id_user": parent.id_parent,
                    "email": parent.email,
                    "image": "assets/images/avatar.png" # Default mock image
                })
                
                # Add Children Profiles related to this parent
                children = Eleve.objects.filter(id_parent=parent)
                for child in children:
                     users_list.append({
                        "_id": str(child.id_eleve),
                        "noms_utilisateur": f"{child.nom} {child.prenom}",
                        "username_utilisateur": child.matricule if child.matricule else child.telephone,
                        "telephone_utilisateur": child.telephone,
                        "type_utilisateur": "Student", 
                        "id_user": child.id_eleve,
                        "email": child.email,
                        "image": child.imageurl if child.imageurl else "assets/images/avatar_student.png"
                     })

        elif user_type == 'Student':
            child = Eleve.objects.filter(id_eleve=user_id).first()
            if child:
                users_list.append({
                    "_id": str(child.id_eleve),
                    "noms_utilisateur": f"{child.nom} {child.prenom}",
                    "username_utilisateur": child.matricule if child.matricule else child.telephone,
                    "telephone_utilisateur": child.telephone,
                    "type_utilisateur": "Student",
                    "id_user": child.id_eleve,
                    "email": child.email,
                     "image": child.imageurl if child.imageurl else "assets/images/avatar_student.png"
                })

        elif user_type in ['Teacher', 'Administrative']:
             # For teachers/admins, just return their own profile
             user = request.user
             # Need to find Personnel record to get details
             personnel = Personnel.objects.filter(user=user).first()
             if personnel:
                users_list.append({
                    "_id": str(user.id),
                    "noms_utilisateur": f"{user.first_name} {user.last_name}",
                    "username_utilisateur": user.username,
                    "telephone_utilisateur": personnel.telephone,
                    "type_utilisateur": user_type,
                    "id_user": user.id,
                    "email": user.email,
                    "image": personnel.imageurl if personnel.imageurl else "assets/images/avatar_teacher.png"
                })
        
        # Wrap in expected JSON structure
        return JsonResponse({"utilisateurs": users_list}, status=200)

    except Exception as e:
        import traceback
        traceback.print_exc()
        return JsonResponse({"message": f"Erreur serveur: {str(e)}"}, status=500)
