-- Insertion de données dans la table utilisateur
CREATE SEQUENCE seq_utilisateur START WITH 1 INCREMENT BY 1;

DECLARE
	v_nom VARCHAR2(50);
	v_prenom VARCHAR2(50);
	v_email VARCHAR2(100);
	v_role VARCHAR2(20);
	v_id_site NUMBER;
	num NUMBER :=1;
	
BEGIN

	FOR num IN 1..89 LOOP
		v_nom := dbms_random.string('U', dbms_random.values(5,10));
		v_prenom := dbms_random.string('U', dbms_random.values(5,10));
		v_email := LOWER(v_nom || '.' || v_prenom || '@cy-tech.fr');
		
		IF num <= 4 THEN
			v_role := 'Admin';
		ELSIF num <= 15 THEN
			v_role := 'Professeur';
		ELSIF num <= 39 THEN
			v_role := 'Personnel_Administratif';
		ELSE:
			v_role := 'Etudiant';
		END IF;
	
		-- 1 = Cergy et 2 == Pau
		v_id_site := FLOOR(dbms_random.value(1,3));
	
		INSERT INTO UTILISATEUR (ID_UTILISATEUR, NOM, PRENOM, EMAIL, ROLE, ID_SITE)
		VALUES (seq_utilisateur.NEXTVAL, v_nom, v_prenom, v_email, v_role, v_id_site)
	
		END LOOP;
		
		COMMIT;
		
END;
/

-- Insertion de données dans la table materiel

CREATE SEQUENCE seq_materiel START WITH 1 INCREMENT BY 1;

DECLARE
	v_type_materiel VARCHAR2(50);
	v_modele VARCHAR2(50);
	v_etat VARCHAR2(20);
	v_adresse_ip VARCHAR2(15);
	v_quantite NUMBER;
	v_id_site NUMBER;
	v_id_utilisateur NUMBER;
	v_prob NUMBER; --Probabilité pour ETAT
	
BEGIN

	--Assignation d'un PC portable à chaque utilisateur
	FOR user_info IN (SELECT id_utilisateur, id_site FROM utilisateur) LOOP
		v_type_materiel := 'PC_Portable';
		v_modele := 'Laptop-' || dbms_random.string('U', 5);
		v_prob := dbms_random.value(0, 1); -- Génération d'un nombre entre 0 et 1
		v_etat := CASE WHEN v_prob < 0.2 THEN 'En_panne' ELSE 'Disponible' END;
		v_adresse_ip := '192.168.1.' || seq_materiel.NEXTVAL;
		v_quantite := 1;
		v_id_site := user_num.ID_SITE;
		v_id_utilisateur := user_info.ID_UTILISATEUR;
		
		INSERT INTO materiel (id_materiel, type_materiel, modele, etat, adresse_ip, quantite, id_site)
		VALUES (seq_materiel.NEXTVAL, v_type_materiel, v_modele, v_etat, v_adresse_ip, v_quantite, v_id_site);
	END LOOP;
	
	-- Imprimantes
	FOR i IN 1..10 LOOP
		v_type_materiel := 'Imprimante';
		v_modele := 'Printer-' || dbms_random.string('U', 5);
		v_prob := dbms_random.value(0, 1);
		v_etat := CASE WHEN v_prob < 0.2 THEN 'En_panne' ELSE 'Disponible' END;
		v_adresse_ip := NULL;
		v_quantite := 1;
		v_id_site := FLOOR(dbms_random.value(1,3));
	
		INSERT INTO materiel (id_materiel, type_materiel, modele, etat, adresse_ip, quantite, id_site)
		VALUES (seq_materiel.NEXTVAL, v_type_materiel, v_modele, v_etat, v_adresse_ip, v_quantite, v_id_site)
	END LOOP;
	
	-- Ordinateur de bureau
	FOR 1..100 LOOP
		v_type_materiel := 'Ordinateur_Bureau';
		v_modele := 'Desktop-' || dbms_random.string('U', 5);
		v_prob := dbms_random.value(0, 1);
		v_etat := CASE WHEN v_prob < 0.2 THEN 'En_panne' ELSE 'Disponible' END;
		v_adresse_ip := '192.168.2.' || seq_materiel.NEXTVAL;
		v_quantite := 1;
		v_id_site := FLOOR(dbms_random.value(1,3));
		
		INSERT INTO MATERIEL (ID_MATERIEL, TYPE_MATERIEL, MODELE, ETAT, ADRESSE_IP, QUANTITE, ID_SITE)
        VALUES (seq_materiel.nextval, v_type_materiel, v_modele, v_etat, v_adresse_ip, v_quantite, v_id_site);
    END LOOP;
	
	-- Machine à café
	
		-- Imprimantes
	FOR i IN 1..10 LOOP
		v_type_materiel := 'Machine_Cafe';
		v_modele := 'Expresso-' || dbms_random.string('U', 5);
		v_prob := dbms_random.value(0, 1);
		v_etat := CASE WHEN v_prob < 0.2 THEN 'En_panne' ELSE 'Disponible' END;
		v_adresse_ip := NULL;
		v_quantite := 1;
		v_id_site := FLOOR(dbms_random.value(1,3));
	
		INSERT INTO materiel (id_materiel, type_materiel, modele, etat, adresse_ip, quantite, id_site)
		VALUES (seq_materiel.NEXTVAL, v_type_materiel, v_modele, v_etat, v_adresse_ip, v_quantite, v_id_site)
	END LOOP;
	
	COMMIT;
		
