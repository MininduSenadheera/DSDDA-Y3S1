DECLARE 
BEGIN
    DBMS_OUTPUT.PUT_LINE('This is my first PL/SQL program');
END;
/

SET SERVEROUTPUT ON

-- Exercise 1
DECLARE
    var_ename VARCHAR(12);
    var_eno NUMBER(4) := 001;
BEGIN
    SELECT e.ename INTO var_ename
    FROM Emp e
    WHERE e.eno = var_eno;

    -- || is used to concatenate
    DBMS_OUTPUT.PUT_LINE('Name of the employee with eno: ' || var_eno || ' is ' || var_ename);
END;

-- Exercise 2
DECLARE
    current_salary NUMBER(8,2);
    var_eno NUMBER(4) := 001;
BEGIN
    SELECT e.salary INTO current_salary
    FROM Emp e
    WHERE e.eno = var_eno;

    IF (current_salary < 45000) THEN
        DBMS_OUTPUT.PUT_LINE('Current salary is very low');
    ELSIF (current_salary < 55000) THEN
        DBMS_OUTPUT.PUT_LINE('Current salary is low');
    ELSIF (current_salary < 65000) THEN
        DBMS_OUTPUT.PUT_LINE('Current salary is medium');
    ELSIF (current_salary < 75000) THEN
        DBMS_OUTPUT.PUT_LINE('Current salary is medium high');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Current salary is high');
    END IF;
END;

begin
  <<i_loop>> for i in 1 .. 10 loop
    <<j_loop>> for j in 1 .. 10 loop 
        dbms_output.put(to_char(j, '999')); 
        exit j_loop when j=i;
    end loop;
    dbms_output.new_line;
  end loop;
end; 


-- Exercise 3
BEGIN
 <<i_loop>> FOR i IN REVERSE 1 .. 9 LOOP
    <<j_loop>> FOR j IN 1 .. 9 LOOP 
        DBMS_OUTPUT.PUT(TO_CHAR(i, '999')); 
        EXIT j_loop WHEN j=i;
    END LOOP;
    DBMS_OUTPUT.new_line;
  END LOOP;
END;


-- Exercise 4
-- implicit cursor
DECLARE 
    CURSOR purchase_cur IS
        SELECT p.customer, p.company, p.quantity, p.purchaseDate
        FROM Puchase p;
    purchase_rec purchase_cur%ROWTYPE;
BEGIN
    FOR purchase_rec in purchase_cur LOOP
        IF ('1st January 2000') > purchase_rec.purchaseDate THEN
            UPDATE purchase p
            SET p.quantity = p.quantity + 150
            WHERE p.customer = purchase_rec.customer;
        ELSIF ('1st January 2001') > purchase_rec.purchaseDate THEN
            UPDATE purchase p
            SET p.quantity = p.quantity + 100
            WHERE p.customer = purchase_rec.customer;
        ELSIF ('1st January 2002')> purchase_rec.purchaseDate THEN
            UPDATE purchase p
            SET p.quantity = p.quantity + 100
            WHERE p.customer = purchase_rec.customer;
        END  IF;
    END LOOP;
END;

-- explicit cursor not sure
DECLARE 
    CURSOR purchase_cur IS
        SELECT p.customer, p.company, p.quantity, p.purchaseDate
        FROM Puchase p;
    purchase_rec purchase_cur%ROWTYPE;
BEGIN
    IF NOT purchase_cur%ISOPEN THEN
        OPEN purchase_cur;
    END IF;


    WHILE purchase_cur%FOUND LOOP
        FETCH purchase_cur INTO purchase_rec;

        IF ('1st January 2000') > purchase_rec.purchaseDate THEN
            UPDATE purchase p
            SET p.quantity = p.quantity + 150
            WHERE p.customer = purchase_rec.customer;
        ELSIF ('1st January 2001') > purchase_rec.purchaseDate THEN
            UPDATE purchase p
            SET p.quantity = p.quantity + 100
            WHERE p.customer = purchase_rec.customer;
        ELSIF ('1st January 2002')> purchase_rec.purchaseDate THEN
            UPDATE purchase p
            SET p.quantity = p.quantity + 100
            WHERE p.customer = purchase_rec.customer;
        END  IF;
    END LOOP;

    CLOSE purchase_cur;
END;