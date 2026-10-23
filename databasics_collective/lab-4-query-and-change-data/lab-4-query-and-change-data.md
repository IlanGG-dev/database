# Lab 4: Query and Change Data Safely

## Introduction

Data manipulation language statements read and change table rows. In this lab, you will load a small dataset, query related tables, and use a savepoint to test changes without keeping them.

### Objectives

In this lab, you will:

- Insert related rows in the correct order.
- Filter, sort, join, and aggregate data with `SELECT`.
- Use targeted `UPDATE` and `DELETE` statements.
- Control a transaction with `SAVEPOINT`, `ROLLBACK`, and `COMMIT`.

Estimated Time: 25 minutes

## Task 1: Load the sample data

1. If your environment already contains rows in the `DBC_` tables, continue to Task 2. Otherwise, insert the departments.

    ```sql
    INSERT ALL
        INTO dbc_departments VALUES (10, 'Computer Science', 'North Campus')
        INTO dbc_departments VALUES (20, 'Business', 'Central Campus')
        INTO dbc_departments VALUES (30, 'Design', 'Arts Campus')
    SELECT 1 FROM dual;
    ```

2. Insert the students.

    ```sql
    INSERT ALL
        INTO dbc_students
            (student_id, first_name, last_name, email, department_id,
             enrollment_date, status)
        VALUES
            (1001, 'Ana', 'Torres', 'ana.torres@example.edu', 10,
             DATE '2026-08-17', 'ACTIVE')
        INTO dbc_students
            (student_id, first_name, last_name, email, department_id,
             enrollment_date, status)
        VALUES
            (1002, 'Leo', 'Kim', 'leo.kim@example.edu', 10,
             DATE '2026-08-17', 'ACTIVE')
        INTO dbc_students
            (student_id, first_name, last_name, email, department_id,
             enrollment_date, status)
        VALUES
            (1003, 'Maya', 'Singh', 'maya.singh@example.edu', 20,
             DATE '2026-08-18', 'ACTIVE')
        INTO dbc_students
            (student_id, first_name, last_name, email, department_id,
             enrollment_date, status)
        VALUES
            (1004, 'Daniel', 'Cruz', 'daniel.cruz@example.edu', 30,
             DATE '2026-08-18', 'ACTIVE')
    SELECT 1 FROM dual;
    ```

3. Insert the courses and enrollments.

    ```sql
    INSERT ALL
        INTO dbc_courses VALUES (2001, 'DB101', 'Database Fundamentals', 3, 10)
        INTO dbc_courses VALUES (2002, 'DV110', 'Data Visualization', 3, 30)
        INTO dbc_courses VALUES (2003, 'BA120', 'Business Analytics', 3, 20)
        INTO dbc_courses VALUES (2004, 'SQL201', 'SQL for Applications', 4, 10)
    SELECT 1 FROM dual;

    INSERT ALL
        INTO dbc_enrollments VALUES (1001, 2001, DATE '2026-09-01', NULL)
        INTO dbc_enrollments VALUES (1001, 2004, DATE '2026-09-01', NULL)
        INTO dbc_enrollments VALUES (1002, 2001, DATE '2026-09-02', NULL)
        INTO dbc_enrollments VALUES (1003, 2003, DATE '2026-09-02', NULL)
        INTO dbc_enrollments VALUES (1004, 2002, DATE '2026-09-03', NULL)
    SELECT 1 FROM dual;

    COMMIT;
    ```

4. The commit makes the sample rows permanent and ends the transaction.

5. The demo-ready scripts use `MERGE` to update matching rows or insert missing rows. This makes repeated loads predictable.

## Task 2: Filter and sort rows

1. Find active students in the Computer Science department.

    ```sql
    SELECT student_id, first_name, last_name, email
    FROM   dbc_students
    WHERE  department_id = 10
      AND  status = 'ACTIVE'
    ORDER  BY last_name, first_name;
    ```

2. Change the filter to another department and run the query again.

## Task 3: Join related tables

1. Run a four-table join to show the courses for each student.

    ```sql
    SELECT s.first_name || ' ' || s.last_name AS student_name,
           d.department_name,
           c.course_code,
           c.course_title,
           e.enrolled_on
    FROM   dbc_students s
    JOIN   dbc_departments d ON d.department_id = s.department_id
    JOIN   dbc_enrollments e ON e.student_id = s.student_id
    JOIN   dbc_courses c ON c.course_id = e.course_id
    ORDER  BY student_name, c.course_code;
    ```

2. Count students in each course.

    ```sql
    SELECT c.course_code,
           c.course_title,
           COUNT(e.student_id) AS student_count
    FROM   dbc_courses c
    LEFT JOIN dbc_enrollments e ON e.course_id = c.course_id
    GROUP  BY c.course_code, c.course_title
    ORDER  BY c.course_code;
    ```

3. Notice how the foreign keys supply the join conditions. The tables store each department, student, and course once.

## Task 4: Test data changes inside a transaction

1. Oracle locks changed rows until `COMMIT` or `ROLLBACK`. Other sessions can read committed versions, but another writer on the same row may wait.

2. Create a savepoint, then insert, update, and delete specific rows.

    ```sql
    SAVEPOINT before_practice;

    INSERT INTO dbc_students
        (student_id, first_name, last_name, email, department_id,
         enrollment_date, status)
    VALUES
        (1999, 'Sam', 'Rivera', 'sam.rivera@example.edu', 10,
         SYSDATE, 'ACTIVE');

    UPDATE dbc_students
    SET    status = 'PAUSED'
    WHERE  student_id = 1002;

    DELETE FROM dbc_enrollments
    WHERE  student_id = 1004
      AND  course_id = 2002;
    ```

3. Check the pending changes before you commit them.

    ```sql
    SELECT student_id, first_name, last_name, status
    FROM   dbc_students
    WHERE  student_id IN (1002, 1999)
    ORDER  BY student_id;

    SELECT student_id, course_id
    FROM   dbc_enrollments
    WHERE  student_id = 1004;
    ```

4. Undo every change made after the savepoint.

    ```sql
    ROLLBACK TO before_practice;
    COMMIT;
    ```

5. Run the two verification queries again. Student `1999` should be absent, student `1002` should be active, and student `1004` should have an enrollment.

6. Use the same safety pattern for future experiments. Target rows with a `WHERE` clause, inspect the result, then choose `COMMIT` or `ROLLBACK`.

## Acknowledgements

* **Author** - Oracle University Program
* **Last Updated By/Date** - Oracle University Program, October 2026
