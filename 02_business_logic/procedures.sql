--PROCEDURES

-- =========================================================
-- Procedure: sp_admit_patient
-- Purpose: Handles patient admission workflow
-- Business logic:
-- 1. Validates that the patient is active (Soft Delete Check)
-- 2. Finds an available bed in a department
-- 3. Creates an admission record
-- 4. Marks the bed as occupied
-- =========================================================


DELIMITER $$

CREATE PROCEDURE sp_admit_patient (
    IN p_patient_id INT,
    IN p_department_id INT,
    IN p_diagnosis VARCHAR(255)
)
BEGIN
    DECLARE v_bed_id INT;
    DECLARE v_is_active TINYINT(1) DEFAULT 0;

        -- Step 1: Validate that the patient exists and is active
    SELECT is_active 
    INTO v_is_active 
    FROM patient 
    WHERE patient_id = p_patient_id;

    IF v_is_active = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Admission failed: Patient is inactive or does not exist';
    END IF;

    -- Step 2: Find an available bed in the requested department
    SELECT bed_id
    INTO v_bed_id
    FROM bed
    WHERE department_id = p_department_id
      AND status = 'Available'
    LIMIT 1;

    -- Step 3: Validate bed availability
    IF v_bed_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No available beds in this department';
    END IF;

    -- Step 4: Create admission record
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

    -- Step 5: Update bed status
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