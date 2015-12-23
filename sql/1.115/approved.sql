BEGIN;
ALTER TABLE instant_answer ADD COLUMN approved smallint DEFAULT 1 NOT NULL;
UPDATE instant_answer SET approved=0 WHERE dev_milestone='ghosted';
COMMIT;
