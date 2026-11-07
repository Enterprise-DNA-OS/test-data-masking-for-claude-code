---
description: Inspect the actual masked output, kept fields and relationship consistency before recording the requested decision. Reviewer must differ from importer.
---

Read CLAUDE.md first. Inspect the actual masked output, kept fields and relationship consistency before recording the requested decision. Reviewer must differ from importer.

Run `node scripts/masking.mjs review --run="<name or ID>" --reviewer="<reviewer>" --decision=<accepted|rejected> --evidence="<inspection reference>"`. Use `--json` for further analysis.

Start with current records. Use exact IDs if names are ambiguous. Mutations must be within the operator's request. For imports, run the dry run first, then remove --dry-run only for the authorised import. Do not display raw imported values, contact external systems, send messages or assert legal compliance. Explain current blockers and keep generated drafts private.
