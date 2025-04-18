SHOW CON_NAME;
ALTER SESSION SET CONTAINER = XEPDB1;

CREATE DATABASE LINK link_pau 
  CONNECT TO c##pau IDENTIFIED BY pau 
  USING 'XEPDB1';
SELECT * FROM UTILISATEUR@link_pau;
-- Fragmentation horizontale : utilisateur_cergy
CREATE VIEW utilisateur_cergy AS 
SELECT * FROM utilisateur 
WHERE id_site = (SELECT id_site FROM site WHERE nom='Cergy');

-- Fragmentation mixte : materiel tech & maintenance
CREATE VIEW materiel_tech_cergy AS  
SELECT id_materiel, type_materiel, modele, adresse_ip  
FROM materiel  
WHERE id_site = (SELECT id_site FROM site WHERE nom='Cergy');

SELECT * FROM MATERIEL_TECH_CERGY;

CREATE VIEW materiel_maintenance_cergy AS  
SELECT id_materiel, etat, quantite  
FROM materiel  
WHERE id_site = (SELECT id_site FROM site WHERE nom='Cergy');

-- Technicien Cergy (vue matérialisée)
CREATE MATERIALIZED VIEW LOG ON technicien WITH PRIMARY KEY;
CREATE MATERIALIZED VIEW technicien_cergy REFRESH ON COMMIT FAST AS
SELECT * FROM technicien 
WHERE id_site = 1;

-- Fragmentation verticale (locale)
CREATE VIEW intervention_header AS 
SELECT id_intervention, statut, date_demande 
FROM intervention;

CREATE VIEW intervention_detail AS 
SELECT id_intervention, id_materiel, id_technicien, description, date_debut, date_fin 
FROM intervention;
