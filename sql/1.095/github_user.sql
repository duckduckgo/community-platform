BEGIN;
    CREATE TABLE github_user_link (
        "users_id" bigint NOT NULL,
        "data" text NOT NULL
    );

    ALTER TABLE users ADD COLUMN "github_user" text;
COMMIT;
