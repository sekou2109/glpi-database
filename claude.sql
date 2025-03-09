-- Création des tablespaces pour séparer les données par site
CREATE TABLESPACE ts_cergy
DATAFILE 'ts_cergy.dat' SIZE 100M AUTOEXTEND ON;
 
CREATE TABLESPACE ts_pau
DATAFILE 'ts_pau.dat' SIZE 100M AUTOEXTEND ON;
 
-- Création des utilisateurs et rôles Oracle
CREATE ROLE admin_role;
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW TO admin_role;
 
CREATE ROLE tech_role;
GRANT CREATE SESSION TO tech_role;
 
CREATE USER admin_user IDENTIFIED BY password DEFAULT TABLESPACE ts_cergy;
GRANT admin_role TO admin_user;
 
CREATE USER tech_user IDENTIFIED BY password DEFAULT TABLESPACE ts_cergy;
GRANT tech_role TO tech_user;
 
-- Table SITE
CREATE TABLE SITE (
    ID_SITE NUMBER PRIMARY KEY,
    NOM VARCHAR2(50) UNIQUE,
    ADRESSE VARCHAR2(200),
    TELEPHONE VARCHAR2(15)
) TABLESPACE ts_cergy;
 
-- Partition de la table UTILISATEUR par site
CREATE TABLE UTILISATEUR (
    ID_UTILISATEUR NUMBER PRIMARY KEY,
    NOM VARCHAR2(50) NOT NULL,
    PRENOM VARCHAR2(50) NOT NULL,
    EMAIL VARCHAR2(100) UNIQUE NOT NULL,
    ROLE VARCHAR2(20) CHECK (ROLE IN ('Admin', 'Technicien', 'Professeur', 'Personnel Administratif', 'Étudiant')),
    ID_SITE NUMBER REFERENCES SITE(ID_SITE) NOT NULL,
    DATE_CREATION DATE DEFAULT SYSDATE
) 
PARTITION BY REFERENCE (FK_UTILISATEUR_SITE);
 
-- Création d'index pour optimiser les recherches fréquentes
CREATE INDEX idx_utilisateur_email ON UTILISATEUR(EMAIL) TABLESPACE ts_cergy;
CREATE INDEX idx_utilisateur_role ON UTILISATEUR(ROLE) TABLESPACE ts_cergy;
 
-- Table TECHNICIEN avec héritage d'UTILISATEUR
CREATE TABLE TECHNICIEN (
    ID_TECHNICIEN NUMBER PRIMARY KEY,
    COMPETENCES VARCHAR2(255) NOT NULL, 
    NIVEAU VARCHAR2(20) CHECK (NIVEAU IN ('Junior', 'Confirmé', 'Expert')),
    HEURE_DEBUT_SERVICE TIMESTAMP,
    HEURE_FIN_SERVICE TIMESTAMP,
    CONSTRAINT FK_TECH_USER FOREIGN KEY (ID_TECHNICIEN) REFERENCES UTILISATEUR(ID_UTILISATEUR) ON DELETE CASCADE
) TABLESPACE ts_cergy;
 
-- Table TYPE_MATERIEL pour normalisation
CREATE TABLE TYPE_MATERIEL (
    ID_TYPE NUMBER PRIMARY KEY,
    LIBELLE VARCHAR2(50) UNIQUE NOT NULL,
    DESCRIPTION VARCHAR2(200)
) TABLESPACE ts_cergy;
 
-- Table MATERIEL avec partition par site
CREATE TABLE MATERIEL (
    ID_MATERIEL NUMBER PRIMARY KEY,
    ID_TYPE NUMBER REFERENCES TYPE_MATERIEL(ID_TYPE) NOT NULL,
    MODELE VARCHAR2(50) NOT NULL,
    NUMERO_SERIE VARCHAR2(50) UNIQUE,
    ETAT VARCHAR2(20) CHECK (ETAT IN ('Disponible', 'En maintenance', 'En panne', 'Réparé', 'Hors service')),
    ADRESSE_IP VARCHAR2(15) UNIQUE, 
    QUANTITE NUMBER DEFAULT 1 CHECK (QUANTITE >= 0),
    DATE_ACHAT DATE,
    DATE_GARANTIE DATE,
    ID_SITE NUMBER REFERENCES SITE(ID_SITE) NOT NULL
)
PARTITION BY REFERENCE (FK_MATERIEL_SITE);
 
