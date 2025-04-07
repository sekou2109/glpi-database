-- Creation des cluster
SHOW CON_NAME;
ALTER SESSION SET CONTAINER = XEPDB1;
ALTER SESSION SET CONTAINER = CDB$ROOT;

--Cluster entre table utilisateurs et utilisation_materiel
DROP CLUSTER cluster_utilisation_materiel;
CREATE CLUSTER cluster_utilisation_materiel (
    ID_UTILISATEUR NUMBER
) SIZE 1024 TABLESPACE ts_donnees;

DROP CLUSTER cluster_intervention_materiel;
--Cluster entre table intervention et materiel
CREATE CLUSTER cluster_intervention_materiel (
    ID_MATERIEL NUMBER
) SIZE 1024 TABLESPACE ts_donnees;