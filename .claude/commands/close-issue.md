---
description: Close only with operator-provided resolution evidence.
---

Read CLAUDE.md first. Close only with operator-provided resolution evidence.

Run `node scripts/masking.mjs close-issue --issue="<name or ID>" --resolution="<evidence>" --actor="<operator>"`. Use `--json` for further analysis.

Start with current records. Use exact IDs if names are ambiguous. Mutations must be within the operator's request. For imports, run the dry run first, then remove --dry-run only for the authorised import. Do not display raw imported values, contact external systems, send messages or assert legal compliance. Explain current blockers and keep generated drafts private.
