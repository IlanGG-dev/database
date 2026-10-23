# Future Green-Button Plan

## Goal

Provision an Oracle Autonomous Database environment that lets a beginner open Database Actions and start the workshop with predictable access and data.

## Recommended Modes

### Learner build mode

Provision the database and workshop user, but do not create the `DBC_` objects. Learners create the schema during Labs 3 through 5. This mode preserves the learning sequence.

### Demo-ready mode

Provision the database and workshop user, then run `workshops/tenancy/sql/run-all.sql`. Learners begin with a populated schema and focus on querying, transactions, schema objects, and indexes.

## Deployment Contract

1. Provision or reuse an Autonomous Database suitable for SQL practice.
2. Create a dedicated workshop user with quota and privileges to create tables, views, sequences, synonyms, and indexes in its own schema.
3. Provide Database Actions access for that user.
4. Run the SQL scripts with SQLcl from `workshops/tenancy/sql` when the operator selects demo-ready mode.
5. Run `workshops/tenancy/sql/04-verify.sql`. Stop if an expected object is missing.
6. Do not run `workshops/tenancy/sql/99-cleanup.sql` during provisioning.
7. Keep credentials, wallet files, OCIDs, and service names outside this repository.

## SQL Execution Order

1. `00-preflight.sql` reports existing workshop objects.
2. `01-create-schema.sql` creates missing tables and the sequence.
3. `02-load-sample-data.sql` uses `MERGE` so retries produce the same logical rows.
4. `03-create-schema-objects.sql` creates or replaces the view and synonym, then creates missing indexes.
5. `04-verify.sql` reports row counts, constraints, indexes, and a joined view result.

`run-all.sql` calls these scripts in order. The scripts limit their work to objects whose names start with `DBC_`.

## Reset Strategy

`99-cleanup.sql` is an explicit, optional reset script. It removes only the workshop objects and relies on the recycle bin for dropped tables. An operator should run it only when resetting a dedicated workshop schema. The automated deployment should prefer rerunning the idempotent creation and load scripts.

## Open Deployment Decisions

- Select the final Autonomous Database service and sizing for the event.
- Decide whether the green button creates one database per learner or shared databases with isolated users.
- Choose learner build mode or demo-ready mode.
- Add the final Resource Manager, OCI CLI, or orchestration layer after reviewers approve the tenancy pattern.
- Runtime-test the scripts with the database version and privileges used in production.

Estimated Time: Not applicable

## Acknowledgements

* **Author** - Oracle University Program
* **Last Updated By/Date** - Oracle University Program, October 2026
