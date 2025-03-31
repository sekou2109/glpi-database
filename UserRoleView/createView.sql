CREATE OR REPLACE VIEW v_affectation AS
SELECT 
    u.idUtilisateur,
    u.nom AS nom_utilisateur,
    u.prenom AS prenom_utilisateur,
    m.idMateriel,
    m.type AS type_materiel,
    m.modele AS modele_materiel,
    um.date_utilisation AS date_affectation
FROM utilisateur u
JOIN utilisation_materiel um ON u.idUtilisateur = um.idUtilisateur
JOIN materiel m ON um.idMateriel = m.idMateriel;



-- 2) Vue pour la gestion des interventions (réparations)
CREATE OR REPLACE VIEW v_interventions AS
SELECT 
    i.idIntervention,
    i.date_demande,
    i.date_fin,
    i.statut,
    i.description,
    m.idMateriel,
    m.type AS type_materiel,
    m.modele AS modele_materiel,
    t.idTechnicien,
    t.competences AS competences_technicien
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
    idMateriel,
    type,
    modele,
    site,
    etat,
    adresse_ip,
    quantite
FROM materiel;

-- 4) Vue sur les utilisateurs
CREATE OR REPLACE VIEW v_utilisateurs AS
SELECT 
    idUtilisateur,
    nom,
    prenom,
    email,
    role
FROM utilisateur;

-- 5) Vue sur les techniciens
CREATE OR REPLACE VIEW v_techniciens AS
SELECT
    idTechnicien,
    competences,
    heure_debut_service,
    heure_fin_service
FROM technicien;



-- 7) Vue sur les sites
CREATE OR REPLACE VIEW v_sites AS
SELECT
    idSite,
    nom
FROM site;
