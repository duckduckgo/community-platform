BEGIN;

ALTER TABLE instant_answer ALTER COLUMN code_review DROP NOT NULL;

ALTER TABLE instant_answer ALTER COLUMN design_review DROP NOT NULL;

COMMIT;


