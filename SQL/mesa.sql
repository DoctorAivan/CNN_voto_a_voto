

	ALC     =   ALCALDES
	ALC     =   ALCALDES
	CNC     =   CONCEJALES
	GBN     =   GOBERNADORES
	CNT     =   CONSTITUYENTES

	DROP TABLE mesa;

	CREATE TABLE mesa
	(
		mesa_id bigserial PRIMARY KEY NOT NULL,
		usuario_id bigint NOT NULL DEFAULT 1 REFERENCES usuario(usuario_id) ON DELETE CASCADE,
		mesa_tipo varchar(3) check(mesa_tipo in ('ALC','CNC','GBN','CNT')) DEFAULT 'ALC',
		mesa_zona bigint NOT NULL DEFAULT 0,
		mesa_zona_titulo varchar(64),
		mesa_comuna varchar(64),
		mesa_local varchar(64),
		mesa_numero varchar(64) DEFAULT 'Mesa ',
		mesa_orden smallint NOT NULL DEFAULT 1,
		mesa_estado smallint NOT NULL DEFAULT 0,
		mesa_destacada smallint NOT NULL DEFAULT 0,
		mesa_votos_blancos smallint NOT NULL DEFAULT 0,
		mesa_votos_nulos smallint NOT NULL DEFAULT 0,
		mesa_cambio timestamp without time zone DEFAULT now() NOT NULL,
		mesa_creado timestamp without time zone DEFAULT now() NOT NULL
	);

	ALTER TABLE public.mesa OWNER TO app_vav;
	CREATE SEQUENCE mesa_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
	ALTER TABLE public.mesa_id_seq OWNER TO app_vav;
	ALTER SEQUENCE mesa_id_seq OWNED BY mesa.mesa_id;
	ALTER TABLE ONLY mesa ALTER COLUMN mesa_id SET DEFAULT nextval('mesa_id_seq'::regclass);

	REVOKE ALL ON TABLE mesa FROM PUBLIC;
	REVOKE ALL ON TABLE mesa FROM app_vav;
	GRANT ALL ON TABLE mesa TO app_vav;

--			-			-			-			-			-			-			-			-

--  ELIMINAR PROCESO
	DROP FUNCTION mesa_nuevo
	(
		bigint,
        character varying,
        bigint,
        character varying
	);

--	CREAR NUEVA MESA
	CREATE FUNCTION mesa_nuevo
	(
		in_usuario_id bigint,
        in_mesa_tipo character varying,
        in_mesa_zona bigint,
        in_mesa_zona_titulo character varying,
		in_mesa_comuna character varying
	)
		RETURNS bigint
	    LANGUAGE plpgsql
	    AS $$
	    
		DECLARE
			in_mesa_id bigint;
		BEGIN

        SELECT nextval('mesa_id_seq') INTO in_mesa_id;
        
        INSERT INTO mesa
        (
        	mesa_id,
        	usuario_id,
            mesa_tipo,
            mesa_zona,
            mesa_zona_titulo,
			mesa_comuna
        )
		VALUES
		(
			in_mesa_id,
			in_usuario_id,
            in_mesa_tipo,
            in_mesa_zona,
            in_mesa_zona_titulo,
			in_mesa_comuna
		);

    --  AGREGAR CANDIDATOS A LA MESA
        INSERT INTO voto (candidato_id, mesa_id, voto_total) SELECT candidato_id, in_mesa_id, 0 FROM candidato WHERE candidato_tipo = in_mesa_tipo AND candidato_zona = in_mesa_zona;

        RETURN in_mesa_id;
	        
	END $$;

--			-			-			-			-			-			-			-			-
--			-			-			-			-			-			-			-			-

--  ELIMINAR PROCESO
	DROP FUNCTION mesa_guardar
	(
	    bigint,
		bigint,
		bigint,
	    character varying,
	    character varying,
		character varying
	);

--	MESA GUARDAR
	CREATE OR REPLACE FUNCTION mesa_guardar
	(
	    in_mesa_id bigint,
		in_usuario_id bigint,
		in_mesa_estado bigint,
		in_mesa_comuna character varying,
	    in_mesa_local character varying,
	    in_mesa_numero character varying
	)
	
		RETURNS bigint
	    LANGUAGE plpgsql
	    AS $$
	    
		DECLARE
		BEGIN

	--	Editar mesa
		UPDATE
			mesa
			
		SET
			usuario_id	= in_usuario_id,
			mesa_estado = in_mesa_estado,
			mesa_comuna = in_mesa_comuna,
			mesa_local = in_mesa_local,
			mesa_numero = in_mesa_numero,
			mesa_cambio = now()
			
		WHERE
			mesa_id = in_mesa_id
		;
		
		RETURN 1;

	END $$;

--			-			-			-			-			-			-			-			-
--			-			-			-			-			-			-			-			-

