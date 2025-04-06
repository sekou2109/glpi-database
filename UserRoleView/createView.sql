SHOW CON_NAME;
ALTER SESSION SET CONTAINER = XEPDB1;
ALTER SESSION SET CONTAINER = CDB$ROOT;
select table_name from user_tables;

DESC UTILISATEUR;
CREATE OR REPLACE VIEW v_affectation AS
SELECT 
    u.ID_UTILISATEUR,
    u.nom AS nom_utilisateur,
    u.prenom AS prenom_utilisateur,
    m.ID_MATERIEL,
    m.TYPE_MATERIEL AS type_materiel,
    m.modele AS modele_materiel,
    um.DATE_UTILISATION AS date_affectation
FROM utilisateur u
JOIN utilisation_materiel um ON u.idUtilisateur = um.idUtilisateur
JOIN materiel m ON um.idMateriel = m.idMateriel;



-- 2) Vue pour la gestion des interventions (réparations)
CREATE OR REPLACE VIEW v_interventions AS
SELECT 
    i.ID_INTERVENTION,
    i.date_demande,
    i.date_fin,
    i.statut,
    i.DESCRIPTION_INTERVENTION,
    m.ID_MATERIEL,
    m.TYPE_MATERIEL AS type_materiel,
    m.MODELE AS modele_materiel,
    t.ID_TECHNICIEN,
    t.COMPETENCES AS competences_technicien
FROM intervention i
JOIN materiel m ON i.idMateriel = m.idMateriel
JOIN technicien t ON i.idTechnicien = t.idTechnicien;

CREATE OR REPLACE VIEW v_interventions_technicien AS
SELECT
    i.date_debut,
    i.date_fin,
    i.statut
FROM intervention i;



-- 3) Vue sur le matériel (avec IP)
CREATE OR REPLACE VIEW v_materiel AS
SELECT 
    m.ID_MATERIEL,
    m.TYPE_MATERIEL,
    m.MODELE,
    s.NOM,
    m.ETAT,
    m.adresse_ip,
    m.quantite
FROM materiel m
JOIN site s ON m.ID_SITE=s.ID_SITE;

-- 4) Vue sur les utilisateurs
-- voici une modif que j'ai fait pour corriger tout
CREATE OR REPLACE VIEW v_utilisateurs AS
SELECT 
    ID_UTILISATEUR,
    nom,
    prenom,
    email,
    ROLE
FROM UTILISATEUR;

-- 5) Vue sur les techniciens
CREATE OR REPLACE VIEW v_techniciens AS
SELECT
    ID_TECHNICIEN,
    competences,
    heure_debut_service,
    heure_fin_service
FROM technicien;



-- 7) Vue sur les sites
CREATE OR REPLACE VIEW v_sites AS
SELECT
    ID_SITE,
    nom
FROM site;
