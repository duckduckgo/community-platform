-- Convert schema 'DDGC::DBOld v1.x' to 'DDGC::DB v1.x':;

BEGIN;

ALTER TABLE user_campaign_notice ADD COLUMN campaign_email_is_account_email bigint DEFAULT 0 NOT NULL;

ALTER TABLE user_campaign_notice ADD COLUMN campaign_email text;

ALTER TABLE user_campaign_notice ADD COLUMN campaign_email_verified smallint DEFAULT 0 NOT NULL;

COMMIT;


