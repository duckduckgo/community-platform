BEGIN;
ALTER TABLE instant_answer_issues ADD COLUMN is_pr text;
COMMIT;

