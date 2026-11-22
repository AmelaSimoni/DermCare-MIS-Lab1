# DermCare MIS — Programming Lab I

## Clinical scenario
DermCare MIS is an educational database prototype for a fictional dermatology clinic. It stores patient information, clinical encounters, skin lesions and their measurements over time, diagnostic requests and results, assessments, diagnoses, treatment plans, follow-ups and staff access information. **No real patient data** is included.

## Database design
The project contains **three MySQL databases (schemas) on the same MySQL server**, with **19 tables** in total:

| Database | Tables |
| --- | --- |
| `dermcare_patient_db` | `patient`, `address`, `emergency_contact`, `allergy` (4) |
| `dermcare_user_db` | `app_user`, `role`, `permission`, `user_role`, `role_permission`, `audit_event` (6) |
| `dermcare_clinical_db` | `encounter`, `skin_lesion`, `observation`, `diagnostic_request`, `diagnostic_result`, `clinical_assessment`, `diagnosis`, `treatment_plan`, `follow_up` (9) |

**Patient vs encounter:** the `patient` table stores persistent demographic information; `encounter` stores an individual clinical visit. `skin_lesion` identifies a lesion belonging to a patient, while `observation` records a measurement of that lesion *during a particular encounter*. A lesion can therefore be observed in several encounters.

The databases are connected by cross-schema foreign keys on the same MySQL server. See `Design_Notes.md` for the relationship details and integrity rules. The ER diagrams are supplied as editable `.drawio` files; `Domain_Model.svg` is the conceptual overview.

## Files
- `Patient_ER.drawio`, `User_ER.drawio`, `Clinical_ER.drawio` — three editable ER diagrams (open with diagrams.net).
- `Domain_Model.svg` — conceptual/domain overview.
- `01_create_schema.sql` — three schemas, 19 tables, PK/FK/CHECK constraints and consistency triggers.
- `02_insert_sample_data.sql` — fictional sample records.
- `03_queries.sql` — five meaningful SELECT queries, including cross-schema JOIN, LEFT JOIN and lesion measurement trends.
- `04_integrity_tests.sql` — six **intentionally invalid** statements to demonstrate constraints. **Do not run as part of setup.**
- `Design_Notes.md` — detailed mapping and design decisions.

## Reproducing the database in MySQL Workbench
Use **MySQL 8.0.16 or later**, on a **fresh MySQL server or an environment without these three schemas**. The scripts are not intended to be run again over the existing database: they contain CREATE TABLE statements and fixed demonstration IDs.

1. Open `01_create_schema.sql` and execute it to create the three schemas, tables and triggers.
2. Open `02_insert_sample_data.sql` and execute it once to insert fictional data.
3. Open `03_queries.sql` and execute the five SELECT statements. They do not modify the database.
4. If desired, run statements from `04_integrity_tests.sql` **individually**, expecting errors. Do not run this file as a normal setup script.

## Example results
With the sample data, patient Alex Demo has two completed encounters, lesion L1 increases from 4.00 mm to 6.00 mm, one assessment has high risk, a blood-test request has no result yet, and one follow-up is marked planned. These five queries were also run successfully in MySQL Workbench during development. The actual database was inspected for all 19 tables; recreating the complete database from scratch on a separate machine has not yet been independently verified.

## Notes and limitations
This is a database-focused Lab I prototype, not a deployed medical application. The demonstration user records have intentionally disabled credentials. No production authentication or healthcare privacy compliance is claimed. **Three schemas in one MySQL instance are not the same as three independently running MySQL server instances.**
