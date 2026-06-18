

CREATE VIEW vw_current_admissions AS
SELECT
    a.admission_id,
    p.patient_id,
    p.first_name,
    p.last_name,
    p.birth_date,
    b.bed_number,
    d.department_name,
    a.admission_date,
    a.diagnosis
FROM admission a
JOIN patient p ON a.patient_id = p.patient_id
JOIN bed b ON a.bed_id = b.bed_id
JOIN department d ON b.department_id = d.department_id
WHERE a.discharge_date IS NULL;


CREATE VIEW vw_bed_occupancy AS
SELECT
    d.department_name,
    COUNT(b.bed_id) AS total_beds,
    SUM(CASE WHEN b.status = 'Occupied' THEN 1 ELSE 0 END) AS occupied_beds,
    SUM(CASE WHEN b.status = 'Available' THEN 1 ELSE 0 END) AS available_beds,
    ROUND(
        (SUM(CASE WHEN b.status = 'Occupied' THEN 1 ELSE 0 END) / COUNT(b.bed_id)) * 100,
        2
    ) AS occupancy_rate
FROM department d
JOIN bed b ON d.department_id = b.department_id
GROUP BY d.department_name;


CREATE VIEW vw_admission_details AS
SELECT
    a.admission_id,
    p.first_name,
    p.last_name,
    b.bed_number,
    d.department_name,
    a.admission_date,
    a.discharge_date,
    CASE 
    WHEN a.discharge_date IS NULL THEN 'Active'
    ELSE 'Closed'
END AS admission_status
FROM admission a
JOIN patient p ON a.patient_id = p.patient_id
JOIN bed b ON a.bed_id = b.bed_id
JOIN department d ON b.department_id = d.department_id;


CREATE VIEW vw_patient_summary AS
SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    COUNT(a.admission_id) AS total_admissions,
    MAX(a.admission_date) AS last_admission_date,
    MIN(a.admission_date) AS first_admission_date,
    COALESCE(
        ROUND(AVG(DATEDIFF(COALESCE(a.discharge_date, NOW()), a.admission_date)), 2),
        0
    ) AS avg_stay_days
FROM patient p
LEFT JOIN admission a ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name;