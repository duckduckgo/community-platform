BEGIN;
    update instant_answer set unsafe = 0 where unsafe is NULL; 
COMMIT;