-- Création d'index pour les recherches fréquentes
CREATE INDEX idx_materiel_etat ON MATERIEL(ETAT) TABLESPACE ts_cergy;
CREATE INDEX idx_materiel_type ON MATERIEL(ID_TYPE) TABLESPACE ts_cergy;
 
-- Table STATUT_INTERVENTION pour normalisation
CREATE TABLE STATUT_INTERVENTION (
    ID_STATUT NUMBER PRIMARY KEY,
    LIBELLE VARCHAR2(30) UNIQUE NOT NULL,
    DESCRIPTION VARCHAR2(200)
) TABLESPACE ts_cergy;
 
-- Table INTERVENTION avec cluster pour optimiser les requêtes liées
CREATE TABLE INTERVENTION (
    ID_INTERVENTION NUMBER PRIMARY KEY,
    ID_MATERIEL NUMBER REFERENCES MATERIEL(ID_MATERIEL) NOT NULL,
    ID_TECHNICIEN NUMBER REFERENCES TECHNICIEN(ID_TECHNICIEN) NOT NULL,
    ID_STATUT NUMBER REFERENCES STATUT_INTERVENTION(ID_STATUT) NOT NULL,
    DATE_DEMANDE DATE DEFAULT SYSDATE NOT NULL,
    DATE_DEBUT DATE,  
    DATE_FIN DATE,  
    DESCRIPTION VARCHAR2(1000),
    SOLUTION VARCHAR2(1000),
    PRIORITE NUMBER(1) CHECK (PRIORITE BETWEEN 1 AND 5),
    CONSTRAINT chk_dates CHECK (DATE_FIN IS NULL OR DATE_DEBUT IS NULL OR DATE_FIN >= DATE_DEBUT)
) TABLESPACE ts_cergy;
 
-- Création d'index pour les recherches fréquentes sur interventions
CREATE INDEX idx_intervention_dates ON INTERVENTION(DATE_DEMANDE, DATE_DEBUT, DATE_FIN) TABLESPACE ts_cergy;
CREATE INDEX idx_intervention_statut ON INTERVENTION(ID_STATUT) TABLESPACE ts_cergy;
 
-- Table de relation N:M pour UTILISATION_MATERIEL avec historisation
CREATE TABLE UTILISATION_MATERIEL (
    ID_UTILISATION NUMBER PRIMARY KEY,
    ID_UTILISATEUR NUMBER REFERENCES UTILISATEUR(ID_UTILISATEUR) ON DELETE CASCADE,
    ID_MATERIEL NUMBER REFERENCES MATERIEL(ID_MATERIEL) ON DELETE CASCADE,
    DATE_DEBUT DATE DEFAULT SYSDATE NOT NULL,
    DATE_FIN DATE,
    COMMENTAIRE VARCHAR2(200),
    CONSTRAINT chk_util_dates CHECK (DATE_FIN IS NULL OR DATE_FIN >= DATE_DEBUT)
) TABLESPACE ts_cergy;
 
-- Création d'une séquence pour les ID
CREATE SEQUENCE seq_utilisateur START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_materiel START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_intervention START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_utilisation START WITH 1 INCREMENT BY 1;
 
-- Création d'une vue pour simplifier les requêtes fréquentes
CREATE OR REPLACE VIEW vue_interventions_en_cours AS
SELECT i.ID_INTERVENTION, m.MODELE, t.NOM AS NOM_TECHNICIEN, t.PRENOM AS PRENOM_TECHNICIEN,
       i.DATE_DEMANDE, i.DATE_DEBUT, s.LIBELLE AS STATUT, i.DESCRIPTION, si.NOM AS SITE
FROM INTERVENTION i
JOIN MATERIEL m ON i.ID_MATERIEL = m.ID_MATERIEL
JOIN TECHNICIEN tc ON i.ID_TECHNICIEN = tc.ID_TECHNICIEN
JOIN UTILISATEUR t ON tc.ID_TECHNICIEN = t.ID_UTILISATEUR
JOIN STATUT_INTERVENTION s ON i.ID_STATUT = s.ID_STATUT
JOIN SITE si ON m.ID_SITE = si.ID_SITE
WHERE i.DATE_FIN IS NULL AND i.ID_STATUT != (SELECT ID_STATUT FROM STATUT_INTERVENTION WHERE LIBELLE = 'Résolu');
 
