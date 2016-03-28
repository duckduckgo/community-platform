BEGIN;

CREATE TABLE "github_commit_comment" (
    "id" serial NOT NULL,
    "commit_id" bigint NOT NULL,
    "github_repo_id" bigint NOT NULL NOT NULL REFERENCES github_repo(id) ON DELETE RESTRICT,
    "github_user_id" bigint NOT NULL NOT NULL REFERENCES github_user(id) ON DELETE RESTRICT,
    "position" bigint NOT NULL,
    "line" bigint NOT NULL,
    "number" bigint NOT NULL,
    "body" text NOT NULL,
    "created_at" timestamp with time zone NOT NULL,
    "gh_data" text NOT NULL,
    
    PRIMARY KEY (commit_id, number)
);

COMMIT;
