-- Insertion dans la table intervention

create sequence seq_intervention start with 1 increment by 1;

-- Fonction d'ajout d'une intervention (Demande d'intervention)

create or replace function demande_intervention (
   p_id_materiel number default null
) return number is
   v_id_materiel   number;
   v_id_technicien number;
   v_new_id        number;
   v_count         number;
begin
	-- Gestion exception : aucun materiel en panne
   select count(*)
     into v_count
     from materiel
    where etat = 'En_panne';
   if v_count = 0 then
      raise_application_error(
         -20002,
         'Aucun materiel en panne !'
      );
   end if;

	-- Choisir le materiel en panne
   if p_id_materiel is not null then
      select count(*)
        into v_count
        from materiel
       where id_materiel = p_id_materiel
         and etat = 'En_panne';
      if v_count = 0 then
         raise_application_error(
            -20003,
            'Le materiel selectionné n''est pas en panne.'
         );
      end if;
      v_id_materiel := p_id_materiel;
   else
      select id_materiel
        from materiel
       where etat = 'En_panne'
       order by dbms_random.value
       fetch first 1 row only;
   end if;

	-- Selection d'un technicien au hasard
   select id_technicien
     into v_id_technicien
     from technicien
    order by dbms_random.value
    fetch first 1 row only;

	-- insertion dans la table intervention
   insert into intervention (
      id_intervention,
      id_materiel,
      id_technicien,
      date_demande,
      statut,
      description_intervention
   ) values ( seq_intervention.nextval,
              v_id_materiel,
              v_id_technicien,
              sysdate,
              'En_attente',
              'Diagnostic_en_cours' );

	-- On retourne ici l'id de l'intervention créée
   select seq_intervention.currval
     into v_new_id
     from dual;

   return v_new_id;
end demande_intervention;
/