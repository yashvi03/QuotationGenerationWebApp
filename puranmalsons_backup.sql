--
-- PostgreSQL database dump
--

-- Dumped from database version 17rc1
-- Dumped by pg_dump version 17rc1

-- Started on 2025-04-27 12:03:24

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
-- TOC entry 233 (class 1255 OID 33522)
-- Name: update_modified_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_modified_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.date_modified = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_modified_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 225 (class 1259 OID 24914)
-- Name: additem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.additem (
    id integer NOT NULL,
    type character varying(100) NOT NULL,
    size character varying(50) NOT NULL,
    article character varying(150) NOT NULL,
    category character varying(100) NOT NULL,
    mc_name character varying(100) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    qty integer,
    form_id uuid,
    quotation_id uuid NOT NULL,
    mrp numeric(10,2),
    discount_rate numeric(5,2),
    net_rate numeric(10,2)
);


ALTER TABLE public.additem OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 24913)
-- Name: additem_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.additem_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.additem_id_seq OWNER TO postgres;

--
-- TOC entry 4950 (class 0 OID 0)
-- Dependencies: 224
-- Name: additem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.additem_id_seq OWNED BY public.additem.id;


--
-- TOC entry 228 (class 1259 OID 33228)
-- Name: cards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cards (
    card_id uuid DEFAULT gen_random_uuid() NOT NULL,
    type character varying(50) NOT NULL,
    size character varying(50) NOT NULL,
    items json
);


ALTER TABLE public.cards OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 33346)
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer (
    customer_id uuid DEFAULT gen_random_uuid() NOT NULL,
    title character varying(10),
    name character varying(255) NOT NULL,
    billing_address text,
    shipping_address text,
    phone_number character varying(15),
    whatsapp_number character varying(15)
);


ALTER TABLE public.customer OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 33512)
-- Name: final_quotation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.final_quotation (
    quotation_id character varying(50) NOT NULL,
    customer_id uuid DEFAULT gen_random_uuid(),
    card_ids uuid[],
    margin_ids uuid[],
    date_created timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    date_modified timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.final_quotation OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 24790)
-- Name: item_pricing; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item_pricing (
    id integer NOT NULL,
    itemname character varying(255) NOT NULL,
    discount numeric(10,2),
    netrate numeric(10,2),
    margincategory character varying(50),
    discountcategory character varying(50)
);


ALTER TABLE public.item_pricing OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 24789)
-- Name: item_pricing_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.item_pricing_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.item_pricing_id_seq OWNER TO postgres;

--
-- TOC entry 4951 (class 0 OID 0)
-- Dependencies: 219
-- Name: item_pricing_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.item_pricing_id_seq OWNED BY public.item_pricing.id;


--
-- TOC entry 218 (class 1259 OID 24772)
-- Name: items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.items (
    item_id integer NOT NULL,
    type character varying(255),
    size character varying(50),
    mrp numeric(10,2),
    article character varying(255),
    cat1 character varying(50),
    cat2 character varying(50),
    cat3 character varying(50),
    margin_category character varying(50),
    discount_category character varying(50),
    mc_name character varying(255),
    image_url character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    type_image_url text,
    temp character varying(255),
    gst numeric(5,2),
    make character varying(255)
);


ALTER TABLE public.items OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 24771)
-- Name: items_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.items_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.items_item_id_seq OWNER TO postgres;

--
-- TOC entry 4952 (class 0 OID 0)
-- Dependencies: 217
-- Name: items_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.items_item_id_seq OWNED BY public.items.item_id;


--
-- TOC entry 230 (class 1259 OID 33337)
-- Name: margin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.margin (
    margin_id uuid DEFAULT gen_random_uuid() NOT NULL,
    mc_name character varying(50),
    margin double precision NOT NULL
);


ALTER TABLE public.margin OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 24893)
-- Name: pickmargin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pickmargin (
    mc_name character varying(255) NOT NULL,
    margin numeric(10,2) NOT NULL,
    id integer NOT NULL,
    quotation_id uuid NOT NULL
);


ALTER TABLE public.pickmargin OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 24940)
-- Name: pickmargin_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pickmargin_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pickmargin_id_seq OWNER TO postgres;

--
-- TOC entry 4953 (class 0 OID 0)
-- Dependencies: 226
-- Name: pickmargin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pickmargin_id_seq OWNED BY public.pickmargin.id;


--
-- TOC entry 222 (class 1259 OID 24873)
-- Name: quotation_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quotation_items (
    quotation_items_id integer NOT NULL,
    article character varying(255) NOT NULL,
    image_url character varying(255),
    quantity integer NOT NULL,
    category character varying(100),
    type character varying(100),
    size character varying(50),
    margin numeric(5,2),
    discount_rate numeric(10,2),
    mrp numeric(10,2),
    net_rate numeric(10,2),
    final_rate numeric(10,2),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    item_id integer,
    quotation_id uuid NOT NULL
);


ALTER TABLE public.quotation_items OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 24872)
-- Name: quotation_items_quotation_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.quotation_items_quotation_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.quotation_items_quotation_items_id_seq OWNER TO postgres;

--
-- TOC entry 4954 (class 0 OID 0)
-- Dependencies: 221
-- Name: quotation_items_quotation_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.quotation_items_quotation_items_id_seq OWNED BY public.quotation_items.quotation_items_id;


--
-- TOC entry 227 (class 1259 OID 24948)
-- Name: quotations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quotations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.quotations OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 33256)
-- Name: wip_quotation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wip_quotation (
    quotation_id character varying(50) NOT NULL,
    card_ids text[],
    margin_ids text[],
    date_created timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    date_modified timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    customer_id uuid
);


ALTER TABLE public.wip_quotation OWNER TO postgres;

--
-- TOC entry 4748 (class 2604 OID 24917)
-- Name: additem id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.additem ALTER COLUMN id SET DEFAULT nextval('public.additem_id_seq'::regclass);


--
-- TOC entry 4743 (class 2604 OID 24793)
-- Name: item_pricing id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_pricing ALTER COLUMN id SET DEFAULT nextval('public.item_pricing_id_seq'::regclass);


--
-- TOC entry 4740 (class 2604 OID 24775)
-- Name: items item_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items ALTER COLUMN item_id SET DEFAULT nextval('public.items_item_id_seq'::regclass);


--
-- TOC entry 4747 (class 2604 OID 24941)
-- Name: pickmargin id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pickmargin ALTER COLUMN id SET DEFAULT nextval('public.pickmargin_id_seq'::regclass);


--
-- TOC entry 4744 (class 2604 OID 24876)
-- Name: quotation_items quotation_items_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotation_items ALTER COLUMN quotation_items_id SET DEFAULT nextval('public.quotation_items_quotation_items_id_seq'::regclass);


--
-- TOC entry 4937 (class 0 OID 24914)
-- Dependencies: 225
-- Data for Name: additem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.additem (id, type, size, article, category, mc_name, created_at, qty, form_id, quotation_id, mrp, discount_rate, net_rate) FROM stdin;
60	CPVC	2-1/2"	Tee	SCH-80	CPVC Fittings	2024-12-30 12:45:21.092093	1	495acc0f-6809-4d57-a543-308130314545	f28ce516-3d63-46d8-8c95-36d7cbfee0ce	\N	\N	\N
61	UPVC	1-1/4"x1/2"	Reducing Bush	SCH-80	UPVC Fitting	2024-12-30 12:46:10.132086	2	306125c6-0339-4119-854b-c9ebe992a919	f28ce516-3d63-46d8-8c95-36d7cbfee0ce	\N	\N	\N
62	CPVC	2-1/2"	Endcap	SCH-80	CPVC Fittings	2024-12-30 12:49:32.762944	3	14641d98-b706-4aeb-a2b6-f3f172e5c3cb	f28ce516-3d63-46d8-8c95-36d7cbfee0ce	\N	\N	\N
63	CPVC	2-1/2"	Elbow 90*	SCH-40	CPVC Fittings	2024-12-31 00:50:46.648421	3	aa3f2b60-e2f7-4319-8ab9-5f89da257d1e	f28ce516-3d63-46d8-8c95-36d7cbfee0ce	\N	\N	\N
64	UPVC	2"x1"	Reducing Coupler	SCH-80	UPVC Fitting	2024-12-31 00:51:06.04433	4	767dcdd1-ce02-4e18-a337-87de503164b6	f28ce516-3d63-46d8-8c95-36d7cbfee0ce	\N	\N	\N
65	CPVC	2-1/2"	Endcap	SCH-80	CPVC Fittings	2024-12-31 01:18:17.368436	4	73165898-5d1c-4ba2-a118-7ea941e63765	f28ce516-3d63-46d8-8c95-36d7cbfee0ce	\N	\N	\N
66	CPVC	2-1/2"	Endcap	SCH-80	CPVC Fittings	2024-12-31 10:32:24.585898	4	94445328-a6e3-4ae7-a761-64fd8ba8e920	f28ce516-3d63-46d8-8c95-36d7cbfee0ce	\N	\N	\N
67	CPVC	4"	Endcap	SCH-80	CPVC Fittings	2024-12-31 16:22:11.766585	4	689e19bb-4a40-4206-b30f-2ccdaebfe2df	f28ce516-3d63-46d8-8c95-36d7cbfee0ce	\N	\N	\N
37	CPVC	1-1/4	pipe	SDR 13.5	CPVC Pipe 1-1/4"; 1-1/2"; 2"	2024-12-28 22:54:24.842294	1	e500e439-24d0-4bff-90b5-489def537b2b	a9b0f86b-4585-4be7-8228-75e29c3d934a	\N	\N	\N
38	CPVC	3"	Tee	SCH-80	CPVC Fittings	2024-12-28 23:04:15.049536	1	d9dd4f13-b0f0-4b31-895f-43b21b18c600	a9b0f86b-4585-4be7-8228-75e29c3d934a	\N	\N	\N
39	CPVC	1"	Tee	SDR 11	CPVC Fittings	2024-12-28 23:24:34.094722	7	c7697afa-a1d8-4279-b1af-4c7155f0cc6f	a9b0f86b-4585-4be7-8228-75e29c3d934a	\N	\N	\N
40	CPVC	1"	Tee	SDR 11	CPVC Fittings	2024-12-28 23:25:52.3978	1	19fd462c-d00e-4582-8ae1-983ec60fea8c	a9b0f86b-4585-4be7-8228-75e29c3d934a	\N	\N	\N
41	CPVC	1"	Pipe	SDR 11	CPVC Pipe 3/4"; 1"	2024-12-28 23:27:20.337408	3	414143ea-78b0-42e7-92af-5ccb16e19259	a9b0f86b-4585-4be7-8228-75e29c3d934a	\N	\N	\N
42	CPVC	2-1/2"	Elbow 90*	SCH-40	CPVC Fittings	2024-12-28 23:29:07.801829	1	0190eb15-de40-482a-b602-6835006fc788	a9b0f86b-4585-4be7-8228-75e29c3d934a	\N	\N	\N
43	CPVC	4"	Endcap	SCH-80	CPVC Fittings	2024-12-29 01:26:16.814964	3	ac5cab6a-4341-40f6-a699-956a6e4014c0	a9b0f86b-4585-4be7-8228-75e29c3d934a	\N	\N	\N
44	CPVC	2-1/2"	Elbow 90*	SCH-40	CPVC Fittings	2024-12-29 01:31:42.729601	1	8e2ef776-bdc8-4515-907b-eb00ea2823db	a9b0f86b-4585-4be7-8228-75e29c3d934a	\N	\N	\N
45	CPVC	1"	Coupler	SDR 11	CPVC Fittings	2024-12-29 11:15:17.877935	1	af6b5f4a-57c1-46c0-b77d-724db2e68f00	a9b0f86b-4585-4be7-8228-75e29c3d934a	\N	\N	\N
46	CPVC	1"	Tee	SDR 11	CPVC Fittings	2024-12-29 12:58:23.023681	1	f13ad97e-6d5d-48f8-b861-7f680b212f4c	a43167b9-0aff-4155-851d-d2532d75688d	\N	\N	\N
47	CPVC	1"	45* Elbow	SDR 11	CPVC Fittings	2024-12-29 12:59:05.067517	1	c0f298f9-fca8-4b34-be07-ae7ab571bf2c	a43167b9-0aff-4155-851d-d2532d75688d	\N	\N	\N
48	CPVC	1"	Pipe	SDR 11	CPVC Pipe 3/4"; 1"	2024-12-29 13:14:47.97375	2	205cd50d-cf6e-436a-93c8-11f329b51b50	a43167b9-0aff-4155-851d-d2532d75688d	\N	\N	\N
49	CPVC	4"	Elbow 90*	SCH-80	CPVC Fittings	2024-12-29 13:28:29.656411	6	8b347106-24e5-418e-8258-54610523d180	a43167b9-0aff-4155-851d-d2532d75688d	\N	\N	\N
50	CPVC	2-1/2"	Elbow 90*	SCH-40	CPVC Fittings	2024-12-29 15:53:23.279206	1	c9364a24-247b-4083-9420-0d5ffaf858ba	a43167b9-0aff-4155-851d-d2532d75688d	\N	\N	\N
51	CPVC	1"	Pipe	SDR 11	CPVC Pipe 3/4"; 1"	2024-12-29 17:15:57.174629	1	590ad226-1727-4b10-a4f1-51613bbfedb8	a43167b9-0aff-4155-851d-d2532d75688d	\N	\N	\N
52	CPVC	4"	Endcap	SCH-80	CPVC Fittings	2024-12-29 17:49:49.33619	97	f1d14ff4-fe11-4e7e-9e9a-ef9dde2ac350	a43167b9-0aff-4155-851d-d2532d75688d	\N	\N	\N
53	CPVC	4"	Elbow 90*	SCH-40	CPVC Fittings	2024-12-29 19:57:44.157309	2	028b433e-c8be-493d-9753-48da61ae0ee7	a43167b9-0aff-4155-851d-d2532d75688d	\N	\N	\N
54	CPVC	2-1/2"	Endcap	SCH-80	CPVC Fittings	2024-12-29 20:48:21.533533	5	c8010aaf-a94a-4e56-8479-c86f64656046	a43167b9-0aff-4155-851d-d2532d75688d	\N	\N	\N
55	CPVC	1"	Tee	SDR 11	CPVC Fittings	2024-12-29 20:57:00.690035	7	de26f4fc-c87c-4ea9-b21f-5079a99661be	a43167b9-0aff-4155-851d-d2532d75688d	\N	\N	\N
56	CPVC	1"	Coupler	SDR 11	CPVC Fittings	2024-12-29 20:57:34.189153	1	ba90eb99-b7e5-42d0-a4c2-d0c6b6fde95b	a43167b9-0aff-4155-851d-d2532d75688d	\N	\N	\N
57	CPVC	3"	Endcap	SCH-80	CPVC Fittings	2024-12-30 11:57:03.601081	1	c9f8cda4-af76-43a2-8592-7821f9fac049	f28ce516-3d63-46d8-8c95-36d7cbfee0ce	\N	\N	\N
58	CPVC	2-1/2"	Tee	SCH-80	CPVC Fittings	2024-12-30 12:12:38.588324	1	5eb595e8-ff73-4922-b745-bea43b489063	f28ce516-3d63-46d8-8c95-36d7cbfee0ce	\N	\N	\N
59	CPVC	2-1/2"	Endcap	SCH-80	CPVC Fittings	2024-12-30 12:45:20.973663	3	e79f9630-8079-4b15-9d17-54f02c8e2e4a	f28ce516-3d63-46d8-8c95-36d7cbfee0ce	\N	\N	\N
68	UPVC	1/2"	Elbow 90*	SCH-80	UPVC Fitting	2024-12-31 18:30:32.265382	2	5975ad8d-513b-4b57-8090-bfa1e050c996	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
69	CPVC	2-1/2"	Endcap	SCH-80	CPVC Fittings	2025-01-01 03:33:24.210646	2	2597f1f5-bea8-48cc-b0c4-9eb94dbcdf03	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
70	CPVC	4"	Elbow 90*	SCH-80	CPVC Fittings	2025-01-01 09:47:18.827501	3	8d0942bd-442f-46cd-929c-95323688d6e4	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
71	CPVC	2-1/2"	Tee	SCH-80	CPVC Fittings	2025-01-01 10:03:33.38191	1	f7e4ad3d-6380-4896-8589-f1ae337758b4	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
72	CPVC	2-1/2"	Elbow 90*	SCH-80	CPVC Fittings	2025-01-01 10:29:56.043337	2	13470cd1-3967-4833-841c-01bfe2f72c77	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
73	CPVC	1-1/4	pipe	SDR 13.5	CPVC Pipe 1-1/4"; 1-1/2"; 2"	2025-01-01 10:32:38.410394	2	1b365cc0-9657-476a-aa9d-4e8b27cce867	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
74	CPVC	2-1/2"	Tee	SCH-80	CPVC Fittings	2025-01-01 12:02:28.850408	2	4bb59699-ab64-4b05-9157-819b257239ff	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
75	CPVC	1"	Coupler	SDR 11	CPVC Fittings	2025-01-01 12:06:34.406874	2	46eff71d-2b1a-437f-8416-a35fb5bf0770	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
76	CPVC	2-1/2"	Tee	SCH-80	CPVC Fittings	2025-01-01 12:39:58.850838	2	51acb956-85c0-49a9-b471-73e9819deb28	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
77	CPVC	2-1/2"	Elbow 90*	SCH-80	CPVC Fittings	2025-01-01 12:39:58.90312	3	6eebe82d-fcde-4d4b-81b0-fa20fa7fd9f8	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
78	CPVC	1"	Tee	SDR 11	CPVC Fittings	2025-01-01 14:31:22.371587	3	682c42e7-693e-4e68-82ff-334ead50e605	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
79	CPVC	1"	45* Elbow	SDR 11	CPVC Fittings	2025-01-01 14:31:22.413925	3	4c60910e-e9cd-4f46-9c9c-c4655bee711a	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
80	CPVC	2-1/2"	Elbow 90*	SCH-80	CPVC Fittings	2025-01-01 18:13:54.010668	1	1491979e-d0dc-4cf6-92a9-e4f34211dee4	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
81	UPVC	3/4"	Coupler	SCH-80	UPVC Fitting	2025-01-01 18:31:25.035181	1	1b468114-21f5-42b6-acf2-eb0aa79a8a00	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
82	CPVC	4"	Endcap	SCH-80	CPVC Fittings	2025-01-01 18:50:41.403766	1	d4c3f25d-423a-495a-8fe3-ec4eafc6d5de	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
83	CPVC	4"	Elbow 90*	SCH-40	CPVC Fittings	2025-01-01 18:50:41.714032	2	d4c3f25d-423a-495a-8fe3-ec4eafc6d5de	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
84	CPVC	2-1/2"	Elbow 90*	SCH-40	CPVC Fittings	2025-01-01 19:11:58.71076	3	9903d614-beb7-46e7-9954-c403ea937461	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
85	CPVC	2-1/2"	Tee	SCH-80	CPVC Fittings	2025-01-01 19:11:58.963549	1	9903d614-beb7-46e7-9954-c403ea937461	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
86	CPVC	2-1/2"	Tee	SCH-80	CPVC Fittings	2025-01-01 21:28:41.870919	1	3f823244-e84e-4b93-bf06-09816d984bec	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
87	CPVC	2-1/2"	Endcap	SCH-80	CPVC Fittings	2025-01-01 21:35:02.852214	2	eb405510-7d96-4000-a343-70a7724ce5b1	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
88	CPVC	2-1/2"	Endcap	SCH-80	CPVC Fittings	2025-01-01 21:37:32.882375	1	4cd59ed4-ea51-4977-a433-4a21eae3e262	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
89	CPVC	2-1/2"	Elbow 90*	SCH-80	CPVC Fittings	2025-01-01 21:44:47.439328	2	af13f0e5-f39d-4923-8c02-c9e51e23d7cf	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
90	CPVC	1"	Pipe	SDR 11	CPVC Pipe 3/4"; 1"	2025-01-01 21:45:24.605074	1	d3dbe49a-e87f-4495-bc2e-3d394653224c	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
91	CPVC	1"	Coupler	SDR 11	CPVC Fittings	2025-01-01 21:45:24.652399	1	d3dbe49a-e87f-4495-bc2e-3d394653224c	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
92	CPVC	2-1/2"	Endcap	SCH-80	CPVC Fittings	2025-01-01 21:50:04.85711	1	7facf832-00f0-4470-8b29-6160b090b37f	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
93	CPVC	1-1/4	pipe	SDR 13.5	CPVC Pipe 1-1/4"; 1-1/2"; 2"	2025-01-01 22:04:16.724288	2	2c17bec5-9c52-4a67-a663-38dfdb74c00a	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
94	CPVC	2"x1/2"	Reducing Bush	SDR 11	CPVC Fittings	2025-01-01 22:06:53.767041	2	34002b3f-3507-4b35-8bab-56ec9902cf71	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
95	CPVC	1-1/4	pipe	SDR 13.5	CPVC Pipe 1-1/4"; 1-1/2"; 2"	2025-01-01 23:07:21.147125	3	3539a1dc-ef3c-4628-b748-5656569d329f	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
96	CPVC	1-1/2"x1-1/4"	Reducing Bush	SDR 11	CPVC Fittings	2025-01-01 23:28:36.049293	1	b463d453-e20c-4de0-b44d-5aa48ef5c3c6	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
97	CPVC	2-1/2"	Endcap	SCH-80	CPVC Fittings	2025-01-01 23:28:56.704754	1	19cec8da-2e9a-42ba-af31-cef7ae99596a	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
99	CPVC	1"	Coupler	SDR 11	CPVC Fittings	2025-01-02 00:09:16.886695	1	2f665bf1-3afe-4330-9866-7f2cb6682307	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
100	CPVC	2-1/2"	Endcap	SCH-80	CPVC Fittings	2025-01-02 00:11:53.939519	1	c9d9df69-8121-45e6-8c23-cc1c9e289ff2	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
101	CPVC	1"	Coupler	SDR 11	CPVC Fittings	2025-01-02 01:27:49.678346	4	0c675fc3-2045-459b-a0fd-7c740b693587	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
102	CPVC	1"	Coupler	SDR 11	CPVC Fittings	2025-01-02 01:31:23.928482	7	b1e4e387-41a0-4401-9da5-900c3ea1f184	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
107	CPVC	1"	Coupler	SDR 11	CPVC Fittings	2025-01-02 02:48:52.673856	1	74e0445a-54fd-4b39-b64c-eb4c078c89f9	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
109	CPVC	1"	Coupler	SDR 11	CPVC Fittings	2025-01-02 02:52:57.642613	1	a94bf398-c1c1-4082-833c-112caaa404c7	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
113	CPVC	2-1/2"	Endcap	SCH-80	CPVC Fittings	2025-01-02 02:53:33.173743	4	f7b35a46-ed01-4d7f-ad4f-71a79041d961	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
117	CPVC	2-1/2"	Tee	SCH-80	CPVC Fittings	2025-01-02 02:54:30.982091	1	7c61662f-d83d-44bf-aa99-0f90e48bb2b2	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
119	CPVC	2-1/2"	Endcap	SCH-80	CPVC Fittings	2025-01-02 03:07:35.747666	2	45a21423-f400-4f39-acc8-23f18f495f47	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
120	CPVC	2-1/2"	Endcap	SCH-80	CPVC Fittings	2025-01-02 03:07:52.330343	3	00e29220-7475-4b9e-803e-dbccd09d6660	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
122	CPVC	1"	Pipe	SDR 11	CPVC Pipe 3/4"; 1"	2025-01-02 03:09:31.803123	4	37843eb3-fc71-4d1f-bfb2-f2ef7fdbae1a	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
98	CPVC	1"	90* Elbow	SDR 11	CPVC Fittings	2025-01-02 00:05:29.880519	243	98c3189b-5320-4a55-bf97-18cb267ced85	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
103	CPVC	3/4"	Pipe	SDR 11	CPVC Pipe 3/4"; 1"	2025-01-02 01:35:35.660179	6	dca61d3e-639e-4b61-9f01-7715b27915da	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
104	CPVC	1"	Pipe	SDR 11	CPVC Pipe 3/4"; 1"	2025-01-02 02:08:35.881154	2	4aac12b9-7b7b-4212-a94c-c7cf81e8a17d	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
105	CPVC	1"	Brass FTA	Hex	CPVC Fittings	2025-01-02 02:08:35.920064	3	4aac12b9-7b7b-4212-a94c-c7cf81e8a17d	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
106	CPVC	1"	Coupler	SDR 11	CPVC Fittings	2025-01-02 02:39:58.211428	1	e6b45b4d-ba4f-46dd-b594-de4f9743fa51	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
108	CPVC	1"	Brass FTA	Hex	CPVC Fittings	2025-01-02 02:48:52.754404	3	74e0445a-54fd-4b39-b64c-eb4c078c89f9	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
110	CPVC	1"	Brass FTA	SDR 11	CPVC Fittings	2025-01-02 02:52:57.760568	5	a94bf398-c1c1-4082-833c-112caaa404c7	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
111	CPVC	2-1/2"	Endcap	SCH-80	CPVC Fittings	2025-01-02 02:53:16.137116	1	c8db080a-22aa-49e4-80f9-dede4c01e5ed	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
112	CPVC	2-1/2"	Tee	SCH-80	CPVC Fittings	2025-01-02 02:53:16.198108	3	c8db080a-22aa-49e4-80f9-dede4c01e5ed	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
114	CPVC	2-1/2"	Elbow 90*	SCH-40	CPVC Fittings	2025-01-02 02:53:33.240525	4	f7b35a46-ed01-4d7f-ad4f-71a79041d961	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
115	CPVC	2-1/2"	Endcap	SCH-80	CPVC Fittings	2025-01-02 02:54:19.792507	2	548afb12-42f9-4af4-8036-26e987a95fff	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
116	CPVC	2-1/2"	Endcap	SCH-80	CPVC Fittings	2025-01-02 02:54:30.939639	1	7c61662f-d83d-44bf-aa99-0f90e48bb2b2	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
118	CPVC	2-1/2"	Endcap	SCH-80	CPVC Fittings	2025-01-02 02:55:15.708082	1	034eb325-de4e-4cf7-874b-56474397f53e	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
121	CPVC	2-1/2"	Elbow 90*	SCH-80	CPVC Fittings	2025-01-02 03:08:01.316159	3	6fcd5ccf-f682-4880-9c80-2d235856a8aa	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
123	CPVC	1"	MTA (Plastic)	SDR 11	CPVC Fittings	2025-01-02 03:09:46.515717	6	c904ce49-43a0-4786-a285-fb1176c7f072	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
124	CPVC	1"	Coupler	SDR 11	CPVC Fittings	2025-01-02 03:12:57.357608	4	7299efd8-071d-4404-882a-0b15be4fe35c	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
125	CPVC	2-1/2"	Endcap	SCH-80	CPVC Fittings	2025-01-02 03:39:28.021103	1	95aa52c7-2007-4c46-99ce-811a913005f7	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
126	CPVC	2-1/2"	Endcap	SCH-80	CPVC Fittings	2025-01-02 03:41:21.761767	1	d9b0ac3b-5d25-492d-88c2-ff07cae38486	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
127	CPVC	2-1/2"	Elbow 90*	SCH-40	CPVC Fittings	2025-01-02 03:41:21.821088	1	d9b0ac3b-5d25-492d-88c2-ff07cae38486	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
128	CPVC	2-1/2"	Endcap	SCH-80	CPVC Fittings	2025-01-02 03:58:31.791883	1	82ac6be5-38e8-4a8b-8caf-52134e935ca0	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
129	CPVC	1"	Coupler	SDR 11	CPVC Fittings	2025-01-02 04:31:02.29057	1	a5be2355-cc1a-4990-8b5d-e5f294a33509	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
130	CPVC	2-1/2"	Elbow 90*	SCH-80	CPVC Fittings	2025-01-02 04:33:51.982919	1	8c96426d-3ea3-401b-adf6-787b29df9100	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
131	CPVC	1"	Pipe	SDR 11	CPVC Pipe 3/4"; 1"	2025-01-02 05:04:54.789966	1	92dacd35-4b3c-4096-9702-d1809aeb1e82	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
132	CPVC	2-1/2"	Endcap	SCH-80	CPVC Fittings	2025-01-02 05:13:35.60043	1	5a34b37b-203d-41f6-aa67-460df11a269f	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
133	CPVC	2-1/2"	Elbow 90*	SCH-80	CPVC Fittings	2025-01-02 05:21:32.759855	1	5be86b53-28d7-40ae-9ff9-2c2de55ab480	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
134	CPVC	4"	Elbow 90*	SCH-80	CPVC Fittings	2025-01-02 05:23:47.516279	1	b75d2d12-c9f0-465f-ae7a-e001ef3d9fbb	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
135	CPVC	1"	Coupler	SDR 11	CPVC Fittings	2025-01-02 05:38:57.808017	1	c83525de-97bd-443b-9719-5a8613bff511	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
136	CPVC	1"	Tee	SDR 11	CPVC Fittings	2025-01-02 05:44:11.946267	1	45b865db-4070-4c32-a43c-eb4a86743db0	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
137	CPVC	2-1/2"	Endcap	SCH-80	CPVC Fittings	2025-01-02 05:46:42.901669	1	378d9c90-3ddb-402b-8735-b99b63bead31	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
138	CPVC	2-1/2"	Endcap	SCH-80	CPVC Fittings	2025-01-02 05:57:38.641458	1	147369d8-fdd9-481c-b62a-63ff91cf340d	2d9c74fc-16c6-42be-861e-3418f1812c3a	\N	\N	\N
139	CPVC	1"	Pipe	SDR 11	CPVC Pipe 3/4"; 1"	2025-01-02 09:36:38.709741	1	23606ae0-79c2-4749-9436-829d999e30ff	2d9c74fc-16c6-42be-861e-3418f1812c3a	630.00	\N	310.00
140	CPVC	2-1/2"	Elbow 90*	SCH-80	CPVC Fittings	2025-01-02 09:38:29.335809	1	c0499b55-9cc5-4759-8137-00dd25ececd1	2d9c74fc-16c6-42be-861e-3418f1812c3a	985.00	43.50	\N
141	CPVC	1-1/4	pipe	SDR 13.5	CPVC Pipe 1-1/4"; 1-1/2"; 2"	2025-01-02 09:45:47.024416	1	4ee3b32c-80ac-4c13-a17a-efd57cbf58e7	2d9c74fc-16c6-42be-861e-3418f1812c3a	801.00	\N	405.00
147	CPVC	2-1/2"	Endcap	SCH-80	CPVC Fittings	2025-01-02 11:48:44.841664	1	7c2941e1-fd55-4441-bc80-5c2ee3d458f2	2d9c74fc-16c6-42be-861e-3418f1812c3a	338.00	43.50	\N
148	CPVC	2-1/2"	Elbow 90*	SCH-80	CPVC Fittings	2025-01-02 11:48:55.109028	1	7c2941e1-fd55-4441-bc80-5c2ee3d458f2	2d9c74fc-16c6-42be-861e-3418f1812c3a	985.00	43.50	\N
149	CPVC	2-1/2"	Elbow 90*	SCH-40	CPVC Fittings	2025-01-02 11:48:55.110037	1	7c2941e1-fd55-4441-bc80-5c2ee3d458f2	2d9c74fc-16c6-42be-861e-3418f1812c3a	620.00	43.50	\N
150	CPVC	1"	Pipe	SDR 11	CPVC Pipe 3/4"; 1"	2025-01-02 11:49:36.866465	1	ffcbaabd-019e-4f28-a7e6-8446b60920a3	2d9c74fc-16c6-42be-861e-3418f1812c3a	630.00	\N	310.00
151	CPVC	1"	Tee	SDR 11	CPVC Fittings	2025-01-02 11:49:47.913765	1	ffcbaabd-019e-4f28-a7e6-8446b60920a3	2d9c74fc-16c6-42be-861e-3418f1812c3a	45.70	43.50	\N
152	CPVC	1"	45* Elbow	SDR 11	CPVC Fittings	2025-01-02 11:49:47.978402	1	ffcbaabd-019e-4f28-a7e6-8446b60920a3	2d9c74fc-16c6-42be-861e-3418f1812c3a	45.20	43.50	\N
153	CPVC	1-1/4	pipe	SDR 13.5	CPVC Pipe 1-1/4"; 1-1/2"; 2"	2025-01-02 11:55:53.366271	1	13c824fc-453f-4fb8-b18f-b87f9de54969	2d9c74fc-16c6-42be-861e-3418f1812c3a	801.00	\N	405.00
154	CPVC	2-1/2"	Endcap	SCH-80	CPVC Fittings	2025-01-02 11:56:20.662598	1	13c824fc-453f-4fb8-b18f-b87f9de54969	2d9c74fc-16c6-42be-861e-3418f1812c3a	338.00	43.50	\N
155	CPVC	2-1/2"	Tee	SCH-80	CPVC Fittings	2025-01-02 11:56:20.719566	1	13c824fc-453f-4fb8-b18f-b87f9de54969	2d9c74fc-16c6-42be-861e-3418f1812c3a	1522.00	43.50	\N
156	CPVC	4"	Endcap	SCH-80	CPVC Fittings	2025-01-02 12:01:38.326708	1	f9efd8aa-7f0e-436c-ab49-4dfeb0e0977d	2d9c74fc-16c6-42be-861e-3418f1812c3a	937.00	43.50	\N
161	CPVC	2-1/2"	Elbow 90*	SCH-40	CPVC Fittings	2025-01-02 12:24:33.575473	1	9b495aa1-61c7-4e00-aeb1-429e25c85a62	2d9c74fc-16c6-42be-861e-3418f1812c3a	620.00	43.50	\N
162	CPVC	2-1/2"	Tee	SCH-80	CPVC Fittings	2025-01-02 12:24:43.508366	1	9b495aa1-61c7-4e00-aeb1-429e25c85a62	2d9c74fc-16c6-42be-861e-3418f1812c3a	1522.00	43.50	\N
163	CPVC	2-1/2"	Endcap	SCH-80	CPVC Fittings	2025-01-02 12:34:53.675188	1	aabdfab4-8190-4aee-a4e8-a7e395a62ae2	2d9c74fc-16c6-42be-861e-3418f1812c3a	338.00	43.50	\N
164	CPVC	4"	Endcap	SCH-80	CPVC Fittings	2025-01-02 14:05:29.176461	1	e47b03b7-dca5-4556-a8d0-1bb269be4c58	2d9c74fc-16c6-42be-861e-3418f1812c3a	937.00	43.50	\N
165	CPVC	4"	Elbow 90*	SCH-40	CPVC Fittings	2025-01-02 14:05:39.045391	1	e47b03b7-dca5-4556-a8d0-1bb269be4c58	2d9c74fc-16c6-42be-861e-3418f1812c3a	1602.00	43.50	\N
166	CPVC	4"	Elbow 90*	SCH-40	CPVC Fittings	2025-01-02 16:09:19.464786	1	d91e23d3-47e7-4b1d-a1b8-6007fb77d3bc	2d9c74fc-16c6-42be-861e-3418f1812c3a	1602.00	43.50	\N
168	CPVC	3"	Elbow 90*	SCH-40	CPVC Fittings	2025-01-02 17:01:32.794971	1	c41787fc-e379-4b0b-bcf2-5ac07c69eca9	2d9c74fc-16c6-42be-861e-3418f1812c3a	980.00	43.50	\N
169	CPVC	3"	Tee	SCH-80	CPVC Fittings	2025-01-02 17:01:32.794971	1	c41787fc-e379-4b0b-bcf2-5ac07c69eca9	2d9c74fc-16c6-42be-861e-3418f1812c3a	2263.00	43.50	\N
171	UPVC	1-1/4"x1"	Reducing Coupler	SCH-80	UPVC Fitting	2025-01-02 17:03:17.388767	1	cae37cc1-a457-4f86-91bc-be5c58c63265	2d9c74fc-16c6-42be-861e-3418f1812c3a	43.60	61.00	\N
172	CPVC	2-1/2"	Tee	SCH-80	CPVC Fittings	2025-01-02 18:39:38.4201	1	6013d145-7ee7-453a-9e03-e586b2f0e0c4	2d9c74fc-16c6-42be-861e-3418f1812c3a	1522.00	43.50	\N
173	CPVC	2"x1/2"	Reducing Bush	SDR 11	CPVC Fittings	2025-01-02 18:39:49.493967	1	9c0a7bb6-9a37-435d-b7b8-f44dbbd911a0	2d9c74fc-16c6-42be-861e-3418f1812c3a	111.10	43.50	\N
177	CPVC	4"	Elbow 90*	SCH-40	CPVC Fittings	2025-01-02 22:51:06.426563	1	f7242903-3591-4f5c-9564-b097e8f2f925	2d9c74fc-16c6-42be-861e-3418f1812c3a	1602.00	43.50	\N
178	SWR	110MM	Pipe Single Socket	Type A	UGD / SWR Pipe 75; 90; 110; 160mm	2025-01-05 17:02:04.664532	1	6e677d3f-3d6b-4bc9-bd04-46bc168d3526	12dc4e06-9535-4ec8-8201-e30a53922e27	1294.00	\N	430.00
176	SWR	63MM	Pipe Single Socket	6 mtr	SWR / Agri Pipe	2025-01-02 22:00:09.397709	1	52d11e55-bbac-4d03-a9de-556c4c39bec9	2d9c74fc-16c6-42be-861e-3418f1812c3a	1279.00	68.50	\N
179	CPVC	1-1/4	pipe	SDR 13.5	CPVC Pipe 1-1/4"; 1-1/2"; 2"	2025-01-05 17:06:22.088968	1	d9d38187-83a5-4a5a-8095-219367111be0	aa4470bd-2715-495f-a52d-72f67976fcc8	801.00	\N	405.00
\.


