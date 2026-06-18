--PROCEDURES

-- =========================================================
-- Procedure: sp_admit_patient
-- Purpose: Handles patient admission workflow
-- Business logic:
-- 1. Finds an available bed in a department
-- 2. Creates an admission record
-- 3. Marks the bed as occupied
-- =========================================================


DELIMITER $$

CREATE PROCEDURE sp_admit_patient (
    IN p_patient_id INT,
    IN p_department_id INT,
    IN p_diagnosis VARCHAR(255)
)
BEGIN
    DECLARE v_bed_id INT;

    -- Step 1: Find an available bed in the requested department
    SELECT bed_id
    INTO v_bed_id
    FROM bed
    WHERE department_id = p_department_id
      AND status = 'Available'
    LIMIT 1;

    -- Step 2: Validate bed availability
    IF v_bed_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No available beds in this department';
    END IF;

    -- Step 3: Create admission record
    INSERT INTO admission (
        patient_id,
        bed_id,
        admission_date,
        diagnosis
    )
    VALUES (
        p_patient_id,
        v_bed_id,
        NOW(),
        p_diagnosis
    );

    -- Step 4: Update bed status
    UPDATE bed
    SET status = 'Occupied'
    WHERE bed_id = v_bed_id;

END $$

DELIMITER ;

-- Example usage:
-- CALL sp_admit_patient(1, 1, 'Respiratory distress');


-- =========================================================
-- Procedure: sp_discharge_patient
-- Purpose: Handles patient discharge workflow
-- Business logic:
-- 1. Validates active admission
-- 2. Closes admission record
-- 3. Frees assigned bed
-- =========================================================

DELIMITER $$

CREATE PROCEDURE sp_discharge_patient (
    IN p_admission_id INT
)
BEGIN
    DECLARE v_bed_id INT;
    DECLARE v_admission_date DATETIME;

    -- Step 1: Get active admission data
    SELECT bed_id, admission_date
    INTO v_bed_id, v_admission_date
    FROM admission
    WHERE admission_id = p_admission_id
      AND discharge_date IS NULL;

    -- Step 2: Validate admission exists and is active
    IF v_bed_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Admission not found or already closed';
    END IF;

    -- Step 3: Close admission
    UPDATE admission
    SET discharge_date = NOW()
    WHERE admission_id = p_admission_id;

    -- Step 4: Release bed
    UPDATE bed
    SET status = 'Available'
    WHERE bed_id = v_bed_id;

END $$

DELIMITER ;

-- Example usage:
-- CALL sp_discharge_patient(1);