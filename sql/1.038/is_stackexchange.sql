BEGIN;
    ALTER TABLE instant_answer ADD COLUMN is_stackexchange integer;
COMMIT;
