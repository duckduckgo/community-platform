BEGIN;

ALTER TABLE users RENAME COLUMN github_user_plaintext TO github_user;
ALTER TABLE users DROP COLUMN github_id;

COMMIT;
