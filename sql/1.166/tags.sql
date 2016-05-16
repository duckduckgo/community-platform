BEGIN;
ALTER TABLE github_issue ADD COLUMN tags text;
COMMIT;
