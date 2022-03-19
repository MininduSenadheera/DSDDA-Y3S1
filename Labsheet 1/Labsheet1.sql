--  Creating the database
CREATE DATABASE DSDDA_LAB1
USE DSDDA_LAB1

-- Creating the Tables
CREATE TABLE Employee (
    EmpNo VARCHAR (20),
    fname CHAR (20),
    lname CHAR (20),
    address VARCHAR(40),
    salary INTEGER,
    DeptNo VARCHAR(20),
    CONSTRAINT PK_Employee PRIMARY KEY (EmpNo)
)

CREATE TABLE Department (
    DeptNo VARCHAR (20),
    DeptName CHAR (20),
    Location VARCHAR (20),
    CONSTRAINT PK_Department PRIMARY KEY (DeptNo)
)

CREATE TABLE Project (
    ProjNo CHAR(5),
    Project_Name VARCHAR (20),
    DeptNo VARCHAR (20),
    CONSTRAINT PK_Project PRIMARY KEY (ProjNo)
)

CREATE TABLE Works_On (
    EmpNo VARCHAR (20),
    ProjNo CHAR (5),
    DateWorked date,
    Hours INTEGER,
    CONSTRAINT PK_WorksOn PRIMARY KEY (EmpNo, ProjNo),
    CONSTRAINT FK_WorksOn1 FOREIGN KEY (EmpNo) REFERENCES Employee (EmpNo),
    CONSTRAINT FK_WorksOn2 FOREIGN KEY (ProjNo) REFERENCES Project (ProjNo)
)

-- Inserting data
INSERT INTO Employee VALUES
    ('Emp01','John','Scott','Mysore', 45000, 003),
    ('Emp02','James','Smith','Bangalore', 50000, 005),
    ('Emp03','Edward','Hedge','Bangalore', 65000, 002),
    ('Emp04','Santhosh','Kumar','Delhi', 80000, 002),
    ('Emp05','Veena','M','Mumbai', 45000, 004)

INSERT INTO Department VALUES 
    ('001','Accounts','Bungalore'),
    ('002','IT','Mumbai'),
    ('003','ECE','Mumbai'),
    ('004','ISE','Mumbai'),
    ('005','CSE','Delhi')

INSERT INTO Project VALUES 
    ('P01','IOT','005'),
    ('P02','Cloud','005'),
    ('P03','BankMgmt','004'),
    ('P04','Sensors','003'),
    ('P05','BigData','002')

INSERT INTO Works_On VALUES 
    ('Emp02','P03','02-OCT-2018',4),
    ('Emp01','P02','22-JAN-2014',13),
    ('Emp02','P02','19-JUN-2020',15),
    ('Emp02','P01','11-JUN-2020',10),
    ('Emp01','P04','08-FEB-2009',6),
    ('Emp03','P01','18-OCT-2018',18),
    ('Emp01','P05','02-SEP-2011',7)

-- Questions

-- 1
SELECT E.fname, E.lname, E.address, D.DeptName
FROM Employee E, Department D, Project P, Works_On w
WHERE D.DeptName = 'IT' AND D.DeptNo = P.DeptNo AND P.ProjNo = W.ProjNo AND W.EmpNo = E.EmpNo

-- 2
SELECT DISTINCT salary, EmpNo 
FROM Employee

-- 3
SELECT E.fname, E.lname
FROM Employee E, Department D, Project P, Works_On W
WHERE D.DeptNo = 005 AND P.ProjNo = 'P01' AND W.[Hours] >= 10 AND 
E.EmpNo = W.EmpNo AND P.ProjNo = W.ProjNo AND P.DeptNo = D.DeptNo

-- 4
SELECT E.fname, E.lname, P.Project_Name, D.DeptNo
FROM Employee E, Project P, Works_On W, Department D
WHERE E.EmpNo = W.EmpNo AND P.ProjNo = W.ProjNo AND P.DeptNo = D.DeptNo
ORDER BY D.DeptNo, E.fname ASC, E.lname ASC

-- 5
SELECT E.fname, E.lname, E.salary * 110/100 AS 'Raised Salary'
FROM Employee E, Project P, Works_On W
WHERE P.Project_Name = 'IOT' AND E.EmpNo = W.EmpNo AND W.ProjNo = P.ProjNo

-- Dropping the tables
DROP TABLE Employee
DROP TABLE Department
DROP TABLE Project
DROP TABLE Works_On
