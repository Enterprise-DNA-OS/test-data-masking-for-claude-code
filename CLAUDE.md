# Test Data Masking for Claude Code

A local masking desk for teams preparing exported Salesforce records for testing. It tracks field rules, test purposes, refreshes, masked copies, exceptions and review evidence. Read this file from AGENTS.md in every agent runtime.

## Working rules

- Every answer starts with current CLI output. Run readiness immediately before describing a run as reviewed.
- Never print raw source records in chat. Read only headers and counts for import planning.
- Imported files stay private. The program stores transformed values, not raw source values, but keep rules preserve values and require inspection.
- No network access, Salesforce mutation, email sending, permission grants or production-data deletion is part of this CLI.
- Actor and reviewer labels are attribution, not authentication. A different label is a house review check, not proof of identity.
- Do not accept a run on the operator's behalf unless the operator has inspected the output and supplied the exact decision and evidence.
- Inspect kept fields, identifiers, combinations of fields and relationship consistency. Replacement is not a certificate of anonymisation.
- Preserve applied migrations and append-only evidence. Use /customise for tested changes.
- Use an empty DATA_DIR and no DATABASE_URL for synthetic demos. Never seed an operational database.
- Read docs/compliance.md before interpreting compliance findings.

## Routing

- `/environments`: List test purposes, owners, refresh revisions and retention dates.
- `/rules`: Read every configured field treatment and reason.
- `/coverage`: Count kept, erased and replaced fields by object.
- `/runs`: Read the masking run register.
- `/datasets`: Reconcile processed objects and row counts.
- `/attention`: Review overdue work, unmasked refreshes and unreviewed runs.
- `/retention`: Review test-copy purpose and expiry.
- `/issues`: Read the exception register.
- `/reviews`: Read decisions and evidence references.
- `/activity`: Read the change record.
- `/kept-fields`: Inspect fields deliberately copied unchanged.
- `/readiness`: Recheck refresh, rules, retention, exceptions and review decisions.
- `/compliance`: Read record checks with the rules and limits in docs/compliance.md.
- `/run`: Read a run, its policy snapshot and reviews.
- `/add-environment`: Register an authorised test purpose, owner and retention review date.
- `/set-rule`: Set an explicit treatment for a field. A changed rule invalidates prior acceptance.
- `/refresh`: Record a fresh source copy and invalidate earlier review decisions.
- `/import`: Read docs/replace-cloud-compliance-datamasker.md, inspect headers without displaying raw values, test first, reconcile counts.
- `/review`: Inspect the actual masked output, kept fields and relationship consistency before recording the requested decision. Reviewer must differ from importer.
- `/log-issue`: Record an exception that blocks acceptance for this environment.
- `/close-issue`: Close only with operator-provided resolution evidence.
- `/export`: Write a complete private snapshot to a new file. Kept fields still require protection.
- `/export-csv`: Write masked objects to a new directory for inspection. Never load them into a live system.
- `/weekly-review`: Draft the weekly review from readiness, attention and compliance.
- `/draft-handover`: Draft a named environment handover without sending or granting access.
- `/help`: Show supported commands and flags.
- `/customise`: add fields or rules with a tested migration.
- `/new-view`: add a read-only report.

## Files

The CLI is scripts/masking.mjs. Migrations and seed data live under supabase. DATABASE_URL selects PostgreSQL, otherwise PGlite persists under .data/db. brand.json controls documents and views. No front end is required. All flags use --name=value.

Omni by Enterprise DNA installs, customises and runs this desk: https://enterprisedna.co/omni/book/?offer=replace-software&utm_campaign=cloud-compliance-datamasker
