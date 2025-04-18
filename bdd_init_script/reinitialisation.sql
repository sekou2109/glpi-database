SHOW CON_NAME;
ALTER SESSION SET CONTAINER = XEPDB1;
ALTER SESSION SET CONTAINER = CDB$ROOT;
-- Suppression des tables dans l'ordre des dépendances
DROP TABLE UTILISATION_MATERIEL CASCADE CONSTRAINTS;
DROP TABLE INTERVENTION CASCADE CONSTRAINTS;
DROP TABLE TECHNICIEN CASCADE CONSTRAINTS;
DROP TABLE MATERIEL CASCADE CONSTRAINTS;
DROP TABLE UTILISATEUR CASCADE CONSTRAINTS;
DROP TABLE SITE CASCADE CONSTRAINTS;

-- Suppression des clusters
DROP CLUSTER cluster_utilisation_materiel INCLUDING TABLES;
DROP CLUSTER cluster_intervention_materiel INCLUDING TABLES;

-- Suppression des tablespaces et fichiers associés
DROP TABLESPACE ts_donnees INCLUDING CONTENTS AND DATAFILES;
DROP TABLESPACE ts_index INCLUDING CONTENTS AND DATAFILES;
DROP TABLESPACE ts_logs INCLUDING CONTENTS AND DATAFILES;
DROP TABLESPACE ts_site_cergy INCLUDING CONTENTS AND DATAFILES;
DROP TABLESPACE ts_site_pau INCLUDING CONTENTS AND DATAFILES;
