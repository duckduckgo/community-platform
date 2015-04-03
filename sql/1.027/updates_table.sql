BEGIN;
CREATE TABLE "instant_answer_updates" (
      "id" text NOT NULL,
      "field" text NOT NULL,
      "value" text NOT NULL,
      "timestamp" text NOT NULL,
      PRIMARY KEY ("id")
);

ALTER TABLE "instant_answer_updates" ADD CONSTRAINT "instant_answer_updates_fk_instant_answer_id" FOREIGN KEY ("instant_answer_id")
  REFERENCES "instant_answer" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;
COMMIT;
