BEGIN;

ALTER TABLE token_domain ADD COLUMN active smallint DEFAULT 1 NOT NULL;

COMMIT;

