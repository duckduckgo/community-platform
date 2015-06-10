BEGIN;

CREATE TABLE "activity_feed" (
  "id" serial NOT NULL,
  "created" timestamp with time zone NOT NULL,
  "type" text NOT NULL,
  "description" text NOT NULL,
  "format" text DEFAULT 'markdown' NOT NULL,
  PRIMARY KEY ("id")
);

COMMIT;
