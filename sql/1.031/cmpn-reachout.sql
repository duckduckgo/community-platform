-- Convert schema 'DDGC::DBOld v1.x' to 'DDGC::DB v1.x':;

BEGIN;

ALTER TABLE user_campaign_notice ADD COLUMN unsubbed smallint DEFAULT 0 NOT NULL;

COMMIT;