END;
/


-- Insertion de données dans la table site

INSERT INTO site VALUES (1, 'Cergy');
INSERT INTO site VALUES (2, 'Pau');

COMMIT;


-- Insertion de données dans la table technicien

CREATE SEQUENCE seq_technicien START WITH 1 INCREMENT BY 1;

DECLARE
	v_nom VARCHAR2(10);
	v_prenom VARCHAR2(10);
	v_entreprise VARCHAR2(10);
	v_competences VARCHAR2(50);
	v_heure_debut_service VARCHAR2(10);
	v_heure_fin_service VARCHAR2(10);
	v_id_site NUMBER;
	v_random NUMBER;

BEGIN
	-- Techniciens de Pau
	FOR 1..5 LOOP
		v_nom := dbms_random.string('U', 8);
		v_prenom := dbms_random.string('U', 10);
		v_entreprise := dbms_random.string('U', 5);
		v_heure_debut_service := '9:00';
		v_heure_fin_service := '17:00'
		v_id_site := 2;

		v_random := ROUND(dbms_random.value(1,5));
		v_competences := CASE v_random
			WHEN 1 THEN 'Reseau'
			WHEN 2 THEN 'Securite'
			WHEN 3 THEN 'Materiel et depannage'
			WHEN 4 THEN 'Machines a cafe'
			WHEN 5 THEN 'Assistence utilisateur'
		END;

		INSERT INTO TECHNICIEN (ID_TECHNICIEN, NOM, PRENOM, ENTREPRISE, COMPETENCES, HEURE_DEBUT_SERVICE, HEURE_FIN_SERVICE, ID_SITE)
		VALUES (seq_technicien.nextval, v_nom, v_prenom, v_entreprise, v_competences, v_heure_debut_service, v_heure_fin_service, v_id_site);
	END LOOP;

		-- Techniciens de Cergy
	FOR 1..5 LOOP
		v_nom := dbms_random.string('U', 8);
		v_prenom := dbms_random.string('U', 10);
		v_entreprise := dbms_random.string('U', 5);
		v_heure_debut_service := '9:00';
		v_heure_fin_service := '17:00'
		v_id_site := 1;

		v_random := ROUND(dbms_random.value(1,5));
		v_competences := CASE v_random
			WHEN 1 THEN 'Reseau'
			WHEN 2 THEN 'Securite'
			WHEN 3 THEN 'Materiel et depannage'
			WHEN 4 THEN 'Machines a cafe'
			WHEN 5 THEN 'Assistence utilisateur'
		END;

		INSERT INTO TECHNICIEN (ID_TECHNICIEN, NOM, PRENOM, ENTREPRISE, COMPETENCES, HEURE_DEBUT_SERVICE, HEURE_FIN_SERVICE, ID_SITE)
		VALUES (seq_technicien.nextval, v_nom, v_prenom, v_entreprise, v_competences, v_heure_debut_service, v_heure_fin_service, v_id_site);
	END LOOP;

	COMMIT;
END;
/

-- Insertion dans la table intervention

CREATE SEQUENCE seq_intervention START WITH 1 INCREMENT BY 1;

