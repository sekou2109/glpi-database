ALTER SESSION SET CONTAINER = CDB$ROOT;
ALTER SESSION SET CONTAINER = XEPDB1;
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


GRANT dba TO c##admin;


-- 1
GRANT INSERT ON utilisation_materiel TO c##etudiant;  
GRANT SELECT ON v_affectation TO c##user;             

-- 2
GRANT SELECT, INSERT, UPDATE ON intervention TO c##technicien, c##personnel, c##admin;
GRANT SELECT ON v_interventions TO c##technicien, c##personnel, c##admin;
GRANT SELECT ON v_interventions_technicien TO c##technicien, c##admin;


-- 3
GRANT INSERT ON materiel TO c##personnel, c##admin;
GRANT SELECT ON v_materiel TO c##personnel, c##technicien, c##admin;


-- 4
GRANT INSERT ON utilisateur TO c##admin;
GRANT SELECT ON v_utilisateurs TO c##personnel, c##admin;


-- 5
GRANT INSERT ON technicien TO c##admin, c##personnel;
GRANT SELECT, UPDATE ON technicien TO c##admin, c##personnel, c##technicien;


-- 6
GRANT UPDATE ON technicien TO c##admin, c##personnel;


-- 7
GRANT INSERT ON site TO c##admin, c##personnel;
GRANT SELECT ON v_sites TO c##user;  -- La consultation des sites reste ouverte à tous



