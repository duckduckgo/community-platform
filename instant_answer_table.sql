--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: instant_answer; Type: TABLE; Schema: public; Owner: ddgc; Tablespace: 
--

CREATE TABLE instant_answer (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    perl_module text,
    dev_milestone text,
    milestone_dates text,
    status text,
    repo text,
    topic text,
    code text,
    src_name text,
    src_url text,
    src_api_documentation text,
    icon_url text,
    screenshot text,
    template_group text,
    custom_templates text,
    example_query text,
    other_queries text,
    signal_from text,
    tab text,
    attribution_orig text,
    template text,
    attribution text,
    screenshots text,
    unsafe integer,
    type text,
    producer text,
    src_options text,
    src_id integer,
    src_domain text,
    perl_dependencies text,
    is_live integer,
    mockups text,
    triggers text,
    designer text,
    developer text,
    code_review integer,
    design_review integer,
    test_machine text,
    browsers_ie integer,
    browsers_chrome integer,
    browsers_firefox integer,
    browsers_safari integer,
    browsers_opera integer,
    mobile_android integer,
    mobile_ios integer,
    tested_relevancy integer,
    tested_staging integer,
    answerbar text,
    api_status_page text,
    meta_id text,
    dev_date date,
    live_date date,
    created_date date,
    is_stackexchange integer,
    forum_link text,
    last_commit text,
    last_comment text,
    last_update text
);


ALTER TABLE public.instant_answer OWNER TO ddgc;

--
-- Name: instant_answer_pkey; Type: CONSTRAINT; Schema: public; Owner: ddgc; Tablespace: 
--

ALTER TABLE ONLY instant_answer
    ADD CONSTRAINT instant_answer_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

