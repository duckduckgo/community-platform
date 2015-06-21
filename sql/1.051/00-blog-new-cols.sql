BEGIN;

ALTER TABLE user_blog DROP CONSTRAINT user_blog_fk_language_id;

ALTER TABLE user_blog DROP CONSTRAINT user_blog_fk_translation_of_id;

ALTER TABLE user_blog DROP CONSTRAINT user_blog_fk_users_id;

ALTER TABLE user_blog DROP COLUMN translation_of_id;

ALTER TABLE user_blog DROP COLUMN language_id;

ALTER TABLE user_blog DROP COLUMN data;

ALTER TABLE user_blog ADD COLUMN format varchar(8) DEFAULT 'markdown' NOT NULL;

ALTER TABLE user_blog ADD CONSTRAINT user_blog_fk_users_id FOREIGN KEY (users_id)
  REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

UPDATE user_blog SET format = 'html' WHERE raw_html = 1;

UPDATE user_blog SET format = 'bbcode' WHERE raw_html = 0;

ALTER TABLE user_blog DROP COLUMN raw_html;

COMMIT;


