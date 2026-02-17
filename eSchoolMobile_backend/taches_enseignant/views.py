import json
from django.views.decorators.csrf import csrf_exempt
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from django.contrib.auth import authenticate
from django.contrib.auth.models import User
from django.db.models import Count,F
from django.utils.timezone import now
from rest_framework_simplejwt.tokens import AccessToken
from rest_framework_simplejwt.authentication import JWTAuthentication
from django.forms import model_to_dict
from django.http import JsonResponse,FileResponse
from django.contrib.auth.hashers import make_password,check_password
from .models import AttributionCours,Horaire,EleveInscription,HorairePresence,Eleve,Evaluation,EleveNoteType,Periode,Session,Trimestre,EleveConduite,Annee,Campus,ClasseCycleActif,ClasseActive,EleveNote,CoursParClasse
from django.utils import timezone
from django.core.files.storage import default_storage
from django.core.files.base import ContentFile
from datetime import datetime
from firebase_admin import credentials,messaging

@api_view(["GET"])
@permission_classes([IsAuthenticated])
def getAttributionsCoursEnseignant(request,id_annee,id_classe):
        auth = JWTAuthentication()
        header = auth.get_header(request)
        raw_token = auth.get_raw_token(header)
        try:
            validated_token = auth.get_validated_token(raw_token)
            user_id = validated_token["user_id"]
            attributions = AttributionCours.objects.filter(id_annee=id_annee,id_classe=id_classe,id_personnel=user_id) if id_classe>0 else AttributionCours.objects.filter(id_annee=id_annee,id_personnel=user_id)
            attributions = attributions.select_related(
            'id_annee', 'attribution_type', 'id_campus', 'id_classe','id_classe__classe_id',
            'id_cycle','id_cycle__cycle_id', 'id_cours','id_cours_id_cours', 'id_personnel').annotate(
                classe=F('id_classe__classe_id__classe'),
                classe_id=F('id_classe__classe_id__id_classe'),
                groupe=F('id_classe__groupe'),
                cycle_id=F('id_cycle__cycle_id__id_cycle'),
                cycle=F('id_cycle__cycle_id__cycle'),
                annee=F('id_annee__annee'),
                cours_id=F('id_cours__id_cours__id_cours'),
                cours=F('id_cours__id_cours__cours'),
                ponderation=F('id_cours__ponderation'),
                cm=F('id_cours__cm'),
                tp=F('id_cours__tp'),
                td=F('id_cours__td'),
                tpe=F('id_cours__tpe'),
                campus=F('id_campus__campus')).values('classe_id','classe','groupe','cycle_id','cycle','cours_id','cours','campus','annee','ponderation','cm','tp','td','tpe').order_by('classe','groupe')
            
            return JsonResponse(list(attributions.values()),safe=False,status=200)
        except Exception:
            return JsonResponse({"message": "Une erreur est survenue"}, status=500)
        
@api_view(["GET"])
@permission_classes([IsAuthenticated])
def getCoursEleve(request,id_annee,id_eleve):
        try:
            inscription = EleveInscription.objects.get(id_eleve=id_eleve,id_annee=id_annee)
            if inscription is not None:
                courses = CoursParClasse.objects.filter(id_classe=inscription.id_classe).select_related('id_cours').annotate(
                    cours_id=F('id_cours__id_cours'),
                    cours=F('id_cours__cours'),
                ).values('cours_id','cours')
                return JsonResponse(list(courses.values()),safe=False,status=200)
            return JsonResponse([],safe=False,status=200)
        except Exception:
            print("Erreur lors de la récupération des cours de l'élève")
            return JsonResponse({"message": "Une erreur est survenue"}, status=500)        
     
@api_view(["GET"])
@permission_classes([IsAuthenticated])
def getAttributionsCoursEnseignantByClass(request,id_annee,id_classe):
    auth = JWTAuthentication()
    header = auth.get_header(request)
    raw_token = auth.get_raw_token(header)
    try:
        validated_token = auth.get_validated_token(raw_token)
        user_id = validated_token["user_id"]
        attributions = AttributionCours.objects.filter(id_annee=id_annee,id_personnel=user_id,id_classe=id_classe).select_related(
        'id_annee', 'attribution_type', 'id_campus', 'id_classe','id_classe__classe_id',
        'id_cycle','id_cycle__cycle_id', 'id_cours', 'id_personnel').annotate(
            classe=F('id_classe__classe_id__classe'),
            groupe=F('id_classe__groupe'),
            cycle=F('id_cycle__cycle_id__cycle'),
            annee=F('id_annee__annee'),
            cours=F('id_cours__id_cours__cours')).values('classe','groupe','cycle','cours')
        
        return JsonResponse(list(attributions.values()),safe=False,status=200)
    except Exception:
        return JsonResponse({"message": "Une erreur est survenue"}, status=500) 
    

