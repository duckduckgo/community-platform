BEGIN;
    ALTER TABLE instant_answer ADD COLUMN last_commit text;
    ALTER TABLE instant_answer ADD COLUMN last_comment text;
    ALTER TABLE instant_answer ADD COLUMN last_update text;
COMMIT;