--
-- TOC entry 4940 (class 0 OID 33228)
-- Dependencies: 228
-- Data for Name: cards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cards (card_id, type, size, items) FROM stdin;
194fd239-4177-4634-b3bf-6ff6f16ebbf9	SWR	100gm	[{"item_id": "528", "quantity": 6}]
6190f532-bfa4-49ab-a95e-e21f7f74ec76	CPVC	1-1/4"x1"	[{"item_id": "92", "quantity": 3}, {"item_id": "38", "quantity": 6}]
25e12bb8-a72f-4079-b6d1-53962f07f443	SWR	63MM	[{"item_id": "340", "quantity": null}]
1a7fb766-4161-41d0-a19a-0e4a5e857848	SWR	4"x2-1/2"	[{"item_id": "396", "quantity": 3}]
4b286cd4-7bb3-4086-b081-2faf7175181b	SWR	500ml	[{"item_id": "526", "quantity": 5}]
607e37fe-5b22-47b7-bb6a-d0ce7f37ffb2	SWR	100gm	[{"item_id": "528", "quantity": 6}]
c69c741f-410c-4ff6-9fb0-0fb20e68138e	SWR	63MM	[{"item_id": "340", "quantity": 4}]
16cde97f-8afa-46b3-bc41-7e3f7227d299	Agri	63MM	[{"item_id": "468", "quantity": 5}]
b2dbf8c4-8504-4c44-bff0-08e5e04cdc2b	UDS	160MM	[{"item_id": "521", "quantity": 5}]
4725b3ce-dd0a-4af0-beb8-4079a6687240	SWR	63MM	[{"item_id": "340", "quantity": 7}]
a6de9f62-b42b-4121-b998-2bafab85e48e	SWR	4"x2-1/2"	[{"item_id": "396", "quantity": 7}]
9e133455-3f1c-4359-bfd9-c56fa9cc45df	UDS	160MM	[{"item_id": "521", "quantity": 3}]
3ec42ff0-f573-494c-9482-13d5d2a89fe1	SWR	100gm	[{"item_id": "528", "quantity": 3}]
6b150c40-950f-422f-ba14-d3020e86c0ee	SWR	50MM	[{"item_id": "346", "quantity": 2}]
8bcb31f3-54f9-43ac-915f-5c99d5666578	UDS	200MM	[{"item_id": "522", "quantity": 8}]
a43013cd-7c76-4fb8-93dd-30ca00a87a64	SWR	4-1/2"x4"	[{"item_id": "394", "quantity": 9}]
f570fdfb-244f-4477-94fd-123f97ae0bd4	SWR	100gm	[{"item_id": "528", "quantity": null}]
44401695-0196-459c-80de-924352b61b71	SWR	4"x2-1/2"	[{"item_id": "396", "quantity": 7}]
fbdc282e-100e-46b0-81b1-d7ffc79290c5	SWR	4"x2-1/2"	[{"item_id": "396", "quantity": 7}, {"item_id": "378", "quantity": 9}]
8564c1fb-c107-4d5a-aedb-fc2267e96f03	CPVC	3"	[{"item_id": "164", "quantity": 8}]
f818ac9e-9224-4712-a2c5-3ef887f1952b	UPVC	1/2"	[{"item_id": "170", "quantity": 7}]
1cf31cec-8729-4708-bc90-5eba605012c1	SWR	4"x2-1/2"	[{"item_id": "396", "quantity": 8}]
42111d5f-e416-490e-83fe-ccef549cbf6a	SWR	4"x2"	[{"item_id": "395", "quantity": 8}]
339239e3-2af4-4707-af2a-9a02c4c32fc1	SWR	100gm	[{"item_id": "528", "quantity": 6}]
3a839133-dd0e-4ef0-b604-34c9ab657094	SWR	500ml	[{"item_id": "526", "quantity": 8}]
f02471c8-3944-4730-aa30-4865d58e77e2	SWR	63MM	[{"item_id": "340", "quantity": 8}]
bb5181f9-30dd-408a-b588-d9ebc3b1ed53	UPVC	1-1/4"x1"	[{"item_id": "282", "quantity": 6}]
82101bfa-84a8-4a43-b5c8-7029ef85c72f	CPVC	2"	[{"item_id": "5", "quantity": 10}]
4a9e1540-3d44-4ba3-a053-a165de0768f0	SWR	4-1/2"x4"	[{"item_id": "394", "quantity": 8}]
38090344-d215-4c9d-9cfe-96fee5fdf2d5	SWR	100gm	[{"item_id": "528", "quantity": 7}]
b1c7be4a-1a60-4329-b341-8e243f6321b7	Agri	75MM	[{"item_id": "469", "quantity": 9}, {"item_id": "484", "quantity": 1}]
23dc81f8-f6c0-4371-8344-2feeeda1dc48	CPVC	7"	[{"item_id": "117", "quantity": 9}, {"item_id": "119", "quantity": 8}]
a11fa07a-babc-443c-8a46-435769facb33	Agri	50x40MM	[{"item_id": "495", "quantity": 1}]
c8b77d3d-a087-42a0-8e9a-dfcd521174ba	Agri	50x40MM	[{"item_id": "495", "quantity": 10}]
9e86810e-2ab5-4eab-9c9b-77fa74b8527b	SWR	1000ml	[{"item_id": "527", "quantity": 4}]
348834cc-11ff-4b6e-99c8-b214499bf13a	UDS	200MM	[{"item_id": "522", "quantity": 2}]
2cdbe9d0-cb0e-4bbb-9b17-33c1d7ac23b3	UPVC	10ml	[{"item_id": "333", "quantity": 1}]
d119c122-67b3-4fbc-8676-0f408f464b0b	UPVC	1-1/2"x1-1/4"	[{"item_id": "284", "quantity": 1}, {"item_id": "212", "quantity": 1}]
334eddbf-2dc5-4fbd-a7ff-5c4637dfc19a	SWR	110x75MM	[{"item_id": "417", "quantity": 1}]
7d534ec5-66c2-44d5-b0a2-7fa8c8af9151	SWR	500ml	[{"item_id": "526", "quantity": 4}]
fbb594c4-1cbf-490a-a040-de474f251e35	UDS	200MM	[{"item_id": "522", "quantity": 4}]
0c9d3d1b-ad82-4e81-a589-9829c8f0a952	CPVC	3/4"x1/2"	[{"item_id": "148", "quantity": 2}, {"item_id": "138", "quantity": 1}]
8ddd6bf9-016a-47ca-83b5-6fcb196e6b16	Agri	75x63MM	[{"item_id": "500", "quantity": 3}]
c0f47b0f-42f0-4fa0-bfe2-de90e7b9a791	UPVC	1-1/2"x1-1/4"	[{"item_id": "225", "quantity": 9}]
a9b61162-f3e9-4055-baef-0b6fedee9e63	SWR	40MM	[{"item_id": "345", "quantity": 8}]
0e09198d-6d60-474c-a32e-a4e43cdf8bd6	SWR	160MM REPAIR	[{"item_id": "384", "quantity": 7}]
d8a98b29-0297-4d75-ab74-c66611e442ed	SWR	100gm	[{"item_id": "528", "quantity": 7}]
4a4736da-e5ce-468e-8e28-e71be0b764f3	SWR	40MM	[{"item_id": "345", "quantity": 5}]
80f8f15d-ef71-4550-9070-3c312bf8a010	SWR	250gm	[{"item_id": "529", "quantity": 3}]
d10d3347-50ff-462a-aaea-f5929d905fd0	UDS	160MM	[{"item_id": "521", "quantity": 2}]
ae742b62-b3d6-498f-8d32-949c3b7cc831	Agri	75x50MM	[{"item_id": "509", "quantity": 1}, {"item_id": "499", "quantity": 5}]
4529dc4d-8953-4da4-bcef-2ebde4c85c16	SWR	63MM	[{"item_id": "340", "quantity": 3}]
1de73fd1-1cbf-448f-b00b-9046cdcd0c52	SWR	4"x2-1/2"	[{"item_id": "378", "quantity": 6}]
9ddb1b41-4c9d-4db1-bae7-206db7d05573	SWR	40MM	[{"item_id": "345", "quantity": null}]
3493c476-6b91-4dbe-8c1f-a3fd6ce68c4d	SWR	63MM	[{"item_id": "340", "quantity": 7}]
4f7f32b6-b289-4416-befd-b6fb5de74f50	UDS	160MM	[{"item_id": "521", "quantity": 8}]
f4ee6769-005f-4d07-b991-52a5de8ef866	SWR	50MM	[{"item_id": "346", "quantity": 3}]
8b74ee4d-d191-453f-abb9-384095cf08a4	UPVC	1-1/2"x1/2"	[{"item_id": "209", "quantity": 5}]
66bb6d55-9d8d-4730-b96c-4775454e1cfa	UPVC	3/4"	[{"item_id": "180", "quantity": 6}]
067d6729-4d95-482e-8d98-7090ad21f007	CPVC	3/4"	[{"item_id": "142", "quantity": 1}]
5390c1d0-8193-4070-a526-0ce5416f9ca5	CPVC	1"	[{"item_id": "51", "quantity": 1}]
31223a5e-73ef-468a-9840-16ff7aae32a8	CPVC	1"	[{"item_id": "7", "quantity": 1}]
b862f6f9-3bf6-411c-a3c7-428d05c1e5de	CPVC	1"	[{"item_id": "7", "quantity": 7}]
6dc5b642-92d2-49d2-b74f-01de91c46b94	CPVC	1"	[{"item_id": "7", "quantity": 6}]
3d015cd7-e358-4ada-bd7c-9394acf9dd0b	CPVC	1"	[{"item_id": "62", "quantity": 3}]
e85aefd9-7407-46ad-bf86-ac04987b6932	CPVC	1"	[{"item_id": "7", "quantity": 2}]
ad13dc11-c0a3-445a-969a-aaaaf51b4d24	Agri	110x63MM	[{"item_id": "504", "quantity": 1}]
75a0296e-f346-4f54-9b11-478572c1a577	CPVC	1-1/4"x1/2"	[{"item_id": "90", "quantity": 1}]
2844e45d-bd2b-4307-9162-8794b9e8acb1	CPVC	1-1/4"x1/2"	[{"item_id": "90", "quantity": 1}]
4758e3c0-12cc-4d93-ba94-f0f155488eb2	CPVC	1-1/4"x1/2"	[{"item_id": "90", "quantity": 1}]
f712b1c9-5c1f-4f00-b571-c50b1647cc06	CPVC	1-1/4"x1/2"	[{"item_id": "90", "quantity": 1}]
3874d14f-171e-4e28-b693-e5a103422fff	CPVC	3"	[{"item_id": "164", "quantity": 1}]
1c1b3d85-0074-45d8-b9f9-0fac7f670ecb	CPVC	1-1/4"	[{"item_id": "48", "quantity": 1}]
5c05448e-d7f1-4ead-b4ad-80b8f51e854f	Agri	63MM	[{"item_id": "468", "quantity": 1}]
b7b601b6-3b3d-48b1-80c9-bb4c02ae95a9	Agri	110x63MM	[{"item_id": "504", "quantity": 1}, {"item_id": "512", "quantity": 1}]
4e6a5ff7-a547-4b9f-b34c-976e71591903	Agri	110x63MM	[{"item_id": "504", "quantity": 1}, {"item_id": "512", "quantity": 1}]
fa364f8d-a3a2-4db7-9210-baae3f4e8d0b	SWR	1000ml	[{"item_id": "527", "quantity": 1}]
dc36d6ff-eb30-4fea-b2fe-b88e95b630a7	Agri	63x50MM	[{"item_id": "497", "quantity": 12}, {"item_id": "497", "quantity": 17}]
536761f5-213a-4f4e-9239-83b94c983ff7	CPVC	1"	[{"item_id": "106", "quantity": 1}, {"item_id": "83", "quantity": 1}, {"item_id": "110", "quantity": 1}]
dd386e6f-8f6b-4ec3-97b7-b7c8abb778e9	CPVC	1"	[{"item_id": "106", "quantity": 1}, {"item_id": "143", "quantity": 1}]
c1a7f2a3-c10b-4e9c-81e6-728ef89dc6f2	CPVC	3/4	[{"item_id": "1", "quantity": 1}]
d6ecb498-0e9c-4928-844a-f8d67ec3e251	SWR	110MM	[{"item_id": "343", "quantity": 1}]
f28166c7-ac4e-4cf4-85df-9bbf9d5f4119	Agri	110MM	[{"item_id": "471", "quantity": 10}]
24e62446-5291-4542-9b2e-e7bf06d85a4a	Agri	110MM	[{"item_id": "471", "quantity": 3}, {"item_id": "486", "quantity": 1}]
61c913a4-4121-43da-9758-a27f4b3449de	Agri	110MM	[{"item_id": "471", "quantity": 10}]
f357a446-9be0-41fe-8aef-7a3c3e6e2dd6	CPVC	1-1/4"	[{"item_id": "74", "quantity": 1}]
f87cf88f-c1db-4baa-b2e0-1b88fd8985cb	SWR	110MM	[{"item_id": "391", "quantity": 10}, {"item_id": "382", "quantity": 5}, {"item_id": "343", "quantity": 10}]
881e049d-f114-4025-baab-2e4b6d4e3c2e	CPVC	1"	[{"item_id": "113", "quantity": 1}, {"item_id": "531", "quantity": 1}, {"item_id": "121", "quantity": 1}]
36c406c0-4da1-452c-a2a7-eb7e1d3a38aa	CPVC	237ml	[{"item_id": "156", "quantity": 1}]
64ea7afc-3128-4f7e-93fd-74a80fdfccbd	CPVC	59ml	[{"item_id": "154", "quantity": 1}]
0d4c77c1-afef-406d-b2a1-50088795dca0	CPVC	1"x3/4"	[{"item_id": "150", "quantity": 1}, {"item_id": "13", "quantity": 1}, {"item_id": "36", "quantity": 1}]
bc93d81b-a458-4a97-b698-b42358ef52e1	CPVC	3/4"x1/2"	[{"item_id": "138", "quantity": 1}, {"item_id": "129", "quantity": 1}]
f43cdb30-831f-4a51-9c3a-1b4452a88173	CPVC	1"	[{"item_id": "106", "quantity": 1}, {"item_id": "143", "quantity": 1}]
bf7ecc9d-f132-4a2a-80f9-5efcb89205bd	CPVC	3/4"	[{"item_id": "105", "quantity": 1}, {"item_id": "82", "quantity": 1}, {"item_id": "109", "quantity": 1}]
18c09ac4-30ff-428e-8bd7-34f87e9a0e9c	CPVC	1	[{"item_id": "2", "quantity": 1}]
48b411f7-0962-4862-b836-bfeb08194101	Agri	90MM	[{"item_id": "470", "quantity": 1}]
97c47a34-fed6-43d7-bc35-d2682167e95a	SWR	110x90MM	[{"item_id": "418", "quantity": 1}]
1f2f7971-1b2f-4511-b33d-f3e6b5610831	CPVC	1"x1"	[{"item_id": "151", "quantity": 1}]
f4c5ec07-126d-44e1-9d6e-94f21d96fc79	CPVC	1"	[{"item_id": "143", "quantity": 1}, {"item_id": "62", "quantity": 1}]
97602327-abff-4757-aeb1-de856141c8fb	Agri	50MM	[{"item_id": "467", "quantity": 1}, {"item_id": "482", "quantity": 1}]
570f6b64-80f9-443a-8437-ed082603cdb9	SWR	1000ml	[{"item_id": "527", "quantity": 1}]
4fbb04bd-9b38-4416-ab2d-29ec2cdbb141	CPVC	2"x1-1/4"	[{"item_id": "100", "quantity": 1}]
283a8b80-6dca-4165-aaff-fc095757abb3	Agri	90MM	[{"item_id": "470", "quantity": 1}, {"item_id": "517", "quantity": 1}, {"item_id": "485", "quantity": 1}]
a7d34c2f-797c-4c12-b1c5-e22e1f0c2e05	SWR	63MM	[{"item_id": "340", "quantity": 1}]
911934af-b0f5-4c35-8a75-dc6bbcfec420	SWR	63MM	[{"item_id": "340", "quantity": 1}]
a3166e29-2c75-47c6-b424-147a2b0058d2	CPVC	1-1/4"x3/4"	[{"item_id": "91", "quantity": 1}]
68b9ce26-de99-4b5c-a464-5ba898012456	SWR	63MM	[{"item_id": "340", "quantity": 1}]
bd9b38a0-0485-4d3b-b523-4bee7895dd58	CPVC	2"x3/4"	[{"item_id": "98", "quantity": 1}]
ddedf7f7-9534-4730-91bc-266ab745e257	Agri	75x50MM	[{"item_id": "499", "quantity": 1}]
5a35400c-680f-467b-9ebe-837b7c48499d	Agri	75MM	[{"item_id": "469", "quantity": 1}]
071bd512-4430-402e-9958-1775c88ab0a7	Agri	90x63MM	[{"item_id": "501", "quantity": 1}]
d063fa35-fd10-4b6c-81fd-fbb88b4966d1	SWR	4-1/2"x4"	[{"item_id": "394", "quantity": 1}]
f7ad59cf-2d79-4e01-af2d-a98d5c9442b4	UDS	160MM	[{"item_id": "521", "quantity": 1}]
3ff6a268-76ec-4d73-9c42-4919e0801afc	CPVC	1"	[{"item_id": "106", "quantity": 1}]
85ca0fdd-e248-45d1-bdbe-0329100db270	CPVC	3/4	[{"item_id": "1", "quantity": 1}]
210d6f8e-8774-4ade-bd2d-a0a9f47291bd	Agri	90MM	[{"item_id": "470", "quantity": 1}]
88600f86-284e-4660-92c0-08183c98f730	Agri	63x50MM	[{"item_id": "497", "quantity": 1}]
8ec55a9b-1181-4d4b-93eb-198a7f413489	CPVC	2"x1-1/4"	[{"item_id": "100", "quantity": 1}]
aeaa2fa1-d456-4b25-b3c9-58ced6d3d07d	Agri	75MM	[{"item_id": "469", "quantity": 1}]
42b10f29-7719-4c27-a66a-460bd8788a69	Agri	90x63MM	[{"item_id": "501", "quantity": 1}]
93c2132e-bb1a-4319-b26e-5ad63e718a9a	Agri	50x40MM	[{"item_id": "495", "quantity": 1}]
db608008-626d-4052-b269-3ced63587b44	Agri	110x90MM	[{"item_id": "506", "quantity": 1}]
59082e8d-90a4-4248-aae7-1e2e46c916db	CPVC	3"	[{"item_id": "164", "quantity": 2}, {"item_id": "163", "quantity": 9}]
30522421-b1d8-4b16-b356-545885462274	Agri	110MM	[{"item_id": "518", "quantity": 1}]
3900444d-0893-4c1c-bb71-28366e8aae78	UDS	160MM	[{"item_id": "521", "quantity": 1}]
c5dd75c2-5fe7-471f-970d-91020fec7404	CPVC	3/4	[{"item_id": "1", "quantity": 1}]
74bd7d04-9a0a-4e38-819d-a7628a33fd33	UDS	200MM	[{"item_id": "522", "quantity": 1}]
036352a4-1181-406b-ade1-5d00f8c3ac97	Agri	75x40MM	[{"item_id": "498", "quantity": 1}]
cc477e9c-21db-4e8a-98d3-3bffa06fee65	CPVC	237ml	[{"item_id": "156", "quantity": 1}]
94ab3895-3ca1-471d-a5ef-50a8184e5cc5	CPVC	4"	[{"item_id": "159", "quantity": 1}, {"item_id": "167", "quantity": 1}]
6cd729e6-a4ab-4d3c-8c4e-41cb631d33af	CPVC	3/4	[{"item_id": "1", "quantity": 1}]
78c38d5b-4900-403a-a486-1e621a992fac	CPVC	1"	[{"item_id": "51", "quantity": 1}]
c8bf1589-0831-4bdb-871d-cf771920cbfd	Agri	63x50MM	[{"item_id": "497", "quantity": 1}]
ca253faa-9bbd-483a-a696-c6078bed108a	Agri	110MM	[{"item_id": "471", "quantity": 1}]
06f4ca88-f4a4-4525-8bf6-6d287d0d75b1	UPVC	1"x3/4"	[{"item_id": "318", "quantity": 1}, {"item_id": "279", "quantity": 1}]
b45e8baf-fa5f-422b-943a-915735280a48	SWR	50ml	[{"item_id": "523", "quantity": 1}]
b84bbbfe-78d8-42bb-a624-d4b0337ef524	Agri	63x40MM	[{"item_id": "496", "quantity": 1}, {"item_id": "507", "quantity": 1}]
57ca3c93-5f7b-4704-8d9b-decef2a12a0d	CPVC	1"	[{"item_id": "47", "quantity": 1}, {"item_id": "531", "quantity": 1}]
faa72ea2-bf55-4347-99d8-7a7e67618f65	UPVC	1-1/2"x1/2"	[{"item_id": "209", "quantity": 1}]
a1977771-26b8-4c5d-9930-4c0e2cdd6f52	SWR	100ml	[{"item_id": "524", "quantity": 10}]
ebd2dcfa-432c-4b21-a3fb-8d425d90e48b	UPVC	250ml	[{"item_id": "337", "quantity": 1}]
4d164f4a-44d1-4ae9-acf2-05c2be69ec8c	UDS	160MM	[{"item_id": "521", "quantity": 1}]
78ade88d-fef8-4ba8-9617-fa28fece0040	UPVC	1"x1/2"	[{"item_id": "317", "quantity": 1}, {"item_id": "278", "quantity": 1}]
7f68e34e-53d9-4976-ac31-bc71e14e57cb	Agri	75x50MM	[{"item_id": "499", "quantity": 1}, {"item_id": "509", "quantity": 1}]
415863b5-c5a8-4188-85c8-b2229fd8fe86	CPVC	1"x1"	[{"item_id": "151", "quantity": 1}]
2e54a4a2-6e8a-49f3-83b6-e48288805b14	UDS	200MM	[{"item_id": "522", "quantity": 1}]
7d249169-f84f-407f-9d61-84279556b02f	Agri	75x50MM	[{"item_id": "509", "quantity": 1}]
35aa61dc-c2f1-4919-9685-0a42838f3276	UDS	160MM	[{"item_id": "521", "quantity": 1}]
ff7942c3-008c-487c-903b-1584447e843e	Agri	90MM	[{"item_id": "517", "quantity": 1}]
804d7f1a-4a06-40c2-8965-04219b50572c	SWR	90MM	[{"item_id": "381", "quantity": 1}]
0a776bc3-9097-4139-b47b-160d07515c3b	UPVC	10ml	[{"item_id": "333", "quantity": 1}]
bed7fe33-efbc-4342-a45d-d7b37c454b67	UPVC	10ml	[{"item_id": "333", "quantity": 1}]
7a4ab52a-e780-4ec0-a934-f1dd204147b6	SWR	110x90MM	[{"item_id": "418", "quantity": 1}]
45f3fe89-6f05-4381-b27a-2bfbc3153db3	Agri	75x40MM	[{"item_id": "498", "quantity": 1}]
38ea00bc-0a8c-4c4d-915d-8b647ff14bd0	UDS	160MM	[{"item_id": "521", "quantity": 1}]
ffafd138-3e1d-47ba-b988-c7db1ce9a701	Agri	75MM	[{"item_id": "516", "quantity": 1}, {"item_id": "484", "quantity": 1}]
6fac79ef-29df-421a-bcb7-31218ec510c0	Agri	90MM	[{"item_id": "470", "quantity": 1}]
1acd282f-ce35-47e6-a269-dc2918518a0c	Agri	90MM	[{"item_id": "470", "quantity": 1}]
4cd6c6a4-7970-4123-baed-a3e28849a312	CPVC	3/4	[{"item_id": "1", "quantity": 1}]
f7f4173c-f27e-428a-91b0-ccc497b31285	CPVC	1-1/4"x3/4"	[{"item_id": "91", "quantity": 1}]
3777fd29-160a-47fe-984e-c83bf527c8bd	Agri	110x90MM	[{"item_id": "506", "quantity": 1}]
0ccb3097-156c-4942-a224-affdc3636294	CPVC	1-1/4"x3/4"	[{"item_id": "15", "quantity": 1}]
5e258392-6237-46f0-a182-cdce958810ba	CPVC	1-1/4"x3/4"	[{"item_id": "15", "quantity": 1}]
c46aa8bc-826c-406d-a938-6fc427770dfb	CPVC	1-1/2	[{"item_id": "4", "quantity": 1}]
c30c2716-8ff4-49bf-85d2-30ed831a22f3	CPVC	1-1/2	[{"item_id": "4", "quantity": 1}]
63b325ea-d3f6-4b05-b53e-5f84a45c79c1	CPVC	1-1/2	[{"item_id": "4", "quantity": 1}]
02de8fdf-7101-4305-955c-a64303dc2130	UPVC	2"x1"	[{"item_id": "285", "quantity": 1}]
d334232f-4f09-414c-884c-d9dac25eca6d	CPVC	3"	[{"item_id": "163", "quantity": 1}]
16b25e66-76cc-4701-ba8b-fecc3436bf70	Agri	50MM	[{"item_id": "467", "quantity": 1}]
f5a999d5-7223-4264-a3db-be05c58b1a53	Agri	75MM	[{"item_id": "484", "quantity": 1}]
67224775-5e86-4e19-9d46-42822e57dece	Agri	110x90MM	[{"item_id": "506", "quantity": 1}]
dfdc69f6-3725-46e1-8931-fd0cfef29391	Agri	110MM ISI	[{"item_id": "476", "quantity": 1}]
b65a9899-b24b-455e-90ec-749d9b2da77f	Agri	50MM	[{"item_id": "467", "quantity": 1}]
04c6ffdd-6809-41ea-8d6a-a54cd7419434	CPVC	2"x1-1/4"	[{"item_id": "22", "quantity": 1}]
a8636a65-8fbb-4d0b-a4fa-ba2a69f05f96	Agri	50MM	[{"item_id": "520", "quantity": 1}]
91cbebd1-909c-4de4-8fc2-e5d1787cd0dc	UPVC	10ml	[{"item_id": "333", "quantity": 1}]
639cbb48-4559-42f0-9c6c-576e1e82b594	SWR	500ml	[{"item_id": "526", "quantity": 1}]
bbaa9908-92ba-4739-8c4a-d0459dc6a98c	Agri	110x90MM	[{"item_id": "514", "quantity": 1}]
28e3dba4-28eb-4b17-962d-93a71a9f846c	Agri	50MM	[{"item_id": "520", "quantity": 1}]
b04c9b48-2e25-47bc-8453-660b2dd210f8	UDS	160MM	[{"item_id": "521", "quantity": 1}]
\.


