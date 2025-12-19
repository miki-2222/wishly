--
-- PostgreSQL database dump
--

\restrict 9WLM6XBPF3kLamws5i5CZybG2acXKC1SKOF71Q1JkZAajAoGdG9QdWjVs7dH75u

-- Dumped from database version 15.15 (Debian 15.15-1.pgdg13+1)
-- Dumped by pg_dump version 15.15 (Debian 15.15-1.pgdg13+1)

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
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO postgres;

--
-- Name: items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.items (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    name character varying NOT NULL,
    price integer,
    memo text,
    status integer DEFAULT 0 NOT NULL,
    release_date date,
    reservation_start_date date,
    reservation_end_date date,
    purchased_at date,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.items OWNER TO postgres;

--
-- Name: items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.items_id_seq OWNER TO postgres;

--
-- Name: items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.items_id_seq OWNED BY public.items.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    name character varying NOT NULL,
    remember_created_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items ALTER COLUMN id SET DEFAULT nextval('public.items_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	development	2025-12-17 16:21:36.669254	2025-12-17 16:21:36.669256
\.


--
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.items (id, user_id, name, price, memo, status, release_date, reservation_start_date, reservation_end_date, purchased_at, created_at, updated_at) FROM stdin;
1	1	テストアイテム	1000	\N	1	\N	\N	\N	\N	2025-12-19 03:31:12.194178	2025-12-19 03:32:02.173835
2	1	アイテムA	1000	\N	0	\N	\N	\N	\N	2025-12-19 03:33:02.576983	2025-12-19 03:33:02.576983
10	2	アイテム未予約	7000	🤔	0	\N	2025-12-25	2026-02-01	\N	2025-12-19 14:31:12.559553	2025-12-19 14:31:12.559553
8	2	アイテム購入済み	1000	店舗	20	2024-11-13	\N	\N	2024-12-03	2025-12-19 14:28:44.794505	2025-12-19 14:50:41.257471
9	2	アイテム予約中	5000	オンライン	10	2026-01-15	2025-12-11	\N	2025-12-17	2025-12-19 14:29:49.655713	2025-12-19 15:04:39.576816
14	3	アイテム購入済み	1000		20	\N	\N	\N	2025-12-10	2025-12-19 15:23:59.378416	2025-12-19 15:23:59.378416
16	3	アイテム未予約	50000	🤔	0	2026-02-14	2025-12-01	2025-12-31	\N	2025-12-19 15:26:08.266535	2025-12-19 15:26:08.266535
15	3	アイテム予約中	5000	オンライン	10	2025-12-31	\N	2025-11-08	\N	2025-12-19 15:24:47.225514	2025-12-19 15:26:51.514944
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.schema_migrations (version) FROM stdin;
20251216232855
20251218190611
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, encrypted_password, name, remember_created_at, created_at, updated_at) FROM stdin;
1	test@example.com	$2a$12$/P/fZ1VTy1CkKNzgsoRiuOLgrd/rYB2elrfSMUrEd3emrbpM2BImm	テストユーザー	\N	2025-12-17 16:23:58.87747	2025-12-17 16:23:58.87747
2	ninntama@nhk.jp	$2a$12$NjiznM4d9NWrlz8Kzik8b.tUCGhIKHOKCG5OCYfBujGuSyCGoM75W	久々知	\N	2025-12-17 16:45:42.083607	2025-12-19 09:53:01.076419
3	user@user.jp	$2a$12$NwDFyM8sq1kjHKsPqeZhNOhqN0dHs8cewBRjh9/XuKH4/K2Ss0yke	user	\N	2025-12-19 15:23:35.211644	2025-12-19 15:23:35.211644
\.


--
-- Name: items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.items_id_seq', 16, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 3, true);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_items_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_items_on_user_id ON public.items USING btree (user_id);


--
-- Name: index_items_on_user_id_and_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_items_on_user_id_and_created_at ON public.items USING btree (user_id, created_at);


--
-- Name: index_items_on_user_id_and_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_items_on_user_id_and_status ON public.items USING btree (user_id, status);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: items fk_rails_d4b6334db2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT fk_rails_d4b6334db2 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

\unrestrict 9WLM6XBPF3kLamws5i5CZybG2acXKC1SKOF71Q1JkZAajAoGdG9QdWjVs7dH75u

