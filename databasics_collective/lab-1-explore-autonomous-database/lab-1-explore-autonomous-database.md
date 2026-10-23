# Lab 1: Explore Oracle Autonomous Database

## Introduction

Oracle Autonomous Database manages infrastructure tasks such as patching, backups, and routine tuning. You manage your schema, SQL, and application data. In this lab, you will identify your current database session and inspect the objects that belong to your user.

### Objectives

In this lab, you will:

- Identify your current user, schema, service, and container.
- Distinguish the database from the objects in your schema.
- Use data dictionary views to inspect your environment.
- Confirm whether workshop objects already exist.

Estimated Time: 10 minutes

## Task 1: Identify your database session

1. Sign in to Database Actions with your workshop user and open the SQL Worksheet.

2. Run this query.

    ```sql
    SELECT SYS_CONTEXT('USERENV', 'CURRENT_USER') AS current_user,
           SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS current_schema,
           SYS_CONTEXT('USERENV', 'SERVICE_NAME') AS service_name,
           SYS_CONTEXT('USERENV', 'CON_NAME') AS container_name
    FROM   dual;
    ```

3. Read the result. Your user owns a schema with the same name. The service connects your worksheet to the database, and the container identifies the pluggable database that holds your schema.

## Task 2: Inspect the database version

1. Run the following query.

    ```sql
    SELECT banner_full
    FROM   v$version
    WHERE  banner_full LIKE 'Oracle Database%';
    ```

2. Record the database version shown in the result. Version-specific behavior matters when you use newer features, but the SQL in this workshop uses common Oracle Database features.

## Task 3: Inspect your schema

1. List the tables that your user owns.

    ```sql
    SELECT table_name
    FROM   user_tables
    ORDER  BY table_name;
    ```

2. Count your objects by type.

    ```sql
    SELECT object_type, COUNT(*) AS object_count
    FROM   user_objects
    GROUP  BY object_type
    ORDER  BY object_type;
    ```

3. Check for objects from an earlier workshop run.

    ```sql
    SELECT object_type, object_name, status
    FROM   user_objects
    WHERE  object_name LIKE 'DBC\_%' ESCAPE '\'
    ORDER  BY object_type, object_name;
    ```

4. If the last query returns rows, ask your instructor whether the environment uses the demo-ready mode. Do not delete existing objects unless the instructor asks you to reset the dedicated workshop schema.

## Task 4: Connect the concepts

1. Review how the main layers fit together.

    | Layer | Meaning |
    | --- | --- |
    | Database | Managed data and recovery information |
    | Instance | Memory and processes that access the database |
    | CDB and PDB | A CDB hosts PDBs; your schema is inside a PDB |
    | Schema | Objects owned by one user |
    | Autonomous Database | Oracle manages the service; you manage schemas and SQL |

2. Oracle Database can run on-premises, on Exadata, through Cloud@Customer, or in cloud services. This workshop uses Autonomous Database to stay focused on SQL.

3. Oracle also supports JSON, spatial, graph, and vector data. This workshop starts with relational tables.

4. Continue when you can identify your schema, explain `USER_TABLES`, and describe what Autonomous Database manages.

## Acknowledgements

* **Author** - Oracle University Program
* **Last Updated By/Date** - Oracle University Program, October 2026