--
-- TOC entry 4943 (class 0 OID 33346)
-- Dependencies: 231
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer (customer_id, title, name, billing_address, shipping_address, phone_number, whatsapp_number) FROM stdin;
53a16bb9-a839-4eb7-8bd1-ba20a36c81d5	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
7eeecd65-e8ee-40d8-a1f9-e5a443cabfa6	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
1c0e86b9-5d78-41c0-9ffd-847db6d9c322	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
c1eed06b-ee0e-412e-a40a-f532d03d3c95	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
f5da4447-aa49-45a5-a16e-98e0a958d20f	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
ec583d7b-d8e8-4adf-8713-18f9e002e162	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
fedf30cc-a667-4424-bf8b-e1c2982374df	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
4ff40b10-1da1-4696-b9b4-b0192e696774	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
25e4d53f-f4c3-4ebc-bcbe-8d1f93f5be47	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
7931337e-18d8-4e60-833d-25077a9a896d	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
f88f677c-366c-4f70-9569-e7352c529990	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
53c27277-2b65-47a5-b11d-9a75c80b9807	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Nr. Karve Statue, Kothrud	+919474808167	+919474808167
e450dec9-a11f-4158-a1ca-7c5388de2d1e	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Nr. Karve Statue, Kothrud	+919474808167	+919474808167
be3b9866-d5b4-4565-b5cc-a26f71c34c4a	M/S	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
08c639aa-9f69-4a16-9152-a126692c7708	M/S	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
332cb511-9ed1-4f72-8ef5-40e45995303b	Mrs.	Yashvi Sandeep Agrawal	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
c961a62a-8a9a-4f2e-a45a-161ec87dc48f	Mrs.	Yashvi Sandeep Agrawal	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
9839a2f4-ec8e-465e-8347-247315ef9d36	Mr.	Yashvi Sandeep Agrawal	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
2d7ee229-04b9-4337-9dc9-fbd35396f232	Mr.	Yashvi Sandeep Agrawal	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency,hjcjjfyhfjfy vesu	+919374808167	+919374808167
7e6336c9-59fb-4e33-a5da-0efe95f03969	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
67fe4c27-36ac-420d-ae20-9949162c20a9	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
02fb1291-eb6e-41bf-ac3b-c9a6a6b64470	Mr.	Yashvi 	Flat No: 1010, City Crown	Flat NCity Crown	+919474808167	+919474808167
086bb66d-b56c-49e7-9fe6-6765bdbb64eb	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Nr. Karve Statue, Kothrud	+919474808167	+919474808167
07009776-8683-4fbd-8b9b-1a00c15f8916						
a7df86bb-79cf-4aba-ae3e-478a40280682	Mrs.	Yashvi Agrawal	Flat No: 1010, City Crown	Nr. Karve Statue, Kothrud	+919474808167	+919474808167
0926f6ef-628e-40b2-a400-f5e0dd30897c	Mrs.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
e37ce6c7-159f-4ef4-a2da-5d53f474920e	Mrs.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	999
cab7f630-a615-4b7c-a416-72d12c67778e	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
40830a76-faff-4477-ade3-3cd6b91db9ce	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
66990ca8-cbd2-42f3-a396-d15e17dd3e78	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
6f1ca7cd-59ba-43cb-bdc4-cf3d330be600	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City	+919474808167	+919474808167
ff6495aa-5e3b-47ad-bd98-b7f4470deb02	Mrs.	b	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
7c3b1eb6-c249-4461-9ed5-4305aee2c851	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
450049b1-ae18-435d-94f2-bbea7087f961	Mrs.	b	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
cb7ed128-8efa-4fea-ba38-9a1e1da7bb1f	Mr.	Yashvi 	Flat No: 1010, City Crown	Flat NCity Crown	+919474808167	+919474808167
ac726ef0-8f70-4b78-a437-cbfa2c132475	Mr.	blah blah blah	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
3ba54b99-a5f1-4021-86cc-427a58e4550c	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Nr. Karve Statue, Kothrud	+919474808167	+919474808167
5369a8c7-22d5-4746-950d-97c247405892	M/S	BLAHHHHHHHHH	A-802, x Resisdency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
ce7c9da3-7493-4924-9373-7cc53f70772a	Mr.	blah blah blah	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
8b115c5b-59d9-48cd-ad74-f9d3e19b7074	Mr.	blah blah blah	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
a9f3966f-55a8-448c-ae8d-3732350939f2	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City	+919474808167	+919474808167
2b3d28bd-9d51-4949-bd7a-d591ce0bedb1	Mrs.	b	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
31ca724b-e6f6-4b05-9a16-05d2701e8485	Mrs.	b	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
7b8f8318-f558-475b-9a4d-86e5dc64c843	Mrs.	b	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
b930edb4-fb60-44e1-9d50-556eadc46b96	Mrs.	b	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
4eea94d3-2a8d-411a-b396-fda8ee19b453	Mrs.	b	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
c2bd1532-1c42-456d-b78b-c5dea051fd53	Mrs.	b	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
35c19608-10db-453a-a544-c1d56732f732	Mrs.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	999
469f6503-c8ea-4bbc-815b-af735c2bd064	Mrs.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	999
dbb37990-7850-4ea4-9e6a-82cc24900e23	Mrs.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	999
aa62ad69-4e24-4772-bcb0-756e27280868	Mr.	Yashvi Sandeep Agrawal	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
9625badc-4214-4cb2-bbb9-ae024d8a200a	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City	+919474808167	+919474808167
63a40585-4c24-4997-bfcf-c154ec77fe3e	M/S	BLAHHHHHHHHH	A-802, x Resisdency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
0d0b5b08-a437-4eab-8558-8130dcacd3e4	M/S	BLAHHHHHHHHH	A-802, x Resisdency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
e12c06fd-b8b5-42b7-ba11-11b87e19bbdf	M/S	BLAHHHHHHHHH	A-802, x Resisdency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
073fc8e4-40ae-438a-a0a7-bdec8a892ea1	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City	+919474808167	+919474808167
ce685a86-4206-4c8c-bf08-896bc8d19f0c	Mr.	blah blah blah	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
92d80c58-8a88-445c-a497-6a273ca4e955	M/S	BLAHHHHHHHHH	A-802, x Resisdency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
7022dbe9-ff39-41fd-b7ed-656230908389	M/S	BLAHHHHHHHHH	A-802, x Resisdency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
c952f14a-153b-4026-a968-ac4533c582f1	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City	+919474808167	+919474808167
8038dcd4-83f5-4b30-bc74-3c79dd107bf1	M/S	BLAHHHHHHHHH	A-802, x Resisdency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
82582a1e-2da7-4720-9b3a-2f4886d3002b	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
744038c1-c847-4af1-8d79-732e1321d529	M/S	BLAHHHHHHHHH	A-802, x Resisdency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
644f452e-4520-4346-ad87-91b3f7a370d4	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Nr. Karve Statue, Kothrud	+919474808167	+919474808167
67b5ab03-fc82-4f16-b3fa-bde63264d6e7	Mr.	Yashvi Sandeep Agrawal	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
cf0a8c6f-b2ef-401e-9e61-a6fbef894323	Mr.	blah blah blah	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
00eb6cf3-9db8-4956-94d7-99937c5043be	Mr.	Yashvi Sandeep Agrawal	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
a19ad91c-ddec-41b7-ba12-9d017d4fbed6	Mr.	Yashvi Sandeep Agrawal	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
a810ec74-0f20-42ed-aaec-e3c0dfa3118f	Mr.	Yashvi Sandeep Agrawal	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
7c73c082-2226-4dc2-bbb8-d1d74ed30f66	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Nr. Karve Statue, Kothrud	+919474808167	+919474808167
81ded308-7d39-4ae8-a00f-09e58e59f132	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
252b3a9b-010c-49d5-aeae-0534a92800c7	Mr.	Yashvi Sandeep Agrawal	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency,hjcjjfyhfjfy vesu	+919374808167	+919374808167
07848f75-556b-4461-8bde-b28459398f5b	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Nr. Karve Statue, Kothrud	+919474808167	+919474808167
8c86de62-e2b6-44dd-beac-d80b634efd98						
50ef0552-723d-429c-bbc4-498e82a9a429						
1f2639b7-8358-4960-a5cc-1b5975afee67	M/S	BLAHHHHHHHHH	A-802, x Resisdency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
3a5c1159-26e4-4d61-8092-65645fd58c01	M/S	BLAHHHHHHHHH	A-802, x Resisdency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
e4f9af0d-b1c1-4143-9a5b-eb75e574ace2	Mrs.	b	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
6d47358c-2d34-4082-b9cb-af3df0e893f7	Mrs.	b	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
adf3e7b1-8cab-43a2-9885-87f0161c726a	Mrs.	b	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
45639111-b1e9-4239-9bc2-e07652896bce	Mr.	Yashvi 	Flat No: 1010, City Crown	Flat NCity Crown	+919474808167	+919474808167
60d22d82-9e83-41c9-9296-3ab06ecc47f3	Mr.	Yashvi 	Flat No: 1010, City Crown	Flat NCity Crown	+919474808167	+919474808167
8585494e-b75e-43f7-992d-c295a6c3d066	Mr.	Yashvi 	Flat No: 1010, City Crown	Flat NCity Crown	+919474808167	+919474808167
0a74ef37-65d8-4774-867f-1d42e2f43437	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Nr. Karve Statue, Kothrud	+919474808167	+919474808167
ffa8ac50-e052-4f98-a1c2-6d89e04ae3b6	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Nr. Karve Statue, Kothrud	+919474808167	+919474808167
543f9f9d-f7a2-4e4e-9537-ac353577128e	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Nr. Karve Statue, Kothrud	+919474808167	+919474808167
103d532c-b7b9-4377-a586-059f4025bb76	M/S	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
9c2fa362-5579-4522-8193-c819e0085271	Mr.	Yashvi 	Flat No: 1010, City Crown	Flat NCity Crown	+919474808167	+919474808167
17d9f84f-af1b-478a-8200-99b6273a7104	Mr.	Yashvi Sandeep Agrawal	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
bef9d2d2-bef4-4339-874d-64ebe0c1b586	Mr.	Yashvi Sandeep Agrawal	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
94f3690d-a32f-4c02-9fe3-9e658fdc014b	M/S	BLAHHHHHHHHH	A-802, x Resisdency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
07c629ac-ce9b-4c8a-9d43-2fbd6c2f0497	Mr.	Yashvi Sandeep Agrawal	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
b7051fe0-5595-4247-9347-92ed2d3f05d3	Mr.	Yashvi Sandeep Agrawal	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
c89e6999-a55c-498e-b4a7-1c3dec3b6a36	M/S	BLAHHHHHHHHH	A-802, x Resisdency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
9fe5bcd9-5bc2-46bb-8792-94dffd86e26e	M/S	BLAHHHHHHHHH	A-802, x Resisdency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
c2233ddf-a82f-4e10-8c6b-b2b3569da93f	M/S	BLAHHHHHHHHH	A-802, x Resisdency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
141346d3-bd3a-4ac6-9dd2-604f27ab12d9	Mr.	blah blah blah	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
f8c7f42a-745e-452d-bbbc-79e65acd0260	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
9c49f4aa-89d8-4eb0-bed6-50ede0bf16a6	M/S	BLAHHHHHHHHH	A-802, x Resisdency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
82ddbda6-6c67-4314-8a15-a119b77d1036	M/S	BLAHHHHHHHHH	A-802, x Resisdency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
c7661fff-226d-4e4b-83f8-789dd04f8d47	M/S	BLAHHHHHHHHH	A-802, x Resisdency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
35ab902f-2b40-4aa2-8809-3fb3a70132e4	Mr.	Yashvi 	Flat No: 1010, City Crown	Flat NCity Crown	+919474808167	+919474808167
2eced1f4-498e-4ee2-9b5a-578b1c745718	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City	+919474808167	+919474808167
c2a6ee3d-5e72-477c-803e-410d46040cc9	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City	+919474808167	+919474808167
c60beb46-dff1-4509-8699-4c037d1a0013	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City	+919474808167	+919474808167
9c25c40c-61f8-4684-8d05-a84aca08863a	Mrs.	b	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
4d2a374b-1fe6-4da6-b722-dbe29366a320	Mr.	blah blah blah	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
d7039799-2d9a-478e-8458-f14d2cf46b46	Mrs.	b	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
461f6263-4064-41c2-a0fe-42551ba8d4e3	Mr.	Yashvi 	Flat No: 1010, City Crown	Flat NCity Crown	+919474808167	+919474808167
7d948232-726e-4979-9642-f8bb294366bb	Mrs.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	999
bef104e8-9ef5-40ec-a4a1-3c6676179430	Mr.	Yashvi 	Flat No: 1010, City Crown	Flat NCity Crown	+919474808167	+919474808167
df6cbe26-337d-427b-b8dc-1ec7e6cf1322	Mr.	blah blah blah	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
1006fb7c-fdfd-4e12-85a6-ab270cda9f18	Mr.	Yashvi Sandeep Agrawal	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency,hjcjjfyhfjfy vesu	+919374808167	+919374808167
e09e5682-6470-4d20-9691-280935a912e1	Mr.	Yashvi 	Flat No: 1010, City Crown	Flat NCity Crown	+919474808167	+919474808167
48e1eb7f-42d8-4540-94c0-bf731e700c16	Mr.	blah blah blah	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
7892ff5c-3c81-4b83-9321-0f3facf0a6b6	Mrs.	Yashvi Agrawal	Flat No: 1010, City Crown	Nr. Karve Statue, Kothrud	+919474808167	+919474808167
80502609-1217-4c96-9360-cc8e4ed9cd4f	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Nr. Karve Statue, Kothrud	+919474808167	+919474808167
14902055-0378-4fc8-aa6d-9ee0a70ad702	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Nr. Karve Statue, Kothrud	+919474808167	+919474808167
669a26f5-7909-4b42-a05f-c4f848971c74	Mr.	Yashvi Sandeep Agrawal	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
b237c906-8f37-43be-8b19-da78084f2577	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Nr. Karve Statue, Kothrud	+919474808167	+919474808167
b5e0b86d-0422-41e0-8619-30ae0fd1af82	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Nr. Karve Statue, Kothrud	+919474808167	+919474808167
f7dda313-9ed9-4cbf-9fc2-1a685ad2de4f	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City	+919474808167	+919474808167
4964d6d7-2eaf-4211-9932-9c50c5f137e6	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City	+919474808167	+919474808167
6b025d83-0cbc-46c6-8aef-ed96b4adca9e	Mrs.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
b9a0eea3-31d7-4f9f-bc33-c10181664c98	Mr.	Yashvi 	Flat No: 1010, City Crown	Flat NCity Crown	+919474808167	+919474808167
37a26ac0-bfb8-4bb3-901d-2abb8c682de9	Mrs.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	999
cc7ce56d-af3c-43d7-a873-6e492f0ff177	Mrs.	b	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
20ec53ec-6dde-439d-89e1-c5b81d9648a9	Mr.	Yashvi Sandeep Agrawal	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
01a12eab-76a1-4835-8a50-a22797e2f419	Mrs.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	999
ee48612b-da13-4bc8-96e3-6330bf8807d6	Mrs.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	999
7d46f937-8409-4160-b993-ccabdb8429a4	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Flat No: 1010, City	+919474808167	+919474808167
af9cbabf-f130-44d5-88fd-15df549dd43f	Mr.	Yashvi Sandeep Agrawal	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
74b3e83c-9b4f-460b-b3bf-139640605cd1	Mrs.	Yashvi Agrawal	Flat No: 1010, City Crown	Nr. Karve Statue, Kothrud	+919474808167	+919474808167
1619f1d4-94d0-4794-84ca-c04bf30f50e4	M/S	BLAHHHHHHHHH	A-802, x Resisdency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
11ebdc4f-0dba-4032-922c-2615a05bd36a	M/S	BLAHHHHHHHHH	A-802, x Resisdency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
c8025fb9-b992-4279-a6aa-653d4adbfb6a	M/S	BLAHHHHHHHHH	A-802, x Resisdency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
371dbbaf-5a9a-4129-95b8-288edd56c044	Mr.	Yashvi 	Flat No: 1010, City Crown	Flat NCity Crown	+919474808167	+919474808167
942e5586-3c6c-4d03-937d-88ba75d495b8	M/S	BLAHHHHHHHHH	A-802, x Resisdency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
1b00c953-0800-44eb-8846-e16f5147b7da	Mr.	blah blah blah	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
224045c5-dfda-4c69-bf09-1b346094fce2	Mr.	Yashvi 	Flat No: 1010, City Crown	Flat NCity Crown	9474808167	9474808167
6c37a84d-557e-450d-bdf4-4778e332ce65	Mr.	Yashvi 	Flat No: 1010, City Crown	Flat NCity Crown	9474808167	9474808167
00516b8a-8ffb-4df3-9450-a7380f142c80	Mr.	Yashvi 	Flat No: 1010, City Crown	Flat NCity Crown	+919474808167	+919474808167
02d7437d-b311-4161-b58e-3bfb293abdd5	Mr.	blah blah blah	Flat No: 1010, City Crown	Flat No: 1010, City Crown	+919474808167	+919474808167
81e2b516-c1d1-4b9c-900f-57bdfef029a6	Mr.	Yashvi 	Flat No: 1010, City Crown	Flat NCity Crown	9090887658	9090887658
16120750-d29f-43a4-8bfe-1e8c259832d0	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Nr. Karve Statue, Kothrud	+919474808167	+919474808167
fbb830ce-17d6-40fa-8198-23634fac4d82	Mr.	Yashvi 	Flat No: 1010, City Crown	Flat NCity Crown	+919090887658	+919090887658
3fbdaca0-960d-428e-9406-43beb7094aee	Mr.	Yashvi Sandeep Agrawal	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
78523faa-be19-4b67-a261-26f8fdb15ae5	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Nr. Karve Statue, Kothrud	+919474808167	+919474808167
5d3c65fc-86b7-4d26-a00b-1103153932d6	Mr.	Yashvi Sandeep Agrawal	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
233d458b-36ed-4683-bab7-24140324a40d	Mr.	Yashvi Sandeep Agrawal	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency,hjcjjfyhfjfy vesu	+919374808167	+919374808167
4367f67d-1a5f-41fd-9fcd-7e8b00a182b9	Mr.	Yashvi 	Flat No: 1010, City Crown	Flat NCity Crown	+919474808167	+919474808167
f207cb4c-0bcb-403f-96d7-3befe251b5c1	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Nr. Karve Statue, Kothrud	+919474808167	+919474808167
1c94890d-5dc5-40c7-86f3-9c2168b04056	Mr.	Yashvi Sandeep Agrawal	A-802, Shobhan Residency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
fd0b72d5-3e7b-44d5-b45b-d34f4a53aa60	Mr.	Yashvi 	Flat No: 1010, City Crown	Flat NCity Crown	+919090887658	+919090887658
067b2b64-18f1-4dd4-9533-6cccadd53c97	Mr.	Yashvi 	Flat No: 1010, City Crown	Flat NCity Crown	+919474808167	+919474808167
88cf0f8d-0c7c-4fb7-8d3c-1e3e448e83fa	Mr.	Yashvi 	Flat No: 1010, City Crown	Flat NCity Crown	+919090887658	+919090887658
38376791-328a-4c3f-a05b-4a52065241ff	Mr.	Yashvi 	Flat No: 1010, City Crown	Flat NCity Crown	+919474808167	+919474808167
184caaba-502f-481e-9264-0b08524e9ad4	Mr.	Yashvi Agrawal	Flat No: 1010, City Crown	Nr. Karve Statue, Kothrud	+919474808167	+919474808167
6514ca7a-1f54-49bd-a676-35b921e22e13	Mr.	Yashvi 	Flat No: 1010, City Crown	Flat NCity Crown	+919090887658	+919090887658
e4fcc021-cac2-451c-a337-34cf14d1dac8	Mr.	Yashvi 	Flat No: 1010, City Crown	Flat NCity Crown	+919090887658	+919090887658
9106e0f2-6a52-419b-a149-2a3803cbbf40	M/S	BLAHHHHHHHHH	A-802, x Resisdency, vesu	A-802, Shobhan Residency, vesu	+919374808167	+919374808167
\.


