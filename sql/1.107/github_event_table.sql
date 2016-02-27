BEGIN;

CREATE TABLE github_event (
    id serial NOT NULL PRIMARY KEY,
    github_id text NOT NULL UNIQUE,
    github_user_id integer NOT NULL REFERENCES github_user(id) ON DELETE CASCADE,
    github_repo_id integer  NOT NULL REFERENCES github_repo(id) ON DELETE CASCADE,
    github_event_type text NOT NULL,
    github_event_date timestamp with time zone  NOT NULL 
);

COMMIT;
