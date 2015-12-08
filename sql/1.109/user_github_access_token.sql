BEGIN;

ALTER TABLE users ADD COLUMN github_access_token text;

COMMIT;