@api_view(["GET"])
@permission_classes([IsAuthenticated])
def getClassesEnseignant(request,id_annee):
     auth = JWTAuthentication()
     header = auth.get_header(request)
     raw_token = auth.get_raw_token(header)

     try:
         validated_token = auth.get_validated_token(raw_token)
         user_id = validated_token["user_id"]
         attributions = AttributionCours.objects.filter(id_annee=id_annee,id_personnel=user_id).select_related(
         'id_campus', 'id_classe','id_classe__classe_id').annotate(
             total=Count('id_classe'),
             classe=F('id_classe__classe_id__classe')
             ).values('classe').order_by('classe').distinct()
         
         return JsonResponse(list(attributions.values()),safe=False,status=200)
     except Exception:
       return JsonResponse({"message": "Une erreur est survenue"}, status=500) 
     
@api_view(["GET"])
@permission_classes([IsAuthenticated])
def getCreneauxClassesEnseignant(request,id_annee,id_classe,id_cours):
        auth = JWTAuthentication()
        header = auth.get_header(request)
        raw_token = auth.get_raw_token(header)
        try:
            validated_token = auth.get_validated_token(raw_token)
            user_id = validated_token["user_id"]
            attributions = AttributionCours.objects.filter(
                id_annee=id_annee,
                id_classe=id_classe,
                id_personnel=user_id) if id_classe>0 and id_cours==0 else AttributionCours.objects.filter(
                    id_annee=id_annee,
                    id_classe=id_classe,
                    id_cours=id_cours,
                    id_personnel=user_id) if id_classe>0 and id_cours>0 else AttributionCours.objects.filter(
                        id_annee=id_annee,
                        id_cours=id_cours,
                        id_personnel=user_id) if id_classe==0 and id_cours>0 else AttributionCours.objects.filter(
                            id_annee=id_annee,
                            id_personnel=user_id)
            creneaux = Horaire.objects.filter(
                id_annee=id_annee,
                id_classe=id_classe,
                id_classe__in=attributions.values('id_classe'),
                id_cours__in=attributions.values('id_cours'),
                id_annee__in=attributions.values('id_annee')) if id_classe>0 and id_cours==0 else Horaire.objects.filter(
                id_annee=id_annee,
                id_classe=id_classe,
                id_cours=id_cours,
                id_classe__in=attributions.values('id_classe'),
                id_cours__in=attributions.values('id_cours'),
                id_annee__in=attributions.values('id_annee')) if id_classe>0 and id_cours>0 else Horaire.objects.filter(
                id_annee=id_annee,
                id_cours=id_cours,
                id_classe__in=attributions.values('id_classe_id'),
                id_cours__in=attributions.values('id_cours_id'),
                id_annee__in=attributions.values('id_annee_id')) if id_classe==0 and id_cours>0 else Horaire.objects.filter(
                id_annee=id_annee,
                id_classe__in=attributions.values('id_classe_id'),
                id_cours__in=attributions.values('id_cours_id'),
                id_annee__in=attributions.values('id_annee_id'))
            
            creneaux = creneaux.select_related(
            'id_campus', 'id_classe','id_classe__classe_id',
            'id_cycle','id_cycle__cycle_id','id_horaire_type',
            'id_cours','id_cours__id_cours','id_annee').annotate(
            classe=F('id_classe__classe_id__classe'),
            classe_id=F('id_classe__classe_id__id_classe'),
            cycle=F('id_cycle__cycle_id__cycle'),
            annee=F('id_annee__annee'),
            campus=F('id_campus__campus'),
            cours=F('id_cours__id_cours__cours')).values('classe','cours','cycle','annee','campus').order_by('jour','debut')
            print(len(list(attributions.values())))
            
            return JsonResponse(list(creneaux.values()),safe=False,status=200)
        except Exception:
            return JsonResponse({"message": "Une erreur est survenue"}, status=500)
        
