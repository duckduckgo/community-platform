BEGIN;
    ALTER TABLE users ADD COLUMN "github_user" text;
COMMIT;
