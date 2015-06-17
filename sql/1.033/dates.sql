BEGIN;
    ALTER TABLE instant_answer ADD COLUMN dev_date date;

    ALTER TABLE instant_answer ADD COLUMN live_date date;
COMMIT;
