-- Question a
-- Creating objects
-- Incomplete department object is created in order to create emplyee table
CREATE TYPE Dept_t
/
CREATE TYPE Emp_t AS OBJECT(
    eno NUMBER(4),
    ename VARCHAR2(15),
    edept REF Dept_t,
    salaray NUMBER(8,2)
)
/
CREATE TYPE Dept_t AS OBJECT(
    dno NUMBER(2),
    dname VARCHAR2(12),
    mgr REF Emp_t
)
/
CREATE TYPE Proj_t AS OBJECT(
    pno NUMBER(2),
    pname VARCHAR2(15),
    pdept REF Dept_t,
    budget NUMBER(10,2)
)
/

-- Creating tables
CREATE TABLE Dept OF Dept_t (dno PRIMARY KEY)
/
CREATE TABLE Emp OF Emp_t (eno PRIMARY KEY)
/
CREATE TABLE Proj OF Proj_t (pno PRIMARY KEY)
/

-- Question b
-- Inserting data into employee table edept value is set to null because no department
INSERT INTO Emp 
VALUES (Emp_t(001,'Saman',NULL, 50000)) 
/
INSERT INTO Emp 
VALUES (Emp_t(002,'Kamal',NUll, 70000))
/
INSERT INTO Emp 
VALUES (Emp_t(003,'Sunil',NULL, 60000))
/
INSERT INTO Emp 
VALUES (Emp_t(004,'Amal',NULL, 90000))
/

-- Inserting data into department
INSERT INTO Dept 
VALUES (Dept_t(01,'DS', (SELECT REF(e) FROM Emp e WHERE e.eno = 004)))
/
INSERT INTO Dept 
VALUES(Dept_t(02,'SE', (SELECT REF(e) FROM Emp e WHERE e.eno = 002)))
/
INSERT INTO Dept 
VALUES(Dept_t(03,'ISE', (SELECT REF(e) FROM Emp e WHERE e.eno = 003)))
/

-- Inserting data into Project
INSERT INTO Proj 
VALUES (Proj_t(0001,'P01',(SELECT REF(d) FROM Dept d WHERE d.dno=01),100000))
/
INSERT INTO Proj 
VALUES (Proj_t(0002,'P02',(SELECT REF(d) FROM Dept d WHERE d.dno=02),50000))
/
INSERT INTO Proj 
VALUES (Proj_t(0003,'P03',(SELECT REF(d) FROM Dept d WHERE d.dno=03),40000))
/
INSERT INTO Proj 
VALUES (Proj_t(0004,'P04',(SELECT REF(d) FROM Dept d WHERE d.dno=01),30000))
/

-- Updating edept value in employee table
UPDATE Emp e
SET e.edept=(SELECT REF(d) FROM Dept d WHERE d.dno=01)
WHERE e.eno=001;
/
UPDATE Emp e
SET e.edept=(SELECT REF(d) FROM Dept d WHERE d.dno=02)
WHERE e.eno=002;
/
UPDATE Emp e
SET e.edept=(SELECT REF(d) FROM Dept d WHERE d.dno=03)
WHERE e.eno=003;
/
UPDATE Emp e
SET e.edept=(SELECT REF(d) FROM Dept d WHERE d.dno=01)
WHERE e.eno=004;
/

-- Select all from tables
SELECT d.dno,d.dname,d.mgr.eno FROM Dept d
SELECT e.dno,e.ename,e.edept.dno FROM Emp e
SELECT p.pno,p.pname,p.pdept.dno,p.budget FROM Proj p

-- Question c
SELECT d.dno AS "Department No.", d.mgr.ename AS "Manager", d.mgr.salary AS "Salary"
FROM Dept d

-- Question d
SELECT p.pname AS "Project Name", p.pdept.mgr.ename AS "Manager"
FROM Proj p
WHERE p.budget > 50000

-- Question e
SELECT p.pdept.dno AS "Department No.", p.pdept.dname AS "Department Name", SUM(p.budget) AS "Total budget"
FROM Proj p
GROUP BY p.pdept.dno, p.pdept.dname

-- Question f
SELECT p.pname AS "Project Name", p.pdept.mgr.ename AS "Manager"
FROM Proj p
WHERE p.budget IN (SELECT MAX(budget) FROM Proj)

-- Question g
SELECT p.pdept.mgr.eno AS "Employee ID", SUM(p.budget) AS "Total controlling budget"
FROM Proj p
GROUP BY p.pdept.mgr.eno
HAVING SUM(p.budget) > 60000

-- Question h
SELECT ManagerID, MAX(Budget)
FROM (
    SELECT p.pdept.mgr.eno AS ManagerID, SUM(p.budget) AS Budget 
    FROM Proj p 
    GROUP BY p.pdept.mgr.eno)
GROUP BY ManagerID

-- Varnavi's answer (working)
SELECT p2.eno, p2.Total
FROM (
    SELECT p1.pdept.mgr.eno AS eno, SUM(p1.budget) AS Total  
    FROM Proj p1 
    GROUP BY p1.pdept.mgr.eno) p2	
WHERE p2.Total IN (
    SELECT MAX(Total) 
    FROM (
        SELECT p.pdept.mgr.eno AS eno, SUM(p.budget) AS Total  
        FROM Proj p 
        GROUP BY p.pdept.mgr.eno)
    );