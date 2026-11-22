-- 1. Patient visit history
SELECT p.patient_id,p.first_name,p.last_name,e.encounter_id,e.scheduled_at,u.username FROM dermcare_patient_db.patient p JOIN dermcare_clinical_db.encounter e USING(patient_id) JOIN dermcare_user_db.app_user u USING(user_id) WHERE p.patient_id=1 ORDER BY e.scheduled_at;

-- 2. Lesion measurements over time
SELECT l.lesion_id,l.patient_id,e.scheduled_at,o.diameter_mm,o.diameter_mm-LAG(o.diameter_mm) OVER(PARTITION BY l.lesion_id ORDER BY o.observed_at,o.observation_id) AS change_mm FROM dermcare_clinical_db.skin_lesion l JOIN dermcare_clinical_db.observation o USING(lesion_id) JOIN dermcare_clinical_db.encounter e USING(encounter_id) ORDER BY l.lesion_id,o.observed_at;

-- 3. High risk assessments
SELECT p.patient_id,p.first_name,a.assessment_text,a.risk_level FROM dermcare_patient_db.patient p JOIN dermcare_clinical_db.encounter e USING(patient_id) JOIN dermcare_clinical_db.clinical_assessment a USING(encounter_id) WHERE a.risk_level='high';

-- 4. Requests including pending results
SELECT e.patient_id,r.request_id,r.request_type,r.request_status,s.result_summary FROM dermcare_clinical_db.encounter e JOIN dermcare_clinical_db.diagnostic_request r USING(encounter_id) LEFT JOIN dermcare_clinical_db.diagnostic_result s USING(request_id);

-- 5. Planned follow-ups and treatments
SELECT p.patient_id,p.first_name,f.planned_date,t.plan_text FROM dermcare_patient_db.patient p JOIN dermcare_clinical_db.encounter e USING(patient_id) JOIN dermcare_clinical_db.follow_up f USING(encounter_id) LEFT JOIN dermcare_clinical_db.treatment_plan t USING(encounter_id) WHERE f.follow_up_status='planned' AND f.planned_date >= '2026-11-13' ORDER BY f.planned_date;