--
-- TOC entry 4944 (class 0 OID 33512)
-- Dependencies: 232
-- Data for Name: final_quotation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.final_quotation (quotation_id, customer_id, card_ids, margin_ids, date_created, date_modified) FROM stdin;
20250204_003	9625badc-4214-4cb2-bbb9-ae024d8a200a	{fbdc282e-100e-46b0-81b1-d7ffc79290c5,8564c1fb-c107-4d5a-aedb-fc2267e96f03}	{edf119ab-104a-423f-af47-46075275abed,d7fb4ad5-39f2-467d-8112-4267f98af8cf}	2025-02-04 23:06:44.63126	2025-02-04 23:06:44.63126
20250204_004	e12c06fd-b8b5-42b7-ba11-11b87e19bbdf	{1cf31cec-8729-4708-bc90-5eba605012c1}	{edf119ab-104a-423f-af47-46075275abed}	2025-02-04 23:46:59.183669	2025-02-04 23:46:59.183669
20250205_001	073fc8e4-40ae-438a-a0a7-bdec8a892ea1	{42111d5f-e416-490e-83fe-ccef549cbf6a}	{edf119ab-104a-423f-af47-46075275abed}	2025-02-05 21:05:11.041771	2025-02-05 21:05:11.041771
20250208_001	ce685a86-4206-4c8c-bf08-896bc8d19f0c	{339239e3-2af4-4707-af2a-9a02c4c32fc1}	{edf119ab-104a-423f-af47-46075275abed}	2025-02-08 15:37:02.80793	2025-02-08 15:37:02.80793
20250208_005	92d80c58-8a88-445c-a497-6a273ca4e955	{3a839133-dd0e-4ef0-b604-34c9ab657094}	{edf119ab-104a-423f-af47-46075275abed}	2025-02-08 16:12:04.782033	2025-02-08 16:12:04.782033
20250208_011	7022dbe9-ff39-41fd-b7ed-656230908389	{3a839133-dd0e-4ef0-b604-34c9ab657094}	{edf119ab-104a-423f-af47-46075275abed}	2025-02-09 16:06:28.851815	2025-02-09 16:06:28.851815
20250209_001	c952f14a-153b-4026-a968-ac4533c582f1	{f02471c8-3944-4730-aa30-4865d58e77e2}	{76778560-92c0-4eb2-b078-71c1e8488afa}	2025-02-09 17:14:35.230958	2025-02-09 17:14:35.230958
20250209_002	82582a1e-2da7-4720-9b3a-2f4886d3002b	{82101bfa-84a8-4a43-b5c8-7029ef85c72f}	{0c360b42-e6fa-4b38-a096-573e86b6e7c2}	2025-02-09 17:57:05.295381	2025-02-09 17:57:05.295381
20250215_001	644f452e-4520-4346-ad87-91b3f7a370d4	{38090344-d215-4c9d-9cfe-96fee5fdf2d5}	{edf119ab-104a-423f-af47-46075275abed}	2025-02-15 15:01:43.241827	2025-02-15 15:01:43.241827
20250215_002	cf0a8c6f-b2ef-401e-9e61-a6fbef894323	{b1c7be4a-1a60-4329-b341-8e243f6321b7}	{edf119ab-104a-423f-af47-46075275abed}	2025-02-15 18:24:52.89949	2025-02-15 18:24:52.89949
20250215_003	81ded308-7d39-4ae8-a00f-09e58e59f132	{a11fa07a-babc-443c-8a46-435769facb33}	{edf119ab-104a-423f-af47-46075275abed}	2025-02-15 18:37:10.119769	2025-02-15 18:37:10.119769
20250215_005	07848f75-556b-4461-8bde-b28459398f5b	{9e86810e-2ab5-4eab-9c9b-77fa74b8527b}	{edf119ab-104a-423f-af47-46075275abed}	2025-02-15 18:41:06.314287	2025-02-15 18:41:06.314287
20250216_001	50ef0552-723d-429c-bbc4-498e82a9a429	{348834cc-11ff-4b6e-99c8-b214499bf13a,2cdbe9d0-cb0e-4bbb-9b17-33c1d7ac23b3}	{7ea1fa1a-4875-4a71-8c63-52880700a71d,8090e3ba-adae-4902-9aa5-71580c33f66f}	2025-02-16 16:13:39.230615	2025-02-16 16:13:39.230615
20250216_002	e4f9af0d-b1c1-4143-9a5b-eb75e574ace2	{7d534ec5-66c2-44d5-b0a2-7fa8c8af9151,fbb594c4-1cbf-490a-a040-de474f251e35}	{edf119ab-104a-423f-af47-46075275abed,7ea1fa1a-4875-4a71-8c63-52880700a71d}	2025-02-16 16:31:03.433283	2025-02-16 16:31:03.433283
20250216_003	6d47358c-2d34-4082-b9cb-af3df0e893f7	{7d534ec5-66c2-44d5-b0a2-7fa8c8af9151,fbb594c4-1cbf-490a-a040-de474f251e35,0c9d3d1b-ad82-4e81-a589-9829c8f0a952}	{edf119ab-104a-423f-af47-46075275abed,7ea1fa1a-4875-4a71-8c63-52880700a71d,d7fb4ad5-39f2-467d-8112-4267f98af8cf}	2025-02-16 16:33:49.962429	2025-02-16 16:33:49.962429
20250216_004	60d22d82-9e83-41c9-9296-3ab06ecc47f3	{c0f47b0f-42f0-4fa0-bfe2-de90e7b9a791,a9b61162-f3e9-4055-baef-0b6fedee9e63}	{8090e3ba-adae-4902-9aa5-71580c33f66f,76778560-92c0-4eb2-b078-71c1e8488afa}	2025-02-16 17:00:32.931707	2025-02-16 17:00:32.931707
20250219_001	ffa8ac50-e052-4f98-a1c2-6d89e04ae3b6	{d8a98b29-0297-4d75-ab74-c66611e442ed,4a4736da-e5ce-468e-8e28-e71be0b764f3}	{edf119ab-104a-423f-af47-46075275abed,76778560-92c0-4eb2-b078-71c1e8488afa}	2025-02-19 10:38:32.54814	2025-02-19 10:38:32.54814
20250219_002	103d532c-b7b9-4377-a586-059f4025bb76	{4529dc4d-8953-4da4-bcef-2ebde4c85c16}	{76778560-92c0-4eb2-b078-71c1e8488afa}	2025-02-19 11:09:09.156774	2025-02-19 11:09:09.156774
20250219_003	9c2fa362-5579-4522-8193-c819e0085271	{3493c476-6b91-4dbe-8c1f-a3fd6ce68c4d,4f7f32b6-b289-4416-befd-b6fb5de74f50}	{76778560-92c0-4eb2-b078-71c1e8488afa,7ea1fa1a-4875-4a71-8c63-52880700a71d}	2025-02-19 19:22:09.262724	2025-02-19 19:22:09.262724
20250219_004	bef9d2d2-bef4-4339-874d-64ebe0c1b586	{f4ee6769-005f-4d07-b991-52a5de8ef866,8b74ee4d-d191-453f-abb9-384095cf08a4}	{76778560-92c0-4eb2-b078-71c1e8488afa,8090e3ba-adae-4902-9aa5-71580c33f66f}	2025-02-19 21:14:00.518107	2025-02-19 21:14:00.518107
20250301_003	9fe5bcd9-5bc2-46bb-8792-94dffd86e26e	{dd386e6f-8f6b-4ec3-97b7-b7c8abb778e9}	{d7fb4ad5-39f2-467d-8112-4267f98af8cf}	2025-03-01 15:34:24.496123	2025-03-01 15:34:24.496123
20250301_20250302_165731	141346d3-bd3a-4ac6-9dd2-604f27ab12d9	{c1a7f2a3-c10b-4e9c-81e6-728ef89dc6f2}	{0fab6614-658c-44f5-a830-77e6e2e3530a}	2025-03-01 16:58:10.768278	2025-03-01 16:58:10.768278
20250301_20250302_165815	f8c7f42a-745e-452d-bbbc-79e65acd0260	{c1a7f2a3-c10b-4e9c-81e6-728ef89dc6f2}	{0fab6614-658c-44f5-a830-77e6e2e3530a}	2025-03-01 16:58:28.866792	2025-03-01 16:58:28.866792
20250301_20250303_231316	9c49f4aa-89d8-4eb0-bed6-50ede0bf16a6	{24e62446-5291-4542-9b2e-e7bf06d85a4a}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-02 02:07:03.318474	2025-03-02 02:07:03.318474
20250302_001_193221	82ddbda6-6c67-4314-8a15-a119b77d1036	{f357a446-9be0-41fe-8aef-7a3c3e6e2dd6}	{d7fb4ad5-39f2-467d-8112-4267f98af8cf}	2025-03-02 19:34:15.889067	2025-03-02 19:34:15.889067
20250302_001_193424	c7661fff-226d-4e4b-83f8-789dd04f8d47	{f357a446-9be0-41fe-8aef-7a3c3e6e2dd6}	{d7fb4ad5-39f2-467d-8112-4267f98af8cf}	2025-03-02 19:34:41.887492	2025-03-02 19:34:41.887492
20250302_002_202017	2eced1f4-498e-4ee2-9b5a-578b1c745718	{f87cf88f-c1db-4baa-b2e0-1b88fd8985cb,881e049d-f114-4025-baab-2e4b6d4e3c2e}	{edf119ab-104a-423f-af47-46075275abed,7ea1fa1a-4875-4a71-8c63-52880700a71d,d7fb4ad5-39f2-467d-8112-4267f98af8cf,0fab6614-658c-44f5-a830-77e6e2e3530a}	2025-03-02 20:38:49.509908	2025-03-02 20:38:49.509908
20250302_002_204206	c2a6ee3d-5e72-477c-803e-410d46040cc9	{f87cf88f-c1db-4baa-b2e0-1b88fd8985cb,881e049d-f114-4025-baab-2e4b6d4e3c2e}	{edf119ab-104a-423f-af47-46075275abed,7ea1fa1a-4875-4a71-8c63-52880700a71d,d7fb4ad5-39f2-467d-8112-4267f98af8cf,0fab6614-658c-44f5-a830-77e6e2e3530a}	2025-03-02 20:42:20.17476	2025-03-02 20:42:20.17476
20250208_002	c60beb46-dff1-4509-8699-4c037d1a0013	{0d4c77c1-afef-406d-b2a1-50088795dca0}	{d7fb4ad5-39f2-467d-8112-4267f98af8cf}	2025-03-12 22:22:55.356724	2025-03-12 22:22:55.356724
20250201_001	4d2a374b-1fe6-4da6-b722-dbe29366a320	{6b150c40-950f-422f-ba14-d3020e86c0ee,8bcb31f3-54f9-43ac-915f-5c99d5666578}	{76778560-92c0-4eb2-b078-71c1e8488afa}	2025-03-12 23:18:01.963726	2025-03-12 23:18:01.963726
20250128_001	d7039799-2d9a-478e-8458-f14d2cf46b46	{3ec42ff0-f573-494c-9482-13d5d2a89fe1}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-12 23:58:00.69058	2025-03-12 23:58:00.69058
20250205_002	461f6263-4064-41c2-a0fe-42551ba8d4e3	{}	{}	2025-03-13 00:00:28.554431	2025-03-13 00:00:28.554431
20250126_001	7d948232-726e-4979-9642-f8bb294366bb	{9e133455-3f1c-4359-bfd9-c56fa9cc45df,f4c5ec07-126d-44e1-9d6e-94f21d96fc79,97602327-abff-4757-aeb1-de856141c8fb}	{7ea1fa1a-4875-4a71-8c63-52880700a71d,d7fb4ad5-39f2-467d-8112-4267f98af8cf,edf119ab-104a-423f-af47-46075275abed}	2025-03-15 19:04:50.653626	2025-03-15 19:04:50.653626
20250124_001	a7df86bb-79cf-4aba-ae3e-478a40280682	{4725b3ce-dd0a-4af0-beb8-4079a6687240,a6de9f62-b42b-4121-b998-2bafab85e48e}	{76778560-92c0-4eb2-b078-71c1e8488afa,edf119ab-104a-423f-af47-46075275abed}	2025-03-15 19:18:05.38794	2025-03-15 19:18:05.38794
20250315_004_190554	7d948232-726e-4979-9642-f8bb294366bb	{9e133455-3f1c-4359-bfd9-c56fa9cc45df,f4c5ec07-126d-44e1-9d6e-94f21d96fc79,97602327-abff-4757-aeb1-de856141c8fb}	{7ea1fa1a-4875-4a71-8c63-52880700a71d,d7fb4ad5-39f2-467d-8112-4267f98af8cf,edf119ab-104a-423f-af47-46075275abed}	2025-03-15 19:09:58.631606	2025-03-15 19:09:58.631606
20250302_001_193718	35ab902f-2b40-4aa2-8809-3fb3a70132e4	{f357a446-9be0-41fe-8aef-7a3c3e6e2dd6}	{d7fb4ad5-39f2-467d-8112-4267f98af8cf}	2025-03-15 19:19:43.497243	2025-03-15 19:19:43.497243
20250310_001_012217	cf0a8c6f-b2ef-401e-9e61-a6fbef894323	{b1c7be4a-1a60-4329-b341-8e243f6321b7}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-15 19:36:20.214688	2025-03-15 19:36:20.214688
20250315_001_131708	bef104e8-9ef5-40ec-a4a1-3c6676179430	{bc93d81b-a458-4a97-b698-b42358ef52e1}	{}	2025-03-15 19:31:47.099306	2025-03-15 19:31:47.099306
20250315_004_193806	df6cbe26-337d-427b-b8dc-1ec7e6cf1322	{570f6b64-80f9-443a-8437-ed082603cdb9}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-15 19:38:43.252657	2025-03-15 19:38:43.252657
20250315_004_193859	1006fb7c-fdfd-4e12-85a6-ab270cda9f18	{4fbb04bd-9b38-4416-ab2d-29ec2cdbb141}	{d7fb4ad5-39f2-467d-8112-4267f98af8cf}	2025-03-15 19:39:40.620279	2025-03-15 19:39:40.620279
20250315_004_201941	e09e5682-6470-4d20-9691-280935a912e1	{283a8b80-6dca-4165-aaff-fc095757abb3}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-15 20:20:28.215186	2025-03-15 20:20:28.215186
20250315_004_202317	48e1eb7f-42d8-4540-94c0-bf731e700c16	{a7d34c2f-797c-4c12-b1c5-e22e1f0c2e05,911934af-b0f5-4c35-8a75-dc6bbcfec420}	{76778560-92c0-4eb2-b078-71c1e8488afa}	2025-03-15 20:24:12.492484	2025-03-15 20:24:12.492484
20250315_004_223415	7892ff5c-3c81-4b83-9321-0f3facf0a6b6	{a3166e29-2c75-47c6-b424-147a2b0058d2}	{d7fb4ad5-39f2-467d-8112-4267f98af8cf}	2025-03-15 22:35:00.758638	2025-03-15 22:35:00.758638
20250315_004_223935	80502609-1217-4c96-9360-cc8e4ed9cd4f	{68b9ce26-de99-4b5c-a464-5ba898012456}	{76778560-92c0-4eb2-b078-71c1e8488afa}	2025-03-15 22:40:26.76161	2025-03-15 22:40:26.76161
20250315_004_224138	14902055-0378-4fc8-aa6d-9ee0a70ad702	{bd9b38a0-0485-4d3b-b523-4bee7895dd58}	{d7fb4ad5-39f2-467d-8112-4267f98af8cf}	2025-03-15 22:42:21.925162	2025-03-15 22:42:21.925162
20250315_004_224535	669a26f5-7909-4b42-a05f-c4f848971c74	{ddedf7f7-9534-4730-91bc-266ab745e257}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-15 22:46:15.666815	2025-03-15 22:46:15.666815
20250315_004_225706	b237c906-8f37-43be-8b19-da78084f2577	{5a35400c-680f-467b-9ebe-837b7c48499d}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-15 22:57:53.246841	2025-03-15 22:57:53.246841
20250315_004_232136	b5e0b86d-0422-41e0-8619-30ae0fd1af82	{071bd512-4430-402e-9958-1775c88ab0a7}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-15 23:22:16.601268	2025-03-15 23:22:16.601268
20250315_004_235602	f7dda313-9ed9-4cbf-9fc2-1a685ad2de4f	{d063fa35-fd10-4b6c-81fd-fbb88b4966d1}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-15 23:56:55.898896	2025-03-15 23:56:55.898896
20250316_001_011218	4964d6d7-2eaf-4211-9932-9c50c5f137e6	{f7ad59cf-2d79-4e01-af2d-a98d5c9442b4}	{7ea1fa1a-4875-4a71-8c63-52880700a71d}	2025-03-16 01:13:04.225524	2025-03-16 01:13:04.225524
20250316_001_121403	6b025d83-0cbc-46c6-8aef-ed96b4adca9e	{3ff6a268-76ec-4d73-9c42-4919e0801afc}	{d7fb4ad5-39f2-467d-8112-4267f98af8cf}	2025-03-16 12:18:46.356608	2025-03-16 12:18:46.356608
20250316_001_124508	b9a0eea3-31d7-4f9f-bc33-c10181664c98	{85ca0fdd-e248-45d1-bdbe-0329100db270}	{0fab6614-658c-44f5-a830-77e6e2e3530a}	2025-03-16 12:45:51.787429	2025-03-16 12:45:51.787429
20250316_001_125450	37a26ac0-bfb8-4bb3-901d-2abb8c682de9	{210d6f8e-8774-4ade-bd2d-a0a9f47291bd}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-16 12:55:30.894881	2025-03-16 12:55:30.894881
20250316_001_130343	cc7ce56d-af3c-43d7-a873-6e492f0ff177	{88600f86-284e-4660-92c0-08183c98f730}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-16 13:05:06.735492	2025-03-16 13:05:06.735492
20250316_001_131810	20ec53ec-6dde-439d-89e1-c5b81d9648a9	{8ec55a9b-1181-4d4b-93eb-198a7f413489}	{d7fb4ad5-39f2-467d-8112-4267f98af8cf}	2025-03-16 13:18:52.401054	2025-03-16 13:18:52.401054
20250316_001_132038	01a12eab-76a1-4835-8a50-a22797e2f419	{aeaa2fa1-d456-4b25-b3c9-58ced6d3d07d}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-16 13:21:13.900712	2025-03-16 13:21:13.900712
20250316_001_132424	ee48612b-da13-4bc8-96e3-6330bf8807d6	{42b10f29-7719-4c27-a66a-460bd8788a69}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-16 13:25:01.092132	2025-03-16 13:25:01.092132
20250316_001_132959	7d46f937-8409-4160-b993-ccabdb8429a4	{93c2132e-bb1a-4319-b26e-5ad63e718a9a}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-16 13:30:51.989973	2025-03-16 13:30:51.989973
20250316_001_133330	af9cbabf-f130-44d5-88fd-15df549dd43f	{db608008-626d-4052-b269-3ced63587b44}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-16 13:34:05.993147	2025-03-16 13:34:05.993147
20250316_002_162330	1619f1d4-94d0-4794-84ca-c04bf30f50e4	{036352a4-1181-406b-ade1-5d00f8c3ac97,cc477e9c-21db-4e8a-98d3-3bffa06fee65}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-16 16:30:02.277781	2025-03-16 16:30:02.277781
20250316_002_174135	11ebdc4f-0dba-4032-922c-2615a05bd36a	{94ab3895-3ca1-471d-a5ef-50a8184e5cc5}	{d7fb4ad5-39f2-467d-8112-4267f98af8cf}	2025-03-16 17:42:29.814292	2025-03-16 17:42:29.814292
20250316_002_184345	c8025fb9-b992-4279-a6aa-653d4adbfb6a	{6cd729e6-a4ab-4d3c-8c4e-41cb631d33af,78c38d5b-4900-403a-a486-1e621a992fac,c8bf1589-0831-4bdb-871d-cf771920cbfd}	{0fab6614-658c-44f5-a830-77e6e2e3530a,d7fb4ad5-39f2-467d-8112-4267f98af8cf,edf119ab-104a-423f-af47-46075275abed}	2025-03-16 18:50:38.741048	2025-03-16 18:50:38.741048
20250316_002_185417	371dbbaf-5a9a-4129-95b8-288edd56c044	{ca253faa-9bbd-483a-a696-c6078bed108a}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-16 18:54:42.655694	2025-03-16 18:54:42.655694
20250318_001_210036	942e5586-3c6c-4d03-937d-88ba75d495b8	{b45e8baf-fa5f-422b-943a-915735280a48}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-18 21:01:11.116025	2025-03-18 21:01:11.116025
20250318_001_210505	1b00c953-0800-44eb-8846-e16f5147b7da	{b84bbbfe-78d8-42bb-a624-d4b0337ef524}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-18 21:05:36.791326	2025-03-18 21:05:36.791326
20250318_001_222208	224045c5-dfda-4c69-bf09-1b346094fce2	{d6ecb498-0e9c-4928-844a-f8d67ec3e251,57ca3c93-5f7b-4704-8d9b-decef2a12a0d}	{7ea1fa1a-4875-4a71-8c63-52880700a71d,d7fb4ad5-39f2-467d-8112-4267f98af8cf,0fab6614-658c-44f5-a830-77e6e2e3530a}	2025-03-18 22:43:36.245504	2025-03-18 22:43:36.245504
20250318_001_225701	6c37a84d-557e-450d-bdf4-4778e332ce65	{f28166c7-ac4e-4cf4-85df-9bbf9d5f4119}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-18 22:58:10.458711	2025-03-18 22:58:10.458711
20250318_001_230107	00516b8a-8ffb-4df3-9450-a7380f142c80	{61c913a4-4121-43da-9758-a27f4b3449de}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-18 23:01:44.772322	2025-03-18 23:01:44.772322
20250320_001_143703	02d7437d-b311-4161-b58e-3bfb293abdd5	{64ea7afc-3128-4f7e-93fd-74a80fdfccbd}	{d7fb4ad5-39f2-467d-8112-4267f98af8cf}	2025-03-20 14:39:11.829206	2025-03-20 14:39:11.829206
20250323_004_171926	16120750-d29f-43a4-8bfe-1e8c259832d0	{48b411f7-0962-4862-b836-bfeb08194101,97c47a34-fed6-43d7-bc35-d2682167e95a,1f2f7971-1b2f-4511-b33d-f3e6b5610831}	{edf119ab-104a-423f-af47-46075275abed,d7fb4ad5-39f2-467d-8112-4267f98af8cf}	2025-03-23 17:41:28.247111	2025-03-23 17:41:28.247111
20250323_004_175253	fbb830ce-17d6-40fa-8198-23634fac4d82	{59082e8d-90a4-4248-aae7-1e2e46c916db}	{d7fb4ad5-39f2-467d-8112-4267f98af8cf}	2025-03-23 17:54:55.722689	2025-03-23 17:54:55.722689
20250324_001_202223	3fbdaca0-960d-428e-9406-43beb7094aee	{faa72ea2-bf55-4347-99d8-7a7e67618f65,a1977771-26b8-4c5d-9930-4c0e2cdd6f52}	{8090e3ba-adae-4902-9aa5-71580c33f66f,edf119ab-104a-423f-af47-46075275abed}	2025-03-24 20:33:52.142922	2025-03-24 20:33:52.142922
20250324_001_203443	78523faa-be19-4b67-a261-26f8fdb15ae5	{ebd2dcfa-432c-4b21-a3fb-8d425d90e48b,f7f4173c-f27e-428a-91b0-ccc497b31285}	{8090e3ba-adae-4902-9aa5-71580c33f66f,edf119ab-104a-423f-af47-46075275abed}	2025-03-24 20:35:47.47114	2025-03-24 20:35:47.47114
20250326_003_182101	4367f67d-1a5f-41fd-9fcd-7e8b00a182b9	{45f3fe89-6f05-4381-b27a-2bfbc3153db3,38ea00bc-0a8c-4c4d-915d-8b647ff14bd0}	{edf119ab-104a-423f-af47-46075275abed,7ea1fa1a-4875-4a71-8c63-52880700a71d}	2025-03-26 18:21:58.502714	2025-03-26 18:21:58.502714
20250327_001_233949	f207cb4c-0bcb-403f-96d7-3befe251b5c1	{ffafd138-3e1d-47ba-b988-c7db1ce9a701}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-27 23:41:10.55233	2025-03-27 23:41:10.55233
20250301_20250302_215958	f8c7f42a-745e-452d-bbbc-79e65acd0260	{c1a7f2a3-c10b-4e9c-81e6-728ef89dc6f2}	{0fab6614-658c-44f5-a830-77e6e2e3530a}	2025-03-28 10:15:24.876259	2025-03-28 10:15:24.876259
20250331_002_104108	1c94890d-5dc5-40c7-86f3-9c2168b04056	{3777fd29-160a-47fe-984e-c83bf527c8bd}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-31 10:42:37.497818	2025-03-31 10:42:37.497818
20250331_005_121042	fd0b72d5-3e7b-44d5-b45b-d34f4a53aa60	{16b25e66-76cc-4701-ba8b-fecc3436bf70}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-31 12:11:18.272899	2025-03-31 12:11:18.272899
20250302_002_204423	c2a6ee3d-5e72-477c-803e-410d46040cc9	{f87cf88f-c1db-4baa-b2e0-1b88fd8985cb,881e049d-f114-4025-baab-2e4b6d4e3c2e}	{0fab6614-658c-44f5-a830-77e6e2e3530a,d7fb4ad5-39f2-467d-8112-4267f98af8cf,7ea1fa1a-4875-4a71-8c63-52880700a71d,edf119ab-104a-423f-af47-46075275abed}	2025-03-31 12:24:39.102932	2025-03-31 12:24:39.102932
20250326_002_180517	233d458b-36ed-4683-bab7-24140324a40d	{ff7942c3-008c-487c-903b-1584447e843e,804d7f1a-4a06-40c2-8965-04219b50572c,0a776bc3-9097-4139-b47b-160d07515c3b,7a4ab52a-e780-4ec0-a934-f1dd204147b6}	{edf119ab-104a-423f-af47-46075275abed,8090e3ba-adae-4902-9aa5-71580c33f66f}	2025-03-31 12:26:51.861294	2025-03-31 12:26:51.861294
20250331_011_123027	067b2b64-18f1-4dd4-9533-6cccadd53c97	{67224775-5e86-4e19-9d46-42822e57dece}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-31 12:30:56.457269	2025-03-31 12:30:56.457269
20250331_012_123153	88cf0f8d-0c7c-4fb7-8d3c-1e3e448e83fa	{dfdc69f6-3725-46e1-8931-fd0cfef29391}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-31 12:32:24.812497	2025-03-31 12:32:24.812497
20250331_013_123618	38376791-328a-4c3f-a05b-4a52065241ff	{b65a9899-b24b-455e-90ec-749d9b2da77f}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-31 12:36:50.922598	2025-03-31 12:36:50.922598
20250331_013_123658	38376791-328a-4c3f-a05b-4a52065241ff	{b65a9899-b24b-455e-90ec-749d9b2da77f,04c6ffdd-6809-41ea-8d6a-a54cd7419434}	{edf119ab-104a-423f-af47-46075275abed,d7fb4ad5-39f2-467d-8112-4267f98af8cf}	2025-03-31 12:37:24.943706	2025-03-31 12:37:24.943706
20250331_013_123730	38376791-328a-4c3f-a05b-4a52065241ff	{b65a9899-b24b-455e-90ec-749d9b2da77f,04c6ffdd-6809-41ea-8d6a-a54cd7419434}	{edf119ab-104a-423f-af47-46075275abed,d7fb4ad5-39f2-467d-8112-4267f98af8cf}	2025-03-31 12:37:34.495304	2025-03-31 12:37:34.495304
20250331_013_123754	38376791-328a-4c3f-a05b-4a52065241ff	{b65a9899-b24b-455e-90ec-749d9b2da77f,04c6ffdd-6809-41ea-8d6a-a54cd7419434}	{edf119ab-104a-423f-af47-46075275abed,d7fb4ad5-39f2-467d-8112-4267f98af8cf}	2025-03-31 12:37:59.882997	2025-03-31 12:37:59.882997
20250331_013_125835	38376791-328a-4c3f-a05b-4a52065241ff	{04c6ffdd-6809-41ea-8d6a-a54cd7419434,b65a9899-b24b-455e-90ec-749d9b2da77f}	{d7fb4ad5-39f2-467d-8112-4267f98af8cf,edf119ab-104a-423f-af47-46075275abed}	2025-03-31 12:58:41.008937	2025-03-31 12:58:41.008937
20250331_014_130720	6d47358c-2d34-4082-b9cb-af3df0e893f7	{0c9d3d1b-ad82-4e81-a589-9829c8f0a952,7d534ec5-66c2-44d5-b0a2-7fa8c8af9151,fbb594c4-1cbf-490a-a040-de474f251e35}	{7ea1fa1a-4875-4a71-8c63-52880700a71d,d7fb4ad5-39f2-467d-8112-4267f98af8cf,edf119ab-104a-423f-af47-46075275abed}	2025-03-31 13:08:59.083828	2025-03-31 13:08:59.083828
20250331_014_131237	6d47358c-2d34-4082-b9cb-af3df0e893f7	{7d534ec5-66c2-44d5-b0a2-7fa8c8af9151,fbb594c4-1cbf-490a-a040-de474f251e35,0c9d3d1b-ad82-4e81-a589-9829c8f0a952}	{7ea1fa1a-4875-4a71-8c63-52880700a71d,edf119ab-104a-423f-af47-46075275abed,d7fb4ad5-39f2-467d-8112-4267f98af8cf}	2025-03-31 13:12:42.813473	2025-03-31 13:12:42.813473
20250331_014_135454	6d47358c-2d34-4082-b9cb-af3df0e893f7	{7d534ec5-66c2-44d5-b0a2-7fa8c8af9151,fbb594c4-1cbf-490a-a040-de474f251e35,0c9d3d1b-ad82-4e81-a589-9829c8f0a952}	{7ea1fa1a-4875-4a71-8c63-52880700a71d,edf119ab-104a-423f-af47-46075275abed,d7fb4ad5-39f2-467d-8112-4267f98af8cf}	2025-03-31 13:55:00.462345	2025-03-31 13:55:00.462345
20250331_014_143027	184caaba-502f-481e-9264-0b08524e9ad4	{a8636a65-8fbb-4d0b-a4fa-ba2a69f05f96}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-31 14:31:06.560993	2025-03-31 14:31:06.560993
20250331_014_143123	184caaba-502f-481e-9264-0b08524e9ad4	{a8636a65-8fbb-4d0b-a4fa-ba2a69f05f96}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-31 14:31:28.088344	2025-03-31 14:31:28.088344
20250331_014_153117	38376791-328a-4c3f-a05b-4a52065241ff	{b65a9899-b24b-455e-90ec-749d9b2da77f,04c6ffdd-6809-41ea-8d6a-a54cd7419434}	{d7fb4ad5-39f2-467d-8112-4267f98af8cf,edf119ab-104a-423f-af47-46075275abed}	2025-03-31 15:32:00.296377	2025-03-31 15:32:00.296377
20250331_014_153211	38376791-328a-4c3f-a05b-4a52065241ff	{b65a9899-b24b-455e-90ec-749d9b2da77f,04c6ffdd-6809-41ea-8d6a-a54cd7419434}	{d7fb4ad5-39f2-467d-8112-4267f98af8cf,edf119ab-104a-423f-af47-46075275abed}	2025-03-31 15:32:17.680817	2025-03-31 15:32:17.680817
20250331_014_153223	38376791-328a-4c3f-a05b-4a52065241ff	{b65a9899-b24b-455e-90ec-749d9b2da77f,04c6ffdd-6809-41ea-8d6a-a54cd7419434}	{d7fb4ad5-39f2-467d-8112-4267f98af8cf,edf119ab-104a-423f-af47-46075275abed}	2025-03-31 15:32:27.682568	2025-03-31 15:32:27.682568
20250331_014_153651	38376791-328a-4c3f-a05b-4a52065241ff	{04c6ffdd-6809-41ea-8d6a-a54cd7419434,b65a9899-b24b-455e-90ec-749d9b2da77f}	{d7fb4ad5-39f2-467d-8112-4267f98af8cf,edf119ab-104a-423f-af47-46075275abed}	2025-03-31 15:37:00.158141	2025-03-31 15:37:00.158141
20250331_014_153706	38376791-328a-4c3f-a05b-4a52065241ff	{04c6ffdd-6809-41ea-8d6a-a54cd7419434,b65a9899-b24b-455e-90ec-749d9b2da77f}	{d7fb4ad5-39f2-467d-8112-4267f98af8cf,edf119ab-104a-423f-af47-46075275abed}	2025-03-31 15:37:13.683531	2025-03-31 15:37:13.683531
20250331_014_153727	6514ca7a-1f54-49bd-a676-35b921e22e13	{91cbebd1-909c-4de4-8fc2-e5d1787cd0dc}	{8090e3ba-adae-4902-9aa5-71580c33f66f}	2025-03-31 15:40:16.17339	2025-03-31 15:40:16.17339
20250331_014_154023	6514ca7a-1f54-49bd-a676-35b921e22e13	{91cbebd1-909c-4de4-8fc2-e5d1787cd0dc}	{8090e3ba-adae-4902-9aa5-71580c33f66f}	2025-03-31 15:40:27.269313	2025-03-31 15:40:27.269313
20250331_015_160932	7d46f937-8409-4160-b993-ccabdb8429a4	{93c2132e-bb1a-4319-b26e-5ad63e718a9a}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-31 16:09:37.956455	2025-03-31 16:09:37.956455
20250331_016_161600	7d46f937-8409-4160-b993-ccabdb8429a4	{93c2132e-bb1a-4319-b26e-5ad63e718a9a}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-31 16:16:05.686537	2025-03-31 16:16:05.686537
20250331_016_161622	7d46f937-8409-4160-b993-ccabdb8429a4	{93c2132e-bb1a-4319-b26e-5ad63e718a9a}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-31 16:16:28.140637	2025-03-31 16:16:28.140637
20250331_016_161811	7d46f937-8409-4160-b993-ccabdb8429a4	{93c2132e-bb1a-4319-b26e-5ad63e718a9a}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-31 16:18:22.468861	2025-03-31 16:18:22.468861
20250331_016_161942	7d46f937-8409-4160-b993-ccabdb8429a4	{93c2132e-bb1a-4319-b26e-5ad63e718a9a}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-31 16:19:50.822335	2025-03-31 16:19:50.822335
20250331_016_162004	7d46f937-8409-4160-b993-ccabdb8429a4	{93c2132e-bb1a-4319-b26e-5ad63e718a9a}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-31 16:20:38.207479	2025-03-31 16:20:38.207479
20250331_016_162048	7d46f937-8409-4160-b993-ccabdb8429a4	{93c2132e-bb1a-4319-b26e-5ad63e718a9a}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-31 16:20:53.365475	2025-03-31 16:20:53.366396
20250331_016_163717	38376791-328a-4c3f-a05b-4a52065241ff	{b65a9899-b24b-455e-90ec-749d9b2da77f,04c6ffdd-6809-41ea-8d6a-a54cd7419434,639cbb48-4559-42f0-9c6c-576e1e82b594}	{d7fb4ad5-39f2-467d-8112-4267f98af8cf,edf119ab-104a-423f-af47-46075275abed}	2025-03-31 16:37:42.542056	2025-03-31 16:37:42.542056
20250331_017_190853	e4fcc021-cac2-451c-a337-34cf14d1dac8	{28e3dba4-28eb-4b17-962d-93a71a9f846c}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-31 19:09:27.624074	2025-03-31 19:09:27.624074
20250416_001_174402	9106e0f2-6a52-419b-a149-2a3803cbbf40	{b04c9b48-2e25-47bc-8453-660b2dd210f8}	{7ea1fa1a-4875-4a71-8c63-52880700a71d}	2025-04-16 17:45:06.698507	2025-04-16 17:45:06.698507
\.


