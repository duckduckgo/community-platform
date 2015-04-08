BEGIN;
     ALTER TABLE instant_answer ADD COLUMN meta_id text;
COMMIT;
