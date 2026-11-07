# Bring your DataMasker workflow across

The supported import is the Salesforce CSV data that DataMasker operates on. There is no claim of an automatic migration of the Cloud Compliance managed package, rule configuration or job history.

## Export and prepare

Use Salesforce's documented [Data Export service](https://help.salesforce.com/s/articleView?id=sf.admin_exportdata.htm&language=en_US&type=5) for an authorised production-org export, or an authorised Data Loader export for a sandbox. The Data Export service does not support sandboxes. Do not wait for a sandbox Data Export request to complete. Extract the authorised UTF-8 CSV files into a private folder. This program never requests an export or accesses a live Salesforce org.

Name files for their object API name, such as Account.csv and Contact.csv. Each needs a unique nonempty Id column. UTF-8 BOM, CRLF, quoted commas, doubled quotes and embedded newlines are supported. Duplicate headers, uneven rows, duplicate or empty IDs, and empty files fail. All columns need a masking rule. No column is silently dropped or automatically trusted.

In a fresh local database, migrate, register your environment, and set explicit rules for every column. The demo fixture rules are examples only. Map your actual DataMasker policy with your administrator. [Vendor field-rule documentation](https://cloudcompliance.app/documentation/specify-object-field-masking) describes the incumbent's actions; this program implements erase, random replacement tokens, reserved-domain emails and explicit keep, not all of its actions.

```sh
npm run migrate
npm run masking -- add-environment --name="Acceptance" --owner="Operator" --purpose="Acceptance testing" --until=2027-01-31 --actor="Operator"
npm run masking -- set-rule --object=Account --field=Id --action=token --domain=account --reason="Preserve test relationships" --actor="Operator"
# Add the remaining field rules before importing.
npm run masking -- import datamasker --dir="imports/salesforce" --environment="Acceptance" --actor="Operator" --dry-run
npm run masking -- import datamasker --dir="imports/salesforce" --environment="Acceptance" --actor="Operator"
```

## What maps

| Input | Stored record |
|---|---|
| Object filename | Dataset object name |
| Header names | Dataset column order and matched rules, case-insensitive |
| Row values | Transformed values only, except explicit keep rules |
| Matching values in the same token domain | Same replacement within one directory import |
| Whole directory contents | Source hash, total counts and one immutable run |
| Current rules | Full immutable policy snapshot and hash |

Import related objects in the same batch and use the same domain for related identifier fields. Partial exports can contain orphan references. This program preserves equal values but does not discover every relationship or enforce Salesforce's metadata constraints. Review those relationships before accepting a copy. Replacement identifiers are not valid Salesforce IDs. An integration must remap them before a separate test-org load.

## Reconcile before switching

Compare object counts, every header and per-object row counts with the source. Inspect transformed values in an export-csv output, verify fields marked keep and relationships, then record a review with evidence. Tests use synthetic examples based on the documented CSV mechanism, not a licensed account export.

The importer is atomic and repeatable for identical bytes, rules and environment revision. A changed source file produces a new run. A refresh or changed rule invalidates earlier readiness. Source hashes allow reconciliation without retaining the source contents in the database.

Attachments, rich content, formula and roll-up fields omitted by the export, package configuration, job history, regex policies, native Salesforce scheduling and automation muting need separate mapping or implementation. Export availability and queue time depend on your Salesforce account. One local import command does not guarantee the vendor export finishes in a day.

Do not cancel the incumbent until all of your required workflows, security controls and integrations have been tested. Enterprise DNA can map and operate the custom version. No command here sends, publishes, changes Salesforce or deletes source files.
