alter table instant_answer add column release_version numeric(8,3);

create table release_version (
    id bigserial,
    instant_answer_id text not null,
    release_version numeric(8,3) not null,
    status varchar(20) not null,
    updated timestamp with time zone not null default now()
);

