BEGIN;
    UPDATE instant_answer 
    SET developer = '[{"name":"DDG Team", "url":"http://www.duckduckhack.com", "type":"ddg"}]' 
    where developer like '%"name":"duck%' or developer like '%"name":"Duck%';
COMMIT;