@api_view(["GET"])
@permission_classes([IsAuthenticated])
def getCreneauxEleve(request,id_annee,id_eleve,id_cours):
        try:
            inscription = EleveInscription.objects.get(id_eleve=id_eleve,id_annee=id_annee)
            creneaux = Horaire.objects.filter(
                id_annee=id_annee,
                id_classe=inscription.id_classe,
                ) if id_cours==0 else Horaire.objects.filter(
                id_annee=id_annee,
                id_classe=inscription.id_classe,
                id_cours=id_cours)
            
            creneaux = creneaux.select_related(
            'id_campus', 'id_classe','id_classe__classe_id',
            'id_cycle','id_cycle__cycle_id','id_horaire_type',
            'id_cours','id_cours__id_cours','id_annee').annotate(
            classe=F('id_classe__classe_id__classe'),
            classe_id=F('id_classe__classe_id__id_classe'),
            cycle=F('id_cycle__cycle_id__cycle'),
            annee=F('id_annee__annee'),
            campus=F('id_campus__campus'),
            cours=F('id_cours__id_cours__cours')).values('classe','cours','cycle','annee','campus').order_by('jour','debut')
           
            return JsonResponse(list(creneaux.values()),safe=False,status=200)
        except Exception:
            return JsonResponse({"message": "Une erreur est survenue"}, status=500)

@api_view(["GET"])
@permission_classes([IsAuthenticated])
def getEleves(request,id_annee,id_classe):
    auth = JWTAuthentication()
    header = auth.get_header(request)
    raw_token = auth.get_raw_token(header)
    validated_token = auth.get_validated_token(raw_token)
    user_id = validated_token["user_id"]
    attributions = AttributionCours.objects.filter(id_annee=id_annee,id_classe=id_classe,id_personnel=user_id) if id_classe>0 else AttributionCours.objects.filter(id_annee=id_annee,id_personnel=user_id)
    eleves = EleveInscription.objects.filter(
        id_annee=id_annee,
        id_classe__in=attributions.values('id_classe')) if id_classe==0 else EleveInscription.objects.filter(
        id_annee=id_annee,
        id_classe=id_classe,
        id_classe__in=attributions.values('id_classe'))
    eleves = eleves.select_related(
        'id_annee',
        'id_classe_cycle',
        'id_classe_cycle__cycle_id',
        'id_campus',
        'id_eleve',
        'id_classe',
        'id_classe__classe_id').annotate(
        nom=F('id_eleve__nom'),
        prenom=F('id_eleve__prenom'),
        email=F('id_eleve__email'),
        email_parent=F('id_eleve__email_parent'),
        telephone=F('id_eleve__telephone'),
        matricule=F('id_eleve__matricule'),
        date_naissance=F('id_eleve__date_naissance'),
        nom_pere=F('id_eleve__nom_pere'),
        prenom_pere=F('id_eleve__prenom_pere'),
        nom_mere=F('id_eleve__nom_mere'),
        prenom_mere=F('id_eleve__prenom_mere'),
        nationalite=F('id_eleve__nationalite'),
        commune=F('id_eleve__commune_actuelle'),
        zone=F('id_eleve__zone_actuelle'),
        classe=F('id_classe__classe_id__classe'),
        classe_id=F('id_classe__classe_id__id_classe'),
        annee=F('id_annee__annee'),
        groupe=F('id_classe__groupe'),
        cycle_id=F('id_classe_cycle__cycle_id__id_cycle'),
        cycle=F('id_classe_cycle__cycle_id__cycle'),
        campus=F('id_campus__campus')).values(
            'nom',
            'prenom',
            'nom_pere',
            'prenom_pere',
            'nom_mere',
            'prenom_mere',
            'classe',
            'groupe',
            'classe_id',
            'annee',
            'email',
            'email_parent',
            'telephone',
            'matricule',
            'nationalite',
            'commune',
            'zone',
            'date_naissance','campus','cycle').order_by('nom','prenom')
    return JsonResponse(list(eleves.values()),safe=False,status=200)


@csrf_exempt
def enregistrerPresences(request):
    try:
        data = json.loads(request.body)
        records = [HorairePresence(present_ou_absent = pres['est_present'],
                            id_eleve = Eleve.objects.get(id_eleve=pres['id_eleve']),
                            id_horaire = Horaire.objects.get(id_horaire=pres['id_creneau']),
                            date_presence = timezone.now()) for pres in data] 
        HorairePresence.objects.bulk_create(records)
        
        return JsonResponse({"message":"Les présences sont enregistrées"},safe=False,status=201)
    except Exception:
        return JsonResponse({"message":"Une erreur est survenue lors de l'enregistrement des présences"},safe=False,status=500)
 
