SELECT
    p.first_name AS patient_name,
    p.last_name AS patient_surname,
    a.admission_date,
    b.bed_number,
    d.department_name
FROM admission a
JOIN patient p ON a.patient_id = p.patient_id
JOIN bed b ON a.bed_id = b.bed_id
JOIN department d ON b.department_id = d.department_id
WHERE a.discharge_date IS NULL;



SELECT
    d.department_name,
    SUM(CASE WHEN b.status = 'Occupied' THEN 1 ELSE 0 END) AS occupied_beds,
    SUM(CASE WHEN b.status = 'Available' THEN 1 ELSE 0 END) AS available_beds,
    COUNT(*) AS total_beds,
    ROUND(
        (SUM(CASE WHEN b.status = 'Occupied' THEN 1 ELSE 0 END) / COUNT(*)) * 100,
        2
    ) AS occupancy_rate
FROM department d
JOIN bed b ON d.department_id = b.department_id
GROUP BY d.department_name;




SELECT
    d.department_name,
    ROUND(AVG(DATEDIFF(
        COALESCE(a.discharge_date, NOW()),
        a.admission_date
    )), 2) AS avg_length_of_stay_days
FROM admission a
JOIN bed b ON a.bed_id = b.bed_id
JOIN department d ON b.department_id = d.department_id
GROUP BY d.department_name;



SELECT
    DATE_FORMAT(admission_date, '%Y-%m') AS month,
    COUNT(*) AS total_admissions
FROM admission
GROUP BY DATE_FORMAT(admission_date, '%Y-%m')
ORDER BY month;



SELECT
    p.first_name,
    p.last_name,
    COUNT(a.admission_id) AS total_admissions
FROM patient p
JOIN admission a ON p.patient_id = a.patient_id
GROUP BY p.patient_id
ORDER BY total_admissions DESC;



SELECT
    b.bed_number,
    COUNT(a.admission_id) AS usage_count
FROM bed b
JOIN admission a ON b.bed_id = a.bed_id
GROUP BY b.bed_id
ORDER BY usage_count DESC;


SELECT
    d.department_name,
    COUNT(a.admission_id) AS total_admissions
FROM department d
JOIN bed b ON d.department_id = b.department_id
JOIN admission a ON b.bed_id = a.bed_id
GROUP BY d.department_name
ORDER BY total_admissions DESC;


SELECT
    p.first_name,
    p.last_name,
    a.diagnosis,
    a.admission_date,
    d.department_name
FROM admission a
JOIN patient p ON a.patient_id = p.patient_id
JOIN bed b ON a.bed_id = b.bed_id
JOIN department d ON b.department_id = d.department_id
WHERE a.discharge_date IS NULL;



SELECT
    ROUND(
        (SUM(CASE WHEN status = 'Occupied' THEN 1 ELSE 0 END) / COUNT(*)) * 100,
        2
    ) AS global_occupancy_rate
FROM bed;


SELECT
    status,
    COUNT(*) AS total
FROM admission
GROUP BY status;