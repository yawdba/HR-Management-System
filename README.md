# HR-Management-System

## Project Overview
The **HR Management System** is designed to manage employee records, payroll processing, leave tracking, and salary updates efficiently. It includes stored procedures, triggers, and views to streamline HR operations.

## Features
-  **Employee Management**: Store and manage employee details.
-  **Payroll Processing**: Calculate net salaries using stored procedures.
-  **Leave Tracking**: Monitor employees on leave with an HR-friendly view.
-  **Audit Logging**: Log salary changes automatically using triggers.

## Database Schema
The system consists of multiple tables, including:
- **Employees**: Stores employee details such as name, department, and status.
- **Departments**: Manages department details, including department id and names.
- **Salaries**: Tracks salary components like base salary, bonuses, and deductions.
- **Leaves**: Manages employee leave applications and approvals.
- **Payroll**: Logs payroll transactions after processing.


## Key SQL Components
The database includes:
- **Stored Procedures** for automated payroll processing.
- **Triggers** to log changes when salaries are updated.
- **Views** to provide HR with an overview of employees on leave.

## Getting Started

### Prerequisites
- Oracle SQL.