@csrf_exempt
def enregistrerConduite(request):
    try:
        data = json.loads(request.body)
        mention = EleveConduite.getMentionConduite(data['quote'])
        print(mention)
        conduite = EleveConduite(
            motif = data['motif'],
            quote = data['quote'],
            date_enregistrement = now(),
            id_annee = Annee.objects.get(id_annee=data['id_annee']),
            id_campus = Campus.objects.get(id_campus=data['id_campus']),
            id_classe = ClasseActive.objects.get(id_classe_active=data['id_classe']),
            id_cycle = ClasseCycleActif.objects.get(id_cycle_actif=data['id_cycle']),
            id_eleve = Eleve.objects.get(id_eleve=data['id_eleve']),
            id_horaire = Horaire.objects.get(id_horaire=data['id_creneau']),
            id_periode = Periode.objects.get(id_periode=data['id_periode']),
            id_session = Session.objects.get(id_session=1),
            id_trimestre = Trimestre.objects.get(id_trimestre=data['id_trimestre']))
        conduite.save()
        
        return JsonResponse({"message":"La conduite est enregistrée avec succès"},safe=False,status=201)
    except Exception:
        return JsonResponse({"message":"Une erreur est survenue lors de l'enregistrement de la conduite"},safe=False,status=500)


@api_view(['GET'])
def afficherPresences(request,id_creneau):
    presences = HorairePresence.objects.filter(id_horaire=id_creneau).select_related('id_eleve').annotate(
        nom=F('id_eleve__nom'),
        prenom=F('id_eleve__prenom'),
        email=F('id_eleve__email'),
        email_parent=F('id_eleve__email_parent'),
        telephone=F('id_eleve__telephone'),
        matricule=F('id_eleve__matricule'),
        date_naissance=F('id_eleve__date_naissance'),
        nom_pere=F('id_eleve__nom_pere'),
        prenom_pere=F('id_eleve__prenom_pere'),
        nom_mere=F('id_eleve__nom_mere'),
        prenom_mere=F('id_eleve__prenom_mere'),
        nationalite=F('id_eleve__nationalite'),
        commune=F('id_eleve__commune_actuelle'),
        zone=F('id_eleve__zone_actuelle')).values(
            'nom',
            'prenom',
            'nom_pere',
            'prenom_pere',
            'nom_mere',
            'prenom_mere',
            'email',
            'email_parent',
            'telephone',
            'matricule',
            'nationalite',
            'commune',
            'zone',
            'date_naissance').order_by('nom','prenom')
    return JsonResponse(list(presences.values()),safe=False,status=200)

