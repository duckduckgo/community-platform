BEGIN;
ALTER TABLE instant_answer_topics DROP CONSTRAINT instant_answer_topics_fk_topics_id;
ALTER TABLE instant_answer_topics ADD CONSTRAINT instant_answer_topics_fk_topics_id FOREIGN KEY (topics_id)
  REFERENCES topics (id) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;
COMMIT;
