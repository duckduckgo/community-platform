BEGIN;

ALTER TABLE users RENAME COLUMN github_user TO github_user_plaintext;
ALTER TABLE users ADD COLUMN github_access_token text;
ALTER TABLE users ADD COLUMN github_user_linked text;

COMMIT;
