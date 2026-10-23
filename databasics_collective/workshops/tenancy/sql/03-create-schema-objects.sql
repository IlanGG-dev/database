SET SERVEROUTPUT ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

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

CREATE OR REPLACE SYNONYM dbc_schedule FOR dbc_student_schedule_v;

DECLARE
    PROCEDURE create_index_if_missing(
        p_index_name IN VARCHAR2,
        p_statement  IN VARCHAR2
    ) IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO   v_count
        FROM   user_indexes
        WHERE  index_name = UPPER(p_index_name);

        IF v_count = 0 THEN
            EXECUTE IMMEDIATE p_statement;
            DBMS_OUTPUT.PUT_LINE('Created ' || UPPER(p_index_name) || '.');
        ELSE
            DBMS_OUTPUT.PUT_LINE(UPPER(p_index_name) || ' already exists.');
        END IF;
    END create_index_if_missing;
BEGIN
    create_index_if_missing(
        'dbc_students_dept_ix',
        'CREATE INDEX dbc_students_dept_ix ON dbc_students (department_id)'
    );
    create_index_if_missing(
        'dbc_courses_dept_ix',
        'CREATE INDEX dbc_courses_dept_ix ON dbc_courses (department_id)'
    );
    create_index_if_missing(
        'dbc_enroll_course_ix',
        'CREATE INDEX dbc_enroll_course_ix ON dbc_enrollments (course_id)'
    );
END;
/

PROMPT Schema objects and indexes complete.
