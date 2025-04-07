-- Vue globale reconstruite sur le site de Cergy

-- Utilisateur Global
CREATE OR REPLACE VIEW utilisateur_global AS
SELECT * FROM utilisateur_cergy
UNION
SELECT * FROM utilisateur_pau@link_pau;

-- Matériel Global
CREATE OR REPLACE VIEW materiel_tech_global AS
SELECT * FROM materiel_tech_cergy
UNION
SELECT * FROM materiel_tech_pau@link_pau;

CREATE OR REPLACE VIEW materiel_maintenance_global AS
SELECT * FROM materiel_maintenance_cergy
UNION
SELECT * FROM materiel_maintenance_pau@link_pau;

-- Technicien Global
CREATE OR REPLACE VIEW technicien_global AS
SELECT * FROM technicien_cergy
UNION
SELECT * FROM technicien_pau@link_pau;

-- Intervention (verticale)
CREATE OR REPLACE VIEW intervention_header_global AS
SELECT * FROM intervention_header
UNION
SELECT * FROM intervention_header@link_pau;

CREATE OR REPLACE VIEW intervention_detail_global AS
SELECT * FROM intervention_detail
UNION
SELECT * FROM intervention_detail@link_pau;
