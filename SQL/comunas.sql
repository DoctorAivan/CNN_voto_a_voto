DROP TABLE comuna;

CREATE TABLE comuna
(
    comuna_id bigserial PRIMARY KEY NOT NULL,
    region_id bigint NOT NULL DEFAULT 1 REFERENCES region(region_id) ON DELETE RESTRICT,
    distrito_id smallint NOT NULL,
    comuna_nombre varchar(32)
);

ALTER TABLE public.comuna OWNER TO app_vav;
CREATE SEQUENCE comuna_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER TABLE public.comuna_id_seq OWNER TO app_vav;
ALTER SEQUENCE comuna_id_seq OWNED BY comuna.comuna_id;
ALTER TABLE ONLY comuna ALTER COLUMN comuna_id SET DEFAULT nextval('comuna_id_seq'::regclass);

REVOKE ALL ON TABLE comuna FROM PUBLIC;
REVOKE ALL ON TABLE comuna FROM app_vav;
GRANT ALL ON TABLE comuna TO app_vav;