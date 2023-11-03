--	USUARIOS
--			-			-			-			-			-			-			-			-

--	OBTENER TOTAL DE USUARIOS DISPONIBLES
	CREATE FUNCTION usuario_contar_total
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
			count(usuario_id) AS objetos 
			
		FROM
			usuario
	    ;
	
	END $$;

--			-			-			-			-			-			-			-			-

--	OBTENER LISTADO DE USUARIOS
	CREATE OR REPLACE FUNCTION usuario_listado
	(
		in_limit integer,
		in_offset integer
	)
	
		RETURNS TABLE
		(
			usuario_id bigint,
			usuario_rol character varying,
			usuario_estado smallint,
			usuario_nombre character varying,
			usuario_login timestamp without time zone,
			usuario_creado timestamp without time zone,
			usuario_poster text
		)
		
	    LANGUAGE plpgsql
	    AS $$
	    
		BEGIN
		return QUERY
		
	    SELECT
	        usuario.usuario_id,
	        usuario.usuario_rol,
	        usuario.usuario_estado,
	        usuario.usuario_nombre,
	        usuario.usuario_login,
	        usuario.usuario_creado,
			(
				SELECT
					CONCAT( usuario.usuario_id , '|' , imagen.imagen_id , '|' , imagen.imagen_extension ) AS usuario_poster
				
				FROM
					imagen
					
				WHERE
					imagen_objeto = usuario.usuario_id AND
					imagen_tipo = 'USU'
					
				ORDER BY imagen.imagen_orden ASC
				
				LIMIT 1
			)
	
	    FROM
	        usuario
	
	    ORDER BY
	        usuario.usuario_id DESC,
	        usuario.usuario_nombre ASC
	
	    LIMIT in_limit OFFSET in_offset
	    ;
	
	END $$;

--			-			-			-			-			-			-			-			-

--	OBTENER LISTADO DE USUARIOS
	CREATE FUNCTION usuario_listado_movil
	(

	)
	
		RETURNS TABLE
		(
			usuario_id bigint,
			usuario_estado smallint,
			usuario_genero character varying,
			usuario_nombre character varying,
			usuario_password character varying,
			usuario_etiqueta bigint
		)
		
	    LANGUAGE plpgsql
	    AS $$
	    
		BEGIN
		return QUERY
		
	    SELECT
	        usuario.usuario_id,
			usuario.usuario_estado,
			usuario.usuario_genero,
	        usuario.usuario_nombre,
	        usuario.usuario_password,
	        usuario.usuario_etiqueta
	
	    FROM
	        usuario
	
	    ORDER BY
	        usuario.usuario_id DESC,
	        usuario.usuario_nombre ASC
		;
	
	END $$;

--			-			-			-			-			-			-			-			-

--	OBTENER INFORMACIÓN DEL USUARIO
	CREATE FUNCTION usuario_obtener_datos
	(
		in_usuario_id bigint
	)

		RETURNS TABLE
		(
			usuario_id bigint,
			usuario_rol character varying,
			usuario_estado smallint,
			usuario_genero character varying,
			usuario_nombre character varying,
			usuario_email character varying,
			usuario_etiqueta bigint,
			usuario_login timestamp without time zone,
			usuario_creado timestamp without time zone,
			usuario_poster text
		)
		
	    LANGUAGE plpgsql
	    AS $$
	    
		BEGIN
		return QUERY
		
	    SELECT
	        usuario.usuario_id,
	        usuario.usuario_rol,
	        usuario.usuario_estado,
	        usuario.usuario_genero,
	        usuario.usuario_nombre,
	        usuario.usuario_email,
	        usuario.usuario_etiqueta,
	        usuario.usuario_login,
	        usuario.usuario_creado,
			(
				SELECT
					CONCAT( usuario.usuario_id , '|' , imagen.imagen_id , '|' , imagen.imagen_extension ) AS usuario_poster
				
				FROM
					imagen
					
				WHERE
					imagen_objeto = usuario.usuario_id AND
					imagen_tipo = 'USU'
					
				ORDER BY imagen.imagen_orden ASC
				
				LIMIT 1
			)
	
	    FROM
	        usuario
	
	    WHERE
	        usuario.usuario_id = in_usuario_id
	
	    LIMIT 1
	    ;
	
	END $$;

--			-			-			-			-			-			-			-			-

