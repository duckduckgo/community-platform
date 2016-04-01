BEGIN;
    
    ALTER TABLE github_issue_event DROP COLUMN created;

COMMIT;
