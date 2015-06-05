BEGIN;
        ALTER TABLE instant_answer ADD COLUMN pr text;
COMMIT;
