SHOW CON_NAME;
ALTER SESSION SET CONTAINER = XEPDB1;
DROP SEQUENCE seq_utilisateur_pau;
CREATE SEQUENCE seq_utilisateur_pau START WITH 1 INCREMENT BY 1;

DECLARE
   v_nom     VARCHAR2(50);
   v_prenom  VARCHAR2(50);
   v_email   VARCHAR2(100);
   v_role    VARCHAR2(30);
BEGIN
   FOR num IN 1..44 LOOP
      v_nom := dbms_random.string('U', TRUNC(dbms_random.value(5, 10)));
      v_prenom := dbms_random.string('U', TRUNC(dbms_random.value(5, 10)));
      v_email := LOWER(v_nom || '.' || v_prenom || '@cy-tech.fr');

      IF num <= 2 THEN
         v_role := 'Admin';
      ELSIF num <= 7 THEN
         v_role := 'Professeur';
      ELSIF num <= 19 THEN
         v_role := 'Personnel_Administratif';
      ELSE
         v_role := 'Etudiant';
      END IF;

      INSERT INTO utilisateur (
         id_utilisateur,
         nom,
         prenom,
         email,
         role,
         id_site
      ) VALUES (
         seq_utilisateur_pau.NEXTVAL,
         v_nom,
         v_prenom,
         v_email,
         v_role,
         2 -- Pau
      );
   END LOOP;

   COMMIT;
END;
/


-- Materiel
CREATE SEQUENCE seq_materiel_pau START WITH 1 INCREMENT BY 1;

DECLARE
   v_type_materiel  VARCHAR2(50);
   v_modele         VARCHAR2(50);
   v_etat           VARCHAR2(20);
   v_adresse_ip     VARCHAR2(15);
   v_quantite       NUMBER;
   v_prob           NUMBER;
BEGIN
   -- PC portables pour chaque utilisateur de Pau
   FOR user_info IN (
      SELECT id_utilisateur
      FROM utilisateur
      WHERE id_site = 2
   ) LOOP
      v_type_materiel := 'PC_Portable';
      v_modele := 'Laptop-' || dbms_random.string('U', 5);
      v_prob := dbms_random.value(0, 1);
      v_etat := CASE WHEN v_prob < 0.2 THEN 'En panne' ELSE 'Disponible' END;
      v_adresse_ip := '192.168.1.' || seq_materiel_pau.NEXTVAL;
      v_quantite := 1;

      INSERT INTO materiel (
         id_materiel, type_materiel, modele, etat, adresse_ip, quantite, id_site
      ) VALUES (
         seq_materiel_pau.NEXTVAL, v_type_materiel, v_modele, v_etat, v_adresse_ip, v_quantite, 2
      );
   END LOOP;

   -- Imprimantes (5 pour Pau)
   FOR i IN 1..5 LOOP
      v_type_materiel := 'Imprimante';
      v_modele := 'Printer-' || dbms_random.string('U', 5);
      v_etat := CASE WHEN dbms_random.value(0,1) < 0.2 THEN 'En panne' ELSE 'Disponible' END;
      v_quantite := 1;

      INSERT INTO materiel (
         id_materiel, type_materiel, modele, etat, adresse_ip, quantite, id_site
      ) VALUES (
         seq_materiel_pau.NEXTVAL, v_type_materiel, v_modele, v_etat, NULL, v_quantite, 2
      );
   END LOOP;

   -- Ordinateurs de bureau (50 pour Pau)
   FOR i IN 1..50 LOOP
      v_type_materiel := 'Ordinateur_Bureau';
      v_modele := 'Desktop-' || dbms_random.string('U', 5);
      v_etat := CASE WHEN dbms_random.value(0,1) < 0.2 THEN 'En panne' ELSE 'Disponible' END;
      v_adresse_ip := '192.168.2.' || seq_materiel_pau.NEXTVAL;
      v_quantite := 1;

      INSERT INTO materiel (
         id_materiel, type_materiel, modele, etat, adresse_ip, quantite, id_site
      ) VALUES (
         seq_materiel_pau.NEXTVAL, v_type_materiel, v_modele, v_etat, v_adresse_ip, v_quantite, 2
      );
   END LOOP;

   -- Machines à café (5 pour Pau)
   FOR i IN 1..5 LOOP
      v_type_materiel := 'Machine_Cafe';
      v_modele := 'Expresso-' || dbms_random.string('U', 5);
      v_etat := CASE WHEN dbms_random.value(0,1) < 0.2 THEN 'En panne' ELSE 'Disponible' END;
      v_quantite := 1;

      INSERT INTO materiel (
         id_materiel, type_materiel, modele, etat, adresse_ip, quantite, id_site
      ) VALUES (
         seq_materiel_pau.NEXTVAL, v_type_materiel, v_modele, v_etat, NULL, v_quantite, 2
      );
   END LOOP;

   COMMIT;
END;
/


-- Insertion du site Pau
INSERT INTO site VALUES (2, 'Pau');

-- Séquence locale pour les techniciens de Pau
CREATE SEQUENCE seq_technicien_pau START WITH 1001 INCREMENT BY 1;

DECLARE
   v_nom                 VARCHAR2(10);
   v_prenom              VARCHAR2(10);
   v_entreprise          VARCHAR2(10);
   v_competences         VARCHAR2(50);
   v_heure_debut_service VARCHAR2(10) := '9:00';
   v_heure_fin_service   VARCHAR2(10) := '17:00';
   v_random              NUMBER;
BEGIN
   FOR i IN 1..5 LOOP
      v_nom := dbms_random.string('U', 8);
      v_prenom := dbms_random.string('U', 10);
      v_entreprise := dbms_random.string('U', 5);
      v_random := round(dbms_random.value(1, 5));

      v_competences :=
         CASE v_random
            WHEN 1 THEN 'Reseau'
            WHEN 2 THEN 'Securite'
            WHEN 3 THEN 'Materiel et depannage'
            WHEN 4 THEN 'Machines a cafe'
            WHEN 5 THEN 'Assistence utilisateur'
         END;

      INSERT INTO technicien (
         id_technicien,
         nom,
         prenom,
         entreprise,
         competences,
         heure_debut_service,
         heure_fin_service,
         id_site
      ) VALUES (
         seq_technicien_pau.NEXTVAL,
         v_nom,
         v_prenom,
         v_entreprise,
         v_competences,
         v_heure_debut_service,
         v_heure_fin_service,
         2
      );
   END LOOP;

   COMMIT;
END;
/

-- Utilisation de matériel par les utilisateurs de Pau

INSERT INTO utilisation_materiel (
   id_utilisateur,
   id_materiel,
   date_utilisation
) VALUES (16, 122, SYSDATE - 3);

INSERT INTO utilisation_materiel (
   id_utilisateur,
   id_materiel,
   date_utilisation
) VALUES (17, 124, SYSDATE);

COMMIT;


