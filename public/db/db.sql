--
-- PostgreSQL database dump
--

-- Dumped from database version 14.8
-- Dumped by pg_dump version 14.8

-- Started on 2023-09-04 16:23:59

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

--
-- TOC entry 3 (class 2615 OID 24727)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 3430 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 233 (class 1255 OID 24728)
-- Name: adjust_stocks_from_sales(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.adjust_stocks_from_sales() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   
        INSERT INTO stock_transactions (product_id, quantity, transaction_type,new_stocks)
        VALUES (NEW.product_id, NEW.quantity, 'SALES',(select 
    (p.initial_stocks + (select coalesce(sum(po.output_quantity),0) as in from production_outputs po where po.product_id = p.product_id) -
    (select coalesce(sum(si.quantity), 0) as out from sales_items si where si.product_id = p.product_id) - 
     (select coalesce(sum(rp.quantity), 0) as repros from repro_products rp where rp.product_id = p.product_id)) as current_stocks
    from products p where p.product_id = new.product_id limit 1));

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.adjust_stocks_from_sales() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 230 (class 1259 OID 33051)
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customer_id integer NOT NULL,
    customer_name character varying NOT NULL
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 33050)
-- Name: customers_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customers_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customers_customer_id_seq OWNER TO postgres;

--
-- TOC entry 3431 (class 0 OID 0)
-- Dependencies: 229
-- Name: customers_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_customer_id_seq OWNED BY public.customers.customer_id;


--
-- TOC entry 209 (class 1259 OID 24729)
-- Name: delivered_packagings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.delivered_packagings (
    id bigint NOT NULL,
    packaging_id integer NOT NULL,
    delivered_quantity integer NOT NULL,
    date_delivered character varying NOT NULL
);


ALTER TABLE public.delivered_packagings OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 24734)
-- Name: delivered_packagings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.delivered_packagings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.delivered_packagings_id_seq OWNER TO postgres;

--
-- TOC entry 3432 (class 0 OID 0)
-- Dependencies: 210
-- Name: delivered_packagings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.delivered_packagings_id_seq OWNED BY public.delivered_packagings.id;


--
-- TOC entry 232 (class 1259 OID 41243)
-- Name: packaging_adjustments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.packaging_adjustments (
    id integer NOT NULL,
    packaging_id integer NOT NULL,
    adjustment_value integer NOT NULL,
    date_adjusted character varying,
    reason_for_adjustment character varying
);


ALTER TABLE public.packaging_adjustments OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 41242)
-- Name: packaging_adjustments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.packaging_adjustments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.packaging_adjustments_id_seq OWNER TO postgres;

--
-- TOC entry 3433 (class 0 OID 0)
-- Dependencies: 231
-- Name: packaging_adjustments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.packaging_adjustments_id_seq OWNED BY public.packaging_adjustments.id;


--
-- TOC entry 211 (class 1259 OID 24735)
-- Name: packagings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.packagings (
    packaging_id bigint NOT NULL,
    packaging_name character varying,
    initial_stocks bigint
);


ALTER TABLE public.packagings OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 24740)
-- Name: packagings_packaging_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.packagings_packaging_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.packagings_packaging_id_seq OWNER TO postgres;

--
-- TOC entry 3434 (class 0 OID 0)
-- Dependencies: 212
-- Name: packagings_packaging_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.packagings_packaging_id_seq OWNED BY public.packagings.packaging_id;


--
-- TOC entry 213 (class 1259 OID 24741)
-- Name: product_sales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_sales (
    customer_name character varying NOT NULL,
    "createdAt" character varying,
    sales_id bigint NOT NULL,
    "updatedAt" character varying,
    customer_id integer
);


ALTER TABLE public.product_sales OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 24746)
-- Name: product_sales_sales_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_sales_sales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_sales_sales_id_seq OWNER TO postgres;

--
-- TOC entry 3435 (class 0 OID 0)
-- Dependencies: 214
-- Name: product_sales_sales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_sales_sales_id_seq OWNED BY public.product_sales.sales_id;


--
-- TOC entry 215 (class 1259 OID 24747)
-- Name: production_outputs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.production_outputs (
    production_id bigint NOT NULL,
    product_id integer NOT NULL,
    output_quantity integer NOT NULL,
    damaged_packaging integer,
    production_date character varying NOT NULL
);


ALTER TABLE public.production_outputs OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 24752)
-- Name: production_outputs_production_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.production_outputs_production_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.production_outputs_production_id_seq OWNER TO postgres;

--
-- TOC entry 3436 (class 0 OID 0)
-- Dependencies: 216
-- Name: production_outputs_production_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.production_outputs_production_id_seq OWNED BY public.production_outputs.production_id;


--
-- TOC entry 217 (class 1259 OID 24753)
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    product_id integer NOT NULL,
    product_name character varying,
    initial_stocks integer NOT NULL,
    packaging_size numeric
);


ALTER TABLE public.products OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 24758)
-- Name: products_product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.products_product_id_seq OWNER TO postgres;

--
-- TOC entry 3437 (class 0 OID 0)
-- Dependencies: 218
-- Name: products_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_product_id_seq OWNED BY public.products.product_id;


--
-- TOC entry 219 (class 1259 OID 24759)
-- Name: released_packagings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.released_packagings (
    id bigint NOT NULL,
    packaging_id bigint NOT NULL,
    quantity_released bigint NOT NULL,
    date_released character varying,
    released_for character varying
);


ALTER TABLE public.released_packagings OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 24764)
-- Name: released_packagings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.released_packagings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.released_packagings_id_seq OWNER TO postgres;

--
-- TOC entry 3438 (class 0 OID 0)
-- Dependencies: 220
-- Name: released_packagings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.released_packagings_id_seq OWNED BY public.released_packagings.id;


--
-- TOC entry 221 (class 1259 OID 24765)
-- Name: repro_products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.repro_products (
    id bigint NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    reason character varying
);


ALTER TABLE public.repro_products OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 24770)
-- Name: repro_products_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.repro_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.repro_products_id_seq OWNER TO postgres;

--
-- TOC entry 3439 (class 0 OID 0)
-- Dependencies: 222
-- Name: repro_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.repro_products_id_seq OWNED BY public.repro_products.id;


--
-- TOC entry 223 (class 1259 OID 24771)
-- Name: returned_packagings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.returned_packagings (
    id bigint NOT NULL,
    packaging_id integer NOT NULL,
    quantity_returned integer NOT NULL,
    returned_date character varying NOT NULL
);


ALTER TABLE public.returned_packagings OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 24776)
-- Name: returned_packagings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.returned_packagings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.returned_packagings_id_seq OWNER TO postgres;

--
-- TOC entry 3440 (class 0 OID 0)
-- Dependencies: 224
-- Name: returned_packagings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.returned_packagings_id_seq OWNED BY public.returned_packagings.id;


--
-- TOC entry 225 (class 1259 OID 24777)
-- Name: sales_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales_items (
    sales_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    sales_item_id bigint NOT NULL
);


ALTER TABLE public.sales_items OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 24780)
-- Name: sales_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sales_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sales_items_id_seq OWNER TO postgres;

--
-- TOC entry 3441 (class 0 OID 0)
-- Dependencies: 226
-- Name: sales_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sales_items_id_seq OWNED BY public.sales_items.sales_item_id;


--
-- TOC entry 227 (class 1259 OID 24781)
-- Name: stocks_flow; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stocks_flow (
    id integer NOT NULL,
    product_id integer,
    update_type character varying NOT NULL,
    quantity integer NOT NULL,
    new_quantity integer,
    update_key character varying
);


ALTER TABLE public.stocks_flow OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 24786)
-- Name: stocks_flow_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stocks_flow_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stocks_flow_id_seq OWNER TO postgres;

--
-- TOC entry 3442 (class 0 OID 0)
-- Dependencies: 228
-- Name: stocks_flow_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stocks_flow_id_seq OWNED BY public.stocks_flow.id;


--
-- TOC entry 3230 (class 2604 OID 33054)
-- Name: customers customer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN customer_id SET DEFAULT nextval('public.customers_customer_id_seq'::regclass);


--
-- TOC entry 3220 (class 2604 OID 24787)
-- Name: delivered_packagings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivered_packagings ALTER COLUMN id SET DEFAULT nextval('public.delivered_packagings_id_seq'::regclass);


--
-- TOC entry 3231 (class 2604 OID 41246)
-- Name: packaging_adjustments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.packaging_adjustments ALTER COLUMN id SET DEFAULT nextval('public.packaging_adjustments_id_seq'::regclass);


--
-- TOC entry 3221 (class 2604 OID 24788)
-- Name: packagings packaging_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.packagings ALTER COLUMN packaging_id SET DEFAULT nextval('public.packagings_packaging_id_seq'::regclass);


--
-- TOC entry 3222 (class 2604 OID 24789)
-- Name: product_sales sales_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_sales ALTER COLUMN sales_id SET DEFAULT nextval('public.product_sales_sales_id_seq'::regclass);


--
-- TOC entry 3223 (class 2604 OID 24790)
-- Name: production_outputs production_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.production_outputs ALTER COLUMN production_id SET DEFAULT nextval('public.production_outputs_production_id_seq'::regclass);


--
-- TOC entry 3224 (class 2604 OID 24791)
-- Name: products product_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN product_id SET DEFAULT nextval('public.products_product_id_seq'::regclass);


--
-- TOC entry 3225 (class 2604 OID 24792)
-- Name: released_packagings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.released_packagings ALTER COLUMN id SET DEFAULT nextval('public.released_packagings_id_seq'::regclass);


--
-- TOC entry 3226 (class 2604 OID 24793)
-- Name: repro_products id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repro_products ALTER COLUMN id SET DEFAULT nextval('public.repro_products_id_seq'::regclass);


--
-- TOC entry 3227 (class 2604 OID 24794)
-- Name: returned_packagings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.returned_packagings ALTER COLUMN id SET DEFAULT nextval('public.returned_packagings_id_seq'::regclass);


--
-- TOC entry 3228 (class 2604 OID 24795)
-- Name: sales_items sales_item_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_items ALTER COLUMN sales_item_id SET DEFAULT nextval('public.sales_items_id_seq'::regclass);


--
-- TOC entry 3229 (class 2604 OID 24796)
-- Name: stocks_flow id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stocks_flow ALTER COLUMN id SET DEFAULT nextval('public.stocks_flow_id_seq'::regclass);


--
-- TOC entry 3422 (class 0 OID 33051)
-- Dependencies: 230
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.customers VALUES (1, 'NOEL AFRICA');
INSERT INTO public.customers VALUES (2, 'RONNEL MATIBAG');
INSERT INTO public.customers VALUES (3, 'TONY HERNANDEZ');
INSERT INTO public.customers VALUES (4, 'KKM');
INSERT INTO public.customers VALUES (5, 'CLDS CORP.');
INSERT INTO public.customers VALUES (6, 'RAPHAEL DELA CRUZ');
INSERT INTO public.customers VALUES (7, 'PAUL CAGUING');
INSERT INTO public.customers VALUES (8, 'ELMER ANTALLAN');
INSERT INTO public.customers VALUES (9, 'JULIUS JASA');
INSERT INTO public.customers VALUES (10, 'SANI');
INSERT INTO public.customers VALUES (11, 'AVENIDA VERDE');


--
-- TOC entry 3401 (class 0 OID 24729)
-- Dependencies: 209
-- Data for Name: delivered_packagings; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.delivered_packagings VALUES (2, 4, 19850, '05/03/2023');
INSERT INTO public.delivered_packagings VALUES (6, 1, 6614, '05/04/2023');
INSERT INTO public.delivered_packagings VALUES (7, 1, 10610, '06/30/2023');


--
-- TOC entry 3424 (class 0 OID 41243)
-- Dependencies: 232
-- Data for Name: packaging_adjustments; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3403 (class 0 OID 24735)
-- Dependencies: 211
-- Data for Name: packagings; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.packagings VALUES (1, 'DOGGY WOGGY ADULT LAMINATED SACKS', 3730);
INSERT INTO public.packagings VALUES (2, 'PLASTIC 24x36 (FLEXI)', 7374);
INSERT INTO public.packagings VALUES (3, 'PLASTIC 24x36 (LABO)', 1976);
INSERT INTO public.packagings VALUES (5, 'PLASTIC 18.5x28', 17765);
INSERT INTO public.packagings VALUES (4, 'PLASTIC 22x33', 1531);
INSERT INTO public.packagings VALUES (7, 'KRAFT BAG WHITE 18x5x35', 694);
INSERT INTO public.packagings VALUES (6, 'DOGGY WOGGY PUPPY LAMINATED SACKS', 1000);
INSERT INTO public.packagings VALUES (8, 'PIGLET BOOSTER', 6115);


