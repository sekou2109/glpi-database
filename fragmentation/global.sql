SHOW CON_NAME;
ALTER SESSION SET CONTAINER = XEPDB1;
SELECT db_link, host, username FROM user_db_links;
SELECT * FROM UTILISATEUR_GLOBAL;
-- Vue globale reconstruite sur le site de Cergy

-- Utilisateur Global
CREATE OR REPLACE VIEW utilisateur_global AS
SELECT * FROM UTILISATEUR
UNION
SELECT * FROM c##pau.UTILISATEUR@link_pau;

-- Matériel Global
CREATE OR REPLACE VIEW materiel_tech_global AS
SELECT * FROM MATERIEL_TECH_CERGY
UNION
SELECT * FROM C##PAU.materiel_tech_pau@link_pau;
DROP VIEW materiel_tech_global;

CREATE OR REPLACE VIEW materiel_maintenance_global AS
SELECT * FROM MATERIEL_MAINTENANCE_CERGY
UNION
SELECT * FROM C##PAU.materiel_maintenance_pau@link_pau;

-- Technicien Global
CREATE OR REPLACE VIEW technicien_global AS
SELECT * FROM technicien_cergy
UNION
SELECT * FROM C##PAU.technicien_pau@link_pau;

-- Intervention (verticale)
CREATE OR REPLACE VIEW intervention_header_global AS
SELECT * FROM intervention_header
UNION
SELECT * FROM C##PAU.intervention_header@link_pau;

CREATE OR REPLACE VIEW intervention_detail_global AS
SELECT * FROM intervention_detail
UNION
SELECT * FROM c##PAU.intervention_detail@link_pau;
