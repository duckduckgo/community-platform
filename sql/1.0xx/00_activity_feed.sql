BEGIN;

CREATE TABLE "user_subscription" (
  "id" serial NOT NULL,
  "users_id" bigint NOT NULL,
  "category" text NOT NULL,
  "action" text,
  "meta1" text,
  "meta2" text,
  "meta3" text,
  PRIMARY KEY ("id")
);

ALTER TABLE "user_subscription" ADD CONSTRAINT "user_subscription_fk_users_id" FOREIGN KEY ("users_id")
  REFERENCES "users" ("id") DEFERRABLE;

CREATE TABLE "activity_feed" (
  "id" serial NOT NULL,
  "created" timestamp with time zone NOT NULL,
  "category" text NOT NULL,
  "action" text DEFAULT 'created' NOT NULL,
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
