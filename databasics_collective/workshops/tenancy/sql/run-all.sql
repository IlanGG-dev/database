WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

@@00-preflight.sql
@@01-create-schema.sql
@@02-load-sample-data.sql
@@03-create-schema-objects.sql
@@04-verify.sql

PROMPT Databasics Collective setup complete.