--
-- TOC entry 4932 (class 0 OID 24790)
-- Dependencies: 220
-- Data for Name: item_pricing; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item_pricing (id, itemname, discount, netrate, margincategory, discountcategory) FROM stdin;
1	CPVC Pipe 3/4" SDR-13.5 3mtr.	\N	178.00	A	A
2	CPVC Pipe 1" SDR-13.5 3mtr.	\N	256.00	A	B
3	CPVC Pipe 3/4" SDR-11 3mtr.	\N	200.00	A	C
4	CPVC Pipe 1" SDR-11 3mtr.	\N	310.00	A	D
5	CPVC Pipe 1-1/4" SDR-13.5 3mtr.	\N	405.00	B	E
6	CPVC Pipe 1-1/2" SDR-13.5 3mtr.	\N	570.00	B	F
7	CPVC Pipe 2" SDR-13.5 3mtr.	\N	980.00	B	G
8	CPVC Pipe 1-1/4" SDR-11 3mtr.	\N	490.00	B	H
9	CPVC Pipe 1-1/2" SDR-11 3mtr.	\N	670.00	B	I
10	CPVC Pipe 2" SDR-11 3mtr.	\N	1210.00	B	J
11	CPVC Fittings	43.50	\N	C	K
12	CPVC Ball Valve	52.00	\N	C	L
13	CPVC Solvent Cement	30.00	\N	C	M
14	uPVC Pipe	65.50	\N	D	N
15	uPVC Fitting	61.00	\N	E	O
16	uPVC Ball Valve	67.00	\N	E	P
17	uPVC Solvent Cement	30.00	\N	E	Q
18	SWR Pipe Reguler	68.50	\N	F	R
19	PVC/Agri. Pipe	69.50	\N	F	S
20	SWR Pipe 110mm Type A RS 3mtr.	\N	430.00	G	T
21	SWR Pipe 110mm Type A SF 3mtr.	\N	430.00	G	U
22	SWR Pipe 110mm Type A SF 6mtr.	\N	860.00	G	V
23	SWR Pipe 75mm Type A RS 3mtr.	\N	270.00	G	W
24	SWR Pipe 75mm Type A SF 3mtr.	\N	270.00	G	X
25	SWR Pipe 75mm Type A SF 6mtr.	\N	540.00	G	Y
26	SWR Pipe 90mm Type A RS 3mtr.	\N	340.00	G	Z
27	SWR Pipe 90mm Type A SF 3mtr.	\N	340.00	G	AA
28	SWR Pipe 90mm Type A SF 6mtr.	\N	680.00	G	AB
29	SWR Pipe 160mm Type A SF 3mtr.	\N	960.00	G	AC
30	SWR Pipe 160mm Type A SF 6mtr.	\N	1920.00	G	AD
31	UGD (Under Ground Dranage) Pipe	69.00	\N	G	AE
32	SWR Fitting	63.50	\N	H	AF
33	PVC/Agri. Fitting	62.50	\N	H	AG
34	PVC/Agri. Solvent Cement	30.00	\N	H	AH
\.


