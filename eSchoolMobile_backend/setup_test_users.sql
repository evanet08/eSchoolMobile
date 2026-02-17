-- SQL Script to Setup Test Environment for eSchoolMobile (Final Production Schema)
-- Password for all users will be '123456'
-- PBKDF2 Hash for '123456': 'pbkdf2_sha256$870000$Vv6Q3nL3v6Q3$b1f2g3h4i5j6k7l8m9n0o1p2q3r4s5t6u7v8w9x0y1z2'

SET FOREIGN_KEY_CHECKS = 0;

-- 1. Ensure basic structures exist (Campus, Annee, etc.)
INSERT IGNORE INTO campus (id_campus, campus, adresse) VALUES (1, 'Campus Test', 'Adresse Test');
INSERT IGNORE INTO annee (id_annee, debut, fin, annee, etat_annee, date_ouverture, date_cloture) 
VALUES (1, 2025, 2026, '2025-2026', 'Ouverte', '2025-09-01', '2026-06-30');
INSERT IGNORE INTO classe_cycle (id_cycle, cycle) VALUES (1, 'Cycle Secondaire');
INSERT IGNORE INTO classes (id_classe, classe) VALUES (1, '7ème Année');

-- 2. Create a Classe Cycle Actif
INSERT IGNORE INTO classe_cycle_actif (id_cycle_actif, cycle_id_id, id_annee_id, id_campus_id, is_active, date_creation) 
VALUES (1, 1, 1, 1, 1, CURDATE());

-- 3. Create a Classe Active
INSERT IGNORE INTO classe_active (id_classe_active, id_campus_id, id_annee_id, cycle_id_id, classe_id_id, groupe, isTerminale, is_active, date_creation)
VALUES (1, 1, 1, 1, 1, 'A', 0, 1, CURDATE());

-- 4. Create a Parent
DELETE FROM parent WHERE telephone = '+243000000000';
INSERT INTO parent (nom, prenom, telephone, email, password) 
VALUES ('TEST', 'Parent', '+243000000000', 'parent_test@example.com', 'pbkdf2_sha256$870000$Vv6Q3nL3v6Q3$b1f2g3h4i5j6k7l8m9n0o1p2q3r4s5t6u7v8w9x0y1z2');
SET @parent_id = LAST_INSERT_ID();

-- 5. Create 3 Students and link to Parent
DELETE FROM eleve WHERE email IN ('student1@test.com', 'student2@test.com', 'student3@test.com');
INSERT INTO eleve (nom, prenom, genre, email, telephone, password, id_parent, date_naissance) VALUES 
('ELEVE1', 'Test', 'M', 'student1@test.com', '+243000000001', 'pbkdf2_sha256$870000$Vv6Q3nL3v6Q3$b1f2g3h4i5j6k7l8m9n0o1p2q3r4s5t6u7v8w9x0y1z2', @parent_id, '2010-01-01'),
('ELEVE2', 'Test', 'F', 'student2@test.com', '+243000000002', 'pbkdf2_sha256$870000$Vv6Q3nL3v6Q3$b1f2g3h4i5j6k7l8m9n0o1p2q3r4s5t6u7v8w9x0y1z2', @parent_id, '2010-02-01'),
('ELEVE3', 'Test', 'M', 'student3@test.com', '+243000000003', 'pbkdf2_sha256$870000$Vv6Q3nL3v6Q3$b1f2g3h4i5j6k7l8m9n0o1p2q3r4s5t6u7v8w9x0y1z2', @parent_id, '2010-03-01');

-- 6. Inscribe students in the class
INSERT IGNORE INTO trimestre (id_trimestre, trimestre, is_active) VALUES (1, '1er Trimestre', 1);
INSERT INTO eleve_inscription (date_inscription, id_annee_id, id_campus_id, id_classe_id, id_classe_cycle_id, id_eleve_id, id_trimestre_id, status, redoublement, isDelegue)
SELECT CURDATE(), 1, 1, 1, 1, id_eleve, 1, 1, 0, 0 FROM eleve WHERE id_parent = @parent_id;

-- 7. Create a Teacher (Django User + Personnel)
DELETE FROM auth_user WHERE username = 'teacher_test';
INSERT INTO auth_user (password, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) 
VALUES ('pbkdf2_sha256$870000$Vv6Q3nL3v6Q3$b1f2g3h4i5j6k7l8m9n0o1p2q3r4s5t6u7v8w9x0y1z2', 0, 'teacher_test', 'Enseignant', 'Test', 'teacher@test.com', 1, 1, NOW());
SET @teacher_user_id = LAST_INSERT_ID();

