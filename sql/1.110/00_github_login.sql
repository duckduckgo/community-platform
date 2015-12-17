BEGIN;

ALTER TABLE users RENAME COLUMN github_user TO github_user_plaintext;
ALTER TABLE users ADD COLUMN github_id bigint;
ALTER TABLE users ADD CONSTRAINT users_github_id UNIQUE (github_id);

ALTER TABLE github_user DROP CONSTRAINT github_user_fk_users_id;
ALTER TABLE github_user ADD CONSTRAINT github_user_fk_github_id FOREIGN KEY (github_id)
  REFERENCES users (github_id) ON DELETE NO ACTION ON UPDATE CASCADE DEFERRABLE;
ALTER TABLE github_user DROP COLUMN access_token;
ALTER TABLE github_user DROP COLUMN users_id;

COMMIT;
