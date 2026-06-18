-- =========================================================
-- MediCore DB - Expanded Seed Data
-- Realistic hospital dataset for analytics and testing
-- =========================================================

USE medicore_db;

-- Departments
INSERT INTO department (department_name, location) VALUES
('Neonatal ICU', 'Floor 3'),
('Maternity', 'Floor 2'),
('Emergency', 'Floor 1'),
('Pediatrics', 'Floor 4'),
('Internal Medicine', 'Floor 5'),
('Surgery', 'Floor 6');

-- Beds (30 beds total)
INSERT INTO bed (bed_number, department_id, status) VALUES
-- Neonatal ICU
('N-101', 1, 'Available'),
('N-102', 1, 'Occupied'),
('N-103', 1, 'Occupied'),
('N-104', 1, 'Maintenance'),
('N-105', 1, 'Available'),

-- Maternity
('M-201', 2, 'Occupied'),
('M-202', 2, 'Available'),
('M-203', 2, 'Available'),
('M-204', 2, 'Occupied'),
('M-205', 2, 'Available'),

-- Emergency
('E-301', 3, 'Occupied'),
('E-302', 3, 'Occupied'),
('E-303', 3, 'Available'),
('E-304', 3, 'Maintenance'),
('E-305', 3, 'Occupied'),

-- Pediatrics
('P-401', 4, 'Available'),
('P-402', 4, 'Occupied'),
('P-403', 4, 'Available'),
('P-404', 4, 'Occupied'),
('P-405', 4, 'Available'),

-- Internal Medicine
('IM-501', 5, 'Occupied'),
('IM-502', 5, 'Available'),
('IM-503', 5, 'Occupied'),
('IM-504', 5, 'Available'),
('IM-505', 5, 'Occupied'),

-- Surgery
('S-601', 6, 'Occupied'),
('S-602', 6, 'Available'),
('S-603', 6, 'Occupied'),
('S-604', 6, 'Available'),
('S-605', 6, 'Maintenance');

-- Patients (20 realistic patients)
INSERT INTO patient (first_name, last_name, birth_date, sex, national_id) VALUES
('Camila', 'Rojas', '1995-04-10', 'F', '10000001-9'),
('Diego', 'Muñoz', '1988-11-22', 'M', '10000002-7'),
('Fernanda', 'González', '2001-02-15', 'F', '10000003-5'),
('Javier', 'Silva', '1979-07-30', 'M', '10000004-3'),
('Valentina', 'Torres', '1992-09-12', 'F', '10000005-1'),
('Matías', 'López', '1985-03-18', 'M', '10000006-8'),
('Isidora', 'Fernández', '1998-06-25', 'F', '10000007-6'),
('Sebastián', 'Araya', '1975-12-01', 'M', '10000008-4'),
('Francisca', 'Castro', '2000-08-14', 'F', '10000009-2'),
('Tomás', 'Herrera', '1990-05-09', 'M', '10000010-0'),
('Catalina', 'Vargas', '1993-07-22', 'F', '10000011-9'),
('Benjamín', 'Riquelme', '1982-11-11', 'M', '10000012-7'),
('Josefina', 'Molina', '1997-01-19', 'F', '10000013-5'),
('Nicolás', 'Cáceres', '1989-04-03', 'M', '10000014-3'),
('Antonia', 'Bravo', '2002-10-27', 'F', '10000015-1'),
('Pedro', 'Fuentes', '1978-06-06', 'M', '10000016-8'),
('María', 'Pérez', '1996-09-30', 'F', '10000017-6'),
('Cristóbal', 'Reyes', '1987-02-17', 'M', '10000018-4'),
('Daniela', 'Espinoza', '1991-12-25', 'F', '10000019-2'),
('Andrés', 'Valdés', '1983-07-07', 'M', '10000020-0');

