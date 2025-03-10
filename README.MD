# Comment créer initialiser les cluster, tablespace et index

## Etape 1 Administration
Se connecter en tant que sys user et creer le user le role dans le script sql
Situé dans **cluster_script/admin_cluster_tablespace_index.sql** en exécutant ces parties
```sql
ALTER SESSION SET CONTAINER = XEPDB1;
```
CREATION USER
```sql
CREATE USER c##admin_cluster IDENTIFIED BY admin_cluster;
```

CREATION ROLE
```sql
GRANT c##role_admin_cluster TO c##admin_cluster;
```

GRANT LES AUTORISATION sur le role 
```sql
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
```

GRANT le role à l'utilisateur
```sql
GRANT c##role_admin_cluster TO c##admin_cluster;
```

## Etape 2 creation des tablespace

IMPORTANT:

SE connecter avec c##admin_cluster / mdp:admin_cluster 

puis executer

```sql
ALTER SESSION SET CONTAINER = XEPDB1;
```
Dans le même dossier cluster_script
il y a le fichier template: **creation_tablespace_cluster_index.sql.tmpl**

il faut creer le même fichier avec le même nom mais **SANS LE TMPL DANS LE MEME DOSSIER**
Et copier le contenue dans dans le fichier sans tmpl.
car le fichier est ignoré dans le .gitignore:
```sql
-- Création du tablespace pour le site de Cergy
DROP TABLESPACE ts_site_cergy INCLUDING CONTENTS AND DATAFILES;
CREATE TABLESPACE ts_site_cergy
DATAFILE 'your_path\glpi-database\tablespace\ts_site_cergy.dbf'
SIZE 100K REUSE
AUTOEXTEND ON NEXT 100K MAXSIZE 200M;
```
faut mettre à la place le chemin absolue. La raison ??
Oracle ne prend pas en compte les chemins relatifs. Donc faut mettre son propre
chemin jusqu'au fichier.


ainsi il faut exécuter cette suite pour le tablespace

```sql
-- Création du tablespace pour les données
DROP TABLESPACE ts_donnees INCLUDING CONTENTS AND DATAFILES;
CREATE TABLESPACE ts_donnees
DATAFILE 'your_path/glpi-database/tablespace/ts_donnees.dbf'
SIZE 100K REUSE
AUTOEXTEND ON NEXT 100K MAXSIZE 200M;

-- Création du tablespace pour les index
DROP TABLESPACE ts_index INCLUDING CONTENTS AND DATAFILES;
CREATE TABLESPACE ts_index
DATAFILE 'your_path/glpi-database/tablespace/ts_index.dbf'
SIZE 100K REUSE
AUTOEXTEND ON NEXT 100K MAXSIZE 200M;

-- Création du tablespace pour les logs
DROP TABLESPACE ts_logs INCLUDING CONTENTS AND DATAFILES;
CREATE TABLESPACE ts_logs
DATAFILE 'your_path\glpi-database\tablespace\ts_logs.dbf'
SIZE 100K REUSE
AUTOEXTEND ON NEXT 100K MAXSIZE 300M;

-- Création du tablespace pour le site de Cergy
DROP TABLESPACE ts_site_cergy INCLUDING CONTENTS AND DATAFILES;
CREATE TABLESPACE ts_site_cergy
DATAFILE 'your_path\glpi-database\tablespace\ts_site_cergy.dbf'
SIZE 100K REUSE
AUTOEXTEND ON NEXT 100K MAXSIZE 200M;

-- Création du tablespace pour le site de Pau
DROP TABLESPACE ts_site_pau INCLUDING CONTENTS AND DATAFILES;
CREATE TABLESPACE ts_site_pau
DATAFILE 'your_path\glpi-database\tablespace\ts_site_pau.dbf'
SIZE 100K REUSE
AUTOEXTEND ON NEXT 100K MAXSIZE 200M;
```

## ETAPE 3: Création des clusters
Toujours en tant que c##admin_cluster
```sql
--Cluster entre table utilisateurs et utilisation_materiel
DROP CLUSTER cluster_utilisation_materiel;
CREATE CLUSTER cluster_utilisation_materiel (
    ID_UTILISATEUR NUMBER
) SIZE 1024 TABLESPACE ts_donnees;

--Cluster entre table intervention et materiel
CREATE CLUSTER cluster_intervention_materiel (
    ID_MATERIEL NUMBER
) SIZE 1024 TABLESPACE ts_donnees;
```

## ETAPE 4: Création des tables
CREATE TABLE MATERIEL (
    ID_MATERIEL NUMBER PRIMARY KEY,
    TYPE_MATERIEL VARCHAR2(50),
    MODELE VARCHAR2(50),
    ETAT VARCHAR2(20) CHECK (ETAT IN ('Disponible', 'En panne', 'Réparé')),
    ADRESSE_IP VARCHAR2(15) UNIQUE, 
    QUANTITE NUMBER CHECK (QUANTITE >= 0),
    ID_SITE NUMBER REFERENCES SITE(ID_SITE)
) CLUSTER cluster_intervention_materiel (ID_MATERIEL);

CREATE TABLE UTILISATION_MATERIEL (
    ID_UTILISATEUR NUMBER,
    ID_MATERIEL NUMBER REFERENCES MATERIEL(ID_MATERIEL),
    DATE_UTILISATION DATE DEFAULT SYSDATE,
    PRIMARY KEY (ID_UTILISATEUR, ID_MATERIEL, DATE_UTILISATION)
) CLUSTER cluster_utilisation_materiel (ID_UTILISATEUR);

CREATE TABLE INTERVENTION (
    ID_INTERVENTION NUMBER PRIMARY KEY,
    ID_MATERIEL NUMBER,
    ID_TECHNICIEN NUMBER REFERENCES TECHNICIEN(ID_TECHNICIEN),
    DATE_DEMANDE DATE DEFAULT SYSDATE,
    DATE_DEBUT DATE,  
    DATE_FIN DATE,  
    STATUT VARCHAR2(20) CHECK (STATUT IN ('En attente', 'En cours', 'Résolu')),
    DESCRIPTION VARCHAR2(255)
) CLUSTER cluster_intervention_materiel (ID_MATERIEL);

CREATE TABLE TECHNICIEN (
    ID_TECHNICIEN NUMBER PRIMARY KEY,
    NOM VARCHAR2(50),
    PRENOM VARCHAR2(50),
    ENTREPRISE VARCHAR2(100),
    COMPETENCES VARCHAR2(255), 
    HEURE_DEBUT_SERVICE TIMESTAMP,
    HEURE_FIN_SERVICE TIMESTAMP
)TABLESPACE ts_donnees;

## ETAPE 5: Création des index

```sql
-- index

DROP INDEX idx_cluster_utilisation_materiel;

CREATE INDEX idx_cluster_utilisation_materiel 
ON CLUSTER cluster_utilisation_materiel TABLESPACE ts_index;

DROP INDEX idx_cluster_intervention_materiel;

CREATE INDEX idx_cluster_intervention_materiel 
ON CLUSTER cluster_intervention_materiel TABLESPACE ts_index;
```

