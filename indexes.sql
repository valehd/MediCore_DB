CREATE INDEX idx_admission_patient ON admission(patient_id);
CREATE INDEX idx_admission_bed ON admission(bed_id);
CREATE INDEX idx_bed_department ON bed(department_id);