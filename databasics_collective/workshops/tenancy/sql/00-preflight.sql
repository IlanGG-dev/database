SET PAGESIZE 100
SET LINESIZE 180

PROMPT Current workshop objects

SELECT object_type, object_name, status
FROM   user_objects
WHERE  object_name LIKE 'DBC\_%' ESCAPE '\'
ORDER  BY object_type, object_name;

PROMPT Existing workshop tables and estimated rows

SELECT table_name, num_rows, last_analyzed
FROM   user_tables
WHERE  table_name LIKE 'DBC\_%' ESCAPE '\'
ORDER  BY table_name;
