-- Création de la table pour les postes administratifs
CREATE TABLE personnel_posteAdministratif (
    id_posteAdministratif INT AUTO_INCREMENT PRIMARY KEY,
    poste VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

-- Création de la table pour les tâches des enseignants
CREATE TABLE personnelEnseignant_Taches (
    id_tache INT AUTO_INCREMENT PRIMARY KEY,
    tache VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

-- Ajout des colonnes de clés étrangères dans la table personnel
ALTER TABLE personnel
ADD COLUMN id_posteAdministratif INT,
ADD COLUMN id_tache INT;

-- Ajout des contraintes de clés étrangères
ALTER TABLE personnel
ADD CONSTRAINT fk_personnel_poste 
FOREIGN KEY (id_posteAdministratif) REFERENCES personnel_posteAdministratif(id_posteAdministratif)
ON DELETE SET NULL;

ALTER TABLE personnel
ADD CONSTRAINT fk_personnel_tache 
FOREIGN KEY (id_tache) REFERENCES personnelEnseignant_Taches(id_tache)
ON DELETE SET NULL;
