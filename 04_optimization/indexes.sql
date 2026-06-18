-- INDEXES

-- Index to optimize queries filtering or joining by patient in admission records
CREATE INDEX idx_admission_patient ON admission(patient_id);

-- Index to improve performance when querying admissions by bed assignment
CREATE INDEX idx_admission_bed ON admission(bed_id);

-- Index to speed up joins and aggregations between bed and department
CREATE INDEX idx_bed_department ON bed(department_id);