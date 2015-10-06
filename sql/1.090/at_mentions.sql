BEGIN;
    ALTER TABLE instant_answer ADD COLUMN at_mentions text;
COMMIT;
