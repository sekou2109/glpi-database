SHOW CON_NAME;
ALTER SESSION SET CONTAINER = XEPDB1;
DROP SEQUENCE seq_utilisateur_cergy;
create sequence seq_utilisateur_cergy start with 1 increment by 1;

DECLARE
   v_nom    VARCHAR2(50);
   v_prenom VARCHAR2(50);
   v_email  VARCHAR2(100);
   v_role   VARCHAR2(30);
BEGIN
   FOR num IN 1..45 LOOP
      v_nom := dbms_random.string('U', TRUNC(dbms_random.value(5, 10)));
      v_prenom := dbms_random.string('U', TRUNC(dbms_random.value(5, 10)));
      v_email := LOWER(v_nom || '.' || v_prenom || '@cy-tech.fr');

      IF num <= 2 THEN
         v_role := 'Admin';
      ELSIF num <= 8 THEN
         v_role := 'Professeur';
      ELSIF num <= 20 THEN
         v_role := 'Personnel_Administratif';
      ELSE
         v_role := 'Etudiant';
      END IF;

      INSERT INTO utilisateur (
         id_utilisateur,
         nom,
         prenom,
         email,
         role,
         id_site
      ) VALUES (
         seq_utilisateur_cergy.nextval,
         v_nom,
         v_prenom,
         v_email,
         v_role,
         1
      );
   END LOOP;

   COMMIT;
END;
/

-- Materiel

create sequence seq_materiel_cergy start with 1 increment by 1;

declare
   v_type_materiel varchar2(50);
   v_modele        varchar2(50);
   v_etat          varchar2(20);
   v_adresse_ip    varchar2(15);
   v_quantite      number;
   v_prob          number;
begin
   -- PC portables pour chaque utilisateur de Cergy
   for user_info in (
      select id_utilisateur
        from utilisateur
       where id_site = 1
   ) loop
      v_type_materiel := 'PC_Portable';
      v_modele := 'Laptop-'
                  || dbms_random.string(
         'U',
         5
      );
      v_prob := dbms_random.value(
         0,
         1
      );
      v_etat :=
         case
            when v_prob < 0.2 then
               'En panne'
            else 'Disponible'
         end;
      v_adresse_ip := '192.168.1.' || seq_materiel_cergy.nextval;
      v_quantite := 1;
      insert into materiel (
         id_materiel,
         type_materiel,
         modele,
         etat,
         adresse_ip,
         quantite,
         id_site
      ) values ( seq_materiel_cergy.nextval,
                 v_type_materiel,
                 v_modele,
                 v_etat,
                 v_adresse_ip,
                 v_quantite,
                 1 );
   end loop;

   -- Imprimantes (5 pour Cergy)
   for i in 1..5 loop
      v_type_materiel := 'Imprimante';
      v_modele := 'Printer-'
                  || dbms_random.string(
         'U',
         5
      );
      v_etat :=
         case
            when dbms_random.value(
               0,
               1
            ) < 0.2 then
               'En panne'
            else 'Disponible'
         end;
      v_quantite := 1;
      insert into materiel (
         id_materiel,
         type_materiel,
         modele,
         etat,
         adresse_ip,
         quantite,
         id_site
      ) values ( seq_materiel_cergy.nextval,
                 v_type_materiel,
                 v_modele,
                 v_etat,
                 null,
                 v_quantite,
                 1 );
   end loop;

   -- Ordinateurs de bureau (50 pour Cergy)
   for i in 1..50 loop
      v_type_materiel := 'Ordinateur_Bureau';
      v_modele := 'Desktop-'
                  || dbms_random.string(
         'U',
         5
      );
      v_etat :=
         case
            when dbms_random.value(
               0,
               1
            ) < 0.2 then
               'En panne'
            else 'Disponible'
         end;
      v_adresse_ip := '192.168.2.' || seq_materiel_cergy.nextval;
      v_quantite := 1;
      insert into materiel (
         id_materiel,
         type_materiel,
         modele,
         etat,
         adresse_ip,
         quantite,
         id_site
      ) values ( seq_materiel_cergy.nextval,
                 v_type_materiel,
                 v_modele,
                 v_etat,
                 v_adresse_ip,
                 v_quantite,
                 1 );
   end loop;

   -- Machines à café (5 pour Cergy)
   for i in 1..5 loop
      v_type_materiel := 'Machine_Cafe';
      v_modele := 'Expresso-'
                  || dbms_random.string(
         'U',
         5
      );
      v_etat :=
         case
            when dbms_random.value(
               0,
               1
            ) < 0.2 then
               'En panne'
            else 'Disponible'
         end;
      v_quantite := 1;
      insert into materiel (
         id_materiel,
         type_materiel,
         modele,
         etat,
         adresse_ip,
         quantite,
         id_site
      ) values ( seq_materiel_cergy.nextval,
                 v_type_materiel,
                 v_modele,
                 v_etat,
                 null,
                 v_quantite,
                 1 );
   end loop;

   commit;
end;
/


-- Insertion du site Cergy
insert into site values ( 1,
                          'Cergy' );

-- Séquence locale pour les techniciens de Cergy
create sequence seq_technicien_cergy start with 1 increment by 1;

declare
   v_nom                 varchar2(10);
   v_prenom              varchar2(10);
   v_entreprise          varchar2(10);
   v_competences         varchar2(50);
   v_heure_debut_service varchar2(10) := '9:00';
   v_heure_fin_service   varchar2(10) := '17:00';
   v_random              number;
begin
   for i in 1..5 loop
      v_nom := dbms_random.string(
         'U',
         8
      );
      v_prenom := dbms_random.string(
         'U',
         10
      );
      v_entreprise := dbms_random.string(
         'U',
         5
      );
      v_random := round(dbms_random.value(
         1,
         5
      ));
      v_competences :=
         case v_random
            when 1 then
               'Reseau'
            when 2 then
               'Securite'
            when 3 then
               'Materiel et depannage'
            when 4 then
               'Machines a cafe'
            when 5 then
               'Assistence utilisateur'
         end;

      insert into technicien (
         id_technicien,
         nom,
         prenom,
         entreprise,
         competences,
         heure_debut_service,
         heure_fin_service,
         id_site
      ) values ( seq_technicien_cergy.nextval,
                 v_nom,
                 v_prenom,
                 v_entreprise,
                 v_competences,
                 v_heure_debut_service,
                 v_heure_fin_service,
                 1 );
   end loop;

   commit;
end;
/

-- Utilisation de matériel par les utilisateurs de Cergy

insert into utilisation_materiel (
   id_utilisateur,
   id_materiel,
   date_utilisation
) values ( 98,
           78,
           sysdate );

insert into utilisation_materiel (
   id_utilisateur,
   id_materiel,
   date_utilisation
) values ( 99,
           80,
           sysdate - 5 );

-- L'utilisateur 3 utilise le PC 3 depuis une semaine
insert into utilisation_materiel (
   id_utilisateur,
   id_materiel,
   date_utilisation
) values ( 100,
           82,
           sysdate - 7 );

insert into utilisation_materiel (
   id_utilisateur,
   id_materiel,
   date_utilisation
) values ( 6,
           2,
           sysdate );
insert into utilisation_materiel (
   id_utilisateur,
   id_materiel,
   date_utilisation
) values (7,
           4,
           sysdate );


commit;