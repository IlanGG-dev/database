# Lab 5: Add Schema Objects and Indexes

## Introduction

Tables hold data, but other schema objects make that data easier to generate, query, name, and locate. In this lab, you will create a sequence, view, synonym, and three B-tree indexes. You will then inspect the finished schema.

Each object solves a different problem:

| Object | Purpose |
| --- | --- |
| Sequence | Generates numeric values independently of a table |
| View | Gives a saved query a reusable table-like interface |
| Synonym | Provides another name for an existing object |
| Index | Gives Oracle an alternate path for locating rows |

### Objectives

In this lab, you will:

- Generate numeric values with a sequence.
- Present joined data through a view.
- Create a private synonym for a schema object.
- Add B-tree indexes that support foreign key joins.
- Inspect schema objects and indexes.

Estimated Time: 20 minutes

## Task 1: Create and use a sequence

A sequence lets many sessions request new numbers without first searching a table for the highest value. It remains separate from the table, so requesting a number does not insert a row.

1. Check whether the sequence already exists.

    ```sql
    <copy>
    SELECT sequence_name, last_number
    FROM   user_sequences
    WHERE  sequence_name = 'DBC_STUDENT_SEQ';
    </copy>
    ```

    This query checks sequence metadata in the current schema. A returned row means the sequence already exists. `LAST_NUMBER` reflects cached sequence metadata, so it may not equal the next value a session receives.

2. If the query returns no rows, create the sequence.

    ```sql
    <copy>
    CREATE SEQUENCE dbc_student_seq
        START WITH 1100
        INCREMENT BY 1
        NOCYCLE
        CACHE 20;
    </copy>
    ```

    This statement creates a number generator that starts at 1100 and increases by one. `NOCYCLE` prevents reuse after the sequence reaches its limit. `CACHE 20` keeps values in memory for faster access.

3. Read the next value without inserting a row.

    ```sql
    <copy>
    SELECT dbc_student_seq.NEXTVAL AS next_student_id
    FROM   dual;
    </copy>
    ```

    `NEXTVAL` asks the sequence for a new number and advances it. `DUAL` provides the single row needed to run the expression. The alias gives the output a clear column name.

4. A sequence generates unique numbers efficiently. Oracle does not roll sequence values back. Cached values can also be lost when a database instance stops. For these reasons, gaps are normal and do not indicate missing table rows.

## Task 2: Create a view and synonym

A regular view gives a useful query a stable name. Every query against the view reads current data from its base tables. A synonym only changes how you refer to an object; it does not grant privileges on that object.

1. Create a view that stores the four-table query definition.

    ```sql
    <copy>
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
    </copy>
    ```

    This statement saves the four-table query as a view. The view stores the query definition, not another copy of the rows. `CREATE OR REPLACE` creates the view or updates its definition when it already exists.

2. Create a shorter private synonym for the view.

    ```sql
    <copy>
    CREATE OR REPLACE SYNONYM dbc_schedule
    FOR dbc_student_schedule_v;
    </copy>
    ```

    This statement creates `DBC_SCHEDULE` as an alternate name for the view. The synonym does not store data or duplicate the view. It only provides a shorter object name inside the current schema.

3. Query through the synonym.

    ```sql
    <copy>
    SELECT student_name, department_name, course_code, course_title
    FROM   dbc_schedule
    ORDER  BY student_name, course_code;
    </copy>
    ```

    This query reads the view through its synonym. Oracle resolves `DBC_SCHEDULE` to the original view and runs the stored joins. The result lists courses in student and course order.

4. A regular view stores a query definition and reads current base-table data. A materialized view stores query results on disk. Those stored results must refresh after the base data changes; this workshop does not create one.

5. `DBC_SCHEDULE` is private to your schema. A public synonym is database-wide and needs administrative privileges.

## Task 3: Add indexes for common joins

A B-tree index stores ordered key values with row locations. It can reduce the work needed for selective searches and joins. However, every index uses storage and must change when indexed data changes. Create indexes for real access patterns rather than indexing every column.

1. Check which indexes already exist.

    ```sql
    <copy>
    SELECT table_name, index_name, uniqueness
    FROM   user_indexes
    WHERE  table_name LIKE 'DBC\_%' ESCAPE '\'
    ORDER  BY table_name, index_name;
    </copy>
    ```

    This query lists indexes on workshop tables in the current schema. It shows the table, index name, and uniqueness setting. The filter keeps names that begin with the literal `DBC_` prefix.

2. If the following indexes are absent, create them.

    ```sql
    <copy>
    CREATE INDEX dbc_students_dept_ix
        ON dbc_students (department_id);

    CREATE INDEX dbc_courses_dept_ix
        ON dbc_courses (department_id);

    CREATE INDEX dbc_enroll_course_ix
        ON dbc_enrollments (course_id);
    </copy>
    ```

    These statements create three standard B-tree indexes. Each index stores one foreign key column in sorted form. Oracle can use them for joins and targeted lookups when the optimizer estimates a lower cost.

3. These B-tree indexes support joins and lookups on foreign key columns. The primary key on `DBC_ENROLLMENTS` already begins with `STUDENT_ID`, so this lab adds a separate index that begins with `COURSE_ID`.

    Oracle normally creates or reuses an index for a primary key or unique constraint. It does not automatically index foreign key columns. This difference explains why you inspected the existing indexes before creating new ones.

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

Oracle records schema metadata in data dictionary views. Views beginning with `USER_` describe objects owned by the current user. These final queries confirm what the lab created instead of relying only on success messages.

1. Count the workshop objects by type.

    ```sql
    <copy>
    SELECT object_type, COUNT(*) AS object_count
    FROM   user_objects
    WHERE  object_name LIKE 'DBC\_%' ESCAPE '\'
    GROUP  BY object_type
    ORDER  BY object_type;
    </copy>
    ```

    This query reads workshop objects from `USER_OBJECTS`. `GROUP BY` gathers objects with the same type, and `COUNT` totals each group. The result summarizes tables, indexes, views, sequences, and other `DBC_` objects.

2. List the indexed columns in order.

    ```sql
    <copy>
    SELECT i.table_name,
           i.index_name,
           c.column_position,
           c.column_name
    FROM   user_indexes i
    JOIN   user_ind_columns c ON c.index_name = i.index_name
    WHERE  i.table_name LIKE 'DBC\_%' ESCAPE '\'
    ORDER  BY i.table_name, i.index_name, c.column_position;
    </copy>
    ```

    This query joins index details with their columns. `COLUMN_POSITION` shows the order of columns inside each index. That order matters because the first column usually controls which searches can use the index efficiently.

3. Run the schedule query one last time.

    ```sql
    <copy>
    SELECT student_name, department_name, course_code, course_title
    FROM   dbc_student_schedule_v
    ORDER  BY student_name, course_code;
    </copy>
    ```

    This final query confirms that the view still returns the complete schedule. It also shows that added indexes do not change query results. Indexes provide alternate access paths while the optimizer decides how to read the data.

4. You now have a normalized schema with data, constraints, a sequence, a view, a synonym, and indexes. Keep the objects for review unless your instructor asks you to reset the dedicated workshop schema.

## Acknowledgements

* **Author** - Oracle University Program
* **Last Updated By/Date** - Oracle University Program, October 2026