--	CREAR NUEVO USUARIO
	CREATE FUNCTION usuario_nuevo
	(
		
	)
		RETURNS bigint
	    LANGUAGE plpgsql
	    AS $$
	    
		DECLARE
			v_id bigint;
		BEGIN

        SELECT nextval('usuario_id_seq') INTO v_id;
        
        INSERT INTO usuario
        (
        	usuario_id
        )
		VALUES
		(
			v_id
		);
		
        RETURN v_id;
	        
	END $$;

--			-			-			-			-			-			-			-			-

--	APLICAR CAMBIOS AL USUARIO
	CREATE OR REPLACE FUNCTION usuario_editar
	(
		in_usuario_id bigint,
		in_usuario_rol character varying,
		in_usuario_nombre character varying,
		in_usuario_email character varying,
		in_usuario_password character varying,
		in_usuario_genero character varying,
		in_usuario_etiqueta bigint,
		in_imagenes character varying
	)
	
		RETURNS bigint
	    LANGUAGE plpgsql
	    AS $$
	    
		DECLARE
			v_orden int;
			v_imagenes bigint;
			v_imagenes_array varchar[];
		BEGIN
		
	--	Comienzo del Orden
		v_orden = 0;
		
	--	Separar los ID de las Imagenes
        SELECT string_to_array(in_imagenes, ',') INTO v_imagenes_array;

	--	Actualizar Posicion de las imagenes
        FOREACH v_imagenes IN ARRAY v_imagenes_array LOOP

	        UPDATE
	        	imagen
	        SET
	        	imagen_orden = v_orden
	        WHERE
	        	imagen_id = v_imagenes AND
	        	imagen_objeto = in_usuario_id
	        ;
	        
			v_orden = v_orden + 1;

        END LOOP;

	--	Editar Usuario
		UPDATE
			usuario
			
		SET
			usuario_rol = in_usuario_rol,
			usuario_nombre = in_usuario_nombre,
			usuario_email = in_usuario_email,
			usuario_genero = in_usuario_genero,
			usuario_etiqueta = in_usuario_etiqueta
			
		WHERE
			usuario_id = in_usuario_id
		;
		
	--	Validar Cambio de Password
		CASE 

		--	Sin Cambio de Password
			WHEN in_usuario_password = 'NULL' THEN
	
		--	Cambio de Password
			ELSE
			
				UPDATE
					usuario
					
				SET
					usuario_password = in_usuario_password
					
				WHERE
					usuario_id = in_usuario_id
				;

		END CASE;
		
		RETURN 1;
		
	END $$;

--			-			-			-			-			-			-			-			-

--	ELIMINAR USUARIO
	CREATE OR REPLACE FUNCTION usuario_eliminar
	(
		in_usuario_id bigint,
		in_imagen_tipo character varying
	)
		RETURNS TABLE
		(
			imagen_id bigint,
			imagen_objeto bigint,
			imagen_tipo character varying,
			imagen_extension character varying
		)
	    LANGUAGE plpgsql
	    AS $$
	    
		BEGIN
		return QUERY
		
	    SELECT
        	imagen.imagen_id,
        	imagen.imagen_objeto,
        	imagen.imagen_tipo,
        	imagen.imagen_extension
	
	    FROM
	        imagen
	
	    WHERE
	        imagen.imagen_objeto = in_usuario_id AND
	        imagen.imagen_tipo = in_imagen_tipo
	    ;
		
	--	Eliminar Imagenes
        DELETE FROM
        	imagen
    
        WHERE
	        imagen.imagen_objeto = in_usuario_id AND
	        imagen.imagen_tipo = in_imagen_tipo
        ;
        
	--	Eliminar Usuario
        DELETE FROM
        	usuario
    
        WHERE
	        usuario.usuario_id = in_usuario_id
        ;
	
	END $$;

--			-			-			-			-			-			-			-			-

--	USUARIO INICIAR SESION
	CREATE OR REPLACE FUNCTION usuario_iniciar_sesion
	(
		in_usuario_email character varying,
		in_usuario_password character varying
	)

		RETURNS bigint
	    LANGUAGE plpgsql
	    AS $$
	    
		DECLARE
			v_usuario bigint;
		BEGIN
		
	--	VALIDAR CREDENCIALES
		SELECT usuario_id FROM usuario WHERE usuario_email = in_usuario_email AND usuario_password = in_usuario_password INTO v_usuario;
		
	--	RESPUESTA DE LA QUERY
		IF v_usuario <1 THEN
	        RETURN 0;
	    ELSE
			RETURN v_usuario;
        END IF;

	END $$;
