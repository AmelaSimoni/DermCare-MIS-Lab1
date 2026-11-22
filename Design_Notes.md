# Database design

Patient-level data: demographics, addresses, emergency contacts, allergies and persistent skin lesions. Encounter-level data: measurements, assessments, diagnoses, diagnostic requests/results, treatment and follow-up. A lesion can be observed across multiple encounters.

The 19 tables are split into Patient (4), Clinical (9) and User (6). All clinical user_id fields reference app_user.user_id; their meaning depends on the table. Encounter stores the clinician only; creation activity may be logged in audit_event. Diagnostic result reviewer and diagnostic request lesion are optional. Audit object_id is polymorphic and not a foreign key. User-role and role-permission use composite primary keys. Roles and permissions are modeled, not enforced by an application.

Integrity: foreign keys restrict deletion and key updates, names and key clinical fields are required, usernames/role names/permission codes are unique, diameter and chronology are checked. Triggers reject observations or diagnostic requests linking different patients and prevent reassignment of encounter/lesion patient ownership. Addresses, contacts and allergies allow multiple rows per patient.

## Cross-schema references
- dermcare_clinical_db.encounter.patient_id → dermcare_patient_db.patient.patient_id
- dermcare_clinical_db.encounter.user_id → dermcare_user_db.app_user.user_id
- dermcare_clinical_db.skin_lesion.patient_id → dermcare_patient_db.patient.patient_id
- dermcare_clinical_db.skin_lesion.user_id → dermcare_user_db.app_user.user_id
- dermcare_clinical_db.observation.user_id → dermcare_user_db.app_user.user_id
- dermcare_clinical_db.diagnostic_request.user_id → dermcare_user_db.app_user.user_id
- dermcare_clinical_db.diagnostic_result.user_id → dermcare_user_db.app_user.user_id
- dermcare_clinical_db.clinical_assessment.user_id → dermcare_user_db.app_user.user_id
- dermcare_clinical_db.treatment_plan.user_id → dermcare_user_db.app_user.user_id

## Workflow
Register patient → schedule encounter → document lesion and observation → assess → request diagnostics → review results → diagnose → plan treatment → schedule follow-up.

## Scope
Educational prototype; no production authentication, privacy compliance or clinical decision support is claimed.