--
-- TOC entry 3405 (class 0 OID 24741)
-- Dependencies: 213
-- Data for Name: product_sales; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-05-19 16:44:32.545 +08:00', 41, '2023-05-19 16:44:32.545 +08:00', 2);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-05-20 08:25:49.222 +08:00', 42, '2023-05-20 08:25:49.222 +08:00', 2);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-05-22 17:28:40.762 +08:00', 49, '2023-05-22 17:28:40.762 +08:00', 2);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-05-24 16:33:48.484 +08:00', 58, '2023-05-24 16:33:48.484 +08:00', 2);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-05-30 16:02:27.898 +08:00', 74, '2023-05-30 16:02:27.898 +08:00', 2);
INSERT INTO public.product_sales VALUES ('PRODUCTION DEPARTMENT', '2023-05-22 11:25:54.336 +08:00', 46, '2023-05-22 11:25:54.336 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-06-01 16:37:33.753 +08:00', 84, '2023-06-01 16:37:33.753 +08:00', 2);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-06-06 08:14:23.492 +08:00', 91, '2023-06-06 08:14:23.492 +08:00', 2);
INSERT INTO public.product_sales VALUES ('PUAL CAGUING', '2023-05-23 16:42:02.043 +08:00', 53, '2023-05-23 16:42:02.043 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('EMMANUEL MANALANG', '2023-05-24 11:07:52.053 +08:00', 54, '2023-05-24 11:07:52.053 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-06-06 16:17:20.320 +08:00', 95, '2023-06-06 16:17:20.320 +08:00', 2);
INSERT INTO public.product_sales VALUES ('NUGOLD', '2023-05-24 11:55:16.969 +08:00', 56, '2023-05-24 11:55:16.969 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('AVENIDA', '2023-05-25 08:23:38.028 +08:00', 59, '2023-05-25 08:23:38.028 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NIÑO ARAÑO', '2023-05-25 08:33:20.205 +08:00', 60, '2023-05-25 08:33:20.205 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-06-13 08:22:54.795 +08:00', 105, '2023-06-13 08:22:54.795 +08:00', 2);
INSERT INTO public.product_sales VALUES ('TONY HERNANDEZ', '2023-05-24 16:33:12.925 +08:00', 57, '2023-05-24 16:33:12.925 +08:00', 3);
INSERT INTO public.product_sales VALUES ('MARVIN CARANDANG', '2023-05-26 10:35:14.101 +08:00', 64, '2023-05-26 10:35:14.101 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('JULIUS JASA', '2023-05-27 08:54:14.816 +08:00', 65, '2023-05-27 08:54:14.816 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('TONY HERNANDEZ', '2023-06-02 16:33:38.712 +08:00', 86, '2023-06-02 16:33:38.712 +08:00', 3);
INSERT INTO public.product_sales VALUES ('KKM', '2023-05-23 16:37:04.839 +08:00', 52, '2023-05-23 16:37:04.839 +08:00', 4);
INSERT INTO public.product_sales VALUES ('KKM', '2023-05-31 14:53:26.880 +08:00', 80, '2023-05-31 14:53:26.880 +08:00', 4);
INSERT INTO public.product_sales VALUES ('RAPHAEL DELA CRUZ', '2023-05-25 10:50:46.082 +08:00', 62, '2023-05-25 10:50:46.082 +08:00', 6);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '05/18/2023', 28, NULL, 7);
INSERT INTO public.product_sales VALUES ('CASH SALES', '2023-06-01 09:52:26.815 +08:00', 81, '2023-06-01 09:52:26.815 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-05-27 11:26:22.921 +08:00', 67, '2023-05-27 11:26:22.921 +08:00', 7);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-05-31 09:32:36.865 +08:00', 75, '2023-05-31 09:32:36.865 +08:00', 7);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-06-07 16:29:51.629 +08:00', 99, '2023-06-07 16:29:51.629 +08:00', 7);
INSERT INTO public.product_sales VALUES ('CASH SALES', '2023-06-03 11:25:14.045 +08:00', 87, '2023-06-03 11:25:14.045 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NIÑO ARAÑO', '2023-06-05 08:35:23.089 +08:00', 88, '2023-06-05 08:35:23.089 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-05-20 11:04:38.323 +08:00', 44, '2023-05-20 11:04:38.323 +08:00', 8);
INSERT INTO public.product_sales VALUES ('PAU CAGUING', '2023-06-06 08:12:43.285 +08:00', 90, '2023-06-06 08:12:43.285 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-05-29 13:36:57.509 +08:00', 70, '2023-05-29 13:36:57.509 +08:00', 8);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-06-06 08:14:54.309 +08:00', 92, '2023-06-06 08:14:54.309 +08:00', 8);
INSERT INTO public.product_sales VALUES ('SANI', '2023-05-22 18:04:03.127 +08:00', 50, '2023-05-22 18:04:03.127 +08:00', 10);
INSERT INTO public.product_sales VALUES ('SANI', '2023-05-30 14:44:56.895 +08:00', 73, '2023-05-30 14:44:56.895 +08:00', 10);
INSERT INTO public.product_sales VALUES ('AVENIDA VERDE', '2023-05-22 17:28:19.788 +08:00', 48, '2023-05-22 17:28:19.788 +08:00', 11);
INSERT INTO public.product_sales VALUES ('AVENIDA VERDE', '2023-05-27 09:45:11.568 +08:00', 66, '2023-05-27 09:45:11.568 +08:00', 11);
INSERT INTO public.product_sales VALUES ('AVENIDA VERDE', '2023-05-29 14:44:17.374 +08:00', 71, '2023-05-29 14:44:17.374 +08:00', 11);
INSERT INTO public.product_sales VALUES ('AVENIDA VERDE', '2023-05-31 14:04:24.885 +08:00', 78, '2023-05-31 14:04:24.885 +08:00', 11);
INSERT INTO public.product_sales VALUES ('CASH SALES', '2023-06-13 14:38:14.904 +08:00', 108, '2023-06-13 14:38:14.904 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-23 11:35:16.886 +08:00', 398, '2023-08-23 11:35:16.886 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('CLDS CORP.', '2023-08-24 13:54:37.589 +08:00', 404, '2023-08-24 13:54:37.589 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-08-26 08:28:02.725 +08:00', 410, '2023-08-26 08:28:02.725 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-08-26 11:30:44.164 +08:00', 416, '2023-08-26 11:30:44.164 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-29 10:09:56.487 +08:00', 418, '2023-08-29 10:09:56.487 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('KKM', '2023-08-30 14:19:38.726 +08:00', 424, '2023-08-30 14:19:38.726 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-09-01 10:03:09.088 +08:00', 430, '2023-09-01 10:03:09.088 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-09-02 10:28:39.099 +08:00', 436, '2023-09-02 10:28:39.099 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('DOC MANNY', '2023-09-04 09:49:00.368 +08:00', 438, '2023-09-04 09:49:00.368 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('LAKAL', '2023-06-14 08:21:01.110 +08:00', 114, '2023-06-14 08:21:01.110 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('CLDS CORPORATION', '2023-06-14 13:38:25.485 +08:00', 117, '2023-06-14 13:38:25.485 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-06-14 08:13:09.569 +08:00', 111, '2023-06-14 08:13:09.569 +08:00', 2);
INSERT INTO public.product_sales VALUES ('NUGOLD', '2023-06-15 11:20:38.918 +08:00', 120, '2023-06-15 11:20:38.918 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('DOC MANNY', '2023-06-15 11:32:19.882 +08:00', 121, '2023-06-15 11:32:19.882 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-06-16 16:30:24.288 +08:00', 128, '2023-06-16 16:30:24.288 +08:00', 2);
INSERT INTO public.product_sales VALUES ('CASH SALES', '2023-06-15 15:56:46.817 +08:00', 124, '2023-06-15 15:56:46.817 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-06-20 08:35:54.840 +08:00', 168, '2023-06-20 08:35:54.840 +08:00', 2);
INSERT INTO public.product_sales VALUES ('MARVIN CARANDANG', '2023-06-16 13:29:54.323 +08:00', 126, '2023-06-16 13:29:54.323 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-06-23 15:06:23.248 +08:00', 202, '2023-06-23 15:06:23.248 +08:00', 2);
INSERT INTO public.product_sales VALUES ('NUGOLD ', '2023-06-16 17:01:18.270 +08:00', 129, '2023-06-16 17:01:18.270 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-06-24 09:07:08.384 +08:00', 206, '2023-06-24 09:07:08.384 +08:00', 2);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-06-26 16:46:52.467 +08:00', 214, '2023-06-26 16:46:52.467 +08:00', 2);
INSERT INTO public.product_sales VALUES ('CLDS', '2023-06-20 08:04:41.160 +08:00', 167, '2023-06-20 08:04:41.160 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-07-01 09:35:40.271 +08:00', 227, '2023-07-01 09:35:40.271 +08:00', 2);
INSERT INTO public.product_sales VALUES ('TONY HERNANDEZ', '2023-06-14 08:13:36.588 +08:00', 112, '2023-06-14 08:13:36.588 +08:00', 3);
INSERT INTO public.product_sales VALUES ('TONY HERNANDEZ', '2023-06-17 11:55:02.694 +08:00', 132, '2023-06-17 11:55:02.694 +08:00', 3);
INSERT INTO public.product_sales VALUES ('TONY HERNANDEZ', '2023-06-30 16:52:06.454 +08:00', 226, '2023-06-30 16:52:06.454 +08:00', 3);
INSERT INTO public.product_sales VALUES ('KKM', '2023-06-20 15:15:28.403 +08:00', 170, '2023-06-20 15:15:28.403 +08:00', 4);
INSERT INTO public.product_sales VALUES ('KKM', '2023-06-26 14:31:38.092 +08:00', 213, '2023-06-26 14:31:38.092 +08:00', 4);
INSERT INTO public.product_sales VALUES ('KKM', '2023-06-29 14:38:18.350 +08:00', 221, '2023-06-29 14:38:18.350 +08:00', 4);
INSERT INTO public.product_sales VALUES ('CLDS CORP.', '2023-07-04 09:51:27.843 +08:00', 235, '2023-07-04 09:51:27.843 +08:00', 5);
INSERT INTO public.product_sales VALUES ('SIR RAPHY', '2023-06-15 09:30:56.750 +08:00', 119, '2023-06-15 09:30:56.750 +08:00', 6);
INSERT INTO public.product_sales VALUES ('NIÑO ARAÑO', '2023-06-26 08:19:54.396 +08:00', 209, '2023-06-26 08:19:54.396 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-06-13 14:38:34.419 +08:00', 109, '2023-06-13 14:38:34.419 +08:00', 7);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-06-17 08:51:49.412 +08:00', 130, '2023-06-17 08:51:49.412 +08:00', 7);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-06-21 12:42:07.855 +08:00', 174, '2023-06-21 12:42:07.855 +08:00', 7);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-06-27 16:28:49.653 +08:00', 217, '2023-06-27 16:28:49.653 +08:00', 7);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-06-27 16:52:06.919 +08:00', 218, '2023-06-27 16:52:06.919 +08:00', 7);
INSERT INTO public.product_sales VALUES ('CLDS CORPORATION', '2023-06-30 08:25:50.010 +08:00', 222, '2023-06-30 08:25:50.010 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-07-01 09:36:06.673 +08:00', 228, '2023-07-01 09:36:06.673 +08:00', 7);
INSERT INTO public.product_sales VALUES ('CASH SALES', '2023-06-30 13:29:45.539 +08:00', 225, '2023-06-30 13:29:45.539 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-06-13 14:38:57.375 +08:00', 110, '2023-06-13 14:38:57.375 +08:00', 8);
INSERT INTO public.product_sales VALUES ('CASH SALES', '2023-07-03 10:02:48.066 +08:00', 231, '2023-07-03 10:02:48.066 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-06-17 11:23:15.871 +08:00', 131, '2023-06-17 11:23:15.871 +08:00', 8);
INSERT INTO public.product_sales VALUES ('DOC MANNY', '2023-07-03 10:03:16.402 +08:00', 233, '2023-07-03 10:03:16.402 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-06-23 13:16:48.214 +08:00', 183, '2023-06-23 13:16:48.214 +08:00', 8);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-06-30 09:49:44.020 +08:00', 224, '2023-06-30 09:49:44.020 +08:00', 8);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-07-04 12:45:15.374 +08:00', 237, '2023-07-04 12:45:15.374 +08:00', 8);
INSERT INTO public.product_sales VALUES ('SANI', '2023-07-01 09:37:06.655 +08:00', 229, '2023-07-01 09:37:06.655 +08:00', 10);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-08-26 11:30:59.939 +08:00', 417, '2023-08-26 11:30:59.939 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('SANI', '2023-08-29 16:51:04.729 +08:00', 419, '2023-08-29 16:51:04.729 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('CLDS CORP.', '2023-08-30 16:14:29.783 +08:00', 425, '2023-08-30 16:14:29.783 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-09-01 16:03:25.419 +08:00', 431, '2023-09-01 16:03:25.419 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('AVENIDA VERDE', '2023-06-15 11:34:05.463 +08:00', 123, '2023-06-15 11:34:05.463 +08:00', 11);
INSERT INTO public.product_sales VALUES ('AVENIDA VERDE', '2023-06-24 10:45:22.431 +08:00', 207, '2023-06-24 10:45:22.431 +08:00', 11);
INSERT INTO public.product_sales VALUES ('AVENIDA VERDE', '2023-06-26 11:05:40.430 +08:00', 211, '2023-06-26 11:05:40.430 +08:00', 11);
INSERT INTO public.product_sales VALUES ('AVENIDA VERDE', '2023-06-29 14:16:10.791 +08:00', 220, '2023-06-29 14:16:10.791 +08:00', 11);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-08-24 08:51:19.061 +08:00', 399, '2023-08-24 08:51:19.061 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('EMMANUEL MANALANG', '2023-08-25 10:28:11.159 +08:00', 405, '2023-08-25 10:28:11.159 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-26 09:57:36.002 +08:00', 411, '2023-08-26 09:57:36.002 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-09-02 11:51:32.588 +08:00', 437, '2023-09-02 11:51:32.588 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-09-04 10:27:12.981 +08:00', 439, '2023-09-04 10:27:12.981 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-07-04 14:51:47.994 +08:00', 239, '2023-07-04 14:51:47.994 +08:00', 2);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-07-05 16:47:26.295 +08:00', 243, '2023-07-05 16:47:26.295 +08:00', 2);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-07-14 16:46:20.035 +08:00', 266, '2023-07-14 16:46:20.035 +08:00', 2);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-07-17 08:35:27.178 +08:00', 269, '2023-07-17 08:35:27.178 +08:00', 2);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-07-17 08:35:44.611 +08:00', 270, '2023-07-17 08:35:44.611 +08:00', 2);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-07-24 15:58:30.557 +08:00', 302, '2023-07-24 15:58:30.557 +08:00', 2);
INSERT INTO public.product_sales VALUES ('NUGOLD ', '2023-07-08 09:35:05.292 +08:00', 249, '2023-07-08 09:35:05.292 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-07-24 15:58:42.699 +08:00', 303, '2023-07-24 15:58:42.699 +08:00', 2);
INSERT INTO public.product_sales VALUES ('TONY HERNANDEZ', '2023-07-06 16:28:35.411 +08:00', 245, '2023-07-06 16:28:35.411 +08:00', 3);
INSERT INTO public.product_sales VALUES ('TONY HERNANDEZ', '2023-07-14 17:08:42.760 +08:00', 267, '2023-07-14 17:08:42.760 +08:00', 3);
INSERT INTO public.product_sales VALUES ('TONY HERNANDEZ', '2023-07-24 16:27:46.836 +08:00', 304, '2023-07-24 16:27:46.836 +08:00', 3);
INSERT INTO public.product_sales VALUES ('CASH SALES', '2023-07-13 09:24:59.920 +08:00', 257, '2023-07-13 09:24:59.920 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('KKM', '2023-07-13 16:45:20.332 +08:00', 262, '2023-07-13 16:45:20.332 +08:00', 4);
INSERT INTO public.product_sales VALUES ('KKM', '2023-07-17 08:35:02.789 +08:00', 268, '2023-07-17 08:35:02.789 +08:00', 4);
INSERT INTO public.product_sales VALUES ('KKM', '2023-07-17 13:13:52.537 +08:00', 277, '2023-07-17 13:13:52.537 +08:00', 4);
INSERT INTO public.product_sales VALUES ('KKM', '2023-07-22 11:55:39.575 +08:00', 297, '2023-07-22 11:55:39.575 +08:00', 4);
INSERT INTO public.product_sales VALUES ('CLDS CORP.', '2023-07-13 14:57:01.019 +08:00', 261, '2023-07-13 14:57:01.019 +08:00', 5);
INSERT INTO public.product_sales VALUES ('CLDS CORP.', '2023-07-19 15:53:31.415 +08:00', 287, '2023-07-19 15:53:31.415 +08:00', 5);
INSERT INTO public.product_sales VALUES ('CASH SALES', '2023-07-17 11:19:48.803 +08:00', 274, '2023-07-17 11:19:48.803 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('SIR RAPHY', '2023-07-13 10:39:51.117 +08:00', 259, '2023-07-13 10:39:51.117 +08:00', 6);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-07-05 10:23:12.963 +08:00', 240, '2023-07-05 10:23:12.963 +08:00', 7);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-07-11 09:50:34.090 +08:00', 255, '2023-07-11 09:50:34.090 +08:00', 7);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-07-17 11:54:00.327 +08:00', 276, '2023-07-17 11:54:00.327 +08:00', 7);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-07-17 17:07:01.426 +08:00', 278, '2023-07-17 17:07:01.426 +08:00', 7);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-07-24 10:14:53.662 +08:00', 298, '2023-07-24 10:14:53.662 +08:00', 7);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-07-10 14:03:26.151 +08:00', 252, '2023-07-10 14:03:26.151 +08:00', 8);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-07-17 11:20:06.858 +08:00', 275, '2023-07-17 11:20:06.858 +08:00', 8);
INSERT INTO public.product_sales VALUES ('GOLD LABEL', '2023-07-21 10:16:34.264 +08:00', 290, '2023-07-21 10:16:34.264 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-07-19 13:24:54.378 +08:00', 286, '2023-07-19 13:24:54.378 +08:00', 8);
INSERT INTO public.product_sales VALUES ('JULIUS JASA', '2023-07-21 11:04:38.520 +08:00', 293, '2023-07-21 11:04:38.520 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('ALBERT ARAÑO', '2023-07-22 10:04:59.554 +08:00', 294, '2023-07-22 10:04:59.554 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-07-24 13:13:06.306 +08:00', 300, '2023-07-24 13:13:06.306 +08:00', 8);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-07-26 10:40:27.887 +08:00', 308, '2023-07-26 10:40:27.887 +08:00', 8);
INSERT INTO public.product_sales VALUES ('SANI', '2023-07-18 09:49:43.840 +08:00', 281, '2023-07-18 09:49:43.840 +08:00', 10);
INSERT INTO public.product_sales VALUES ('CASH SALES', '2023-07-24 13:57:28.465 +08:00', 301, '2023-07-24 13:57:28.465 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('AVENIDA VERDE', '2023-07-11 08:20:21.914 +08:00', 253, '2023-07-11 08:20:21.914 +08:00', 11);
INSERT INTO public.product_sales VALUES ('AVENIDA VERDE', '2023-07-14 08:58:44.303 +08:00', 263, '2023-07-14 08:58:44.303 +08:00', 11);
INSERT INTO public.product_sales VALUES ('AVENIDA VERDE', '2023-07-17 11:06:03.285 +08:00', 272, '2023-07-17 11:06:03.285 +08:00', 11);
INSERT INTO public.product_sales VALUES ('AVENIDA VERDE', '2023-07-21 10:17:58.355 +08:00', 291, '2023-07-21 10:17:58.355 +08:00', 11);
INSERT INTO public.product_sales VALUES ('AVENIDA VERDE', '2023-07-26 13:18:02.584 +08:00', 310, '2023-07-26 13:18:02.584 +08:00', 11);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-24 11:09:21.289 +08:00', 400, '2023-08-24 11:09:21.289 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-25 10:28:23.772 +08:00', 406, '2023-08-25 10:28:23.772 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('CASH SALES', '2023-08-26 10:30:22.932 +08:00', 412, '2023-08-26 10:30:22.932 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('AVENIDA VERDE', '2023-08-30 08:35:47.820 +08:00', 420, '2023-08-30 08:35:47.820 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-08-31 09:37:52.599 +08:00', 426, '2023-08-31 09:37:52.599 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-09-02 08:55:15.185 +08:00', 432, '2023-09-02 08:55:15.185 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-09-04 14:09:40.537 +08:00', 440, '2023-09-04 14:09:40.537 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-07-26 16:51:02.503 +08:00', 311, '2023-07-26 16:51:02.503 +08:00', 2);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-07-29 09:48:02.717 +08:00', 316, '2023-07-29 09:48:02.717 +08:00', 2);
INSERT INTO public.product_sales VALUES ('CASH SALES', '2023-07-31 15:34:02.099 +08:00', 322, '2023-07-31 15:34:02.099 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-08-05 09:11:04.059 +08:00', 342, '2023-08-05 09:11:04.059 +08:00', 2);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-08-10 09:56:18.924 +08:00', 350, '2023-08-10 09:56:18.924 +08:00', 2);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-08-10 09:58:36.610 +08:00', 354, '2023-08-10 09:58:36.610 +08:00', 2);
INSERT INTO public.product_sales VALUES ('MARVIN CARANDANG', '2023-08-02 12:47:01.631 +08:00', 328, '2023-08-02 12:47:01.631 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-08-10 11:57:38.091 +08:00', 355, '2023-08-10 11:57:38.091 +08:00', 2);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-08-12 08:51:02.392 +08:00', 364, '2023-08-12 08:51:02.392 +08:00', 2);
INSERT INTO public.product_sales VALUES ('DOC MANNY', '2023-08-03 10:10:54.390 +08:00', 333, '2023-08-03 10:10:54.390 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('PAU CAGUING', '2023-08-03 10:11:11.630 +08:00', 334, '2023-08-03 10:11:11.630 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('PAU CAGUING', '2023-08-04 11:05:35.569 +08:00', 339, '2023-08-04 11:05:35.569 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-08-15 16:44:23.682 +08:00', 376, '2023-08-15 16:44:23.682 +08:00', 2);
INSERT INTO public.product_sales VALUES ('TONY HERNANDEZ', '2023-07-29 09:48:21.155 +08:00', 317, '2023-07-29 09:48:21.155 +08:00', 3);
INSERT INTO public.product_sales VALUES ('TONY HERNANDEZ', '2023-08-02 16:45:29.797 +08:00', 330, '2023-08-02 16:45:29.797 +08:00', 3);
INSERT INTO public.product_sales VALUES ('TONY HERNANDEZ', '2023-08-05 08:39:31.186 +08:00', 341, '2023-08-05 08:39:31.186 +08:00', 3);
INSERT INTO public.product_sales VALUES ('KKM', '2023-07-27 11:12:56.866 +08:00', 313, '2023-07-27 11:12:56.866 +08:00', 4);
INSERT INTO public.product_sales VALUES ('CASH SALES', '2023-08-11 09:49:24.111 +08:00', 358, '2023-08-11 09:49:24.111 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('KKM', '2023-08-04 09:48:07.323 +08:00', 336, '2023-08-04 09:48:07.323 +08:00', 4);
INSERT INTO public.product_sales VALUES ('KKM', '2023-08-10 09:56:43.911 +08:00', 351, '2023-08-10 09:56:43.911 +08:00', 4);
INSERT INTO public.product_sales VALUES ('KKM', '2023-08-11 15:46:02.027 +08:00', 361, '2023-08-11 15:46:02.027 +08:00', 4);
INSERT INTO public.product_sales VALUES ('CASH SALES', '2023-08-12 09:45:43.829 +08:00', 365, '2023-08-12 09:45:43.829 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('CASH SALES', '2023-08-12 09:45:59.117 +08:00', 366, '2023-08-12 09:45:59.117 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('KKM', '2023-08-15 09:38:16.877 +08:00', 373, '2023-08-15 09:38:16.877 +08:00', 4);
INSERT INTO public.product_sales VALUES ('CLDS CORP.', '2023-08-03 10:10:21.944 +08:00', 331, '2023-08-03 10:10:21.944 +08:00', 5);
INSERT INTO public.product_sales VALUES ('CLDS CORP.', '2023-08-10 14:38:57.603 +08:00', 356, '2023-08-10 14:38:57.603 +08:00', 5);
INSERT INTO public.product_sales VALUES ('CLDS CORP.', '2023-08-10 14:39:23.121 +08:00', 357, '2023-08-10 14:39:23.121 +08:00', 5);
INSERT INTO public.product_sales VALUES ('CLDS CORP.', '2023-08-17 10:19:09.809 +08:00', 380, '2023-08-17 10:19:09.809 +08:00', 5);
INSERT INTO public.product_sales VALUES ('SIR RAPHY', '2023-08-15 10:24:54.728 +08:00', 375, '2023-08-15 10:24:54.728 +08:00', 6);
INSERT INTO public.product_sales VALUES ('SIR RAPHY', '2023-08-16 10:13:39.811 +08:00', 377, '2023-08-16 10:13:39.811 +08:00', 6);
INSERT INTO public.product_sales VALUES ('RAPHAEL DELA CRUZ', '2023-08-02 11:35:49.975 +08:00', 327, '2023-08-02 11:35:49.975 +08:00', 6);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-07-27 11:12:35.491 +08:00', 312, '2023-07-27 11:12:35.491 +08:00', 7);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-07-31 09:03:29.391 +08:00', 318, '2023-07-31 09:03:29.391 +08:00', 7);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-08-08 08:49:27.223 +08:00', 345, '2023-08-08 08:49:27.223 +08:00', 7);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-08-10 09:57:57.595 +08:00', 353, '2023-08-10 09:57:57.595 +08:00', 7);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-08-11 15:46:21.675 +08:00', 362, '2023-08-11 15:46:21.675 +08:00', 7);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-08-14 13:46:08.292 +08:00', 371, '2023-08-14 13:46:08.292 +08:00', 7);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-08-16 16:57:20.225 +08:00', 379, '2023-08-16 16:57:20.225 +08:00', 7);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-07-27 14:26:03.211 +08:00', 314, '2023-07-27 14:26:03.211 +08:00', 8);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-08-01 09:45:28.772 +08:00', 324, '2023-08-01 09:45:28.772 +08:00', 8);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-08-04 09:48:28.050 +08:00', 337, '2023-08-04 09:48:28.050 +08:00', 8);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-08-07 14:40:41.451 +08:00', 344, '2023-08-07 14:40:41.451 +08:00', 8);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-08-08 13:28:16.609 +08:00', 348, '2023-08-08 13:28:16.609 +08:00', 8);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-08-14 16:32:55.181 +08:00', 372, '2023-08-14 16:32:55.181 +08:00', 8);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-08-16 16:17:09.303 +08:00', 378, '2023-08-16 16:17:09.303 +08:00', 8);
INSERT INTO public.product_sales VALUES ('SANI', '2023-08-04 10:53:59.008 +08:00', 338, '2023-08-04 10:53:59.008 +08:00', 10);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-09-02 09:31:25.589 +08:00', 433, '2023-09-02 09:31:25.589 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('CASH SALES', '2023-09-04 16:12:09.039 +08:00', 441, '2023-09-04 16:12:09.039 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('AVENIDA VERDE', '2023-07-28 08:30:56.297 +08:00', 315, '2023-07-28 08:30:56.297 +08:00', 11);
INSERT INTO public.product_sales VALUES ('AVENIDA VERDE', '2023-07-31 11:08:07.113 +08:00', 320, '2023-07-31 11:08:07.113 +08:00', 11);
INSERT INTO public.product_sales VALUES ('AVENIDA VERDE', '2023-08-04 09:35:09.326 +08:00', 335, '2023-08-04 09:35:09.326 +08:00', 11);
INSERT INTO public.product_sales VALUES ('AVENIDA VERDE', '2023-08-08 09:05:15.832 +08:00', 346, '2023-08-08 09:05:15.832 +08:00', 11);
INSERT INTO public.product_sales VALUES ('RAPHAEL DELA CRUZ', '2023-08-24 11:10:02.345 +08:00', 401, '2023-08-24 11:10:02.345 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-25 11:40:55.341 +08:00', 407, '2023-08-25 11:40:55.341 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('TONY HERNANDEZ', '2023-08-26 11:11:18.149 +08:00', 413, '2023-08-26 11:11:18.149 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NIÑO ARAÑO', '2023-08-30 08:49:31.251 +08:00', 421, '2023-08-30 08:49:31.251 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('AVENIDA VERDE', '2023-08-31 09:38:53.087 +08:00', 427, '2023-08-31 09:38:53.087 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-08-22 10:04:01.825 +08:00', 389, '2023-08-22 10:04:01.825 +08:00', 2);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-08-22 10:53:42.450 +08:00', 393, '2023-08-22 10:53:42.450 +08:00', 2);
INSERT INTO public.product_sales VALUES ('RONNEL MATIBAG', '2023-08-23 08:35:23.896 +08:00', 396, '2023-08-23 08:35:23.896 +08:00', 2);
INSERT INTO public.product_sales VALUES ('JULIUS JASA', '2023-08-19 10:42:22.631 +08:00', 386, '2023-08-19 10:42:22.631 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('TONY HERNANDEZ', '2023-08-18 13:10:14.328 +08:00', 382, '2023-08-18 13:10:14.328 +08:00', 3);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-08-22 10:03:19.845 +08:00', 387, '2023-08-22 10:03:19.845 +08:00', 7);
INSERT INTO public.product_sales VALUES ('CASH SALES', '2023-08-22 10:12:17.121 +08:00', 391, '2023-08-22 10:12:17.121 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-08-18 15:03:13.698 +08:00', 384, '2023-08-18 15:03:13.698 +08:00', 8);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-08-22 12:01:49.155 +08:00', 394, '2023-08-22 12:01:49.155 +08:00', 8);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-24 13:09:12.574 +08:00', 402, '2023-08-24 13:09:12.574 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-05-19 10:09:33.982 +08:00', 32, '2023-05-19 10:09:33.982 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-05-19 12:49:18.874 +08:00', 37, '2023-05-19 12:49:18.874 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-05-19 14:25:11.550 +08:00', 40, '2023-05-19 14:25:11.550 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-05-20 11:02:18.696 +08:00', 43, '2023-05-20 11:02:18.696 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-05-20 11:16:26.796 +08:00', 45, '2023-05-20 11:16:26.796 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-05-22 17:26:45.835 +08:00', 47, '2023-05-22 17:26:45.835 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-05-23 10:25:40.648 +08:00', 51, '2023-05-23 10:25:40.648 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-05-24 11:53:13.242 +08:00', 55, '2023-05-24 11:53:13.242 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-05-25 09:51:29.732 +08:00', 61, '2023-05-25 09:51:29.732 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-05-26 10:34:55.930 +08:00', 63, '2023-05-26 10:34:55.930 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-05-29 09:04:57.243 +08:00', 68, '2023-05-29 09:04:57.243 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-05-29 10:49:14.166 +08:00', 69, '2023-05-29 10:49:14.166 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-05-30 09:30:41.398 +08:00', 72, '2023-05-30 09:30:41.398 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-05-31 10:00:06.554 +08:00', 76, '2023-05-31 10:00:06.554 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-05-31 14:03:27.535 +08:00', 77, '2023-05-31 14:03:27.535 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-01 09:53:48.149 +08:00', 82, '2023-06-01 09:53:48.149 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-01 14:46:52.939 +08:00', 83, '2023-06-01 14:46:52.939 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-02 09:52:13.760 +08:00', 85, '2023-06-02 09:52:13.760 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-05 14:36:57.525 +08:00', 89, '2023-06-05 14:36:57.525 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-06 09:23:27.893 +08:00', 93, '2023-06-06 09:23:27.893 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-06 14:30:29.219 +08:00', 94, '2023-06-06 14:30:29.219 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-07 09:51:03.788 +08:00', 96, '2023-06-07 09:51:03.788 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-07 14:16:11.308 +08:00', 97, '2023-06-07 14:16:11.308 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-07 14:16:41.270 +08:00', 98, '2023-06-07 14:16:41.270 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-08 10:28:13.110 +08:00', 100, '2023-06-08 10:28:13.110 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-08 11:33:55.006 +08:00', 101, '2023-06-08 11:33:55.006 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-08 13:10:02.037 +08:00', 102, '2023-06-08 13:10:02.037 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-13 08:22:11.925 +08:00', 103, '2023-06-13 08:22:11.925 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-13 08:22:25.163 +08:00', 104, '2023-06-13 08:22:25.163 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-13 14:37:56.580 +08:00', 106, '2023-06-13 14:37:56.580 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-13 14:38:01.812 +08:00', 107, '2023-06-13 14:38:01.812 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-14 13:39:06.422 +08:00', 118, '2023-06-14 13:39:06.422 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-15 11:32:29.814 +08:00', 122, '2023-06-15 11:32:29.814 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-16 10:36:31.366 +08:00', 125, '2023-06-16 10:36:31.366 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-16 14:27:33.159 +08:00', 127, '2023-06-16 14:27:33.159 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-19 09:14:01.964 +08:00', 165, '2023-06-19 09:14:01.964 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-19 13:10:55.875 +08:00', 166, '2023-06-19 13:10:55.875 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-20 09:07:14.032 +08:00', 169, '2023-06-20 09:07:14.032 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-20 15:58:18.527 +08:00', 171, '2023-06-20 15:58:18.527 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-21 10:01:26.382 +08:00', 172, '2023-06-21 10:01:26.382 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-21 10:25:20.706 +08:00', 173, '2023-06-21 10:25:20.706 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-22 13:44:05.428 +08:00', 175, '2023-06-22 13:44:05.428 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-23 08:18:14.508 +08:00', 176, '2023-06-23 08:18:14.508 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-23 10:07:17.473 +08:00', 177, '2023-06-23 10:07:17.473 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-24 09:06:45.773 +08:00', 205, '2023-06-24 09:06:45.773 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-24 11:01:05.127 +08:00', 208, '2023-06-24 11:01:05.127 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-26 09:51:08.929 +08:00', 210, '2023-06-26 09:51:08.929 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-26 13:18:45.110 +08:00', 212, '2023-06-26 13:18:45.110 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-27 09:22:06.704 +08:00', 215, '2023-06-27 09:22:06.704 +08:00', 1);
INSERT INTO public.product_sales VALUES ('KKM', '2023-08-25 11:41:24.503 +08:00', 408, '2023-08-25 11:41:24.503 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('TONY HERNANDEZ', '2023-08-26 11:11:46.947 +08:00', 414, '2023-08-26 11:11:46.947 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('RAPHAEL DELA CRUZ', '2023-08-31 11:27:48.070 +08:00', 428, '2023-08-31 11:27:48.070 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('CASH SALES', '2023-09-02 09:31:43.827 +08:00', 434, '2023-09-02 09:31:43.827 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-27 13:43:18.058 +08:00', 216, '2023-06-27 13:43:18.058 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-29 10:30:41.917 +08:00', 219, '2023-06-29 10:30:41.917 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-06-30 09:49:10.085 +08:00', 223, '2023-06-30 09:49:10.085 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-03 08:45:30.962 +08:00', 230, '2023-07-03 08:45:30.962 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-03 10:03:04.705 +08:00', 232, '2023-07-03 10:03:04.705 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-03 11:08:07.349 +08:00', 234, '2023-07-03 11:08:07.349 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-04 09:51:47.144 +08:00', 236, '2023-07-04 09:51:47.144 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-04 14:08:08.615 +08:00', 238, '2023-07-04 14:08:08.615 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-05 10:23:37.213 +08:00', 241, '2023-07-05 10:23:37.213 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-05 11:49:19.759 +08:00', 242, '2023-07-05 11:49:19.759 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-06 13:51:46.822 +08:00', 244, '2023-07-06 13:51:46.822 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-07 09:16:39.186 +08:00', 246, '2023-07-07 09:16:39.186 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-07 11:29:28.311 +08:00', 247, '2023-07-07 11:29:28.311 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-08 09:33:42.361 +08:00', 248, '2023-07-08 09:33:42.361 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-08 09:37:04.796 +08:00', 250, '2023-07-08 09:37:04.796 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-10 09:37:37.538 +08:00', 251, '2023-07-10 09:37:37.538 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-11 09:39:57.492 +08:00', 254, '2023-07-11 09:39:57.492 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-11 13:36:43.015 +08:00', 256, '2023-07-11 13:36:43.015 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-13 10:24:00.419 +08:00', 258, '2023-07-13 10:24:00.419 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-13 11:46:02.035 +08:00', 260, '2023-07-13 11:46:02.035 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-14 09:42:56.051 +08:00', 264, '2023-07-14 09:42:56.051 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-14 11:52:24.511 +08:00', 265, '2023-07-14 11:52:24.511 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-17 09:41:37.139 +08:00', 271, '2023-07-17 09:41:37.139 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-17 11:19:30.443 +08:00', 273, '2023-07-17 11:19:30.443 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-18 09:49:01.457 +08:00', 279, '2023-07-18 09:49:01.457 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-18 09:49:20.384 +08:00', 280, '2023-07-18 09:49:20.384 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-18 11:26:17.778 +08:00', 283, '2023-07-18 11:26:17.778 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-19 09:08:43.267 +08:00', 284, '2023-07-19 09:08:43.267 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-19 12:32:47.161 +08:00', 285, '2023-07-19 12:32:47.161 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-20 15:43:41.659 +08:00', 288, '2023-07-20 15:43:41.659 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-20 15:44:09.167 +08:00', 289, '2023-07-20 15:44:09.167 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-21 10:37:31.607 +08:00', 292, '2023-07-21 10:37:31.607 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-22 10:05:15.061 +08:00', 295, '2023-07-22 10:05:15.061 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-24 10:15:04.118 +08:00', 299, '2023-07-24 10:15:04.118 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-25 09:21:09.231 +08:00', 305, '2023-07-25 09:21:09.231 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-25 13:26:01.778 +08:00', 306, '2023-07-25 13:26:01.778 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-26 08:55:08.092 +08:00', 307, '2023-07-26 08:55:08.092 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-26 11:10:16.731 +08:00', 309, '2023-07-26 11:10:16.731 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-31 09:52:44.738 +08:00', 319, '2023-07-31 09:52:44.738 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-07-31 11:11:50.353 +08:00', 321, '2023-07-31 11:11:50.353 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-01 09:45:16.234 +08:00', 323, '2023-08-01 09:45:16.234 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-01 16:41:46.438 +08:00', 325, '2023-08-01 16:41:46.438 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-02 09:39:54.848 +08:00', 326, '2023-08-02 09:39:54.848 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-02 16:44:41.939 +08:00', 329, '2023-08-02 16:44:41.939 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-03 10:10:38.549 +08:00', 332, '2023-08-03 10:10:38.549 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-05 08:25:36.410 +08:00', 340, '2023-08-05 08:25:36.410 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-07 11:37:03.478 +08:00', 343, '2023-08-07 11:37:03.478 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-08 11:44:44.401 +08:00', 347, '2023-08-08 11:44:44.401 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-10 09:11:23.088 +08:00', 349, '2023-08-10 09:11:23.088 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-10 09:57:18.303 +08:00', 352, '2023-08-10 09:57:18.303 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-11 09:49:38.447 +08:00', 359, '2023-08-11 09:49:38.447 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-11 15:45:32.577 +08:00', 360, '2023-08-11 15:45:32.577 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-12 08:34:48.727 +08:00', 363, '2023-08-12 08:34:48.727 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-12 11:46:06.868 +08:00', 367, '2023-08-12 11:46:06.868 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-14 08:20:58.532 +08:00', 368, '2023-08-14 08:20:58.532 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-14 08:51:02.572 +08:00', 369, '2023-08-14 08:51:02.572 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-14 11:36:04.867 +08:00', 370, '2023-08-14 11:36:04.867 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-15 09:38:54.055 +08:00', 374, '2023-08-15 09:38:54.055 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-17 10:19:46.772 +08:00', 381, '2023-08-17 10:19:46.772 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-18 15:01:28.464 +08:00', 383, '2023-08-18 15:01:28.464 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-19 08:48:44.883 +08:00', 385, '2023-08-19 08:48:44.883 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-22 10:03:35.328 +08:00', 388, '2023-08-22 10:03:35.328 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-22 10:04:35.339 +08:00', 390, '2023-08-22 10:04:35.339 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-22 10:25:51.768 +08:00', 392, '2023-08-22 10:25:51.768 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-22 13:52:07.719 +08:00', 395, '2023-08-22 13:52:07.719 +08:00', 1);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-23 10:51:15.855 +08:00', 397, '2023-08-23 10:51:15.855 +08:00', 1);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-08-24 13:52:22.198 +08:00', 403, '2023-08-24 13:52:22.198 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-25 11:42:14.350 +08:00', 409, '2023-08-25 11:42:14.350 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-26 11:13:02.781 +08:00', 415, '2023-08-26 11:13:02.781 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('NOEL AFRICA', '2023-08-30 10:26:47.857 +08:00', 423, '2023-08-30 10:26:47.857 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('ELMER ANTALLAN', '2023-08-31 16:22:44.663 +08:00', 429, '2023-08-31 16:22:44.663 +08:00', NULL);
INSERT INTO public.product_sales VALUES ('PAUL CAGUING', '2023-09-02 10:22:14.908 +08:00', 435, '2023-09-02 10:22:14.908 +08:00', NULL);


--
-- TOC entry 3407 (class 0 OID 24747)
-- Dependencies: 215
-- Data for Name: production_outputs; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.production_outputs VALUES (2, 1, 800, 0, '05/18/2023');
INSERT INTO public.production_outputs VALUES (3, 1, 1800, 2, '05/19/2023');
INSERT INTO public.production_outputs VALUES (4, 1, 112, 0, '05/20/2023');
INSERT INTO public.production_outputs VALUES (6, 6, 18, 0, '05/22/2023');
INSERT INTO public.production_outputs VALUES (7, 15, 700, 0, '05/23/2023');
INSERT INTO public.production_outputs VALUES (8, 15, 288, 10, '05/23/2023');
INSERT INTO public.production_outputs VALUES (9, 6, 100, 0, '05/24/2023');
INSERT INTO public.production_outputs VALUES (10, 3, 200, 0, '05/24/2023');
INSERT INTO public.production_outputs VALUES (11, 4, 50, 0, '05/24/2023');
INSERT INTO public.production_outputs VALUES (12, 17, 288, 0, '05/25/2023');
INSERT INTO public.production_outputs VALUES (13, 18, 320, 0, '05/25/2023');
INSERT INTO public.production_outputs VALUES (14, 4, 50, 0, '05/25/2023');
INSERT INTO public.production_outputs VALUES (15, 4, 300, 0, '05/26/2027');
INSERT INTO public.production_outputs VALUES (16, 19, 236, 0, '05/26/2023');
INSERT INTO public.production_outputs VALUES (17, 4, 56, 5, '05/27/2023');
INSERT INTO public.production_outputs VALUES (18, 21, 100, 0, '05/29/2023');
INSERT INTO public.production_outputs VALUES (19, 21, 898, 1, '05/30/2023');
INSERT INTO public.production_outputs VALUES (20, 20, 200, 0, '05/30/2023');
INSERT INTO public.production_outputs VALUES (21, 20, 752, 0, '06/01/2023');
INSERT INTO public.production_outputs VALUES (22, 16, 300, 0, '06/02/2023');
INSERT INTO public.production_outputs VALUES (23, 16, 900, 0, '06/03/2023');
INSERT INTO public.production_outputs VALUES (24, 16, 326, 0, '06/05/2023');
INSERT INTO public.production_outputs VALUES (25, 2, 436, 0, '06/05/2023');
INSERT INTO public.production_outputs VALUES (26, 1, 902, 0, '06/07/2023');
INSERT INTO public.production_outputs VALUES (27, 7, 232, 0, '06/14/2023');
INSERT INTO public.production_outputs VALUES (28, 18, 320, 0, '06/14/2023');
INSERT INTO public.production_outputs VALUES (29, 22, 363, 0, '06/14/2023');
INSERT INTO public.production_outputs VALUES (30, 19, 241, 0, '06/14/2023');
INSERT INTO public.production_outputs VALUES (31, 23, 118, 0, '06/14/2023');
INSERT INTO public.production_outputs VALUES (32, 15, 650, 0, '06/19/2023');
INSERT INTO public.production_outputs VALUES (33, 15, 302, 2, '06/20/2023');
INSERT INTO public.production_outputs VALUES (34, 1, 200, 0, '06/21/2023');
INSERT INTO public.production_outputs VALUES (35, 2, 404, 0, '06/21/2023');
INSERT INTO public.production_outputs VALUES (36, 24, 220, 0, '06/22/2023');
INSERT INTO public.production_outputs VALUES (37, 1, 1000, 0, '06/22/2023');
INSERT INTO public.production_outputs VALUES (39, 24, 220, 0, '06/24/2023');
INSERT INTO public.production_outputs VALUES (40, 18, 320, 1, '06/24/2023');
INSERT INTO public.production_outputs VALUES (38, 1, 100, 0, '06/24/2023');
INSERT INTO public.production_outputs VALUES (41, 1, 500, 0, '06/24/2023');
INSERT INTO public.production_outputs VALUES (43, 1, 1200, 0, '06/27/2023');
INSERT INTO public.production_outputs VALUES (44, 1, 100, 0, '06/30/2023');
INSERT INTO public.production_outputs VALUES (45, 24, 200, 0, '07/10/2023');
INSERT INTO public.production_outputs VALUES (48, 1, 1, 0, '07/10/2023');
INSERT INTO public.production_outputs VALUES (46, 18, 342, 0, '07/10/2023');
INSERT INTO public.production_outputs VALUES (47, 19, 110, 0, '07/10/2023');
INSERT INTO public.production_outputs VALUES (49, 24, 240, 0, '07/11/2023');
INSERT INTO public.production_outputs VALUES (50, 1, 191, 0, '07/11/2023');
INSERT INTO public.production_outputs VALUES (51, 19, 197, 0, '07/11/2023');
INSERT INTO public.production_outputs VALUES (52, 2, 260, 0, '07/11/2023');
INSERT INTO public.production_outputs VALUES (5, 7, 177, 0, '05/20/2023');
INSERT INTO public.production_outputs VALUES (53, 2, 798, 2, '07/12/2023');
INSERT INTO public.production_outputs VALUES (54, 4, 150, 0, '07/12/2023');
INSERT INTO public.production_outputs VALUES (55, 6, 100, 0, '07/12/2023');
INSERT INTO public.production_outputs VALUES (56, 4, 369, 4, '07/13/2023');
INSERT INTO public.production_outputs VALUES (57, 3, 100, 0, '07/13/2023');
INSERT INTO public.production_outputs VALUES (58, 14, 420, 0, '07/13/2023');
INSERT INTO public.production_outputs VALUES (59, 14, 1400, 0, '07/14/2023');
INSERT INTO public.production_outputs VALUES (60, 18, 305, 0, '07/14/2023');
INSERT INTO public.production_outputs VALUES (61, 14, 814, 11, '07/15/2023');
INSERT INTO public.production_outputs VALUES (62, 21, 500, 0, '07/15/2023');
INSERT INTO public.production_outputs VALUES (63, 1, 600, 0, '07/17/2023');
INSERT INTO public.production_outputs VALUES (64, 26, 234, 0, '07/17/2023');
INSERT INTO public.production_outputs VALUES (65, 21, 383, 1, '07/17/2023');
INSERT INTO public.production_outputs VALUES (66, 27, 400, 0, '07/18/2023');
INSERT INTO public.production_outputs VALUES (67, 1, 458, 0, '07/18/2023');
INSERT INTO public.production_outputs VALUES (68, 27, 393, 0, '07/19/2023');
INSERT INTO public.production_outputs VALUES (69, 15, 400, 0, '07/19/2023');
INSERT INTO public.production_outputs VALUES (70, 1, 148, 0, '07/20/2023');
INSERT INTO public.production_outputs VALUES (71, 27, 107, 0, '07/20/2023');
INSERT INTO public.production_outputs VALUES (72, 15, 518, 3, '07/20/2023');
INSERT INTO public.production_outputs VALUES (73, 1, 200, 0, '07/21/2023');
INSERT INTO public.production_outputs VALUES (74, 1, 300, 0, '07/22/2023');
INSERT INTO public.production_outputs VALUES (75, 1, 400, 0, '07/24/2023');
INSERT INTO public.production_outputs VALUES (76, 1, 300, 0, '07/25/2023');
INSERT INTO public.production_outputs VALUES (77, 18, 316, 0, '07/25/2023');
INSERT INTO public.production_outputs VALUES (78, 17, 195, 0, '07/25/2023');
INSERT INTO public.production_outputs VALUES (80, 17, 43, 0, '07/26/2023');
INSERT INTO public.production_outputs VALUES (79, 1, 900, 0, '07/26/2023');
INSERT INTO public.production_outputs VALUES (81, 22, 228, 0, '07/26/2023');
INSERT INTO public.production_outputs VALUES (82, 19, 338, 0, '07/27/2023');
INSERT INTO public.production_outputs VALUES (83, 1, 412, 0, '07/27/2023');
INSERT INTO public.production_outputs VALUES (84, 1, 1200, 0, '07/28/2023');
INSERT INTO public.production_outputs VALUES (85, 1, 500, 0, '07/31/2023');
INSERT INTO public.production_outputs VALUES (86, 1, 1371, 1, '07/31/2023');
INSERT INTO public.production_outputs VALUES (87, 8, 220, 0, '08/01/2023');
INSERT INTO public.production_outputs VALUES (88, 2, 450, 0, '08/01/2023');
INSERT INTO public.production_outputs VALUES (89, 14, 9, 0, '08/01/2023');
INSERT INTO public.production_outputs VALUES (90, 2, 771, 0, '08/02/2023');
INSERT INTO public.production_outputs VALUES (91, 28, 200, 0, '08/02/2023');
INSERT INTO public.production_outputs VALUES (92, 28, 100, 0, '08/03/2023');
INSERT INTO public.production_outputs VALUES (93, 6, 100, 0, '08/04/2023');
INSERT INTO public.production_outputs VALUES (94, 28, 199, 1, '08/07/2023');
INSERT INTO public.production_outputs VALUES (95, 6, 100, 0, '08/07/2023');
INSERT INTO public.production_outputs VALUES (96, 4, 406, 5, '08/08/2023');
INSERT INTO public.production_outputs VALUES (97, 21, 116, 0, '08/08/2023');
INSERT INTO public.production_outputs VALUES (98, 20, 834, 0, '08/09/2023');
INSERT INTO public.production_outputs VALUES (99, 20, 150, 0, '08/10/2023');
INSERT INTO public.production_outputs VALUES (100, 21, 800, 0, '08/12/2023');
INSERT INTO public.production_outputs VALUES (101, 21, 200, 0, '08/14/2023');
INSERT INTO public.production_outputs VALUES (102, 20, 758, 9, '08/14/2023');
INSERT INTO public.production_outputs VALUES (103, 14, 1260, 0, '08/15/2023');
INSERT INTO public.production_outputs VALUES (104, 14, 1036, 3, '08/16/2023');
INSERT INTO public.production_outputs VALUES (105, 2, 840, 0, '08/16/2023');
INSERT INTO public.production_outputs VALUES (106, 2, 1011, 0, '08/17/2023');
INSERT INTO public.production_outputs VALUES (107, 15, 210, 0, '08/17/2023');
INSERT INTO public.production_outputs VALUES (108, 15, 840, 0, '08/18/2023');
INSERT INTO public.production_outputs VALUES (109, 15, 210, 0, '08/19/2023');
INSERT INTO public.production_outputs VALUES (110, 15, 1050, 0, '08/22/2023');
INSERT INTO public.production_outputs VALUES (111, 15, 535, 4, '08/23/2023');
INSERT INTO public.production_outputs VALUES (112, 7, 197, 0, '08/23/2023');
INSERT INTO public.production_outputs VALUES (113, 1, 400, 0, '08/23/2023');
INSERT INTO public.production_outputs VALUES (114, 1, 800, 0, '08/24/2023');
INSERT INTO public.production_outputs VALUES (115, 18, 245, 0, '08/25/2023');
INSERT INTO public.production_outputs VALUES (116, 26, 231, 0, '08/25/2023');
INSERT INTO public.production_outputs VALUES (117, 19, 229, 0, '08/25/2023');
INSERT INTO public.production_outputs VALUES (118, 1, 400, 0, '08/29/2023');
INSERT INTO public.production_outputs VALUES (119, 1, 400, 0, '08/30/2023');
INSERT INTO public.production_outputs VALUES (120, 1, 155, 0, '08/31/2023');
INSERT INTO public.production_outputs VALUES (121, 24, 440, 0, '09/01/2023');
INSERT INTO public.production_outputs VALUES (122, 1, 545, 0, '09/01/2023');
INSERT INTO public.production_outputs VALUES (123, 1, 171, 0, '09/02/2023');


--
-- TOC entry 3409 (class 0 OID 24753)
-- Dependencies: 217
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.products VALUES (6, 'SOLENN CAT FOOD', 18, 20);
INSERT INTO public.products VALUES (7, 'RAM', 71, 20);
INSERT INTO public.products VALUES (8, 'FOOD FOR THE DOG PUPPY', 280, 9.09);
INSERT INTO public.products VALUES (3, 'FELIZ CAT FOOD', 80, 20);
INSERT INTO public.products VALUES (1, 'DOGGY WOGGY ADULT', 1289, 20);
INSERT INTO public.products VALUES (2, 'DOGGY WOGGY PUPPY', 186, 10);
INSERT INTO public.products VALUES (14, 'CHM - PUPPY', 38, 10);
INSERT INTO public.products VALUES (15, 'PERFECTO', 0, 20);
INSERT INTO public.products VALUES (16, 'NUGOLD - A', 112, 15);
INSERT INTO public.products VALUES (17, 'ANG MAESTRO BABY STAG BOOSTER', 0, 25);
INSERT INTO public.products VALUES (18, 'ANG MAESTRO STAG DEVELOPER', 0, 25);
INSERT INTO public.products VALUES (19, 'ANG MAESTRO BULL STAG', 0, 25);
INSERT INTO public.products VALUES (20, 'CHM - ADULT (PLASTIC)', 0, 20);
INSERT INTO public.products VALUES (21, 'CHM - ADULT (SACKS)', 0, 20);
INSERT INTO public.products VALUES (22, 'ANG MAESTRO JUNIOR STAG', 0, 25);
INSERT INTO public.products VALUES (23, 'PIGLET BOOSTER', 0, 20);
INSERT INTO public.products VALUES (24, 'FOOD FOR THE DOG ADULT', 0, 18.18);
INSERT INTO public.products VALUES (26, 'ANG MAESTRO GENESYS', 0, 25);
INSERT INTO public.products VALUES (27, 'GOLD LABEL ADULT', 0, 20);
INSERT INTO public.products VALUES (28, 'KITTY WITTY (SACKS)', 0, 20);
INSERT INTO public.products VALUES (4, 'KITTY WITTY (PLASTIC)', 202, 20);


--
-- TOC entry 3411 (class 0 OID 24759)
-- Dependencies: 219
-- Data for Name: released_packagings; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.released_packagings VALUES (1, 5, 1013, '05-03-2023', NULL);
INSERT INTO public.released_packagings VALUES (2, 1, 1730, '05-11-2023', NULL);
INSERT INTO public.released_packagings VALUES (3, 1, 1500, '05-11-2023', NULL);
INSERT INTO public.released_packagings VALUES (4, 1, 1000, '05/11/13', NULL);
INSERT INTO public.released_packagings VALUES (5, 6, 30, '05/16/2023', NULL);
INSERT INTO public.released_packagings VALUES (6, 4, 1, '05/18/2023', NULL);
INSERT INTO public.released_packagings VALUES (8, 1, 1114, '05/16/2023', NULL);
INSERT INTO public.released_packagings VALUES (9, 1, 500, '05/19/2023', NULL);
INSERT INTO public.released_packagings VALUES (10, 4, 200, '05/20/2023', NULL);
INSERT INTO public.released_packagings VALUES (11, 4, 973, '05/22/2023', NULL);
INSERT INTO public.released_packagings VALUES (12, 4, 350, '05/23/2023', NULL);
INSERT INTO public.released_packagings VALUES (14, 1, 1, '05/23/2023', NULL);
INSERT INTO public.released_packagings VALUES (13, 4, 0, '05/23/2023', NULL);
INSERT INTO public.released_packagings VALUES (15, 7, 18, '05/22/2023', NULL);
INSERT INTO public.released_packagings VALUES (16, 7, 300, '05/24/2023', NULL);
INSERT INTO public.released_packagings VALUES (18, 3, 300, '05/24/2023', NULL);
INSERT INTO public.released_packagings VALUES (17, 4, 325, '05/24/2023', 'KITTY WITTY');
INSERT INTO public.released_packagings VALUES (19, 4, 280, '05/26/2023', 'KITTY WITTY');
INSERT INTO public.released_packagings VALUES (21, 2, 800, '05/29/2023', 'CHM - A LINER');
INSERT INTO public.released_packagings VALUES (23, 4, 145, '05/30/2023', 'CHM - A');
INSERT INTO public.released_packagings VALUES (24, 4, 700, '05/30/2023', 'CHM - A');
INSERT INTO public.released_packagings VALUES (25, 4, 350, '05/31/2023', 'CHM - A');
INSERT INTO public.released_packagings VALUES (22, 2, 224, '05/30/2023', 'CHM - A LINER');
INSERT INTO public.released_packagings VALUES (27, 8, 1000, '06/02/2023', 'PICKED UP BY AVENIDA');
INSERT INTO public.released_packagings VALUES (28, 1, 1, '06/03/2023', 'rebag dwa');
INSERT INTO public.released_packagings VALUES (29, 6, 436, '06/05/2023', 'DWP');
INSERT INTO public.released_packagings VALUES (30, 1, 867, '06/06/2023', 'DWA');
INSERT INTO public.released_packagings VALUES (31, 1, 200, '06/07/2023', 'DWA');
INSERT INTO public.released_packagings VALUES (32, 1, 1, '06/13/2023', 'rebag dwa');
INSERT INTO public.released_packagings VALUES (33, 2, 30, '06/13/2023', 'CAPT CAT LINER');
INSERT INTO public.released_packagings VALUES (34, 3, 76, '06/13/2023', 'CAPT CAT');
INSERT INTO public.released_packagings VALUES (37, 4, 232, '06/14/2023', 'released for RAM');
INSERT INTO public.released_packagings VALUES (38, 4, 11, '06/14/2023', 'released for RAM - delivery');
INSERT INTO public.released_packagings VALUES (39, 4, 100, '06/14/2023', 'released for piglet booster');
INSERT INTO public.released_packagings VALUES (40, 4, 2, '06/17/2023', 'rebag RAM');
INSERT INTO public.released_packagings VALUES (41, 4, 50, '06/14/2023', 'piglet booster');
INSERT INTO public.released_packagings VALUES (42, 4, 1979, '06/19/2023', 'for perfecto');
INSERT INTO public.released_packagings VALUES (43, 3, 1, '06/21/2023', 'rebag solenn');
INSERT INTO public.released_packagings VALUES (44, 2, 320, '06/23/2023', 'liner for stag dev');
INSERT INTO public.released_packagings VALUES (45, 5, 101, '06/23/2023', 'released for cebu premix');
INSERT INTO public.released_packagings VALUES (46, 1, 500, '06/21/2023', 'DWA');
INSERT INTO public.released_packagings VALUES (47, 1, 2000, '06/22/2023', 'DWA');
INSERT INTO public.released_packagings VALUES (48, 1, 1500, '06/26/2023', 'DWA');
INSERT INTO public.released_packagings VALUES (49, 3, 33, '06/26/2023', 'SGT. DOG');
INSERT INTO public.released_packagings VALUES (50, 4, 2000, '06/29/2023', 'sold to merlo');
INSERT INTO public.released_packagings VALUES (52, 1, 600, '07/01/2023', 'sold to sani');
INSERT INTO public.released_packagings VALUES (53, 6, 404, '06/21/2023', 'dwp');
INSERT INTO public.released_packagings VALUES (54, 2, 203, '06/14/2023', 'used for liner by avenida');
INSERT INTO public.released_packagings VALUES (55, 8, 1000, '07/06/2023', 'purchased by avenida');
INSERT INTO public.released_packagings VALUES (56, 5, 950, '07/11/2023', 'for dwp and liner in dwo');
INSERT INTO public.released_packagings VALUES (57, 3, 100, '07/12/2023', 'SOLENN');
INSERT INTO public.released_packagings VALUES (58, 4, 1027, '07/12/2023', 'FOR KITTY WITTY');
INSERT INTO public.released_packagings VALUES (59, 3, 100, '07/13/2023', 'FELIZ');
INSERT INTO public.released_packagings VALUES (60, 5, 2800, '07/13/2023', 'For CHM Puppy');
INSERT INTO public.released_packagings VALUES (61, 2, 970, '07/17/2023', 'CHM A liner');
INSERT INTO public.released_packagings VALUES (62, 4, 504, '07/18/2023', 'FOR GOLD LABEL A');
INSERT INTO public.released_packagings VALUES (63, 4, 400, '07/18/2023', 'FOR GOLD LABEL A');
INSERT INTO public.released_packagings VALUES (64, 4, 111, '07/19/2023', 'FOR PERFECTO');
INSERT INTO public.released_packagings VALUES (65, 4, 750, '07/19/2023', 'FOR PERFECTO');
INSERT INTO public.released_packagings VALUES (66, 4, 350, '07/20/2023', 'FOR PERFECTO');


--
-- TOC entry 3413 (class 0 OID 24765)
-- Dependencies: 221
-- Data for Name: repro_products; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.repro_products VALUES (1, 4, 1, 'wrecked packaging');
INSERT INTO public.repro_products VALUES (2, 1, 1, 'returned by Sir Elmer Antallan');
INSERT INTO public.repro_products VALUES (3, 1, 1, 'wrecked packaging');
INSERT INTO public.repro_products VALUES (4, 1, 1, 'wrecked packaging');
INSERT INTO public.repro_products VALUES (5, 4, 1, 'wrecked packaging');
INSERT INTO public.repro_products VALUES (6, 7, 71, 'Failed quality');
INSERT INTO public.repro_products VALUES (7, 1, 1, 'returned by clds');
INSERT INTO public.repro_products VALUES (8, 2, 1, 'wrecked packaging');
INSERT INTO public.repro_products VALUES (9, 1, 1, 'wrecked packaging');
INSERT INTO public.repro_products VALUES (10, 14, 1, 'wrecked packaging when loading in truck');
INSERT INTO public.repro_products VALUES (11, 7, 1, 'wrecked packaging');
INSERT INTO public.repro_products VALUES (12, 1, 1, 'picked up by doc manny');
INSERT INTO public.repro_products VALUES (13, 2, 1, 'picked up by doc manny');
INSERT INTO public.repro_products VALUES (14, 7, 1, 'wrecked packaging');
INSERT INTO public.repro_products VALUES (15, 7, 20, 'old stocks');
INSERT INTO public.repro_products VALUES (16, 14, 1, 'wrecked when loading to truck');
INSERT INTO public.repro_products VALUES (17, 4, 1, 'wrecked packaging');


--
-- TOC entry 3415 (class 0 OID 24771)
-- Dependencies: 223
-- Data for Name: returned_packagings; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.returned_packagings VALUES (2, 5, 55, '05/19/2023');
INSERT INTO public.returned_packagings VALUES (3, 1, 869, '05/20/2023');
INSERT INTO public.returned_packagings VALUES (5, 4, 23, '05/20/2023');
INSERT INTO public.returned_packagings VALUES (6, 4, 325, '05/24/2023');
INSERT INTO public.returned_packagings VALUES (7, 4, 145, '05/29/2023');
INSERT INTO public.returned_packagings VALUES (8, 4, 242, '05/31/2023');
INSERT INTO public.returned_packagings VALUES (9, 3, 11, '06/14/2023');
INSERT INTO public.returned_packagings VALUES (10, 4, 30, '06/15/2023');
INSERT INTO public.returned_packagings VALUES (11, 4, 1027, '06/23/2023');
INSERT INTO public.returned_packagings VALUES (12, 5, 41, '06/30/2023');
INSERT INTO public.returned_packagings VALUES (13, 1, 1038, '06/23/2023');
INSERT INTO public.returned_packagings VALUES (14, 4, 504, '07/17/2023');
INSERT INTO public.returned_packagings VALUES (15, 4, 111, '07/19/2023');


--
-- TOC entry 3417 (class 0 OID 24777)
-- Dependencies: 225
-- Data for Name: sales_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.sales_items VALUES (67, 1, 100, 115);
INSERT INTO public.sales_items VALUES (68, 1, 40, 116);
INSERT INTO public.sales_items VALUES (69, 1, 30, 117);
INSERT INTO public.sales_items VALUES (69, 2, 1, 118);
INSERT INTO public.sales_items VALUES (70, 1, 75, 119);
INSERT INTO public.sales_items VALUES (70, 2, 20, 120);
INSERT INTO public.sales_items VALUES (71, 17, 80, 121);
INSERT INTO public.sales_items VALUES (71, 19, 20, 122);
INSERT INTO public.sales_items VALUES (72, 1, 40, 123);
INSERT INTO public.sales_items VALUES (40, 1, 35, 67);
INSERT INTO public.sales_items VALUES (40, 2, 6, 68);
INSERT INTO public.sales_items VALUES (40, 6, 1, 69);
INSERT INTO public.sales_items VALUES (41, 1, 14, 70);
INSERT INTO public.sales_items VALUES (41, 2, 7, 71);
INSERT INTO public.sales_items VALUES (42, 1, 13, 72);
INSERT INTO public.sales_items VALUES (42, 2, 6, 73);
INSERT INTO public.sales_items VALUES (42, 3, 2, 74);
INSERT INTO public.sales_items VALUES (43, 1, 30, 75);
INSERT INTO public.sales_items VALUES (43, 2, 15, 76);
INSERT INTO public.sales_items VALUES (44, 1, 85, 77);
INSERT INTO public.sales_items VALUES (45, 1, 25, 78);
INSERT INTO public.sales_items VALUES (46, 4, 18, 79);
INSERT INTO public.sales_items VALUES (47, 1, 40, 80);
INSERT INTO public.sales_items VALUES (47, 2, 4, 81);
INSERT INTO public.sales_items VALUES (48, 4, 2, 82);
INSERT INTO public.sales_items VALUES (49, 1, 18, 83);
INSERT INTO public.sales_items VALUES (50, 1, 946, 84);
INSERT INTO public.sales_items VALUES (50, 3, 20, 85);
INSERT INTO public.sales_items VALUES (28, 1, 40, 31);
INSERT INTO public.sales_items VALUES (28, 2, 10, 32);
INSERT INTO public.sales_items VALUES (51, 1, 30, 86);
INSERT INTO public.sales_items VALUES (52, 15, 938, 87);
INSERT INTO public.sales_items VALUES (52, 4, 150, 88);
INSERT INTO public.sales_items VALUES (52, 14, 38, 89);
INSERT INTO public.sales_items VALUES (32, 1, 20, 37);
INSERT INTO public.sales_items VALUES (32, 6, 10, 38);
INSERT INTO public.sales_items VALUES (53, 1, 40, 90);
INSERT INTO public.sales_items VALUES (53, 2, 10, 91);
INSERT INTO public.sales_items VALUES (53, 3, 5, 92);
INSERT INTO public.sales_items VALUES (54, 1, 20, 93);
INSERT INTO public.sales_items VALUES (55, 1, 32, 94);
INSERT INTO public.sales_items VALUES (55, 2, 6, 95);
INSERT INTO public.sales_items VALUES (56, 16, 112, 96);
INSERT INTO public.sales_items VALUES (57, 1, 20, 97);
INSERT INTO public.sales_items VALUES (57, 3, 2, 98);
INSERT INTO public.sales_items VALUES (58, 1, 17, 99);
INSERT INTO public.sales_items VALUES (58, 3, 1, 100);
INSERT INTO public.sales_items VALUES (58, 2, 1, 101);
INSERT INTO public.sales_items VALUES (59, 8, 280, 102);
INSERT INTO public.sales_items VALUES (60, 1, 20, 103);
INSERT INTO public.sales_items VALUES (61, 1, 40, 104);
INSERT INTO public.sales_items VALUES (62, 4, 50, 105);
INSERT INTO public.sales_items VALUES (63, 1, 30, 106);
INSERT INTO public.sales_items VALUES (63, 2, 5, 107);
INSERT INTO public.sales_items VALUES (37, 1, 20, 51);
INSERT INTO public.sales_items VALUES (37, 6, 1, 52);
INSERT INTO public.sales_items VALUES (64, 1, 22, 108);
INSERT INTO public.sales_items VALUES (65, 1, 50, 109);
INSERT INTO public.sales_items VALUES (65, 2, 20, 110);
INSERT INTO public.sales_items VALUES (65, 6, 12, 111);
INSERT INTO public.sales_items VALUES (66, 17, 208, 112);
INSERT INTO public.sales_items VALUES (66, 18, 320, 113);
INSERT INTO public.sales_items VALUES (66, 19, 160, 114);
INSERT INTO public.sales_items VALUES (72, 6, 1, 124);
INSERT INTO public.sales_items VALUES (73, 1, 791, 125);
INSERT INTO public.sales_items VALUES (73, 2, 50, 126);
INSERT INTO public.sales_items VALUES (74, 1, 18, 128);
INSERT INTO public.sales_items VALUES (73, 3, 100, 127);
INSERT INTO public.sales_items VALUES (75, 1, 50, 129);
INSERT INTO public.sales_items VALUES (76, 1, 30, 130);
INSERT INTO public.sales_items VALUES (76, 2, 10, 131);
INSERT INTO public.sales_items VALUES (76, 6, 5, 132);
INSERT INTO public.sales_items VALUES (77, 1, 25, 133);
INSERT INTO public.sales_items VALUES (77, 2, 3, 134);
INSERT INTO public.sales_items VALUES (77, 6, 1, 135);
INSERT INTO public.sales_items VALUES (78, 19, 56, 136);
INSERT INTO public.sales_items VALUES (80, 4, 150, 138);
INSERT INTO public.sales_items VALUES (80, 15, 50, 139);
INSERT INTO public.sales_items VALUES (80, 21, 868, 140);
INSERT INTO public.sales_items VALUES (81, 1, 1, 141);
INSERT INTO public.sales_items VALUES (82, 1, 5, 142);
INSERT INTO public.sales_items VALUES (82, 6, 20, 143);
INSERT INTO public.sales_items VALUES (82, 2, 12, 144);
INSERT INTO public.sales_items VALUES (83, 1, 30, 145);
INSERT INTO public.sales_items VALUES (84, 1, 18, 146);
INSERT INTO public.sales_items VALUES (85, 1, 30, 147);
INSERT INTO public.sales_items VALUES (85, 6, 2, 148);
INSERT INTO public.sales_items VALUES (86, 1, 15, 149);
INSERT INTO public.sales_items VALUES (86, 3, 5, 150);
INSERT INTO public.sales_items VALUES (87, 1, 1, 151);
INSERT INTO public.sales_items VALUES (88, 1, 25, 152);
INSERT INTO public.sales_items VALUES (89, 1, 30, 153);
INSERT INTO public.sales_items VALUES (90, 1, 5, 154);
INSERT INTO public.sales_items VALUES (91, 1, 18, 155);
INSERT INTO public.sales_items VALUES (91, 3, 1, 156);
INSERT INTO public.sales_items VALUES (92, 1, 75, 157);
INSERT INTO public.sales_items VALUES (92, 2, 20, 158);
INSERT INTO public.sales_items VALUES (93, 1, 25, 159);
INSERT INTO public.sales_items VALUES (94, 1, 35, 160);
INSERT INTO public.sales_items VALUES (95, 1, 14, 161);
INSERT INTO public.sales_items VALUES (95, 2, 4, 162);
INSERT INTO public.sales_items VALUES (95, 3, 2, 163);
INSERT INTO public.sales_items VALUES (96, 1, 35, 164);
INSERT INTO public.sales_items VALUES (96, 2, 10, 165);
INSERT INTO public.sales_items VALUES (97, 1, 30, 166);
INSERT INTO public.sales_items VALUES (97, 2, 5, 167);
INSERT INTO public.sales_items VALUES (98, 1, 30, 168);
INSERT INTO public.sales_items VALUES (98, 2, 1, 169);
INSERT INTO public.sales_items VALUES (98, 6, 1, 170);
INSERT INTO public.sales_items VALUES (99, 1, 50, 171);
INSERT INTO public.sales_items VALUES (100, 1, 30, 172);
INSERT INTO public.sales_items VALUES (100, 2, 5, 173);
INSERT INTO public.sales_items VALUES (101, 1, 40, 174);
INSERT INTO public.sales_items VALUES (102, 1, 30, 175);
INSERT INTO public.sales_items VALUES (103, 1, 25, 176);
INSERT INTO public.sales_items VALUES (103, 2, 21, 177);
INSERT INTO public.sales_items VALUES (104, 1, 20, 178);
INSERT INTO public.sales_items VALUES (105, 1, 18, 179);
INSERT INTO public.sales_items VALUES (106, 1, 40, 180);
INSERT INTO public.sales_items VALUES (106, 2, 5, 181);
INSERT INTO public.sales_items VALUES (107, 1, 30, 182);
INSERT INTO public.sales_items VALUES (107, 2, 5, 183);
INSERT INTO public.sales_items VALUES (108, 1, 1, 184);
INSERT INTO public.sales_items VALUES (109, 1, 40, 185);
INSERT INTO public.sales_items VALUES (109, 2, 10, 186);
INSERT INTO public.sales_items VALUES (110, 1, 60, 187);
INSERT INTO public.sales_items VALUES (110, 2, 20, 188);
INSERT INTO public.sales_items VALUES (110, 6, 10, 189);
INSERT INTO public.sales_items VALUES (111, 1, 15, 190);
INSERT INTO public.sales_items VALUES (111, 2, 2, 191);
INSERT INTO public.sales_items VALUES (112, 1, 23, 193);
INSERT INTO public.sales_items VALUES (111, 3, 2, 192);
INSERT INTO public.sales_items VALUES (112, 3, 2, 194);
INSERT INTO public.sales_items VALUES (114, 4, 50, 195);
INSERT INTO public.sales_items VALUES (114, 7, 4, 196);
INSERT INTO public.sales_items VALUES (117, 1, 200, 198);
INSERT INTO public.sales_items VALUES (117, 2, 100, 199);
INSERT INTO public.sales_items VALUES (118, 1, 40, 200);
INSERT INTO public.sales_items VALUES (119, 7, 200, 201);
INSERT INTO public.sales_items VALUES (119, 4, 20, 202);
INSERT INTO public.sales_items VALUES (120, 16, 667, 203);
INSERT INTO public.sales_items VALUES (121, 1, 11, 204);
INSERT INTO public.sales_items VALUES (122, 1, 33, 205);
INSERT INTO public.sales_items VALUES (123, 18, 320, 206);
INSERT INTO public.sales_items VALUES (123, 23, 118, 207);
INSERT INTO public.sales_items VALUES (123, 22, 363, 208);
INSERT INTO public.sales_items VALUES (123, 19, 241, 209);
INSERT INTO public.sales_items VALUES (124, 1, 1, 210);
INSERT INTO public.sales_items VALUES (124, 2, 1, 211);
INSERT INTO public.sales_items VALUES (125, 1, 20, 212);
INSERT INTO public.sales_items VALUES (125, 6, 1, 213);
INSERT INTO public.sales_items VALUES (126, 1, 31, 214);
INSERT INTO public.sales_items VALUES (127, 1, 30, 215);
INSERT INTO public.sales_items VALUES (127, 2, 5, 216);
INSERT INTO public.sales_items VALUES (128, 1, 18, 217);
INSERT INTO public.sales_items VALUES (129, 16, 667, 218);
INSERT INTO public.sales_items VALUES (130, 2, 10, 220);
INSERT INTO public.sales_items VALUES (130, 1, 40, 219);
INSERT INTO public.sales_items VALUES (131, 1, 80, 221);
INSERT INTO public.sales_items VALUES (131, 2, 10, 222);
INSERT INTO public.sales_items VALUES (132, 1, 20, 223);
INSERT INTO public.sales_items VALUES (165, 1, 30, 256);
INSERT INTO public.sales_items VALUES (165, 2, 5, 257);
INSERT INTO public.sales_items VALUES (165, 6, 2, 258);
INSERT INTO public.sales_items VALUES (166, 1, 30, 259);
INSERT INTO public.sales_items VALUES (166, 6, 2, 260);
INSERT INTO public.sales_items VALUES (167, 1, 300, 261);
INSERT INTO public.sales_items VALUES (167, 2, 197, 262);
INSERT INTO public.sales_items VALUES (168, 1, 18, 263);
INSERT INTO public.sales_items VALUES (169, 1, 40, 264);
INSERT INTO public.sales_items VALUES (170, 20, 952, 265);
INSERT INTO public.sales_items VALUES (170, 21, 130, 266);
INSERT INTO public.sales_items VALUES (170, 15, 52, 267);
INSERT INTO public.sales_items VALUES (171, 1, 36, 268);
INSERT INTO public.sales_items VALUES (172, 1, 40, 269);
INSERT INTO public.sales_items VALUES (173, 1, 30, 270);
INSERT INTO public.sales_items VALUES (174, 1, 100, 271);
INSERT INTO public.sales_items VALUES (175, 1, 20, 272);
INSERT INTO public.sales_items VALUES (175, 2, 15, 273);
INSERT INTO public.sales_items VALUES (175, 6, 5, 274);
INSERT INTO public.sales_items VALUES (176, 1, 35, 275);
INSERT INTO public.sales_items VALUES (177, 1, 20, 276);
INSERT INTO public.sales_items VALUES (183, 1, 60, 285);
INSERT INTO public.sales_items VALUES (183, 2, 10, 286);
INSERT INTO public.sales_items VALUES (183, 6, 10, 287);
INSERT INTO public.sales_items VALUES (202, 1, 18, 306);
INSERT INTO public.sales_items VALUES (205, 1, 40, 310);
INSERT INTO public.sales_items VALUES (205, 2, 7, 311);
INSERT INTO public.sales_items VALUES (206, 1, 18, 312);
INSERT INTO public.sales_items VALUES (206, 2, 1, 313);
INSERT INTO public.sales_items VALUES (207, 18, 320, 314);
INSERT INTO public.sales_items VALUES (208, 1, 30, 315);
INSERT INTO public.sales_items VALUES (209, 1, 20, 316);
INSERT INTO public.sales_items VALUES (210, 1, 35, 317);
INSERT INTO public.sales_items VALUES (210, 2, 10, 318);
INSERT INTO public.sales_items VALUES (211, 24, 330, 319);
INSERT INTO public.sales_items VALUES (212, 1, 30, 320);
INSERT INTO public.sales_items VALUES (212, 2, 3, 321);
INSERT INTO public.sales_items VALUES (212, 6, 1, 322);
INSERT INTO public.sales_items VALUES (213, 4, 216, 323);
INSERT INTO public.sales_items VALUES (213, 15, 844, 324);
INSERT INTO public.sales_items VALUES (214, 1, 16, 325);
INSERT INTO public.sales_items VALUES (214, 2, 4, 326);
INSERT INTO public.sales_items VALUES (215, 1, 30, 327);
INSERT INTO public.sales_items VALUES (215, 2, 4, 328);
INSERT INTO public.sales_items VALUES (215, 6, 1, 329);
INSERT INTO public.sales_items VALUES (216, 1, 30, 330);
INSERT INTO public.sales_items VALUES (217, 1, 40, 331);
INSERT INTO public.sales_items VALUES (217, 2, 10, 332);
INSERT INTO public.sales_items VALUES (218, 1, 20, 333);
INSERT INTO public.sales_items VALUES (218, 2, 10, 334);
INSERT INTO public.sales_items VALUES (218, 3, 10, 335);
INSERT INTO public.sales_items VALUES (219, 1, 30, 336);
INSERT INTO public.sales_items VALUES (220, 24, 110, 337);
INSERT INTO public.sales_items VALUES (221, 2, 200, 338);
INSERT INTO public.sales_items VALUES (222, 2, 3, 339);
INSERT INTO public.sales_items VALUES (223, 1, 30, 340);
INSERT INTO public.sales_items VALUES (223, 2, 5, 341);
INSERT INTO public.sales_items VALUES (224, 1, 60, 342);
INSERT INTO public.sales_items VALUES (224, 6, 15, 343);
INSERT INTO public.sales_items VALUES (224, 2, 10, 344);
INSERT INTO public.sales_items VALUES (225, 1, 1, 345);
INSERT INTO public.sales_items VALUES (226, 1, 20, 346);
INSERT INTO public.sales_items VALUES (226, 3, 3, 347);
INSERT INTO public.sales_items VALUES (227, 1, 18, 348);
INSERT INTO public.sales_items VALUES (227, 3, 1, 349);
INSERT INTO public.sales_items VALUES (228, 3, 16, 350);
INSERT INTO public.sales_items VALUES (229, 1, 123, 351);
INSERT INTO public.sales_items VALUES (229, 2, 50, 352);
INSERT INTO public.sales_items VALUES (230, 1, 30, 353);
INSERT INTO public.sales_items VALUES (230, 2, 10, 354);
INSERT INTO public.sales_items VALUES (231, 1, 1, 355);
INSERT INTO public.sales_items VALUES (232, 1, 35, 356);
INSERT INTO public.sales_items VALUES (232, 2, 10, 357);
INSERT INTO public.sales_items VALUES (233, 1, 14, 358);
INSERT INTO public.sales_items VALUES (234, 1, 35, 359);
INSERT INTO public.sales_items VALUES (234, 2, 3, 360);
INSERT INTO public.sales_items VALUES (235, 1, 200, 361);
INSERT INTO public.sales_items VALUES (236, 1, 15, 362);
INSERT INTO public.sales_items VALUES (236, 6, 20, 363);
INSERT INTO public.sales_items VALUES (237, 1, 80, 364);
INSERT INTO public.sales_items VALUES (238, 1, 30, 365);
INSERT INTO public.sales_items VALUES (238, 2, 6, 366);
INSERT INTO public.sales_items VALUES (238, 6, 1, 367);
INSERT INTO public.sales_items VALUES (239, 1, 16, 368);
INSERT INTO public.sales_items VALUES (239, 3, 2, 369);
INSERT INTO public.sales_items VALUES (240, 1, 40, 370);
INSERT INTO public.sales_items VALUES (240, 2, 10, 371);
INSERT INTO public.sales_items VALUES (241, 1, 20, 372);
INSERT INTO public.sales_items VALUES (242, 1, 26, 373);
INSERT INTO public.sales_items VALUES (242, 2, 5, 374);
INSERT INTO public.sales_items VALUES (242, 6, 2, 375);
INSERT INTO public.sales_items VALUES (243, 1, 13, 376);
INSERT INTO public.sales_items VALUES (243, 2, 9, 377);
INSERT INTO public.sales_items VALUES (244, 1, 7, 378);
INSERT INTO public.sales_items VALUES (245, 1, 20, 379);
INSERT INTO public.sales_items VALUES (245, 3, 3, 380);
INSERT INTO public.sales_items VALUES (246, 1, 40, 381);
INSERT INTO public.sales_items VALUES (247, 1, 20, 382);
INSERT INTO public.sales_items VALUES (247, 6, 1, 383);
INSERT INTO public.sales_items VALUES (248, 1, 30, 384);
INSERT INTO public.sales_items VALUES (248, 2, 5, 385);
INSERT INTO public.sales_items VALUES (249, 16, 192, 386);
INSERT INTO public.sales_items VALUES (250, 1, 30, 387);
INSERT INTO public.sales_items VALUES (251, 1, 30, 388);
INSERT INTO public.sales_items VALUES (252, 1, 70, 389);
INSERT INTO public.sales_items VALUES (252, 6, 11, 390);
INSERT INTO public.sales_items VALUES (253, 18, 342, 391);
INSERT INTO public.sales_items VALUES (254, 1, 33, 392);
INSERT INTO public.sales_items VALUES (254, 2, 4, 393);
INSERT INTO public.sales_items VALUES (255, 1, 40, 394);
INSERT INTO public.sales_items VALUES (256, 1, 30, 395);
INSERT INTO public.sales_items VALUES (257, 1, 2, 396);
INSERT INTO public.sales_items VALUES (258, 1, 25, 397);
INSERT INTO public.sales_items VALUES (258, 6, 10, 398);
INSERT INTO public.sales_items VALUES (259, 4, 50, 399);
INSERT INTO public.sales_items VALUES (260, 1, 30, 400);
INSERT INTO public.sales_items VALUES (260, 6, 1, 401);
INSERT INTO public.sales_items VALUES (261, 1, 300, 402);
INSERT INTO public.sales_items VALUES (262, 1, 500, 403);
INSERT INTO public.sales_items VALUES (262, 2, 500, 404);
INSERT INTO public.sales_items VALUES (262, 15, 56, 405);
INSERT INTO public.sales_items VALUES (262, 4, 262, 406);
INSERT INTO public.sales_items VALUES (263, 19, 307, 407);
INSERT INTO public.sales_items VALUES (263, 24, 140, 408);
INSERT INTO public.sales_items VALUES (264, 1, 30, 409);
INSERT INTO public.sales_items VALUES (264, 2, 5, 410);
INSERT INTO public.sales_items VALUES (265, 1, 38, 411);
INSERT INTO public.sales_items VALUES (265, 2, 6, 412);
INSERT INTO public.sales_items VALUES (265, 6, 2, 413);
INSERT INTO public.sales_items VALUES (266, 1, 18, 414);
INSERT INTO public.sales_items VALUES (267, 1, 23, 415);
INSERT INTO public.sales_items VALUES (267, 3, 2, 416);
INSERT INTO public.sales_items VALUES (268, 14, 500, 417);
INSERT INTO public.sales_items VALUES (269, 1, 17, 418);
INSERT INTO public.sales_items VALUES (269, 3, 1, 419);
INSERT INTO public.sales_items VALUES (270, 1, 18, 420);
INSERT INTO public.sales_items VALUES (271, 1, 40, 421);
INSERT INTO public.sales_items VALUES (272, 18, 305, 422);
INSERT INTO public.sales_items VALUES (272, 24, 300, 423);
INSERT INTO public.sales_items VALUES (273, 1, 40, 424);
INSERT INTO public.sales_items VALUES (274, 1, 1, 425);
INSERT INTO public.sales_items VALUES (274, 2, 1, 426);
INSERT INTO public.sales_items VALUES (275, 1, 65, 427);
INSERT INTO public.sales_items VALUES (275, 2, 20, 428);
INSERT INTO public.sales_items VALUES (276, 1, 13, 429);
INSERT INTO public.sales_items VALUES (276, 2, 10, 430);
INSERT INTO public.sales_items VALUES (277, 21, 600, 431);
INSERT INTO public.sales_items VALUES (277, 4, 100, 432);
INSERT INTO public.sales_items VALUES (277, 14, 753, 433);
INSERT INTO public.sales_items VALUES (278, 1, 30, 434);
INSERT INTO public.sales_items VALUES (278, 2, 10, 435);
INSERT INTO public.sales_items VALUES (279, 1, 30, 436);
INSERT INTO public.sales_items VALUES (279, 2, 5, 437);
INSERT INTO public.sales_items VALUES (279, 6, 1, 438);
INSERT INTO public.sales_items VALUES (280, 1, 30, 439);
INSERT INTO public.sales_items VALUES (280, 2, 5, 440);
INSERT INTO public.sales_items VALUES (280, 6, 1, 441);
INSERT INTO public.sales_items VALUES (281, 1, 215, 442);
INSERT INTO public.sales_items VALUES (281, 2, 150, 443);
INSERT INTO public.sales_items VALUES (283, 1, 30, 446);
INSERT INTO public.sales_items VALUES (283, 2, 5, 447);
INSERT INTO public.sales_items VALUES (283, 6, 2, 448);
INSERT INTO public.sales_items VALUES (284, 1, 25, 449);
INSERT INTO public.sales_items VALUES (284, 6, 1, 450);
INSERT INTO public.sales_items VALUES (285, 1, 30, 451);
INSERT INTO public.sales_items VALUES (285, 2, 10, 452);
INSERT INTO public.sales_items VALUES (286, 1, 70, 453);
INSERT INTO public.sales_items VALUES (286, 2, 20, 454);
INSERT INTO public.sales_items VALUES (286, 6, 10, 455);
INSERT INTO public.sales_items VALUES (287, 1, 500, 456);
INSERT INTO public.sales_items VALUES (288, 1, 40, 457);
INSERT INTO public.sales_items VALUES (288, 2, 10, 458);
INSERT INTO public.sales_items VALUES (289, 1, 30, 459);
INSERT INTO public.sales_items VALUES (290, 27, 900, 460);
INSERT INTO public.sales_items VALUES (290, 4, 100, 461);
INSERT INTO public.sales_items VALUES (291, 26, 234, 462);
INSERT INTO public.sales_items VALUES (292, 1, 30, 463);
INSERT INTO public.sales_items VALUES (292, 2, 5, 464);
INSERT INTO public.sales_items VALUES (292, 6, 2, 465);
INSERT INTO public.sales_items VALUES (293, 1, 50, 466);
INSERT INTO public.sales_items VALUES (293, 2, 20, 467);
INSERT INTO public.sales_items VALUES (293, 6, 11, 468);
INSERT INTO public.sales_items VALUES (294, 1, 30, 469);
INSERT INTO public.sales_items VALUES (295, 1, 30, 470);
INSERT INTO public.sales_items VALUES (295, 6, 3, 471);
INSERT INTO public.sales_items VALUES (297, 21, 283, 475);
INSERT INTO public.sales_items VALUES (297, 14, 1380, 476);
INSERT INTO public.sales_items VALUES (297, 15, 105, 477);
INSERT INTO public.sales_items VALUES (298, 3, 2, 479);
INSERT INTO public.sales_items VALUES (299, 1, 21, 480);
INSERT INTO public.sales_items VALUES (300, 1, 50, 481);
INSERT INTO public.sales_items VALUES (300, 2, 10, 482);
INSERT INTO public.sales_items VALUES (300, 6, 10, 483);
INSERT INTO public.sales_items VALUES (301, 1, 1, 484);
INSERT INTO public.sales_items VALUES (302, 1, 15, 485);
INSERT INTO public.sales_items VALUES (302, 3, 2, 486);
INSERT INTO public.sales_items VALUES (302, 2, 2, 487);
INSERT INTO public.sales_items VALUES (303, 1, 18, 488);
INSERT INTO public.sales_items VALUES (304, 1, 25, 489);
INSERT INTO public.sales_items VALUES (298, 1, 40, 478);
INSERT INTO public.sales_items VALUES (305, 1, 27, 490);
INSERT INTO public.sales_items VALUES (305, 2, 10, 491);
INSERT INTO public.sales_items VALUES (306, 1, 40, 492);
INSERT INTO public.sales_items VALUES (307, 1, 35, 493);
INSERT INTO public.sales_items VALUES (307, 2, 10, 494);
INSERT INTO public.sales_items VALUES (308, 1, 60, 495);
INSERT INTO public.sales_items VALUES (308, 2, 20, 496);
INSERT INTO public.sales_items VALUES (308, 6, 10, 497);
INSERT INTO public.sales_items VALUES (309, 1, 30, 498);
INSERT INTO public.sales_items VALUES (309, 6, 2, 499);
INSERT INTO public.sales_items VALUES (310, 18, 316, 500);
INSERT INTO public.sales_items VALUES (310, 17, 100, 501);
INSERT INTO public.sales_items VALUES (311, 1, 18, 502);
INSERT INTO public.sales_items VALUES (312, 1, 70, 503);
INSERT INTO public.sales_items VALUES (312, 3, 5, 504);
INSERT INTO public.sales_items VALUES (313, 15, 813, 505);
INSERT INTO public.sales_items VALUES (313, 1, 269, 506);
INSERT INTO public.sales_items VALUES (314, 1, 50, 507);
INSERT INTO public.sales_items VALUES (314, 6, 15, 508);
INSERT INTO public.sales_items VALUES (314, 2, 10, 509);
INSERT INTO public.sales_items VALUES (315, 22, 228, 510);
INSERT INTO public.sales_items VALUES (315, 17, 138, 511);
INSERT INTO public.sales_items VALUES (316, 1, 11, 512);
INSERT INTO public.sales_items VALUES (316, 2, 15, 513);
INSERT INTO public.sales_items VALUES (317, 1, 20, 514);
INSERT INTO public.sales_items VALUES (317, 2, 1, 515);
INSERT INTO public.sales_items VALUES (317, 3, 5, 516);
INSERT INTO public.sales_items VALUES (318, 1, 50, 517);
INSERT INTO public.sales_items VALUES (318, 2, 10, 518);
INSERT INTO public.sales_items VALUES (318, 3, 5, 519);
INSERT INTO public.sales_items VALUES (319, 1, 25, 520);
INSERT INTO public.sales_items VALUES (320, 19, 338, 521);
INSERT INTO public.sales_items VALUES (321, 1, 30, 522);
INSERT INTO public.sales_items VALUES (322, 1, 1, 523);
INSERT INTO public.sales_items VALUES (322, 2, 1, 524);
INSERT INTO public.sales_items VALUES (323, 1, 35, 525);
INSERT INTO public.sales_items VALUES (323, 2, 10, 526);
INSERT INTO public.sales_items VALUES (324, 1, 70, 527);
INSERT INTO public.sales_items VALUES (325, 1, 30, 528);
INSERT INTO public.sales_items VALUES (325, 2, 5, 529);
INSERT INTO public.sales_items VALUES (326, 1, 33, 530);
INSERT INTO public.sales_items VALUES (326, 2, 10, 531);
INSERT INTO public.sales_items VALUES (326, 6, 5, 532);
INSERT INTO public.sales_items VALUES (327, 7, 43, 533);
INSERT INTO public.sales_items VALUES (327, 4, 7, 534);
INSERT INTO public.sales_items VALUES (328, 1, 15, 535);
INSERT INTO public.sales_items VALUES (328, 6, 8, 536);
INSERT INTO public.sales_items VALUES (329, 1, 35, 537);
INSERT INTO public.sales_items VALUES (329, 2, 10, 538);
INSERT INTO public.sales_items VALUES (330, 1, 25, 539);
INSERT INTO public.sales_items VALUES (331, 1, 500, 540);
INSERT INTO public.sales_items VALUES (331, 2, 200, 541);
INSERT INTO public.sales_items VALUES (332, 1, 30, 542);
INSERT INTO public.sales_items VALUES (333, 1, 14, 543);
INSERT INTO public.sales_items VALUES (334, 1, 40, 544);
INSERT INTO public.sales_items VALUES (334, 2, 5, 545);
INSERT INTO public.sales_items VALUES (335, 8, 80, 546);
INSERT INTO public.sales_items VALUES (336, 28, 250, 547);
INSERT INTO public.sales_items VALUES (337, 1, 40, 548);
INSERT INTO public.sales_items VALUES (337, 2, 50, 549);
INSERT INTO public.sales_items VALUES (337, 6, 10, 550);
INSERT INTO public.sales_items VALUES (338, 2, 300, 551);
INSERT INTO public.sales_items VALUES (338, 1, 826, 552);
INSERT INTO public.sales_items VALUES (339, 1, 30, 553);
INSERT INTO public.sales_items VALUES (339, 2, 10, 554);
INSERT INTO public.sales_items VALUES (340, 1, 40, 555);
INSERT INTO public.sales_items VALUES (341, 3, 10, 556);
INSERT INTO public.sales_items VALUES (342, 1, 18, 557);
INSERT INTO public.sales_items VALUES (343, 1, 80, 558);
INSERT INTO public.sales_items VALUES (343, 2, 5, 559);
INSERT INTO public.sales_items VALUES (344, 1, 60, 560);
INSERT INTO public.sales_items VALUES (344, 2, 40, 561);
INSERT INTO public.sales_items VALUES (344, 6, 5, 562);
INSERT INTO public.sales_items VALUES (345, 1, 40, 563);
INSERT INTO public.sales_items VALUES (345, 2, 10, 564);
INSERT INTO public.sales_items VALUES (346, 8, 140, 565);
INSERT INTO public.sales_items VALUES (347, 1, 75, 566);
INSERT INTO public.sales_items VALUES (348, 2, 30, 567);
INSERT INTO public.sales_items VALUES (348, 1, 60, 568);
INSERT INTO public.sales_items VALUES (348, 6, 10, 569);
INSERT INTO public.sales_items VALUES (349, 1, 30, 570);
INSERT INTO public.sales_items VALUES (349, 6, 3, 571);
INSERT INTO public.sales_items VALUES (350, 1, 15, 572);
INSERT INTO public.sales_items VALUES (350, 2, 2, 573);
INSERT INTO public.sales_items VALUES (350, 3, 2, 574);
INSERT INTO public.sales_items VALUES (351, 21, 116, 575);
INSERT INTO public.sales_items VALUES (351, 20, 134, 576);
INSERT INTO public.sales_items VALUES (352, 1, 25, 577);
INSERT INTO public.sales_items VALUES (352, 6, 1, 578);
INSERT INTO public.sales_items VALUES (353, 1, 40, 579);
INSERT INTO public.sales_items VALUES (353, 3, 32, 580);
INSERT INTO public.sales_items VALUES (353, 2, 5, 581);
INSERT INTO public.sales_items VALUES (354, 1, 16, 582);
INSERT INTO public.sales_items VALUES (354, 3, 2, 583);
INSERT INTO public.sales_items VALUES (355, 1, 10, 584);
INSERT INTO public.sales_items VALUES (355, 2, 16, 585);
INSERT INTO public.sales_items VALUES (356, 1, 200, 586);
INSERT INTO public.sales_items VALUES (356, 2, 200, 587);
INSERT INTO public.sales_items VALUES (357, 1, 100, 588);
INSERT INTO public.sales_items VALUES (358, 1, 1, 589);
INSERT INTO public.sales_items VALUES (359, 1, 40, 590);
INSERT INTO public.sales_items VALUES (360, 1, 30, 591);
INSERT INTO public.sales_items VALUES (360, 2, 2, 592);
INSERT INTO public.sales_items VALUES (360, 6, 2, 593);
INSERT INTO public.sales_items VALUES (361, 20, 250, 594);
INSERT INTO public.sales_items VALUES (362, 1, 25, 595);
INSERT INTO public.sales_items VALUES (362, 2, 10, 596);
INSERT INTO public.sales_items VALUES (363, 1, 20, 597);
INSERT INTO public.sales_items VALUES (363, 2, 10, 598);
INSERT INTO public.sales_items VALUES (364, 1, 18, 599);
INSERT INTO public.sales_items VALUES (365, 2, 1, 600);
INSERT INTO public.sales_items VALUES (366, 1, 1, 601);
INSERT INTO public.sales_items VALUES (366, 2, 1, 602);
INSERT INTO public.sales_items VALUES (367, 1, 30, 603);
INSERT INTO public.sales_items VALUES (367, 2, 5, 604);
INSERT INTO public.sales_items VALUES (367, 6, 1, 605);
INSERT INTO public.sales_items VALUES (368, 1, 30, 606);
INSERT INTO public.sales_items VALUES (368, 2, 6, 607);
INSERT INTO public.sales_items VALUES (369, 1, 40, 608);
INSERT INTO public.sales_items VALUES (370, 1, 30, 609);
INSERT INTO public.sales_items VALUES (371, 1, 100, 610);
INSERT INTO public.sales_items VALUES (372, 1, 120, 611);
INSERT INTO public.sales_items VALUES (373, 21, 400, 612);
INSERT INTO public.sales_items VALUES (373, 28, 100, 613);
INSERT INTO public.sales_items VALUES (373, 1, 125, 614);
INSERT INTO public.sales_items VALUES (374, 1, 30, 615);
INSERT INTO public.sales_items VALUES (374, 2, 20, 616);
INSERT INTO public.sales_items VALUES (375, 7, 40, 617);
INSERT INTO public.sales_items VALUES (375, 4, 10, 618);
INSERT INTO public.sales_items VALUES (376, 1, 17, 619);
INSERT INTO public.sales_items VALUES (376, 2, 2, 620);
INSERT INTO public.sales_items VALUES (377, 7, 100, 621);
INSERT INTO public.sales_items VALUES (378, 1, 70, 622);
INSERT INTO public.sales_items VALUES (378, 2, 20, 623);
INSERT INTO public.sales_items VALUES (379, 1, 40, 624);
INSERT INTO public.sales_items VALUES (379, 2, 10, 625);
INSERT INTO public.sales_items VALUES (379, 3, 9, 626);
INSERT INTO public.sales_items VALUES (380, 1, 300, 627);
INSERT INTO public.sales_items VALUES (380, 2, 300, 628);
INSERT INTO public.sales_items VALUES (381, 1, 23, 629);
INSERT INTO public.sales_items VALUES (381, 2, 5, 630);
INSERT INTO public.sales_items VALUES (382, 1, 25, 631);
INSERT INTO public.sales_items VALUES (383, 1, 20, 632);
INSERT INTO public.sales_items VALUES (383, 6, 1, 633);
INSERT INTO public.sales_items VALUES (384, 1, 60, 634);
INSERT INTO public.sales_items VALUES (384, 2, 20, 635);
INSERT INTO public.sales_items VALUES (384, 6, 10, 636);
INSERT INTO public.sales_items VALUES (385, 1, 63, 637);
INSERT INTO public.sales_items VALUES (385, 2, 15, 638);
INSERT INTO public.sales_items VALUES (386, 1, 40, 639);
INSERT INTO public.sales_items VALUES (386, 6, 11, 641);
INSERT INTO public.sales_items VALUES (386, 2, 20, 640);
INSERT INTO public.sales_items VALUES (387, 1, 70, 642);
INSERT INTO public.sales_items VALUES (387, 2, 10, 643);
INSERT INTO public.sales_items VALUES (387, 3, 15, 644);
INSERT INTO public.sales_items VALUES (388, 1, 30, 645);
INSERT INTO public.sales_items VALUES (389, 1, 15, 646);
INSERT INTO public.sales_items VALUES (389, 3, 3, 647);
INSERT INTO public.sales_items VALUES (390, 1, 20, 648);
INSERT INTO public.sales_items VALUES (390, 2, 15, 649);
INSERT INTO public.sales_items VALUES (391, 1, 1, 650);
INSERT INTO public.sales_items VALUES (391, 2, 1, 651);
INSERT INTO public.sales_items VALUES (392, 1, 40, 652);
INSERT INTO public.sales_items VALUES (393, 1, 18, 653);
INSERT INTO public.sales_items VALUES (394, 1, 80, 654);
INSERT INTO public.sales_items VALUES (394, 2, 10, 655);
INSERT INTO public.sales_items VALUES (394, 6, 5, 656);
INSERT INTO public.sales_items VALUES (395, 1, 35, 657);
INSERT INTO public.sales_items VALUES (437, 1, 25, 737);
INSERT INTO public.sales_items VALUES (395, 6, 1, 658);
INSERT INTO public.sales_items VALUES (396, 1, 18, 659);
INSERT INTO public.sales_items VALUES (397, 1, 30, 660);
INSERT INTO public.sales_items VALUES (398, 1, 30, 661);
INSERT INTO public.sales_items VALUES (398, 2, 5, 662);
INSERT INTO public.sales_items VALUES (398, 6, 1, 663);
INSERT INTO public.sales_items VALUES (399, 1, 40, 664);
INSERT INTO public.sales_items VALUES (399, 2, 15, 665);
INSERT INTO public.sales_items VALUES (400, 1, 20, 666);
INSERT INTO public.sales_items VALUES (401, 7, 40, 667);
INSERT INTO public.sales_items VALUES (401, 4, 10, 668);
INSERT INTO public.sales_items VALUES (402, 1, 30, 669);
INSERT INTO public.sales_items VALUES (402, 6, 1, 670);
INSERT INTO public.sales_items VALUES (403, 1, 70, 671);
INSERT INTO public.sales_items VALUES (403, 2, 10, 672);
INSERT INTO public.sales_items VALUES (403, 6, 10, 673);
INSERT INTO public.sales_items VALUES (405, 1, 15, 675);
INSERT INTO public.sales_items VALUES (406, 1, 30, 676);
INSERT INTO public.sales_items VALUES (407, 1, 33, 677);
INSERT INTO public.sales_items VALUES (408, 21, 600, 678);
INSERT INTO public.sales_items VALUES (408, 20, 366, 679);
INSERT INTO public.sales_items VALUES (408, 28, 100, 680);
INSERT INTO public.sales_items VALUES (409, 1, 2, 681);
INSERT INTO public.sales_items VALUES (409, 6, 1, 682);
INSERT INTO public.sales_items VALUES (410, 1, 14, 683);
INSERT INTO public.sales_items VALUES (410, 3, 5, 684);
INSERT INTO public.sales_items VALUES (411, 1, 30, 685);
INSERT INTO public.sales_items VALUES (412, 1, 1, 686);
INSERT INTO public.sales_items VALUES (413, 1, 20, 687);
INSERT INTO public.sales_items VALUES (413, 2, 2, 688);
INSERT INTO public.sales_items VALUES (413, 3, 2, 689);
INSERT INTO public.sales_items VALUES (414, 1, 25, 690);
INSERT INTO public.sales_items VALUES (414, 2, 5, 691);
INSERT INTO public.sales_items VALUES (414, 3, 2, 692);
INSERT INTO public.sales_items VALUES (415, 1, 30, 693);
INSERT INTO public.sales_items VALUES (415, 2, 10, 694);
INSERT INTO public.sales_items VALUES (415, 6, 1, 695);
INSERT INTO public.sales_items VALUES (416, 1, 40, 696);
INSERT INTO public.sales_items VALUES (416, 2, 10, 697);
INSERT INTO public.sales_items VALUES (417, 1, 70, 698);
INSERT INTO public.sales_items VALUES (417, 2, 20, 699);
INSERT INTO public.sales_items VALUES (418, 1, 25, 700);
INSERT INTO public.sales_items VALUES (418, 2, 2, 701);
INSERT INTO public.sales_items VALUES (419, 1, 432, 702);
INSERT INTO public.sales_items VALUES (419, 2, 500, 703);
INSERT INTO public.sales_items VALUES (404, 1, 300, 674);
INSERT INTO public.sales_items VALUES (404, 2, 200, 704);
INSERT INTO public.sales_items VALUES (420, 19, 109, 705);
INSERT INTO public.sales_items VALUES (420, 26, 231, 706);
INSERT INTO public.sales_items VALUES (420, 18, 245, 707);
INSERT INTO public.sales_items VALUES (421, 1, 30, 708);
INSERT INTO public.sales_items VALUES (423, 1, 40, 710);
INSERT INTO public.sales_items VALUES (423, 6, 1, 711);
INSERT INTO public.sales_items VALUES (424, 14, 1000, 712);
INSERT INTO public.sales_items VALUES (424, 15, 554, 713);
INSERT INTO public.sales_items VALUES (425, 1, 300, 714);
INSERT INTO public.sales_items VALUES (426, 1, 15, 715);
INSERT INTO public.sales_items VALUES (426, 2, 4, 716);
INSERT INTO public.sales_items VALUES (426, 3, 2, 717);
INSERT INTO public.sales_items VALUES (427, 19, 120, 718);
INSERT INTO public.sales_items VALUES (428, 7, 30, 719);
INSERT INTO public.sales_items VALUES (428, 4, 20, 720);
INSERT INTO public.sales_items VALUES (429, 1, 60, 721);
INSERT INTO public.sales_items VALUES (429, 2, 25, 722);
INSERT INTO public.sales_items VALUES (429, 6, 10, 723);
INSERT INTO public.sales_items VALUES (430, 1, 35, 724);
INSERT INTO public.sales_items VALUES (430, 2, 5, 725);
INSERT INTO public.sales_items VALUES (431, 1, 15, 726);
INSERT INTO public.sales_items VALUES (431, 3, 3, 727);
INSERT INTO public.sales_items VALUES (432, 1, 18, 728);
INSERT INTO public.sales_items VALUES (433, 1, 40, 729);
INSERT INTO public.sales_items VALUES (434, 1, 1, 730);
INSERT INTO public.sales_items VALUES (434, 2, 1, 731);
INSERT INTO public.sales_items VALUES (435, 1, 40, 732);
INSERT INTO public.sales_items VALUES (435, 2, 5, 733);
INSERT INTO public.sales_items VALUES (436, 1, 27, 734);
INSERT INTO public.sales_items VALUES (436, 2, 15, 735);
INSERT INTO public.sales_items VALUES (436, 6, 5, 736);
INSERT INTO public.sales_items VALUES (437, 6, 1, 738);
INSERT INTO public.sales_items VALUES (438, 1, 10, 739);
INSERT INTO public.sales_items VALUES (439, 1, 25, 740);
INSERT INTO public.sales_items VALUES (439, 2, 9, 741);
INSERT INTO public.sales_items VALUES (439, 6, 1, 742);
INSERT INTO public.sales_items VALUES (440, 2, 30, 743);
INSERT INTO public.sales_items VALUES (440, 1, 60, 744);
INSERT INTO public.sales_items VALUES (440, 6, 5, 745);
INSERT INTO public.sales_items VALUES (441, 1, 4, 746);


--
-- TOC entry 3419 (class 0 OID 24781)
-- Dependencies: 227
-- Data for Name: stocks_flow; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3443 (class 0 OID 0)
-- Dependencies: 229
-- Name: customers_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_customer_id_seq', 11, true);


--
-- TOC entry 3444 (class 0 OID 0)
-- Dependencies: 210
-- Name: delivered_packagings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.delivered_packagings_id_seq', 7, true);


--
-- TOC entry 3445 (class 0 OID 0)
-- Dependencies: 231
-- Name: packaging_adjustments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.packaging_adjustments_id_seq', 1, false);


--
-- TOC entry 3446 (class 0 OID 0)
-- Dependencies: 212
-- Name: packagings_packaging_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.packagings_packaging_id_seq', 8, false);


--
-- TOC entry 3447 (class 0 OID 0)
-- Dependencies: 214
-- Name: product_sales_sales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_sales_sales_id_seq', 441, true);


--
-- TOC entry 3448 (class 0 OID 0)
-- Dependencies: 216
-- Name: production_outputs_production_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.production_outputs_production_id_seq', 123, true);


--
-- TOC entry 3449 (class 0 OID 0)
-- Dependencies: 218
-- Name: products_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_product_id_seq', 28, true);


--
-- TOC entry 3450 (class 0 OID 0)
-- Dependencies: 220
-- Name: released_packagings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.released_packagings_id_seq', 66, true);


--
-- TOC entry 3451 (class 0 OID 0)
-- Dependencies: 222
-- Name: repro_products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.repro_products_id_seq', 17, true);


--
-- TOC entry 3452 (class 0 OID 0)
-- Dependencies: 224
-- Name: returned_packagings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.returned_packagings_id_seq', 15, true);


--
-- TOC entry 3453 (class 0 OID 0)
-- Dependencies: 226
-- Name: sales_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sales_items_id_seq', 746, true);


--
-- TOC entry 3454 (class 0 OID 0)
-- Dependencies: 228
-- Name: stocks_flow_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stocks_flow_id_seq', 1, false);


--
-- TOC entry 3233 (class 2606 OID 24798)
-- Name: delivered_packagings delivered_packagings_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivered_packagings
    ADD CONSTRAINT delivered_packagings_pk PRIMARY KEY (id);


--
-- TOC entry 3236 (class 2606 OID 24800)
-- Name: packagings packagings_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.packagings
    ADD CONSTRAINT packagings_pk PRIMARY KEY (packaging_id);


--
-- TOC entry 3238 (class 2606 OID 24802)
-- Name: product_sales product_sales_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_sales
    ADD CONSTRAINT product_sales_pk PRIMARY KEY (sales_id);


--
-- TOC entry 3240 (class 2606 OID 24804)
-- Name: production_outputs production_outputs_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.production_outputs
    ADD CONSTRAINT production_outputs_pk PRIMARY KEY (production_id);


--
-- TOC entry 3242 (class 2606 OID 24806)
-- Name: products products_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pk PRIMARY KEY (product_id);


--
-- TOC entry 3244 (class 2606 OID 24808)
-- Name: released_packagings released_packagings_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.released_packagings
    ADD CONSTRAINT released_packagings_pk PRIMARY KEY (id);


--
-- TOC entry 3246 (class 2606 OID 24810)
-- Name: repro_products repro_products_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repro_products
    ADD CONSTRAINT repro_products_pk PRIMARY KEY (id);


--
-- TOC entry 3248 (class 2606 OID 24812)
-- Name: returned_packagings returned_packagings_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.returned_packagings
    ADD CONSTRAINT returned_packagings_pk PRIMARY KEY (id);


--
-- TOC entry 3250 (class 2606 OID 24814)
-- Name: sales_items sales_items_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_items
    ADD CONSTRAINT sales_items_pk PRIMARY KEY (sales_item_id);


--
-- TOC entry 3252 (class 1259 OID 41249)
-- Name: packaging_adjustments_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX packaging_adjustments_id_idx ON public.packaging_adjustments USING btree (id);


--
-- TOC entry 3234 (class 1259 OID 24815)
-- Name: packagings_packaging_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX packagings_packaging_id_idx ON public.packagings USING btree (packaging_id);


--
-- TOC entry 3251 (class 1259 OID 24816)
-- Name: stocks_flow_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX stocks_flow_id_idx ON public.stocks_flow USING btree (id);


--
-- TOC entry 3253 (class 2606 OID 24817)
-- Name: delivered_packagings delivered_packagings_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivered_packagings
    ADD CONSTRAINT delivered_packagings_fk FOREIGN KEY (packaging_id) REFERENCES public.packagings(packaging_id) ON DELETE CASCADE;


--
-- TOC entry 3261 (class 2606 OID 41250)
-- Name: packaging_adjustments packaging_adjustments_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.packaging_adjustments
    ADD CONSTRAINT packaging_adjustments_fk FOREIGN KEY (packaging_id) REFERENCES public.packagings(packaging_id) ON DELETE CASCADE;


--
-- TOC entry 3254 (class 2606 OID 24822)
-- Name: production_outputs production_outputs_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.production_outputs
    ADD CONSTRAINT production_outputs_fk FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- TOC entry 3255 (class 2606 OID 24827)
-- Name: released_packagings released_packagings_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.released_packagings
    ADD CONSTRAINT released_packagings_fk FOREIGN KEY (packaging_id) REFERENCES public.packagings(packaging_id) ON DELETE CASCADE;


--
-- TOC entry 3256 (class 2606 OID 24832)
-- Name: repro_products repro_products_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repro_products
    ADD CONSTRAINT repro_products_fk FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- TOC entry 3257 (class 2606 OID 24837)
-- Name: returned_packagings returned_packagings_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.returned_packagings
    ADD CONSTRAINT returned_packagings_fk FOREIGN KEY (packaging_id) REFERENCES public.packagings(packaging_id) ON DELETE CASCADE;


--
-- TOC entry 3258 (class 2606 OID 24842)
-- Name: sales_items sales_items_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_items
    ADD CONSTRAINT sales_items_fk FOREIGN KEY (sales_id) REFERENCES public.product_sales(sales_id) ON DELETE CASCADE;


--
-- TOC entry 3259 (class 2606 OID 24847)
-- Name: sales_items sales_items_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_items
    ADD CONSTRAINT sales_items_fk_1 FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- TOC entry 3260 (class 2606 OID 24852)
-- Name: stocks_flow stocks_flow_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stocks_flow
    ADD CONSTRAINT stocks_flow_fk FOREIGN KEY (product_id) REFERENCES public.products(product_id);


-- Completed on 2023-09-04 16:24:00

--
-- PostgreSQL database dump complete
--

