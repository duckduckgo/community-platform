BEGIN;
ALTER TABLE instant_answer ADD COLUMN api_status_page text;
COMMIT;
