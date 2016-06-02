BEGIN;
UPDATE instant_answer SET code='["share/spice/time/capitals.yml","share/spice/time/content.handlebars","share/spice/time/time.css","share/spice/time/time.js","t/Time.t","lib/DDG/Spice/Time.pm"]' 
WHERE meta_id='time';
UPDATE instant_answer SET code='["share/goodie/cheat_sheets/json/r.json","lib/DDG/Goodie/CheatSheets.pm","t/CheatSheets/CheatSheets.t"]' 
WHERE meta_id='r_cheat_sheet';
COMMIT;
