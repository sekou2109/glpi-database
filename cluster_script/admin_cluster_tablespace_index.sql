-- A executer que dans sys user
DROP USER c##admin_cluster;
DROP ROLE c##role_admin_cluster;
SELECT TS_DONNEES FROM dba_tablespaces;
SHOW CON_NAME;
ALTER SESSION SET CONTAINER = XEPDB1;
-- Je crée le user admin cluser
-- Créer le user admin en tant que system

CREATE USER c##admin_cluster IDENTIFIED BY admin_cluster;

-- Création du role et association du role au user toujours en tant que système ou sys
CREATE ROLE c##role_admin_cluster;
GRANT CONNECT TO c##role_admin_cluster;
GRANT RESOURCE TO c##role_admin_cluster;
GRANT CREATE TABLESPACE TO c##role_admin_cluster;
GRANT CREATE ANY TABLE TO c##role_admin_cluster;
GRANT DROP TABLESPACE TO c##role_admin_cluster;
GRANT ALTER TABLESPACE TO c##role_admin_cluster;
GRANT CREATE ANY DIRECTORY TO c##role_admin_cluster;
GRANT ALTER SESSION TO c##role_admin_cluster;
GRANT SET CONTAINER TO c##role_admin_cluster;
GRANT CREATE CLUSTER TO c##role_admin_cluster;
GRANT c##role_admin_cluster TO c##admin_cluster;

-- A n'exécuter que dans le user admin et quand les tablespaces sont créés
ALTER USER c##admin_cluster quota unlimited on users;
ALTER USER C##admin_cluster QUOTA UNLIMITED ON TS_DONNEES;
ALTER USER C##admin_cluster QUOTA UNLIMITED ON TS_INDEX;
ALTER USER C##admin_cluster QUOTA UNLIMITED ON TS_LOGS;
ALTER USER C##admin_cluster QUOTA UNLIMITED ON TS_SITE_CERGY;
ALTER USER C##admin_cluster QUOTA UNLIMITED ON TS_SITE_PAU;


