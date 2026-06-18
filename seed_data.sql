INSERT INTO department (department_name, location) VALUES
('UCI Neonatal', 'Piso 3'),
('Maternidad', 'Piso 2'),
('Urgencia', 'Piso 1'),
('Pediatría', 'Piso 4');

INSERT INTO bed (bed_number, department_id, status) VALUES
('N-101', 1, 'Available'),
('N-102', 1, 'Occupied'),
('M-201', 2, 'Available'),
('M-202', 2, 'Maintenance'),
('U-301', 3, 'Occupied'),
('P-401', 4, 'Available');

INSERT INTO patient (first_name, last_name, birth_date, sex, national_id) VALUES
('Camila', 'Rojas', '1995-04-10', 'F', '12345678-9'),
('Diego', 'Muñoz', '1988-11-22', 'M', '98765432-1'),
('Fernanda', 'González', '2001-02-15', 'F', '11223344-5'),
('Javier', 'Silva', '1979-07-30', 'M', '55667788-0');

INSERT INTO admission (patient_id, bed_id, admission_date, discharge_date, diagnosis) VALUES
(1, 2, '2026-06-10 08:00:00', NULL, 'Premature birth monitoring'),
(2, 5, '2026-06-12 14:30:00', NULL, 'Post-surgery recovery'),
(3, 3, '2026-06-15 09:00:00', NULL, 'Observation'),
(4, 1, '2026-06-16 18:45:00', NULL, 'Respiratory infection');