--  ELIMINAR PROCESO
	DROP FUNCTION mesa_detalles
	(
		bigint
	);

--  OBTENER DETALLES DE LA MESA
    CREATE FUNCTION mesa_detalles
	(
		in_mesa_id bigint
	)
		RETURNS TABLE
		(
            mesa_id bigint,
		    usuario_id bigint,
		    mesa_tipo character varying,
            mesa_zona bigint,
            mesa_zona_titulo character varying,
			mesa_comuna character varying,
            mesa_local character varying,
            mesa_numero character varying,
            mesa_orden smallint,
            mesa_estado smallint,
            mesa_destacada smallint,
            mesa_votos_blancos smallint,
            mesa_votos_nulos smallint,
            mesa_cambio timestamp without time zone,
            mesa_creado timestamp without time zone,
			usuario_nombre character varying
		)
		
	    LANGUAGE plpgsql
	    AS $$
	    
		BEGIN
		return QUERY
		
	    SELECT
            mesa.mesa_id,
            mesa.usuario_id,
            mesa.mesa_tipo,
            mesa.mesa_zona,
            mesa.mesa_zona_titulo,
			mesa.mesa_comuna,
            mesa.mesa_local,
            mesa.mesa_numero,
            mesa.mesa_orden,
            mesa.mesa_estado,
            mesa.mesa_destacada,
            mesa.mesa_votos_blancos,
            mesa.mesa_votos_nulos,
            mesa.mesa_cambio,
            mesa.mesa_creado,
			usuario.usuario_nombre
	
	    FROM
			usuario,
	        mesa
	
	    WHERE
			usuario.usuario_id = mesa.usuario_id AND
	        mesa.mesa_id = in_mesa_id
	
	    LIMIT 1
	    ;
	
	END $$;

--			-			-			-			-			-			-			-			-

	select * from mesa_candidatos( 26 );

--  ELIMINAR PROCESO
	DROP FUNCTION mesa_candidatos
	(
		bigint
	);

--  OBTENER DETALLES DE LA MESA
    CREATE FUNCTION mesa_candidatos
	(
		in_mesa_id bigint
	)
		RETURNS TABLE
		(
            voto_id bigint,
            voto_total smallint,
            candidato_id bigint,
            candidato_nombre character varying,
			candidato_nombres character varying,
			candidato_apellidos character varying,
			candidato_lista character varying
		)
		
	    LANGUAGE plpgsql
	    AS $$
	    
		BEGIN
		return QUERY
		
	    SELECT
            voto.voto_id,
            voto.voto_total,
            voto.candidato_id,
            candidato.candidato_nombre,
			candidato.candidato_nombres,
			candidato.candidato_apellidos,
			candidato.candidato_lista
	
	    FROM
            candidato,
            voto
	
	    WHERE
	        candidato.candidato_id  =   voto.candidato_id AND
	        voto.mesa_id = in_mesa_id

		ORDER BY candidato.candidato_orden ASC
	    ;
	
	END $$;

--			-			-			-			-			-			-			-			-

	SELECT * FROM mesa_candidatos_swich(16);

--  ELIMINAR PROCESO
	DROP FUNCTION mesa_candidatos_swich
	(
		bigint
	);

--  OBTENER DETALLES DE LA MESA
    CREATE FUNCTION mesa_candidatos_swich
	(
		in_mesa_id bigint
	)
		RETURNS TABLE
		(
            voto_id bigint,
            voto_total smallint,
            candidato_id bigint,
			candidato_nombres character varying,
			candidato_apellidos character varying,
			candidato_genero character varying,
			candidato_independiente boolean,
			candidato_lista character varying,
			partido_codigo character varying,
			pacto_codigo character varying
		)
		
	    LANGUAGE plpgsql
	    AS $$
	    
		BEGIN
		return QUERY
		
	    SELECT
            voto.voto_id,
            voto.voto_total,
            voto.candidato_id,
			candidato.candidato_nombres,
			candidato.candidato_apellidos,
			candidato.candidato_genero,
			candidato.candidato_independiente,
			candidato.candidato_lista,
			partido.partido_codigo,
			pacto.pacto_nombre
	
	    FROM
			pacto,
			partido,
            candidato,
            voto
	
	    WHERE
			pacto.pacto_id = candidato.pacto_id AND
			partido.partido_id = candidato.partido_id AND
	        candidato.candidato_id = voto.candidato_id AND
	        voto.mesa_id = in_mesa_id

		ORDER BY candidato.candidato_orden ASC;
	
	END $$;

--			-			-			-			-			-			-			-			-

--  ELIMINAR PROCESO
	DROP FUNCTION mesa_voto
	(
		bigint,
        bigint,
		bigint
	);

