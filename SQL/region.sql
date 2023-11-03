DROP TABLE region;

CREATE TABLE region
(
    region_id bigserial PRIMARY KEY NOT NULL,
    region_nombre varchar(32),
    region_codigo varchar(5)
);

ALTER TABLE public.region OWNER TO app_vav;
CREATE SEQUENCE region_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER TABLE public.region_id_seq OWNER TO app_vav;
ALTER SEQUENCE region_id_seq OWNED BY region.region_id;
ALTER TABLE ONLY region ALTER COLUMN region_id SET DEFAULT nextval('region_id_seq'::regclass);

REVOKE ALL ON TABLE region FROM PUBLIC;
REVOKE ALL ON TABLE region FROM app_vav;
GRANT ALL ON TABLE region TO app_vav;