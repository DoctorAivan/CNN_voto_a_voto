

ALC     =   ALCALDES
CNC     =   CONCEJALES
GBN     =   GOBERNADORES
CNT     =   CONSTITUYENTES

DROP TABLE candidato;

CREATE TABLE candidato
(
    candidato_id bigserial PRIMARY KEY NOT NULL,
    candidato_tipo varchar(3) check(candidato_tipo in ('ALC','CNC','GBN','CNT')) DEFAULT 'ALC',
    candidato_orden smallint NOT NULL DEFAULT 1,
    candidato_zona bigint NOT NULL DEFAULT 0,
    pacto_id bigint NOT NULL DEFAULT 1 REFERENCES pacto(pacto_id) ON DELETE CASCADE,
    partido_id bigint NOT NULL DEFAULT 1 REFERENCES partido(partido_id) ON DELETE CASCADE,
    candidato_nombre varchar(64),
    candidato_nombre_corto varchar(64),
    candidato_genero varchar(1) DEFAULT 'n',
    candidato_independiente boolean DEFAULT false
);

ALTER TABLE public.candidato OWNER TO app_vav;
CREATE SEQUENCE candidato_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER TABLE public.candidato_id_seq OWNER TO app_vav;
ALTER SEQUENCE candidato_id_seq OWNED BY candidato.candidato_id;
ALTER TABLE ONLY candidato ALTER COLUMN candidato_id SET DEFAULT nextval('candidato_id_seq'::regclass);

REVOKE ALL ON TABLE candidato FROM PUBLIC;
REVOKE ALL ON TABLE candidato FROM app_vav;
GRANT ALL ON TABLE candidato TO app_vav;