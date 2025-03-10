/* CREATION DES UTILISATEURS */
CREATE USER c##patrick IDENTIFIED BY patrick;
CREATE USER c##senku IDENTIFIED BY senku;
CREATE USER c##severine IDENTIFIED BY severine;
CREATE USER c##seb IDENTIFIED BY seb;
CREATE USER c##theo IDENTIFIED BY theo;

/* CREATION DES ROLES */

CREATE ROLE c##user;
CREATE ROLE c##etudiant;
CREATE ROLE c##prof;
CREATE ROLE c##personnel;
CREATE ROLE c##admin;
CREATE ROLE c##technicien;

/* GESTION DES PERMISSIONS */
GRANT connect,resource TO c##user;


/* ATTRIBUTION DES ROLES */
GRANT c##user TO c##patrick;
GRANT c##prof TO c##patrick;

GRANT c##user TO c##senku;
GRANT c##etudiant TO c##senku;

GRANT c##user TO c##severine;
GRANT c##personnel TO c##severine;

GRANT c##user TO c##seb;
GRANT c##technicien TO c##seb;

GRANT c##user TO c##theo;
GRANT c##admin TO c##theo;
