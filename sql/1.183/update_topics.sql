BEGIN;
TRUNCATE TABLE instant_answer_topics;
TRUNCATE TABLE topics CASCADE;
INSERT INTO topics (name) VALUES ('python');
INSERT INTO topics (name) VALUES ('swift');
INSERT INTO topics (name) VALUES ('javascript');
INSERT INTO topics (name) VALUES ('css');
INSERT INTO topics (name) VALUES ('perl');

# do stuff add stack_overflow to all topics

COMMIT;
