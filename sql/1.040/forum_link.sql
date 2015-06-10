BEGIN;
    ALTER TABLE instant_answer ADD COLUMN forum_link text;
COMMIT;
