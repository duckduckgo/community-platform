BEGIN;

CREATE TABLE "github_commit_comment" (
    "id" serial NOT NULL,
    "sha" bigint NOT NULL REFERENCES github_commit(id) ON DELETE CASCADE,
    "github_repo_id" bigint NOT NULL REFERENCES github_repo(id) ON DELETE CASCADE,
    "github_user_id" bigint NOT NULL REFERENCES github_user(id) ON DELETE CASCADE,
    "position" bigint NOT NULL,
    "line" bigint NOT NULL,
    "number" bigint NOT NULL,
    "body" text NOT NULL,
    "created_at" timestamp with time zone NOT NULL,
    "gh_data" text NOT NULL,
    
    PRIMARY KEY (sha, number)
);

COMMIT;
