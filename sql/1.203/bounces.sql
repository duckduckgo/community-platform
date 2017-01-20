ALTER TABLE subscriber ADD COLUMN bounced integer DEFAULT 0 NOT NULL;
ALTER TABLE subscriber ADD COLUMN complaint integer DEFAULT 0 NOT NULL;
