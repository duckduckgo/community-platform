BEGIN;
drop table if exists instant_answer_blocks;

create table instant_answer_blockgroup (
    id serial primary key,
    blockgroup varchar(20) not null unique
);

copy instant_answer_blockgroup (blockgroup) from stdin;
goodie_exlusive
spice_killresult
spice_nonexclusive
goodie
spice
fathead
longtail
\.

alter table instant_answer
    add column blockgroup varchar(20) references instant_answer_blockgroup (blockgroup);
    
update instant_answer set blockgroup = 'goodie' where repo = 'goodies';
update instant_answer set blockgroup = repo where repo != 'goodies' and char_length(repo) > 0;

update instant_answer as ia set
    blockgroup = a.blockgroup
    from (values
        ('conversions', 'goodie_exlusive'),
        ('convert_lat_lon', 'goodie_exlusive'),
        ('help_line', 'goodie_exlusive'),
        ('laser_ship', 'goodie_exlusive'),
        ('latex', 'goodie_exlusive'),
        ('make_me_asandwich', 'goodie_exlusive'),
        ('moon_phases', 'goodie_exlusive'),
        ('passphrase', 'goodie_exlusive'),
        ('password', 'goodie_exlusive'),
        ('private_network', 'goodie_exlusive'),
        ('random_number', 'goodie_exlusive'),
        ('sha', 'goodie_exlusive'),
        ('subnet_calc', 'goodie_exlusive'),
        ('unix_time', 'goodie_exlusive'),
        ('zapp_brannigan', 'goodie_exlusive'),
        ('alternative_to', 'spice_killresult'),
        ('products', 'spice_killresult'),
        ('bitcoin', 'spice_killresult'),
        ('bitcoin_address', 'spice_killresult'),
        ('bitcoin_block', 'spice_killresult'),
        ('bitcoin_transaction', 'spice_killresult'),
        ('chuck_norris', 'spice_killresult'),
        ('envato', 'spice_killresult'),
        ('expand_url', 'spice_killresult'),
        ('forecast', 'spice_killresult'),
        ('images', 'spice_killresult'),
        ('in_theaters', 'spice_killresult'),
        ('iplookup', 'spice_killresult'),
        ('is_it_up', 'spice_killresult'),
        ('leak_db', 'spice_killresult'),
        ('maps_maps', 'spice_killresult'),
        ('maps_places', 'spice_killresult'),
        ('meta_cpan', 'spice_killresult'),
        ('movie', 'spice_killresult'),
        ('people_in_space', 'spice_killresult'),
        ('rand_word', 'spice_killresult'),
        ('stopwatch', 'spice_killresult'),
        ('timer', 'spice_killresult'),
        ('xkcd', 'spice_killresult'),
        ('code_search', 'spice_nonexclusive'),
        ('Lastfm::Artist', 'spice_nonexclusive'),
        ('Quixey', 'spice_nonexclusive'),
        ('Zanran', 'spice_nonexclusive')
    ) as a(id, blockgroup)
    where ia.id = a.id;

update instant_answer set deployment_state = 'live' where blockgroup is not null;
COMMIT;
