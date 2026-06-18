-- Ranking patients by total number of admissions
-- Shows most frequent hospital users

SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    COUNT(a.admission_id) AS total_admissions,
    RANK() OVER (ORDER BY COUNT(a.admission_id) DESC) AS patient_rank
FROM patient p
LEFT JOIN admission a ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name;



-- Gets the most recent admission per patient
-- Useful for monitoring active clinical history

SELECT *
FROM (
    SELECT
        p.patient_id,
        p.first_name,
        p.last_name,
        a.admission_date,
        ROW_NUMBER() OVER (
            PARTITION BY p.patient_id
            ORDER BY a.admission_date DESC
        ) AS rn
    FROM patient p
    JOIN admission a ON p.patient_id = a.patient_id
) t
WHERE t.rn = 1;


-- Monthly admission trend with running total
-- Shows hospital activity over time

SELECT
    month,
    monthly_admissions,
    SUM(monthly_admissions) OVER (ORDER BY month) AS cumulative_admissions
FROM (
    SELECT
        DATE_FORMAT(admission_date, '%Y-%m') AS month,
        COUNT(*) AS monthly_admissions
    FROM admission
    GROUP BY DATE_FORMAT(admission_date, '%Y-%m')
) t
ORDER BY month;