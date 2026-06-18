-- QUERIES

-- ANALYTICAL QUERIES (REPORTING LAYER)

-- Query 1: Monthly admission trends (time-series analysis)
-- Shows hospital activity over time

SELECT
    DATE_FORMAT(admission_date, '%Y-%m') AS month,
    COUNT(*) AS total_admissions
FROM admission
GROUP BY DATE_FORMAT(admission_date, '%Y-%m')
ORDER BY month;


-- Query 2: Patients with highest number of admissions (utilization analysis)
-- Identifies frequent users of hospital services

SELECT
    p.first_name,
    p.last_name,
    COUNT(a.admission_id) AS total_admissions
FROM patient p
JOIN admission a ON p.patient_id = a.patient_id
GROUP BY p.patient_id
ORDER BY total_admissions DESC;


-- Query 3: Most used beds (resource utilization analysis)
-- Identifies high-demand hospital beds

SELECT
    b.bed_number,
    COUNT(a.admission_id) AS usage_count
FROM bed b
JOIN admission a ON b.bed_id = a.bed_id
GROUP BY b.bed_id
ORDER BY usage_count DESC;


-- Query 4: Department demand ranking
-- Measures total admissions per department

SELECT
    d.department_name,
    COUNT(a.admission_id) AS total_admissions
FROM department d
JOIN bed b ON d.department_id = b.department_id
JOIN admission a ON b.bed_id = a.bed_id
GROUP BY d.department_name
ORDER BY total_admissions DESC;


-- Query 5: Admission status distribution
-- Shows distribution of active vs closed admissions

SELECT
    status,
    COUNT(*) AS total
FROM admission
GROUP BY status;