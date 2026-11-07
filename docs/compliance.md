# Test-data controls and their limits

Sources checked 7 November 2026. The command named compliance checks recorded evidence and local house controls. It does not certify privacy compliance or determine whether a data set is legally de-identified.

| Control | Implemented behaviour | Basis |
|---|---|---|
| CLASSIFICATION | Import stops when any column lacks an explicit rule. | House control supporting reasonable safeguards under [NZ Privacy Principle 5](https://www.privacy.org.nz/privacy-principles/5/). |
| KEEP-REVIEW | Kept fields require a reason and appear in compliance output. | House control. Field combinations can identify a person even when names are replaced. |
| RETENTION | A due or expired recorded review date is flagged and blocks acceptance. No automatic deletion. | House control supporting [APP 11](https://www.oaic.gov.au/privacy/australian-privacy-principles/australian-privacy-principles-guidelines/chapter-11-app-11-security-of-personal-information). Applicable entities must take reasonable protective steps and, subject to exceptions, destroy or de-identify information no longer needed for permitted purposes. |
| EVIDENCE | A new refresh, changed rules or unresolved issue prevents acceptance. | Operational house policy, not a statutory deadline. |
| REVIEW | Another operator label and evidence reference are required to accept a run. | House separation-of-review policy. Labels are not authenticated identities. |

The chosen retention date is the organisation's review date, not a legislated fixed period. The organisation determines applicable law, lawful purposes, retention exceptions and disposal procedures. No raw or transformed data is deleted by this tool.

[OAIC de-identification guidance](https://www.oaic.gov.au/privacy/privacy-guidance-for-organisations-and-government-agencies/handling-personal-information/de-identification-and-the-privacy-act) requires contextual assessment. Random replacement of direct identifiers alone is not proof that people cannot be identified. Kept fields, combinations, external information and access arrangements matter. Review the complete output before release.

Protect source files and output directories. Do not upload real personal data into a model conversation. The database stores masked values and explicit keep values, not a reverse token map. Input files remain on disk. Database owners can modify the code or bypass append-only triggers. Backups, authenticated access, encryption, retention execution and a review of actual deployments are outside this local program's assertions.
