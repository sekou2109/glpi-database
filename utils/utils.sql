-- Modifier les PDB
SHOW CON_NAME;
ALTER SESSION SET CONTAINER = CDB$ROOT;
ALTER SESSION SET CONTAINER = XEPDB1;

-- Voir les clusters
SELECT cluster_name
FROM dba_clusters;
SELECT * FROM dba_clusters WHERE cluster_name IN ('CLUSTER_UTILISATION_MATERIEL', 'CLUSTER_INTERVENTION_MATERIEL');

-- Voir les tables créers
select table_name from user_tables;

-- Voir les vues creers
SELECT view_name FROM user_views;

-- voir les roles creer
SELECT role FROM dba_roles;

-- voir les user creer
SELECT username, account_status, created
FROM dba_users
WHERE username LIKE 'C##%';

