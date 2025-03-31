-- Se placer dans admin_cluster
SHOW CON_NAME;
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
CREATE OR REPLACE TRIGGER user_utilise_materiel
AFTER INSERT ON utilisation_materiel
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('Insertion en cours dans la table utilisation_materiel : ' || :NEW.id_utilisateur || ' ' || :NEW.id_materiel);
END;
/

CREATE OR REPLACE TRIGGER affectation_user_to_materiel
AFTER INSERT ON utilisation_materiel
FOR EACH ROW
BEGIN
    INSERT INTO MATERIEL (id_materiel, type_materiel, modele, etat, adresse_ip, quantite, id_site)
    VALUES (material_id_seq.NEXTVAL, 'Type', 'Modèle', 'Disponible', '192.168.0.1', 1, 1);
    DBMS_OUTPUT.PUT_LINE('Matériel affecté à l utilisateur:' || :NEW.nom || :NEW.prenom);
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
