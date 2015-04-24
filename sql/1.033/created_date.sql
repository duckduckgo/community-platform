BEGIN;
    ALTER TABLE instant_answer ADD COLUMN created_date date;
COMMIT;

