SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: api_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.api_keys (
    id integer NOT NULL,
    value character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: api_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.api_keys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: api_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.api_keys_id_seq OWNED BY public.api_keys.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: info_sud_courts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.info_sud_courts (
    id integer NOT NULL,
    guid character varying NOT NULL,
    data jsonb DEFAULT '"{}"'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: info_sud_courts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.info_sud_courts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: info_sud_courts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.info_sud_courts_id_seq OWNED BY public.info_sud_courts.id;


--
-- Name: info_sud_decrees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.info_sud_decrees (
    id integer NOT NULL,
    guid character varying NOT NULL,
    data jsonb DEFAULT '"{}"'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: info_sud_decrees_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.info_sud_decrees_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: info_sud_decrees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.info_sud_decrees_id_seq OWNED BY public.info_sud_decrees.id;


--
-- Name: info_sud_hearings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.info_sud_hearings (
    id integer NOT NULL,
    guid character varying NOT NULL,
    data jsonb DEFAULT '"{}"'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: info_sud_hearings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.info_sud_hearings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: info_sud_hearings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.info_sud_hearings_id_seq OWNED BY public.info_sud_hearings.id;


--
-- Name: info_sud_judges; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.info_sud_judges (
    id integer NOT NULL,
    guid character varying NOT NULL,
    data jsonb DEFAULT '"{}"'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: info_sud_judges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.info_sud_judges_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: info_sud_judges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.info_sud_judges_id_seq OWNED BY public.info_sud_judges.id;


--
-- Name: invites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invites (
    id integer NOT NULL,
    email character varying NOT NULL,
    locale character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: invites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.invites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.invites_id_seq OWNED BY public.invites.id;


--
-- Name: justice_gov_sk_pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.justice_gov_sk_pages (
    id bigint NOT NULL,
    model character varying DEFAULT '0'::character varying NOT NULL,
    "integer" character varying DEFAULT '0'::character varying NOT NULL,
    uri character varying NOT NULL,
    data jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: justice_gov_sk_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.justice_gov_sk_pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: justice_gov_sk_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.justice_gov_sk_pages_id_seq OWNED BY public.justice_gov_sk_pages.id;


--
-- Name: obcan_justice_sk_civil_hearings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.obcan_justice_sk_civil_hearings (
    id bigint NOT NULL,
    guid character varying NOT NULL,
    uri character varying NOT NULL,
    data jsonb DEFAULT '"{}"'::jsonb NOT NULL,
    checksum character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: obcan_justice_sk_civil_hearings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.obcan_justice_sk_civil_hearings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: obcan_justice_sk_civil_hearings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.obcan_justice_sk_civil_hearings_id_seq OWNED BY public.obcan_justice_sk_civil_hearings.id;


--
-- Name: obcan_justice_sk_courts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.obcan_justice_sk_courts (
    id bigint NOT NULL,
    guid character varying NOT NULL,
    uri character varying NOT NULL,
    data jsonb DEFAULT '"{}"'::jsonb NOT NULL,
    checksum character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: obcan_justice_sk_courts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.obcan_justice_sk_courts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: obcan_justice_sk_courts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.obcan_justice_sk_courts_id_seq OWNED BY public.obcan_justice_sk_courts.id;


--
-- Name: obcan_justice_sk_criminal_hearings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.obcan_justice_sk_criminal_hearings (
    id bigint NOT NULL,
    guid character varying NOT NULL,
    uri character varying NOT NULL,
    data jsonb DEFAULT '"{}"'::jsonb NOT NULL,
    checksum character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: obcan_justice_sk_criminal_hearings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.obcan_justice_sk_criminal_hearings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: obcan_justice_sk_criminal_hearings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.obcan_justice_sk_criminal_hearings_id_seq OWNED BY public.obcan_justice_sk_criminal_hearings.id;


--
-- Name: obcan_justice_sk_decrees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.obcan_justice_sk_decrees (
    id bigint NOT NULL,
    guid character varying NOT NULL,
    uri character varying NOT NULL,
    data jsonb DEFAULT '"{}"'::jsonb NOT NULL,
    checksum character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: obcan_justice_sk_decrees_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.obcan_justice_sk_decrees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: obcan_justice_sk_decrees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.obcan_justice_sk_decrees_id_seq OWNED BY public.obcan_justice_sk_decrees.id;


--
-- Name: obcan_justice_sk_judges; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.obcan_justice_sk_judges (
    id bigint NOT NULL,
    guid character varying NOT NULL,
    uri character varying NOT NULL,
    data jsonb DEFAULT '"{}"'::jsonb NOT NULL,
    checksum character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: obcan_justice_sk_judges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.obcan_justice_sk_judges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: obcan_justice_sk_judges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.obcan_justice_sk_judges_id_seq OWNED BY public.obcan_justice_sk_judges.id;


--
-- Name: public_prosecutor_refinements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.public_prosecutor_refinements (
    id integer NOT NULL,
    name character varying NOT NULL,
    email character varying NOT NULL,
    ip_address character varying NOT NULL,
    prosecutor character varying NOT NULL,
    office character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: public_prosecutor_refinements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.public_prosecutor_refinements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: public_prosecutor_refinements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.public_prosecutor_refinements_id_seq OWNED BY public.public_prosecutor_refinements.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: api_keys id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_keys ALTER COLUMN id SET DEFAULT nextval('public.api_keys_id_seq'::regclass);


--
-- Name: info_sud_courts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_sud_courts ALTER COLUMN id SET DEFAULT nextval('public.info_sud_courts_id_seq'::regclass);


--
-- Name: info_sud_decrees id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_sud_decrees ALTER COLUMN id SET DEFAULT nextval('public.info_sud_decrees_id_seq'::regclass);


--
-- Name: info_sud_hearings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_sud_hearings ALTER COLUMN id SET DEFAULT nextval('public.info_sud_hearings_id_seq'::regclass);


--
-- Name: info_sud_judges id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_sud_judges ALTER COLUMN id SET DEFAULT nextval('public.info_sud_judges_id_seq'::regclass);


--
-- Name: invites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invites ALTER COLUMN id SET DEFAULT nextval('public.invites_id_seq'::regclass);


--
-- Name: justice_gov_sk_pages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.justice_gov_sk_pages ALTER COLUMN id SET DEFAULT nextval('public.justice_gov_sk_pages_id_seq'::regclass);


--
-- Name: obcan_justice_sk_civil_hearings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.obcan_justice_sk_civil_hearings ALTER COLUMN id SET DEFAULT nextval('public.obcan_justice_sk_civil_hearings_id_seq'::regclass);


--
-- Name: obcan_justice_sk_courts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.obcan_justice_sk_courts ALTER COLUMN id SET DEFAULT nextval('public.obcan_justice_sk_courts_id_seq'::regclass);


--
-- Name: obcan_justice_sk_criminal_hearings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.obcan_justice_sk_criminal_hearings ALTER COLUMN id SET DEFAULT nextval('public.obcan_justice_sk_criminal_hearings_id_seq'::regclass);


--
-- Name: obcan_justice_sk_decrees id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.obcan_justice_sk_decrees ALTER COLUMN id SET DEFAULT nextval('public.obcan_justice_sk_decrees_id_seq'::regclass);


--
-- Name: obcan_justice_sk_judges id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.obcan_justice_sk_judges ALTER COLUMN id SET DEFAULT nextval('public.obcan_justice_sk_judges_id_seq'::regclass);


--
-- Name: public_prosecutor_refinements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.public_prosecutor_refinements ALTER COLUMN id SET DEFAULT nextval('public.public_prosecutor_refinements_id_seq'::regclass);


--
-- Name: api_keys api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: info_sud_courts info_sud_courts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_sud_courts
    ADD CONSTRAINT info_sud_courts_pkey PRIMARY KEY (id);


--
-- Name: info_sud_decrees info_sud_decrees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_sud_decrees
    ADD CONSTRAINT info_sud_decrees_pkey PRIMARY KEY (id);


--
-- Name: info_sud_hearings info_sud_hearings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_sud_hearings
    ADD CONSTRAINT info_sud_hearings_pkey PRIMARY KEY (id);


--
-- Name: info_sud_judges info_sud_judges_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_sud_judges
    ADD CONSTRAINT info_sud_judges_pkey PRIMARY KEY (id);


--
-- Name: invites invites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invites
    ADD CONSTRAINT invites_pkey PRIMARY KEY (id);


--
-- Name: justice_gov_sk_pages justice_gov_sk_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.justice_gov_sk_pages
    ADD CONSTRAINT justice_gov_sk_pages_pkey PRIMARY KEY (id);


--
-- Name: obcan_justice_sk_civil_hearings obcan_justice_sk_civil_hearings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.obcan_justice_sk_civil_hearings
    ADD CONSTRAINT obcan_justice_sk_civil_hearings_pkey PRIMARY KEY (id);


--
-- Name: obcan_justice_sk_courts obcan_justice_sk_courts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.obcan_justice_sk_courts
    ADD CONSTRAINT obcan_justice_sk_courts_pkey PRIMARY KEY (id);


--
-- Name: obcan_justice_sk_criminal_hearings obcan_justice_sk_criminal_hearings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.obcan_justice_sk_criminal_hearings
    ADD CONSTRAINT obcan_justice_sk_criminal_hearings_pkey PRIMARY KEY (id);


--
-- Name: obcan_justice_sk_decrees obcan_justice_sk_decrees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.obcan_justice_sk_decrees
    ADD CONSTRAINT obcan_justice_sk_decrees_pkey PRIMARY KEY (id);


--
-- Name: obcan_justice_sk_judges obcan_justice_sk_judges_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.obcan_justice_sk_judges
    ADD CONSTRAINT obcan_justice_sk_judges_pkey PRIMARY KEY (id);


--
-- Name: public_prosecutor_refinements public_prosecutor_refinements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.public_prosecutor_refinements
    ADD CONSTRAINT public_prosecutor_refinements_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: index_api_keys_on_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_api_keys_on_value ON public.api_keys USING btree (value);


--
-- Name: index_info_sud_courts_on_guid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_info_sud_courts_on_guid ON public.info_sud_courts USING btree (guid);


--
-- Name: index_info_sud_decrees_on_guid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_info_sud_decrees_on_guid ON public.info_sud_decrees USING btree (guid);


--
-- Name: index_info_sud_hearings_on_guid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_info_sud_hearings_on_guid ON public.info_sud_hearings USING btree (guid);


--
-- Name: index_info_sud_judges_on_guid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_info_sud_judges_on_guid ON public.info_sud_judges USING btree (guid);


--
-- Name: index_invites_on_email_and_locale; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_invites_on_email_and_locale ON public.invites USING btree (email, locale);


--
-- Name: index_justice_gov_sk_pages_on_uri; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_justice_gov_sk_pages_on_uri ON public.justice_gov_sk_pages USING btree (uri);


--
-- Name: index_obcan_justice_sk_civil_hearings_on_checksum; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_obcan_justice_sk_civil_hearings_on_checksum ON public.obcan_justice_sk_civil_hearings USING btree (checksum);


--
-- Name: index_obcan_justice_sk_civil_hearings_on_data; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_obcan_justice_sk_civil_hearings_on_data ON public.obcan_justice_sk_civil_hearings USING gin (data);


--
-- Name: index_obcan_justice_sk_civil_hearings_on_guid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_obcan_justice_sk_civil_hearings_on_guid ON public.obcan_justice_sk_civil_hearings USING btree (guid);


--
-- Name: index_obcan_justice_sk_civil_hearings_on_uri; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_obcan_justice_sk_civil_hearings_on_uri ON public.obcan_justice_sk_civil_hearings USING btree (uri);


--
-- Name: index_obcan_justice_sk_courts_on_checksum; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_obcan_justice_sk_courts_on_checksum ON public.obcan_justice_sk_courts USING btree (checksum);


--
-- Name: index_obcan_justice_sk_courts_on_data; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_obcan_justice_sk_courts_on_data ON public.obcan_justice_sk_courts USING gin (data);


--
-- Name: index_obcan_justice_sk_courts_on_guid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_obcan_justice_sk_courts_on_guid ON public.obcan_justice_sk_courts USING btree (guid);


--
-- Name: index_obcan_justice_sk_courts_on_uri; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_obcan_justice_sk_courts_on_uri ON public.obcan_justice_sk_courts USING btree (uri);


--
-- Name: index_obcan_justice_sk_criminal_hearings_on_checksum; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_obcan_justice_sk_criminal_hearings_on_checksum ON public.obcan_justice_sk_criminal_hearings USING btree (checksum);


--
-- Name: index_obcan_justice_sk_criminal_hearings_on_data; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_obcan_justice_sk_criminal_hearings_on_data ON public.obcan_justice_sk_criminal_hearings USING gin (data);


--
-- Name: index_obcan_justice_sk_criminal_hearings_on_guid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_obcan_justice_sk_criminal_hearings_on_guid ON public.obcan_justice_sk_criminal_hearings USING btree (guid);


--
-- Name: index_obcan_justice_sk_criminal_hearings_on_uri; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_obcan_justice_sk_criminal_hearings_on_uri ON public.obcan_justice_sk_criminal_hearings USING btree (uri);


--
-- Name: index_obcan_justice_sk_decrees_on_checksum; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_obcan_justice_sk_decrees_on_checksum ON public.obcan_justice_sk_decrees USING btree (checksum);


--
-- Name: index_obcan_justice_sk_decrees_on_data; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_obcan_justice_sk_decrees_on_data ON public.obcan_justice_sk_decrees USING gin (data);


--
-- Name: index_obcan_justice_sk_decrees_on_guid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_obcan_justice_sk_decrees_on_guid ON public.obcan_justice_sk_decrees USING btree (guid);


--
-- Name: index_obcan_justice_sk_decrees_on_uri; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_obcan_justice_sk_decrees_on_uri ON public.obcan_justice_sk_decrees USING btree (uri);


--
-- Name: index_obcan_justice_sk_judges_on_checksum; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_obcan_justice_sk_judges_on_checksum ON public.obcan_justice_sk_judges USING btree (checksum);


--
-- Name: index_obcan_justice_sk_judges_on_data; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_obcan_justice_sk_judges_on_data ON public.obcan_justice_sk_judges USING gin (data);


--
-- Name: index_obcan_justice_sk_judges_on_guid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_obcan_justice_sk_judges_on_guid ON public.obcan_justice_sk_judges USING btree (guid);


--
-- Name: index_obcan_justice_sk_judges_on_uri; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_obcan_justice_sk_judges_on_uri ON public.obcan_justice_sk_judges USING btree (uri);


--
-- Name: index_public_prosecutor_refinements_on_ip_address; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_public_prosecutor_refinements_on_ip_address ON public.public_prosecutor_refinements USING btree (ip_address);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20240406084627'),
('20240129212609'),
('20170304203708'),
('20160706000015'),
('20151221185525'),
('20151221185405'),
('20151221182850'),
('20151220191833'),
('20151204145601'),
('20151204143202'),
('20151204141114'),
('20151125160428'),
('20151102130857'),
('20151101174415');

