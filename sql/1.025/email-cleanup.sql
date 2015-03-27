BEGIN;

ALTER TABLE users ADD COLUMN email_verified integer DEFAULT 0 NOT NULL;

COMMIT;