--
-- TOC entry 4930 (class 0 OID 24772)
-- Dependencies: 218
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.items (item_id, type, size, mrp, article, cat1, cat2, cat3, margin_category, discount_category, mc_name, image_url, created_at, updated_at, type_image_url, temp, gst, make) FROM stdin;
521	UDS	160MM	3255.00	SN-2 Pipe 3mtr	\N	\N	\N	G	AE	UGD / SWR Pipe 75; 90; 110; 160mm	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/uds.png	\N	18.00	kelvin
522	UDS	200MM	4973.00	SN-2 Pipe 3mtr	\N	\N	\N	G	AE	UGD / SWR Pipe 75; 90; 110; 160mm	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/uds.png	\N	18.00	kelvin
531	CPVC	1"	528.00	Pipe	SDR 13.5	\N	\N	A	B	CPVC Pipe 3/4"; 1"	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_2.png	2025-02-22 13:09:46.519131	2025-02-22 13:09:46.519131	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
465	Agri	63MM	1098.00	Pipe 4 kg	Self Fit	6 mtr	\N	F	SWR / Agri Pipe	S	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
466	Agri	40MM	35.60	Elbow 90*	10 kg	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_113.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
467	Agri	50MM	55.20	Elbow 90*	10 kg	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_113.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
1	CPVC	3/4	345.00	pipe	SDR 13.5	\N	\N	A	A	CPVC Pipe 3/4"; 1"	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_1.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
468	Agri	63MM	81.70	Elbow 90*	6 kg	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_115.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
469	Agri	75MM	111.20	Elbow 90*	6 kg	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_115.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
470	Agri	90MM	159.20	Elbow 90*	6 kg	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_115.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
4	CPVC	1-1/2	1134.00	pipe	SDR 13.5	\N	\N	B	F	CPVC Pipe 1-1/4"; 1-1/2"; 2"	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_1.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
5	CPVC	2"	1950.00	Pipe	SDR 13.5	\N	\N	B	G	CPVC Pipe 1-1/4"; 1-1/2"; 2"	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_1.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
6	CPVC	3/4"	387.00	Pipe	SDR 11	\N	\N	A	C	CPVC Pipe 3/4"; 1"	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_2.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
7	CPVC	1"	630.00	Pipe	SDR 11	\N	\N	A	D	CPVC Pipe 3/4"; 1"	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_2.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
8	CPVC	1-1/4"	963.00	Pipe	SDR 11	\N	\N	B	H	CPVC Pipe 1-1/4"; 1-1/2"; 2"	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_2.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
11	CPVC	3/4"x1/2"	18.30	Reducing Coupler	SDR 11	\N	\N	C	K	CPVC Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
483	Agri	63MM	107.70	Tee	6 kg	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_118.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
484	Agri	75MM	147.00	Tee	6 kg	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_118.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
485	Agri	90MM	206.70	Tee	6 kg	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_118.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
369	SWR	4"x3"	334.00	Reducing Tee w Door	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
498	Agri	75x40MM	46.70	Reducing Coupler	\N	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_121.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
499	Agri	75x50MM	51.50	Reducing Coupler	\N	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_121.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
500	Agri	75x63MM	54.50	Reducing Coupler	\N	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_121.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
501	Agri	90x63MM	73.80	Reducing Coupler	\N	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_121.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
502	Agri	90x75MM	78.60	Reducing Coupler	\N	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_121.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
503	Agri	110x50MM	110.60	Reducing Coupler	\N	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_121.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
504	Agri	110x63MM	114.80	Reducing Coupler	\N	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_121.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
505	Agri	110x75MM	122.00	Reducing Coupler	\N	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_121.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
506	Agri	110x90MM	134.60	Reducing Coupler	\N	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_121.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
507	Agri	63x40MM	81.20	Reducing Tee	\N	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_122.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
508	Agri	75x40MM	121.90	Reducing Tee	\N	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_122.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
509	Agri	75x50MM	51.50	Reducing Tee	\N	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_122.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
510	Agri	90x63MM	189.80	Reducing Tee	\N	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_122.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
511	Agri	90x75MM	195.20	Reducing Tee	\N	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_122.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
232	UPVC	2"	117.10	Elbow 45*	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_45.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
233	UPVC	1/2"	16.10	Elbow 90*	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_46.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
234	UPVC	3/4"	23.90	Elbow 90*	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_46.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
235	UPVC	1"	39.30	Elbow 90*	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_46.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
236	UPVC	1-1/4"	64.20	Elbow 90*	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_46.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
237	UPVC	1-1/2"	84.00	Elbow 90*	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_46.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
238	UPVC	2"	132.40	Elbow 90*	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_46.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
239	UPVC	1/2"	8.80	MTA	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_50.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
179	UPVC	1/2"	270.00	Pipe	SCH-40	3 mtr	\N	D	N	UPVC Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_40.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	N	18.00	kelvin
180	UPVC	3/4"	360.00	Pipe	SCH-40	3 mtr	\N	D	N	UPVC Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_40.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	N	18.00	kelvin
181	UPVC	1"	528.00	Pipe	SCH-40	3 mtr	\N	D	N	UPVC Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_40.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	N	18.00	kelvin
182	UPVC	1-1/4"	717.00	Pipe	SCH-40	3 mtr	\N	D	N	UPVC Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_40.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	N	18.00	kelvin
183	UPVC	1-1/2"	855.00	Pipe	SCH-40	3 mtr	\N	D	N	UPVC Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_40.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	N	18.00	kelvin
12	CPVC	1"x1/2"	29.00	Reducing Coupler	SDR 11	\N	\N	C	K	CPVC Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
34	CPVC	3/4"x1/2"	39.20	Reducing Tee	SDR 11	\N	\N	C	K	CPVC Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
184	UPVC	2"	1146.00	Pipe	SCH-40	3 mtr	\N	D	N	UPVC Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_40.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	N	18.00	kelvin
185	UPVC	1/2"	678.00	Pipe	SCH-80	6 mtr	\N	D	N	UPVC Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_39.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	N	18.00	kelvin
186	UPVC	3/4"	924.00	Pipe	SCH-80	6 mtr	\N	D	N	UPVC Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_39.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	N	18.00	kelvin
187	UPVC	1"	1356.00	Pipe	SCH-80	6 mtr	\N	D	N	UPVC Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_39.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	N	18.00	kelvin
188	UPVC	1-1/4"	1872.00	Pipe	SCH-80	6 mtr	\N	D	N	UPVC Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_39.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	N	18.00	kelvin
375	SWR	90MM	190.00	Door Bend	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_82.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
376	SWR	110MM	239.00	Door Bend	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_82.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
377	SWR	160MM	605.00	Door Bend	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_82.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
378	SWR	4"x2-1/2"	113.00	Reducing Coupler	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_83.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
379	SWR	4"x3"	127.00	Reducing Coupler	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_83.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
380	SWR	75MM	55.00	Coupler	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_84.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
381	SWR	90MM	94.00	Coupler	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_84.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
38	CPVC	1-1/4"x1"	114.70	Reducing Tee	SDR 11	\N	\N	C	K	CPVC Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
101	CPVC	2"x1-1/2"	90.40	Reducing Bush	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_13.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
102	CPVC	3/4"	10.60	Transition Bushing	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_14.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
103	CPVC	1"	20.20	Transition Bushing	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_14.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
104	CPVC	1-1/4"	40.10	Transition Bushing	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_14.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
105	CPVC	3/4"	60.00	Cross Tee	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_15.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
427	SWR	4"x3"	297.00	Reducing Tee	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
106	CPVC	1"	106.10	Cross Tee	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_15.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
107	CPVC	3/4"	95.00	Step Over Bend	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_16.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
108	CPVC	1"	165.80	Step Over Bend	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_16.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
109	CPVC	3/4"	87.90	Long Radius Bend	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_17.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
110	CPVC	1"	129.60	Long Radius Bend	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_17.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
111	CPVC	1/2"	20.00	Test Plug		\N	\N	C	K	CPVC Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
112	CPVC	3/4"	195.00	Ball Valve	SDR 11	\N	\N	C	L	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_18.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
113	CPVC	1"	305.00	Ball Valve	SDR 11	\N	\N	C	L	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_18.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
114	CPVC	1-1/4"	520.00	Ball Valve	SDR 11	\N	\N	C	L	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_18.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
115	CPVC	1-1/2"	928.00	Ball Valve	SDR 11	\N	\N	C	L	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_18.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
461	Agri	50MM	492.00	Pipe 6 kg	Self Fit	3 mtr	\N	F	S	SWR / Agri Pipe	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	S	18.00	kelvin
471	Agri	110MM	314.00	Elbow 90*	6 kg	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_115.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
472	Agri	63MM	50.90	Elbow 90*	4 kg	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_116.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
473	Agri	75MM	73.20	Elbow 90*	4 kg	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_116.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
474	Agri	90MM	104.70	Elbow 90*	4 kg	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_116.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
462	Agri	63MM	549.00	Pipe 4 kg	Self Fit	3 mtr	\N	F	S	SWR / Agri Pipe	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	S	18.00	kelvin
475	Agri	110MM	159.70	Elbow 90*	4 kg	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_116.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
476	Agri	110MM ISI	238.00	Elbow 90*	4 kg	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_116.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
477	Agri	63MM	32.60	Elbow 90*	2.5 kg	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_117.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
478	Agri	75MM	46.10	Elbow 90*	2.5 kg	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_117.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
479	Agri	90MM	69.00	Elbow 90*	2.5 kg	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_117.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
480	Agri	110MM	121.20	Elbow 90*	2.5 kg	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_117.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
481	Agri	40MM	45.00	Tee	10 kg	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_114.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
482	Agri	50MM	69.40	Tee	10 kg	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_114.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
2	CPVC	1	528.00	pipe	SDR 13.5	\N	\N	A	B	CPVC Pipe 3/4"; 1"	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_1.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
3	CPVC	1-1/4	801.00	pipe	SDR 13.5	\N	\N	B	E	CPVC Pipe 1-1/4"; 1-1/2"; 2"	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_1.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
486	Agri	110MM	360.20	Tee	6 kg	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_118.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
487	Agri	63MM	68.50	Tee	4 kg	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_119.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
488	Agri	75MM	95.30	Tee	4 kg	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_119.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
489	Agri	90MM	134.70	Tee	4 kg	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_119.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
490	Agri	110MM	196.20	Tee	4 kg	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_119.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
491	Agri	63MM	40.90	Tee	2.5 kg	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_120.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
492	Agri	75MM	58.00	Tee	2.5 kg	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_120.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
493	Agri	90MM	85.80	Tee	2.5 kg	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_120.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
494	Agri	110MM	148.80	Tee	2.5 kg	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_120.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
495	Agri	50x40MM	28.10	Reducing Coupler	\N	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_121.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
496	Agri	63x40MM	35.00	Reducing Coupler	\N	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_121.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
497	Agri	63x50MM	40.40	Reducing Coupler	\N	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_121.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
512	Agri	110x63MM	321.10	Reducing Tee	\N	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_122.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
513	Agri	110x75MM	324.20	Reducing Tee	\N	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_122.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
514	Agri	110x90MM	336.20	Reducing Tee	\N	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_122.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
515	Agri	63MM	26.90	Endcap	\N	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_123.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
516	Agri	75MM	37.40	Endcap	\N	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_123.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
517	Agri	90MM	54.60	Endcap	\N	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_123.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
518	Agri	110MM	86.60	Endcap	\N	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_123.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
519	Agri	40MM	22.60	MTA	\N	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_124.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
520	Agri	50MM	32.20	MTA	\N	\N	\N	H	AG	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_124.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	\N	18.00	kelvin
170	UPVC	1/2"	339.00	Pipe	SCH-80	3 mtr	\N	D	N	UPVC Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_39.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	\N	18.00	kelvin
340	SWR	63MM	641.00	Pipe Single Socket	Self Fit	3 mtr	Type A	F	R	SWR / Agri Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_71.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	R	18.00	kelvin
341	SWR	75MM	715.00	Pipe Single Socket	Self Fit	3 mtr	Type A	G	X	UGD / SWR Pipe 75; 90; 110; 160mm	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_71.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	X	18.00	kelvin
312	UPVC	1"x3/4"	161.10	Reducing Brass Tee	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_63.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
342	SWR	90MM	954.00	Pipe Single Socket	Self Fit	3 mtr	Type A	G	AA	UGD / SWR Pipe 75; 90; 110; 160mm	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_71.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AA	18.00	kelvin
343	SWR	110MM	1294.00	Pipe Single Socket	Self Fit	3 mtr	Type A	G	U	UGD / SWR Pipe 75; 90; 110; 160mm	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_71.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	U	18.00	kelvin
344	SWR	160MM	2856.00	Pipe Single Socket	Self Fit	3 mtr	Type A	G	AC	UGD / SWR Pipe 75; 90; 110; 160mm	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_71.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AC	18.00	kelvin
137	CPVC	3/4"x1/2"	126.40	Reducing Brass MTA (HEX)	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_26.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
138	CPVC	3/4"x1/2"	95.80	Brass MTA	SDR 11	Round	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_27.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
345	SWR	40MM	798.00	Pipe Single Socket	Self Fit	6 mtr	Type A	F	R	SWR / Agri Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_72.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	R	18.00	kelvin
346	SWR	50MM	1008.00	Pipe Single Socket	Self Fit	6 mtr	Type A	F	R	SWR / Agri Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_72.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	R	18.00	kelvin
347	SWR	63MM	1279.00	Pipe Single Socket	Self Fit	6 mtr	Type A	F	R	SWR / Agri Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_72.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	R	18.00	kelvin
348	SWR	75MM	1422.00	Pipe Single Socket	Self Fit	6 mtr	Type A	G	Y	UGD / SWR Pipe 75; 90; 110; 160mm	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_72.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	Y	18.00	kelvin
349	SWR	90MM	1905.00	Pipe Single Socket	Self Fit	6 mtr	Type A	G	AB	UGD / SWR Pipe 75; 90; 110; 160mm	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_72.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AB	18.00	kelvin
350	SWR	110MM	2582.00	Pipe Single Socket	Self Fit	6 mtr	Type A	G	V	UGD / SWR Pipe 75; 90; 110; 160mm	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_72.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	V	18.00	kelvin
351	SWR	160MM	5697.00	Pipe Single Socket	Self Fit	6 mtr	Type A	G	AD	UGD / SWR Pipe 75; 90; 110; 160mm	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_72.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AD	18.00	kelvin
352	SWR	75MM	725.00	Pipe Single Socket	Ring Fit	3 mtr	Type A	G	W	UGD / SWR Pipe 75; 90; 110; 160mm	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_75.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	W	18.00	kelvin
353	SWR	90MM	966.00	Pipe Single Socket	Ring Fit	3 mtr	Type A	G	Z	UGD / SWR Pipe 75; 90; 110; 160mm	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_75.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	Z	18.00	kelvin
354	SWR	110MM	1310.00	Pipe Single Socket	Ring Fit	3 mtr	Type A	G	T	UGD / SWR Pipe 75; 90; 110; 160mm	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_75.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	T	18.00	kelvin
355	SWR	75MM	1303.00	Pipe Single Socket	Ring Fit	3 mtr	Type B	F	R	SWR / Agri Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_76.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	R	18.00	kelvin
356	SWR	90MM	1588.00	Pipe Single Socket	Ring Fit	3 mtr	Type B	F	R	SWR / Agri Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_76.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	R	18.00	kelvin
357	SWR	110MM	1945.00	Pipe Single Socket	Ring Fit	3 mtr	Type B	F	R	SWR / Agri Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_76.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	R	18.00	kelvin
358	SWR	75MM	564.00	Pipe Single Socket	Ring Fit	3 mtr	2.5 kg	F	R	SWR / Agri Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_77.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	R	18.00	kelvin
359	SWR	90MM	654.00	Pipe Single Socket	Ring Fit	3 mtr	2.5 kg	F	R	SWR / Agri Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_77.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	R	18.00	kelvin
360	SWR	110MM	957.00	Pipe Single Socket	Ring Fit	3 mtr	2.5 kg	F	R	SWR / Agri Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_77.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	R	18.00	kelvin
460	Agri	40MM	330.00	Pipe 6 kg	Self Fit	3 mtr	\N	F	S	SWR / Agri Pipe	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	S	18.00	kelvin
463	Agri	40MM	660.00	Pipe 6 kg	Self Fit	6 mtr	\N	F	S	SWR / Agri Pipe	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	S	18.00	kelvin
464	Agri	50MM	984.00	Pipe 6 kg	Self Fit	6 mtr	\N	F	S	SWR / Agri Pipe	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/agri.png	S	18.00	kelvin
338	SWR	40MM	399.00	Pipe Single Socket	Self Fit	3 mtr	Type A	F	R	SWR / Agri Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_71.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	R	18.00	kelvin
339	SWR	50MM	505.00	Pipe Single Socket	Self Fit	3 mtr	Type A	F	R	SWR / Agri Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_71.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	R	18.00	kelvin
366	SWR	4"x2-1/2"	240.00	Reducing Tee	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
361	SWR	160MM	2200.00	Pipe Single Socket	Ring Fit	3 mtr	2.5 kg	F	R	SWR / Agri Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_77.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	R	18.00	kelvin
362	SWR	75MM	132.00	Plain Tee	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_79.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
363	SWR	110MM	244.00	Plain Tee	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_79.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
364	SWR	75MM	174.00	Door Tee	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_80.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
365	SWR	110MM	316.00	Door Tee	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_80.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
367	SWR	4"x3"	280.00	Reducing Tee	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
368	SWR	4"x2-1/2"	321.00	Reducing Tee w Door	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
370	SWR	75MM	99.00	Plain Bend	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_81.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
371	SWR	90MM	146.00	Plain Bend	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_81.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
372	SWR	110MM	191.00	Plain Bend	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_81.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
373	SWR	160MM	540.00	Plain Bend	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_81.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
374	SWR	75MM	132.00	Door Bend	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_82.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
195	UPVC	1-1/2"	1710.00	Pipe	SCH-40	6 mtr	\N	D	N	UPVC Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_40.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	N	18.00	kelvin
196	UPVC	2"	2292.00	Pipe	SCH-40	6 mtr	\N	D	N	UPVC Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_40.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	N	18.00	kelvin
197	UPVC	1/2"	11.20	Coupler	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_41.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
198	UPVC	3/4"	16.60	Coupler	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_41.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
199	UPVC	1"	26.00	Coupler	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_41.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
200	UPVC	1-1/4"	41.70	Coupler	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_41.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
201	UPVC	1-1/2"	54.50	Coupler	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_41.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
202	UPVC	2"	80.10	Coupler	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_41.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
203	UPVC	3/4"x1/2"	15.90	Reducing Coupler	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_42.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
204	UPVC	1"x1/2"	24.90	Reducing Coupler	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_42.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
205	UPVC	1"x3/4"	26.40	Reducing Coupler	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_42.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
206	UPVC	1-1/4"x1/2"	40.00	Reducing Coupler	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_42.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
207	UPVC	1-1/4"x3/4"	41.10	Reducing Coupler	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_42.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
36	CPVC	1"x3/4"	49.40	Reducing Tee	SDR 11	\N	\N	C	K	CPVC Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
208	UPVC	1-1/4"x1"	43.60	Reducing Coupler	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_42.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
209	UPVC	1-1/2"x1/2"	50.90	Reducing Coupler	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_42.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
210	UPVC	1-1/2"x3/4"	51.60	Reducing Coupler	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_42.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
211	UPVC	1-1/2"x1"	55.10	Reducing Coupler	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_42.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
212	UPVC	1-1/2"x1-1/4"	58.90	Reducing Coupler	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_42.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
213	UPVC	2"x1"	83.90	Reducing Coupler	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_42.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
214	UPVC	2"x1-1/2"	91.50	Reducing Coupler	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_42.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
215	UPVC	1/2"	22.00	Tee	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_43.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
216	UPVC	3/4"	34.50	Tee	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_43.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
217	UPVC	1"	54.20	Tee	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_43.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
218	UPVC	1-1/4"	85.60	Tee	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_43.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
219	UPVC	1-1/2"	116.10	Tee	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_43.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
220	UPVC	2"	178.50	Tee	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_43.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
221	UPVC	3/4"x1/2"	33.60	Reducing Tee	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_44.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
222	UPVC	1"x1/2"	48.60	Reducing Tee	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_44.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
223	UPVC	1"x3/4"	49.40	Reducing Tee	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_44.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
224	UPVC	1-1/2"x1"	114.30	Reducing Tee	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_44.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
225	UPVC	1-1/2"x1-1/4"	177.20	Reducing Tee	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_44.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
226	UPVC	2"x1"	182.80	Reducing Tee	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_44.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
227	UPVC	1/2"	17.20	Elbow 45*	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_45.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
228	UPVC	3/4"	24.50	Elbow 45*	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_45.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
229	UPVC	1"	38.20	Elbow 45*	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_45.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
230	UPVC	1-1/4"	58.40	Elbow 45*	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_45.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
231	UPVC	1-1/2"	74.80	Elbow 45*	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_45.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
191	UPVC	1/2"	540.00	Pipe	SCH-40	6 mtr	\N	D	N	UPVC Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_40.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	N	18.00	kelvin
192	UPVC	3/4"	720.00	Pipe	SCH-40	6 mtr	\N	D	N	UPVC Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_40.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	N	18.00	kelvin
193	UPVC	1"	1056.00	Pipe	SCH-40	6 mtr	\N	D	N	UPVC Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_40.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	N	18.00	kelvin
194	UPVC	1-1/4"	1434.00	Pipe	SCH-40	6 mtr	\N	D	N	UPVC Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_40.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	N	18.00	kelvin
171	UPVC	3/4"	462.00	Pipe	SCH-80	3 mtr	\N	D	N	UPVC Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_39.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	\N	18.00	kelvin
172	UPVC	1"	625.00	Pipe	SCH-80	3 mtr	\N	D	N	UPVC Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_39.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	\N	18.00	kelvin
173	UPVC	1-1/4"	915.00	Pipe	SCH-80	3 mtr	\N	D	N	UPVC Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_39.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	\N	18.00	kelvin
174	UPVC	1-1/2"	1225.00	Pipe	SCH-80	3 mtr	\N	D	N	UPVC Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_39.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	\N	18.00	kelvin
175	UPVC	2"	1695.00	Pipe	SCH-80	3 mtr	\N	D	N	UPVC Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_39.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	\N	18.00	kelvin
9	CPVC	1-1/2"	1335.00	Pipe	SDR 11	\N	\N	B	I	CPVC Pipe 1-1/4"; 1-1/2"; 2"	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_2.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
10	CPVC	2"	2409.00	Pipe	SDR 11	\N	\N	B	J	CPVC Pipe 1-1/4"; 1-1/2"; 2"	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_2.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
13	CPVC	1"x3/4"	32.20	Reducing Coupler	SDR 11	\N	\N	C	K	CPVC Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
14	CPVC	1-1/4"x1/2"	54.00	Reducing Coupler	SDR 11	\N	\N	C	K	CPVC Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
15	CPVC	1-1/4"x3/4"	57.00	Reducing Coupler	SDR 11	\N	\N	C	K	CPVC Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
16	CPVC	1-1/4"x1"	66.80	Reducing Coupler	SDR 11	\N	\N	C	K	CPVC Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
17	CPVC	1-1/2"x3/4"	92.30	Reducing Coupler	SDR 11	\N	\N	C	K	CPVC Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
18	CPVC	1-1/2"x1"	104.20	Reducing Coupler	SDR 11	\N	\N	C	K	CPVC Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
19	CPVC	1-1/2"x1-1/4"	92.60	Reducing Coupler	SDR 11	\N	\N	C	K	CPVC Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
20	CPVC	2"x3/4"	224.30	Reducing Coupler	SDR 11	\N	\N	C	K	CPVC Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
21	CPVC	2"x1"	190.10	Reducing Coupler	SDR 11	\N	\N	C	K	CPVC Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
22	CPVC	2"x1-1/4"	202.50	Reducing Coupler	SDR 11	\N	\N	C	K	CPVC Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
23	CPVC	2"x1-1/2"	222.70	Reducing Coupler	SDR 11	\N	\N	C	K	CPVC Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
24	CPVC	3/4"	13.50	Coupler	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_3.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
523	SWR	50ml	80.00	Solvent Cement	\N	\N	\N	H	AH	SWR / PVC / Agri Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	\N	18.00	kelvin
524	SWR	100ml	105.00	Solvent Cement	\N	\N	\N	H	AH	SWR / PVC / Agri Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	\N	18.00	kelvin
525	SWR	250ml	200.00	Solvent Cement	\N	\N	\N	H	AH	SWR / PVC / Agri Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	\N	18.00	kelvin
526	SWR	500ml	350.00	Solvent Cement	\N	\N	\N	H	AH	SWR / PVC / Agri Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	\N	18.00	kelvin
527	SWR	1000ml	620.00	Solvent Cement	\N	\N	\N	H	AH	SWR / PVC / Agri Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	\N	18.00	kelvin
528	SWR	100gm	50.00	Rubber Lubricant	\N	\N	\N	H	AH	SWR / PVC / Agri Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	\N	18.00	kelvin
529	SWR	250gm	95.00	Rubber Lubricant	\N	\N	\N	H	AH	SWR / PVC / Agri Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	\N	18.00	kelvin
530	SWR	500gm	180.00	Rubber Lubricant	\N	\N	\N	H	AH	SWR / PVC / Agri Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	\N	18.00	kelvin
25	CPVC	1"	23.30	Coupler	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_3.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
26	CPVC	1-1/4"	40.60	Coupler	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_3.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
27	CPVC	1-1/2"	71.80	Coupler	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_3.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
28	CPVC	2"	149.60	Coupler	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_3.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
29	CPVC	3/4"	28.30	Tee	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_4.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
30	CPVC	1"	45.70	Tee	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_4.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
31	CPVC	1-1/4"	88.10	Tee	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_4.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
32	CPVC	1-1/2"	141.60	Tee	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_4.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
33	CPVC	2"	304.00	Tee	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_4.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
35	CPVC	1"x1/2"	67.30	Reducing Tee	SDR 11	\N	\N	C	K	CPVC Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
37	CPVC	1-1/4"x3/4"	105.80	Reducing Tee	SDR 11	\N	\N	C	K	CPVC Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
39	CPVC	1-1/2"x3/4"	164.20	Reducing Tee	SDR 11	\N	\N	C	K	CPVC Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
40	CPVC	1-1/2"x1"	168.50	Reducing Tee	SDR 11	\N	\N	C	K	CPVC Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
41	CPVC	1-1/2"x1-1/4"	177.20	Reducing Tee	SDR 11	\N	\N	C	K	CPVC Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
42	CPVC	2"x3/4"	327.50	Reducing Tee	SDR 11	\N	\N	C	K	CPVC Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
43	CPVC	2"x1"	334.40	Reducing Tee	SDR 11	\N	\N	C	K	CPVC Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
44	CPVC	2"x1-1/4"	342.80	Reducing Tee	SDR 11	\N	\N	C	K	CPVC Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
45	CPVC	2"x1-1/2"	364.50	Reducing Tee	SDR 11	\N	\N	C	K	CPVC Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
46	CPVC	3/4"	23.70	45* Elbow	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_5.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
47	CPVC	1"	45.20	45* Elbow	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_5.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
48	CPVC	1-1/4"	78.40	45* Elbow	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_5.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
49	CPVC	1-1/2"	145.00	45* Elbow	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_5.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
50	CPVC	3/4"	16.60	90* Elbow	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_6.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
51	CPVC	1"	34.00	90* Elbow	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_6.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
52	CPVC	1-1/4"	70.20	90* Elbow	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_6.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
53	CPVC	1-1/2"	111.90	90* Elbow	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_6.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
54	CPVC	2"	243.60	90* Elbow	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_6.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
55	CPVC	3/4"	20.10	MTA (Plastic)	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_7.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
56	CPVC	1"	31.60	MTA (Plastic)	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_7.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
57	CPVC	1-1/4"	50.10	MTA (Plastic)	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_7.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
58	CPVC	1-1/2"	80.70	MTA (Plastic)	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_7.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
59	CPVC	2"	144.30	MTA (Plastic)	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_7.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
60	CPVC	3/4"x1/2"	29.20	Reducing MTA (Plastic)	SDR 11	\N	\N	C	K	CPVC Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
61	CPVC	3/4"	26.90	FTA (Plastic)	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_8.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
62	CPVC	1"	42.70	FTA (Plastic)	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_8.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
63	CPVC	1-1/4"	72.90	FTA (Plastic)	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_8.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
64	CPVC	1-1/2"	114.60	FTA (Plastic)	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_8.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
65	CPVC	2"	206.00	FTA (Plastic)	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_8.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
66	CPVC	3/4"x1/2"	39.40	Reducing FTA (Plastic)	SDR 11	\N	\N	C	K	CPVC Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
67	CPVC	3/4"	11.90	Endcap	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_9.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
68	CPVC	1"	20.30	Endcap	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_9.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
69	CPVC	1-1/4"	34.90	Endcap	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_9.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
70	CPVC	1-1/2"	54.30	Endcap	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_9.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
71	CPVC	2"	121.40	Endcap	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_9.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
72	CPVC	3/4"	69.50	Union	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_10.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
73	CPVC	1"	110.60	Union	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_10.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
74	CPVC	1-1/4"	148.00	Union	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_10.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
75	CPVC	1-1/2"	258.70	Union	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_10.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
76	CPVC	2"	471.90	Union	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_10.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
77	CPVC	3/4"	64.30	Tank Connector (Thread)	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_11.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
78	CPVC	1"	97.20	Tank Connector (Thread)	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_11.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
79	CPVC	1-1/4"	148.00	Tank Connector (Thread)	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_11.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
80	CPVC	1-1/2"	208.50	Tank Connector (Thread)	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_11.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
81	CPVC	2"	304.10	Tank Connector (Thread)	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_11.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
82	CPVC	3/4"	63.20	Socket Tank Connector	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_12.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
83	CPVC	1"	101.50	Socket Tank Connector	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_12.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
84	CPVC	1-1/4"	122.40	Socket Tank Connector	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_12.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
85	CPVC	1-1/2"	213.20	Socket Tank Connector	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_12.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
86	CPVC	2"	306.90	Socket Tank Connector	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_12.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
87	CPVC	3/4"x1/2"	10.90	Reducing Bush	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_13.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
88	CPVC	1"x1/2"	21.60	Reducing Bush	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_13.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
89	CPVC	1"x3/4"	16.40	Reducing Bush	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_13.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
90	CPVC	1-1/4"x1/2"	42.40	Reducing Bush	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_13.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
91	CPVC	1-1/4"x3/4"	32.20	Reducing Bush	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_13.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
92	CPVC	1-1/4"x1"	28.10	Reducing Bush	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_13.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
93	CPVC	1-1/2"x1/2"	68.40	Reducing Bush	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_13.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
94	CPVC	1-1/2"x3/4"	51.60	Reducing Bush	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_13.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
95	CPVC	1-1/2"x1"	49.20	Reducing Bush	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_13.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
96	CPVC	1-1/2"x1-1/4"	34.80	Reducing Bush	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_13.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
97	CPVC	2"x1/2"	111.10	Reducing Bush	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_13.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
98	CPVC	2"x3/4"	96.50	Reducing Bush	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_13.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
99	CPVC	2"x1"	97.30	Reducing Bush	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_13.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
100	CPVC	2"x1-1/4"	90.50	Reducing Bush	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_13.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
116	CPVC	6"	276.00	Kitchen Mixer	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_20.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
117	CPVC	7"	283.00	Kitchen Mixer	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_20.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
118	CPVC	6"	340.00	Mixer Adapter	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_19.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
119	CPVC	7"	351.00	Mixer Adapter	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_19.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
120	CPVC	3/4"	115.60	Brass Tee	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_21.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
121	CPVC	1"	227.50	Brass Tee	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_21.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
122	CPVC	1-1/4"	319.10	Brass Tee	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_21.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
123	CPVC	3/4"x1/2"	84.60	Reducing Brass Tee	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_22.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
124	CPVC	1"x1/2"	118.60	Reducing Brass Tee	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_22.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
125	CPVC	1"x3/4"	156.00	Reducing Brass Tee	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_22.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
126	CPVC	3/4"	105.40	Brass Elbow	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_23.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
127	CPVC	1"	221.10	Brass Elbow	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_23.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
128	CPVC	1-1/4"	315.70	Brass Elbow	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_23.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
129	CPVC	3/4"x1/2"	75.00	Reducing Brass Elbow	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_24.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
130	CPVC	1"x1/2"	109.80	Reducing Brass Elbow	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_24.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
131	CPVC	1"x3/4"	145.00	Reducing Brass Elbow	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_24.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
132	CPVC	3/4"	185.30	Brass MTA	SDR 11	Hex	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_25.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
133	CPVC	1"	296.30	Brass MTA	SDR 11	Hex	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_25.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
134	CPVC	1-1/4"	743.80	Brass MTA	SDR 11	Hex	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_25.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
135	CPVC	1-1/2"	928.70	Brass MTA	SDR 11	Hex	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_25.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
136	CPVC	2"	1634.90	Brass MTA	SDR 11	Hex	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_25.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
139	CPVC	1"x1/2"	114.60	Brass MTA	SDR 11	Round	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_27.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
140	CPVC	1"x3/4"	195.60	Brass MTA	SDR 11	Round	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_27.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
141	CPVC	1"x1"	260.00	Brass MTA	SDR 11	Round	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_27.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
142	CPVC	3/4"	189.00	Brass FTA	SDR 11	Hex	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_28.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
143	CPVC	1"	385.80	Brass FTA	SDR 11	Hex	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_28.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
144	CPVC	1-1/4"	756.20	Brass FTA	SDR 11	Hex	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_28.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
417	SWR	110x75MM	19.00	Ecentric Bush	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
145	CPVC	1-1/2"	920.00	Brass FTA	SDR 11	Hex	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_28.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
146	CPVC	2"	1431.30	Brass FTA	SDR 11	Hex	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_28.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
147	CPVC	3/4"x1/2"	138.30	Reducing Brass FTA (HEX)	SDR 11	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_29.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
148	CPVC	3/4"x1/2"	76.60	Brass FTA	SDR 11	Round	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_30.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
149	CPVC	1"x1/2"	91.20	Brass FTA	SDR 11	Round	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_30.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
150	CPVC	1"x3/4"	127.90	Brass FTA	SDR 11	Round	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_30.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
151	CPVC	1"x1"	215.80	Brass FTA	SDR 11	Round	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_30.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
152	CPVC	10ml	25.00	Solvent Cement	\N	\N	\N	C	M	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_31.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
153	CPVC	25ml	55.00	Solvent Cement	\N	\N	\N	C	M	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_31.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
154	CPVC	59ml	170.00	Solvent Cement	\N	\N	\N	C	M	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_32.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
155	CPVC	118ml	180.00	Solvent Cement	\N	\N	\N	C	M	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_32.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
156	CPVC	237ml	470.00	Solvent Cement	\N	\N	\N	C	M	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_32.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
157	CPVC	2-1/2"	620.00	Elbow 90*	SCH-40	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_33.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
158	CPVC	3"	980.00	Elbow 90*	SCH-40	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_33.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
159	CPVC	4"	1602.00	Elbow 90*	SCH-40	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_33.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
160	CPVC	2-1/2"	985.00	Elbow 90*	SCH-80	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_34.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
161	CPVC	4"	2807.00	Elbow 90*	SCH-80	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_34.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
162	CPVC	2-1/2"	1522.00	Tee	SCH-80	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_35.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
163	CPVC	3"	2263.00	Tee	SCH-80	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_35.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
164	CPVC	3"	1400.00	Elbow 45*	SCH-80	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_36.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
165	CPVC	2-1/2"	338.00	Endcap	SCH-80	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_38.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
166	CPVC	3"	498.00	Endcap	SCH-80	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_38.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
167	CPVC	4"	937.00	Endcap	SCH-80	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_38.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
168	CPVC	2-1/2"x2"	1351.00	Reducing Tee	SCH-80	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_37.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
169	CPVC	3"x2-1/2"	2193.00	Reducing Tee	SCH-80	\N	\N	C	K	CPVC Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_37.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/cpvc.png	\N	18.00	kelvin
189	UPVC	1-1/2"	2274.00	Pipe	SCH-80	6 mtr	\N	D	N	UPVC Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_39.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	N	18.00	kelvin
190	UPVC	2"	3144.00	Pipe	SCH-80	6 mtr	\N	D	N	UPVC Pipe	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_39.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	N	18.00	kelvin
245	UPVC	1/2"	10.80	FTA	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_51.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
246	UPVC	3/4"	17.90	FTA	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_51.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
247	UPVC	1"	27.80	FTA	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_51.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
248	UPVC	1-1/4"	41.50	FTA	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_51.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
249	UPVC	1-1/2"	53.10	FTA	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_51.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
250	UPVC	2"	75.90	FTA	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_51.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
251	UPVC	1/2"	8.50	Endcap	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_48.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
252	UPVC	3/4"	12.30	Endcap	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_48.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
253	UPVC	1"	20.70	Endcap	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_48.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
254	UPVC	1-1/4"	31.80	Endcap	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_48.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
255	UPVC	1-1/2"	41.20	Endcap	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_48.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
256	UPVC	2"	62.30	Endcap	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_48.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
257	UPVC	1/2"	35.60	Union	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_49.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
258	UPVC	3/4"	54.90	Union	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_49.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
259	UPVC	1"	72.10	Union	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_49.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
260	UPVC	1-1/4"	99.40	Union	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_49.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
261	UPVC	1-1/2"	156.60	Union	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_49.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
262	UPVC	2"	228.40	Union	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_49.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
263	UPVC	1/2"	34.90	Tank Connector	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_52.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
264	UPVC	3/4"	43.10	Tank Connector	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_52.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
265	UPVC	1"	59.20	Tank Connector	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_52.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
266	UPVC	1-1/4"	91.50	Tank Connector	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_52.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
267	UPVC	1-1/2"	105.90	Tank Connector	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_52.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
268	UPVC	2"	148.40	Tank Connector	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_52.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
269	UPVC	1/2"	35.00	Socket Tank Connector	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_53.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
270	UPVC	3/4"	43.00	Socket Tank Connector	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_53.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
271	UPVC	1"	60.00	Socket Tank Connector	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_53.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
272	UPVC	1-1/4"	92.00	Socket Tank Connector	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_53.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
273	UPVC	1-1/2"	117.00	Socket Tank Connector	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_53.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
274	UPVC	1/2"	56.60	Long Tank Connector	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_54.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
275	UPVC	3/4"	72.30	Long Tank Connector	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_54.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
276	UPVC	1"	101.70	Long Tank Connector	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_54.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
277	UPVC	3/4"x1/2"	6.80	Reducing Bush	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_47.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
278	UPVC	1"x1/2"	17.20	Reducing Bush	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_47.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
279	UPVC	1"x3/4"	11.90	Reducing Bush	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_47.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
453	SWR	75MM	272.00	Double Y	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_109.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
454	SWR	110MM	513.00	Double Y	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_109.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
455	SWR	75MM	256.00	Double Tee w Door	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_111.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
456	SWR	110MM	453.00	Double Tee w Door	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_111.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
457	SWR	75MM	305.00	Double Y w Door	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_110.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
458	SWR	110MM	567.00	Double Y w Door	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_110.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
459	SWR	4"x2-1/2"x1-1/2"	265.00	Multi Floor Trap	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_112.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
280	UPVC	1-1/4"x1/2"	30.10	Reducing Bush	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_47.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
281	UPVC	1-1/4"x3/4"	30.20	Reducing Bush	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_47.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
282	UPVC	1-1/4"x1"	20.20	Reducing Bush	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_47.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
283	UPVC	1-1/2"x1"	37.10	Reducing Bush	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_47.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
284	UPVC	1-1/2"x1-1/4"	19.50	Reducing Bush	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_47.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
285	UPVC	2"x1"	70.80	Reducing Bush	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_47.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
286	UPVC	2"x1-1/4"	67.50	Reducing Bush	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_47.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
287	UPVC	2"x1-1/2"	51.10	Reducing Bush	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_47.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
288	UPVC	1/2"	20.80	Threaded Elbow	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_55.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
289	UPVC	1/2"	25.80	Threaded Tee	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_56.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
290	UPVC	1/2"	68.10	Step Over Bend	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_58.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
291	UPVC	3/4"	100.70	Step Over Bend	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_58.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
292	UPVC	1"	178.50	Step Over Bend	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_58.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
382	SWR	110MM	94.00	Coupler	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_84.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
383	SWR	160MM	301.00	Coupler	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_84.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
384	SWR	160MM REPAIR	298.00	Coupler	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_84.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
385	SWR	75MM	175.00	Single Y	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_85.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
386	SWR	110MM	342.00	Single Y	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_85.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
387	SWR	75MM	208.00	Single Y w Door	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_86.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
388	SWR	110MM	398.00	Single Y w Door	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_86.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
389	SWR	75MM	76.00	Bend 45*	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_87.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
390	SWR	90MM	121.00	Bend 45*	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_87.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
391	SWR	110MM	143.00	Bend 45*	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_87.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
392	SWR	160MM	460.00	Bend 45*	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_87.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
393	SWR	4"x4"	472.00	P-Trap	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_88.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
394	SWR	4-1/2"x4"	492.00	P-Trap	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_88.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
395	SWR	4"x2"	150.00	Nahani Trap w/o Jali	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_89.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
396	SWR	4"x2-1/2"	160.00	Nahani Trap w/o Jali	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_89.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
397	SWR	4"x3"	175.00	Nahani Trap w/o Jali	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_89.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
398	SWR	4"x4"	189.00	Nahani Trap w/o Jali	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_89.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
399	SWR	4"x4"	516.00	Q-Trap	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_90.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
400	SWR	4-1/2"x4"	537.00	Q-Trap	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_90.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
401	SWR	4"x4"	635.00	S-Trap	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_91.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
402	SWR	4-1/2"x4"	653.00	S-Trap	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_91.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
403	SWR	75MM	51.00	Door Cap w Ring	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_92.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
404	SWR	110MM	76.00	Door Cap w Ring	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_92.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
405	SWR	75MM	199.00	Double Tee	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_93.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
406	SWR	110MM	370.00	Double Tee	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_93.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
407	SWR	75MM	252.00	Double Y	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_94.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
408	SWR	110MM	490.00	Double Y	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_94.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
409	SWR	75MM	237.00	Double Tee w Door	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_95.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
410	SWR	110MM	430.00	Double Tee w Door	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_95.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
411	SWR	75MM	287.00	Double Y w Door	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_96.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
412	SWR	110MM	544.00	Double Y w Door	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_96.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
413	SWR	75MM	19.00	Vent Cowl	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_97.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
414	SWR	110MM	36.00	Vent Cowl	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_97.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
415	SWR	160MM	298.00	Vent Cowl	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_97.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
416	SWR	110MM	282.00	Cleansing Pipe	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_98.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
418	SWR	110x90MM	36.00	Ecentric Bush	Self Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
419	SWR	75MM	174.00	Plain Tee	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_99.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
420	SWR	90MM	250.00	Plain Tee	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_99.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
421	SWR	110MM	314.00	Plain Tee	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_99.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
422	SWR	160MM	845.00	Plain Tee	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_99.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
423	SWR	75MM	207.00	Door Tee	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_100.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
424	SWR	110MM	370.00	Door Tee	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_100.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
425	SWR	160MM	893.00	Door Tee	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_100.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
426	SWR	4"x2-1/2"	283.00	Reducing Tee	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
428	SWR	4"x2-1/2"	335.00	Reducing Tee w Door	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
429	SWR	4"x3"	348.00	Reducing Tee w Door	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	\N	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
430	SWR	75MM	106.00	Plain Bend	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_101.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
431	SWR	90MM	164.00	Plain Bend	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_101.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
432	SWR	110MM	213.00	Plain Bend	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_101.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
433	SWR	160MM	598.00	Plain Bend	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_101.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
434	SWR	75MM	137.00	Door Bend	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_102.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
435	SWR	90MM	205.00	Door Bend	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_102.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
436	SWR	110MM	264.00	Door Bend	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_102.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
437	SWR	160MM	663.00	Door Bend	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_102.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
438	SWR	4"x2-1/2"	128.00	Reducing Coupler	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_103.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
439	SWR	4"x3"	141.00	Reducing Coupler	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_103.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
440	SWR	75MM	86.00	Coupler	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_104.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
441	SWR	90MM	115.00	Coupler	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_104.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
442	SWR	110MM	145.00	Coupler	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_104.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
443	SWR	75MM	211.00	Single Y	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_105.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
444	SWR	110MM	396.00	Single Y	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_105.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
445	SWR	75MM	236.00	Single Y w Door	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_106.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
446	SWR	110MM	445.00	Single Y w Door	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_106.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
447	SWR	75MM	100.00	Bend 45*	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_107.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
448	SWR	90MM	138.00	Bend 45*	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_107.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
449	SWR	110MM	177.00	Bend 45*	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_107.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
450	SWR	160MM	516.00	Bend 45*	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_107.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
451	SWR	75MM	218.00	Double Tee	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_108.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
452	SWR	110MM	393.00	Double Tee	Ring Fit	\N	\N	H	AF	SWR / PVC / Agri Fittings	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_108.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/swr.png	AF	18.00	kelvin
293	UPVC	1/2"	49.40	Long Radius Bend	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_57.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
294	UPVC	3/4"	69.20	Long Radius Bend	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_57.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
295	UPVC	1"	113.20	Long Radius Bend	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_57.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
296	UPVC	1/2"	14.00	Test Plug	\N	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_59.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
297	UPVC	3/4"	160.00	Ball Valve	SCH-80	\N	\N	E	P	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_60.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	P	18.00	kelvin
298	UPVC	1"	190.00	Ball Valve	SCH-80	\N	\N	E	P	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_60.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	P	18.00	kelvin
299	UPVC	1-1/4"	275.00	Ball Valve	SCH-80	\N	\N	E	P	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_60.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	P	18.00	kelvin
300	UPVC	1-1/2"	552.00	Ball Valve	SCH-80	\N	\N	E	P	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_60.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	P	18.00	kelvin
301	UPVC	1/2"	115.00	Compact Ball Valve	SCH-80	\N	\N	E	P	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_61.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	P	18.00	kelvin
302	UPVC	3/4"	150.00	Compact Ball Valve	SCH-80	\N	\N	E	P	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_61.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	P	18.00	kelvin
303	UPVC	1"	180.00	Compact Ball Valve	SCH-80	\N	\N	E	P	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_61.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	P	18.00	kelvin
304	UPVC	1-1/4"	260.00	Compact Ball Valve	SCH-80	\N	\N	E	P	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_61.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	P	18.00	kelvin
305	UPVC	1-1/2"	360.00	Compact Ball Valve	SCH-80	\N	\N	E	P	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_61.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	P	18.00	kelvin
306	UPVC	2"	580.00	Compact Ball Valve	SCH-80	\N	\N	E	P	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_61.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	P	18.00	kelvin
307	UPVC	1/2"	94.10	Brass Tee	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_62.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
308	UPVC	3/4"	139.60	Brass Tee	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_62.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
309	UPVC	1"	222.30	Brass Tee	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_62.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
310	UPVC	3/4"x1/2"	101.90	Reducing Brass Tee	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_63.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
311	UPVC	1"x1/2"	118.40	Reducing Brass Tee	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_63.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
240	UPVC	3/4"	14.20	MTA	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_50.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
241	UPVC	1"	23.40	MTA	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_50.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
242	UPVC	1-1/4"	35.10	MTA	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_50.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
243	UPVC	1-1/2"	46.20	MTA	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_50.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
244	UPVC	2"	65.60	MTA	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_50.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
318	UPVC	1"x3/4"	153.80	Reducing Brass Elbow	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_65.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
319	UPVC	1/2"	105.40	Brass MTA	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_66.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
320	UPVC	3/4"	177.30	Brass MTA	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_66.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
321	UPVC	1"	262.40	Brass MTA	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_66.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
322	UPVC	1-1/4"	470.40	Brass MTA	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_66.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
323	UPVC	1-1/2"	611.10	Brass MTA	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_66.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
324	UPVC	2"	958.30	Brass MTA	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_66.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
325	UPVC	1/2"	81.20	Brass FTA	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_67.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
326	UPVC	3/4"	130.20	Brass FTA	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_67.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
327	UPVC	1"	190.00	Brass FTA	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_67.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
328	UPVC	1-1/4"	314.60	Brass FTA	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_67.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
329	UPVC	1-1/2"	497.10	Brass FTA	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_67.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
330	UPVC	2"	669.30	Brass FTA	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_67.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
331	UPVC	3/4"x1/2"	83.90	Reducing Brass FTA	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_68.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
332	UPVC	1"x1/2"	92.00	Reducing Brass FTA	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_68.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
333	UPVC	10ml	20.00	Solvent Cement	\N	\N	\N	E	Q	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_69.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	Q	18.00	kelvin
334	UPVC	25ml	40.00	Solvent Cement	\N	\N	\N	E	Q	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_69.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	Q	18.00	kelvin
335	UPVC	50ml	120.00	Solvent Cement	\N	\N	\N	E	Q	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_69.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	Q	18.00	kelvin
336	UPVC	100ml	180.00	Solvent Cement	\N	\N	\N	E	Q	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_70.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	Q	18.00	kelvin
337	UPVC	250ml	300.00	Solvent Cement	\N	\N	\N	E	Q	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_70.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	Q	18.00	kelvin
313	UPVC	1/2"	85.40	Brass Elbow	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_64.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
314	UPVC	3/4"	125.50	Brass Elbow	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_64.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
315	UPVC	1"	216.30	Brass Elbow	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_64.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
316	UPVC	3/4"x1/2"	95.80	Reducing Brass Elbow	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_65.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
317	UPVC	1"x1/2"	105.60	Reducing Brass Elbow	SCH-80	\N	\N	E	O	UPVC Fitting	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/QUOTATION_image_65.png	2024-11-18 15:15:32.240751	2024-11-18 15:15:32.29256	https://puranmalsonsbucket.s3.ap-south-1.amazonaws.com/upvc.png	O	18.00	kelvin
\.


