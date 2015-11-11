BEGIN;
    CREATE TABLE "instant_answer_traffic" (
          "date" date NOT NULL,
          "answer_id" text NOT NULL,
          "pixel_type" text NOT NULL,
          "count" bigint NOT NULL,
          "id" serial NOT NULL,
          PRIMARY KEY ("id")
    );

COMMIT;
