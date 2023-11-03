--			-			-			-			-			-			-			-			-
--	Destacar Mesa
	CREATE FUNCTION mesa_destacada
	(
		in_mesa_id bigint
	)
	
		RETURNS bigint
	    LANGUAGE plpgsql
	    AS $$
	    
		DECLARE
			v_id bigint;
			v_estado bigint;
		BEGIN

	--	Obtener Estado Actual
		SELECT mesa_destacada FROM mesa WHERE mesa_id = in_mesa_id INTO v_estado;
	
		IF v_estado = 1 THEN
		
			UPDATE
				mesa
				
			SET
				mesa_destacada = 0,
				mesa_cambio = now()
			
			WHERE mesa_id = in_mesa_id;
			
			return 0;
			
		ELSE
			
			UPDATE
				mesa
				
			SET
				mesa_destacada = 1,
				mesa_cambio = now()
			
			WHERE mesa_id = in_mesa_id;
			
			return 1;
			
		END IF;
		
	END $$;

--			-			-			-			-			-			-			-			-

--	MESA ACTIVAR
	CREATE FUNCTION mesa_activar
	(
		in_mesa_id bigint,
		in_mesa_numero character varying
	)
	
		RETURNS bigint
	    LANGUAGE plpgsql
	    AS $$
	    
		DECLARE
		BEGIN

		UPDATE
			mesa
			
		SET
			mesa_estado = 1,
			mesa_numero = in_mesa_numero,
			mesa_cambio = now()
		
		WHERE mesa_id = in_mesa_id;
		
		return 1;

	END $$;

--			-			-			-			-			-			-			-			-

	CREATE FUNCTION mesa_duplicar
	(
		in_mesa_id bigint
	)
	
		RETURNS bigint
	    LANGUAGE plpgsql
	    AS $$
	    
		DECLARE
		BEGIN

		INSERT INTO web_book (page_count, year_published, file, image, display_on_hp, name, description, name_cs, name_en, description_cs, description_en)
		SELECT page_count, year_published, file, image, display_on_hp, name, description, name_cs, name_en, description_cs, description_en FROM web_book WHERE id = 3;
		
	END $$;

--			-			-			-			-			-			-			-			-

--	OBTENER TOTAL DE MESAS DISPONIBLES
	CREATE FUNCTION mesa_contar_total
	(
		
	)
		RETURNS TABLE
		(
			objetos bigint
		)
		
	    LANGUAGE plpgsql
	    AS $$
	    
		BEGIN
		return QUERY
		
		SELECT
			count(mesa_id) AS objetos 
			
		FROM
			mesa
	    ;
	
	END $$;

--			-			-			-			-			-			-			-			-

	DROP FUNCTION mesa_listado();

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
			mesa_orden bigint,
		    mesa_destacada smallint,
		    mesa_estado smallint,
		    mesa_nombre character varying,
		    mesa_numero character varying,
		    mesa_region character varying,
		    mesa_ciudad character varying,
		    mesa_voto_a smallint,
		    mesa_voto_r smallint,
		    mesa_voto_ar_blanco smallint,
		    mesa_voto_ar_nulo smallint,
		    mesa_voto_cm smallint,
		    mesa_voto_cc smallint,
		    mesa_voto_cmcc_blanco smallint,
		    mesa_voto_cmcc_nulo smallint,
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
			mesa.mesa_orden,
		    mesa.mesa_destacada,
		    mesa.mesa_estado,
		    mesa.mesa_nombre,
		    mesa.mesa_numero,
		    mesa.mesa_region,
		    mesa.mesa_ciudad,
		    mesa.mesa_voto_a,
		    mesa.mesa_voto_r,
		    mesa.mesa_voto_ar_blanco,
		    mesa.mesa_voto_ar_nulo,
		    mesa.mesa_voto_cm,
		    mesa.mesa_voto_cc,
		    mesa.mesa_voto_cmcc_blanco,
		    mesa.mesa_voto_cmcc_nulo,
			mesa.mesa_cambio,
			mesa.mesa_creado,
			usuario.usuario_nombre
	
	    FROM
	        mesa,
	        usuario
	        
		WHERE
			mesa.usuario_id = usuario.usuario_id
	
	    ORDER BY
	        mesa.mesa_destacada DESC,
			mesa.mesa_estado DESC,
	        mesa.mesa_cambio DESC
	
	    LIMIT in_limit OFFSET in_offset
	    ;
	
	END $$;

