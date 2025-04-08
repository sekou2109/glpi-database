-- Insertion dans la table intervention
DROP SEQUENCE seq_intervention;
create sequence seq_intervention start with 1 increment by 1;

-- filepath: h:\Documents\ing2\semestre2\TraitementData\projet_dossier\glpi-database\function_procedure\code\code_demande_intervention.sql
CREATE OR REPLACE FUNCTION demande_intervention (
   p_id_materiel NUMBER DEFAULT NULL
) RETURN NUMBER IS
   v_id_materiel   NUMBER;
   v_id_technicien NUMBER;
   v_new_id        NUMBER;
   v_count         NUMBER;
BEGIN
   -- Gestion exception : aucun matériel en panne
   SELECT COUNT(*)
     INTO v_count
     FROM materiel
    WHERE etat = 'En panne';
   IF v_count = 0 THEN
      RAISE_APPLICATION_ERROR(
         -20002,
         'Aucun matériel en panne !'
      );
   END IF;

   -- Choisir le matériel en panne
   IF p_id_materiel IS NOT NULL THEN
      SELECT COUNT(*)
        INTO v_count
        FROM materiel
       WHERE id_materiel = p_id_materiel
         AND etat = 'En panne';
      IF v_count = 0 THEN
         RAISE_APPLICATION_ERROR(
            -20003,
            'Le matériel sélectionné n''est pas en panne.'
         );
      END IF;
      v_id_materiel := p_id_materiel;
   ELSE
      SELECT id_materiel
        INTO v_id_materiel
        FROM materiel
       WHERE etat = 'En panne'
       ORDER BY dbms_random.value
       FETCH FIRST 1 ROW ONLY;
   END IF;

   -- Sélection d'un technicien au hasard
   SELECT id_technicien
     INTO v_id_technicien
     FROM technicien
    ORDER BY dbms_random.value
    FETCH FIRST 1 ROW ONLY;

   -- Insertion dans la table intervention
   INSERT INTO intervention (
      id_intervention,
      id_materiel,
      id_technicien,
      date_demande,
      statut,
      description
   ) VALUES (
      seq_intervention.nextval,
      v_id_materiel,
      v_id_technicien,
      SYSDATE,
      'En attente',
      'Diagnostic_en_cours'
   );

   -- Retourner l'ID de l'intervention créée
   SELECT seq_intervention.currval
     INTO v_new_id
     FROM dual;

   RETURN v_new_id;
END demande_intervention;
/