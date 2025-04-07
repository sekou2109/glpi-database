--Choix entre view classique et view materialisée 
-- view classique = accès aux données peu fréquent et que les données d'une table sont mises à jour fréquemment
-- view materialisée = données consultées fréquemment et que les données d'une table ne sont pas mises à jour fréquemment.


-- Fragmentation horizontale

-- UTILISATEUR

-- utilisateurs de Cergy

CREATE VIEW utilisateur_cergy AS SELECT * FROM utilisateur WHERE id_site=(SELECT id_site FROM site WHERE nom='Cergy');

-- utilisateurs de Pau

CREATE VIEW utilisateur_pau AS SELECT * FROM utilisateur WHERE id_site=(SELECT id_site FROM site WHERE nom='Pau');


-- MATERIEL (voir fragmentation mixte)

-- materiels de Cergy

-- CREATE VIEW materiel_cergy AS SELECT * FROM materiel WHERE id_site=(SELECT id_site FROM site WHERE nom='Cergy');

-- materiel de Pau

-- CREATE VIEW materiel_pau AS SELECT * FROM materiel WHERE id_site=(SELECT id_site FROM site WHERE nom='Pau');


-- TECHNICIEN

-- technicien de Cergy (vue materialisée)

CREATE MATERIALIZED VIEW log_technicien_cergy AS SELECT * FROM technicien WHERE id_site=(SELECT id_site FROM site WHERE nom='Cergy');

CREATE MATERIALIZED VIEW technicien_cergy REFRESH ON COMMIT FAST AS SELECT * FROM technicien WHERE id_site=(SELECT id_site FROM site WHERE nom='Cergy');

-- technicien de Pau (vue materialisée)

CREATE MATERIALIZED VIEW log_technicien_pau AS SELECT * FROM technicien WHERE id_site=(SELECT id_site FROM site WHERE nom='Pau');

CREATE MATERIALIZED VIEW technicien_pau REFRESH ON COMMIT FAST AS SELECT * FROM technicien WHERE id_site=(SELECT id_site FROM site WHERE nom='Pau');


-- Fragmentation verticale

-- INTERVENTION

-- informations les plus utiles dans la table INTERVENTION

CREATE VIEW intervention_header AS SELECT id_intervention, statut, date_demande
FROM intervention;

-- informations détaillées des interventions

CREATE VIEW intervention_detail AS SELECT id_intervention, id_materiel, id_technicien, description, date_debut, date_fin
FROM intervention;


-- Fragmentation mixte

-- MATERIEL

-- informations sur les caractéristiques techniques du matériel

-- Cergy

CREATE VIEW materiel_tech_cergy AS  
SELECT id_materiel, type_materiel, modele, adresse_ip  
FROM materiel  
WHERE id_site=(SELECT id_site FROM site WHERE nom='Cergy');


-- Pau
CREATE VIEW materiel_tech_pau AS  
SELECT id_materiel, type_materiel, modele, adresse_ip  
FROM materiel  
WHERE id_site=(SELECT id_site FROM site WHERE nom='Pau');


-- informations sur l'etat du stock des matériels

-- Cergy

CREATE VIEW materiel_maintenance_cergy AS  
SELECT id_materiel, etat, quantite  
FROM materiel  
WHERE id_site=(SELECT id_site FROM site WHERE nom='Cergy');


-- Pau

CREATE VIEW materiel_maintenance_pau AS  
SELECT id_materiel, etat, quantite  
FROM materiel  
WHERE id_site=(SELECT id_site FROM site WHERE nom='Pau');