-- index

DROP INDEX idx_cluster_utilisation_materiel;

CREATE INDEX idx_cluster_utilisation_materiel 
ON CLUSTER cluster_utilisation_materiel TABLESPACE ts_index;

DROP INDEX idx_cluster_intervention_materiel;

CREATE INDEX idx_cluster_intervention_materiel 
ON CLUSTER cluster_intervention_materiel TABLESPACE ts_index;