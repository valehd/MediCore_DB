-- =========================================================
-- MediCore DB - Seed Data
-- Initial dataset for testing hospital operations system
-- =========================================================

USE medicore_db;

-- =========================================================
-- Departments (Hospital Units)
-- =========================================================
INSERT INTO department (department_name, location) VALUES
('Neonatal ICU', 'Floor 3'),
('Maternity', 'Floor 2'),
('Emergency', 'Floor 1'),
('Pediatrics', 'Floor 4');

-- =========================================================
-- Beds (Hospital Resources)
-- =========================================================
INSERT INTO bed (bed_number, department_id, status) VALUES
('N-101', 1, 'Available'),
('N-102', 1, 'Occupied'),
('M-201', 2, 'Available'),
('M-202', 2, 'Maintenance'),
('E-301', 3, 'Occupied'),
('P-401', 4, 'Available');

-- =========================================================
-- Patients (Demographic Data)
-- =========================================================
INSERT INTO patient (first_name, last_name, birth_date, sex, national_id) VALUES
('Camila', 'Rojas', '1995-04-10', 'F', '12345678-9'),
('Diego', 'Muñoz', '1988-11-22', 'M', '98765432-1'),
('Fernanda', 'González', '2001-02-15', 'F', '11223344-5'),
('Javier', 'Silva', '1979-07-30', 'M', '55667788-0');

-- =========================================================
-- Admissions (Hospitalization Records)
-- =========================================================
INSERT INTO admission (patient_id, bed_id, admission_date, discharge_date, diagnosis) VALUES
(1, 2, '2026-06-10 08:00:00', NULL, 'Premature birth monitoring'),
(2, 5, '2026-06-12 14:30:00', NULL, 'Post-surgical recovery'),
(3, 3, '2026-06-15 09:00:00', NULL, 'Medical observation'),
(4, 1, '2026-06-16 18:45:00', NULL, 'Respiratory infection');