--	OBTENER TOTAL DE MESAS DISPONIBLES POR USUARIO
	CREATE FUNCTION mesa_usuario_contar_total
	(
		in_usuario_id bigint
	)
		RETURNS TABLE
		(
			objetos bigint
		)
		
	    LANGUAGE plpgsql
	    AS $$
	    
		BEGIN
		return QUERY
		
		SELECT
			count(mesa_id) AS objetos
			
		FROM
			mesa
			
		WHERE
			usuario_id = in_usuario_id
	    ;
	
	END $$;

--			-			-			-			-			-			-			-			-

--	OBTENER LISTADO DE MESAS POR USUARIO
	CREATE OR REPLACE FUNCTION mesa_usuario_listado
	(
		in_usuario_id bigint,
		in_limit integer,
		in_offset integer
	)
	
		RETURNS TABLE
		(
		    mesa_id bigint,
			mesa_orden bigint,
		    mesa_destacada smallint,
		    mesa_estado smallint,
		    mesa_nombre character varying,
		    mesa_numero character varying,
		    mesa_region character varying,
		    mesa_ciudad character varying,
		    mesa_voto_a smallint,
		    mesa_voto_r smallint,
		    mesa_voto_ar_blanco smallint,
		    mesa_voto_ar_nulo smallint,
		    mesa_voto_cm smallint,
		    mesa_voto_cc smallint,
		    mesa_voto_cmcc_blanco smallint,
		    mesa_voto_cmcc_nulo smallint,
			mesa_cambio timestamp without time zone,
			mesa_creado timestamp without time zone			
		)
		
	    LANGUAGE plpgsql
	    AS $$
	    
		BEGIN
		return QUERY
		
	    SELECT
		    mesa.mesa_id,
			mesa.mesa_orden,
		    mesa.mesa_destacada,
		    mesa.mesa_estado,
		    mesa.mesa_nombre,
		    mesa.mesa_numero,
		    mesa.mesa_region,
		    mesa.mesa_ciudad,
		    mesa.mesa_voto_a,
		    mesa.mesa_voto_r,
		    mesa.mesa_voto_ar_blanco,
		    mesa.mesa_voto_ar_nulo,
		    mesa.mesa_voto_cm,
		    mesa.mesa_voto_cc,
		    mesa.mesa_voto_cmcc_blanco,
		    mesa.mesa_voto_cmcc_nulo,
			mesa.mesa_cambio,
			mesa.mesa_creado
	
	    FROM
	        mesa
	        
		WHERE
			usuario_id = in_usuario_id
	
	    ORDER BY
	        mesa.mesa_estado DESC,
	        mesa.mesa_cambio DESC
	
	    LIMIT in_limit OFFSET in_offset
	    ;
	
	END $$;

--			-			-			-			-			-			-			-			-