-- Trigger pour vérifier la disponibilité d'un technicien avant assignation
CREATE OR REPLACE TRIGGER trg_verif_dispo_technicien
BEFORE INSERT OR UPDATE ON INTERVENTION
FOR EACH ROW
DECLARE
    v_count NUMBER;
    v_competence VARCHAR2(255);
BEGIN
    -- Vérifier que le technicien n'a pas trop d'interventions en cours
    SELECT COUNT(*) INTO v_count
    FROM INTERVENTION
    WHERE ID_TECHNICIEN = :NEW.ID_TECHNICIEN
    AND ID_STATUT IN (SELECT ID_STATUT FROM STATUT_INTERVENTION WHERE LIBELLE IN ('En attente', 'En cours'))
    AND ID_INTERVENTION != NVL(:NEW.ID_INTERVENTION, 0);
    
    -- Récupérer les compétences du technicien
    SELECT COMPETENCES INTO v_competence
    FROM TECHNICIEN
    WHERE ID_TECHNICIEN = :NEW.ID_TECHNICIEN;
    
    -- Si plus de 5 interventions en cours, empêcher l'assignation
    IF v_count >= 5 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Ce technicien a déjà 5 interventions en cours.');
    END IF;
END;
/
 
-- Procédure pour générer des rapports d'activité
CREATE OR REPLACE PROCEDURE generer_rapport_activite(p_date_debut DATE, p_date_fin DATE, p_id_site NUMBER DEFAULT NULL)
AS
    v_total_interventions NUMBER;
    v_interventions_resolues NUMBER;
    v_temps_moyen_resolution NUMBER;
    v_site_nom VARCHAR2(50);
BEGIN
    -- Si un site est spécifié, récupérer son nom
    IF p_id_site IS NOT NULL THEN
        SELECT NOM INTO v_site_nom FROM SITE WHERE ID_SITE = p_id_site;
        DBMS_OUTPUT.PUT_LINE('Rapport d''activité pour le site ' || v_site_nom);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Rapport d''activité global');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('Période du ' || TO_CHAR(p_date_debut, 'DD/MM/YYYY') || ' au ' || TO_CHAR(p_date_fin, 'DD/MM/YYYY'));
    
    -- Total des interventions
    SELECT COUNT(*) INTO v_total_interventions
    FROM INTERVENTION i
    JOIN MATERIEL m ON i.ID_MATERIEL = m.ID_MATERIEL
    WHERE i.DATE_DEMANDE BETWEEN p_date_debut AND p_date_fin
    AND (p_id_site IS NULL OR m.ID_SITE = p_id_site);
    
    DBMS_OUTPUT.PUT_LINE('Total des interventions: ' || v_total_interventions);
    
    -- Interventions résolues
    SELECT COUNT(*) INTO v_interventions_resolues
    FROM INTERVENTION i
    JOIN MATERIEL m ON i.ID_MATERIEL = m.ID_MATERIEL
    JOIN STATUT_INTERVENTION s ON i.ID_STATUT = s.ID_STATUT
    WHERE i.DATE_DEMANDE BETWEEN p_date_debut AND p_date_fin
    AND s.LIBELLE = 'Résolu'
    AND (p_id_site IS NULL OR m.ID_SITE = p_id_site);
    
    DBMS_OUTPUT.PUT_LINE('Interventions résolues: ' || v_interventions_resolues);
    
    -- Temps moyen de résolution
    SELECT AVG(i.DATE_FIN - i.DATE_DEBUT) INTO v_temps_moyen_resolution
    FROM INTERVENTION i
    JOIN MATERIEL m ON i.ID_MATERIEL = m.ID_MATERIEL
    WHERE i.DATE_DEMANDE BETWEEN p_date_debut AND p_date_fin
    AND i.DATE_FIN IS NOT NULL
    AND (p_id_site IS NULL OR m.ID_SITE = p_id_site);
    
    DBMS_OUTPUT.PUT_LINE('Temps moyen de résolution: ' || ROUND(v_temps_moyen_resolution, 2) || ' jours');
END;
/