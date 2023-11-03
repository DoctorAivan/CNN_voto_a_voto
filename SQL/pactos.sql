DROP TABLE pacto;

CREATE TABLE pacto
(
    pacto_id bigserial PRIMARY KEY NOT NULL,
    pacto_codigo varchar(3),
    pacto_nombre varchar(32)
);

ALTER TABLE public.pacto OWNER TO app_vav;
CREATE SEQUENCE pacto_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER TABLE public.pacto_id_seq OWNER TO app_vav;
ALTER SEQUENCE pacto_id_seq OWNED BY pacto.pacto_id;
ALTER TABLE ONLY pacto ALTER COLUMN pacto_id SET DEFAULT nextval('pacto_id_seq'::regclass);

REVOKE ALL ON TABLE pacto FROM PUBLIC;
REVOKE ALL ON TABLE pacto FROM app_vav;
GRANT ALL ON TABLE pacto TO app_vav;