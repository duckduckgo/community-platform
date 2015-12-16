BEGIN;

CREATE TABLE "instant_answer_last_updated" (
  "token" text NOT NULL,
  "updated" timestamp with time zone NOT NULL,
  PRIMARY KEY ("token")
);

COMMIT;
