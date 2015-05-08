BEGIN;
update instant_answer set tab = 'answer' where tab is null and repo = 'goodies';
COMMIT;
