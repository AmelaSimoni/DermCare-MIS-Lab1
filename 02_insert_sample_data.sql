-- Fictional data only; password placeholders are not usable credentials.
START TRANSACTION;
INSERT INTO `dermcare_patient_db`.`patient` (patient_id,first_name,last_name,date_of_birth) VALUES
(1,'Alex','Demo','1985-04-12'),
(2,'Jamie','Example','1992-07-20');
INSERT INTO `dermcare_patient_db`.`address` (patient_id,street_name,city,country_code) VALUES
(1,'Example Street','Villach','AT');
INSERT INTO `dermcare_patient_db`.`emergency_contact` (patient_id,first_name,last_name,phone_number,relationship_to_patient) VALUES
(1,'Taylor','Demo','000000','Sibling');
INSERT INTO `dermcare_patient_db`.`allergy` (patient_id,allergen_name,recorded_on) VALUES
(1,'Penicillin','2026-10-01');
INSERT INTO `dermcare_user_db`.`app_user` (user_id,username,password_hash,first_name,last_name,is_active) VALUES
(1,'doctor_demo','DISABLED_DEMO_ACCOUNT','Morgan','Demo',0),
(2,'staff_demo','DISABLED_DEMO_ACCOUNT','Casey','Example',0);
INSERT INTO `dermcare_user_db`.`role` (role_id,role_name) VALUES
(1,'Dermatologist'),
(2,'Receptionist');
INSERT INTO `dermcare_user_db`.`permission` (permission_id,permission_code) VALUES
(1,'CLINICAL_READ'),
(2,'CLINICAL_WRITE');
INSERT INTO `dermcare_user_db`.`user_role` (user_id,role_id) VALUES
(1,1),
(2,2);
INSERT INTO `dermcare_user_db`.`role_permission` (role_id,permission_id) VALUES
(1,1),
(1,2),
(2,1);
INSERT INTO `dermcare_clinical_db`.`encounter` (encounter_id,patient_id,user_id,scheduled_at,started_at,ended_at,encounter_status) VALUES
(1,1,1,'2026-10-01 09:00','2026-10-01 09:00','2026-10-01 09:30','completed'),
(2,1,1,'2026-11-01 09:00','2026-11-01 09:00','2026-11-01 09:30','completed'),
(3,2,1,'2026-11-02 10:00','2026-11-02 10:00','2026-11-02 10:30','completed');
INSERT INTO `dermcare_clinical_db`.`skin_lesion` (lesion_id,patient_id,user_id,lesion_label,body_site,first_documented_at,lesion_status) VALUES
(1,1,1,'L1','Left arm','2026-10-01 09:10','active'),
(2,2,1,'L2','Back','2026-11-02 10:10','active');
INSERT INTO `dermcare_clinical_db`.`observation` (encounter_id,lesion_id,user_id,diameter_mm,color_description,border_irregular,observed_at) VALUES
(1,1,1,4.00,'brown',0,'2026-10-01 09:10'),
(2,1,1,6.00,'brown',1,'2026-11-01 09:10'),
(3,2,1,3.00,'pink',0,'2026-11-02 10:10');
INSERT INTO `dermcare_clinical_db`.`diagnostic_request` (request_id,encounter_id,lesion_id,user_id,request_type,request_status,requested_at) VALUES
(1,2,1,1,'Biopsy','completed','2026-11-01 09:20'),
(2,3,NULL,1,'Blood test','pending','2026-11-02 10:20');
INSERT INTO `dermcare_clinical_db`.`diagnostic_result` (request_id,user_id,source_name,result_summary,received_at,reviewed_at,result_status) VALUES
(1,1,'Demo lab','Benign findings','2026-11-05 09:00','2026-11-05 11:00','reviewed');
INSERT INTO `dermcare_clinical_db`.`clinical_assessment` (assessment_id,encounter_id,user_id,assessment_text,risk_level,assessed_at) VALUES
(1,2,1,'Change in lesion size','high','2026-11-01 09:15'),
(2,3,1,'Routine review','low','2026-11-02 10:15');
INSERT INTO `dermcare_clinical_db`.`diagnosis` (assessment_id,diagnosis_name,certainty) VALUES
(1,'Melanocytic nevus','suspected'),
(2,'Benign skin lesion','suspected');
INSERT INTO `dermcare_clinical_db`.`treatment_plan` (encounter_id,user_id,treatment_type,plan_text,plan_status) VALUES
(2,1,'Monitoring','Review lesion after lab result','active');
INSERT INTO `dermcare_clinical_db`.`follow_up` (encounter_id,planned_date,reason,follow_up_status) VALUES
(2,'2026-12-01','Review findings','planned');
INSERT INTO `dermcare_user_db`.`audit_event` (user_id,action_code,object_type,object_id,success,details) VALUES
(1,'CREATE','encounter',1,1,'Demo event');
COMMIT;
