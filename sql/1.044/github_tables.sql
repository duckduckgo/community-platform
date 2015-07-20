BEGIN;

ALTER TABLE github_commit ALTER COLUMN author_date TYPE timestamp with time zone;

ALTER TABLE github_commit ALTER COLUMN committer_date TYPE timestamp with time zone;

ALTER TABLE github_commit ALTER COLUMN gh_data DROP DEFAULT;

ALTER TABLE github_issue ADD COLUMN idea_id bigint;

ALTER TABLE github_issue ADD COLUMN isa_pull_request integer NOT NULL default 0;

ALTER TABLE github_issue ALTER COLUMN number TYPE bigint;

ALTER TABLE github_issue ALTER COLUMN created_at TYPE timestamp with time zone;

ALTER TABLE github_issue ALTER COLUMN updated_at TYPE timestamp with time zone;

ALTER TABLE github_issue ALTER COLUMN closed_at TYPE timestamp with time zone;

ALTER TABLE github_issue ALTER COLUMN gh_data DROP DEFAULT;

ALTER TABLE github_issue ADD CONSTRAINT github_issue_number_github_repo_id UNIQUE (number, github_repo_id);

ALTER TABLE github_issue_event ALTER COLUMN created_at TYPE timestamp with time zone;

ALTER TABLE github_issue_event ALTER COLUMN gh_data DROP DEFAULT;

ALTER TABLE github_pull ADD COLUMN number bigint NOT NULL;

ALTER TABLE github_pull ALTER COLUMN created_at TYPE timestamp with time zone;

ALTER TABLE github_pull ALTER COLUMN updated_at TYPE timestamp with time zone;

ALTER TABLE github_pull ALTER COLUMN closed_at TYPE timestamp with time zone;

ALTER TABLE github_pull ALTER COLUMN merged_at TYPE timestamp with time zone;

ALTER TABLE github_pull ALTER COLUMN gh_data DROP DEFAULT;

ALTER TABLE github_pull ADD CONSTRAINT github_pull_number_github_repo_id UNIQUE (number, github_repo_id);

ALTER TABLE github_pull ADD CONSTRAINT github_pull_fk_github_repo_id_number FOREIGN KEY (github_repo_id, number)
  REFERENCES github_issue (github_repo_id, number) ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE github_repo DROP CONSTRAINT github_repo_fk_github_repo_id_source;

ALTER TABLE github_repo DROP COLUMN github_repo_id_source;

ALTER TABLE github_repo ALTER COLUMN pushed_at TYPE timestamp with time zone;

ALTER TABLE github_repo ALTER COLUMN created_at TYPE timestamp with time zone;

ALTER TABLE github_repo ALTER COLUMN updated_at TYPE timestamp with time zone;

ALTER TABLE github_repo ALTER COLUMN gh_data DROP DEFAULT;

ALTER TABLE github_user ADD COLUMN isa_owners_team_member integer NOT NULL default 0;

ALTER TABLE github_user ALTER COLUMN created_at TYPE timestamp with time zone;

ALTER TABLE github_user ALTER COLUMN updated_at TYPE timestamp with time zone;

ALTER TABLE github_user ALTER COLUMN gh_data DROP DEFAULT;


CREATE TABLE "github_comment" (
  "id" serial NOT NULL,
  "github_id" bigint NOT NULL,
  "github_repo_id" bigint NOT NULL,
  "github_user_id" bigint NOT NULL,
  "number" bigint NOT NULL,
  "body" text NOT NULL,
  "created_at" timestamp with time zone NOT NULL,
  "updated_at" timestamp with time zone NOT NULL,
  "gh_data" text NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "github_comment_github_id" UNIQUE ("github_id")
);

CREATE TABLE "github_fork" (
  "id" serial NOT NULL,
  "github_id" bigint NOT NULL,
  "github_repo_id" bigint NOT NULL,
  "github_user_id" bigint NOT NULL,
  "full_name" text NOT NULL,
  "pushed_at" timestamp with time zone NOT NULL,
  "created_at" timestamp with time zone NOT NULL,
  "updated_at" timestamp with time zone NOT NULL,
  "gh_data" text NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "github_fork_github_id" UNIQUE ("github_id")
);

CREATE TABLE "github_review_comment" (
  "id" serial NOT NULL,
  "github_id" bigint NOT NULL,
  "github_repo_id" bigint NOT NULL,
  "github_user_id" bigint NOT NULL,
  "number" bigint NOT NULL,
  "diff_hunk" text NOT NULL,
  "path" text NOT NULL,
  "body" text NOT NULL,
  "created_at" timestamp with time zone NOT NULL,
  "updated_at" timestamp with time zone NOT NULL,
  "gh_data" text NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "github_review_comment_github_id" UNIQUE ("github_id")
);

ALTER TABLE "github_comment" ADD CONSTRAINT "github_comment_fk_github_repo_id_number" FOREIGN KEY ("github_repo_id", "number")
  REFERENCES "github_issue" ("github_repo_id", "number") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "github_comment" ADD CONSTRAINT "github_comment_fk_github_repo_id" FOREIGN KEY ("github_repo_id")
  REFERENCES "github_repo" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "github_comment" ADD CONSTRAINT "github_comment_fk_github_user_id" FOREIGN KEY ("github_user_id")
  REFERENCES "github_user" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "github_fork" ADD CONSTRAINT "github_fork_fk_github_repo_id" FOREIGN KEY ("github_repo_id")
  REFERENCES "github_repo" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "github_fork" ADD CONSTRAINT "github_fork_fk_github_user_id" FOREIGN KEY ("github_user_id")
  REFERENCES "github_user" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "github_review_comment" ADD CONSTRAINT "github_review_comment_fk_github_repo_id_number" FOREIGN KEY ("github_repo_id", "number")
  REFERENCES "github_pull" ("github_repo_id", "number") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "github_review_comment" ADD CONSTRAINT "github_review_comment_fk_github_repo_id" FOREIGN KEY ("github_repo_id")
  REFERENCES "github_repo" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "github_review_comment" ADD CONSTRAINT "github_review_comment_fk_github_user_id" FOREIGN KEY ("github_user_id")
  REFERENCES "github_user" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;


COMMIT;


