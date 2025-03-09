--ATTENTION ICI ORACLE n'accepte que les chemins ABSOLUE pas RELATIF
--Donc faudra mettre votre chemin absolu

-- Création des tablespaces

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

-- Création du tablespace pour les logs
DROP TABLESPACE ts_logs INCLUDING CONTENTS AND DATAFILES;

CREATE TABLESPACE ts_logs
DATAFILE 'H:\Documents\ing2\semestre2\TraitementData\projet_dossier\glpi-database\tablespace\ts_logs.dbf'
SIZE 100K REUSE
AUTOEXTEND ON NEXT 100K MAXSIZE 300M;

-- Création du tablespace pour les index
DROP TABLESPACE ts_index INCLUDING CONTENTS AND DATAFILES;
CREATE TABLESPACE ts_index
DATAFILE 'H:\Documents\ing2\semestre2\TraitementData\projet_dossier\glpi-database\tablespace\ts_index.dbf'
SIZE 100K REUSE
AUTOEXTEND ON NEXT 100K MAXSIZE 200M;



