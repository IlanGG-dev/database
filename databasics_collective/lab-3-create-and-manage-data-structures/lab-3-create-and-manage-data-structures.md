# Lab 3: Create and Manage Data Structures

## Introduction

Data definition language statements create and change schema objects. In this lab, you will use `CREATE TABLE` to build the four-table model and use data dictionary views to confirm the result.

### Objectives

In this lab, you will:

- Create tables with Oracle data types.
- Modify a table with `ALTER TABLE`.
- Add primary, unique, foreign key, and check constraints.
- Inspect table columns and constraints.
- Recognize how DDL affects transactions.

Estimated Time: 20 minutes

## Task 1: Create the department and student tables

1. Run the following statements as a script.

    ```sql
    CREATE TABLE dbc_departments (
        department_id   NUMBER(4),
        department_name VARCHAR2(100) NOT NULL,
        location        VARCHAR2(100) NOT NULL,
        CONSTRAINT dbc_departments_pk PRIMARY KEY (department_id),
        CONSTRAINT dbc_departments_name_uk UNIQUE (department_name)
    );

    CREATE TABLE dbc_students (
        student_id      NUMBER(6),
        first_name      VARCHAR2(50) NOT NULL,
        last_name       VARCHAR2(50) NOT NULL,
        email           VARCHAR2(150) NOT NULL,
        department_id   NUMBER(4) NOT NULL,
        enrollment_date DATE DEFAULT SYSDATE NOT NULL,
        status          VARCHAR2(12) DEFAULT 'ACTIVE' NOT NULL,
        CONSTRAINT dbc_students_pk PRIMARY KEY (student_id),
        CONSTRAINT dbc_students_email_uk UNIQUE (email),
        CONSTRAINT dbc_students_status_ck
            CHECK (status IN ('ACTIVE', 'PAUSED', 'GRADUATED')),
        CONSTRAINT dbc_students_dept_fk
            FOREIGN KEY (department_id)
            REFERENCES dbc_departments (department_id)
    );
    ```

2. Confirm that the result reports two successful DDL statements. If a table already exists, ask your instructor whether your environment uses demo-ready mode.

## Task 2: Create the course and enrollment tables

1. Run the next two statements as a script.

    ```sql
    CREATE TABLE dbc_courses (
        course_id      NUMBER(6),
        course_code    VARCHAR2(20) NOT NULL,
        course_title   VARCHAR2(120) NOT NULL,
        credits        NUMBER(1) NOT NULL,
        department_id  NUMBER(4) NOT NULL,
        CONSTRAINT dbc_courses_pk PRIMARY KEY (course_id),
        CONSTRAINT dbc_courses_code_uk UNIQUE (course_code),
        CONSTRAINT dbc_courses_credits_ck CHECK (credits BETWEEN 1 AND 6),
        CONSTRAINT dbc_courses_dept_fk
            FOREIGN KEY (department_id)
            REFERENCES dbc_departments (department_id)
    );

    CREATE TABLE dbc_enrollments (
        student_id     NUMBER(6),
        course_id      NUMBER(6),
        enrolled_on    DATE DEFAULT SYSDATE NOT NULL,
        grade          VARCHAR2(2),
        CONSTRAINT dbc_enrollments_pk PRIMARY KEY (student_id, course_id),
        CONSTRAINT dbc_enroll_student_fk
            FOREIGN KEY (student_id)
            REFERENCES dbc_students (student_id),
        CONSTRAINT dbc_enroll_course_fk
            FOREIGN KEY (course_id)
            REFERENCES dbc_courses (course_id),
        CONSTRAINT dbc_enroll_grade_ck
            CHECK (grade IN ('A', 'B', 'C', 'D', 'F') OR grade IS NULL)
    );
    ```

2. Notice the creation order. Parent tables must exist before a foreign key can reference them.

## Task 3: Inspect the columns

1. Query the data dictionary.

    ```sql
    SELECT table_name,
           column_id,
           column_name,
           data_type,
           data_length,
           nullable
    FROM   user_tab_columns
    WHERE  table_name LIKE 'DBC\_%' ESCAPE '\'
    ORDER  BY table_name, column_id;
    ```

2. Find one `NUMBER`, one `VARCHAR2`, and one `DATE` column. Check `NULLABLE` for a required column. Oracle also supports `JSON`, `VECTOR`, `CLOB`, and `BLOB`.

3. Add a temporary column.

    ```sql
    ALTER TABLE dbc_students
        ADD (preferred_name VARCHAR2(50));
    ```

4. Rerun the query from Step 1 and find `PREFERRED_NAME`. Then restore the planned design.

    ```sql
    ALTER TABLE dbc_students
        DROP COLUMN preferred_name;
    ```

## Task 4: Inspect the constraints

1. Run this query.

    ```sql
    SELECT table_name,
           constraint_name,
           constraint_type,
           status
    FROM   user_constraints
    WHERE  table_name LIKE 'DBC\_%' ESCAPE '\'
    ORDER  BY table_name, constraint_type, constraint_name;
    ```

2. Interpret the constraint types:

    - `P` identifies a primary key.
    - `R` identifies a foreign key.
    - `U` identifies a unique constraint.
    - `C` identifies a check constraint or a generated `NOT NULL` rule.

3. Remember that Oracle commits pending work before and after DDL, including `CREATE`, `ALTER`, `RENAME`, and `DROP`. Keep schema changes separate from transaction exercises when you need the option to roll back data changes.

## Acknowledgements

* **Author** - Oracle University Program
* **Last Updated By/Date** - Oracle University Program, October 2026
