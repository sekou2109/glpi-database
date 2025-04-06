--ATTENTION ICI ORACLE n'accepte que les chemins ABSOLUE pas RELATIF
--Donc faudra mettre votre chemin absolu
--Pour creer les tablespace faudra pas être sous SYS mais sous le user 
--c##admin_cluster
-- Création des tablespaces

-- ETAPES IMPORTANTE METTRE le CONTAINER PDB à XEPDB1
SHOW CON_NAME
ALTER SESSION SET CONTAINER = XEPDB1;

-- Création du tablespace pour les données
DROP TABLESPACE ts_donnees INCLUDING CONTENTS AND DATAFILES;
CREATE TABLESPACE ts_donnees
DATAFILE 'H:\Documents\ing2\semestre2\TraitementData\projet_dossier\glpi-database\tablespace\ts_donnees.dbf' 
SIZE 100K REUSE
AUTOEXTEND ON NEXT 100K MAXSIZE 200M;

-- Création du tablespace pour les index
DROP TABLESPACE ts_index INCLUDING CONTENTS AND DATAFILES;
CREATE TABLESPACE ts_index
DATAFILE 'H:\Documents\ing2\semestre2\TraitementData\projet_dossier\glpi-database\tablespace\ts_index.dbf'
SIZE 100K REUSE
AUTOEXTEND ON NEXT 100K MAXSIZE 200M;

-- Création du tablespace pour les logs utilisation matériel
DROP TABLESPACE ts_logs INCLUDING CONTENTS AND DATAFILES;

CREATE TABLESPACE ts_logs
DATAFILE 'H:\Documents\ing2\semestre2\TraitementData\projet_dossier\glpi-database\tablespace\ts_logs.dbf'
SIZE 100K REUSE
AUTOEXTEND ON NEXT 100K MAXSIZE 300M;

-- Création du tablespace pour site cergy
DROP TABLESPACE ts_site_cergy INCLUDING CONTENTS AND DATAFILES;

CREATE TABLESPACE ts_site_cergy
DATAFILE 'H:\Documents\ing2\semestre2\TraitementData\projet_dossier\glpi-database\tablespace\ts_site_cergy.dbf'
SIZE 100K REUSE
AUTOEXTEND ON NEXT 100K MAXSIZE 200M;

-- Création du tablespace pour site Pau
DROP TABLESPACE ts_site_pau INCLUDING CONTENTS AND DATAFILES;

CREATE TABLESPACE ts_site_pau
DATAFILE 'H:\Documents\ing2\semestre2\TraitementData\projet_dossier\glpi-database\tablespace\ts_site_pau.dbf'
SIZE 100K REUSE
AUTOEXTEND ON NEXT 100K MAXSIZE 200M;
