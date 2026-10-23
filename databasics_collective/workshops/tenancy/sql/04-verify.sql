SET PAGESIZE 100
SET LINESIZE 180

PROMPT Row counts

SELECT 'DBC_DEPARTMENTS' object_name, COUNT(*) row_count FROM dbc_departments
UNION ALL
SELECT 'DBC_STUDENTS', COUNT(*) FROM dbc_students
UNION ALL
SELECT 'DBC_COURSES', COUNT(*) FROM dbc_courses
UNION ALL
SELECT 'DBC_ENROLLMENTS', COUNT(*) FROM dbc_enrollments
ORDER BY object_name;

PROMPT Constraints

SELECT table_name, constraint_name, constraint_type, status
FROM   user_constraints
WHERE  table_name LIKE 'DBC\_%' ESCAPE '\'
ORDER  BY table_name, constraint_type, constraint_name;

PROMPT Indexes

SELECT table_name, index_name, uniqueness, status
FROM   user_indexes
WHERE  table_name LIKE 'DBC\_%' ESCAPE '\'
ORDER  BY table_name, index_name;

PROMPT Student schedule view

SELECT student_name, department_name, course_code, course_title
FROM   dbc_student_schedule_v
ORDER  BY student_name, course_code;
