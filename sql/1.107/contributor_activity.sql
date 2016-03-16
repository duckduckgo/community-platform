BEGIN;

CREATE TABLE contributor_activity (
    id serial NOT NULL PRIMARY KEY,
    github_id text NOT NULL UNIQUE,
    contributor_id integer NOT NULL REFERENCES github_user(id) ON DELETE CASCADE,
    github_repo_id integer NOT NULL REFERENCES github_repo(id) ON DELETE CASCADE,
    contributor_activity_type text NOT NULL,
    contributor_activity_date timestamp with time zone  NOT NULL 
);

COMMIT;
