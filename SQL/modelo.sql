--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Name: imagen_eliminar(bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION imagen_eliminar(in_imagen_id bigint, in_imagen_objeto bigint) RETURNS TABLE(imagen_id bigint, imagen_objeto bigint, imagen_tipo character varying, imagen_extension character varying)
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
	        imagen.imagen_id = in_imagen_id AND
	        imagen.imagen_objeto = in_imagen_objeto

	    LIMIT 1
	    ;
		
	--	Eliminar Imagen
        DELETE FROM
        	imagen
    
        WHERE
        	imagen.imagen_id = in_imagen_id AND
        	imagen.imagen_objeto = in_imagen_objeto
        ;
	
	END $$;


ALTER FUNCTION public.imagen_eliminar(in_imagen_id bigint, in_imagen_objeto bigint) OWNER TO postgres;

--
-- Name: imagen_listado(bigint, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION imagen_listado(in_imagen_objeto bigint, in_imagen_tipo character varying) RETURNS TABLE(imagen_id bigint, imagen_orden bigint, imagen_objeto bigint, imagen_tipo character varying, imagen_extension character varying, imagen_cambio bigint)
    LANGUAGE plpgsql
    AS $$
	    
		BEGIN
		return QUERY
		
	    SELECT
        	imagen.imagen_id,
        	imagen.imagen_orden,
        	imagen.imagen_objeto,
        	imagen.imagen_tipo,
        	imagen.imagen_extension,
        	imagen.imagen_cambio
	
	    FROM
	        imagen
	
	    WHERE
	        imagen.imagen_objeto = in_imagen_objeto AND
	        imagen.imagen_tipo = in_imagen_tipo
	        
		ORDER BY
			imagen_orden ASC
	
	    LIMIT 50
	    ;
	
	END $$;


ALTER FUNCTION public.imagen_listado(in_imagen_objeto bigint, in_imagen_tipo character varying) OWNER TO postgres;

--
-- Name: imagen_nueva(bigint, bigint, character varying, character varying, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION imagen_nueva(in_imagen_id bigint, in_imagen_objeto bigint, in_imagen_tipo character varying, in_imagen_extension character varying, in_imagen_cambio bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
		DECLARE
			v_imagen_id bigint;
			v_orden bigint;
		BEGIN
		
		-- verificar si email ya esta registrado
		select count(*) from imagen where imagen_objeto = in_imagen_objeto INTO v_orden;
		
        INSERT INTO imagen
        (
        	imagen_id,
        	imagen_orden,
        	imagen_objeto,
        	imagen_tipo,
        	imagen_extension,
        	imagen_cambio
        )
		VALUES
		(
        	in_imagen_id,
        	v_orden,
        	in_imagen_objeto,
        	in_imagen_tipo,
        	in_imagen_extension,
        	in_imagen_cambio
		);
		
        RETURN v_imagen_id;
	
	END $$;


ALTER FUNCTION public.imagen_nueva(in_imagen_id bigint, in_imagen_objeto bigint, in_imagen_tipo character varying, in_imagen_extension character varying, in_imagen_cambio bigint) OWNER TO postgres;

--
-- Name: mesa_activar(bigint, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mesa_activar(in_mesa_id bigint, in_mesa_numero character varying) RETURNS bigint
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


ALTER FUNCTION public.mesa_activar(in_mesa_id bigint, in_mesa_numero character varying) OWNER TO postgres;

--
-- Name: mesa_contar_total(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mesa_contar_total() RETURNS TABLE(objetos bigint)
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


ALTER FUNCTION public.mesa_contar_total() OWNER TO postgres;

--
-- Name: mesa_destacada(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mesa_destacada(in_mesa_id bigint) RETURNS bigint
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


ALTER FUNCTION public.mesa_destacada(in_mesa_id bigint) OWNER TO postgres;

--
-- Name: mesa_editar(bigint, bigint, bigint, character varying, character varying, character varying, character varying, bigint, bigint, bigint, bigint, bigint, bigint, bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mesa_editar(in_mesa_id bigint, in_usuario_id bigint, in_mesa_estado bigint, in_mesa_nombre character varying, in_mesa_numero character varying, in_mesa_region character varying, in_mesa_ciudad character varying, in_mesa_voto_a bigint, in_mesa_voto_r bigint, in_mesa_voto_ar_blanco bigint, in_mesa_voto_ar_nulo bigint, in_mesa_voto_cm bigint, in_mesa_voto_cc bigint, in_mesa_voto_cmcc_blanco bigint, in_mesa_voto_cmcc_nulo bigint) RETURNS bigint
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


ALTER FUNCTION public.mesa_editar(in_mesa_id bigint, in_usuario_id bigint, in_mesa_estado bigint, in_mesa_nombre character varying, in_mesa_numero character varying, in_mesa_region character varying, in_mesa_ciudad character varying, in_mesa_voto_a bigint, in_mesa_voto_r bigint, in_mesa_voto_ar_blanco bigint, in_mesa_voto_ar_nulo bigint, in_mesa_voto_cm bigint, in_mesa_voto_cc bigint, in_mesa_voto_cmcc_blanco bigint, in_mesa_voto_cmcc_nulo bigint) OWNER TO postgres;

--
-- Name: mesa_eliminar(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mesa_eliminar(in_mesa_id bigint) RETURNS bigint
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


ALTER FUNCTION public.mesa_eliminar(in_mesa_id bigint) OWNER TO postgres;

--
-- Name: mesa_listado(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mesa_listado(in_limit integer, in_offset integer) RETURNS TABLE(mesa_id bigint, usuario_id bigint, mesa_orden bigint, mesa_destacada smallint, mesa_estado smallint, mesa_nombre character varying, mesa_numero character varying, mesa_region character varying, mesa_ciudad character varying, mesa_voto_a smallint, mesa_voto_r smallint, mesa_voto_ar_blanco smallint, mesa_voto_ar_nulo smallint, mesa_voto_cm smallint, mesa_voto_cc smallint, mesa_voto_cmcc_blanco smallint, mesa_voto_cmcc_nulo smallint, mesa_cambio timestamp without time zone, mesa_creado timestamp without time zone, usuario_nombre character varying)
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


ALTER FUNCTION public.mesa_listado(in_limit integer, in_offset integer) OWNER TO postgres;

--
-- Name: mesa_nuevo(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mesa_nuevo(in_usuario_id bigint) RETURNS bigint
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


ALTER FUNCTION public.mesa_nuevo(in_usuario_id bigint) OWNER TO postgres;

--
-- Name: mesa_obtener_datos(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mesa_obtener_datos(in_mesa_id bigint) RETURNS TABLE(mesa_id bigint, usuario_id bigint, mesa_destacada smallint, mesa_estado smallint, mesa_nombre character varying, mesa_numero character varying, mesa_region character varying, mesa_ciudad character varying, mesa_voto_a smallint, mesa_voto_r smallint, mesa_voto_ar_blanco smallint, mesa_voto_ar_nulo smallint, mesa_voto_cm smallint, mesa_voto_cc smallint, mesa_voto_cmcc_blanco smallint, mesa_voto_cmcc_nulo smallint)
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


ALTER FUNCTION public.mesa_obtener_datos(in_mesa_id bigint) OWNER TO postgres;

--
-- Name: mesa_usuario_contar_total(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mesa_usuario_contar_total(in_usuario_id bigint) RETURNS TABLE(objetos bigint)
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


ALTER FUNCTION public.mesa_usuario_contar_total(in_usuario_id bigint) OWNER TO postgres;

--
-- Name: mesa_usuario_listado(bigint, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mesa_usuario_listado(in_usuario_id bigint, in_limit integer, in_offset integer) RETURNS TABLE(mesa_id bigint, mesa_orden bigint, mesa_destacada smallint, mesa_estado smallint, mesa_nombre character varying, mesa_numero character varying, mesa_region character varying, mesa_ciudad character varying, mesa_voto_a smallint, mesa_voto_r smallint, mesa_voto_ar_blanco smallint, mesa_voto_ar_nulo smallint, mesa_voto_cm smallint, mesa_voto_cc smallint, mesa_voto_cmcc_blanco smallint, mesa_voto_cmcc_nulo smallint, mesa_cambio timestamp without time zone, mesa_creado timestamp without time zone)
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


ALTER FUNCTION public.mesa_usuario_listado(in_usuario_id bigint, in_limit integer, in_offset integer) OWNER TO postgres;

--
-- Name: mesa_votos(bigint, smallint, smallint, smallint, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mesa_votos(in_mesa_id bigint, in_mesa_voto_a smallint, in_mesa_voto_r smallint, in_mesa_voto_cm smallint, in_mesa_voto_cc smallint) RETURNS bigint
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
			mesa_voto_cc = in_mesa_voto_cc
			
		WHERE
			mesa_id = in_mesa_id
		;
		
		RETURN 1;
		
	END $$;


ALTER FUNCTION public.mesa_votos(in_mesa_id bigint, in_mesa_voto_a smallint, in_mesa_voto_r smallint, in_mesa_voto_cm smallint, in_mesa_voto_cc smallint) OWNER TO postgres;

--
-- Name: mesa_votos(bigint, bigint, bigint, bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mesa_votos(in_mesa_id bigint, in_mesa_voto_a bigint, in_mesa_voto_r bigint, in_mesa_voto_cm bigint, in_mesa_voto_cc bigint) RETURNS bigint
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


ALTER FUNCTION public.mesa_votos(in_mesa_id bigint, in_mesa_voto_a bigint, in_mesa_voto_r bigint, in_mesa_voto_cm bigint, in_mesa_voto_cc bigint) OWNER TO postgres;

--
-- Name: objeto_estado(bigint, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION objeto_estado(in_objeto_id bigint, in_objeto_tipo character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
	    
		DECLARE
			v_id bigint;
			v_estado bigint;
		BEGIN
		
	--	Validar Tipo de Objeto 
		CASE 

		--	Usuarios
			WHEN in_objeto_tipo = 'USU' THEN
			
			--	Obtener Estado Actual
				SELECT usuario_estado FROM usuario WHERE usuario_id = in_objeto_id INTO v_estado;
			
				IF v_estado = 1 THEN
					UPDATE usuario SET usuario_estado = 0 WHERE usuario_id = in_objeto_id;
					return 0;
			    ELSE
					UPDATE usuario SET usuario_estado = 1 WHERE usuario_id = in_objeto_id;
					return 1;
			    END IF;

		--	Mesas
			WHEN in_objeto_tipo = 'MES' THEN
			
			--	Obtener Estado Actual
				SELECT mesa_estado FROM mesa WHERE mesa_id = in_objeto_id INTO v_estado;
			
				IF v_estado = 1 THEN
				
					UPDATE
						mesa
						
					SET
						mesa_estado = 0,
						mesa_cambio = now()
					
					WHERE mesa_id = in_objeto_id;
					
					return 0;
					
			    ELSE
					
					UPDATE
						mesa
						
					SET
						mesa_estado = 1,
						mesa_cambio = now()
					
					WHERE mesa_id = in_objeto_id;
					
					return 1;
					
			    END IF;
	
			ELSE
			
		END CASE;
		
	END $$;


ALTER FUNCTION public.objeto_estado(in_objeto_id bigint, in_objeto_tipo character varying) OWNER TO postgres;

--
-- Name: swich_actual(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION swich_actual() RETURNS TABLE(swich_mesa_1 smallint, swich_mesa_2 smallint, swich_mesa_3 smallint)
    LANGUAGE plpgsql
    AS $$
	    
		BEGIN
		return QUERY
		
	    SELECT
		    swich.swich_mesa_1,
		    swich.swich_mesa_2,
		    swich.swich_mesa_3
	
	    FROM
	        swich
	        
		WHERE
			swich.swich_id = 1
	
	    LIMIT 1
	    ;
	
	END $$;


ALTER FUNCTION public.swich_actual() OWNER TO postgres;

--
-- Name: swich_editar(bigint, bigint, bigint, bigint, bigint, bigint, bigint, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION swich_editar(in_swich_id bigint, in_swich_modo bigint, in_swich_mesas bigint, in_swich_mesa_1 bigint, in_swich_mesa_2 bigint, in_swich_mesa_3 bigint, in_swich_mesa_4 bigint, in_swich_votos character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
	    
		DECLARE
		BEGIN
		
		UPDATE
			swich
			
		SET
			swich_mesas = in_swich_mesas,
			swich_modo = in_swich_modo,
			swich_mesa_1 = in_swich_mesa_1,
			swich_mesa_2 = in_swich_mesa_2,
			swich_mesa_3 = in_swich_mesa_3,
			swich_mesa_4 = in_swich_mesa_4,
			swich_votos = in_swich_votos,
			swich_cambio = now()
			
		WHERE
			swich_id = in_swich_id
		;
		
		RETURN 1;
	
	END $$;


ALTER FUNCTION public.swich_editar(in_swich_id bigint, in_swich_modo bigint, in_swich_mesas bigint, in_swich_mesa_1 bigint, in_swich_mesa_2 bigint, in_swich_mesa_3 bigint, in_swich_mesa_4 bigint, in_swich_votos character varying) OWNER TO postgres;

--
-- Name: swich_mesas(bigint, bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION swich_mesas(in_mesa_1 bigint, in_mesa_2 bigint, in_mesa_3 bigint) RETURNS TABLE(mesa_id bigint, mesa_nombre character varying, mesa_numero character varying, mesa_region character varying, mesa_ciudad character varying, mesa_voto_a smallint, mesa_voto_r smallint, mesa_voto_cm smallint, mesa_voto_cc smallint)
    LANGUAGE plpgsql
    AS $$
	    
		BEGIN
		return QUERY
		
	    SELECT
		    mesa.mesa_id,
		    mesa.mesa_nombre,
		    mesa.mesa_numero,
		    mesa.mesa_region,
		    mesa.mesa_ciudad,
		    mesa.mesa_voto_a,
		    mesa.mesa_voto_r,
		    mesa.mesa_voto_cm,
		    mesa.mesa_voto_cc
	
	    FROM
	        mesa
	        
		WHERE
			mesa.mesa_id IN ( in_mesa_1 , in_mesa_2 , in_mesa_3 )
	
	    LIMIT 3
	    ;
	
	END $$;


ALTER FUNCTION public.swich_mesas(in_mesa_1 bigint, in_mesa_2 bigint, in_mesa_3 bigint) OWNER TO postgres;

--
-- Name: swich_obtener_datos(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION swich_obtener_datos(in_swich_id bigint) RETURNS TABLE(swich_mesas smallint, swich_modo smallint, swich_mesa_1 smallint, swich_mesa_2 smallint, swich_mesa_3 smallint, swich_mesa_4 smallint, swich_votos character varying, swich_cambio timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
	    
		BEGIN
		return QUERY
		
	    SELECT
	        swich.swich_mesas,
			swich.swich_modo,
	        swich.swich_mesa_1,
	        swich.swich_mesa_2,
	        swich.swich_mesa_3,
	        swich.swich_mesa_4,
			swich.swich_votos,
			swich.swich_cambio
	
	    FROM
	        swich
	
		WHERE
			swich.swich_id = in_swich_id
	    ;
	
	END $$;


ALTER FUNCTION public.swich_obtener_datos(in_swich_id bigint) OWNER TO postgres;

--
-- Name: usuario_contar_total(); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION usuario_contar_total() RETURNS TABLE(objetos bigint)
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


ALTER FUNCTION public.usuario_contar_total() OWNER TO app_vav;

--
-- Name: usuario_editar(bigint, character varying, character varying, character varying, character varying, character varying, bigint, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION usuario_editar(in_usuario_id bigint, in_usuario_rol character varying, in_usuario_nombre character varying, in_usuario_email character varying, in_usuario_password character varying, in_usuario_genero character varying, in_usuario_etiqueta bigint, in_imagenes character varying) RETURNS bigint
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


ALTER FUNCTION public.usuario_editar(in_usuario_id bigint, in_usuario_rol character varying, in_usuario_nombre character varying, in_usuario_email character varying, in_usuario_password character varying, in_usuario_genero character varying, in_usuario_etiqueta bigint, in_imagenes character varying) OWNER TO postgres;

--
-- Name: usuario_eliminar(bigint, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION usuario_eliminar(in_usuario_id bigint, in_imagen_tipo character varying) RETURNS TABLE(imagen_id bigint, imagen_objeto bigint, imagen_tipo character varying, imagen_extension character varying)
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


ALTER FUNCTION public.usuario_eliminar(in_usuario_id bigint, in_imagen_tipo character varying) OWNER TO postgres;

--
-- Name: usuario_iniciar_sesion(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION usuario_iniciar_sesion(in_usuario_email character varying, in_usuario_password character varying) RETURNS bigint
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


ALTER FUNCTION public.usuario_iniciar_sesion(in_usuario_email character varying, in_usuario_password character varying) OWNER TO postgres;

--
-- Name: usuario_listado(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION usuario_listado(in_limit integer, in_offset integer) RETURNS TABLE(usuario_id bigint, usuario_rol character varying, usuario_estado smallint, usuario_nombre character varying, usuario_login timestamp without time zone, usuario_creado timestamp without time zone, usuario_poster text)
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


ALTER FUNCTION public.usuario_listado(in_limit integer, in_offset integer) OWNER TO postgres;

--
-- Name: usuario_listado_movil(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION usuario_listado_movil() RETURNS TABLE(usuario_id bigint, usuario_estado smallint, usuario_genero character varying, usuario_nombre character varying, usuario_password character varying, usuario_etiqueta bigint)
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


ALTER FUNCTION public.usuario_listado_movil() OWNER TO postgres;

--
-- Name: usuario_nuevo(); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION usuario_nuevo() RETURNS bigint
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


ALTER FUNCTION public.usuario_nuevo() OWNER TO app_vav;

--
-- Name: usuario_obtener_datos(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION usuario_obtener_datos(in_usuario_id bigint) RETURNS TABLE(usuario_id bigint, usuario_rol character varying, usuario_estado smallint, usuario_genero character varying, usuario_nombre character varying, usuario_email character varying, usuario_etiqueta bigint, usuario_login timestamp without time zone, usuario_creado timestamp without time zone, usuario_poster text)
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


ALTER FUNCTION public.usuario_obtener_datos(in_usuario_id bigint) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: imagen; Type: TABLE; Schema: public; Owner: app_vav; Tablespace: 
--

CREATE TABLE imagen (
    imagen_id bigint NOT NULL,
    imagen_orden bigint NOT NULL,
    imagen_objeto bigint NOT NULL,
    imagen_tipo character varying(3) NOT NULL,
    imagen_estado smallint DEFAULT 1,
    imagen_titulo character varying(32),
    imagen_bajada character varying(64),
    imagen_tags character varying(128),
    imagen_extension character varying(4) NOT NULL,
    imagen_cambio bigint,
    imagen_creado timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT imagen_imagen_extension_check CHECK (((imagen_extension)::text = ANY (ARRAY[('.jpg'::character varying)::text, ('.gif'::character varying)::text, ('.png'::character varying)::text]))),
    CONSTRAINT imagen_imagen_tipo_check CHECK (((imagen_tipo)::text = 'USU'::text))
);


ALTER TABLE public.imagen OWNER TO app_vav;

--
-- Name: imagen_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE imagen_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.imagen_id_seq OWNER TO app_vav;

--
-- Name: imagen_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE imagen_id_seq OWNED BY imagen.imagen_id;


--
-- Name: imagen_imagen_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE imagen_imagen_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.imagen_imagen_id_seq OWNER TO app_vav;

--
-- Name: imagen_imagen_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE imagen_imagen_id_seq OWNED BY imagen.imagen_id;


--
-- Name: mesa; Type: TABLE; Schema: public; Owner: app_vav; Tablespace: 
--

CREATE TABLE mesa (
    mesa_id bigint NOT NULL,
    usuario_id bigint DEFAULT 4 NOT NULL,
    mesa_orden bigint DEFAULT 0 NOT NULL,
    mesa_destacada smallint DEFAULT 0,
    mesa_estado smallint DEFAULT 0,
    mesa_nombre character varying(32),
    mesa_numero character varying(64),
    mesa_region character varying(32),
    mesa_ciudad character varying(32),
    mesa_cambio timestamp without time zone DEFAULT now() NOT NULL,
    mesa_creado timestamp without time zone DEFAULT now() NOT NULL
);

ALTER TABLE public.mesa OWNER TO app_vav;

--
-- Name: mesa_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE mesa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mesa_id_seq OWNER TO app_vav;

--
-- Name: mesa_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE mesa_id_seq OWNED BY mesa.mesa_id;


--
-- Name: mesa_mesa_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE mesa_mesa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mesa_mesa_id_seq OWNER TO app_vav;

--
-- Name: mesa_mesa_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE mesa_mesa_id_seq OWNED BY mesa.mesa_id;


--
-- Name: swich; Type: TABLE; Schema: public; Owner: app_vav; Tablespace: 
--

CREATE TABLE swich (
    swich_id bigint NOT NULL,
    swich_mesas smallint DEFAULT 0,
    swich_mesa_1 smallint DEFAULT 0,
    swich_mesa_2 smallint DEFAULT 0,
    swich_mesa_3 smallint DEFAULT 0,
    swich_mesa_4 smallint DEFAULT 0,
    swich_votos character varying(1) DEFAULT 'p'::character varying,
    swich_cambio timestamp without time zone DEFAULT now() NOT NULL,
    swich_modo smallint
);


ALTER TABLE public.swich OWNER TO app_vav;

--
-- Name: swich_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE swich_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.swich_id_seq OWNER TO app_vav;

--
-- Name: swich_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE swich_id_seq OWNED BY swich.swich_id;


--
-- Name: swich_swich_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE swich_swich_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.swich_swich_id_seq OWNER TO app_vav;

--
-- Name: swich_swich_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE swich_swich_id_seq OWNED BY swich.swich_id;


--
-- Name: usuario; Type: TABLE; Schema: public; Owner: app_vav; Tablespace: 
--

CREATE TABLE usuario (
    usuario_id bigint NOT NULL,
    usuario_rol character varying(2) DEFAULT 'OP'::character varying,
    usuario_estado smallint DEFAULT 1,
    usuario_genero character varying(1) DEFAULT 'n'::character varying,
    usuario_nombre character varying(32),
    usuario_email character varying(64),
    usuario_password character varying(32),
    usuario_etiqueta bigint DEFAULT 1,
    usuario_login timestamp without time zone DEFAULT now(),
    usuario_creado timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT usuario_usuario_genero_check CHECK (((usuario_genero)::text = ANY (ARRAY[('n'::character varying)::text, ('f'::character varying)::text, ('m'::character varying)::text]))),
    CONSTRAINT usuario_usuario_rol_check CHECK (((usuario_rol)::text = ANY (ARRAY[('AD'::character varying)::text, ('AM'::character varying)::text, ('OP'::character varying)::text, ('VZ'::character varying)::text])))
);


ALTER TABLE public.usuario OWNER TO app_vav;

--
-- Name: usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE usuario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuario_id_seq OWNER TO app_vav;

--
-- Name: usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE usuario_id_seq OWNED BY usuario.usuario_id;


--
-- Name: usuario_usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE usuario_usuario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuario_usuario_id_seq OWNER TO app_vav;

--
-- Name: usuario_usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE usuario_usuario_id_seq OWNED BY usuario.usuario_id;


--
-- Name: imagen_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY imagen ALTER COLUMN imagen_id SET DEFAULT nextval('imagen_id_seq'::regclass);


--
-- Name: mesa_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY mesa ALTER COLUMN mesa_id SET DEFAULT nextval('mesa_id_seq'::regclass);


--
-- Name: swich_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY swich ALTER COLUMN swich_id SET DEFAULT nextval('swich_id_seq'::regclass);


--
-- Name: usuario_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY usuario ALTER COLUMN usuario_id SET DEFAULT nextval('usuario_id_seq'::regclass);


--
-- Name: imagen_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY imagen
    ADD CONSTRAINT imagen_pkey PRIMARY KEY (imagen_id);


--
-- Name: mesa_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY mesa
    ADD CONSTRAINT mesa_pkey PRIMARY KEY (mesa_id);


--
-- Name: swich_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY swich
    ADD CONSTRAINT swich_pkey PRIMARY KEY (swich_id);


--
-- Name: usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (usuario_id);


--
-- Name: mesa_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY mesa
    ADD CONSTRAINT mesa_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES usuario(usuario_id) ON DELETE RESTRICT;


--
-- Name: public; Type: ACL; Schema: -; Owner: app_vav
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM app_vav;
GRANT ALL ON SCHEMA public TO app_vav;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--
