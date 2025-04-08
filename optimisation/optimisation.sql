BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE PLAN_TABLE';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

@?\rdbms\admin\utlxplan.sql;

EXEC DBMS_STATS.GATHER_TABLE_STATS(USER, 'UTILISATEUR');
EXEC DBMS_STATS.GATHER_TABLE_STATS(USER, 'MATERIEL');
EXEC DBMS_STATS.GATHER_TABLE_STATS(USER, 'SITE');
EXEC DBMS_STATS.GATHER_TABLE_STATS(USER, 'TECHNICIEN');
EXEC DBMS_STATS.GATHER_TABLE_STATS(USER, 'INTERVENTION');
EXEC DBMS_STATS.GATHER_TABLE_STATS(USER, 'UTILISATION_MATERIEL');
--------------------------------------------------------------------------------
-- Requête complexe 1 : Jointure de plusieurs tables
--------------------------------------------------------------------------------
EXPLAIN PLAN FOR 
SELECT 
    u.nom,
    u.prenom,
    s.nom AS site,
    m.type_materiel,
    m.modele,
    t.nom AS tech_nom,
    t.prenom AS tech_prenom,
    i.date_debut,
    i.date_fin,
    i.statut
FROM UTILISATEUR u
JOIN SITE s ON u.id_site = s.id_site
JOIN MATERIEL m ON s.id_site = m.id_site
JOIN INTERVENTION i ON m.id_materiel = i.id_materiel
JOIN TECHNICIEN t ON i.id_technicien = t.id_technicien
WHERE i.statut = 'En cours'
  AND m.etat = 'Disponible'
  AND u.role = 'Etudiant';

-- Affichage du plan d'exécution de la requête 1
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

--------------------------------------------------------------------------------
-- Requête complexe 2 : Utilisation d'une sous-requête
--------------------------------------------------------------------------------
EXPLAIN PLAN FOR
SELECT *
FROM MATERIEL m
WHERE m.id_materiel IN (
    SELECT i.id_materiel
    FROM INTERVENTION i
    WHERE i.date_debut > SYSDATE - 30
      AND i.statut <> 'Résolu'
);

-- Affichage du plan d'exécution de la requête 2
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

--------------------------------------------------------------------------------
-- Requête complexe 3 : Agrégation avec jointure
--------------------------------------------------------------------------------
EXPLAIN PLAN FOR
SELECT 
    s.nom AS site, 
    COUNT(m.id_materiel) AS total_materiel, 
    AVG(m.quantite) AS avg_quantite
FROM SITE s
LEFT JOIN MATERIEL m ON s.id_site = m.id_site
GROUP BY s.nom
HAVING COUNT(m.id_materiel) > 5;

-- Affichage du plan d'exécution de la requête 3
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

SET AUTOTRACE ON;

SELECT * FROM UTILISATEUR WHERE ROLE = 'Etudiant';
SELECT * FROM MATERIEL WHERE TYPE_MATERIEL = 'Ordinateur';

SET AUTOTRACE OFF;
