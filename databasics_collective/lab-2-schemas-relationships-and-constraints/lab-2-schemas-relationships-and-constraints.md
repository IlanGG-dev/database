# Lab 2: Design a Relational Schema

## Introduction

A useful database model stores each fact once and links related facts with keys. In this lab, you will turn a flat student roster into four related tables. The design will support data integrity and the SQL exercises in later labs.

### Objectives

In this lab, you will:

- Find repeated facts in a flat data set.
- Separate those facts into related tables.
- Choose primary keys and foreign keys.
- Define constraints for required values and business rules.

Estimated Time: 15 minutes

## Task 1: Find the repeated facts

1. Consider a single table with these columns:

    ```text
    STUDENT_ID, STUDENT_NAME, EMAIL, DEPARTMENT_NAME, DEPARTMENT_LOCATION,
    COURSE_CODE, COURSE_TITLE, CREDITS, ENROLLED_ON, GRADE
    ```

2. Identify the facts that repeat when a student takes several courses. The student name and department would appear once for every enrollment. Course details would repeat for every student in the course.

3. Note the risk: changing a department location would require updates to many rows. Missing one row would leave conflicting values.

## Task 2: Separate the entities

1. Use four tables to store each type of fact:

    | Table | Purpose | Primary key |
    | --- | --- | --- |
    | `DBC_DEPARTMENTS` | One row per department | `DEPARTMENT_ID` |
    | `DBC_STUDENTS` | One row per student | `STUDENT_ID` |
    | `DBC_COURSES` | One row per course | `COURSE_ID` |
    | `DBC_ENROLLMENTS` | One row per student and course pair | `STUDENT_ID`, `COURSE_ID` |

2. Read this compact entity relationship diagram.

    ```text
    DBC_DEPARTMENTS 1 ----- many DBC_STUDENTS
    DBC_DEPARTMENTS 1 ----- many DBC_COURSES
    DBC_STUDENTS    1 ----- many DBC_ENROLLMENTS
    DBC_COURSES     1 ----- many DBC_ENROLLMENTS
    ```

3. Explain why `DBC_ENROLLMENTS` resolves the many-to-many relationship between students and courses. One student can take many courses, and one course can contain many students.

4. A one-to-one relationship links one row to at most one row, such as a student and one current identity card. The model above also shows one-to-many and many-to-many relationships.

## Task 3: Choose the constraints

1. Match each rule to an Oracle constraint:

    | Rule | Constraint |
    | --- | --- |
    | Every row has a stable identifier | `PRIMARY KEY` |
    | Each student email and course code is different | `UNIQUE` |
    | Names, titles, and required relationships must have a value | `NOT NULL` |
    | A student or course must reference an existing department | `FOREIGN KEY` |
    | Status, grade, and credit values must stay in an allowed range | `CHECK` |

2. Review the physical model that you will create in the next lab.

    ```text
    DBC_DEPARTMENTS(department_id, department_name, location)
    DBC_STUDENTS(student_id, first_name, last_name, email,
                 department_id, enrollment_date, status)
    DBC_COURSES(course_id, course_code, course_title, credits, department_id)
    DBC_ENROLLMENTS(student_id, course_id, enrolled_on, grade)
    ```

3. Confirm that every foreign key points to a primary key and that the enrollment table uses both foreign keys as its primary key.

4. The entities form a conceptual model. Keys and relationships form the logical model. The next lab creates the Oracle physical model.

## Task 4: Prepare for deployment

1. Note the naming boundary: every workshop object starts with `DBC_`. Future automation can find these objects without changing unrelated schema content.

2. Use learner build mode to create the objects yourself. A future demo-ready deployment can run the repeatable scripts in `workshops/tenancy/sql`.

## Acknowledgements

* **Author** - Oracle University Program
* **Last Updated By/Date** - Oracle University Program, October 2026
