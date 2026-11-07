CREATE FUNCTION touch_updated() RETURNS trigger LANGUAGE plpgsql AS $$ BEGIN NEW.updated_at=now(); RETURN NEW; END $$;
CREATE FUNCTION immutable_row() RETURNS trigger LANGUAGE plpgsql AS $$ BEGIN RAISE EXCEPTION 'Evidence is append-only'; END $$;
CREATE TABLE environments (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(), name text NOT NULL UNIQUE CHECK(length(trim(name))>0),
 owner text NOT NULL CHECK(length(trim(owner))>0), purpose text NOT NULL CHECK(length(trim(purpose))>0),
 retention_due date NOT NULL, revision integer NOT NULL DEFAULT 1 CHECK(revision>0),
 refreshed_at timestamptz NOT NULL DEFAULT now(), created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE field_rules (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(), object_name text NOT NULL, field_name text NOT NULL,
 action text NOT NULL CHECK(action IN ('erase','token','email','keep')), domain text NOT NULL DEFAULT '', reason text NOT NULL,
 CHECK(action NOT IN ('token','email') OR length(trim(domain))>0), CHECK(length(trim(reason))>0),
 UNIQUE(object_name,field_name), created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE runs (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(), name text NOT NULL UNIQUE, environment_id uuid NOT NULL REFERENCES environments,
 revision integer NOT NULL, policy_hash text NOT NULL, policy jsonb NOT NULL, source_hash text NOT NULL,
 row_count integer NOT NULL CHECK(row_count>0), actor text NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(),
 UNIQUE(environment_id,revision,source_hash,policy_hash)
);
CREATE TABLE datasets (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(), run_id uuid NOT NULL REFERENCES runs, object_name text NOT NULL,
 columns jsonb NOT NULL, row_count integer NOT NULL CHECK(row_count>0), created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), UNIQUE(run_id,object_name)
);
CREATE TABLE masked_records (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(), dataset_id uuid NOT NULL REFERENCES datasets, ordinal integer NOT NULL CHECK(ordinal>0), values jsonb NOT NULL,
 created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now(), UNIQUE(dataset_id,ordinal)
);
CREATE TABLE reviews (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(), run_id uuid NOT NULL REFERENCES runs, reviewer text NOT NULL CHECK(length(trim(reviewer))>0),
 evidence text NOT NULL CHECK(length(trim(evidence))>0), decision text NOT NULL CHECK(decision IN ('accepted','rejected')),
 created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE issues (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(), name text NOT NULL, environment_id uuid NOT NULL REFERENCES environments,
 owner text NOT NULL, due date NOT NULL, status text NOT NULL DEFAULT 'open' CHECK(status IN ('open','closed')), resolution text,
 CHECK(status='open' OR length(trim(resolution))>0), created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE activity (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(), action text NOT NULL, actor text NOT NULL, detail jsonb NOT NULL,
 created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now()
);
DO $$ DECLARE t text; BEGIN
 FOREACH t IN ARRAY ARRAY['environments','field_rules','runs','datasets','masked_records','reviews','issues','activity'] LOOP
 EXECUTE format('CREATE TRIGGER touch BEFORE UPDATE ON %I FOR EACH ROW EXECUTE FUNCTION touch_updated()',t);
 EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY',t);
 EXECUTE format('REVOKE ALL ON %I FROM PUBLIC',t);
 END LOOP;
 FOREACH t IN ARRAY ARRAY['runs','datasets','masked_records','reviews','activity'] LOOP
 EXECUTE format('CREATE TRIGGER immutable BEFORE UPDATE OR DELETE ON %I FOR EACH ROW EXECUTE FUNCTION immutable_row()',t);
 END LOOP;
END $$;
CREATE VIEW rule_coverage AS SELECT object_name, count(*) AS fields, count(*) FILTER(WHERE action='keep') AS kept_fields,
 count(*) FILTER(WHERE action='erase') AS erased_fields,count(*) FILTER(WHERE action IN ('token','email')) AS replaced_fields FROM field_rules GROUP BY object_name;
CREATE VIEW run_register AS SELECT r.id,r.name,e.name AS environment,r.revision,e.revision AS current_revision,r.row_count,r.actor,r.created_at,
 COALESCE((SELECT decision FROM reviews WHERE run_id=r.id ORDER BY created_at DESC,id DESC LIMIT 1),'unreviewed') AS decision,
 (SELECT count(*) FROM issues WHERE environment_id=e.id AND status='open') AS blockers,
 e.retention_due, r.policy_hash FROM runs r JOIN environments e ON e.id=r.environment_id;
CREATE VIEW attention AS
 SELECT 'RETENTION' AS kind,e.name AS item,e.owner,e.retention_due AS due,'Retention review due or expired' AS detail FROM environments e WHERE e.retention_due<=current_date
 UNION ALL SELECT 'ISSUE',i.name,i.owner,i.due,e.name FROM issues i JOIN environments e ON e.id=i.environment_id WHERE i.status='open'
 UNION ALL SELECT 'NO-CURRENT-RUN',e.name,e.owner,current_date,'No masking run for the current refresh' FROM environments e WHERE NOT EXISTS(SELECT 1 FROM runs r WHERE r.environment_id=e.id AND r.revision=e.revision)
 UNION ALL SELECT 'UNREVIEWED',r.name,e.owner,r.created_at::date,e.name FROM runs r JOIN environments e ON e.id=r.environment_id WHERE r.revision=e.revision AND NOT EXISTS(SELECT 1 FROM reviews v WHERE v.run_id=r.id);
CREATE VIEW retention_review AS SELECT e.id,e.name,e.owner,e.purpose,e.retention_due,
 (e.retention_due-current_date) AS days_left,count(DISTINCT r.id) AS runs,coalesce(sum(r.row_count),0) AS stored_rows
 FROM environments e LEFT JOIN runs r ON r.environment_id=e.id GROUP BY e.id;
