![MySQL](https://img.shields.io/badge/MySQL-8.0-blue)
![SQL](https://img.shields.io/badge/SQL-Advanced-green)
![Procedures](https://img.shields.io/badge/Stored%20Procedures-Yes-brightgreen)
![Triggers](https://img.shields.io/badge/Triggers-Yes-red)
![Views](https://img.shields.io/badge/Views-Yes-yellow)
![Status](https://img.shields.io/badge/Status-Completed-success)
# MediCore DB — Hospital Operations Database System

MediCore DB is a relational database system that models real-world hospital operations including patient admissions, bed allocation, and operational analytics.

The project goes beyond basic CRUD by implementing database-driven business logic, automation, and reporting using advanced SQL features.

🎯 Key Objectives

This project was built to simulate a real hospital data system where:

Patient admissions are automated
Bed allocation is dynamically managed
Operational integrity is enforced at database level
Historical and analytical reporting is available via SQL views

🧱 Core Data Model

The system is built around four main entities:

Department → Hospital units (ICU, Emergency, etc.)
Patient → Patient demographic information
Bed → Hospital resource management
Admission → Tracks patient hospitalization lifecycle

⚙️ Core Database Features

🔹 Stored Procedures (Business Logic Layer)
sp_admit_patient
Automatically assigns available beds
Creates admission records
Ensures controlled patient intake
sp_discharge_patient
Closes active admissions
Frees hospital beds
Maintains data consistency

🔹 Triggers (Data Integrity & Auditing)
trg_bed_status_change
Captures all bed status changes
Stores audit trail for traceability

🔹 Views (Analytics Layer)
vw_current_admissions → Active hospitalizations
vw_bed_occupancy → Department-level occupancy rates
vw_admission_history → Historical patient stays
vw_patient_summary → Patient-level aggregated metrics

📊 Business Impact

This system demonstrates how SQL can be used not only for storage, but for:

Automating operational workflows
Enforcing data consistency at database level
Providing real-time operational insights
Supporting healthcare resource optimization

🛠️ Tech Stack
MySQL
SQL (DDL, DML, Views, Stored Procedures, Triggers)
Data modeling & relational design
Optional Python scripts for data loading / ETL

📁 Project Structure
medicore-db/
│
├── schema.sql
├── indexes.sql
├── views.sql
├── procedures.sql
├── triggers.sql
├── queries.sql
├── audit_tables.sql
└── README.md
🚀 Example Usage
CALL sp_admit_patient(1, 1, 'Respiratory distress');
CALL sp_discharge_patient(1);

Key Technical Highlights
Database-driven business logic (no reliance on application layer)
Automated resource allocation using stored procedures
Auditability through triggers
Analytical layer via SQL views
Clean separation of schema, logic, and reporting layers

👩‍💻 Author
Valentina Hernandez
SQL & Data Engineering portfolio project focused on hospital systems, database design, and operational analytics.