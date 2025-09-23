--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0
-- Dumped by pg_dump version 17.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: roler; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.roler AS ENUM (
    'client',
    'worker'
);


ALTER TYPE public.roler OWNER TO postgres;

--
-- Name: service_name_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.service_name_enum AS ENUM (
    'ТО',
    'Диагностика',
    'Ремонт'
);


ALTER TYPE public.service_name_enum OWNER TO postgres;

--
-- Name: status_appointment; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.status_appointment AS ENUM (
    'pending',
    'confirmed',
    'completed',
    'cancelled'
);


ALTER TYPE public.status_appointment OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: appointments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appointments (
    id integer NOT NULL,
    client_id integer NOT NULL,
    service_id integer NOT NULL,
    sto_id integer NOT NULL,
    date_time timestamp without time zone NOT NULL,
    status character varying(255) DEFAULT 'pending'::public.status_appointment,
    car character varying(17),
    worker_id integer
);


ALTER TABLE public.appointments OWNER TO postgres;

--
-- Name: appointments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.appointments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.appointments_id_seq OWNER TO postgres;

--
-- Name: appointments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appointments_id_seq OWNED BY public.appointments.id;


--
-- Name: appointments_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.appointments_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.appointments_seq OWNER TO postgres;

--
-- Name: cars; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cars (
    vin character varying(17) NOT NULL,
    brand character varying(50) NOT NULL,
    model character varying(50) NOT NULL,
    year integer,
    mileage integer,
    client_id integer NOT NULL
);


ALTER TABLE public.cars OWNER TO postgres;

--
-- Name: client; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client (
    user_id integer NOT NULL,
    car_brand character varying(20),
    car_model character varying(40),
    car_year integer
);


ALTER TABLE public.client OWNER TO postgres;

