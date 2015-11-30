BEGIN;
    ALTER TABLE users ADD COLUMN new_contributor smallint DEFAULT 1 NOT NULL;
COMMIT;
