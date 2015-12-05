BEGIN;
    ALTER TABLE instant_answer_issues ADD COLUMN status text;
COMMIT;
