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

	CREATE OR REPLACE FUNCTION mesa_usuario_listado
	(
        in_usuario_id bigint,
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
			mesa.usuario_id = usuario.usuario_id AND
            mesa.usuario_id = in_usuario_id
	
	    ORDER BY
	        mesa.mesa_destacada DESC,
			mesa.mesa_estado DESC,
	        mesa.mesa_cambio DESC
	
	    LIMIT in_limit OFFSET in_offset
	    ;
	
	END $$;