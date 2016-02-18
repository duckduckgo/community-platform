BEGIN;

update instant_answer set blockgroup = null where repo in ('fathead', 'longtail'); 
delete from instant_answer_blockgroup where blockgroup in ('fathead', 'longtail');

COMMIT;
