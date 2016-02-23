--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET search_path = public, pg_catalog;

--
-- Name: comment_report_resolution; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE comment_report_resolution AS ENUM (
    'resolved',
    'invalid',
    'acknowledged',
    'new'
);


ALTER TYPE comment_report_resolution OWNER TO postgres;

--
-- Name: resource_rating; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE resource_rating AS ENUM (
    '1',
    '2',
    '3',
    '4',
    '5'
);


ALTER TYPE resource_rating OWNER TO postgres;

--
-- Name: token_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE token_type AS ENUM (
    'activate',
    'password_reset'
);


ALTER TYPE token_type OWNER TO postgres;

--
-- Name: get_package_dependencies(integer, integer[], integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_package_dependencies(src integer, alldeps integer[] DEFAULT '{}'::integer[], self integer DEFAULT NULL::integer) RETURNS integer[]
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    deps integer[] := '{}';
    pkg integer;
BEGIN
	IF self IS NULL THEN
		self = src;
	END IF;
	--ARRAY_APPEND(deps, 30)
	--FOR i IN 1..src LOOP
	--	deps := array_append(deps, i);
	--END LOOP;
	--SELECT array_agg(i) INTO deps FROM generate_series(1, src) AS i;
	SELECT array_agg(package) INTO deps FROM (
		SELECT package FROM package_dependencies WHERE source_package = src
	) AS dep;

	-- Go through deps
	-- Is it in allDeps?
	-- If not, add to alldeps and run the function!
	IF deps IS NOT NULL THEN
		FOREACH pkg IN ARRAY deps LOOP
			IF ((pkg = self) or (SELECT pkg = ANY(allDeps))) THEN
				-- That's fine, ignore this.
				RAISE NOTICE 'reading dep % twice', pkg;
			ELSE
				RAISE NOTICE 'trying to add %', pkg;
				allDeps = array_append(allDeps, pkg);
				allDeps = get_package_dependencies(pkg, allDeps, self);
			END IF;
		END LOOP;
	END IF;		
	
	RETURN allDeps;
END;
$$;


ALTER FUNCTION public.get_package_dependencies(src integer, alldeps integer[], self integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: bans; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE bans (
    id integer NOT NULL,
    banner integer NOT NULL,
    banned_user integer NOT NULL,
    reason text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    active boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE bans OWNER TO postgres;

--
-- Name: bans_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE bans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bans_id_seq OWNER TO postgres;

--
-- Name: bans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE bans_id_seq OWNED BY bans.id;


--
-- Name: comment_reports; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE comment_reports (
    id integer NOT NULL,
    reporter integer NOT NULL,
    reported_comment integer NOT NULL,
    closed boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    status comment_report_resolution DEFAULT 'new'::comment_report_resolution NOT NULL
);


ALTER TABLE comment_reports OWNER TO postgres;

--
-- Name: comment_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE comment_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comment_reports_id_seq OWNER TO postgres;

--
-- Name: comment_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE comment_reports_id_seq OWNED BY comment_reports.id;


--
-- Name: comment_reports_reporter_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE comment_reports_reporter_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comment_reports_reporter_seq OWNER TO postgres;

--
-- Name: comment_reports_reporter_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE comment_reports_reporter_seq OWNED BY comment_reports.reporter;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE comments (
    id integer NOT NULL,
    parent integer,
    author integer NOT NULL,
    message text NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    resource integer NOT NULL,
    edited_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE comments OWNER TO postgres;

--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comments_id_seq OWNER TO postgres;

--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: lapis_migrations; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE lapis_migrations (
    name character varying(255) NOT NULL
);


ALTER TABLE lapis_migrations OWNER TO postgres;

--
-- Name: package_dependencies; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE package_dependencies (
    source_package integer NOT NULL,
    package integer NOT NULL,
    needs_version boolean NOT NULL
);


ALTER TABLE package_dependencies OWNER TO postgres;

--
-- Name: COLUMN package_dependencies.needs_version; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN package_dependencies.needs_version IS 'Whenever a new package is uploaded by a resource, it will update all dependencies with needs_version set to false to the newest package.';


--
-- Name: resource_admins; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE resource_admins (
    resource integer NOT NULL,
    "user" integer NOT NULL,
    can_configure boolean DEFAULT false NOT NULL,
    can_moderate boolean DEFAULT false NOT NULL,
    can_manage boolean DEFAULT false NOT NULL,
    can_upload_packages boolean DEFAULT false NOT NULL,
    can_upload_screenshots boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    user_confirmed boolean DEFAULT false NOT NULL
);


ALTER TABLE resource_admins OWNER TO postgres;

--
-- Name: resource_packages; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE resource_packages (
    id integer NOT NULL,
    resource integer NOT NULL,
    file text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    description text NOT NULL,
    download_count integer DEFAULT 0 NOT NULL,
    version character varying(10) NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    uploader integer
);


ALTER TABLE resource_packages OWNER TO postgres;

--
-- Name: resource_packages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE resource_packages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE resource_packages_id_seq OWNER TO postgres;

--
-- Name: resource_packages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE resource_packages_id_seq OWNED BY resource_packages.id;


--
-- Name: resource_ratings; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE resource_ratings (
    "user" integer NOT NULL,
    resource integer NOT NULL,
    rating resource_rating NOT NULL
);


ALTER TABLE resource_ratings OWNER TO postgres;

--
-- Name: resource_screenshots; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE resource_screenshots (
    id integer NOT NULL,
    resource integer NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    file text NOT NULL,
    uploader integer,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE resource_screenshots OWNER TO postgres;

--
-- Name: resource_screenshots_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE resource_screenshots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE resource_screenshots_id_seq OWNER TO postgres;

--
-- Name: resource_screenshots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE resource_screenshots_id_seq OWNED BY resource_screenshots.id;


--
-- Name: resources; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE resources (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    longname character varying(255) NOT NULL,
    rating real DEFAULT 0 NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    creator integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    downloads integer DEFAULT 0 NOT NULL,
    type integer NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    slug character varying(255) NOT NULL
);


ALTER TABLE resources OWNER TO postgres;

--
-- Name: resources_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE resources_id_seq OWNER TO postgres;

--
-- Name: resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE resources_id_seq OWNED BY resources.id;


--
-- Name: user_data; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE user_data (
    user_id integer NOT NULL,
    location character varying(255),
    gang character varying(255),
    website character varying(255),
    about text,
    privacy_mode integer DEFAULT 1 NOT NULL,
    birthday date
);


ALTER TABLE user_data OWNER TO postgres;

--
-- Name: user_followings; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE user_followings (
    follower integer NOT NULL,
    following integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE user_followings OWNER TO postgres;

--
-- Name: user_tokens; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE user_tokens (
    id character varying(20) NOT NULL,
    owner integer NOT NULL,
    type integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    expires_at timestamp without time zone NOT NULL
);


ALTER TABLE user_tokens OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    password character(60) NOT NULL,
    email character varying(254) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    activated boolean DEFAULT false NOT NULL,
    banned boolean DEFAULT false NOT NULL,
    slug character varying(255) NOT NULL,
    level integer DEFAULT 1 NOT NULL
);


ALTER TABLE users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY bans ALTER COLUMN id SET DEFAULT nextval('bans_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comment_reports ALTER COLUMN id SET DEFAULT nextval('comment_reports_id_seq'::regclass);


--
-- Name: reporter; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comment_reports ALTER COLUMN reporter SET DEFAULT nextval('comment_reports_reporter_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY resource_packages ALTER COLUMN id SET DEFAULT nextval('resource_packages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY resource_screenshots ALTER COLUMN id SET DEFAULT nextval('resource_screenshots_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY resources ALTER COLUMN id SET DEFAULT nextval('resources_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: bans_id_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY bans
    ADD CONSTRAINT bans_id_pkey PRIMARY KEY (id);


--
-- Name: comment_reports_id_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY comment_reports
    ADD CONSTRAINT comment_reports_id_pkey PRIMARY KEY (id);


--
-- Name: comments_id_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_id_pkey PRIMARY KEY (id);


--
-- Name: lapis_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY lapis_migrations
    ADD CONSTRAINT lapis_migrations_pkey PRIMARY KEY (name);


--
-- Name: resource_admins_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY resource_admins
    ADD CONSTRAINT resource_admins_pkey PRIMARY KEY (resource, "user");


--
-- Name: resource_dependencies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY package_dependencies
    ADD CONSTRAINT resource_dependencies_pkey PRIMARY KEY (source_package, package);


--
-- Name: resource_packages_id_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY resource_packages
    ADD CONSTRAINT resource_packages_id_pkey PRIMARY KEY (id);


--
-- Name: resource_packages_resver_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY resource_packages
    ADD CONSTRAINT resource_packages_resver_key UNIQUE (resource, version);


--
-- Name: resource_ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY resource_ratings
    ADD CONSTRAINT resource_ratings_pkey PRIMARY KEY ("user", resource);


--
-- Name: resource_screenshots_id_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY resource_screenshots
    ADD CONSTRAINT resource_screenshots_id_pkey PRIMARY KEY (id);


--
-- Name: resources_id_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY resources
    ADD CONSTRAINT resources_id_pkey PRIMARY KEY (id);


--
-- Name: user_data_id_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user_data
    ADD CONSTRAINT user_data_id_pkey PRIMARY KEY (user_id);


--
-- Name: user_followings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user_followings
    ADD CONSTRAINT user_followings_pkey PRIMARY KEY (follower, following);


--
-- Name: user_tokens_id_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user_tokens
    ADD CONSTRAINT user_tokens_id_pkey PRIMARY KEY (id);


--
-- Name: users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users_id_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_id_pkey PRIMARY KEY (id);


--
-- Name: users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: fki_comment_reports_reported_comment_fkey; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_comment_reports_reported_comment_fkey ON comment_reports USING btree (reported_comment);


--
-- Name: fki_comment_reports_reporter_fkey; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_comment_reports_reporter_fkey ON comment_reports USING btree (reporter);


--
-- Name: fki_comments_parent_fkey; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_comments_parent_fkey ON comments USING btree (parent);


--
-- Name: fki_resource_admins_user_fkey; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_resource_admins_user_fkey ON resource_admins USING btree ("user");


--
-- Name: fki_resource_dependencies_target_fkey; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_resource_dependencies_target_fkey ON package_dependencies USING btree (package);


--
-- Name: fki_resource_packages_resource_fkey; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_resource_packages_resource_fkey ON resource_packages USING btree (resource);


--
-- Name: fki_resource_packages_uploader_fkey; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_resource_packages_uploader_fkey ON resource_packages USING btree (uploader);


--
-- Name: fki_resource_ratings_resource_fkey; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_resource_ratings_resource_fkey ON resource_ratings USING btree (resource);


--
-- Name: fki_resource_screenshots_resource_fkey; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_resource_screenshots_resource_fkey ON resource_screenshots USING btree (resource);


--
-- Name: fki_resource_screenshots_uploader_fkey; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_resource_screenshots_uploader_fkey ON resource_screenshots USING btree (uploader);


--
-- Name: fki_resources_creator_fkey; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_resources_creator_fkey ON resources USING btree (creator);


--
-- Name: fki_user_data_id_fkey; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_user_data_id_fkey ON user_data USING btree (user_id);


--
-- Name: bans_banned_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY bans
    ADD CONSTRAINT bans_banned_user_fkey FOREIGN KEY (banned_user) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: bans_banner_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY bans
    ADD CONSTRAINT bans_banner_fkey FOREIGN KEY (banner) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: comment_reports_reported_comment_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comment_reports
    ADD CONSTRAINT comment_reports_reported_comment_fkey FOREIGN KEY (reported_comment) REFERENCES comments(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: comment_reports_reporter_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comment_reports
    ADD CONSTRAINT comment_reports_reporter_fkey FOREIGN KEY (reporter) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: comments_author_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_author_fkey FOREIGN KEY (author) REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: comments_parent_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_parent_fkey FOREIGN KEY (parent) REFERENCES comments(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: comments_resource_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_resource_fkey FOREIGN KEY (resource) REFERENCES resources(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: resource_admins_resource_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY resource_admins
    ADD CONSTRAINT resource_admins_resource_fkey FOREIGN KEY (resource) REFERENCES resources(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: resource_admins_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY resource_admins
    ADD CONSTRAINT resource_admins_user_fkey FOREIGN KEY ("user") REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: resource_dependencies_source_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY package_dependencies
    ADD CONSTRAINT resource_dependencies_source_fkey FOREIGN KEY (source_package) REFERENCES resource_packages(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: resource_dependencies_target_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY package_dependencies
    ADD CONSTRAINT resource_dependencies_target_fkey FOREIGN KEY (package) REFERENCES resource_packages(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: resource_packages_resource_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY resource_packages
    ADD CONSTRAINT resource_packages_resource_fkey FOREIGN KEY (resource) REFERENCES resources(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: resource_packages_uploader_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY resource_packages
    ADD CONSTRAINT resource_packages_uploader_fkey FOREIGN KEY (uploader) REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: resource_ratings_resource_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY resource_ratings
    ADD CONSTRAINT resource_ratings_resource_fkey FOREIGN KEY (resource) REFERENCES resources(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: resource_ratings_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY resource_ratings
    ADD CONSTRAINT resource_ratings_user_fkey FOREIGN KEY ("user") REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: resource_screenshots_resource_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY resource_screenshots
    ADD CONSTRAINT resource_screenshots_resource_fkey FOREIGN KEY (resource) REFERENCES resources(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: resource_screenshots_uploader_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY resource_screenshots
    ADD CONSTRAINT resource_screenshots_uploader_fkey FOREIGN KEY (uploader) REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: resources_creator_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY resources
    ADD CONSTRAINT resources_creator_fkey FOREIGN KEY (creator) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_data_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_data
    ADD CONSTRAINT user_data_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_followings_follower_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_followings
    ADD CONSTRAINT user_followings_follower_fkey FOREIGN KEY (follower) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_followings_following_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_followings
    ADD CONSTRAINT user_followings_following_fkey FOREIGN KEY (following) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_tokens_owner_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_tokens
    ADD CONSTRAINT user_tokens_owner_fkey FOREIGN KEY (owner) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Data for Name: lapis_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY lapis_migrations (name) FROM stdin;
\.


--
-- PostgreSQL database dump complete
--

