SHOW CON_NAME;
ALTER SESSION SET CONTAINER = XEPDB1;

SELECT * FROM MATERIEL;
CREATE DATABASE LINK link_cergy 
  CONNECT TO c##cergy IDENTIFIED BY cergy 
  USING 'XEPDB1';
SELECT * FROM UTILISATEUR@link_cergy;

-- Fragmentation horizontale : utilisateur_pau
CREATE VIEW utilisateur_pau AS 
SELECT * FROM utilisateur 
WHERE id_site = (SELECT id_site FROM site WHERE nom='Pau');

-- Fragmentation mixte : materiel tech & maintenance
CREATE VIEW materiel_tech_pau AS  
SELECT id_materiel, type_materiel, modele, adresse_ip  
FROM materiel  
WHERE id_site = (SELECT id_site FROM site WHERE nom='Pau');

CREATE VIEW materiel_maintenance_pau AS  
SELECT id_materiel, etat, quantite  
FROM materiel  
WHERE id_site = (SELECT id_site FROM site WHERE nom='Pau');

DESCRIBE materiel_maintenance_pau;

SELECT * FROM c##pau.materiel_maintenance_pau@link_pau WHERE ROWNUM <= 1;

-- Technicien Pau (vue matérialisée)
CREATE MATERIALIZED VIEW LOG ON technicien WITH PRIMARY KEY;
CREATE MATERIALIZED VIEW technicien_pau REFRESH ON COMMIT FAST AS
SELECT * FROM technicien 
WHERE id_site = 2;

-- Fragmentation verticale (locale)
CREATE VIEW intervention_header AS 
SELECT id_intervention, statut, date_demande 
FROM intervention;

CREATE VIEW intervention_detail AS 
SELECT id_intervention, id_materiel, id_technicien, description, date_debut, date_fin 
FROM intervention;
