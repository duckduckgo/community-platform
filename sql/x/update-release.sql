BEGIN:

delete from instant_answer where id = 'crunchbase';
delete from instant_answer where id = 'time_and_date_holiday';
delete from instant_answer where id = '6169';
delete from instant_answer where id = 'windows_shortcuts_cheat_sheet';
delete from instant_answer where id = 'mlb_games';
delete from instant_answer where id = '6303';
delete from instant_answer where id = 'yoga_postures';

alter table instant_answer add column release_version numeric(8,3);

create unique index ia_unique_meta_id on instant_answer (meta_id);

create table release_version (
    id bigserial,
    instant_answer_id text not null references instant_answer (meta_id),
    release_version numeric(8,3) not null,
    status varchar(20) not null,
    updated timestamp with time zone not null default now()
);

COMMIT;