@api_view(['GET'])
def togglePresenceStatus(request,id_creneau,id_eleve):
    try:
        presence = HorairePresence.objects.filter(id_horaire=id_creneau,id_eleve=id_eleve).first()
        presence.present_ou_absent = 1 if presence.present_ou_absent == 0 else 0
        presence.save()
        return JsonResponse({"message":"Le statut de présence de l'élève est modifié avec succès"},status=201)
    except Exception as e:
        return JsonResponse({"message":"Erreur lors de la modification du statut de présence de l'élève"},status=500)
    


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def afficherEvaluations(request,id_annee,id_classe,id_cours):
   
    auth = JWTAuthentication()
    header = auth.get_header(request)
    raw_token = auth.get_raw_token(header)
    validated_token = auth.get_validated_token(raw_token)
    user_id = validated_token["user_id"]
    attributions = AttributionCours.objects.filter(id_annee=id_annee,id_classe=id_classe,id_cours=id_cours,id_personnel=user_id) if id_classe>0 and id_cours>0 else AttributionCours.objects.filter(id_annee=id_annee,id_classe=id_classe,id_personnel=user_id) if id_classe>0 and id_cours==0 else AttributionCours.objects.filter(id_annee=id_annee,id_cours=id_cours,id_personnel=user_id) if id_classe==0 and id_cours>0 else AttributionCours.objects.filter(id_annee=id_annee,id_personnel=user_id)
    evaluations = Evaluation.objects.filter(
        id_annee=id_annee,
        id_classe_active=id_classe,
        id_cours_classe=id_cours,
        id_classe_active__in=attributions.values('id_classe'),
        id_cours_classe__in=attributions.values('id_cours')
        ) if id_classe>0 and id_cours>0 else Evaluation.objects.filter(
            id_annee=id_annee,
            id_classe_active=id_classe,
            id_classe_active__in=attributions.values('id_classe'),
        id_cours_classe__in=attributions.values('id_cours')) if id_classe>0 and id_cours==0 else Evaluation.objects.filter(
            id_annee=id_annee,
            id_cours_classe=id_cours,
            id_classe_active__in=attributions.values('id_classe'),
            id_cours_classe__in=attributions.values('id_cours')) if id_classe==0 and id_cours>0 else Evaluation.objects.filter(
                id_annee=id_annee,
                id_classe_active__in=attributions.values('id_classe'),
                id_cours_classe__in=attributions.values('id_cours'))
    evaluations = evaluations.select_related(
        'id_classe_active',
        'id_classe_active__classe_id',
        'id_cours_classe',
        'id_cours_classe__id_cours',
        'id_type_note',
        'id_periode',
        'id_session',
        'id_trimestre'
        ).annotate(
        classe=F('id_classe_active__classe_id__classe'),
        cours=F('id_cours_classe__id_cours__cours'),
        type_evaluation=F('id_type_note__type'),
        periode=F('id_periode__periode'),
        session=F('id_session__session'),
        trimestre=F('id_trimestre__trimestre'),
       ).values('classe','cours','type_evaluation','periode','session','trimestre').order_by('date_eval','cours')
    return JsonResponse(list(evaluations.values()),safe=False,status=200)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def afficherEvaluationsEleve(request,id_annee,id_eleve,id_cours):
    inscription = EleveInscription.objects.get(id_eleve=id_eleve,id_annee=id_annee)
    evaluations = Evaluation.objects.filter(
        id_annee=id_annee,
        id_classe_active=inscription.id_classe,
        id_cours_classe=id_cours
        ) if id_cours>0 else Evaluation.objects.filter(
            id_annee=id_annee,
            id_classe_active=inscription.id_classe)
    evaluations = evaluations.select_related(
        'id_classe_active',
        'id_classe_active__classe_id',
        'id_cours_classe',
        'id_cours_classe__id_cours',
        'id_type_note',
        'id_periode',
        'id_session',
        'id_trimestre'
        ).annotate(
        classe=F('id_classe_active__classe_id__classe'),
        cours=F('id_cours_classe__id_cours__cours'),
        type_evaluation=F('id_type_note__type'),
        periode=F('id_periode__periode'),
        session=F('id_session__session'),
        trimestre=F('id_trimestre__trimestre'),
       ).values('classe','cours','type_evaluation','periode','session','trimestre').order_by('date_eval','cours')
    return JsonResponse(list(evaluations.values()),safe=False,status=200)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def afficherConduites(request,id_annee,id_classe):
    conduites = EleveConduite.objects.filter(id_annee=id_annee,id_classe=id_classe) if id_classe>0 else EleveConduite.objects.filter(id_annee=id_annee)
    conduites = conduites.select_related(
        'id_horaire',
        'id_horaire__id_cours',
        'id_horaire__id_cours__id_cours',
        'id_annee',
        'id_classe',
        'id_campus',
        'id_classe__classe_id',
        'id_cycle',
        'id_eleve',
        'id_type_note',
        'id_periode',
        'id_session',
        'id_trimestre'
        ).annotate(
        classe=F('id_classe__classe_id__classe'),
        nom=F('id_eleve__nom'),
        prenom=F('id_eleve__prenom'),
        groupe=F('id_classe__groupe'),
        cours_id=F('id_horaire__id_cours'),
        jour=F('id_horaire__jour'),
        debut=F('id_horaire__debut'),
        annee=F('id_annee__annee'),
        fin=F('id_horaire__fin'),
        campus=F('id_campus__campus'),
        cycle=F('id_cycle__cycle_id__cycle'),
        cours=F('id_horaire__id_cours__id_cours__cours')
       ).values('classe','cours','cours_id','nom','prenom','groupe','debut','fin','jour','annee','campus','cycle').order_by('nom','prenom')
    return JsonResponse(list(conduites.values()),safe=False,status=200)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def afficherConduitesEleve(request,id_annee,id_eleve,id_cours):
    conduites = EleveConduite.objects.filter(id_annee=id_annee,id_eleve=id_eleve,id_horaire__id_cours=id_cours) if id_cours>0 else EleveConduite.objects.filter(id_annee=id_annee,id_eleve=id_eleve)
    conduites = conduites.select_related(
        'id_horaire',
        'id_horaire__id_cours',
        'id_horaire__id_cours__id_cours',
        'id_annee',
        'id_classe',
        'id_campus',
        'id_classe__classe_id',
        'id_cycle',
        'id_eleve',
        'id_type_note',
        'id_periode',
        'id_session',
        'id_trimestre'
        ).annotate(
        classe=F('id_classe__classe_id__classe'),
        nom=F('id_eleve__nom'),
        prenom=F('id_eleve__prenom'),
        groupe=F('id_classe__groupe'),
        cours_id=F('id_horaire__id_cours'),
        jour=F('id_horaire__jour'),
        debut=F('id_horaire__debut'),
        annee=F('id_annee__annee'),
        fin=F('id_horaire__fin'),
        campus=F('id_campus__campus'),
        cycle=F('id_cycle__cycle_id__cycle'),
        cours=F('id_horaire__id_cours__id_cours__cours')
       ).values('classe','cours','cours_id','nom','prenom','groupe','debut','fin','jour','annee','campus','cycle').order_by('nom','prenom')
    
    return JsonResponse(list(conduites.values()),safe=False,status=200)

