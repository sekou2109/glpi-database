/* CREATION DES UTILISATEURS */
CREATE USER c##hadj identified by hadj;
CREATE USER c##axel identified by axel;
CREATE USER c##sekou identified by sekou;
CREATE USER c##bryan identified by bryan;

/* AUTORISATION DE BASE */
GRANT connect,resource TO c##hadj;
GRANT connect,resource TO c##axel;
GRANT connect,resource TO c##sekou;
GRANT connect,resource TO c##bryan;

/* CREATION DES ROLES*/
CREATE ROLE c##common;
CREATE ROLE c##usermanager;

/*ATTRIBUTION DES ROLES*/
GRANT c##common TO c##hadj;
GRANT c##common TO c##axel;
GRANT c##common TO c##sekou;
GRANT c##common TO c##bryan;
GRANT c##usermanager TO c##bryan;

/* ATTRIBUTION DE PERMISSIONS*/
GRANT CREATE ROLE, ALTER ANY ROLE TO c##usermanager;