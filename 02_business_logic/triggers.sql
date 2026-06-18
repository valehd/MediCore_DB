-- Trigger: trg_bed_status_change
-- Purpose: Audits every change in bed status to maintain historical traceability
-- This ensures all modifications to critical hospital resources are recorded

DELIMITER $$
CREATE TRIGGER trg_bed_status_change
AFTER UPDATE ON bed
FOR EACH ROW
BEGIN
    IF OLD.status <> NEW.status THEN
        INSERT INTO bed_audit_log (
            bed_id,
            old_status,
            new_status,
            changed_at
        )
        VALUES (
            OLD.bed_id,
            OLD.status,
            NEW.status,
            NOW()
        );
    END IF;
END $$

DELIMITER ;



ALTER TABLE patient ADD COLUMN is_active TINYINT(1) DEFAULT 1;



DELIMITER $$

-- Trigger: trg_prevent_patient_delete
-- Purpose: Enforces soft-delete compliance by blocking physical DELETE operations on patients
CREATE TRIGGER trg_prevent_patient_delete
BEFORE DELETE ON patient
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Physical deletion is prohibited by hospital compliance policy. Update is_active to 0 instead.';
END $$

DELIMITER ;