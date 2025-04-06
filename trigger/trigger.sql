-- Se placer dans admin_cluster
SHOW CON_NAME;
ALTER SESSION SET CONTAINER = XEPDB1;
SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER test_trig
AFTER INSERT ON utilisateur
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('Insertion en cours dans la table utilisateur : ' || :NEW.nom || ' ' || :NEW.prenom);
END;
/

INSERT INTO SITE (ID_SITE, NOM) VALUES (1, 'Cergy');
INSERT INTO SITE (ID_SITE, NOM) VALUES (2, 'Pau');
INSERT INTO utilisateur (id_utilisateur, nom, prenom, id_site) VALUES (1, 'Doe', 'John', 1);
INSERT INTO utilisateur (id_utilisateur, nom, prenom, id_site) VALUES (2, 'Doe', 'Jane', 2);
INSERT INTO utilisateur (id_utilisateur, nom, prenom, id_site) VALUES (3, 'Doe', 'Jack', 1);
INSERT INTO utilisateur (id_utilisateur, nom, prenom, id_site) VALUES (4, 'Doe', 'Jill', 2);
DELETE FROM UTILISATEUR;
-- SELECT * FROM utilisateur;

-- trigger sur utilisation materiel
-- filepath: h:\Documents\ing2\semestre2\TraitementData\projet_dossier\glpi-database\trigger\trigger.sql
CREATE OR REPLACE TRIGGER affectation_user_to_materiel
BEFORE INSERT ON utilisation_materiel
FOR EACH ROW
DECLARE
    v_nom       UTILISATEUR.NOM%TYPE;
    v_prenom    UTILISATEUR.PRENOM%TYPE;
    v_site      UTILISATEUR.ID_SITE%TYPE;
    v_role      UTILISATEUR.ROLE%TYPE;
    v_site_nom  SITE.NOM%TYPE;
    v_type_materiel VARCHAR2(50);
    v_modele    VARCHAR2(50);
    v_new_id_materiel NUMBER;
BEGIN
    -- Récupérer les infos de l'utilisateur
    SELECT NOM, PRENOM, ROLE, ID_SITE
      INTO v_nom, v_prenom, v_role, v_site
      FROM UTILISATEUR
      WHERE ID_UTILISATEUR = :NEW.ID_UTILISATEUR;

    -- Récupérer le nom du site
    SELECT NOM
      INTO v_site_nom
      FROM SITE
      WHERE ID_SITE = v_site;

    -- Déterminer le type de matériel et le modèle en fonction du rôle de l'utilisateur
    v_type_materiel := CASE 
        WHEN v_role = 'Admin' THEN 'Ordinateur'
        WHEN v_role = 'Professeur' THEN 'Imprimante'
        WHEN v_role = 'Personnel_Administratif' THEN 'Scanner'
        WHEN v_role = 'Etudiant' THEN 'Tablette'
        ELSE 'Autre'
    END;

    v_modele := CASE 
        WHEN v_role = 'Admin' THEN 'Dell-XPS'
        WHEN v_role = 'Professeur' THEN 'HP-LaserJet'
        WHEN v_role = 'Personnel_Administratif' THEN 'Canon-Scan'
        WHEN v_role = 'Etudiant' THEN 'iPad'
        ELSE 'Générique'
    END;

    -- Générer un nouvel ID pour le matériel et insérer dans MATERIEL
    v_new_id_materiel := material_id_seq.NEXTVAL;
    INSERT INTO MATERIEL (id_materiel, type_materiel, modele, etat, adresse_ip, quantite, id_site)
    VALUES (
        v_new_id_materiel, 
        v_type_materiel,
        v_modele,
        CASE 
            WHEN DBMS_RANDOM.VALUE(0, 1) < 0.2 THEN 'En panne'
            ELSE 'Disponible'
        END,
        '192.168.' || TRUNC(DBMS_RANDOM.VALUE(0, 256)) || '.' || TRUNC(DBMS_RANDOM.VALUE(0, 256)),
        1,
        v_site
    );

    -- Assigner le nouvel ID_MATERIEL à l'insertion en cours dans UTILISATION_MATERIEL
    :NEW.ID_MATERIEL := v_new_id_materiel;
    -- Affichage d'un message avec l'ID, le nom, le prénom, le rôle et le nom du site
    DBMS_OUTPUT.PUT_LINE('Matériel affecté à l utilisateur : ID=' || :NEW.ID_UTILISATEUR ||
                         ', Nom=' || v_nom || ', Prénom=' || v_prenom ||
                         ', Rôle=' || v_role || ', Site=' || v_site_nom ||
                         ', Type Matériel=' || v_type_materiel || ', Modèle=' || v_modele);
END;
/
-- trigger sur intervention
-- remplacer par les vues necessaires
CREATE OR REPLACE TRIGGER notification_intervention
AFTER INSERT ON intervention
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('Insertion en cours dans la table intervention : ' || :NEW.id_intervention || ' ' || :NEW.id_materiel || ' ' || :NEW.id_technicien);
END;
/