--
-- Name: client_reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_reviews (
    id integer NOT NULL,
    client_id integer NOT NULL,
    sto_id integer NOT NULL,
    rating integer,
    comment text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT client_reviews_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE public.client_reviews OWNER TO postgres;

--
-- Name: client_reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.client_reviews_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.client_reviews_id_seq OWNER TO postgres;

--
-- Name: client_reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.client_reviews_id_seq OWNED BY public.client_reviews.id;


--
-- Name: client_reviews_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.client_reviews_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.client_reviews_seq OWNER TO postgres;

--
-- Name: client_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.client_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.client_user_id_seq OWNER TO postgres;

--
-- Name: client_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.client_user_id_seq OWNED BY public.client.user_id;


--
-- Name: inventory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory (
    sto_id integer NOT NULL,
    part_id integer NOT NULL,
    quantity integer DEFAULT 0 NOT NULL,
    CONSTRAINT inventory_quantity_check CHECK ((quantity >= 0))
);


ALTER TABLE public.inventory OWNER TO postgres;

--
-- Name: services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.services (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description text,
    repair_hours double precision NOT NULL,
    sto_id integer NOT NULL
);


ALTER TABLE public.services OWNER TO postgres;

--
-- Name: services_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.services_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.services_id_seq OWNER TO postgres;

--
-- Name: services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.services_id_seq OWNED BY public.services.id;


--
-- Name: services_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.services_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.services_seq OWNER TO postgres;

--
-- Name: spare_part; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.spare_part (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    category character varying(100)
);


ALTER TABLE public.spare_part OWNER TO postgres;

--
-- Name: spare_part_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.spare_part_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.spare_part_id_seq OWNER TO postgres;

--
-- Name: spare_part_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.spare_part_id_seq OWNED BY public.spare_part.id;


--
-- Name: spare_part_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.spare_part_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.spare_part_seq OWNER TO postgres;

--
-- Name: sto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sto (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    address text NOT NULL,
    rating double precision DEFAULT 0.0,
    working_hours text,
    verification_code character varying(2000) NOT NULL
);


ALTER TABLE public.sto OWNER TO postgres;

--
-- Name: sto_id_gen; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sto_id_gen
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sto_id_gen OWNER TO postgres;

--
-- Name: sto_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sto_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sto_id_seq OWNER TO postgres;

--
-- Name: sto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sto_id_seq OWNED BY public.sto.id;


--
-- Name: sto_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sto_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sto_seq OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    email character varying(50) NOT NULL,
    password_hash character varying(255) NOT NULL,
    phone character varying(15),
    role character varying(255),
    client_user_id integer,
    worker_user_id integer
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_gen; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_gen
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_gen OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: users_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_seq OWNER TO postgres;

--
-- Name: worker; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.worker (
    user_id integer NOT NULL,
    specialization character varying(100),
    experience_years integer,
    sto_id integer
);


ALTER TABLE public.worker OWNER TO postgres;

--
-- Name: worker_reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.worker_reviews (
    id integer NOT NULL,
    worker_id integer NOT NULL,
    hours_for_complete character varying(50),
    service_name character varying(255),
    comment text,
    auto_model character varying(50),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    appointment_id integer
);


ALTER TABLE public.worker_reviews OWNER TO postgres;

--
-- Name: worker_reviews_id_gen; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.worker_reviews_id_gen
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.worker_reviews_id_gen OWNER TO postgres;

--
-- Name: worker_reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.worker_reviews_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.worker_reviews_id_seq OWNER TO postgres;

--
-- Name: worker_reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.worker_reviews_id_seq OWNED BY public.worker_reviews.id;


--
-- Name: worker_reviews_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.worker_reviews_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.worker_reviews_seq OWNER TO postgres;

--
-- Name: worker_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.worker_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.worker_user_id_seq OWNER TO postgres;

--
-- Name: worker_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.worker_user_id_seq OWNED BY public.worker.user_id;


--
-- Name: appointments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments ALTER COLUMN id SET DEFAULT nextval('public.appointments_id_seq'::regclass);


--
-- Name: client user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client ALTER COLUMN user_id SET DEFAULT nextval('public.client_user_id_seq'::regclass);


--
-- Name: client_reviews id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_reviews ALTER COLUMN id SET DEFAULT nextval('public.client_reviews_id_seq'::regclass);


--
-- Name: services id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services ALTER COLUMN id SET DEFAULT nextval('public.services_id_seq'::regclass);


--
-- Name: spare_part id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.spare_part ALTER COLUMN id SET DEFAULT nextval('public.spare_part_id_seq'::regclass);


--
-- Name: sto id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto ALTER COLUMN id SET DEFAULT nextval('public.sto_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: worker user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker ALTER COLUMN user_id SET DEFAULT nextval('public.worker_user_id_seq'::regclass);


--
-- Name: worker_reviews id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker_reviews ALTER COLUMN id SET DEFAULT nextval('public.worker_reviews_id_seq'::regclass);


--
-- Data for Name: appointments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.appointments (id, client_id, service_id, sto_id, date_time, status, car, worker_id) FROM stdin;
1	5	1	3	2025-08-10 14:30:00	confirmed	\N	\N
2	502	1	3	2026-12-13 04:15:00	ACCEPTED	\N	\N
52	502	1	3	2025-05-30 11:00:00	REJECTED	\N	\N
55	502	1	3	2025-12-12 04:15:00	REJECTED	\N	\N
702	502	1	3	2025-05-29 23:00:00	\N	22222222222222	\N
703	502	1	3	2025-05-30 19:00:00	\N	22222222222222	\N
752	502	1	3	2025-05-31 13:30:00	\N	22222222222222	\N
602	502	1	3	2025-05-29 18:15:00	ACCEPTED	6565656565566	752
652	502	1	3	2025-05-31 19:00:00	REJECTED	3333333333333	\N
53	502	1	3	2025-05-20 09:00:00	COMPLETED	\N	752
54	502	1	3	2025-05-24 09:00:00	COMPLETED	\N	752
103	502	1	3	2025-05-27 06:15:00	ACCEPTED	\N	752
852	502	1	3	2025-06-01 10:30:00	COMPLETED	\N	852
202	502	1	3	2025-05-23 06:15:00	COMPLETED	\N	852
102	502	1	3	2025-05-30 08:00:00	COMPLETED	\N	752
452	502	1	3	2025-05-30 16:15:00	COMPLETED	\N	902
553	502	1	3	2025-05-24 16:45:00	REJECTED	\N	\N
302	502	1	3	2025-05-24 15:30:00	COMPLETED	\N	752
952	502	3	3	2025-06-08 10:30:00	pending	21212121212121	\N
1002	502	3	3	2025-05-31 10:00:00	pending	21212121212121	\N
1052	953	4	6	2025-05-24 11:45:00	ACCEPTED	\N	952
1102	1002	3	3	2025-06-06 12:00:00	COMPLETED	\N	1003
1152	1052	3	3	2025-05-25 14:15:00	COMPLETED	\N	1053
252	502	1	3	2025-05-30 16:30:00	pending	\N	752
802	502	1	3	2025-05-30 12:30:00	REJECTED	\N	\N
1202	502	2	3	2025-05-29 18:30:00	pending	22222222222222	\N
152	502	1	3	2025-05-30 06:15:00	ACCEPTED	\N	752
\.


--
-- Data for Name: cars; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cars (vin, brand, model, year, mileage, client_id) FROM stdin;
1111111111111111	audi	100	1997	389503	602
22222222222222	alfa romeo	super	2020	10000	502
342957634577	mercedes	cls	2025	1500	502
3333333333333	eadvae	asfvbas	2020	20202	502
6565656565566	Toyota	Crown	2020	100000	502
21212121212121	nissan	juke	2021	120000	502
007007007007	Как у бодна	у джеймса	2025	1000	953
112232131234343	Toyota	Crown	2015	48000	1002
12938236127642	Toyota	Crown	2012	145000	1052
\.


--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client (user_id, car_brand, car_model, car_year) FROM stdin;
5	volkswagen	polo sedan	2017
602	\N	\N	\N
352	\N	\N	\N
652	\N	\N	\N
702	\N	\N	\N
752	\N	\N	\N
802	\N	\N	\N
902	\N	\N	\N
502	nissan	juke	2021
953	Как у бодна	у джеймса	2025
1002	Toyota	Crown	2015
1003	\N	\N	\N
1052	Toyota	Crown	2012
1053	\N	\N	\N
\.


--
-- Data for Name: client_reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client_reviews (id, client_id, sto_id, rating, comment, created_at) FROM stdin;
1	502	3	4	Debug	2025-05-17 00:39:03.927288
2	502	3	5	debug2	2025-05-17 00:43:34.576248
52	502	3	3	debug3	2025-05-17 00:46:11.828786
102	502	3	2	debug4\r\n	2025-05-19 21:05:53.822459
152	502	3	1	Debug5	2025-05-19 21:16:46.602978
202	502	3	5	debug6	2025-05-19 21:20:57.214834
252	502	3	5	debug7\r\n	2025-05-19 21:22:34.720276
302	502	3	5	debug8?	2025-05-19 21:35:28.313935
352	502	3	5	debug9	2025-05-19 21:44:33.557284
402	502	3	5	debug10!	2025-05-19 21:46:33.476548
452	502	3	5	Крутое СТО	2025-05-20 16:06:38.707812
652	502	3	1	w	2025-05-23 10:41:39.29688
702	502	6	5	Первое правило бойцовского клуба	2025-05-23 11:38:36.276991
752	1002	3	5	Запись!	2025-05-23 12:50:22.08327
802	1052	3	5	Запись!	2025-05-23 14:13:51.203547
\.


--
-- Data for Name: inventory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory (sto_id, part_id, quantity) FROM stdin;
3	1	30
3	52	2
3	102	12
3	152	4
6	202	4
3	252	2
3	302	2
\.


--
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.services (id, name, description, repair_hours, sto_id) FROM stdin;
1	замена масла	Обычная процедура замены масла, время приближенное	0.5	3
2	Осмотр состояния КПП	Осмотр коробки передач, если все хорошо, то замена масла, если будут обнаружены дефекты, то ремонт	8	3
3	шумоизоляция	полная шумоизоляция салона и двигателя	10	3
4	Гос переворот в греции	***	32	6
5	Тест	ЗАПИСЬ	1	3
6	Замена магнитолы	--	2	3
\.


--
-- Data for Name: spare_part; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spare_part (id, name, category) FROM stdin;
1	бампер vw polo	бампер
52	МКПП на audi 100	коробка передач
102	диски 25 радиуса	диски
152	амортизаторы vw passat	подвеска
202	Динамики Урал 203В	динамики
252	Выхлопная труба outlander	Выхлопная система
302	Выхлопная труба Mark 2	выхлопная система
\.


--
-- Data for Name: sto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sto (id, name, address, rating, working_hours, verification_code) FROM stdin;
3	СТО АвтоМир	ул. Ленина 1	4	9:00 - 21:00	Ta4pRtDChS3LjfchE5EP+4aqOruD90KZa/aQV2wr98M=
4	Механиков	ул. красного восстания, 1	0	13:00 - 19:00	3yyaMim9ZE+/+4CQr30T6/9bvFlqrIJZG+cjhs5IEHk=
5	ШинкАнгара	ул. Улан-Баторская, 1	0	11:00 - 19:00	ovvAwCeBEOfAU0fFynyiI9HZx2YgV1CienPsjlhLhwA=
6	Сто тайного правительства	ул. Лермонтова, 1	5	0:00 - 23:59	5G2IibHekwsf8K0Tm+fYkto7KcQ1TsmwmuMeEaxi+xQ=
11	Итоговая СТО с шифрованием	ул. Баумана, 3	0	10:00-17:00	UJm41f0QM9jZJVEMYx7l6o11TiGGi5fKHvKWE8Hs+9U=
14	СТО-1	Кировская 1	0	10:00-20:00	n+357aLSfvRP0WohaaT8GCVxX/wM9qh/7lkJRbubbBU=
15	СТО-2	Кировская 1	0	10:00-20:00	iQFV+ZQr/ro1Rj+vE+YolAAg5F6aaGV2VAcOcs9HAI4=
18	STO3	ADDRESS	0	00:00-21:00	DbuyNAzPMB96Xncdq0bFZXN6ECjqYl7sCAn+QfsRhI8=
1	НовоеСТО	ул. рабочая	0	10:00-19:00	Pzq8Fn+w0mqLU3DlgidHzLPwgQvWpOHbdj0vnJx6/0w=
2	LASTSTO	HELL	0	10:00-19:00	nA0TmTR6A8Z9GS3tB2VDd9LrH2ow3QNNncNy0/a+alo=
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, password_hash, phone, role, client_user_id, worker_user_id) FROM stdin;
3	Иван Механиков	mechanic@example.com	hashed_password	\N	worker	\N	\N
5	Иван Алексеевич	IVanAlex@example.com	ghdhbv923g23byf7	89500827119	client	\N	\N
202	Игорь Непокрытых	igor.nepocrytyh@mail.ru	$2a$10$uqYp1FH3mR2lRhmC6xj/M.EIa9ONrzhKIeWBdww6upgLK0yyhgLRe	89500827119	CLIENT	\N	\N
252	Xarek In	xarek@mail.ru	$2a$10$hh0KmlHUrd7HvZwXj6fBDumMiU4ZD12BIpOEdmnm.MS9yp1AfTQJC	324982374102	WORKER	\N	\N
302	Злобин Виталий	zlob@gmail.com	$2a$10$QvrVdYGREK1qXcW.O/.mr.EP4viw2yDCPKVt7.cbu/j1GHgWTlqzK	89303040472	CLIENT	\N	\N
402	Ramzan	r@mail	$2a$10$fa5x/6Bn.Pm9EF81KsM74ub7rdJvbOCGXCCTduH5AVKu9nEp/oW/q	75839294683	CLIENT	\N	\N
1952	Last Work	LastWorrker@mail.ru	$2a$10$nlajOkVh1JQmttJYtxUYeuLjxP3T4UTsIwgBQKyja66v7eVGIKrEG	82399385393	WORKER	\N	\N
352	Работник Джон	n@mail	$2a$10$p124ctysYxo4RvcX.CEFpOxGA1Wo2oaAmHfH4ThcY/1gp14NxFRIK	81283838222	WORKER	\N	\N
452	dvvjcf	w@mail	$2a$10$wcLXAcPI3BchZCfwRNLRA.fmWzDEtrnmHtjtTJjPIbMqpHSJsylQi	564738334	WORKER	\N	\N
552	Ya Client	g@mail	$2a$10$Yma2kRotqHG/vWDGjNbFmOtEtsvnKkSbpbtX/DTkS3dFaKqLOQwS.	89500827119	CLIENT	\N	\N
602	Обычный пользователь	norm@mail.ru	$2a$10$NM6cfepjc6O8Q0M4P9kpbecEG.JS1/WpwDuyNYyHLkrk0JPV6g7Ce	8888888888	CLIENT	\N	\N
652	Worker Sto	worker@mail	$2a$10$K7cAuXZ335CJoXJsF1frgOpKCMZnCAZZFiL4egbmSTlzgsvPy0N0q	8999999999	WORKER	\N	\N
702	РАБ СИСТЕМЫ	Rab@mail	$2a$10$skLqNTs/pggskz81w5bDUOicNKdrqZAqAwYGqt031htUXz5ovMZ4q	89666666666	WORKER	\N	\N
2002	LASTSTO ad	wowo@mail.ru	$2a$10$td9EPwa8icSHAj2Zixieb.zkBxO50AV.4oqyJJJvKtcbA8mdXt7Ua	89500827118	WORKER	\N	\N
802	Новый работник	newWorker@mail	$2a$10$jsuToUa4ITnYlQFJ34tnyuIIWr2u8Epy7GOUv9/ossDdMd73Nrxeu	898989898989	WORKER	\N	\N
852	Раб СистЕмы	WorldWork@mail.ru	$2a$10$D8w/XmD7hMflDKE3X1J9MOhQu9O9xf8teBDToQvj/Ol249vwlEjIq	88005353535	WORKER	\N	\N
752	Работник автомираа	wor@mail	$2a$10$xQGWTW0dyszuKfgF6q1qquQDWmLo0hykuUS3jn87sWvCwtKVkyN7u	88484838381	WORKER	\N	\N
902	f f	f@mail	$2a$10$1HOAuUk45om2wogvuH9LEO0nRXSjfxZEUt.ctuiu1dnfC9ziZRFT.	9876567865	WORKER	\N	\N
2052	A adAA	LastWork@mail.ru	$2a$10$CB3iSlm4J/pn46gfA6HoBu3unKQvTbAQq3asaFOt63YiUPRyPLXze	8989364585	WORKER	\N	\N
502	Богатый Клиент	client@mail	$2a$10$8.wdwf8ZT3G2o/gmZBe4ieyngqMsIF4CH86KI8L53XxOMRS5coF8O	65748393974	CLIENT	\N	\N
952	Unknown Unknown	workerHidden@mail.ru	$2a$10$/N0HGroipVezrNm4FC61u.xWa5XoFieDsdWrjQv5rMflh8B2JSVX.	1111111111111	WORKER	\N	\N
953	РабОтник завода	mail@mail	$2a$10$n2NAHhmRoFbsr5ZE2OlobeT248OBCWsKMCb0U/FCgSoESoZf8.l7e	25348234198	CLIENT	\N	\N
1002	Иван Ивановв	ClientSto@mail.ru	$2a$10$GX6Zc9V0KTsHyETV.hXKQ.N6hX0og7HOQcHBB6mAXi/fwp3tiNGxO	8950000000	CLIENT	\N	\N
1003	Работник Автомира	Rabotnik@mail.ru	$2a$10$vPC8.3PP07Bpbb41Sy3ikOcIlgjvxchJltHJL9I67BQnHdyyYCHPO	89283763732	WORKER	\N	\N
1052	Иван Ивановв	ClienTT@mail.ru	$2a$10$irc.Jk8ATGTlkpw.fQwc.u4DfTowAliNzhsHDgUxbzhXW/sgsm3I2	8989898989898	CLIENT	\N	\N
1053	Иван Зорин	Work@mail.ru	$2a$10$G.eHGLgHupScCgGwDkMyF.tiGik4pLenUVjlZBGJ3tR2LIq2tLE5u	89849364757	WORKER	\N	\N
1102	Готовый работник	MainWorker@mail.ru	$2a$10$KJZKiXSvXyWxjQOBwnUU1uu021bx.BV25Jh/aZJs63n0U9ERdILB.	89386464753	WORKER	\N	\N
1152	Точно итоговыйРаботник	LastWorker@mail.ru	$2a$10$nea7/W42bVIeBcSR/PCnJeotEUWhfuSipWpYv54FzVgTxB2eD52PS	89453625284	WORKER	\N	\N
1202	A	LLL@mail.ru	$2a$10$T5vVfj.NabKIRdhm3EqSbu55fJHkkvT99i0Jlk.ZftlmM1p1X698O	75849375643	WORKER	\N	\N
1203	A AA	LLLL@mail.ru	$2a$10$AwJZ5DfIf6LK1rOmmBNB8Of/2emm/7GwZSyCr2Xozps.ewTddrB7G	89678588675	WORKER	\N	\N
1252	AA AA	LLRR@mail.ru	$2a$10$tHpJ8wR5hlDGaSodnvxIiu0.dN//xW1krqXXODyrFllrChxWnO12i	89768999504	WORKER	\N	\N
1302	AAA AAA	POlza4@mail.ru	$2a$10$a6cHEts0F2UnEXlFyoHxpOUhJSn49FqERVsM1A1YU6vAkKGeGBPei	89679989576	WORKER	\N	\N
1352	AAAAA A	UYstal@mail.ru	$2a$10$FUmbMWqI.qezLNRKj3R4feAJBpvBgG38g7qxEYmrq7Ag4JU1qfvkW	89657567483	WORKER	\N	\N
1402	FFF FFF	WWW@MAIL.RU	$2a$10$bnGfUJvge9tdcltGiKNnfumaSVVDrqXtwQ1uymjQJ4hSQVeO2NIl.	89576748392	WORKER	\N	\N
1452	ddd	WR@mail.ru	$2a$10$DFXgK5JM5HgStbdZMF7tVO/g5J1mMNPtl36RccXEWKKV2ik4bzTcm	8934983478	WORKER	\N	\N
1453	fg fg	rrrr@mail.ru	$2a$10$SzxqFp7HuICPvHGyG8/zKOTwf.mJWY1JwIVxorZlNoo2YpsDkNGgq	98885469744	WORKER	\N	\N
1502	d d	Re@mail.ru	$2a$10$3KbBQEhRwvEjnvX4J3vaOOHliyb0MDsN1yVJ6pkHAr0QSTk4t8GoC	123124124	WORKER	\N	\N
1552	d r	tr@mail.ru	$2a$10$ohXYFV8HzIlVt5.TzzV5E.jsx59tcxVZPsUXGqFZHA6c11JVu2bpG	12312123123	WORKER	\N	\N
1602	ddd	dd@mail.ru	$2a$10$N9N0LBVUtm6bnC4d.JFcq.pBt94n/QQby1JFIrpFdeOIUNHH6FxIq	88888888882	WORKER	\N	\N
6	admin	admin@admin	admin	\N	admin	\N	\N
1652	dha asfh	ahb@mail	$2a$10$x8jilQ579nZv5Tzu0BO/G.Y3qZo0yEo1ewzcdVCrtNifHm5c6OUzC	49863495738	WORKER	\N	\N
1702	GGG GGG	ayyyy@mail	$2a$10$O8OTV26lb8gC34y1iSEkZ.ekCIylBiV2Us5GVXxApMfDEa7ascjl6	988857464	WORKER	\N	\N
1752	dda asdasd	Wkn@mail.ru	$2a$10$fFj7vTprT2QBS9bKtvGYZuu8wOeF5xg0zKXl4cC/zKkaJuoYuWo1O	934883465	WORKER	\N	\N
1802	adnaawd asd	awda@mail	$2a$10$PDAXcu3HR9LNxPTLsrfzJOk.LoJjtRlJkMXQVRS/Zvfio9gKojK/K	78654456887	WORKER	\N	\N
1852	ajwd asd	asdmm@mail.ru	$2a$10$b4Jqr9/H5XW3CxKxNCAT3uz6rJ.XSsU2kjwqKHhCsin1.7MUbcRyS	88977556885	WORKER	\N	\N
1902	awld sdcn	wda@mail	$2a$10$dwNzt07DyrrQIFDfYe1HDe0Tjm2L0C0qsI6x3ho09gCe62UOvCNXG	9896869312	WORKER	\N	\N
2102	h H	hh@mail.ru	$2a$10$e9XanaJLmbNbHQ23.cvsu.5Hwzou0cZxFXMFyVuFhyYHpAj2pqf3C	898423943	WORKER	\N	\N
\.


--
-- Data for Name: worker; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.worker (user_id, specialization, experience_years, sto_id) FROM stdin;
1902	Автозвук	3	1
2102	шиномонтаж	5	2
3	Механик	\N	3
702	шиномонтаж	50	3
802	Автозвук	10	3
852	Автозвук	15	3
902	диагностика	7	3
752	Замена раздатки	8	3
952	Гос тайна	10	3
1003	Автозвук	14	3
1053	Автозвук	15	3
\.


--
-- Data for Name: worker_reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.worker_reviews (id, worker_id, hours_for_complete, service_name, comment, auto_model, created_at, appointment_id) FROM stdin;
1	752	1	\N	deb	Crown	2025-05-22 00:55:37.083849	53
2	752	1	замена масла	debug3	Crown	2025-05-22 01:17:38.207335	54
52	852	2	замена масла	Я занимаюсь автозвуком ,поэтому так долго	Crown	2025-05-22 01:48:41.370415	852
102	852	2	замена масла	OK	Crown	2025-05-22 01:57:13.903897	202
152	752	1	замена масла	БУМБУМ	Crown	2025-05-22 15:36:10.123745	102
202	902	1	замена масла	gg	Crown	2025-05-22 20:48:47.680118	452
252	752	1	замена масла		Crown	2025-05-22 23:45:06.150366	302
302	1003	8	шумоизоляция	--	Crown	2025-05-23 12:52:54.329096	1102
352	1053	9	шумоизоляция	__-	Crown	2025-05-23 14:15:33.142977	1152
\.


--
-- Name: appointments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointments_id_seq', 2, true);


--
-- Name: appointments_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointments_seq', 1251, true);


--
-- Name: client_reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.client_reviews_id_seq', 1, false);


--
-- Name: client_reviews_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.client_reviews_seq', 851, true);


--
-- Name: client_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.client_user_id_seq', 1, false);


--
-- Name: services_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.services_id_seq', 6, true);


--
-- Name: services_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.services_seq', 1, true);


--
-- Name: spare_part_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.spare_part_id_seq', 2, true);


--
-- Name: spare_part_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.spare_part_seq', 351, true);


--
-- Name: sto_id_gen; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sto_id_gen', 1, false);


--
-- Name: sto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sto_id_seq', 18, true);


--
-- Name: sto_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sto_seq', 51, true);


--
-- Name: users_id_gen; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_gen', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 6, true);


--
-- Name: users_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_seq', 2151, true);


--
-- Name: worker_reviews_id_gen; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.worker_reviews_id_gen', 1, false);


--
-- Name: worker_reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.worker_reviews_id_seq', 1, false);


--
-- Name: worker_reviews_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.worker_reviews_seq', 401, true);


--
-- Name: worker_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.worker_user_id_seq', 1, false);


--
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (id);


--
-- Name: cars cars_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cars
    ADD CONSTRAINT cars_pkey PRIMARY KEY (vin);


--
-- Name: client client_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (user_id);


--
-- Name: client_reviews client_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_reviews
    ADD CONSTRAINT client_reviews_pkey PRIMARY KEY (id);


--
-- Name: inventory inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (sto_id, part_id);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: spare_part spare_part_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.spare_part
    ADD CONSTRAINT spare_part_pkey PRIMARY KEY (id);


--
-- Name: sto sto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sto
    ADD CONSTRAINT sto_pkey PRIMARY KEY (id);


--
-- Name: users ukgauetj0pm78b765a9a4wm3814; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT ukgauetj0pm78b765a9a4wm3814 UNIQUE (client_user_id);


--
-- Name: users ukqrvvbj0tvgdwae1o73g0m22vx; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT ukqrvvbj0tvgdwae1o73g0m22vx UNIQUE (worker_user_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: worker worker_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker
    ADD CONSTRAINT worker_pkey PRIMARY KEY (user_id);


--
-- Name: worker_reviews worker_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker_reviews
    ADD CONSTRAINT worker_reviews_pkey PRIMARY KEY (id);


--
-- Name: appointments appointments_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.client(user_id);


--
-- Name: appointments appointments_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id);


--
-- Name: appointments appointments_sto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_sto_id_fkey FOREIGN KEY (sto_id) REFERENCES public.sto(id);


--
-- Name: cars cars_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cars
    ADD CONSTRAINT cars_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.client(user_id) ON DELETE CASCADE;


--
-- Name: client_reviews client_reviews_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_reviews
    ADD CONSTRAINT client_reviews_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.client(user_id);


--
-- Name: client_reviews client_reviews_sto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_reviews
    ADD CONSTRAINT client_reviews_sto_id_fkey FOREIGN KEY (sto_id) REFERENCES public.sto(id);


--
-- Name: client client_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: appointments fk4am0r4t47mu1ltc2nyyodmyej; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fk4am0r4t47mu1ltc2nyyodmyej FOREIGN KEY (worker_id) REFERENCES public.worker(user_id);


--
-- Name: appointments fk4btw9v9vpykplj5c0ekndd9e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fk4btw9v9vpykplj5c0ekndd9e FOREIGN KEY (car) REFERENCES public.cars(vin);


--
-- Name: worker_reviews fkdooameyh8vqb5wi7i450s5hml; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker_reviews
    ADD CONSTRAINT fkdooameyh8vqb5wi7i450s5hml FOREIGN KEY (appointment_id) REFERENCES public.appointments(id);


--
-- Name: users fkqxdhns6oo8nru6s6ycme4j5sk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fkqxdhns6oo8nru6s6ycme4j5sk FOREIGN KEY (worker_user_id) REFERENCES public.worker(user_id);


--
-- Name: users fksm0fmd174dqlj9q3wxy434h8p; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fksm0fmd174dqlj9q3wxy434h8p FOREIGN KEY (client_user_id) REFERENCES public.client(user_id);


--
-- Name: inventory inventory_part_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_part_id_fkey FOREIGN KEY (part_id) REFERENCES public.spare_part(id) ON DELETE CASCADE;


--
-- Name: inventory inventory_sto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_sto_id_fkey FOREIGN KEY (sto_id) REFERENCES public.sto(id) ON DELETE CASCADE;


--
-- Name: services services_sto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_sto_id_fkey FOREIGN KEY (sto_id) REFERENCES public.sto(id) ON DELETE CASCADE;


--
-- Name: worker_reviews worker_reviews_worker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker_reviews
    ADD CONSTRAINT worker_reviews_worker_id_fkey FOREIGN KEY (worker_id) REFERENCES public.worker(user_id);


--
-- Name: worker worker_sto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker
    ADD CONSTRAINT worker_sto_id_fkey FOREIGN KEY (sto_id) REFERENCES public.sto(id) ON DELETE SET NULL;


--
-- Name: worker worker_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker
    ADD CONSTRAINT worker_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

