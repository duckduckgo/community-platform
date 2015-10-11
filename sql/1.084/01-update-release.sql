BEGIN:

alter table instant_answer
    add column release_version numeric(8,3),
    add column deployment_state varchar(15);

create unique index ia_unique_meta_id on instant_answer (meta_id);

create table release_version (
    id bigserial,
    instant_answer_id text not null references instant_answer (meta_id),
    release_version numeric(8,3) not null,
    status varchar(20) not null,
    updated timestamp with time zone not null default now()
);

COMMIT;
