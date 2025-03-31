-- Creation des cluster

--Cluster entre table utilisateurs et utilisation_materiel
DROP CLUSTER cluster_utilisation_materiel;
CREATE CLUSTER cluster_utilisation_materiel (
    ID_UTILISATEUR NUMBER
) SIZE 1024 TABLESPACE ts_donnees;

--Cluster entre table intervention et materiel
CREATE CLUSTER cluster_intervention_materiel (
    ID_MATERIEL NUMBER
) SIZE 1024 TABLESPACE ts_donnees;