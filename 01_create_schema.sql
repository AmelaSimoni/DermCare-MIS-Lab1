-- MySQL 8.0.16+; run on a fresh server/schema set. No destructive DROP.

CREATE DATABASE IF NOT EXISTS `dermcare_patient_db` CHARACTER SET utf8mb4;

CREATE DATABASE IF NOT EXISTS `dermcare_user_db` CHARACTER SET utf8mb4;

CREATE DATABASE IF NOT EXISTS `dermcare_clinical_db` CHARACTER SET utf8mb4;

CREATE TABLE `dermcare_patient_db`.`patient` (
  patient_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(80) NOT NULL,
  last_name VARCHAR(80) NOT NULL,
  date_of_birth DATE NOT NULL,
  phone_number VARCHAR(32),
  email VARCHAR(254),
  preferred_language VARCHAR(8),
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE `dermcare_patient_db`.`address` (
  address_id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT NOT NULL,
  street_name VARCHAR(120) NOT NULL,
  house_number VARCHAR(15),
  postal_code VARCHAR(15),
  city VARCHAR(100) NOT NULL,
  country_code CHAR(2) NOT NULL,
  address_type VARCHAR(20),
  FOREIGN KEY (patient_id) REFERENCES `dermcare_patient_db`.`patient` (patient_id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE `dermcare_patient_db`.`emergency_contact` (
  contact_id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT NOT NULL,
  first_name VARCHAR(80) NOT NULL,
  last_name VARCHAR(80) NOT NULL,
  phone_number VARCHAR(32) NOT NULL,
  relationship_to_patient VARCHAR(40),
  is_primary TINYINT(1) NOT NULL DEFAULT 0,
  FOREIGN KEY (patient_id) REFERENCES `dermcare_patient_db`.`patient` (patient_id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE `dermcare_patient_db`.`allergy` (
  allergy_id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT NOT NULL,
  allergen_name VARCHAR(120) NOT NULL,
  allergen_category VARCHAR(30),
  reaction VARCHAR(180),
  severity VARCHAR(16),
  recorded_on DATE NOT NULL,
  FOREIGN KEY (patient_id) REFERENCES `dermcare_patient_db`.`patient` (patient_id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE `dermcare_user_db`.`app_user` (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(60) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  first_name VARCHAR(80) NOT NULL,
  last_name VARCHAR(80) NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE `dermcare_user_db`.`role` (
  role_id INT AUTO_INCREMENT PRIMARY KEY,
  role_name VARCHAR(40) NOT NULL UNIQUE,
  description VARCHAR(180)
) ENGINE=InnoDB;

CREATE TABLE `dermcare_user_db`.`permission` (
  permission_id INT AUTO_INCREMENT PRIMARY KEY,
  permission_code VARCHAR(70) NOT NULL UNIQUE,
  description VARCHAR(180)
) ENGINE=InnoDB;

CREATE TABLE `dermcare_user_db`.`user_role` (
  user_id INT NOT NULL,
  role_id INT NOT NULL,
  assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES `dermcare_user_db`.`app_user` (user_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  FOREIGN KEY (role_id) REFERENCES `dermcare_user_db`.`role` (role_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  PRIMARY KEY (user_id, role_id)
) ENGINE=InnoDB;

CREATE TABLE `dermcare_user_db`.`role_permission` (
  role_id INT NOT NULL,
  permission_id INT NOT NULL,
  FOREIGN KEY (role_id) REFERENCES `dermcare_user_db`.`role` (role_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  FOREIGN KEY (permission_id) REFERENCES `dermcare_user_db`.`permission` (permission_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  PRIMARY KEY (role_id, permission_id)
) ENGINE=InnoDB;

CREATE TABLE `dermcare_user_db`.`audit_event` (
  audit_event_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  action_code VARCHAR(60) NOT NULL,
  object_type VARCHAR(50) NOT NULL,
  object_id INT,
  success TINYINT(1) NOT NULL,
  occurred_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  details VARCHAR(250),
  FOREIGN KEY (user_id) REFERENCES `dermcare_user_db`.`app_user` (user_id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE `dermcare_clinical_db`.`encounter` (
  encounter_id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT NOT NULL,
  user_id INT NOT NULL,
  scheduled_at DATETIME NOT NULL,
  started_at DATETIME,
  ended_at DATETIME,
  reason_for_visit VARCHAR(250),
  encounter_status VARCHAR(20) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (patient_id) REFERENCES `dermcare_patient_db`.`patient` (patient_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  FOREIGN KEY (user_id) REFERENCES `dermcare_user_db`.`app_user` (user_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CHECK (ended_at IS NULL OR (started_at IS NOT NULL AND ended_at >= started_at))
) ENGINE=InnoDB;

CREATE TABLE `dermcare_clinical_db`.`skin_lesion` (
  lesion_id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT NOT NULL,
  user_id INT NOT NULL,
  lesion_label VARCHAR(70) NOT NULL,
  body_site VARCHAR(100) NOT NULL,
  laterality VARCHAR(20),
  first_documented_at DATETIME NOT NULL,
  lesion_status VARCHAR(20) NOT NULL,
  FOREIGN KEY (patient_id) REFERENCES `dermcare_patient_db`.`patient` (patient_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  FOREIGN KEY (user_id) REFERENCES `dermcare_user_db`.`app_user` (user_id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE `dermcare_clinical_db`.`observation` (
  observation_id INT AUTO_INCREMENT PRIMARY KEY,
  encounter_id INT NOT NULL,
  lesion_id INT NOT NULL,
  user_id INT NOT NULL,
  diameter_mm DECIMAL(5,2) NOT NULL,
  color_description VARCHAR(100),
  border_irregular TINYINT(1) NOT NULL,
  observed_at DATETIME NOT NULL,
  FOREIGN KEY (encounter_id) REFERENCES `dermcare_clinical_db`.`encounter` (encounter_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  FOREIGN KEY (lesion_id) REFERENCES `dermcare_clinical_db`.`skin_lesion` (lesion_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  FOREIGN KEY (user_id) REFERENCES `dermcare_user_db`.`app_user` (user_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CHECK (diameter_mm >= 0),
  CHECK (border_irregular IN (0,1))
) ENGINE=InnoDB;

CREATE TABLE `dermcare_clinical_db`.`diagnostic_request` (
  request_id INT AUTO_INCREMENT PRIMARY KEY,
  encounter_id INT NOT NULL,
  lesion_id INT,
  user_id INT NOT NULL,
  request_type VARCHAR(40) NOT NULL,
  clinical_question VARCHAR(250),
  request_status VARCHAR(20) NOT NULL,
  requested_at DATETIME NOT NULL,
  FOREIGN KEY (encounter_id) REFERENCES `dermcare_clinical_db`.`encounter` (encounter_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  FOREIGN KEY (lesion_id) REFERENCES `dermcare_clinical_db`.`skin_lesion` (lesion_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  FOREIGN KEY (user_id) REFERENCES `dermcare_user_db`.`app_user` (user_id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE `dermcare_clinical_db`.`diagnostic_result` (
  result_id INT AUTO_INCREMENT PRIMARY KEY,
  request_id INT NOT NULL,
  user_id INT,
  source_name VARCHAR(120) NOT NULL,
  result_summary TEXT NOT NULL,
  received_at DATETIME NOT NULL,
  reviewed_at DATETIME,
  result_status VARCHAR(20) NOT NULL,
  FOREIGN KEY (request_id) REFERENCES `dermcare_clinical_db`.`diagnostic_request` (request_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  FOREIGN KEY (user_id) REFERENCES `dermcare_user_db`.`app_user` (user_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CHECK ((reviewed_at IS NULL AND user_id IS NULL) OR (reviewed_at >= received_at AND user_id IS NOT NULL AND reviewed_at IS NOT NULL))
) ENGINE=InnoDB;

CREATE TABLE `dermcare_clinical_db`.`clinical_assessment` (
  assessment_id INT AUTO_INCREMENT PRIMARY KEY,
  encounter_id INT NOT NULL,
  user_id INT NOT NULL,
  assessment_text TEXT NOT NULL,
  risk_level VARCHAR(12) NOT NULL,
  assessed_at DATETIME NOT NULL,
  FOREIGN KEY (encounter_id) REFERENCES `dermcare_clinical_db`.`encounter` (encounter_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  FOREIGN KEY (user_id) REFERENCES `dermcare_user_db`.`app_user` (user_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CHECK (risk_level IN ('low','medium','high'))
) ENGINE=InnoDB;

CREATE TABLE `dermcare_clinical_db`.`diagnosis` (
  diagnosis_id INT AUTO_INCREMENT PRIMARY KEY,
  assessment_id INT NOT NULL,
  diagnosis_name VARCHAR(180) NOT NULL,
  diagnosis_code VARCHAR(30),
  certainty VARCHAR(15) NOT NULL,
  FOREIGN KEY (assessment_id) REFERENCES `dermcare_clinical_db`.`clinical_assessment` (assessment_id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE `dermcare_clinical_db`.`treatment_plan` (
  plan_id INT AUTO_INCREMENT PRIMARY KEY,
  encounter_id INT NOT NULL,
  user_id INT NOT NULL,
  treatment_type VARCHAR(30) NOT NULL,
  plan_text TEXT NOT NULL,
  plan_status VARCHAR(20) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (encounter_id) REFERENCES `dermcare_clinical_db`.`encounter` (encounter_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  FOREIGN KEY (user_id) REFERENCES `dermcare_user_db`.`app_user` (user_id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE `dermcare_clinical_db`.`follow_up` (
  follow_up_id INT AUTO_INCREMENT PRIMARY KEY,
  encounter_id INT NOT NULL,
  planned_date DATE NOT NULL,
  reason VARCHAR(250),
  follow_up_status VARCHAR(20) NOT NULL,
  FOREIGN KEY (encounter_id) REFERENCES `dermcare_clinical_db`.`encounter` (encounter_id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

USE dermcare_clinical_db;

DELIMITER $$

CREATE TRIGGER observation_check_insert BEFORE INSERT ON observation FOR EACH ROW
BEGIN
 IF NEW.lesion_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM encounter e JOIN skin_lesion l ON l.patient_id=e.patient_id WHERE e.encounter_id=NEW.encounter_id AND l.lesion_id=NEW.lesion_id) THEN
 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Encounter and lesion must belong to same patient';
 END IF;
END$$

CREATE TRIGGER observation_check_update BEFORE UPDATE ON observation FOR EACH ROW
BEGIN
 IF NEW.lesion_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM encounter e JOIN skin_lesion l ON l.patient_id=e.patient_id WHERE e.encounter_id=NEW.encounter_id AND l.lesion_id=NEW.lesion_id) THEN
 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Encounter and lesion must belong to same patient';
 END IF;
END$$

CREATE TRIGGER diagnostic_request_check_insert BEFORE INSERT ON diagnostic_request FOR EACH ROW
BEGIN
 IF NEW.lesion_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM encounter e JOIN skin_lesion l ON l.patient_id=e.patient_id WHERE e.encounter_id=NEW.encounter_id AND l.lesion_id=NEW.lesion_id) THEN
 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Encounter and lesion must belong to same patient';
 END IF;
END$$

CREATE TRIGGER diagnostic_request_check_update BEFORE UPDATE ON diagnostic_request FOR EACH ROW
BEGIN
 IF NEW.lesion_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM encounter e JOIN skin_lesion l ON l.patient_id=e.patient_id WHERE e.encounter_id=NEW.encounter_id AND l.lesion_id=NEW.lesion_id) THEN
 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Encounter and lesion must belong to same patient';
 END IF;
END$$

CREATE TRIGGER encounter_patient_immutable BEFORE UPDATE ON encounter FOR EACH ROW
BEGIN
 IF NEW.patient_id <> OLD.patient_id THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Patient ownership cannot be changed'; END IF;
END$$

CREATE TRIGGER skin_lesion_patient_immutable BEFORE UPDATE ON skin_lesion FOR EACH ROW
BEGIN
 IF NEW.patient_id <> OLD.patient_id THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Patient ownership cannot be changed'; END IF;
END$$

DELIMITER ;
