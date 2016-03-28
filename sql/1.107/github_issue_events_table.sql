BEGIN;
    
    ALTER TABLE github_event_issue DROP COLUMN created;

COMMIT;
