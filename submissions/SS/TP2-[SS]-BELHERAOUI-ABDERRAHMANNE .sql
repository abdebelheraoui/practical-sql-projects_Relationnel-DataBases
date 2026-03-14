DROP DATABASE IF EXISTS hospital_db;
CREATE DATABASE hospital_db;
USE hospital_db;

CREATE TABLE specialties (
    specialty_id INT PRIMARY KEY AUTO_INCREMENT,
    specialty_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    consultation_fee DECIMAL(10,2) NOT NULL
);

CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    specialty_id INT NOT NULL,
    license_number VARCHAR(20) UNIQUE NOT NULL,
    hire_date DATE,
    office VARCHAR(100),
    active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (specialty_id) REFERENCES specialties(specialty_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    file_number VARCHAR(20) UNIQUE NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('M','F') NOT NULL,
    blood_type VARCHAR(5),
    email VARCHAR(100),
    phone VARCHAR(20) NOT NULL,
    address TEXT,
    city VARCHAR(50),
    province VARCHAR(50),
    registration_date DATE DEFAULT (CURRENT_DATE),
    insurance VARCHAR(100),
    insurance_number VARCHAR(50),
    allergies TEXT,
    medical_history TEXT
);

CREATE TABLE consultations (
    consultation_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    consultation_date DATETIME NOT NULL,
    reason TEXT NOT NULL,
    diagnosis TEXT,
    observations TEXT,
    blood_pressure VARCHAR(20),
    temperature DECIMAL(4,2),
    weight DECIMAL(5,2),
    height DECIMAL(5,2),
    status ENUM('Scheduled','In Progress','Completed','Cancelled') DEFAULT 'Scheduled',
    amount DECIMAL(10,2),
    paid BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE medications (
    medication_id INT PRIMARY KEY AUTO_INCREMENT,
    medication_code VARCHAR(20) UNIQUE NOT NULL,
    commercial_name VARCHAR(150) NOT NULL,
    generic_name VARCHAR(150),
    form VARCHAR(50),
    dosage VARCHAR(50),
    manufacturer VARCHAR(100),
    unit_price DECIMAL(10,2) NOT NULL,
    available_stock INT DEFAULT 0,
    minimum_stock INT DEFAULT 10,
    expiration_date DATE,
    prescription_required BOOLEAN DEFAULT TRUE,
    reimbursable BOOLEAN DEFAULT FALSE
);

CREATE TABLE prescriptions (
    prescription_id INT PRIMARY KEY AUTO_INCREMENT,
    consultation_id INT NOT NULL,
    prescription_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    treatment_duration INT,
    general_instructions TEXT,
    FOREIGN KEY (consultation_id) REFERENCES consultations(consultation_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE prescription_details (
    detail_id INT PRIMARY KEY AUTO_INCREMENT,
    prescription_id INT NOT NULL,
    medication_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    dosage_instructions VARCHAR(200) NOT NULL,
    duration INT NOT NULL,
    total_price DECIMAL(10,2),
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(prescription_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (medication_id) REFERENCES medications(medication_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE INDEX idx_patient_name ON patients(last_name, first_name);
CREATE INDEX idx_consultation_date ON consultations(consultation_date);
CREATE INDEX idx_consultation_patient ON consultations(patient_id);
CREATE INDEX idx_consultation_doctor ON consultations(doctor_id);
CREATE INDEX idx_medication_name ON medications(commercial_name);
CREATE INDEX idx_prescription_consultation ON prescriptions(consultation_id);

INSERT INTO specialties (specialty_name, description, consultation_fee) VALUES
('Neurology','Brain and nervous system',3500),
('Ophthalmology','Eye care and vision',2200),
('Endocrinology','Hormones and metabolism',3000),
('Gastroenterology','Digestive system',2700),
('Pulmonology','Lungs and respiratory system',2600),
('Psychiatry','Mental health disorders',2400);

INSERT INTO doctors (last_name,first_name,email,phone,specialty_id,license_number,hire_date,office,active) VALUES
('Adams','Brian','brian.adams@hospital.com','0556000001',1,'LIC101','2016-03-14','Room 110',TRUE),
('Clark','Susan','susan.clark@hospital.com','0556000002',2,'LIC102','2017-06-22','Room 210',TRUE),
('Patel','Raj','raj.patel@hospital.com','0556000003',3,'LIC103','2019-09-10','Room 310',TRUE),
('Garcia','Maria','maria.garcia@hospital.com','0556000004',4,'LIC104','2015-12-05','Room 410',TRUE),
('Nguyen','David','david.nguyen@hospital.com','0556000005',5,'LIC105','2018-04-18','Room 510',TRUE),
('Khan','Aisha','aisha.khan@hospital.com','0556000006','0556000006',6,'LIC106','2020-02-11','Room 610',TRUE);

INSERT INTO patients (file_number,last_name,first_name,date_of_birth,gender,blood_type,email,phone,address,city,province,registration_date,insurance,insurance_number,allergies,medical_history) VALUES
('PAT101','Hassan','Ali','1990-05-12','M','O+','ali.hassan@email.com','0661000001','Rue 1','Algiers','Algiers','2024-01-05','CNAS','111222333','None','Migraines'),
('PAT102','Benali','Sara','2008-03-20','F','A+','sara.benali@email.com','0661000002','Rue 2','Oran','Oran','2024-02-01','None',NULL,'Dust','Asthma'),
('PAT103','Rahmani','Karim','1975-10-15','M','B+','karim.rahmani@email.com','0661000003','Rue 3','Constantine','Constantine','2024-02-10','CASNOS','444555666','None','Diabetes'),
('PAT104','Saidi','Nadia','1988-07-08','F','AB-','nadia.saidi@email.com','0661000004','Rue 4','Setif','Setif','2024-03-12','CNAS','777888999','Penicillin','Hypertension'),
('PAT105','Toumi','Yacine','2012-11-25','M','A-','yacine.toumi@email.com','0661000005','Rue 5','Annaba','Annaba','2024-04-08','None',NULL,'Peanuts','None'),
('PAT106','Belaid','Fatima','1965-01-30','F','O-','fatima.belaid@email.com','0661000006','Rue 6','Tlemcen','Tlemcen','2024-05-20','CNAS','222333444','Latex','Heart disease'),
('PAT107','Cherif','Omar','1998-06-17','M','B-','omar.cherif@email.com','0661000007','Rue 7','Batna','Batna','2024-06-15','CASNOS','999888777','None','None'),
('PAT108','Meziane','Lina','2021-09-02','F','A+','lina.meziane@email.com','0661000008','Rue 8','Bejaia','Bejaia','2024-07-01','None',NULL,'Milk','None');

INSERT INTO consultations (patient_id,doctor_id,consultation_date,reason,diagnosis,observations,blood_pressure,temperature,weight,height,status,amount,paid) VALUES
(1,1,'2025-03-01 09:00:00','Headache','Migraine','Advised rest','120/80',36.7,72,178,'Completed',3500,TRUE),
(2,2,'2025-03-02 10:00:00','Vision problems','Myopia','Needs glasses','110/70',36.6,40,150,'Completed',2200,TRUE),
(3,3,'2025-03-03 11:00:00','High sugar','Type 2 Diabetes','Diet control','130/85',36.8,85,175,'Completed',3000,FALSE),
(4,4,'2025-03-04 12:00:00','Stomach pain','Gastritis','Medication prescribed','115/75',36.5,60,165,'Completed',2700,TRUE),
(5,5,'2025-03-05 14:00:00','Breathing difficulty','Bronchitis','Inhaler recommended','125/80',37.2,45,150,'Completed',2600,TRUE),
(6,6,'2025-03-06 15:00:00','Anxiety','General anxiety','Psychological therapy','120/80',36.6,68,170,'Completed',2400,TRUE),
(7,1,'2025-03-07 09:30:00','Memory issues','Under investigation','MRI recommended','130/90',36.7,80,180,'Scheduled',3500,FALSE),
(8,2,'2025-03-08 10:45:00','Eye irritation','Allergy','Eye drops prescribed','100/60',36.8,12,90,'Completed',2200,TRUE);

INSERT INTO medications (medication_code,commercial_name,generic_name,form,dosage,manufacturer,unit_price,available_stock,minimum_stock,expiration_date,prescription_required,reimbursable) VALUES
('MED101','Panadol','Paracetamol','Tablet','500mg','GSK',200,120,20,'2026-10-10',FALSE,TRUE),
('MED102','Amoxicare','Amoxicillin','Capsule','500mg','Pfizer',450,60,15,'2025-12-31',TRUE,TRUE),
('MED103','Glucor','Metformin','Tablet','850mg','Merck',300,70,20,'2027-03-01',TRUE,TRUE),
('MED104','Ventair','Salbutamol','Inhaler','100mcg','AstraZeneca',900,25,10,'2025-11-15',TRUE,TRUE),
('MED105','Allergex','Cetirizine','Tablet','10mg','UCB',350,40,10,'2026-01-20',FALSE,FALSE),
('MED106','Diclogel','Diclofenac','Gel','1%','Novartis',600,30,8,'2025-09-30',FALSE,TRUE),
('MED107','Augmex','Amoxicillin/Clavulanate','Tablet','1g','GSK',950,18,10,'2025-05-10',TRUE,TRUE),
('MED108','Gastrol','Sodium Alginate','Syrup','250ml','Reckitt',420,55,15,'2026-06-15',FALSE,FALSE),
('MED109','Lipicure','Atorvastatin','Tablet','20mg','Pfizer',1100,35,10,'2026-04-20',TRUE,TRUE),
('MED110','Iburex','Ibuprofen','Tablet','400mg','Pfizer',180,8,15,'2025-08-20',FALSE,FALSE);

INSERT INTO prescriptions (consultation_id,treatment_duration,general_instructions) VALUES
(1,5,'Take with water'),
(2,30,'Use daily'),
(3,60,'Strict diet required'),
(4,10,'Avoid spicy food'),
(5,7,'Use inhaler if needed'),
(6,14,'Follow therapy sessions'),
(8,5,'Apply eye drops twice daily');

INSERT INTO prescription_details (prescription_id,medication_id,quantity,dosage_instructions,duration,total_price) VALUES
(1,1,2,'1 tablet twice daily',5,400),
(2,9,1,'1 tablet daily',30,1100),
(3,3,2,'1 tablet morning and evening',60,600),
(4,8,1,'10ml after meals',10,420),
(5,4,1,'2 puffs when needed',7,900),
(6,6,1,'Apply on affected area',14,600),
(7,5,1,'1 tablet at night',5,350);
Q1. List all patients with their main information
SELECT file_number, CONCAT(last_name, ' ', first_name) AS full_name, date_of_birth, phone, city FROM patients;
 Q2. Display all doctors with their specialty
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, s.specialty_name, d.office, d.active 
FROM doctors d 
JOIN specialties s ON d.specialty_id = s.specialty_id;

 Q3. Find all medications with price less than 500 DA
SELECT medication_code, commercial_name, unit_price, available_stock FROM medications WHERE unit_price < 500;
 Q4. List consultations from January 2025
SELECT c.consultation_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name, CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, c.status 
FROM consultations c 
JOIN patients p ON c.patient_id = p.patient_id 
JOIN doctors d ON c.doctor_id = d.doctor_id 
WHERE c.consultation_date BETWEEN '2025-01-01' AND '2025-01-31 23:59:59';
 Q5. Display medications where stock is below minimum stock
SELECT commercial_name, available_stock, minimum_stock, (minimum_stock - available_stock) AS difference 
FROM medications 
WHERE available_stock < minimum_stock;




 Q6. Display all consultations with patient and doctor names
SELECT c.consultation_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name, CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, c.diagnosis, c.amount 
FROM consultations c 
JOIN patients p ON c.patient_id = p.patient_id 
JOIN doctors d ON c.doctor_id = d.doctor_id;

 Q7. List all prescriptions with medication details
SELECT pr.prescription_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name, m.commercial_name AS medication_name, pd.quantity, pd.dosage_instructions 
FROM prescription_details pd 
JOIN prescriptions pr ON pd.prescription_id = pr.prescription_id 
JOIN consultations c ON pr.consultation_id = c.consultation_id 
JOIN patients p ON c.patient_id = p.patient_id 
JOIN medications m ON pd.medication_id = m.medication_id;
 Q8. Display patients with their last consultation date
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, MAX(c.consultation_date) AS last_consultation_date, CONCAT(d.last_name, ' ', d.first_name) AS doctor_name 
FROM patients p 
JOIN consultations c ON p.patient_id = c.patient_id 
JOIN doctors d ON c.doctor_id = d.doctor_id 
GROUP BY p.patient_id, p.last_name, p.first_name, d.last_name, d.first_name;

 Q9. List doctors and the number of consultations performed
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, COUNT(c.consultation_id) AS consultation_count 
FROM doctors d 
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id 
GROUP BY d.doctor_id, d.last_name, d.first_name;

 Q10. Display revenue by medical specialty
SELECT s.specialty_name, SUM(c.amount) AS total_revenue, COUNT(c.consultation_id) AS consultation_count 
FROM specialties s 
JOIN doctors d ON s.specialty_id = d.specialty_id 
JOIN consultations c ON d.doctor_id = c.doctor_id 
GROUP BY s.specialty_id, s.specialty_name;




 Q11. Calculate total prescription amount per patient
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, SUM(pd.total_price) AS total_prescription_cost 
FROM patients p 
JOIN consultations c ON p.patient_id = c.patient_id 
JOIN prescriptions pr ON c.consultation_id = pr.consultation_id 
JOIN prescription_details pd ON pr.prescription_id = pd.prescription_id 
GROUP BY p.patient_id, p.last_name, p.first_name;

 Q12. Count the number of consultations per doctor
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, COUNT(c.consultation_id) AS consultation_count 
FROM doctors d 
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id 
GROUP BY d.doctor_id, d.last_name, d.first_name;

 Q13. Calculate total stock value of pharmacy
SELECT COUNT(medication_id) AS total_medications, SUM(unit_price * available_stock) AS total_stock_value FROM medications;

 Q14. Find average consultation price per specialty
SELECT s.specialty_name, AVG(c.amount) AS average_price 
FROM specialties s 
JOIN doctors d ON s.specialty_id = d.specialty_id 
JOIN consultations c ON d.doctor_id = c.doctor_id 
GROUP BY s.specialty_id, s.specialty_name;

 Q15. Count number of patients by blood type
SELECT blood_type, COUNT(patient_id) AS patient_count FROM patients GROUP BY blood_type;




 Q16. Find the top 5 most prescribed medications
SELECT m.commercial_name AS medication_name, COUNT(pd.detail_id) AS times_prescribed, SUM(pd.quantity) AS total_quantity 
FROM medications m 
JOIN prescription_details pd ON m.medication_id = pd.medication_id 
GROUP BY m.medication_id, m.commercial_name 
ORDER BY times_prescribed DESC 
LIMIT 5;

 Q17. List patients who have never had a consultation
SELECT CONCAT(last_name, ' ', first_name) AS patient_name, registration_date 
FROM patients 
WHERE patient_id NOT IN (SELECT DISTINCT patient_id FROM consultations);

Q18. Display doctors who performed more than 2 consultations
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, s.specialty_name AS specialty, COUNT(c.consultation_id) AS consultation_count 
FROM doctors d 
JOIN specialties s ON d.specialty_id = s.specialty_id 
JOIN consultations c ON d.doctor_id = c.doctor_id 
GROUP BY d.doctor_id, d.last_name, d.first_name, s.specialty_name 
HAVING COUNT(c.consultation_id) > 2;

 Q19. Find unpaid consultations with total amount
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, c.consultation_date, c.amount, CONCAT(d.last_name, ' ', d.first_name) AS doctor_name 
FROM consultations c 
JOIN patients p ON c.patient_id = p.patient_id 
JOIN doctors d ON c.doctor_id = d.doctor_id 
WHERE c.paid = FALSE;

 Q20. List medications expiring in less than 6 months from today
SELECT commercial_name, expiration_date, DATEDIFF(expiration_date, CURRENT_DATE) AS days_until_expiration 
FROM medications 
WHERE expiration_date BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, INTERVAL 6 MONTH);




 Q21. Find patients who consulted more than the average
SELECT patient_name, consultation_count, average_count
FROM (
    SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, COUNT(c.consultation_id) AS consultation_count
    FROM patients p
    JOIN consultations c ON p.patient_id = c.patient_id
    GROUP BY p.patient_id, p.last_name, p.first_name
) AS patient_counts,
(
    SELECT AVG(cnt) AS average_count
    FROM (SELECT COUNT(consultation_id) AS cnt FROM consultations GROUP BY patient_id) AS counts
) AS avg_table
WHERE consultation_count > average_count;

 Q22. List medications more expensive than average price
SELECT commercial_name, unit_price, (SELECT AVG(unit_price) FROM medications) AS average_price 
FROM medications 
WHERE unit_price > (SELECT AVG(unit_price) FROM medications);

 Q23. Display doctors from the most requested specialty
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, s.specialty_name, specialty_counts.cnt AS specialty_consultation_count
FROM doctors d
JOIN specialties s ON d.specialty_id = s.specialty_id
JOIN (
    SELECT s.specialty_id, COUNT(c.consultation_id) AS cnt
    FROM specialties s
    JOIN doctors d ON s.specialty_id = d.specialty_id
    JOIN consultations c ON d.doctor_id = c.doctor_id
    GROUP BY s.specialty_id
) AS specialty_counts ON s.specialty_id = specialty_counts.specialty_id
WHERE specialty_counts.cnt = (
    SELECT MAX(cnt) FROM (
        SELECT COUNT(c.consultation_id) AS cnt
        FROM specialties s
        JOIN doctors d ON s.specialty_id = d.specialty_id
        JOIN consultations c ON d.doctor_id = c.doctor_id
        GROUP BY s.specialty_id
    ) AS max_counts
);

 Q24. Find consultations with amount higher than average
SELECT c.consultation_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name, c.amount, (SELECT AVG(amount) FROM consultations) AS average_amount 
FROM consultations c 
JOIN patients p ON c.patient_id = p.patient_id 
WHERE c.amount > (SELECT AVG(amount) FROM consultations);

 Q25. List allergic patients who received a prescription
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, p.allergies, COUNT(pr.prescription_id) AS prescription_count 
FROM patients p 
JOIN consultations c ON p.patient_id = c.patient_id 
JOIN prescriptions pr ON c.consultation_id = pr.consultation_id 
WHERE p.allergies IS NOT NULL AND p.allergies != 'None' 
GROUP BY p.patient_id, p.last_name, p.first_name, p.allergies;



 Q26. Calculate total revenue per doctor (paid consultations only)
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, COUNT(c.consultation_id) AS total_consultations, SUM(c.amount) AS total_revenue 
FROM doctors d 
JOIN consultations c ON d.doctor_id = c.doctor_id 
WHERE c.paid = TRUE 
GROUP BY d.doctor_id, d.last_name, d.first_name;

 Q27. Display top 3 most profitable specialties
SELECT RANK() OVER (ORDER BY SUM(c.amount) DESC) AS `rank`, s.specialty_name, SUM(c.amount) AS total_revenue 
FROM specialties s 
JOIN doctors d ON s.specialty_id = d.specialty_id 
JOIN consultations c ON d.doctor_id = c.doctor_id 
GROUP BY s.specialty_id, s.specialty_name 
LIMIT 3;

Q28. List medications to restock (stock < minimum)
SELECT commercial_name, available_stock AS current_stock, minimum_stock, (minimum_stock - available_stock) AS quantity_needed 
FROM medications 
WHERE available_stock < minimum_stock;

 Q29. Calculate average number of medications per prescription
SELECT AVG(med_count) AS average_medications_per_prescription 
FROM (
    SELECT COUNT(detail_id) AS med_count 
    FROM prescription_details 
    GROUP BY prescription_id
) AS counts;

 Q30. Generate patient demographics report by age group
SELECT 
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 0 AND 18 THEN '0-18'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 19 AND 40 THEN '19-40'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 41 AND 60 THEN '41-60'
        ELSE '60+'
    END AS age_group,
    COUNT(patient_id) AS patient_count,
    (COUNT(patient_id) / (SELECT COUNT(*) FROM patients)) * 100 AS percentage
FROM patients
GROUP BY age_group;




