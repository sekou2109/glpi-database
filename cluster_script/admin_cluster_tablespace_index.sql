ALTER USER c##admin_cluster quota unlimited on users;
-- Je crée le user admin cluser
-- Créer le user admin en tant que system
DROP USER c##admin_cluster;
DROP ROLE c##role_admin_cluster;
CREATE USER c##admin_cluster IDENTIFIED BY admin_cluster;

-- Création du role et association du role au user toujours en tant que system ou sys
CREATE ROLE c##role_admin_cluster;
GRANT CONNECT TO c##role_admin_cluster;
GRANT RESOURCE TO c##role_admin_cluster;
GRANT CREATE TABLESPACE TO c##role_admin_cluster;
GRANT DROP TABLESPACE TO c##role_admin_cluster;
GRANT ALTER TABLESPACE TO c##role_admin_cluster;
GRANT CREATE ANY DIRECTORY TO c##role_admin_cluster;
GRANT c##role_admin_cluster TO c##admin_cluster;




