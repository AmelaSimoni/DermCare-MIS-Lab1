SELECT
    p.first_name,
    p.last_name,
    e.encounter_id,
    e.encounter_status
FROM dermcare_patient_db.patient AS p
JOIN dermcare_clinical_db.encounter AS e
    ON p.patient_id = e.patient_id;