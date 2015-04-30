BEGIN;
    ALTER TABLE instant_answer ADD COLUMN is_fanon integer;
COMMIT;

