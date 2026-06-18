CREATE TABLE bed_audit_log (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    bed_id INT NOT NULL,
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP
);


