-- Question 1
-- Creating objects
CREATE TYPE Doctor_t AS OBJECT(
    regNo CHAR(10),
    name VARCHAR2(50),
    specialization VARCHAR2(25)
)
/
CREATE TYPE HospitalVisit_t AS OBJECT(
    hosChg FLOAT,
    vDate DATE,
    refDoc REF Doctor_t,
    docChg FLOAT
)
/
CREATE TYPE HospitalVisit_tlb AS TABLE OF HospitalVisit_t
/
CREATE TYPE Patient_t AS OBJECT(
    id CHAr(10),
    name VARCHAR2(50),
    dateofBirth DATE,
    phone CHAR(10),
    hospVisits HospitalVisit_tlb
)
/

-- Creating tables
CREATE TABLE Doctors OF Doctor_t (regNo PRIMARY KEY)
/
CREATE TABLE Patients OF Patient_t (id PRIMARY KEY) 
NESTED TABLE hospVisits STORE AS hospVisit_ntb
/

-- Question 2
-- Inserting data into doctor table
INSERT INTO Doctors 
VALUES (Doctor_t(1223441234,'Dr.K.Perera', 'Gynecologist')) 
/
INSERT INTO Doctors 
VALUES (Doctor_t(1234421131,'Dr.P.Weerasinghe', 'Dermatologist')) 
/
INSERT INTO Doctors 
VALUES (Doctor_t(2342111322,'Dr.S.Fernando', 'Pediatrician')) 
/
INSERT INTO Doctors 
VALUES (Doctor_t(2344114344,'Dr.K.Sathgunanathan', 'Pediatrician')) 
/

-- Inserting data into patients table
INSERT INTO Patients
VALUES (
    Patient_t('732821122V','Sampath Weerasinghe','23-JAN-73','0332124222',
        HospitalVisit_tlb(
            HospitalVisit_t(
                50.00,'24-MAY-06',(SELECT ref(d) FROM Doctors d WHERE d.regNo = '1223441234'),500.00
            )      
        )
    )
)
/
INSERT INTO Patients
VALUES (
    Patient_t('491221019V','Dulani Perera','3-FEB-49','0112233211',
        HospitalVisit_tlb(
            HospitalVisit_t(
                75.00,'25-MAY-06',(SELECT ref(d) FROM Doctors d WHERE d.regNo = '2342111322'),550.00
            ),
            HospitalVisit_t(
                90.00,'29-MAY-06',(SELECT ref(d) FROM Doctors d WHERE d.regNo = '2344114344'),300.00
            )
        )
    )
)
/

-- Question 3a
SELECT p.id, SUM(h.hosChg) AS "Total amount spent on hospital"
FROM PATIENTS p, TABLE (p.hospVisits) h
WHERE p.id = '732821122V'
GROUP BY p.id

-- Question 3b
SELECT COUNT(p.id) AS "No.of Patients"
FROM Patients p, TABLE (p.hospVisits) h
WHERE h.refDoc.name = 'Prof.S.Fernando'

--Question 3c Incomplete
SELECT COUNT(DISTINCT(p.id)) AS "No.of patients channeled pediatricians"
FROM PATIENTS p, TABLE (p.hospVisits) h
WHERE h.refDoc.specialization = 'Pediatrician'

-- Question 3d
SELECT p.name, SUM(h.docChg) AS "Total amount spent on doctors"
FROM PATIENTS p, TABLE (p.hospVisits) h
GROUP BY p.name

-- Question 3e
SELECT h.refDoc.name, SUM(h.docChg) AS "Total doctor charges earned"
FROM PATIENTS p, TABLE (p.hospVisits) h
GROUP BY h.refDoc.name
HAVING SUM(h.docChg) > 1000