-- Fonction d'ajout d'une intervention (Demande d'intervention)

CREATE OR REPLACE FUNCTION demande_intervention(p_id_materiel NUMBER DEFAULT NULL)
RETURN NUMBER IS
	v_id_materiel NUMBER;
	v_id_technicien NUMBER;
	v_new_id NUMBER;
	v_count NUMBER;
BEGIN
	-- Gestion exception : aucun materiel en panne
	SELECT COUNT(*) INTO v_count FROM materiel WHERE etat='En_panne';
	IF v_count = 0 THEN
		RAISE_APPLICATION_ERROR(-20002, 'Aucun materiel en panne !');
	END IF;

	-- Choisir le materiel en panne
	IF p_id_materiel IS NOT NULL THEN
		SELECT COUNT(*) INTO v_count FROM materiel WHERE id_materiel=p_id_materiel AND etat='En_panne';
		IF v_count = 0 THEN
			RAISE_APPLICATION_ERROR(-20003, 'Le materiel selectionné n''est pas en panne.');
		END IF;
		v_id_materiel := p_id_materiel;

	ELSE:
		SELECT id_materiel FROM MATERIEL WHERE etat ='En_panne'
		ORDER BY dbms_random.value
		FETCH FIRST 1 ROW ONLY;
	END IF;

	-- Selection d'un technicien au hasard
	SELECT id_technicien INTO v_id_technicien FROM technicien ORDER BY dbms_random.value
	FETCH FIRST 1 ROW ONLY;

	-- insertion dans la table intervention
	INSERT INTO intervention (id_intervention, id_materiel, id_technicien, Date_demande, statut, description_intervention)
	VALUES (seq_intervention.nextval, v_id_materiel, v_id_technicien, SYSDATE, 'En_attente', 'Diagnostic_en_cours');

	-- On retourne ici l'id de l'intervention créée
	SELECT seq_intervention.currval INTO v_new_id FROM DUAL;

	RETURN v_new_id;
END demande_intervention;
/

--Mettre à jour intervention après le passage d'un technicien

CREATE OR REPLACE PROCEDURE mettre_a_jour_intervention(
	p_id_intervention NUMBER,
	p_nouveau_statut VARCHAR2
) IS
	v_id_materiel NUMBER;
BEGIN
	IF p_nouveau_statut NOT IN ('En_attente', 'En_cours', 'Resolu') THEN
		RAISE_APPLICATION_ERROR(-20001, 'Statut invalide. Utiliser : En_attente, En_cours, Resolu');
	END IF;

	SELECT id_materiel INTO v_id_materiel FROM intervention WHERE id_intervention=p_id_intervention;

	--Mise à jour de la table intervention
	UPDATE intervention SET statut=p_nouveau_statut,
	DATE_DEBUT = CASE WHEN p_nouveau_statut='En_cours' THEN SYSDATE ELSE DATE_DEBUT END,
	DATE_FIN = CASE WHEN p_nouveau_statut='Resolu' THEN SYSDATE ELSE NULL END
	WHERE id_intervention=p_id_intervention;

	IF p_nouveau_statut='Resolu' THEN
		UPDATE materiel SET etat='Disponible'
		WHERE id_materiel=v_id_materiel;
	END IF;

	COMMIT;
END mettre_a_jour_intervention;
/

-- Insertion de données dans la table utilisation_materiel


INSERT INTO UTILISATION_MATERIEL (ID_UTILISATEUR, ID_MATERIEL, DATE_UTILISATION)
VALUES (1, 1, SYSDATE);


INSERT INTO UTILISATION_MATERIEL (ID_UTILISATEUR, ID_MATERIEL, DATE_UTILISATION)
VALUES (2, 2, SYSDATE - 5);

-- L'utilisateur 3 utilise le PC 3 depuis une semaine
INSERT INTO UTILISATION_MATERIEL (ID_UTILISATEUR, ID_MATERIEL, DATE_UTILISATION)
VALUES (3, 3, SYSDATE - 7);


INSERT INTO UTILISATION_MATERIEL (ID_UTILISATEUR, ID_MATERIEL, DATE_UTILISATION)
VALUES (4, 4, SYSDATE - 3);

INSERT INTO UTILISATION_MATERIEL (ID_UTILISATEUR, ID_MATERIEL, DATE_UTILISATION)
VALUES (5, 5, SYSDATE);

COMMIT;





	

	
