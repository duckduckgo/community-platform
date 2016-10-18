CREATE TABLE subscriber (
    email_address text NOT NULL,
    campaign text NOT NULL,
    created timestamp with time zone NOT NULL,
    verified integer DEFAULT 0 NOT NULL,
    unsubscribed integer DEFAULT 0 NOT NULL,
    v_key text NOT NULL,
    u_key text NOT NULL
);

CREATE TABLE subscriber_maillog (
    email_address text NOT NULL,
    campaign text NOT NULL,
    email_id character(1) NOT NULL,
    sent timestamp with time zone NOT NULL
);

ALTER TABLE ONLY subscriber
    ADD CONSTRAINT subscriber_pkey PRIMARY KEY (email_address, campaign);

ALTER TABLE ONLY subscriber_maillog
    ADD CONSTRAINT subscriber_maillog_pkey PRIMARY KEY (email_address, campaign, email_id);

CREATE INDEX subscriber_maillog_idx_email_address_campaign ON subscriber_maillog USING btree (email_address, campaign);

ALTER TABLE ONLY subscriber_maillog
    ADD CONSTRAINT subscriber_maillog_fk_email_address_campaign FOREIGN KEY (email_address, campaign) REFERENCES subscriber(email_address, campaign) DEFERRABLE;

