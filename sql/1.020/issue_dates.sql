BEGIN;
    ALTER TABLE instant_answer_issues ADD COLUMN date text;
COMMIT;
