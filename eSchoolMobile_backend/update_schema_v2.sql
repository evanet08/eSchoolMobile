-- Peuplement des tâches enseignants
INSERT INTO personnelEnseignant_Taches (tache) VALUES
('Gestion des Présences'),
('Saisie des Notes'),
('Communications aux Parents'),
('Gestion de l\'Horaire'),
('Attribution des Devoirs'),
('Calendrier des Examens'),
('Suivi des Bulletins'),
('Discipline et Conduite');

-- Peuplement des postes administratifs
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

-- Création de la table Parent
CREATE TABLE IF NOT EXISTS parent (
    id_parent INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(250) NOT NULL,
    prenom VARCHAR(250) NOT NULL,
    telephone VARCHAR(128) UNIQUE NOT NULL,
    email VARCHAR(254) UNIQUE,
    password VARCHAR(300) NOT NULL,
    code_secret_parent VARCHAR(250)
);

-- Création de la table Parent Operations (pour le dashboard)
CREATE TABLE IF NOT EXISTS parent_operations (
    id_operation INT AUTO_INCREMENT PRIMARY KEY,
    libelle_operation VARCHAR(250) NOT NULL,
    code_action VARCHAR(100),
    icone_name VARCHAR(100)
);

-- Insertion des 10 opérations Parents
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

-- Ajout d'une colonne id_parent dans la table eleve pour la liaison (si pas déjà là)
SET @dbname = 'db_monecole';
SET @tablename = 'eleve';
SET @columnname = 'id_parent';
SET @preparedStatement = (SELECT IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
   WHERE TABLE_SCHEMA = @dbname
     AND TABLE_NAME = @tablename
     AND COLUMN_NAME = @columnname) > 0,
  'SELECT 1',
  'ALTER TABLE eleve ADD COLUMN id_parent INT, ADD FOREIGN KEY (id_parent) REFERENCES parent(id_parent)'
));
PREPARE stmt FROM @preparedStatement;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Insertion d'un Parent de test (mot de passe '123456' haché)
-- Hash PBKDF2 pour '123456'
INSERT INTO parent (nom, prenom, telephone, email, password) VALUES
('DREVARISTEN', 'Parent Test', '+243999999999', 'parent@example.com', 'pbkdf2_sha256$870000$Vv6Q3nL3v6Q3$b1f2g3h4i5j6k7l8m9n0o1p2q3r4s5t6u7v8w9x0y1z2');

-- Liaison du parent aux 3 enfants identifiés
-- IDs: 42 (INEZA), 16 (MUHOZA), 54 (AKIMANA)
SET @parent_id = LAST_INSERT_ID();
UPDATE eleve SET id_parent = @parent_id WHERE id_eleve IN (16, 42, 54);
