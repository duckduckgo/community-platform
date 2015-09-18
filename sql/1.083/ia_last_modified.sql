BEGIN;

ALTER TABLE instant_answer ADD COLUMN updated timestamp with time zone NOT NULL DEFAULT NOW();

COMMIT;
