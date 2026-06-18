-- Patient → Admission → Bed (Available → Occupied)

DELIMITER $$

CREATE PROCEDURE sp_admit_patient (
    IN p_patient_id INT,
    IN p_department_id INT,
    IN p_diagnosis VARCHAR(255)
)
BEGIN
    DECLARE v_bed_id INT;

    -- 1. Buscar cama disponible en el departamento
    SELECT bed_id
    INTO v_bed_id
    FROM bed
    WHERE department_id = p_department_id
      AND status = 'Available'
    LIMIT 1;

    -- 2. Si no hay camas disponibles, lanzar error
    IF v_bed_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No available beds in this department';
    END IF;

    -- 3. Crear hospitalización
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

    -- 4. Actualizar estado de la cama
    UPDATE bed
    SET status = 'Occupied'
    WHERE bed_id = v_bed_id;

END $$

DELIMITER ;


-- como se usa
CALL sp_admit_patient(1, 1, 'Respiratory distress');


--Admission (OPEN) → Discharge → Bed (Occupied → Available)
DELIMITER $$

CREATE PROCEDURE sp_discharge_patient (
    IN p_admission_id INT
)
BEGIN
    DECLARE v_bed_id INT;
    DECLARE v_admission_date DATETIME;

    -- 1. Obtener datos de la hospitalización
    SELECT bed_id, admission_date
    INTO v_bed_id, v_admission_date
    FROM admission
    WHERE admission_id = p_admission_id
      AND discharge_date IS NULL;

    -- 2. Validar que exista hospitalización activa
    IF v_bed_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Admission not found or already closed';
    END IF;

    -- 3. Actualizar hospitalización (dar alta)
    UPDATE admission
    SET discharge_date = NOW()
    WHERE admission_id = p_admission_id;

    -- 4. Liberar cama
    UPDATE bed
    SET status = 'Available'
    WHERE bed_id = v_bed_id;

END $$

DELIMITER ;

--como se usa 
CALL sp_discharge_patient(1);