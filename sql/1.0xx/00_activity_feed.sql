BEGIN;

CREATE TABLE "activity_feed" (
  "id" serial NOT NULL,
  "created" timestamp with time zone NOT NULL,
  "category" text NOT NULL,
  "action" text,
  "meta1" text,
  "meta2" text,
  "meta3" text,
  "description" text NOT NULL,
  "format" text DEFAULT 'markdown' NOT NULL,
  "for_user" bigint,
  "for_role" int,
  PRIMARY KEY ("id")
);

COMMIT;
