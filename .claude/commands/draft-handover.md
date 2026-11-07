---
description: Draft a named environment handover without sending or granting access.
---

Read CLAUDE.md first. Draft a named environment handover without sending or granting access.

Run `node scripts/masking.mjs draft-handover --environment="<name>"`. Use `--json` for further analysis.

Start with current records. Use exact IDs if names are ambiguous. Mutations must be within the operator's request. For imports, run the dry run first, then remove --dry-run only for the authorised import. Do not display raw imported values, contact external systems, send messages or assert legal compliance. Explain current blockers and keep generated drafts private.
