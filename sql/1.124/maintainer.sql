BEGIN;
ALTER TABLE instant_answer ADD COLUMN maintainer text;
COMMIT;
