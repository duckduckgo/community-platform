alter table release_version drop constraint release_version_instant_answer_id_fkey;
update release_version set instant_answer_id = instant_answer.id from instant_answer where instant_answer_id = instant_answer.meta_id;
alter table release_version add foreign key(instant_answer_id) references instant_answer(id);