--	OBTENER INFORMACIÓN DE LA MESA
	CREATE FUNCTION mesa_obtener_datos
	(
		in_mesa_id bigint
	)

		RETURNS TABLE
		(
		    mesa_id bigint,
		    usuario_id bigint,
		    mesa_destacada smallint,
		    mesa_estado smallint,
		    mesa_nombre character varying,
		    mesa_numero character varying,
		    mesa_region character varying,
		    mesa_ciudad character varying,
		    mesa_voto_a smallint,
		    mesa_voto_r smallint,
		    mesa_voto_ar_blanco smallint,
		    mesa_voto_ar_nulo smallint,
		    mesa_voto_cm smallint,
		    mesa_voto_cc smallint,
		    mesa_voto_cmcc_blanco smallint,
		    mesa_voto_cmcc_nulo smallint
		)
		
	    LANGUAGE plpgsql
	    AS $$
	    
		BEGIN
		return QUERY
		
	    SELECT
		    mesa.mesa_id,
		    mesa.usuario_id,
		    mesa.mesa_destacada,
		    mesa.mesa_estado,
		    mesa.mesa_nombre,
		    mesa.mesa_numero,
		    mesa.mesa_region,
		    mesa.mesa_ciudad,
		    mesa.mesa_voto_a,
		    mesa.mesa_voto_r,
		    mesa.mesa_voto_ar_blanco,
		    mesa.mesa_voto_ar_nulo,
		    mesa.mesa_voto_cm,
		    mesa.mesa_voto_cc,
		    mesa.mesa_voto_cmcc_blanco,
		    mesa.mesa_voto_cmcc_nulo
	
	    FROM
	        mesa
	
	    WHERE
	        mesa.mesa_id = in_mesa_id
	
	    LIMIT 1
	    ;
	
	END $$;

--			-			-			-			-			-			-			-			-

--	CREAR NUEVA MESA
	CREATE FUNCTION mesa_nuevo
	(
		in_usuario_id bigint
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
        	usuario_id
        )
		VALUES
		(
			in_mesa_id,
			in_usuario_id
		);
		
        RETURN in_mesa_id;
	        
	END $$;

--			-			-			-			-			-			-			-			-

--	APLICAR CAMBIOS A LA MESA
	CREATE OR REPLACE FUNCTION mesa_editar
	(
	    in_mesa_id bigint,
		in_usuario_id bigint,
		in_mesa_estado bigint,
	    in_mesa_nombre character varying,
	    in_mesa_numero character varying,
	    in_mesa_region character varying,
	    in_mesa_ciudad character varying,
		in_mesa_voto_a bigint,
		in_mesa_voto_r bigint,
		in_mesa_voto_ar_blanco bigint,
		in_mesa_voto_ar_nulo bigint,
		in_mesa_voto_cm bigint,
		in_mesa_voto_cc bigint,
		in_mesa_voto_cmcc_blanco bigint,
		in_mesa_voto_cmcc_nulo bigint
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
			mesa_nombre = in_mesa_nombre,
			mesa_numero = in_mesa_numero,
			mesa_region = in_mesa_region,
			mesa_ciudad = in_mesa_ciudad,
			mesa_voto_a = in_mesa_voto_a,
			mesa_voto_r = in_mesa_voto_r,
			mesa_voto_ar_blanco = in_mesa_voto_ar_blanco,
			mesa_voto_ar_nulo = in_mesa_voto_ar_nulo,
			mesa_voto_cm = in_mesa_voto_cm,
			mesa_voto_cc = in_mesa_voto_cc,
			mesa_voto_cmcc_blanco = in_mesa_voto_cmcc_blanco,
			mesa_voto_cmcc_nulo = in_mesa_voto_cmcc_nulo,
			mesa_cambio = now()
			
		WHERE
			mesa_id = in_mesa_id
		;
		
		RETURN 1;

	END $$;
	
--			-			-			-			-			-			-			-			-

--	VOTOS DE LA MESA
	CREATE OR REPLACE FUNCTION mesa_votos
	(
	    in_mesa_id bigint,
		in_mesa_voto_a bigint,
		in_mesa_voto_r bigint,
		in_mesa_voto_cm bigint,
		in_mesa_voto_cc bigint
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
			mesa_voto_a = in_mesa_voto_a,
			mesa_voto_r = in_mesa_voto_r,
			mesa_voto_cm = in_mesa_voto_cm,
			mesa_voto_cc = in_mesa_voto_cc,
			mesa_cambio = now()
			
		WHERE
			mesa_id = in_mesa_id
		;
		
		RETURN 1;
		
	END $$;

--			-			-			-			-			-			-			-			-

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

	--	Eliminar mesa
        DELETE FROM
        	mesa
    
        WHERE
	        mesa.mesa_id = in_mesa_id
        ;

		RETURN 1;
	
	END $$;