def afficherTypesEvaluations(request):
    types = EleveNoteType.objects.values().order_by('type')
    return JsonResponse(list(types),safe=False,status=200)

def afficherPeriodes(request):
    periodes = Periode.objects.values().order_by('periode')
    return JsonResponse(list(periodes),safe=False,status=200)

def afficherTrimestres(request):
    trimestres = Trimestre.objects.values().order_by('trimestre')
    return JsonResponse(list(trimestres),safe=False,status=200)

def afficherSessions(request):
    sessions = Session.objects.values().order_by('session')
    return JsonResponse(list(sessions),safe=False,status=200)

@csrf_exempt
def enregistrerEvaluation(request):
     try:   
        data = request.POST
        uploaded_file = request.FILES['questionnaire']
        new_file_name = f"{now().strftime('%Y%m%d%H%M%S')}_{uploaded_file.name}"
        file_path = default_storage.save(f'uploads/{new_file_name}', ContentFile(uploaded_file.read()))
        evaluation = Evaluation(
            ponderer_eval = data['ponderation'],
            date_soumission = data['date_remise'],
            date_eval = data['date_evaluation'],
            id_annee = Annee.objects.get(id_annee=data['id_annee']),
            id_classe_active = ClasseActive.objects.get(id_classe_active=data['id_classe']),
            id_cours_classe = CoursParClasse.objects.get(id_cours_classe=data['id_cours']),
            id_type_note = EleveNoteType.objects.get(id_type_note=data['id_type_evaluation']),
            id_periode = Periode.objects.get(id_periode=data['id_periode']),
            id_session = Session.objects.get(id_session=data['id_session']),
            id_trimestre = Trimestre.objects.get(id_trimestre=data['id_trimestre']),
            id_campus = Campus.objects.get(id_campus=data['id_campus']),
            id_cycle_actif = ClasseCycleActif.objects.get(id_cycle_actif=data['id_cycle']),
            contenu_evaluation=file_path.split('/')[-1],
        )
        evaluation.save()
        return JsonResponse({"message":"L'évaluation est enregistrée avec succès"},safe=False,status=201)
     except Exception:
         return JsonResponse({"message":"Un problème est survenu lors de l'enregistrement de l'evaluation"},safe=False,status=500)
    

@csrf_exempt
def modifierEvaluation(request,id_evaluation):
    try:
        evaluation = Evaluation.objects.get(id_evaluation=id_evaluation)
        data = request.POST

        evaluation.ponderer_eval = data['ponderation']
        evaluation.date_soumission = data['date_remise']
        evaluation.date_eval = data['date_evaluation']
        evaluation.id_classe_active = ClasseActive.objects.get(id_classe_active=data['id_classe'])
        evaluation.id_cours_classe = CoursParClasse.objects.get(id_cours_classe=data['id_cours'])
        evaluation.id_type_note = EleveNoteType.objects.get(id_type_note=data['id_type_evaluation'])
        evaluation.id_periode = Periode.objects.get(id_periode=data['id_periode'])
        evaluation.id_session = Session.objects.get(id_session=data['id_session'])
        evaluation.id_trimestre = Trimestre.objects.get(id_trimestre=data['id_trimestre'])
        evaluation.id_campus = Campus.objects.get(id_campus=data['id_campus'])
        evaluation.id_cycle_actif = ClasseCycleActif.objects.get(id_cycle_actif=data['id_cycle'])
        
        if request.FILES.get('questionnaire'):
            uploaded_file = request.FILES['questionnaire']
            new_file_name = f"{now().strftime('%Y%m%d%H%M%S')}_{uploaded_file.name}"
            file_path = default_storage.save(f'uploads/{new_file_name}', ContentFile(uploaded_file.read()))
            evaluation.contenu_evaluation=file_path.split('/')[-1]
        evaluation.save()
        return JsonResponse({"message":"L'évaluation est modifiée avec succès"},safe=False,status=201)
    except Exception:
         return JsonResponse({"message":"Un problème est survenu lors de la modification de l'evaluation"},safe=False,status=500) 
    

def supprimerEvaluation(request,id_evaluation):
    evaluation = Evaluation.objects.get(id_evaluation=id_evaluation)
    notes = EleveNote.objects.filter(id_evaluation=id_evaluation)
    if notes.count()>0:
        notes.delete()
    deleted_count, deleted_details = evaluation.delete()
    if deleted_count>0:
        return JsonResponse({"message":"Les notes de l'évaluation sont enregistrées avec succès"},safe=False,status=200)
    return JsonResponse({"message":"Un problème est survenu lors de la suppression de l'evaluation"},safe=False,status=500)

