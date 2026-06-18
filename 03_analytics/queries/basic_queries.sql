-- QUERIES


-- BASIC OPERATIONAL QUERIES

-- Query 1: Current hospitalized patients (active admissions only)
-- Shows real-time patient occupancy in the hospital

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
WHERE a.discharge_date IS NULL
    AND p.is_active = 1;


-- Query 2: Bed occupancy metrics by department (operational KPI)
-- Calculates utilization rates per hospital department

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


-- Query 3: Average length of stay per department (clinical KPI)
-- Measures patient hospitalization duration trends

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

-- Query 4: Global hospital bed occupancy rate
-- High-level KPI for overall hospital utilization

SELECT
    ROUND(
        (SUM(CASE WHEN status = 'Occupied' THEN 1 ELSE 0 END) / COUNT(*)) * 100,
        2
    ) AS global_occupancy_rate
FROM bed;

-- Query 5: Current active patients with clinical context
-- Provides diagnostic visibility for active hospitalizations

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
WHERE a.discharge_date IS NULL
AND p.is_active = 1;