--
-- TOC entry 4942 (class 0 OID 33337)
-- Dependencies: 230
-- Data for Name: margin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.margin (margin_id, mc_name, margin) FROM stdin;
0fab6614-658c-44f5-a830-77e6e2e3530a	CPVC Pipe 3/4"; 1"	7
0c360b42-e6fa-4b38-a096-573e86b6e7c2	CPVC Pipe 1-1/4"; 1-1/2"; 2"	9
d7fb4ad5-39f2-467d-8112-4267f98af8cf	CPVC Fittings	3
8090e3ba-adae-4902-9aa5-71580c33f66f	UPVC Fitting	9
edf119ab-104a-423f-af47-46075275abed	SWR / PVC / Agri Fittings	1
7ea1fa1a-4875-4a71-8c63-52880700a71d	UGD / SWR Pipe 75; 90; 110; 160mm	12
d752f85a-e3f3-4291-aae5-452e51c2483a	null	3
3c4a948d-8117-40b6-9cdc-17f1c4942748	UPVC Pipe	6
76778560-92c0-4eb2-b078-71c1e8488afa	SWR / Agri Pipe	12
\.


--
-- TOC entry 4935 (class 0 OID 24893)
-- Dependencies: 223
-- Data for Name: pickmargin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pickmargin (mc_name, margin, id, quotation_id) FROM stdin;
CPVC Fittings	2.00	5	a9b0f86b-4585-4be7-8228-75e29c3d934a
CPVC Fittings	3.00	6	a43167b9-0aff-4155-851d-d2532d75688d
CPVC Fittings	4.00	7	f28ce516-3d63-46d8-8c95-36d7cbfee0ce
CPVC Fittings	7.00	8	2d9c74fc-16c6-42be-861e-3418f1812c3a
UGD / SWR Pipe 75; 90; 110; 160mm	3.00	9	12dc4e06-9535-4ec8-8201-e30a53922e27
CPVC Pipe 1-1/4"; 1-1/2"; 2"	5.00	10	aa4470bd-2715-495f-a52d-72f67976fcc8
\.


--
-- TOC entry 4934 (class 0 OID 24873)
-- Dependencies: 222
-- Data for Name: quotation_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.quotation_items (quotation_items_id, article, image_url, quantity, category, type, size, margin, discount_rate, mrp, net_rate, final_rate, created_at, updated_at, item_id, quotation_id) FROM stdin;
1	Coupler	\N	1	SDR 11	CPVC	1"	3.00	43.50	23.30	\N	-17.20	2024-12-29 22:16:43.493034	2024-12-29 22:16:43.493034	\N	a43167b9-0aff-4155-851d-d2532d75688d
2	Endcap	\N	1	SCH-80	CPVC	3"	5.00	43.50	498.00	\N	459.50	2024-12-30 11:57:15.878849	2024-12-30 11:57:15.878849	\N	f28ce516-3d63-46d8-8c95-36d7cbfee0ce
3	Tee	\N	1	SCH-80	CPVC	2-1/2"	3.00	43.50	1522.00	\N	1481.50	2024-12-30 12:12:46.061012	2024-12-30 12:12:46.061012	\N	f28ce516-3d63-46d8-8c95-36d7cbfee0ce
4	Tee	\N	1	SCH-80	CPVC	2-1/2"	3.00	43.50	1522.00	\N	1481.50	2024-12-30 12:46:19.73325	2024-12-30 12:46:19.73325	\N	f28ce516-3d63-46d8-8c95-36d7cbfee0ce
5	Reducing Bush	\N	2	SCH-80	UPVC	1-1/4"x1/2"	3.00	61.00	30.10	\N	-27.90	2024-12-30 12:46:19.73325	2024-12-30 12:46:19.73325	\N	f28ce516-3d63-46d8-8c95-36d7cbfee0ce
6	Elbow 90*	\N	3	SCH-40	CPVC	2-1/2"	5.00	43.50	620.00	\N	581.50	2024-12-31 00:51:13.341244	2024-12-31 00:51:13.341244	\N	f28ce516-3d63-46d8-8c95-36d7cbfee0ce
7	Reducing Coupler	\N	4	SCH-80	UPVC	2"x1"	5.00	61.00	83.90	\N	27.90	2024-12-31 00:51:13.341244	2024-12-31 00:51:13.341244	\N	f28ce516-3d63-46d8-8c95-36d7cbfee0ce
8	Endcap	\N	2	SCH-80	CPVC	2-1/2"	2.00	43.50	338.00	\N	296.50	2025-01-01 03:37:17.088129	2025-01-01 03:37:17.088129	\N	2d9c74fc-16c6-42be-861e-3418f1812c3a
9	Tee	\N	1	SDR 11	\N	1"	2.00	43.50	45.70	\N	4.20	2025-01-01 18:24:27.052486	2025-01-01 18:24:27.052486	\N	2d9c74fc-16c6-42be-861e-3418f1812c3a
10	Endcap	\N	1	SCH-80	\N	2-1/2"	2.00	43.50	338.00	\N	296.50	2025-01-01 18:25:28.140684	2025-01-01 18:25:28.140684	\N	2d9c74fc-16c6-42be-861e-3418f1812c3a
11	Pipe	\N	1	SDR 11	\N	1"	3.00	\N	630.00	310.00	313.00	2025-01-02 09:37:52.52036	2025-01-02 09:37:52.52036	\N	2d9c74fc-16c6-42be-861e-3418f1812c3a
12	Elbow 90*	\N	1	SCH-80	\N	2-1/2"	3.00	43.50	985.00	\N	944.50	2025-01-02 09:38:43.926333	2025-01-02 09:38:43.926333	\N	2d9c74fc-16c6-42be-861e-3418f1812c3a
13	Tee	\N	1	SCH-80	\N		3.00	43.50	1522.00	\N	1481.50	2025-01-02 09:38:43.926333	2025-01-02 09:38:43.926333	\N	2d9c74fc-16c6-42be-861e-3418f1812c3a
14	Tee	\N	1	SCH-80	\N	2-1/2"	2.00	43.50	1522.00	\N	1480.50	2025-01-02 18:40:16.773531	2025-01-02 18:40:16.773531	\N	2d9c74fc-16c6-42be-861e-3418f1812c3a
15	Reducing Bush	\N	1	SDR 11	\N	2"x1/2"	2.00	43.50	111.10	\N	69.60	2025-01-02 18:40:16.773531	2025-01-02 18:40:16.773531	\N	2d9c74fc-16c6-42be-861e-3418f1812c3a
16	Pipe Single Socket	\N	1	Self Fit	\N	110MM	3.00	\N	1294.00	430.00	433.00	2025-01-05 17:02:15.89665	2025-01-05 17:02:15.89665	\N	12dc4e06-9535-4ec8-8201-e30a53922e27
\.


