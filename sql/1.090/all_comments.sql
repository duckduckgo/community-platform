BEGIN;
    ALTER TABLE instant_answer ADD COLUMN all_comments text;
COMMIT;
