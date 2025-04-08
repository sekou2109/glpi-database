--Mettre à jour intervention après le passage d'un technicien

create or replace procedure mettre_a_jour_intervention (
   p_id_intervention number,
   p_nouveau_statut  varchar2
) is
   v_id_materiel number;
begin
   if p_nouveau_statut not in ( 'En attente',
                                'En cours',
                                'Résolu' ) then
      raise_application_error(
         -20001,
         'Statut invalide. Utiliser : En attente, En cours, Résolu'
      );
   end if;

   select id_materiel
     into v_id_materiel
     from intervention
    where id_intervention = p_id_intervention;

	--Mise à jour de la table intervention
   update intervention
      set statut = p_nouveau_statut,
          date_debut =
             case
                when p_nouveau_statut = 'En cours' then
                   sysdate
                else
                   date_debut
             end,
          date_fin =
             case
                when p_nouveau_statut = 'Résolu' then
                   sysdate
                else
                   null
             end
    where id_intervention = p_id_intervention;

   if p_nouveau_statut = 'Résolu' then
      update materiel
         set
         etat = 'Disponible'
       where id_materiel = v_id_materiel;
   end if;

   commit;
end mettre_a_jour_intervention;
/