-- Insertion de données dans la table utilisateur
create sequence seq_utilisateur start with 1 increment by 1;

declare
   v_nom     varchar2(50);
   v_prenom  varchar2(50);
   v_email   varchar2(100);
   v_role    varchar2(20);
   v_id_site number;
   num       number := 1;
begin
   for num in 1..89 loop
      v_nom := dbms_random.string(
         'U',
         dbms_random.value(
            5,
            10
         )
      );
      v_prenom := dbms_random.string(
         'U',
         dbms_random.value(
            5,
            10
         )
      );
      v_email := lower(v_nom
                       || '.'
                       || v_prenom
                       || '@cy-tech.fr');
      if num <= 4 then
         v_role := 'Admin';
      elsif num <= 15 then
         v_role := 'Professeur';
      elsif num <= 39 then
         v_role := 'Personnel_Administratif';
      else
         v_role := 'Etudiant';
      end if;
	
		-- 1 = Cergy et 2 == Pau
      v_id_site := floor(dbms_random.value(
         1,
         3
      ));
      insert into utilisateur (
         id_utilisateur,
         nom,
         prenom,
         email,
         role,
         id_site
      ) values ( seq_utilisateur.nextval,
                 v_nom,
                 v_prenom,
                 v_email,
                 v_role,
                 v_id_site );

   end loop;

   commit;
end;
/

-- Insertion de données dans la table materiel

create sequence seq_materiel start with 1 increment by 1;

declare
   v_type_materiel  varchar2(50);
   v_modele         varchar2(50);
   v_etat           varchar2(20);
   v_adresse_ip     varchar2(15);
   v_quantite       number;
   v_id_site        number;
   v_id_utilisateur number;
   v_prob           number; --Probabilité pour ETAT

begin

	--Assignation d'un PC portable à chaque utilisateur
   for user_info in (
      select id_utilisateur,
             id_site
        from utilisateur
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
      ); -- Génération d'un nombre entre 0 et 1
      v_etat :=
         case
            when v_prob < 0.2 then
               'En_panne'
            else 'Disponible'
         end;
      v_adresse_ip := '192.168.1.' || seq_materiel.nextval;
      v_quantite := 1;
      v_id_site := user_info.id_site;
      v_id_utilisateur := user_info.id_utilisateur;
      insert into materiel (
         id_materiel,
         type_materiel,
         modele,
         etat,
         adresse_ip,
         quantite,
         id_site
      ) values ( seq_materiel.nextval,
                 v_type_materiel,
                 v_modele,
                 v_etat,
                 v_adresse_ip,
                 v_quantite,
                 v_id_site );
   end loop;
	
	-- Imprimantes
   for i in 1..10 loop
      v_type_materiel := 'Imprimante';
      v_modele := 'Printer-'
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
               'En_panne'
            else 'Disponible'
         end;
      v_adresse_ip := null;
      v_quantite := 1;
      v_id_site := floor(dbms_random.value(
         1,
         3
      ));
      insert into materiel (
         id_materiel,
         type_materiel,
         modele,
         etat,
         adresse_ip,
         quantite,
         id_site
      ) values ( seq_materiel.nextval,
                 v_type_materiel,
                 v_modele,
                 v_etat,
                 v_adresse_ip,
                 v_quantite,
                 v_id_site );
   end loop;
	
	-- Ordinateur de bureau
   for i in 1..100 loop
      v_type_materiel := 'Ordinateur_Bureau';
      v_modele := 'Desktop-'
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
               'En_panne'
            else 'Disponible'
         end;
      v_adresse_ip := '192.168.2.' || seq_materiel.nextval;
      v_quantite := 1;
      v_id_site := floor(dbms_random.value(
         1,
         3
      ));
      insert into materiel (
         id_materiel,
         type_materiel,
         modele,
         etat,
         adresse_ip,
         quantite,
         id_site
      ) values ( seq_materiel.nextval,
                 v_type_materiel,
                 v_modele,
                 v_etat,
                 v_adresse_ip,
                 v_quantite,
                 v_id_site );
   end loop;
	
	-- Machine à café
	
		-- Imprimantes
   for i in 1..10 loop
      v_type_materiel := 'Machine_Cafe';
      v_modele := 'Expresso-'
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
               'En_panne'
            else 'Disponible'
         end;
      v_adresse_ip := null;
      v_quantite := 1;
      v_id_site := floor(dbms_random.value(
         1,
         3
      ));
      insert into materiel (
         id_materiel,
         type_materiel,
         modele,
         etat,
         adresse_ip,
         quantite,
         id_site
      ) values ( seq_materiel.nextval,
                 v_type_materiel,
                 v_modele,
                 v_etat,
                 v_adresse_ip,
                 v_quantite,
                 v_id_site );
   end loop;

   commit;
end;
/


-- Insertion de données dans la table site

insert into site values ( 1,
                          'Cergy' );
insert into site values ( 2,
                          'Pau' );

commit;


-- Insertion de données dans la table technicien

create sequence seq_technicien start with 1 increment by 1;

declare
   v_nom                 varchar2(10);
   v_prenom              varchar2(10);
   v_entreprise          varchar2(10);
   v_competences         varchar2(50);
   v_heure_debut_service varchar2(10);
   v_heure_fin_service   varchar2(10);
   v_id_site             number;
   v_random              number;
begin
	-- Techniciens de Pau
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
      v_heure_debut_service := '9:00';
      v_heure_fin_service := '17:00';
      v_id_site := 2;
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
      ) values ( seq_technicien.nextval,
                 v_nom,
                 v_prenom,
                 v_entreprise,
                 v_competences,
                 v_heure_debut_service,
                 v_heure_fin_service,
                 v_id_site );
   end loop;

		-- Techniciens de Cergy
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
      v_heure_debut_service := '9:00';
      v_heure_fin_service := '17:00';
      v_id_site := 1;
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
      ) values ( seq_technicien.nextval,
                 v_nom,
                 v_prenom,
                 v_entreprise,
                 v_competences,
                 v_heure_debut_service,
                 v_heure_fin_service,
                 v_id_site );
   end loop;

   commit;
end;
/

-- Insertion de données dans la table utilisation_materiel


insert into utilisation_materiel (
   id_utilisateur,
   id_materiel,
   date_utilisation
) values ( 1,
           1,
           sysdate );


insert into utilisation_materiel (
   id_utilisateur,
   id_materiel,
   date_utilisation
) values ( 2,
           2,
           sysdate - 5 );

-- L'utilisateur 3 utilise le PC 3 depuis une semaine
insert into utilisation_materiel (
   id_utilisateur,
   id_materiel,
   date_utilisation
) values ( 3,
           3,
           sysdate - 7 );


insert into utilisation_materiel (
   id_utilisateur,
   id_materiel,
   date_utilisation
) values ( 4,
           4,
           sysdate - 3 );

insert into utilisation_materiel (
   id_utilisateur,
   id_materiel,
   date_utilisation
) values ( 5,
           5,
           sysdate );

commit;