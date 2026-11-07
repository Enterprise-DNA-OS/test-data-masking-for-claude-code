---
description: Read docs/replace-cloud-compliance-datamasker.md, inspect headers without displaying raw values, test first, reconcile counts.
---

Read CLAUDE.md first. Read docs/replace-cloud-compliance-datamasker.md, inspect headers without displaying raw values, test first, reconcile counts.

Run `node scripts/masking.mjs import datamasker --dir="<private CSV directory>" --environment="<name>" --actor="<operator>" --dry-run`. Use `--json` for further analysis.

Start with current records. Use exact IDs if names are ambiguous. Mutations must be within the operator's request. For imports, run the dry run first, then remove --dry-run only for the authorised import. Do not display raw imported values, contact external systems, send messages or assert legal compliance. Explain current blockers and keep generated drafts private.