--
-- TOC entry 4939 (class 0 OID 24948)
-- Dependencies: 227
-- Data for Name: quotations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.quotations (id, created_at) FROM stdin;
f246a062-d2f6-493b-81d3-25580dfafd35	2024-12-27 20:57:21.556327
4a9b0f9b-3b05-4c14-85ca-49d300e86881	2024-12-27 20:57:40.415956
e87d9500-ad92-494f-9d85-0c15fd8f95de	2024-12-27 20:57:40.479357
024bebf8-fd64-4754-94f2-0499e09dbc12	2024-12-27 20:59:02.876207
d49bc59a-d4f8-4387-92a5-9939c631c0fe	2024-12-27 20:59:02.920789
a1c844f6-e70b-4007-9a23-d01e52e0c4dd	2024-12-27 21:00:20.847589
0b1e8fbf-37c5-459b-ba7a-fd0a230adb63	2024-12-28 04:06:11.812651
506c626f-bfba-4e4a-9a4e-8fb5caf56fa2	2024-12-28 04:06:11.962124
57aefdab-0a89-4e1e-921d-d44c3f6a5e1f	2024-12-28 04:09:36.067371
a2c531dc-c09e-4ed7-ae27-4c7285274fa6	2024-12-28 04:09:36.09993
67a3e954-1d97-436e-b1ac-8e514af32b06	2024-12-28 04:10:08.234763
a7a759ec-40ea-428c-a9d2-003987fdbeb2	2024-12-28 04:10:08.273356
f7eb5432-a488-48ae-ad10-672ac8acc31d	2024-12-28 04:59:16.594379
ae0fa1ea-0ec4-43d0-a61f-ee3bae9a3ec7	2024-12-28 04:59:16.597545
87db8103-07ff-48b5-b83d-2bcb360946cf	2024-12-28 04:59:43.55809
df1885c7-1504-42fe-90f6-48a4005621ee	2024-12-28 04:59:43.602205
cfd95014-ed84-49c4-b692-0123f0bc1524	2024-12-28 05:06:31.925189
712212d2-48d3-4111-82de-8123c925e027	2024-12-28 05:06:32.010603
68c923f6-6dad-4b51-a0ad-5c0bcaa57685	2024-12-28 05:08:27.699027
d75525c5-900c-4f6e-ab57-d2ff7ed4e373	2024-12-28 05:08:27.754294
d4166667-1a0c-4abb-8666-28dad554a5ab	2024-12-28 05:09:37.051458
528b4fe2-5520-4f8a-8935-97ac716461ac	2024-12-28 05:09:45.039462
6e1e4992-e5ed-4322-bf53-fa1f97234bf8	2024-12-28 05:09:56.82814
3a5c9b56-2c8b-45dc-9a6c-f0c1263422ff	2024-12-28 05:09:56.906089
af2bb67a-af24-464c-b98d-4b3ad60b3ac7	2024-12-28 05:10:12.903299
61a24207-ea54-42cb-9acc-5c8802bb8374	2024-12-28 05:10:12.978076
bf60fa33-f5a6-41ca-9956-e93cc3e567de	2024-12-28 05:11:06.285379
7b4eda6c-a754-44c7-af51-0069370e6232	2024-12-28 05:11:06.340394
8f24672f-0aab-4ea4-bc24-25c74b9fbdfa	2024-12-28 05:12:03.091229
e34669ea-13f9-476d-ae74-67d20f8f56d9	2024-12-28 05:12:03.787019
c44987a7-2c7b-4cd6-b504-ff87ea31bf36	2024-12-28 05:12:04.784244
a1f6ccee-7e73-469c-8c03-e053dade733f	2024-12-28 05:13:31.055495
6a80b6b8-8223-4843-af5d-1fbd816cff32	2024-12-28 05:15:20.078554
73ac6488-68ad-4cbd-909e-2acb2c360131	2024-12-28 05:15:29.315982
2ad333ce-b6a0-4a9b-b50f-0e2c242fd1b0	2024-12-28 05:15:29.377851
ecdf3aa4-d11c-4102-be4c-b2f5fedb325d	2024-12-28 05:17:42.094312
339b5c48-029e-4861-972f-4a939dd26f20	2024-12-28 05:17:49.219123
ecd55257-3972-483d-8c70-548610ab7e52	2024-12-28 05:17:49.264812
dff0c36c-5d52-41f7-a17b-7c860cb32b6d	2024-12-28 05:18:45.147768
4c7e46bb-bd1f-4001-9340-8b51d39e6c67	2024-12-28 05:18:46.023489
969692fd-0a71-4291-9246-b0040dbddf36	2024-12-28 05:18:46.024488
\.


--
-- TOC entry 4941 (class 0 OID 33256)
-- Dependencies: 229
-- Data for Name: wip_quotation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wip_quotation (quotation_id, card_ids, margin_ids, date_created, date_modified, customer_id) FROM stdin;
WIP_20250205_001	{}	{}	2025-02-05 23:31:03.490319	2025-02-05 23:31:03.490319	7c26b3d6-8fb7-4ceb-a210-7d9dfc93619a
WIP_20250204_001	{a43013cd-7c76-4fb8-93dd-30ca00a87a64}	{edf119ab-104a-423f-af47-46075275abed}	2025-02-04 22:16:19.800334	2025-02-04 22:16:35.849693	eb14e8a1-083f-452a-a4fc-867b30284d69
WIP_20250205_003	{}	{}	2025-02-05 23:31:39.8046	2025-02-05 23:31:39.8046	325f2724-115f-41f0-b777-180835845c47
WIP_20250204_002	{f570fdfb-244f-4477-94fd-123f97ae0bd4}	{edf119ab-104a-423f-af47-46075275abed}	2025-02-04 22:38:13.485659	2025-02-04 22:45:49.610219	a918f7d7-c84f-417e-acb6-67005fbd4e11
WIP_20250205_004	{}	{}	2025-02-05 23:31:41.15702	2025-02-05 23:31:41.15702	b21c2b00-e94c-4432-a553-adc4ba35c1ff
WIP_20250205_005	{}	{}	2025-02-05 23:31:41.318896	2025-02-05 23:31:41.318896	65f5fbca-66b0-42ac-a6fb-4bd7cd251aed
WIP_20250205_006	{}	{}	2025-02-05 23:31:41.427471	2025-02-05 23:31:41.427471	567e3a23-9eea-4137-baab-4c277e9615ed
WIP_20250215_001	{06f4ca88-f4a4-4525-8bf6-6d287d0d75b1,bf7ecc9d-f132-4a2a-80f9-5efcb89205bd,f43cdb30-831f-4a51-9c3a-1b4452a88173}	{8090e3ba-adae-4902-9aa5-71580c33f66f,d7fb4ad5-39f2-467d-8112-4267f98af8cf}	2025-02-15 18:22:29.978915	2025-03-18 20:59:31.312445	a810ec74-0f20-42ed-aaec-e3c0dfa3118f
WIP_20250205_007	{}	{}	2025-02-05 23:31:41.634749	2025-02-05 23:31:41.634749	56c7240c-cf78-4312-942e-bb5d0e024a8c
WIP_20250209_001	{bb5181f9-30dd-408a-b588-d9ebc3b1ed53}	{8090e3ba-adae-4902-9aa5-71580c33f66f}	2025-02-09 17:55:15.899218	2025-02-09 12:25:40.052206	8038dcd4-83f5-4b30-bc74-3c79dd107bf1
WIP_20250323_003_170741	{18c09ac4-30ff-428e-8bd7-34f87e9a0e9c}	{0fab6614-658c-44f5-a830-77e6e2e3530a}	2025-03-23 17:07:41.085962	2025-03-23 11:41:50.225132	81e2b516-c1d1-4b9c-900f-57bdfef029a6
WIP_20250208_001	{}	{}	2025-02-08 15:37:09.022773	2025-02-08 15:37:09.022773	3eb45629-76c5-4c69-a85f-997bc73f1761
WIP_20250128_002	{}	{}	2025-01-28 15:36:00.883675	2025-01-28 15:36:00.883675	23699638-4beb-49c2-8fcc-9c86aa83e74c
WIP_20250208_003	{}	{}	2025-02-08 16:07:11.403361	2025-02-08 16:07:11.403361	4e58ba90-472b-403c-841a-f7d3c947ffe0
WIP_20250208_004	{}	{}	2025-02-08 16:08:08.965967	2025-02-08 16:08:08.965967	62da0928-1ef0-45c1-bbb5-a1d3706918a1
WIP_20250204_003	{f818ac9e-9224-4712-a2c5-3ef887f1952b}	{3c4a948d-8117-40b6-9cdc-17f1c4942748}	2025-02-04 23:41:52.112276	2025-02-04 18:12:19.715136	0d0b5b08-a437-4eab-8558-8130dcacd3e4
WIP_20250323_001_005734	{}	{}	2025-03-23 00:57:34.911344	2025-03-23 00:57:34.911344	8e22cb9b-4ca8-438e-8d89-2e97074dd1d3
WIP_20250215_003	{c8b77d3d-a087-42a0-8e9a-dfcd521174ba}	{edf119ab-104a-423f-af47-46075275abed}	2025-02-15 18:39:32.899761	2025-02-15 13:10:06.744376	252b3a9b-010c-49d5-aeae-0534a92800c7
WIP_20250208_005	{}	{}	2025-02-08 16:12:08.050915	2025-02-08 16:12:08.050915	d08ca4a7-d34b-4989-9a6c-321ba6d5c8ea
WIP_20250331_001_104102	{}	{}	2025-03-31 10:41:02.810867	2025-03-31 10:41:02.810867	5e3afec1-3804-48c2-91d3-4f9478ac8d10
WIP_20250208_006	{}	{}	2025-02-08 16:17:37.333467	2025-02-08 16:17:37.333467	32978742-2fd8-4585-9ab2-ee2d71fa3906
WIP_20250208_007	{}	{}	2025-02-08 16:18:37.088647	2025-02-08 16:18:37.088647	20a3d651-2df0-4fe0-9b62-97ad1fb6aff6
WIP_20250208_008	{3a839133-dd0e-4ef0-b604-34c9ab657094}	{edf119ab-104a-423f-af47-46075275abed}	2025-02-08 16:24:30.482207	2025-02-08 16:24:30.482207	92d80c58-8a88-445c-a497-6a273ca4e955
WIP_20250208_009	{3a839133-dd0e-4ef0-b604-34c9ab657094}	{edf119ab-104a-423f-af47-46075275abed}	2025-02-08 16:25:04.498187	2025-02-08 16:25:04.498187	92d80c58-8a88-445c-a497-6a273ca4e955
WIP_20250208_010	{3a839133-dd0e-4ef0-b604-34c9ab657094}	{edf119ab-104a-423f-af47-46075275abed}	2025-02-08 16:25:11.349326	2025-02-08 16:25:11.349326	92d80c58-8a88-445c-a497-6a273ca4e955
WIP_20250331_003_104957	{02de8fdf-7101-4305-955c-a64303dc2130}	{}	2025-03-31 10:49:57.987324	2025-03-31 10:49:58.013866	9e7c2508-e4f1-4fee-b5e1-5d0834ec3452
WIP_20250215_004	{}	{}	2025-02-15 18:40:20.115385	2025-02-15 18:40:20.115385	82be7cd2-ef70-41dc-b07f-7c032c08e073
WIP_20250201_002	{}	{}	2025-02-01 16:17:50.045949	2025-02-01 16:17:50.045949	44768d49-5219-4458-be69-3336e73335fd
WIP_20250331_010_122659	{}	{}	2025-03-31 12:26:59.223319	2025-03-31 12:26:59.223319	d0069881-9d10-4928-b1a4-eb233a54418a
WIP_20250209_002	{4a9e1540-3d44-4ba3-a053-a165de0768f0}	{edf119ab-104a-423f-af47-46075275abed}	2025-02-09 21:10:37.015762	2025-02-09 15:41:05.68162	744038c1-c847-4af1-8d79-732e1321d529
WIP_20250331_011_123102	{}	{}	2025-03-31 12:31:02.411847	2025-03-31 12:31:02.411847	41acf85a-65f8-4c4a-a74d-f0654a134d36
WIP_20250216_003	{7d534ec5-66c2-44d5-b0a2-7fa8c8af9151,fbb594c4-1cbf-490a-a040-de474f251e35,0c9d3d1b-ad82-4e81-a589-9829c8f0a952,8ddd6bf9-016a-47ca-83b5-6fcb196e6b16}	{edf119ab-104a-423f-af47-46075275abed,7ea1fa1a-4875-4a71-8c63-52880700a71d,d7fb4ad5-39f2-467d-8112-4267f98af8cf}	2025-02-16 16:58:12.525934	2025-02-16 11:28:41.739037	adf3e7b1-8cab-43a2-9885-87f0161c726a
WIP_20250215_002	{23dc81f8-f6c0-4371-8344-2feeeda1dc48}	{d7fb4ad5-39f2-467d-8112-4267f98af8cf}	2025-02-15 18:33:14.813613	2025-02-15 13:03:46.711728	7c73c082-2226-4dc2-bbb8-d1d74ed30f66
WIP_20250331_012_123230	{}	{}	2025-03-31 12:32:30.735229	2025-03-31 12:32:30.735229	99ccb70b-5890-4436-97e0-04c5da998c56
WIP_20250216_004	{c0f47b0f-42f0-4fa0-bfe2-de90e7b9a791,a9b61162-f3e9-4055-baef-0b6fedee9e63,0e09198d-6d60-474c-a32e-a4e43cdf8bd6}	{8090e3ba-adae-4902-9aa5-71580c33f66f,76778560-92c0-4eb2-b078-71c1e8488afa,edf119ab-104a-423f-af47-46075275abed}	2025-02-16 17:00:34.732308	2025-02-16 11:31:09.205904	8585494e-b75e-43f7-992d-c295a6c3d066
WIP_20250219_001	{d8a98b29-0297-4d75-ab74-c66611e442ed,4a4736da-e5ce-468e-8e28-e71be0b764f3,80f8f15d-ef71-4550-9070-3c312bf8a010,d10d3347-50ff-462a-aaea-f5929d905fd0,ae742b62-b3d6-498f-8d32-949c3b7cc831}	{edf119ab-104a-423f-af47-46075275abed,76778560-92c0-4eb2-b078-71c1e8488afa,7ea1fa1a-4875-4a71-8c63-52880700a71d}	2025-02-19 10:38:48.797153	2025-02-19 05:09:50.549742	543f9f9d-f7a2-4e4e-9537-ac353577128e
WIP_20250216_002	{7d534ec5-66c2-44d5-b0a2-7fa8c8af9151,fbb594c4-1cbf-490a-a040-de474f251e35}	{edf119ab-104a-423f-af47-46075275abed,7ea1fa1a-4875-4a71-8c63-52880700a71d}	2025-02-16 16:31:19.459538	2025-02-16 16:31:19.459538	e4f9af0d-b1c1-4143-9a5b-eb75e574ace2
WIP_20250219_002	{1de73fd1-1cbf-448f-b00b-9046cdcd0c52,9ddb1b41-4c9d-4db1-bae7-206db7d05573}	{}	2025-02-19 18:07:25.869832	2025-02-19 19:21:20.160146	db9eee1a-d8e5-4e56-8f1d-8e0dfcc6a077
WIP_20250219_003	{}	{}	2025-02-19 21:09:05.872649	2025-02-19 21:09:05.872649	11376189-22bb-4149-a1a6-f411127e5f71
WIP_20250219_004	{}	{}	2025-02-19 21:40:34.605559	2025-02-19 21:40:34.605559	0ed20f25-cc47-4dd2-841c-502aa75a3fe6
WIP_20250219_005	{66bb6d55-9d8d-4730-b96c-4775454e1cfa,067d6729-4d95-482e-8d98-7090ad21f007}	{3c4a948d-8117-40b6-9cdc-17f1c4942748,d7fb4ad5-39f2-467d-8112-4267f98af8cf}	2025-02-19 21:42:22.96815	2025-02-19 16:39:20.091992	94f3690d-a32f-4c02-9fe3-9e658fdc014b
WIP_20250219_006	{5390c1d0-8193-4070-a526-0ce5416f9ca5}	{d7fb4ad5-39f2-467d-8112-4267f98af8cf}	2025-02-19 22:10:46.376001	2025-02-19 16:42:48.792095	b7051fe0-5595-4247-9347-92ed2d3f05d3
WIP_20250216_001	{d119c122-67b3-4fbc-8676-0f408f464b0b,334eddbf-2dc5-4fbd-a7ff-5c4637dfc19a}	{8090e3ba-adae-4902-9aa5-71580c33f66f,edf119ab-104a-423f-af47-46075275abed}	2025-02-16 16:23:18.421786	2025-03-12 17:05:45.252337	9c25c40c-61f8-4684-8d05-a84aca08863a
WIP_20250222_001	{31223a5e-73ef-468a-9840-16ff7aae32a8,b862f6f9-3bf6-411c-a3c7-428d05c1e5de}	{}	2025-02-22 11:17:40.926802	2025-02-22 11:30:51.234356	c1560c87-df66-4fe4-b93a-381dcc65cab8
WIP_20250323_002_102420	{}	{}	2025-03-23 10:24:20.670201	2025-03-23 10:24:20.670201	740badb0-8b26-4cac-90ac-e2acada3c789
WIP_20250331_014_155507	{}	{}	2025-03-31 15:55:07.392075	2025-03-31 15:55:07.392075	064332a3-664e-451f-a12a-f0ea2b376c6e
WIP_20250316_001_160008	{30522421-b1d8-4b16-b356-545885462274,3900444d-0893-4c1c-bb71-28366e8aae78,c5dd75c2-5fe7-471f-970d-91020fec7404,74bd7d04-9a0a-4e38-819d-a7628a33fd33}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-16 16:00:08.472596	2025-03-16 16:13:51.780835	74b3e83c-9b4f-460b-b3bf-139640605cd1
WIP_20250326_001_173523	{4d164f4a-44d1-4ae9-acf2-05c2be69ec8c,78ade88d-fef8-4ba8-9617-fa28fece0040,7f68e34e-53d9-4976-ac31-bc71e14e57cb,415863b5-c5a8-4188-85c8-b2229fd8fe86,2e54a4a2-6e8a-49f3-83b6-e48288805b14,7d249169-f84f-407f-9d61-84279556b02f,35aa61dc-c2f1-4919-9685-0a42838f3276}	{7ea1fa1a-4875-4a71-8c63-52880700a71d,8090e3ba-adae-4902-9aa5-71580c33f66f,edf119ab-104a-423f-af47-46075275abed,d7fb4ad5-39f2-467d-8112-4267f98af8cf}	2025-03-26 17:35:23.664996	2025-03-26 18:04:51.425622	5d3c65fc-86b7-4d26-a00b-1103153932d6
WIP_20250331_016_170430	{b65a9899-b24b-455e-90ec-749d9b2da77f,04c6ffdd-6809-41ea-8d6a-a54cd7419434,639cbb48-4559-42f0-9c6c-576e1e82b594,bbaa9908-92ba-4739-8c4a-d0459dc6a98c}	{d7fb4ad5-39f2-467d-8112-4267f98af8cf,edf119ab-104a-423f-af47-46075275abed}	2025-03-31 17:04:30.305902	2025-03-31 17:04:42.319783	38376791-328a-4c3f-a05b-4a52065241ff
WIP_20250222_002	{6dc5b642-92d2-49d2-b74f-01de91c46b94,3d015cd7-e358-4ada-bd7c-9394acf9dd0b,e85aefd9-7407-46ad-bf86-ac04987b6932}	{}	2025-02-22 11:37:06.293772	2025-02-22 11:54:48.858678	f31bf4bf-6607-48c3-9388-b6ad17bab601
WIP_20250222_003	{}	{}	2025-02-22 15:58:20.211992	2025-02-22 15:58:20.211992	c12a5806-23e6-49e6-9b0f-766a266aef35
WIP_20250223_001	{}	{}	2025-02-23 23:15:54.009113	2025-02-23 23:15:54.009113	82eacadd-19ea-4b5e-8a24-f52c7cb87b7b
WIP_20250226_001	{}	{}	2025-02-26 11:18:12.22325	2025-02-26 11:18:12.22325	d617cf2d-55a0-4209-a94c-2419a23a34df
WIP_20250226_002	{}	{}	2025-02-26 11:24:39.742503	2025-02-26 11:24:39.742503	8243ca54-532b-49d7-abe6-5a675f040dc7
WIP_20250227_001	{}	{}	2025-02-27 21:12:42.498318	2025-02-27 21:12:42.498318	90c4f170-49a5-4d2e-ae5a-55a18f8e5e31
WIP_20250301_001	{}	{}	2025-03-01 12:14:23.347849	2025-03-01 12:14:23.347849	a1f616d6-afc2-4083-9132-050fddca711a
WIP_20250301_002	{NULL,dc36d6ff-eb30-4fea-b2fe-b88e95b630a7,536761f5-213a-4f4e-9239-83b94c983ff7}	{}	2025-03-01 13:06:30.263883	2025-03-01 15:31:57.210904	9bb94aa9-45b8-4d48-81af-6747e0a55e4a
WIP_20250301_003	{dd386e6f-8f6b-4ec3-97b7-b7c8abb778e9}	{d7fb4ad5-39f2-467d-8112-4267f98af8cf}	2025-03-01 16:50:39.318274	2025-03-01 11:20:49.646965	c2233ddf-a82f-4e10-8c6b-b2b3569da93f
WIP_20250305_001_152248	{36c406c0-4da1-452c-a2a7-eb7e1d3a38aa}	{}	2025-03-05 15:22:48.037543	2025-03-05 15:23:02.949965	d75eee65-7f44-4389-a5f4-2cbdd8a1547c
WIP_20250331_015_161306	{93c2132e-bb1a-4319-b26e-5ad63e718a9a}	{edf119ab-104a-423f-af47-46075275abed}	2025-03-31 16:13:06.427708	2025-03-31 16:13:06.427708	7d46f937-8409-4160-b993-ccabdb8429a4
WIP_20250331_002_104940	{}	{}	2025-03-31 10:49:40.109382	2025-03-31 10:49:40.109382	62a096f2-8fa4-44f3-b88c-b6f34c7d7b1f
WIP_20250331_004_105025	{d334232f-4f09-414c-884c-d9dac25eca6d}	{}	2025-03-31 10:50:25.011725	2025-03-31 10:50:25.03683	7311ca5d-f7b0-47c3-abb8-aa858ffbf589
WIP_20250331_005_122417	{f5a999d5-7223-4264-a3db-be05c58b1a53}	{}	2025-03-31 12:24:17.904907	2025-03-31 12:24:17.956888	984c7288-17f3-4101-9fb6-4409563611ce
WIP_20250331_006_122450	{}	{}	2025-03-31 12:24:50.115552	2025-03-31 12:24:50.115552	8dadcb95-3c9e-462d-913c-0b368f5801e2
WIP_20250315_002_141718	{}	{}	2025-03-15 14:17:18.379698	2025-03-15 14:17:18.379698	7c915288-46ad-4002-9435-3eb05d67fd72
WIP_20250315_003_141722	{}	{}	2025-03-15 14:17:22.78705	2025-03-15 14:17:22.78705	c094a5d2-2b99-4027-b2f8-693c148b9847
WIP_20250331_007_122527	{}	{}	2025-03-31 12:25:27.012799	2025-03-31 12:25:27.012799	e80d625f-00a6-4f1d-ae06-6235e88b14a7
WIP_20250331_008_122552	{}	{}	2025-03-31 12:25:52.39387	2025-03-31 12:25:52.39387	4e9ea0e8-33d2-46f0-902a-57eabece8bb5
WIP_20250331_009_122610	{}	{}	2025-03-31 12:26:10.404618	2025-03-31 12:26:10.404618	4ce0dea3-52bc-47b2-a4ed-891265894131
WIP_20250331_013_125936	{}	{}	2025-03-31 12:59:36.88063	2025-03-31 12:59:36.88063	76bd1a3e-5b6f-4f81-aa0f-925239dfa9d5
\.


--
-- TOC entry 4955 (class 0 OID 0)
-- Dependencies: 224
-- Name: additem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.additem_id_seq', 179, true);


--
-- TOC entry 4956 (class 0 OID 0)
-- Dependencies: 219
-- Name: item_pricing_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.item_pricing_id_seq', 34, true);


--
-- TOC entry 4957 (class 0 OID 0)
-- Dependencies: 217
-- Name: items_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.items_item_id_seq', 531, true);


--
-- TOC entry 4958 (class 0 OID 0)
-- Dependencies: 226
-- Name: pickmargin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pickmargin_id_seq', 10, true);


--
-- TOC entry 4959 (class 0 OID 0)
-- Dependencies: 221
-- Name: quotation_items_quotation_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.quotation_items_quotation_items_id_seq', 16, true);


--
-- TOC entry 4769 (class 2606 OID 24922)
-- Name: additem additem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.additem
    ADD CONSTRAINT additem_pkey PRIMARY KEY (id);


--
-- TOC entry 4773 (class 2606 OID 33233)
-- Name: cards cards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards
    ADD CONSTRAINT cards_pkey PRIMARY KEY (card_id);


--
-- TOC entry 4779 (class 2606 OID 33353)
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customer_id);


--
-- TOC entry 4781 (class 2606 OID 33521)
-- Name: final_quotation final_quotation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.final_quotation
    ADD CONSTRAINT final_quotation_pkey PRIMARY KEY (quotation_id);


--
-- TOC entry 4763 (class 2606 OID 24795)
-- Name: item_pricing item_pricing_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_pricing
    ADD CONSTRAINT item_pricing_pkey PRIMARY KEY (id);


--
-- TOC entry 4761 (class 2606 OID 24779)
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (item_id);


--
-- TOC entry 4777 (class 2606 OID 33342)
-- Name: margin margin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.margin
    ADD CONSTRAINT margin_pkey PRIMARY KEY (margin_id);


--
-- TOC entry 4767 (class 2606 OID 24943)
-- Name: pickmargin pickmargin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pickmargin
    ADD CONSTRAINT pickmargin_pkey PRIMARY KEY (id);


--
-- TOC entry 4765 (class 2606 OID 24882)
-- Name: quotation_items quotation_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotation_items
    ADD CONSTRAINT quotation_items_pkey PRIMARY KEY (quotation_items_id);


--
-- TOC entry 4771 (class 2606 OID 24987)
-- Name: quotations quotations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_pkey PRIMARY KEY (id);


--
-- TOC entry 4775 (class 2606 OID 33264)
-- Name: wip_quotation wip_quotation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wip_quotation
    ADD CONSTRAINT wip_quotation_pkey PRIMARY KEY (quotation_id);


--
-- TOC entry 4783 (class 2620 OID 33523)
-- Name: final_quotation update_final_quotation_modified; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_final_quotation_modified BEFORE UPDATE ON public.final_quotation FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();


--
-- TOC entry 4782 (class 2606 OID 24888)
-- Name: quotation_items fk_item_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotation_items
    ADD CONSTRAINT fk_item_id FOREIGN KEY (item_id) REFERENCES public.items(item_id);


-- Completed on 2025-04-27 12:03:29

--
-- PostgreSQL database dump complete
--

