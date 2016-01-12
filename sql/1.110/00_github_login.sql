BEGIN;

ALTER TABLE users RENAME COLUMN github_user TO github_user_plaintext;
ALTER TABLE users ADD COLUMN github_id bigint;
ALTER TABLE users ADD CONSTRAINT users_github_id UNIQUE (github_id);

ALTER TABLE github_user DROP CONSTRAINT IF EXISTS github_user_fk_users_id;
ALTER TABLE github_user DROP COLUMN IF EXISTS access_token;
ALTER TABLE github_user DROP COLUMN IF EXISTS users_id;

DROP TABLE IF EXISTS github_user_link;

COMMIT;
