SET SERVEROUTPUT ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

DECLARE
    PROCEDURE run_ddl(p_statement IN VARCHAR2, p_object IN VARCHAR2) IS
    BEGIN
        EXECUTE IMMEDIATE p_statement;
        DBMS_OUTPUT.PUT_LINE('Created ' || p_object || '.');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -955 THEN
                DBMS_OUTPUT.PUT_LINE(p_object || ' already exists.');
            ELSE
                RAISE;
            END IF;
    END run_ddl;
BEGIN
    run_ddl(q'[
        CREATE TABLE dbc_departments (
            department_id   NUMBER(4),
            department_name VARCHAR2(100) NOT NULL,
            location        VARCHAR2(100) NOT NULL,
            CONSTRAINT dbc_departments_pk PRIMARY KEY (department_id),
            CONSTRAINT dbc_departments_name_uk UNIQUE (department_name)
        )
    ]', 'DBC_DEPARTMENTS');

    run_ddl(q'[
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
        )
    ]', 'DBC_STUDENTS');

    run_ddl(q'[
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
        )
    ]', 'DBC_COURSES');

    run_ddl(q'[
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
        )
    ]', 'DBC_ENROLLMENTS');

    run_ddl(q'[
        CREATE SEQUENCE dbc_student_seq
            START WITH 1100
            INCREMENT BY 1
            NOCYCLE
            CACHE 20
    ]', 'DBC_STUDENT_SEQ');
END;
/

PROMPT Schema creation complete.
