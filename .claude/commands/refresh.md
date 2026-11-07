---
description: Record a fresh source copy and invalidate earlier review decisions.
---

Read CLAUDE.md first. Record a fresh source copy and invalidate earlier review decisions.

Run `node scripts/masking.mjs refresh --environment="<name>" --reason="<source refresh evidence>" --until=<YYYY-MM-DD> --actor="<operator>"`. Use `--json` for further analysis.

Start with current records. Use exact IDs if names are ambiguous. Mutations must be within the operator's request. For imports, run the dry run first, then remove --dry-run only for the authorised import. Do not display raw imported values, contact external systems, send messages or assert legal compliance. Explain current blockers and keep generated drafts private.