--	VOTOS DE LA MESA
	CREATE OR REPLACE FUNCTION mesa_voto
	(
        in_mesa_id bigint,
	    in_voto_id bigint,
		in_voto_total bigint
	)
	
		RETURNS bigint
	    LANGUAGE plpgsql
	    AS $$
	    
		DECLARE
		BEGIN

	--  Actualizar Votos
		UPDATE
			voto
			
		SET
			voto_total = in_voto_total
			
		WHERE
		    voto.voto_id = in_voto_id
		;

	--  Actualizar Mesa
		UPDATE
			mesa
			
		SET
			mesa_cambio = now()
			
		WHERE
			mesa.mesa_id = in_mesa_id
		;
		
		RETURN 1;
		
	END $$;

--			-			-			-			-			-			-			-			-
--			-			-			-			-			-			-			-			-

--  ELIMINAR PROCESO
	DROP FUNCTION mesa_listado
	(
		integer,
        integer
	);

--	OBTENER LISTADO DE MESAS
	CREATE OR REPLACE FUNCTION mesa_listado
	(
		in_limit integer,
		in_offset integer
	)
	
		RETURNS TABLE
		(
		    mesa_id bigint,
		    usuario_id bigint,
			mesa_tipo character varying,
			mesa_orden smallint,
		    mesa_destacada smallint,
		    mesa_estado smallint,
			mesa_zona bigint,
			mesa_zona_titulo character varying,
			mesa_comuna character varying,
		    mesa_local character varying,
		    mesa_numero character varying,
		    mesa_votos_blancos smallint,
		    mesa_votos_nulos smallint,
			mesa_cambio timestamp without time zone,
			mesa_creado timestamp without time zone,
			usuario_nombre character varying
		)
		
	    LANGUAGE plpgsql
	    AS $$
	    
		BEGIN
		return QUERY
		
	    SELECT
		    mesa.mesa_id,
		    mesa.usuario_id,
			mesa.mesa_tipo,
			mesa.mesa_orden,
		    mesa.mesa_destacada,
		    mesa.mesa_estado,
			mesa.mesa_zona,
			mesa.mesa_zona_titulo,
			mesa.mesa_comuna,
		    mesa.mesa_local,
		    mesa.mesa_numero,
		    mesa.mesa_votos_blancos,
		    mesa.mesa_votos_nulos,
			mesa.mesa_cambio,
			mesa.mesa_creado,
			usuario.usuario_nombre
	
	    FROM
	        mesa,
	        usuario
	        
		WHERE
			mesa.usuario_id = usuario.usuario_id
	
	    ORDER BY
			mesa.mesa_estado DESC,
	        mesa.mesa_cambio DESC
	
	    LIMIT in_limit OFFSET in_offset
	    ;
	
	END $$;

--			-			-			-			-			-			-			-			-
--			-			-			-			-			-			-			-			-

--  ELIMINAR PROCESO
	DROP FUNCTION mesa_eliminar
	(
		bigint
	);

--	ELIMINAR MESA
	CREATE OR REPLACE FUNCTION mesa_eliminar
	(
		in_mesa_id bigint
	)
		RETURNS bigint
	    LANGUAGE plpgsql
	    AS $$
	    
		DECLARE
		BEGIN

	--	Eliminar votos
        DELETE FROM voto WHERE voto.mesa_id = in_mesa_id;

	--	Eliminar mesa
        DELETE FROM mesa WHERE mesa.mesa_id = in_mesa_id;

		RETURN 1;
	
	END $$;

--			-			-			-			-			-			-			-			-

--  ELIMINAR PROCESO
	DROP FUNCTION mesa_candidato_guardar
	(
		bigint,
	    character varying
	);

--	MESA CANDIDATO GUARDAR
	CREATE OR REPLACE FUNCTION mesa_candidato_guardar
	(
        in_candidato_id bigint,
	    in_candidato_nombres character varying,
		in_candidato_apellidos character varying
	)
		RETURNS bigint
	    LANGUAGE plpgsql
	    AS $$
	    
		DECLARE
		BEGIN

	--  Actualizar Candidato
		UPDATE
			candidato
			
		SET
			candidato_nombres = in_candidato_nombres,
			candidato_apellidos = in_candidato_apellidos
		
		WHERE
			candidato_id = in_candidato_id
		;
		
		RETURN 1;
		
	END $$;


--			-			-			-			-			-			-			-			-
--			-			-			-			-			-			-			-			-

--  ELIMINAR PROCESO
	DROP FUNCTION mesa_locales
	(

	);

--	OBTENER LISTADO DE MESAS
	CREATE OR REPLACE FUNCTION mesa_locales
	(

	)
	
		RETURNS TABLE
		(
		    mesa_id bigint,
		    mesa_local character varying,
		    mesa_numero character varying
		)
		
	    LANGUAGE plpgsql
	    AS $$
	    
		BEGIN
		return QUERY
		
	    SELECT
		    DISTINCT mesa_local
	
	    FROM
	        mesa;
	
	END $$;