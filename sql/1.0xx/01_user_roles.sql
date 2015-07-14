-- Convert schema 'DDGC::DBOld v1.x' to 'DDGC::DB v1.x':;

BEGIN;

CREATE TABLE "user_role" (
  "users_id" bigint NOT NULL,
  "role" integer NOT NULL,
  PRIMARY KEY ("users_id", "role")
);

ALTER TABLE "user_role" ADD CONSTRAINT "user_role_fk_users_id" FOREIGN KEY ("users_id")
  REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

INSERT INTO "user_role" ("users_id", "role")
SELECT "id", 1
  FROM "users"
 WHERE "admin" = 1;

INSERT INTO "user_role" ("users_id", "role")
SELECT "id", 2
  FROM "users"
 WHERE "flags" LIKE '%forum_manager%';

INSERT INTO "user_role" ("users_id", "role")
SELECT "id", 3
  FROM "users"
 WHERE "flags" LIKE '%translation_manager%';

INSERT INTO "user_role" ("users_id", "role")
SELECT "id", 4
  FROM "users"
 WHERE "flags" LIKE '%patron%';

ALTER TABLE users DROP COLUMN admin;

ALTER TABLE users DROP COLUMN roles;

ALTER TABLE users DROP COLUMN flags;

COMMIT;

