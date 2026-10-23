WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

MERGE INTO dbc_departments d
USING (
    SELECT 10 department_id, 'Computer Science' department_name, 'North Campus' location FROM dual
    UNION ALL
    SELECT 20, 'Business', 'Central Campus' FROM dual
    UNION ALL
    SELECT 30, 'Design', 'Arts Campus' FROM dual
) s
ON (d.department_id = s.department_id)
WHEN MATCHED THEN UPDATE SET
    d.department_name = s.department_name,
    d.location = s.location
WHEN NOT MATCHED THEN INSERT
    (department_id, department_name, location)
VALUES
    (s.department_id, s.department_name, s.location);

MERGE INTO dbc_students d
USING (
    SELECT 1001 student_id, 'Ana' first_name, 'Torres' last_name,
           'ana.torres@example.edu' email, 10 department_id,
           DATE '2026-08-17' enrollment_date, 'ACTIVE' status FROM dual
    UNION ALL
    SELECT 1002, 'Leo', 'Kim', 'leo.kim@example.edu', 10, DATE '2026-08-17', 'ACTIVE' FROM dual
    UNION ALL
    SELECT 1003, 'Maya', 'Singh', 'maya.singh@example.edu', 20, DATE '2026-08-18', 'ACTIVE' FROM dual
    UNION ALL
    SELECT 1004, 'Daniel', 'Cruz', 'daniel.cruz@example.edu', 30, DATE '2026-08-18', 'ACTIVE' FROM dual
) s
ON (d.student_id = s.student_id)
WHEN MATCHED THEN UPDATE SET
    d.first_name = s.first_name,
    d.last_name = s.last_name,
    d.email = s.email,
    d.department_id = s.department_id,
    d.enrollment_date = s.enrollment_date,
    d.status = s.status
WHEN NOT MATCHED THEN INSERT
    (student_id, first_name, last_name, email, department_id, enrollment_date, status)
VALUES
    (s.student_id, s.first_name, s.last_name, s.email, s.department_id,
     s.enrollment_date, s.status);

MERGE INTO dbc_courses d
USING (
    SELECT 2001 course_id, 'DB101' course_code,
           'Database Fundamentals' course_title, 3 credits, 10 department_id FROM dual
    UNION ALL
    SELECT 2002, 'DV110', 'Data Visualization', 3, 30 FROM dual
    UNION ALL
    SELECT 2003, 'BA120', 'Business Analytics', 3, 20 FROM dual
    UNION ALL
    SELECT 2004, 'SQL201', 'SQL for Applications', 4, 10 FROM dual
) s
ON (d.course_id = s.course_id)
WHEN MATCHED THEN UPDATE SET
    d.course_code = s.course_code,
    d.course_title = s.course_title,
    d.credits = s.credits,
    d.department_id = s.department_id
WHEN NOT MATCHED THEN INSERT
    (course_id, course_code, course_title, credits, department_id)
VALUES
    (s.course_id, s.course_code, s.course_title, s.credits, s.department_id);

MERGE INTO dbc_enrollments d
USING (
    SELECT 1001 student_id, 2001 course_id, DATE '2026-09-01' enrolled_on, CAST(NULL AS VARCHAR2(2)) grade FROM dual
    UNION ALL
    SELECT 1001, 2004, DATE '2026-09-01', NULL FROM dual
    UNION ALL
    SELECT 1002, 2001, DATE '2026-09-02', NULL FROM dual
    UNION ALL
    SELECT 1003, 2003, DATE '2026-09-02', NULL FROM dual
    UNION ALL
    SELECT 1004, 2002, DATE '2026-09-03', NULL FROM dual
) s
ON (d.student_id = s.student_id AND d.course_id = s.course_id)
WHEN MATCHED THEN UPDATE SET
    d.enrolled_on = s.enrolled_on,
    d.grade = s.grade
WHEN NOT MATCHED THEN INSERT
    (student_id, course_id, enrolled_on, grade)
VALUES
    (s.student_id, s.course_id, s.enrolled_on, s.grade);

COMMIT;

PROMPT Sample data load complete.
