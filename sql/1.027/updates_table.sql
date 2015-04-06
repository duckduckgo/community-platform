BEGIN;
ALTER TABLE instant_answer DROP COLUMN updates;

CREATE TABLE "instant_answer_updates" (
  "instant_answer_id" text NOT NULL,
  "field" text NOT NULL,
  "value" text NOT NULL,
  "timestamp" text NOT NULL
);

ALTER TABLE "instant_answer_updates" ADD CONSTRAINT "instant_answer_updates_fk_instant_answer_id" FOREIGN KEY ("instant_answer_id")
  REFERENCES "instant_answer" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

COMMIT;
