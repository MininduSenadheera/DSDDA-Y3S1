-- Creating objects
CREATE TYPE Depend_t AS OBJECT(
    depname VARCHAR2(12),
    gender CHAR(1),
    bdate DATE,
    relationship VARCHAR2(10)
)
/
CREATE TYPE Dependtb_t AS TABLE OF Depend_t
/
CREATE TYPE Dept_t2
/
CREATE TYPE Emp_t2 AS OBJECT (
    eno NUMBER(4),
    ename VARCHAR2(15),
    edept REF Dept_t2,
    salary NUMBER(8,2),
    dependents Dependtb_t
)
/
CREATE TYPE Dept_t2 AS OBJECT(
    dno NUMBER(2),
    dname VARCHAR2(12),
    mgr REF Emp_t2
)
/
CREATE TYPE Proj_t2 AS OBJECT(
    pno NUMBER(4),
    pname VARCHAR2(15),
    pdept REF Dept_t2,
    budget NUMBER(10,2)
)
/
CREATE TYPE Work_t2 AS OBJECT(
    wemp REF Emp_t2,
    wproj REF Proj_t2,
    since DATE,
    hours NUMBER(4,2)
)
/

-- Creating tables
CREATE TABLE Dept2 OF Dept_t2 (dno PRIMARY KEY)
/
CREATE TABLE Emp2 OF Emp_t2 (eno PRIMARY KEY)
NESTED TABLE dependents STORE AS dependent_tb
/
CREATE TABLE Proj2 OF Proj_t2 (pno PRIMARY KEY)
/
CREATE TABLE Work2 OF Work_t2
/


-- Inserting data into employee table edept value is set to null because no department
INSERT INTO Emp2
VALUES (
    Emp_t2(1111,'John',NULL, 45000, 
        Dependtb_t(
            Depend_t('Kate', 'F','12-AUG-1988','SPOUSE'),
            Depend_t('Bill', 'M','02-JAN-2013','CHILD')
        )
    )
) 
/
INSERT INTO Emp2
VALUES (
    Emp_t2(2143,'James',NUll, 50000,
        Dependtb_t(
            Depend_t('Lily', 'F','25-DEC-1933','SPOUSE')
        )
    )
)
/
INSERT INTO Emp2
VALUES (
    Emp_t2(1113,'Edward',NULL, 65000,
        Dependtb_t(
            Depend_t('Nina', 'F','16-SEP-1980','SPOUSE')
        )
    )
)
/
INSERT INTO Emp2 
VALUES (
    Emp_t2(1114,'Santhosh',NULL, 80000,
        Dependtb_t(
            Depend_t('Luke', 'M','26-MAR-2000','CHILD')
        )
    )
)
/
INSERT INTO Emp2 
VALUES (
    Emp_t2(1115,'Veena',NULL, 45000,
        Dependtb_t(
            Depend_t('Kumar', 'M','06-OCT-1985','SPOUSE')
        )
    )
)
/

-- Inserting data into department
INSERT INTO Dept2
VALUES (Dept_t2(01,'Accounts', (SELECT REF(e) FROM Emp2 e WHERE e.eno = 1113)))
/
INSERT INTO Dept2
VALUES(Dept_t2(02,'IT', (SELECT REF(e) FROM Emp2 e WHERE e.eno = 1115)))
/
INSERT INTO Dept2
VALUES(Dept_t2(03,'Data Mining ', (SELECT REF(e) FROM Emp2 e WHERE e.eno = 1114)))
/

-- Inserting data into Project table
INSERT INTO Proj2
VALUES (Proj_t2(401,'IOT',(SELECT REF(d) FROM Dept2 d WHERE d.dno=03),30000))
/
INSERT INTO Proj2
VALUES (Proj_t2(402,'Cloud',(SELECT REF(d) FROM Dept2 d WHERE d.dno=03),60000))
/
INSERT INTO Proj2
VALUES (Proj_t2(403,'BankMgmt',(SELECT REF(d) FROM Dept2 d WHERE d.dno=01),25000))
/
INSERT INTO Proj2
VALUES (Proj_t2(404,'Sensors',(SELECT REF(d) FROM Dept2 d WHERE d.dno=02),9000))
/
INSERT INTO Proj2
VALUES (Proj_t2(405,'BigData',(SELECT REF(d) FROM Dept2 d WHERE d.dno=02),10000))
/

