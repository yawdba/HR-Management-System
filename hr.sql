create table Employees(
EmployeeID NUMBER,
FirstName VARCHAR2(25),
LastName VARCHAR2(25),
DOB DATE,
Gender VARCHAR2(10),
DepartmentID NUMBER,
HireDate DATE,
HireDate VARCHAR2(25),
Salary DECIMAL,
Status VARCHAR2(10)
);

create table Departments(
DepartmentID NUMBER,
DepartmentName VARCHAR2(25)
);

create table Salaries(
SalaryID NUMBER,
EmployeeID NUMBER,
DepartmentName VARCHAR2(25),
BaseSalary DECIMAL,
Bonus DECIMAL,
Deductions DECIMAL,
PayDate DATE
);

create table Leaves(
LeaveID NUMBER,
EmployeeID NUMBER,
LeaveType VARCHAR2(25),
StartDate DATE,
EndDate DATE,
Status VARCHAR2(25)
);

create table Promotions(
PromotionID NUMBER,
EmployeeID NUMBER,
OldJobTitle VARCHAR2(25),
NewJobTitle VARCHAR2(25),
EffectiveDate DATE
);



---Stored Procedure
create table Payroll(
EmployeeID NUMBER,
PayDate DATE,
NetSalary NUMBER
);


CREATE OR REPLACE PROCEDURE Process_Payroll(
    p_EmployeeID IN NUMBER
) AS
    v_BaseSalary  NUMBER;
    v_Bonus       NUMBER;
    v_Deductions  NUMBER;
    v_NetSalary   NUMBER;
BEGIN
    -- Retrieve salary details
    SELECT BaseSalary, Bonus, Deductions
    INTO v_BaseSalary, v_Bonus, v_Deductions
    FROM Salaries
    WHERE EmployeeID = p_EmployeeID;

    -- Calculate Net Salary
    v_NetSalary := v_BaseSalary + NVL(v_Bonus, 0) - NVL(v_Deductions, 0);

    -- Insert payroll record
    INSERT INTO Payroll (EmployeeID, PayDate, NetSalary)
    VALUES (p_EmployeeID, SYSDATE, v_NetSalary);

END Process_Payroll;
/


BEGIN
    FOR emp IN (SELECT EmployeeID FROM Employees WHERE Status = 'Active') LOOP
        Process_Payroll(emp.EmployeeID);
    END LOOP;
END;
/



---Trigger
create table Salary_Audit(
AuditID       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
EmployeeID    NUMBER,
OldSalary     NUMBER,
NewSalary     NUMBER,
ChangeDate    DATE DEFAULT SYSDATE,
ChangedBy     VARCHAR2(100)
);



CREATE OR REPLACE TRIGGER trg_Salary_Update
BEFORE UPDATE ON Salaries
FOR EACH ROW
BEGIN
    -- Log changes only if the salary is actually modified
    IF :OLD.BaseSalary <> :NEW.BaseSalary THEN
        INSERT INTO Salary_Audit (EmployeeID, OldSalary, NewSalary, ChangedBy)
        VALUES (:NEW.EmployeeID, :OLD.BaseSalary, :NEW.BaseSalary, USER);
    END IF;
END;
/


UPDATE Salaries 
SET BaseSalary = 9000 
WHERE EmployeeID = 5;



---View
CREATE OR REPLACE VIEW HR_Leave_Tracker AS
SELECT 
    e.EmployeeID,
    e.FirstName || ' ' || e.LastName AS EmployeeName,
    e.DepartmentID,
    d.DepartmentName,
    l.LeaveType,
    l.StartDate,
    l.EndDate,
    (l.EndDate - l.StartDate) AS LeaveDuration,
    l.Status
FROM Employees e
JOIN Leaves l ON e.EmployeeID = l.EmployeeID
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE l.Status = 'Approved'
ORDER BY l.StartDate;


