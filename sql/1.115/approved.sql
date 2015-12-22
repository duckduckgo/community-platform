BEGIN;
ALTER TABLE instant_answer ADD COLUMN approved smallint DEFAULT 0 NOT NULL;
COMMIT;
