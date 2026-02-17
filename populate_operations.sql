-- populate_operations.sql
-- Script pour remplir les tables d'opérations et éviter l'écran blanc sur le Dashboard

USE db_eschoolmobile;

-- 1. Tâches Enseignants
DELETE FROM personnelEnseignant_Taches; -- Nettoyage (optionnel)
INSERT INTO personnelEnseignant_Taches (tache) VALUES
('Gestion des Présences'),
('Saisie des Notes'),
('Communications aux Parents'),
('Gestion de l\'Horaire'),
('Attribution des Devoirs'),
('Calendrier des Examens'),
('Suivi des Bulletins'),
('Discipline et Conduite');

-- 2. Postes Administratifs
DELETE FROM personnel_posteAdministratif; -- Nettoyage (optionnel)
INSERT INTO personnel_posteAdministratif (poste) VALUES
('Agent Comptable'),
('Directeur d\'École'),
('Superviseur Pédagogique'),
('Secrétaire Administratif'),
('Préfet des Études'),
('Proviseur'),
('Intendant'),
('Bibliothécaire'),
('Animateur Culturel'),
('Directeur de Discipline');

-- 3. Opérations Parents (Dashboard Parent)
DELETE FROM parent_operations; -- Nettoyage (optionnel)
INSERT INTO parent_operations (libelle_operation, code_action, icone_name) VALUES
('Visualiser les Notes', 'VIEW_GRADES', 'grade'),
('Vérifier les Présences', 'VIEW_ATTENDANCE', 'event_available'),
('Effectuer un Paiement', 'MAKE_PAYMENT', 'payments'),
('Historique des Paiements', 'PAYMENT_HISTORY', 'receipt_long'),
('Messagerie École', 'COMMUNICATION', 'chat'),
('Calendrier Scolaire', 'CALENDAR', 'calendar_month'),
('Suivi Discipline', 'DISCIPLINE', 'gavel'),
('Documents Administratifs', 'DOCUMENTS', 'description'),
('Menu de la Cantine', 'CANTINE', 'restaurant'),
('Transport Scolaire', 'TRANSPORT', 'directions_bus');

SELECT "Données insérées avec succès. L'écran blanc devrait disparaître." as message;
