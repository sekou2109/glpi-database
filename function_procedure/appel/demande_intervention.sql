-- A exécuter dans Oracle pour créer une demande d'intervention
-- 1) Executer ce code
-- 2) L'id de l'intervention créée sera affichée dans la console
-- 3) Mettre à jour l'intervention avec le statut 'En_cours' ou 'Resolu' avec la procédure mettre_a_jour_intervention
DECLARE v_id_intervention NUMBER;
BEGIN
    v_id_intervention := demande_intervention; -- Prend un matériel en panne au hasard
    --v_id_intervention := demande_intervention(id_materiel); -- Prend un materiel spécifique
    DBMS_OUTPUT.PUT_LINE('Intervention créée avec ID : ' || v_id_intervention);
END;
/
COMMIT;