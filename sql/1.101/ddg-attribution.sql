BEGIN;
    UPDATE instant_answer SET developer = '[{"name":"DuckDuckGo", "url":"http://www.duckduckhack.com", "type":"ddg"}]' where developer = '[{"name":"DDG Team","url":"http://www.duckduckhack.com","type":"ddg"}]';
COMMIT;
