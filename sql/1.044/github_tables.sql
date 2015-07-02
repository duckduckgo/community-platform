-- Convert schema 'DDGC::DB v1.x' to 'DDGC::DBOld v1.x':;

BEGIN;

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

ALTER TABLE "github_comment" ADD CONSTRAINT "github_comment_fk_github_repo_id_number" FOREIGN KEY ("github_repo_id", "number")
  REFERENCES "github_issue" ("github_repo_id", "number") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "github_comment" ADD CONSTRAINT "github_comment_fk_github_repo_id" FOREIGN KEY ("github_repo_id")
  REFERENCES "github_repo" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "github_comment" ADD CONSTRAINT "github_comment_fk_github_user_id" FOREIGN KEY ("github_user_id")
  REFERENCES "github_user" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

DROP INDEX comment_updated_idx;

DROP INDEX comment_created_idx;

DROP INDEX comment_context_id_idx;

DROP INDEX comment_context_idx;

DROP INDEX event_created_idx;

DROP INDEX event_context_id_idx;

DROP INDEX event_pid_idx;

DROP INDEX event_context_idx;

DROP INDEX event_nid_idx;

DROP INDEX event_notification_sent_idx;

DROP INDEX event_notification_group_group_context_id_idx;

DROP INDEX event_related_context_id_idx;

DROP INDEX event_related_context_idx;

ALTER TABLE github_commit ALTER COLUMN author_date TYPE timestamp with time zone;

ALTER TABLE github_commit ALTER COLUMN committer_date TYPE timestamp with time zone;

ALTER TABLE github_commit ALTER COLUMN gh_data DROP DEFAULT;

ALTER TABLE github_issue ADD COLUMN idea_id bigint;

ALTER TABLE github_issue ADD COLUMN isa_pull_request boolean NOT NULL;

ALTER TABLE github_issue ALTER COLUMN created_at TYPE timestamp with time zone;

ALTER TABLE github_issue ALTER COLUMN updated_at TYPE timestamp with time zone;

ALTER TABLE github_issue ALTER COLUMN closed_at TYPE timestamp with time zone;

ALTER TABLE github_issue ALTER COLUMN gh_data DROP DEFAULT;

ALTER TABLE github_issue ADD CONSTRAINT github_issue_number_github_repo_id UNIQUE (number, github_repo_id);

ALTER TABLE github_issue_event ALTER COLUMN created_at TYPE timestamp with time zone;

ALTER TABLE github_issue_event ALTER COLUMN gh_data DROP DEFAULT;

ALTER TABLE github_pull ADD COLUMN number text NOT NULL;

ALTER TABLE github_pull ALTER COLUMN created_at TYPE timestamp with time zone;

ALTER TABLE github_pull ALTER COLUMN updated_at TYPE timestamp with time zone;

ALTER TABLE github_pull ALTER COLUMN closed_at TYPE timestamp with time zone;

ALTER TABLE github_pull ALTER COLUMN merged_at TYPE timestamp with time zone;

ALTER TABLE github_pull ALTER COLUMN gh_data DROP DEFAULT;

ALTER TABLE github_pull ADD CONSTRAINT github_pull_number_github_repo_id UNIQUE (number, github_repo_id);

ALTER TABLE github_repo DROP CONSTRAINT github_repo_fk_github_repo_id_source;

ALTER TABLE github_repo DROP COLUMN github_repo_id_source;

ALTER TABLE github_repo ALTER COLUMN pushed_at TYPE timestamp with time zone;

ALTER TABLE github_repo ALTER COLUMN created_at TYPE timestamp with time zone;

ALTER TABLE github_repo ALTER COLUMN updated_at TYPE timestamp with time zone;

ALTER TABLE github_repo ALTER COLUMN gh_data DROP DEFAULT;

ALTER TABLE github_user DROP COLUMN scope_public_repo;

ALTER TABLE github_user ADD COLUMN scope_pulic_repo text DEFAULT '0' NOT NULL;

ALTER TABLE github_user ALTER COLUMN created_at TYPE timestamp with time zone;

ALTER TABLE github_user ALTER COLUMN updated_at TYPE timestamp with time zone;

ALTER TABLE github_user ALTER COLUMN scope_user_email TYPE text;

ALTER TABLE github_user ALTER COLUMN gh_data DROP DEFAULT;

DROP INDEX user_language_username_idx;

DROP INDEX user_notification_context_id_idx;

DROP INDEX user_notification_cycle_idx;

DROP INDEX user_notification_group_priority_idx;

DROP INDEX user_notification_group_filter_by_language_idx;

DROP INDEX user_notification_group_action_idx;

DROP INDEX user_notification_group_context_idx;

DROP INDEX user_notification_group_group_context_idx;

DROP INDEX user_notification_group_sub_context_idx;

DROP INDEX user_notification_group_with_context_id_idx;


COMMIT;