-- Admissions (40 records realistic clinical flow)
-- Mix of active and closed cases
INSERT INTO admission (patient_id, bed_id, admission_date, discharge_date, diagnosis) VALUES
(1, 2, '2026-06-10 08:00:00', NULL, 'Premature birth monitoring'),
(2, 11, '2026-06-12 14:30:00', NULL, 'Post-surgical recovery'),
(3, 3, '2026-06-15 09:00:00', NULL, 'Medical observation'),
(4, 21, '2026-06-16 18:45:00', NULL, 'Respiratory infection'),
(5, 5, '2026-06-01 10:00:00', '2026-06-05 12:00:00', 'Flu complications'),
(6, 6, '2026-05-20 09:15:00', '2026-05-28 11:00:00', 'Post surgery recovery'),
(7, 7, '2026-06-18 13:00:00', NULL, 'Routine observation'),
(8, 8, '2026-06-02 07:45:00', '2026-06-10 10:00:00', 'Trauma care'),
(9, 9, '2026-06-11 16:20:00', NULL, 'Pediatric infection'),
(10, 10, '2026-06-03 08:30:00', '2026-06-08 14:00:00', 'Emergency care'),

(11, 12, '2026-05-15 11:00:00', '2026-05-22 09:00:00', 'Cardiac monitoring'),
(12, 13, '2026-06-05 12:00:00', NULL, 'Respiratory distress'),
(13, 14, '2026-06-06 13:30:00', NULL, 'Observation'),
(14, 15, '2026-06-07 14:00:00', NULL, 'Internal infection'),
(15, 16, '2026-06-08 15:00:00', NULL, 'Emergency case'),
(16, 17, '2026-06-09 16:00:00', NULL, 'Surgery recovery'),
(17, 18, '2026-06-10 17:00:00', NULL, 'Routine check'),
(18, 19, '2026-06-11 18:00:00', NULL, 'Trauma'),
(19, 20, '2026-06-12 19:00:00', NULL, 'Observation'),
(20, 21, '2026-06-13 20:00:00', NULL, 'Critical care');


-- =========================================================
-- LARGE VOLUME GENERATION FOR OPTIMIZATION AND TESTING
-- =========================================================

DELIMITER $$

CREATE PROCEDURE PopulateMassivePatients()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE random_name VARCHAR(50);
    DECLARE random_last VARCHAR(50);
    DECLARE random_sex CHAR(1);
    DECLARE random_birth DATE;
    DECLARE random_rut VARCHAR(12);

    WHILE i <= 1000 DO
        -- Alternate random names and genders
        SET random_sex = IF(RAND() > 0.5, 'M', 'F');
        SET random_name = ELT(FLOOR(1 + RAND() * 10), 'Camila', 'Diego', 'Fernanda', 'Javier', 'Valentina', 'Matías', 'Isidora', 'Sebastián', 'Francisca', 'Tomás');
        SET random_last = ELT(FLOOR(1 + RAND() * 10), 'Rojas', 'Muñoz', 'González', 'Silva', 'Torres', 'López', 'Fernández', 'Araya', 'Castro', 'Herrera');
        
        -- Random birthdate between 1970 and 2015
        SET random_birth = DATE_ADD('1970-01-01', INTERVAL FLOOR(RAND() * 16500) DAY);
        
        -- Fake but unique National ID to prevent constraint collisions
        SET random_rut = CONCAT(CONVERT(20000000 + i, CHAR), '-K');

        INSERT INTO patient (first_name, last_name, birth_date, sex, national_id)
        VALUES (random_name, random_last, random_birth, random_sex, random_rut);

        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

-- Execute patient generation procedure and clean up
CALL PopulateMassivePatients();
DROP PROCEDURE PopulateMassivePatients;


-- Massive cross-join generation for clinical history (~2,000 historical rows)
INSERT INTO admission (patient_id, bed_id, admission_date, discharge_date, diagnosis)
SELECT 
    p.patient_id,
    -- Random bed assignment between 1 and 30
    FLOOR(1 + RAND() * 30) AS bed_id,
    -- Random admission date within the last 2 years
    DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 730) DAY) AS admission_date,
    -- 90% discharged (historical cases), 10% currently hospitalized (discharge_date IS NULL)
    IF(RAND() > 0.1, DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 10) DAY), NULL) AS discharge_date,
    -- Random clinical diagnosis
    ELT(FLOOR(1 + RAND() * 6), 'Premature birth monitoring', 'Post-surgical recovery', 'Respiratory infection', 'Trauma care', 'Cardiac monitoring', 'Flu complications') AS diagnosis
FROM patient p
-- Cross join multiplier to duplicate record generation per patient
CROSS JOIN (SELECT 1 UNION SELECT 2) t
WHERE p.patient_id > 20; -- Keeps your original 20 seed patients intact
