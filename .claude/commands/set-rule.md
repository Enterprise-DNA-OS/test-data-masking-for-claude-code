---
description: Set an explicit treatment for a field. A changed rule invalidates prior acceptance.
---

Read CLAUDE.md first. Set an explicit treatment for a field. A changed rule invalidates prior acceptance.

Run `node scripts/masking.mjs set-rule --object=<object> --field=<field> --action=<erase|token|email|keep> --domain="<shared token domain>" --reason="<reason>" --actor="<operator>"`. Use `--json` for further analysis.

Start with current records. Use exact IDs if names are ambiguous. Mutations must be within the operator's request. For imports, run the dry run first, then remove --dry-run only for the authorised import. Do not display raw imported values, contact external systems, send messages or assert legal compliance. Explain current blockers and keep generated drafts private.
