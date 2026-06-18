-- Trigger 1
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