@csrf_exempt
def enregistrerNotesEvaluation(request):
     try:
        evaluation = Evaluation.objects.get(id_evaluation=note['id_evaluation'])
        data = json.loads(request.body)
        notes = data.get('notes')
        notes_insert = []
        for note in notes:
            mention = EleveNote.getMentionNote(note['note'],evaluation.ponderer_eval)
            print(mention)
            notes_insert.append(
                EleveNote(
                    date_saisie = note['date_saisie'],
                    note = note['note'],
                    id_annee = Annee.objects.get(id_annee=note['id_annee']),
                    id_campus =  Campus.objects.get(id_campus=note['id_campus']),
                    id_classe_active =  ClasseActive.objects.get(id_classe_active=note['id_classe']),
                    id_cours_classe = CoursParClasse.objects.get(id_cours_classe=note['id_cours']),
                    id_cycle_actif =  ClasseCycleActif.objects.get(id_cycle_actif=note['id_cycle']),
                    id_eleve = Eleve.objects.get(id_eleve=note['id_eleve']),
                    id_type_note = EleveNoteType.objects.get(id_type_note=note['id_type_note']),
                    id_evaluation = evaluation,
                    id_periode = Periode.objects.get(id_periode=note['id_periode']),
                    id_session = Session.objects.get(id_session=note['id_session']),
                    id_trimestre = Trimestre.objects.get(id_trimestre=note['id_trimestre'])))
            
        EleveNote.objects.bulk_create(notes_insert)
        return JsonResponse({"message":"Les notes de l'évaluation sont enregistrées avec succès"},safe=False,status=201)
     except Exception:
         return JsonResponse({"message":"Un problème est survenu lors de l'enregistrement des notes de l'evaluation"},safe=False,status=500)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def afficherNotesEvaluation(request,id_evaluation):
    notes = EleveNote.objects.filter(id_evaluation=id_evaluation).select_related(
        'id_annee',
        'id_campus',
        'id_classe_active','id_classe_active__classe_id',
        'id_cours_classe','id_cours_classe__id_cours',
        'id_cycle_actif','id_cycle_actif__cycle_id',
        'id_eleve',
        'id_type_note',
        'id_evaluation',
        'id_periode',
        'id_session',
        'id_trimestre'
    ).annotate(
        classe=F('id_classe_active__classe_id__classe'),
        nom=F('id_eleve__nom'),
        ponderation=F('id_evaluation__ponderer_eval'),
        prenom=F('id_eleve__prenom'),
        groupe=F('id_classe_active__groupe'),
        annee=F('id_annee__annee'),
        campus=F('id_campus__campus'),
        cycle=F('id_cycle_actif__cycle_id__cycle'),
        cours=F('id_cours_classe__id_cours__cours'),
        type_note=F('id_type_note__type'),
        periode=F('id_periode__periode'),
        session=F('id_session__session'),
        trimestre=F('id_trimestre__trimestre')
    ).values('classe','nom','prenom','groupe','cours','annee','campus','cycle','type_note','periode','session','trimestre','ponderation').order_by('note')
    return JsonResponse(list(notes.values()),safe=False,status=200)
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def afficher_rapports_periodique(request,id_eleve,id_cours,debut,fin,id_annee):

    start_date = datetime.strptime(debut,'%Y-%m-%d')
    end_date = datetime.strptime(fin,'%Y-%m-%d')
    inscription = EleveInscription.objects.get(id_eleve=id_eleve,id_annee=id_annee)
    evaluations = Evaluation.objects.filter(
        id_annee=id_annee,
        id_classe_active=inscription.id_classe,
        id_cours_classe=id_cours,
        date_eval__range=(start_date, end_date)
        ) if id_cours>0 else Evaluation.objects.filter(
            id_annee=id_annee,
            id_classe_active=inscription.id_classe,
            date_eval__range=(start_date, end_date))
    evaluations = evaluations.select_related(
        'id_classe_active',
        'id_classe_active__classe_id',
        'id_cours_classe',
        'id_cours_classe__id_cours',
        'id_type_note',
        'id_periode',
        'id_session',
        'id_trimestre'
        ).annotate(
        classe=F('id_classe_active__classe_id__classe'),
        cours=F('id_cours_classe__id_cours__cours'),
        type_evaluation=F('id_type_note__type'),
        periode=F('id_periode__periode'),
        session=F('id_session__session'),
        trimestre=F('id_trimestre__trimestre'),
       ).values('classe','cours','type_evaluation','periode','session','trimestre').order_by('date_eval','cours')
    
    conduites = EleveConduite.objects.filter(
        id_annee=id_annee,
        id_eleve=id_eleve,
        id_horaire__id_cours=id_cours,
        date_enregistrement__range=(start_date, end_date)) if id_cours>0 else EleveConduite.objects.filter(
            id_annee=id_annee,
            id_eleve=id_eleve,
            date_enregistrement__range=(start_date, end_date))
    conduites = conduites.select_related(
        'id_horaire',
        'id_horaire__id_cours',
        'id_horaire__id_cours__id_cours',
        'id_annee',
        'id_classe',
        'id_campus',
        'id_classe__classe_id',
        'id_cycle',
        'id_eleve',
        'id_type_note',
        'id_periode',
        'id_session',
        'id_trimestre'
        ).annotate(
        classe=F('id_classe__classe_id__classe'),
        nom=F('id_eleve__nom'),
        prenom=F('id_eleve__prenom'),
        groupe=F('id_classe__groupe'),
        cours_id=F('id_horaire__id_cours'),
        jour=F('id_horaire__jour'),
        debut=F('id_horaire__debut'),
        annee=F('id_annee__annee'),
        fin=F('id_horaire__fin'),
        campus=F('id_campus__campus'),
        cycle=F('id_cycle__cycle_id__cycle'),
        cours=F('id_horaire__id_cours__id_cours__cours')
       ).values('classe','cours','cours_id','nom','prenom','groupe','debut','fin','jour','annee','campus','cycle').order_by('nom','prenom')

    presences = HorairePresence.objects.filter(
        id_eleve=id_eleve,
        date_presence__range=(start_date,end_date)
    ).select_related(
        'id_horaire',
        'id_eleve','id_horaire__id_classe','id_horaire__id_horaire_type',
        'id_horaire__id_classe__classe_id',
        'id_horaire__id_cours','id_horaire__id_cycle','id_horaire__id_annee',
        'id_horaire__id_cours__id_cours','id_horaire__id_campus').annotate(
        nom=F('id_eleve__nom'),
        prenom=F('id_eleve__prenom'),
        email=F('id_eleve__email'),
        email_parent=F('id_eleve__email_parent'),
        telephone=F('id_eleve__telephone'),
        matricule=F('id_eleve__matricule'),
        date_naissance=F('id_eleve__date_naissance'),
        nom_pere=F('id_eleve__nom_pere'),
        prenom_pere=F('id_eleve__prenom_pere'),
        nom_mere=F('id_eleve__nom_mere'),
        prenom_mere=F('id_eleve__prenom_mere'),
        nationalite=F('id_eleve__nationalite'),
        commune=F('id_eleve__commune_actuelle'),
        zone=F('id_eleve__zone_actuelle'),
        groupe=F('id_horaire__id_classe__groupe'),
        classe=F('id_horaire__id_classe__classe_id__classe'),
        jour=F('id_horaire__jour'),
        debut=F('id_horaire__debut'),
        annee=F('id_horaire__id_annee__annee'),
        fin=F('id_horaire__fin'),
        campus=F('id_horaire__id_campus__campus'),
        cycle=F('id_horaire__id_cycle__cycle_id__cycle'),
        cours=F('id_horaire__id_cours__id_cours__cours'),
        id_classe=F('id_horaire__id_classe'),
        id_cours=F('id_horaire__id_cours'),
        id_annee=F('id_horaire__id_annee'),
        id_cycle=F('id_horaire__id_cycle'),
        id_campus=F('id_horaire__id_campus')
        ).values(
            'nom',
            'prenom',
            'nom_pere',
            'prenom_pere',
            'nom_mere',
            'prenom_mere',
            'email',
            'email_parent',
            'telephone',
            'matricule',
            'nationalite',
            'commune',
            'zone','groupe','debut','fin','jour','annee','campus','cycle',
            'date_naissance','classe','cours','id_classe','id_cours','id_annee','id_cycle','id_campus').order_by('nom','prenom')
    
    return JsonResponse({
        'evaluations':list(evaluations.values()),
        'conduites':list(conduites.values()),
        'presences':list(presences.values())
    },safe=False,status=200)


def download_file(request, file_name):
    file_path = f'../media/uploads/{file_name}'
    if default_storage.exists(file_path):
        return FileResponse(default_storage.open(file_path, 'rb'), as_attachment=True)
    return JsonResponse({"error": "Fichier non trouvé"}, status=404)




