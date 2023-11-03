DROP TABLE voto;

CREATE TABLE voto
(
    voto_id bigserial PRIMARY KEY NOT NULL,
    candidato_id bigint NOT NULL DEFAULT 1 REFERENCES candidato(candidato_id) ON DELETE CASCADE,
    mesa_id bigint NOT NULL DEFAULT 1 REFERENCES mesa(mesa_id) ON DELETE CASCADE,
    voto_total smallint NOT NULL
);

ALTER TABLE public.voto OWNER TO app_vav;
CREATE SEQUENCE voto_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER TABLE public.voto_id_seq OWNER TO app_vav;
ALTER SEQUENCE voto_id_seq OWNED BY voto.voto_id;
ALTER TABLE ONLY voto ALTER COLUMN voto_id SET DEFAULT nextval('voto_id_seq'::regclass);

REVOKE ALL ON TABLE voto FROM PUBLIC;
REVOKE ALL ON TABLE voto FROM app_vav;
GRANT ALL ON TABLE voto TO app_vav;