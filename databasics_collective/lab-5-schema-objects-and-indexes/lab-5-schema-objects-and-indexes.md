# Lab 5: Add Schema Objects and Indexes

## Introduction

Tables hold data, but other schema objects make that data easier to generate, query, name, and locate. In this lab, you will create a sequence, view, synonym, and three B-tree indexes. You will then inspect the finished schema.

### Objectives

In this lab, you will:

- Generate numeric values with a sequence.
- Present joined data through a view.
- Create a private synonym for a schema object.
- Add B-tree indexes that support foreign key joins.
- Inspect schema objects and indexes.

Estimated Time: 20 minutes

## Task 1: Create and use a sequence

1. Check whether the sequence already exists.

    ```sql
    SELECT sequence_name, last_number
    FROM   user_sequences
    WHERE  sequence_name = 'DBC_STUDENT_SEQ';
    ```

2. If the query returns no rows, create the sequence.

    ```sql
    CREATE SEQUENCE dbc_student_seq
        START WITH 1100
        INCREMENT BY 1
        NOCYCLE
        CACHE 20;
    ```

3. Read the next value without inserting a row.

    ```sql
    SELECT dbc_student_seq.NEXTVAL AS next_student_id
    FROM   dual;
    ```

4. A sequence generates unique numbers efficiently. Oracle does not roll sequence values back, so gaps are normal and do not indicate missing table rows.

## Task 2: Create a view and synonym

1. Create a view that stores the four-table query definition.

    ```sql
    CREATE OR REPLACE VIEW dbc_student_schedule_v AS
    SELECT s.student_id,
           s.first_name || ' ' || s.last_name AS student_name,
           d.department_name,
           c.course_code,
           c.course_title,
           e.enrolled_on,
           e.grade
    FROM   dbc_students s
    JOIN   dbc_departments d ON d.department_id = s.department_id
    JOIN   dbc_enrollments e ON e.student_id = s.student_id
    JOIN   dbc_courses c ON c.course_id = e.course_id;
    ```

2. Create a shorter private synonym for the view.

    ```sql
    CREATE OR REPLACE SYNONYM dbc_schedule
    FOR dbc_student_schedule_v;
    ```

3. Query through the synonym.

    ```sql
    SELECT student_name, department_name, course_code, course_title
    FROM   dbc_schedule
    ORDER  BY student_name, course_code;
    ```

4. A view stores a query. A materialized view stores results and must refresh them; this workshop does not create one.

5. `DBC_SCHEDULE` is private to your schema. A public synonym is database-wide and needs administrative privileges.

## Task 3: Add indexes for common joins

1. Check which indexes already exist.

    ```sql
    SELECT table_name, index_name, uniqueness
    FROM   user_indexes
    WHERE  table_name LIKE 'DBC\_%' ESCAPE '\'
    ORDER  BY table_name, index_name;
    ```

2. If the following indexes are absent, create them.

    ```sql
    CREATE INDEX dbc_students_dept_ix
        ON dbc_students (department_id);

    CREATE INDEX dbc_courses_dept_ix
        ON dbc_courses (department_id);

    CREATE INDEX dbc_enroll_course_ix
        ON dbc_enrollments (course_id);
    ```

3. These B-tree indexes support joins and lookups on foreign key columns. The primary key on `DBC_ENROLLMENTS` already begins with `STUDENT_ID`, so this lab adds a separate index that begins with `COURSE_ID`.

4. Use the workload to choose an index type.

    | Index type | Typical use |
    | --- | --- |
    | B-tree | Lookups, ranges, joins, and frequently changed data |
    | Bitmap | Low-cardinality, read-heavy analytics; avoid frequent DML |
    | Function-based | Expressions such as `UPPER(last_name)` |
    | Specialized | Text, spatial, JSON, graph, or vector searches |

5. The optimizer may choose a full table scan for this small dataset. It uses an index only when that access path costs less.

6. Autonomous Database can evaluate B-tree indexes automatically. This lab creates them manually to teach index selection.

## Task 4: Inspect the finished schema

1. Count the workshop objects by type.

    ```sql
    SELECT object_type, COUNT(*) AS object_count
    FROM   user_objects
    WHERE  object_name LIKE 'DBC\_%' ESCAPE '\'
    GROUP  BY object_type
    ORDER  BY object_type;
    ```

2. List the indexed columns in order.

    ```sql
    SELECT i.table_name,
           i.index_name,
           c.column_position,
           c.column_name
    FROM   user_indexes i
    JOIN   user_ind_columns c ON c.index_name = i.index_name
    WHERE  i.table_name LIKE 'DBC\_%' ESCAPE '\'
    ORDER  BY i.table_name, i.index_name, c.column_position;
    ```

3. Run the schedule query one last time.

    ```sql
    SELECT student_name, department_name, course_code, course_title
    FROM   dbc_student_schedule_v
    ORDER  BY student_name, course_code;
    ```

4. You now have a normalized schema with data, constraints, a sequence, a view, a synonym, and indexes. Keep the objects for review unless your instructor asks you to reset the dedicated workshop schema.

## Acknowledgements

* **Author** - Oracle University Program
* **Last Updated By/Date** - Oracle University Program, October 2026
