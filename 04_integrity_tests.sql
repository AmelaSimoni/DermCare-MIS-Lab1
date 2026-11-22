-- Run each statement separately; each should fail. No valid data is changed.
-- 1 nonexistent patient
INSERT INTO dermcare_clinical_db.encounter(patient_id,user_id,scheduled_at,encounter_status) VALUES(999,1,NOW(),'planned');
-- 2 negative diameter
INSERT INTO dermcare_clinical_db.observation(encounter_id,lesion_id,user_id,diameter_mm,border_irregular,observed_at) VALUES(1,1,1,-1,0,NOW());
-- 3 mismatched patient
INSERT INTO dermcare_clinical_db.observation(encounter_id,lesion_id,user_id,diameter_mm,border_irregular,observed_at) VALUES(1,2,1,4,0,NOW());
-- 4 duplicate role assignment
INSERT INTO dermcare_user_db.user_role(user_id,role_id) VALUES(1,1);
-- 5 mismatched diagnostic request
INSERT INTO dermcare_clinical_db.diagnostic_request(encounter_id,lesion_id,user_id,request_type,request_status,requested_at) VALUES(1,2,1,'Biopsy','pending',NOW());
-- 6 invalid encounter chronology
UPDATE dermcare_clinical_db.encounter SET ended_at='2020-01-01' WHERE encounter_id=1;
