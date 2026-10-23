# Databasics Collective Topic Coverage Report

## Scope

This report compares the 90-minute workshop with the eight supplied Oracle Database presentations. It also identifies topics found only in green-button assets.

### Coverage labels

- **Strong**: The workshop teaches the main source topics through explanation and practice.
- **Partial**: The workshop covers the beginner essentials but leaves out important source topics.
- **Light**: The workshop mentions the area but does not teach it.

## Summary

The workshop covers relational design, constraints, core DDL and DML, transactions, schema objects, and B-tree indexes. Learners build one university schema from start to finish.

The workshop now adds compact context for architecture, deployment, relationships, table changes, concurrency, schema objects, and index choices. It keeps the same five labs and 90-minute estimate.

## Coverage by source presentation

| Source topic | Coverage | Included in the workshop | Missing or deferred |
| --- | --- | --- | --- |
| Introduction to Oracle Database | **Partial** | Database and DBMS concepts, instance and database, Autonomous Database, schemas, SQL, deployment choices, and common data models | Oracle Database history, business challenges, detailed converged-platform positioning, the full tool catalog, and industry examples |
| Oracle Database Overview and Architecture | **Partial** | Database, instance, memory and background processes, service, CDB, PDB, schema, managed-service boundary, and data dictionary inspection | Data files, control files, redo logs, parameter files, diagnostics, startup and recovery, and deeper multitenant administration |
| Schemas, Relationships, and Constraints | **Strong** | Redundancy, normalization, keys, all core constraints, one-to-one, one-to-many, many-to-many, a junction table, and modeling stages | A graphical ERD exercise and formal normal forms beyond the practical example |
| Create, Modify, and Manage Data Structures | **Strong for beginners** | DDL purpose, `CREATE TABLE`, common data types, defaults, constraints, `ALTER TABLE`, temporary column add and drop, auto-commit, and dictionary inspection | Hands-on `RENAME` and object `DROP`, read-only tables, advanced types, JSON collections, and SQL/JSON |
| Data Actions: Select, Insert, Update, Delete | **Strong** | Core DML, joins, aggregation, transaction control, safe predicates, row locks, consistent reads, and the purpose of `MERGE` | Hands-on `MERGE`, multi-session concurrency practice, lock-free reservations, duality views, and JSON data changes |
| Introduction to Schema Objects | **Strong for beginners** | Tables, views, sequences, private synonyms, B-tree indexes, plus concise materialized-view and public-synonym distinctions | Creating and refreshing materialized views, public-synonym administration, and deeper dependency or privilege concepts |
| Database Deployment Options | **Partial** | Autonomous Database as the selected environment plus a concise comparison with on-premises, Exadata, Cloud@Customer, and cloud services | Detailed platform selection, sovereignty and residency design, multicloud architecture, and deployment case studies |
| Indexes in Oracle Database | **Partial** | Index purpose, B-tree creation, foreign-key indexes, optimizer choice, bitmap and function-based use cases, specialized indexes, and automatic-indexing context | Hands-on advanced index types, execution-plan measurement, index lifecycle operations, and edition or version details |

## Strengthening completed without extending the workshop

1. Lab 1 now connects Autonomous Database, the instance, database, CDB, PDB, schema, and deployment choices.
2. Lab 2 now compares all three common relationship types and names the modeling stages.
3. Lab 3 now includes a reversible `ALTER TABLE` exercise and briefly identifies advanced data types.
4. Lab 4 now explains row locks, consistent reads, and why deployment scripts use `MERGE`.
5. Lab 5 now distinguishes regular and materialized views, private and public synonyms, and major index categories.

## Topics better suited to a follow-up workshop

- Physical storage, crash recovery, and diagnostic architecture
- Oracle Database history and detailed product positioning
- JSON collections, JSON-relational duality views, and SQL/JSON
- Vector, spatial, graph, XML, and other specialized data models
- Advanced and domain-specific index types
- Automatic indexing and index lifecycle management
- Materialized views and refresh strategies
- Detailed deployment architecture and platform selection

## Green-button readiness note

The support assets separate learner build mode from demo-ready mode. Lab 4 now explains why those scripts use `MERGE`. Cleanup remains an instructor or operator action.

## Overall assessment

The strengthened draft keeps the right beginner core. It closes the clearest source gaps without adding a lab or changing the estimated time. Advanced topics remain better suited to a second workshop.

Estimated Time: Not applicable

## Acknowledgements

* **Author** - Oracle University Program
* **Last Updated By/Date** - Oracle University Program, October 2026
