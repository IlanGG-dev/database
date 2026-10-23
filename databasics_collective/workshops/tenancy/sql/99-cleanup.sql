SET SERVEROUTPUT ON
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

PROMPT WARNING: This script removes the DBC_ workshop objects from the current schema.

DECLARE
    PROCEDURE drop_object(
        p_statement       IN VARCHAR2,
        p_missing_sqlcode IN NUMBER,
        p_object_name     IN VARCHAR2
    ) IS
    BEGIN
        EXECUTE IMMEDIATE p_statement;
        DBMS_OUTPUT.PUT_LINE('Dropped ' || p_object_name || '.');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = p_missing_sqlcode THEN
                DBMS_OUTPUT.PUT_LINE(p_object_name || ' does not exist.');
            ELSE
                RAISE;
            END IF;
    END drop_object;
BEGIN
    drop_object('DROP SYNONYM dbc_schedule', -1434, 'DBC_SCHEDULE');
    drop_object('DROP VIEW dbc_student_schedule_v', -942, 'DBC_STUDENT_SCHEDULE_V');
    drop_object('DROP SEQUENCE dbc_student_seq', -2289, 'DBC_STUDENT_SEQ');
    drop_object('DROP TABLE dbc_enrollments CASCADE CONSTRAINTS', -942, 'DBC_ENROLLMENTS');
    drop_object('DROP TABLE dbc_courses CASCADE CONSTRAINTS', -942, 'DBC_COURSES');
    drop_object('DROP TABLE dbc_students CASCADE CONSTRAINTS', -942, 'DBC_STUDENTS');
    drop_object('DROP TABLE dbc_departments CASCADE CONSTRAINTS', -942, 'DBC_DEPARTMENTS');
END;
/

PROMPT Cleanup complete. Dropped tables remain recoverable through the recycle bin.
