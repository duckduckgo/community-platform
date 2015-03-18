BEGIN;
    ALTER TABLE instant_answer_issues ADD COLUMN author text;
COMMIT;
