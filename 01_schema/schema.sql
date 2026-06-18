USE medicore_db;

CREATE TABLE department (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

CREATE TABLE patient (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,
    sex ENUM('F','M') NOT NULL,
    national_id VARCHAR(20) UNIQUE
);

CREATE TABLE bed (
    bed_id INT AUTO_INCREMENT PRIMARY KEY,
    bed_number VARCHAR(20)UNIQUE NOT NULL,
    department_id INT NOT NULL,
    status ENUM(
        'Available',
        'Occupied',
        'Maintenance'
    ) DEFAULT 'Available',

    FOREIGN KEY (department_id)
        REFERENCES department(department_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE admission (
    admission_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    bed_id INT NOT NULL,
    admission_date DATETIME NOT NULL,
    discharge_date DATETIME NULL,
    status ENUM('Active','Closed')NOT NULL DEFAULT 'Active',
    diagnosis VARCHAR(255),

    FOREIGN KEY (patient_id)
        REFERENCES patient(patient_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    FOREIGN KEY (bed_id)
        REFERENCES bed(bed_id)

        ON DELETE RESTRICT
        ON UPDATE CASCADE
);