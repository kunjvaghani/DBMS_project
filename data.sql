CREATE DATABASE scholarship;
USE scholarship;

-- for registration page
CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    password VARCHAR(255) NOT NULL,
    gender ENUM('male', 'female', 'prefer-not') NOT NULL,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    account_status ENUM('active', 'inactive', 'suspended') DEFAULT 'active'
);

-- for login page 
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,  -- Store hashed password, not plaintext
    email VARCHAR(100) UNIQUE NOT NULL,
    user_type ENUM('student', 'admin') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP
);

-- Scholarship Apply
CREATE TABLE scholarship_applications (
    application_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    scholarship_type ENUM('merit', 'need-based', 'sports', 'cultural', 'research') NOT NULL,
    academic_year VARCHAR(20) NOT NULL,
    semester INT NOT NULL,
    cgpa DECIMAL(3,2) NOT NULL,
    family_income DECIMAL(12,2) NOT NULL,
    applied_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'under_review', 'approved', 'rejected') DEFAULT 'pending',
    amount_requested DECIMAL(10,2) NOT NULL,
    amount_approved DECIMAL(10,2),
    FOREIGN KEY (student_id) REFERENCES students(id),
    INDEX idx_status (status),
    INDEX idx_applied_date (applied_date)
);

-- Application Status Tracking
CREATE TABLE application_status (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    application_id INT,
    previous_status ENUM('pending', 'under_review', 'approved', 'rejected'),
    current_status ENUM('pending', 'under_review', 'approved', 'rejected'),
    updated_by INT,  -- references users.user_id
    status_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    remarks TEXT,
    FOREIGN KEY (application_id) REFERENCES scholarship_applications(application_id),
    FOREIGN KEY (updated_by) REFERENCES users(user_id),
    INDEX idx_application_id (application_id)
);

-- Documents Table for Scholarship Applications
CREATE TABLE application_documents (
    document_id INT PRIMARY KEY AUTO_INCREMENT,
    application_id INT,
    document_type ENUM('income_certificate', 'grade_sheet', 'recommendation_letter', 'id_proof', 'other'),
    document_path VARCHAR(255) NOT NULL,
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (application_id) REFERENCES scholarship_applications(application_id)
);

-- Create Dashboard View
CREATE VIEW scholarship_dashboard AS
SELECT 
    s.id AS student_id,
    s.full_name,
    s.email,
    s.phone,
    sa.application_id,
    sa.scholarship_type,
    sa.academic_year,
    sa.semester,
    sa.cgpa,
    sa.family_income,
    sa.applied_date,
    sa.status AS current_status,
    sa.amount_requested,
    sa.amount_approved,
    ast.status_date AS last_status_update,
    ast.remarks AS latest_remarks,
    (SELECT COUNT(*) 
     FROM application_documents ad 
     WHERE ad.application_id = sa.application_id) AS documents_submitted
FROM 
    students s
LEFT JOIN scholarship_applications sa ON s.id = sa.student_id
LEFT JOIN application_status ast ON sa.application_id = ast.application_id
WHERE 
    ast.status_id = (
        SELECT MAX(status_id) 
        FROM application_status 
        WHERE application_id = sa.application_id
    );

-- Common Queries for Your Reference:

-- 1. Submit New Scholarship Application
INSERT INTO scholarship_applications 
(student_id, scholarship_type, academic_year, semester, cgpa, family_income, amount_requested)
VALUES (?, ?, ?, ?, ?, ?, ?);

-- 2. Update Application Status
INSERT INTO application_status 
(application_id, previous_status, current_status, updated_by, remarks)
SELECT 
    application_id,
    status AS previous_status,
    ? AS current_status,
    ? AS updated_by,
    ? AS remarks
FROM scholarship_applications
WHERE application_id = ?;

-- 3. Get Student's Application Status
SELECT 
    sa.application_id,
    sa.scholarship_type,
    sa.academic_year,
    sa.status,
    sa.applied_date,
    sa.amount_requested,
    sa.amount_approved,
    ast.status_date,
    ast.remarks
FROM scholarship_applications sa
LEFT JOIN application_status ast ON sa.application_id = ast.application_id
WHERE sa.student_id = ?
ORDER BY sa.applied_date DESC;

-- 4. Get Dashboard Data
SELECT * FROM scholarship_dashboard WHERE student_id = ?;

-- 5. Get Admin Overview
SELECT 
    scholarship_type,
    COUNT(*) as total_applications,
    SUM(CASE WHEN status = 'pending' THEN 1 ELSE 0 END) as pending_count,
    SUM(CASE WHEN status = 'approved' THEN 1 ELSE 0 END) as approved_count,
    SUM(CASE WHEN status = 'rejected' THEN 1 ELSE 0 END) as rejected_count,
    SUM(amount_approved) as total_amount_approved
FROM scholarship_applications
GROUP BY scholarship_type;

-- select * from students;
select * from scholarship_applications;
select * from students;
select * from users;


-- SELECT user_id, username, user_type 
-- FROM students 
-- WHERE username = 'qq' AND password = 'qq';

-- Update last login time
-- UPDATE users 
-- SET last_login = CURRENT_TIMESTAMP 
-- WHERE user_id = ?;