INSERT IGNORE INTO diplome (id_diplome, diplome, sigle) VALUES (1, 'Licence', 'L');
INSERT IGNORE INTO personnel_categorie (id_personnel_category, categorie, sigle) VALUES (1, 'Enseignant', 'ENS');
INSERT IGNORE INTO personnel_type (id_type_personnel, type, sigle) VALUES (1, 'Permanent', 'P');
INSERT IGNORE INTO specialite (id_specialite, specialite, sigle) VALUES (1, 'Mathématiques', 'MATH');
INSERT IGNORE INTO vacation (id_vacation, vacation) VALUES (1, 'Journée');

INSERT INTO personnel (matricule, genre, etat_civil, type_identite, telephone, province, commune, zone, addresse, isMaitresse, isInstiteur, isDAF, isDirecteur, isUser, en_fonction, is_verified, id_diplome_id, user_id, id_categorie_id, id_personnel_type_id, id_specialite_id, id_vacation_id, date_creation)
VALUES ('T001', 'M', 'Célibataire', 'ID', '+243111111111', 'Kinshasa', 'Gombe', 'Z1', 'Addresse Enseignant', 0, 0, 0, 0, 1, 1, 1, 1, @teacher_user_id, 1, 1, 1, 1, CURDATE());
SET @personnel_id = LAST_INSERT_ID();

-- 8. Assign Teacher to Class
INSERT IGNORE INTO attribution_type (id_attribution_type, attribution_type) VALUES (1, 'Titulaire');
INSERT IGNORE INTO cours (id_cours, cours, code_cours) VALUES (1, 'Mathématiques', 'MATH01');
INSERT IGNORE INTO cours_par_classe (id_cours_classe, ponderation, id_annee_id, id_campus_id, id_classe_id, id_cours_id, id_cycle_id, date_creation) 
VALUES (1, 100, 1, 1, 1, 1, 1, CURDATE());
INSERT INTO attribution_cours (id_annee_id, attribution_type_id, id_campus_id, id_classe_id, id_cycle_id, id_cours_id, id_personnel_id, date_attribution)
VALUES (1, 1, 1, 1, 1, 1, @personnel_id, CURDATE());

-- 9. Add some Notes
INSERT IGNORE INTO eleve_note_type (id_type_note, type, sigle) VALUES (1, 'Examen', 'EX');
INSERT IGNORE INTO periode (id_periode, periode, is_active, id_trimestre_id) VALUES (1, 'P1', 1, 1);
INSERT IGNORE INTO session (id_session, session) VALUES (1, 'Principale');
INSERT IGNORE INTO evaluation (id_evaluation, title, ponderer_eval, date_eval, id_annee_id, id_campus_id, id_classe_active_id, id_cours_classe_id, id_cycle_actif_id, id_type_note_id, id_periode_id, id_session_id, id_trimestre_id, date_creation)
VALUES (1, 'Examen Math P1', 100, CURDATE(), 1, 1, 1, 1, 1, 1, 1, 1, 1, CURDATE());

INSERT INTO eleve_note (date_saisie, note, id_annee_id, id_campus_id, id_classe_active_id, id_cours_classe_id, id_cycle_actif_id, id_eleve_id, id_type_note_id, id_evaluation_id, id_periode_id, id_session_id, id_trimestre_id)
SELECT CURDATE(), 75.5, 1, 1, 1, 1, 1, id_eleve, 1, 1, 1, 1, 1 FROM eleve WHERE id_parent = @parent_id;

-- 10. Create an Admin User
DELETE FROM auth_user WHERE username = 'admin_test';
INSERT INTO auth_user (password, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) 
VALUES ('pbkdf2_sha256$870000$Vv6Q3nL3v6Q3$b1f2g3h4i5j6k7l8m9n0o1p2q3r4s5t6u7v8w9x0y1z2', 1, 'admin_test', 'Admin', 'Test', 'admin@test.com', 1, 1, NOW());
SET @admin_user_id = LAST_INSERT_ID();

INSERT IGNORE INTO personnel_posteAdministratif (id_posteAdministratif, poste) VALUES (2, 'Directeur d\'École');
INSERT INTO personnel (matricule, genre, etat_civil, type_identite, telephone, province, commune, zone, addresse, isMaitresse, isInstiteur, isDAF, isDirecteur, isUser, en_fonction, is_verified, id_diplome_id, user_id, id_categorie_id, id_personnel_type_id, id_specialite_id, id_vacation_id, id_posteAdministratif, date_creation)
VALUES ('A001', 'M', 'Marié', 'ID', '+243222222222', 'Kinshasa', 'Gombe', 'Z1', 'Addresse Admin', 0, 0, 0, 1, 1, 1, 1, 1, @admin_user_id, 1, 1, 1, 1, 2, CURDATE());

SET FOREIGN_KEY_CHECKS = 1;
