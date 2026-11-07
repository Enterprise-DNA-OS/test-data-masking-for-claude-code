# Test Data Masking for Claude Code

Turn exported Salesforce records into test copies with explicit field rules, a review trail and a named owner. Keep the masking rules and evidence in a database you own.

## Three ways to own it

- **Do it yourself:** use the MIT-licensed base with Claude Code, Codex, OpenCode or Cursor. Hosting and your coding agent are separate costs.
- **We customise it:** Enterprise DNA maps your fields and rules, brings your exported records across, and adds your connections, a web front end or another stack where needed. One setup fee, then a retainer.
- **We run it for you:** Omni by Enterprise DNA installs and operates your version, manages access and backups, and keeps the review process working. One setup fee, then a retainer.

[Book a 30-minute call with Sam](https://enterprisedna.co/omni/book/?offer=replace-software&utm_source=github&utm_medium=readme&utm_campaign=cloud-compliance-datamasker).

## The subscription being compared

Cloud Compliance's [pricing page](https://cloudcompliance.app/pricing), checked 7 November 2026, lists DataMasker at $6.99 per user monthly with a $19,999 annual minimum. The page does not specify currency. Other vendor pages show different figures. Confirm a current quote. This is a published minimum, not evidence of an Enterprise DNA customer's invoice.

## Try the synthetic demo

Node 20 or newer. No cloud account is required.

```sh
npm install
npm test
npm run demo
npm run masking -- attention
npm run masking -- readiness --json
npm run view
npm run docs
```

The repeatable demo has three test environments, two five-record masking runs, an expired review date, an overdue exception and an environment with no run. All source records are invented. Use a separate empty DATA_DIR for real work. DATABASE_URL selects PostgreSQL, otherwise the local PGlite database lives under .data/db.

## What the desk does

Every imported column needs a rule. Erase blanks a value, token replaces it with a random identifier, email produces an address under example.invalid, and keep copies a value with a recorded justification. Matching source values in the same token domain share a replacement within one batch, so Account.Id and Contact.AccountId stay related when their rules share a domain. New runs generate new replacements. There is no reverse lookup store.

Import accepts a directory of Salesforce object CSV files. It checks unique nonempty Id values per object and rejects malformed files or unclassified fields before writing. A whole directory is one transaction. Repeating the identical batch under the same refresh and rules is a no-op. Raw source values are handled in memory and are not stored, except values deliberately copied by keep rules. Input files and operating-system memory remain the operator's responsibility.

Runs store counts, source hashes and the exact rules used. Reviews require another operator label and a source evidence reference. Changed rules, a new refresh, an expired retention date or open exceptions prevent acceptance. Readiness recalculates those conditions for earlier decisions. It does not inspect access controls or certify anonymity.

This is a trusted local operator tool. Row-level security and revoked PUBLIC privileges restrict default database access. Database owners can bypass controls. Actor labels are not authenticated identities. Real deployments need access controls, encrypted storage and backups appropriate to their data.

## Recurring jobs

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
- `/customise`: add a field or change a rule through a tested migration.
- `/new-view`: build another read-only report.

All CLI commands support --json, case-insensitive name matching and partial IDs. Ambiguous names list matches and exit 1. Run help for exact flags.

## Ten questions to ask your records

1. Which refreshes have no masking run yet? (`attention`)
2. Which runs were reviewed against rules we have since changed? (`readiness`)
3. Which copies have passed their retention review date? (`retention`)
4. Which fields are deliberately kept and why? (`kept-fields`)
5. Who has unresolved work before a test copy can be accepted? (`issues`)
6. How many fields are erased, replaced or kept for each object? (`coverage`)
7. Which run contains each imported object and how many records? (`datasets`)
8. Who accepted or rejected each run and what evidence did they record? (`reviews`)
9. Which test purposes and owners sit behind stored copies? (`environments`)
10. Who changed the rules or recorded a refresh? (`activity`)

These analyses run today. They are not a claim that no vendor report can answer the same question. Cross-run rules and your own review process make the answers specific to your business.

## Your first hour: ten things to ask for

1. Put our name and colours in brand.json.
2. Show copies whose retention review is overdue.
3. Show all fields copied unchanged and their reasons.
4. List the fields in an export without showing personal values.
5. Draft explicit masking rules for those fields.
6. Test an import before storing transformed copies.
7. Reconcile source and imported object counts.
8. Inspect relationship consistency in the transformed records.
9. Draft the Monday review and a handover.
10. Add a project field with a migration and test it.

## Switching and operating

[The replace guide](docs/replace-cloud-compliance-datamasker.md) describes the one-command CSV import. It brings the Salesforce records DataMasker operates on, not its proprietary package configuration, historical jobs or native automation. Rules must be mapped first. Exported Account and Contact files are provided as synthetic format fixtures, not a licensed-account export.

The base works on local CSV copies. It does not mask a live Salesforce sandbox, mute Salesforce automation, migrate attachments, preserve Salesforce-compatible record IDs or restore files to Salesforce. Enterprise DNA can scope these integrations into your version. Do not retire a native masking tool until your actual workflows and controls have been replaced and checked.

npm run docs creates per-run masking evidence and per-environment handover documents in your brand. npm run view creates week, attention and retention pages. weekly-review and draft-handover write private Markdown drafts. Files are read-only outputs, with no send or grant-access action.

export produces a complete JSON snapshot of operational records, rules, masked values and evidence. export-csv writes transformed object files to a new directory. Neither overwrites an existing output. Use native database backups for restoration and test your restore procedure. Retention checks never erase data. Disposal of source files, transformed copies and backups remains a reviewed operation.

## Validation

npm test uses a disposable database and output directory. It tests every CLI command, masking relationships, no raw persistence, invalid imports, repeated imports, evidence gates, changed rules, refresh invalidation, ambiguity, HTML escaping and document generation. CI covers Node 20 and 22 on Windows and Ubuntu, plus PostgreSQL on Ubuntu. Configured CI is not a claim of a completed Windows run. See GitHub Actions for results.

[Compliance](docs/compliance.md) explains legal sources and house controls. [Why no front end](docs/why-no-front-end.md) explains the local workflow. [Research](docs/research.md) records the selection evidence.

## Licence

MIT. Copyright 2026 Enterprise DNA. Independent software, not affiliated with Cloud Compliance or Salesforce. No vendor code or assets are included.
