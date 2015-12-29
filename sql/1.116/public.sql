BEGIN;
ALTER TABLE instant_answer ADD COLUMN public smallint DEFAULT 1 NOT NULL;
UPDATE instant_answer SET public=0 WHERE dev_milestone='ghosted';
COMMIT;