-- Updating edept value in employee table
UPDATE Emp2 e
SET e.edept=(SELECT REF(d) FROM Dept2 d WHERE d.dno=03)
WHERE e.eno=1111;
/
UPDATE Emp2 e
SET e.edept=(SELECT REF(d) FROM Dept2 d WHERE d.dno=01)
WHERE e.eno=2143;
/
UPDATE Emp2 e
SET e.edept=(SELECT REF(d) FROM Dept2 d WHERE d.dno=01)
WHERE e.eno=1113;
/
UPDATE Emp2 e
SET e.edept=(SELECT REF(d) FROM Dept2 d WHERE d.dno=03)
WHERE e.eno=1114;
/
UPDATE Emp2 e
SET e.edept=(SELECT REF(d) FROM Dept2 d WHERE d.dno=02)
WHERE e.eno=1115;
/

-- Inserting data into work table
INSERT INTO Work2
VALUES (
    Work_t2(
        (SELECT REF(e) FROM Emp2 e WHERE e.eno=2143),
        (SELECT REF(p) FROM Proj2 p WHERE p.pno=403),
        '02-OCT-2018',
        4
    )
)
/
INSERT INTO Work2
VALUES (
    Work_t2(
        (SELECT REF(e) FROM Emp2 e WHERE e.eno=1111),
        (SELECT REF(p) FROM Proj2 p WHERE p.pno=402),
        '22-JAN-2014',
        13
    )
)
/
INSERT INTO Work2
VALUES (
    Work_t2(
        (SELECT REF(e) FROM Emp2 e WHERE e.eno=2143),
        (SELECT REF(p) FROM Proj2 p WHERE p.pno=402),
        '19-JUN-2020',
        15
    )
)
/
INSERT INTO Work2
VALUES (
    Work_t2(
        (SELECT REF(e) FROM Emp2 e WHERE e.eno=1113),
        (SELECT REF(p) FROM Proj2 p WHERE p.pno=404),
        '11-JUN-2020',
        10
    )
)
/
INSERT INTO Work2
VALUES (
    Work_t2(
        (SELECT REF(e) FROM Emp2 e WHERE e.eno=1115),
        (SELECT REF(p) FROM Proj2 p WHERE p.pno=404),
        '08-FEB-2009',
        6
    )
)
/
INSERT INTO Work2
VALUES (
    Work_t2(
        (SELECT REF(e) FROM Emp2 e WHERE e.eno=1114),
        (SELECT REF(p) FROM Proj2 p WHERE p.pno=401),
        '18-OCT-2018',
        18
    )
)
/
INSERT INTO Work2
VALUES (
    Work_t2(
        (SELECT REF(e) FROM Emp2 e WHERE e.eno=1111),
        (SELECT REF(p) FROM Proj2 p WHERE p.pno=405),
        '02-SEP-2011',
        7
    )
)
/

-- Question a
ALTER TYPE Emp_t2
ADD MEMBER FUNCTION childAllowance RETURN FLOAT
CASCADE

CREATE OR REPLACE TYPE BODY Emp_t2 AS 
MEMBER FUNCTION childAllowance RETURN FLOAT IS 
    childCount NUMBER;
    BEGIN
        SELECT COUNT(d.depname) INTO childCount
        FROM TABLE(SELF.dependents) d
        WHERE d.relationship='CHILD';
        RETURN SELF.salary * (5/100) * childCount;
    END;
END;

-- Question b
SELECT e.ename AS "Name", e.salary AS "Salary", e.childAllowance() AS "Child allowance"
FROM EMP2 e, TABLE (e.dependents) d
WHERE d.relationship = 'CHILD'

-- Question c
UPDATE EMP2 e
SET e.dependents = Dependtb_t(Depend_t('Jerermy', 'M','12-MAR-2001','CHILD'))
WHERE e.eno = 2143

-- Question d
ALTER TYPE Emp_t2
ADD MEMBER FUNCTION bonus(percentage NUMBER) RETURN FLOAT
CASCADE

-- you have re write the previous method when adding new method to same object
CREATE OR REPLACE TYPE BODY Emp_t2 AS 
    MEMBER FUNCTION childAllowance RETURN FLOAT IS 
    childCount NUMBER;
    BEGIN
        SELECT COUNT(d.depname) INTO childCount
        FROM TABLE(SELF.dependents) d
        WHERE d.relationship='CHILD';
        RETURN SELF.salary * (5/100) * childCount;
    END;
    MEMBER FUNCTION bonus(percentage NUMBER) RETURN FLOAT IS 
    BEGIN
        RETURN SELF.salary * percentage / 100;
    END;
END;

-- Question e
SELECT e.ename AS "Name", e.salary,e.bonus(12) AS "Bonus"
FROM EMP2 e
WHERE e.edept.dname LIKE '%Data Mining%'


show ERRORS