-- =========================================================
-- MediCore DB - Audit & Compliance Tables
-- =========================================================

USE medicore_db;

-- Audit table to track all changes made to bed status
-- This provides traceability for operational and compliance purposes
CREATE TABLE IF NOT EXISTS bed_audit_log (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    bed_id INT NOT NULL,
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    changed_by VARCHAR(100) NOT NULL, -- Tracks which database user executed the change
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
