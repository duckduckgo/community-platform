BEGIN;
ALTER TABLE instant_answer ADD COLUMN answerbar text;
COMMIT;
