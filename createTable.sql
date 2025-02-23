CREATE TABLE UTILISATEUR (
    ID_UTILISATEUR NUMBER PRIMARY KEY,
    NOM VARCHAR2(50),
    EMAIL VARCHAR2(100) UNIQUE,
    ROLE VARCHAR2(20) CHECK (ROLE IN ('Admin', 'Professeur', 'Personnel Administratif', 'Étudiant')),
    ID_SITE NUMBER REFERENCES SITE(ID_SITE)
);

CREATE TABLE TECHNICIEN (
    ID_TECHNICIEN NUMBER PRIMARY KEY REFERENCES UTILISATEUR(ID_UTILISATEUR) ON DELETE CASCADE,
    COMPETENCES VARCHAR2(255), --réparation, réseau, configuration
    HEURE_DEBUT_SERVICE TIMESTAMP,
    HEURE_FIN_SERVICE TIMESTAMP
);

CREATE TABLE SITE (
    ID_SITE NUMBER PRIMARY KEY,
    NOM VARCHAR2(50) UNIQUE
);

CREATE TABLE MATERIEL (
    ID_MATERIEL NUMBER PRIMARY KEY,
    TYPE VARCHAR2(50),
    MARQUE VARCHAR2(50),
    MODELE VARCHAR2(50),
    ID_SITE NUMBER REFERENCES SITE(ID_SITE),
    ETAT VARCHAR2(20) CHECK (ETAT IN ('Disponible', 'En panne', 'Réparé'))
);

CREATE TABLE RESEAU (
    ID_RESEAU NUMBER PRIMARY KEY,
    ADRESSE_IP VARCHAR2(15) UNIQUE NOT NULL,
    ID_MATERIEL NUMBER REFERENCES MATERIEL(ID_MATERIEL)
);

CREATE TABLE INTERVENTION (
    ID_INTERVENTION NUMBER PRIMARY KEY,
    ID_MATERIEL NUMBER REFERENCES MATERIEL(ID_MATERIEL),
    ID_TECHNICIEN NUMBER REFERENCES TECHNICIEN(ID_TECHNICIEN),
    DATE_DEMANDE DATE DEFAULT SYSDATE,
    DATE_DEBUT DATE,  -- Date réelle de début d’intervention
    DATE_FIN DATE,  -- Date de fin si intervention terminée
    STATUT VARCHAR2(20) CHECK (STATUT IN ('En attente', 'En cours', 'Résolu'));
);


CREATE TABLE STOCK (
    ID_STOCK NUMBER PRIMARY KEY,
    ID_MATERIEL NUMBER REFERENCES MATERIEL(ID_MATERIEL),
    QUANTITE NUMBER CHECK (QUANTITE >= 0)
);

CREATE TABLE UTILISATION_MATERIEL (
    ID_UTILISATEUR NUMBER REFERENCES UTILISATEUR(ID_UTILISATEUR),
    ID_MATERIEL NUMBER REFERENCES MATERIEL(ID_MATERIEL),
    DATE_DEBUT DATE DEFAULT SYSDATE,
    DATE_FIN DATE,
    PRIMARY KEY (ID_UTILISATEUR, ID_MATERIEL, DATE_DEBUT) -- Empêche les doublons
);

--MLD
/*Utilisateur (idUtilisateur, nom, prenom, email, role, #idSite)  
Technicien (idTechnicien, competence, heure_debut_service, heure_fin_service)  
Site (idSite, nom)  
Materiel (idMateriel, type, marque, modele, #idSite, etat)  
Reseau (idReseau, adresse_ip, #idMateriel)  
Stock (idStock, #idMateriel, quantite)  
Intervention (idIntervention, #idMateriel, #idTechnicien, date_demande, date_debut, date_fin, statut)  
Utilisation_Materiel ( #idUtilisateur, #idMateriel, date_debut, date_fin)*/  
