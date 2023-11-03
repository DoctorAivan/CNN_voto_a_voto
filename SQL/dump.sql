--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: VAV; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE "VAV" IS 'Aplicación Voto a Voto Elecciones';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


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
-- Name: mesa_candidato_guardar(bigint, character varying, character varying); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION mesa_candidato_guardar(in_candidato_id bigint, in_candidato_nombres character varying, in_candidato_apellidos character varying) RETURNS bigint
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


ALTER FUNCTION public.mesa_candidato_guardar(in_candidato_id bigint, in_candidato_nombres character varying, in_candidato_apellidos character varying) OWNER TO app_vav;

--
-- Name: mesa_candidatos(bigint); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION mesa_candidatos(in_mesa_id bigint) RETURNS TABLE(voto_id bigint, voto_total smallint, candidato_id bigint, candidato_nombre character varying, candidato_nombres character varying, candidato_apellidos character varying, candidato_lista character varying)
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


ALTER FUNCTION public.mesa_candidatos(in_mesa_id bigint) OWNER TO app_vav;

--
-- Name: mesa_candidatos_swich(bigint); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION mesa_candidatos_swich(in_mesa_id bigint) RETURNS TABLE(voto_id bigint, voto_total smallint, candidato_id bigint, candidato_nombres character varying, candidato_apellidos character varying, candidato_genero character varying, candidato_independiente boolean, candidato_lista character varying, partido_codigo character varying, pacto_codigo character varying)
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
			pacto.pacto_codigo
	
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

		ORDER BY candidato.candidato_orden ASC
	    ;
	
	END $$;


ALTER FUNCTION public.mesa_candidatos_swich(in_mesa_id bigint) OWNER TO app_vav;

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
-- Name: mesa_detalles(bigint); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION mesa_detalles(in_mesa_id bigint) RETURNS TABLE(mesa_id bigint, usuario_id bigint, mesa_tipo character varying, mesa_zona bigint, mesa_zona_titulo character varying, mesa_comuna character varying, mesa_local character varying, mesa_numero character varying, mesa_orden smallint, mesa_estado smallint, mesa_destacada smallint, mesa_votos_blancos smallint, mesa_votos_nulos smallint, mesa_cambio timestamp without time zone, mesa_creado timestamp without time zone, usuario_nombre character varying)
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


ALTER FUNCTION public.mesa_detalles(in_mesa_id bigint) OWNER TO app_vav;

--
-- Name: mesa_detalles_swich(bigint); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION mesa_detalles_swich(in_mesa_id bigint) RETURNS TABLE(mesa_id bigint, mesa_tipo character varying, mesa_zona_titulo character varying, mesa_comuna character varying, mesa_local character varying, mesa_numero character varying)
    LANGUAGE plpgsql
    AS $$

		BEGIN

		return QUERY

	    SELECT

            mesa.mesa_id,

            mesa.mesa_tipo,

            mesa.mesa_zona_titulo,

			mesa.mesa_comuna,

            mesa.mesa_local,

            mesa.mesa_numero

	    FROM

	        mesa

	    WHERE

	        mesa.mesa_id = in_mesa_id

	    LIMIT 1

	    ;

	END $$;


ALTER FUNCTION public.mesa_detalles_swich(in_mesa_id bigint) OWNER TO app_vav;

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
-- Name: mesa_eliminar(bigint); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION mesa_eliminar(in_mesa_id bigint) RETURNS bigint
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


ALTER FUNCTION public.mesa_eliminar(in_mesa_id bigint) OWNER TO app_vav;

--
-- Name: mesa_guardar(bigint, bigint, bigint, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION mesa_guardar(in_mesa_id bigint, in_usuario_id bigint, in_mesa_estado bigint, in_mesa_comuna character varying, in_mesa_local character varying, in_mesa_numero character varying) RETURNS bigint
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


ALTER FUNCTION public.mesa_guardar(in_mesa_id bigint, in_usuario_id bigint, in_mesa_estado bigint, in_mesa_comuna character varying, in_mesa_local character varying, in_mesa_numero character varying) OWNER TO app_vav;

--
-- Name: mesa_listado(integer, integer); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION mesa_listado(in_limit integer, in_offset integer) RETURNS TABLE(mesa_id bigint, usuario_id bigint, mesa_tipo character varying, mesa_orden smallint, mesa_destacada smallint, mesa_estado smallint, mesa_zona bigint, mesa_zona_titulo character varying, mesa_comuna character varying, mesa_local character varying, mesa_numero character varying, mesa_votos_blancos smallint, mesa_votos_nulos smallint, mesa_cambio timestamp without time zone, mesa_creado timestamp without time zone, usuario_nombre character varying)
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

	        mesa.mesa_destacada DESC,

			mesa.mesa_estado DESC,

	        mesa.mesa_cambio DESC

	    LIMIT in_limit OFFSET in_offset

	    ;

	END $$;


ALTER FUNCTION public.mesa_listado(in_limit integer, in_offset integer) OWNER TO app_vav;

--
-- Name: mesa_nuevo(bigint, character varying, bigint, character varying, character varying); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION mesa_nuevo(in_usuario_id bigint, in_mesa_tipo character varying, in_mesa_zona bigint, in_mesa_zona_titulo character varying, in_mesa_comuna character varying) RETURNS bigint
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


ALTER FUNCTION public.mesa_nuevo(in_usuario_id bigint, in_mesa_tipo character varying, in_mesa_zona bigint, in_mesa_zona_titulo character varying, in_mesa_comuna character varying) OWNER TO app_vav;

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
-- Name: mesa_usuario_contar_total(bigint); Type: FUNCTION; Schema: public; Owner: app_vav
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


ALTER FUNCTION public.mesa_usuario_contar_total(in_usuario_id bigint) OWNER TO app_vav;

--
-- Name: mesa_usuario_listado(bigint, integer, integer); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION mesa_usuario_listado(in_usuario_id bigint, in_limit integer, in_offset integer) RETURNS TABLE(mesa_id bigint, usuario_id bigint, mesa_tipo character varying, mesa_orden smallint, mesa_destacada smallint, mesa_estado smallint, mesa_zona bigint, mesa_zona_titulo character varying, mesa_comuna character varying, mesa_local character varying, mesa_numero character varying, mesa_votos_blancos smallint, mesa_votos_nulos smallint, mesa_cambio timestamp without time zone, mesa_creado timestamp without time zone, usuario_nombre character varying)
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


ALTER FUNCTION public.mesa_usuario_listado(in_usuario_id bigint, in_limit integer, in_offset integer) OWNER TO app_vav;

--
-- Name: mesa_voto(bigint, bigint, bigint); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION mesa_voto(in_mesa_id bigint, in_voto_id bigint, in_voto_total bigint) RETURNS bigint
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


ALTER FUNCTION public.mesa_voto(in_mesa_id bigint, in_voto_id bigint, in_voto_total bigint) OWNER TO app_vav;

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
-- Name: swich_mesas(bigint, bigint, bigint); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION swich_mesas(in_mesa_1 bigint, in_mesa_2 bigint, in_mesa_3 bigint) RETURNS TABLE(mesa_id bigint, mesa_tipo character varying, mesa_zona bigint, mesa_zona_titulo character varying, mesa_comuna character varying, mesa_local character varying, mesa_numero character varying)
    LANGUAGE plpgsql
    AS $$
	    
		BEGIN
		return QUERY
		
	    SELECT
            mesa.mesa_id,
            mesa.mesa_tipo,
			mesa.mesa_zona,
            mesa.mesa_zona_titulo,
			mesa.mesa_comuna,
            mesa.mesa_local,
            mesa.mesa_numero
	
	    FROM
	        mesa
	        
		WHERE
			mesa.mesa_id IN ( in_mesa_1 , in_mesa_2 , in_mesa_3 )
	
	    LIMIT 3
	    ;
	
	END $$;


ALTER FUNCTION public.swich_mesas(in_mesa_1 bigint, in_mesa_2 bigint, in_mesa_3 bigint) OWNER TO app_vav;

--
-- Name: swich_mesas_total(character varying); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION swich_mesas_total(in_mesa_tipo character varying) RETURNS TABLE(votos_total bigint, round numeric, candidato_id bigint, candidato_nombres character varying, candidato_apellidos character varying, partido_codigo character varying)
    LANGUAGE plpgsql
    AS $$
	    
		BEGIN
		return QUERY
		
		        SELECT
            sum(t2.voto_total) as votos_total,
            round(( cast (sum(t2.voto_total)as decimal) /
 
        case when
        (
            SELECT
                sum(t2.voto_total)
 
            from
                mesa t1,
                voto t2,
                candidato t3,
                (
                    select mesa_id, row_number() over (ORDER BY mesa_id)as rownum
                    from mesa 
                    where mesa_tipo = 'P' 
                    and mesa_estado = 1 
                    order by mesa_id
                ) t5
 
            WHERE
                t1.mesa_tipo = 'P' AND
                t2.mesa_id = t1.mesa_id AND
                t3.candidato_id = t2.candidato_id and
                t1.mesa_id = t5.mesa_id AND
                t5.rownum <= 20
        ) = 0 then 1 else (
            SELECT
                sum(t2.voto_total) 
 
            from
                mesa t1,
                voto t2,
                candidato t3,
                (
                    select mesa_id, row_number() over (ORDER BY mesa_id)as rownum
                    from mesa 
                    where mesa_tipo = 'P' 
                    and mesa_estado = 1 
                    order by mesa_id
                ) t5
 
            WHERE
                t1.mesa_tipo = 'P' AND
                t2.mesa_id = t1.mesa_id AND
                t3.candidato_id = t2.candidato_id AND
                t1.mesa_id = t5.mesa_id AND
                t5.rownum <= 20
            )  end) * 100,2),
            t3.candidato_id,
            t3.candidato_nombres,
            t3.candidato_apellidos,
            t4.partido_codigo
        from
            mesa t1,
            voto t2,
            candidato t3,
            partido t4,
            (
                    select mesa_id, row_number() over (ORDER BY mesa_id)as rownum
                    from mesa 
                    where mesa_tipo = 'P' 
                    and mesa_estado = 1 
                    order by mesa_id
                ) t5
        WHERE
            t1.mesa_tipo = 'P' AND
            t1.mesa_estado = 1 AND
            t2.mesa_id = t1.mesa_id AND
            t2.mesa_id =  t5.mesa_id AND
            t5.rownum <= 20 AND
            t3.candidato_id = t2.candidato_id AND
            t4.partido_id = t3.partido_id
        group by
            t3.candidato_id,
            t3.candidato_apellidos,
            t4.partido_codigo
        order by sum(t2.voto_total) desc;

	END $$;


ALTER FUNCTION public.swich_mesas_total(in_mesa_tipo character varying) OWNER TO app_vav;

--
-- Name: swich_mesas_total_actuales(); Type: FUNCTION; Schema: public; Owner: app_vav
--

CREATE FUNCTION swich_mesas_total_actuales() RETURNS TABLE(mesa bigint)
    LANGUAGE plpgsql
    AS $$
	    
		BEGIN
		return QUERY
		
		select t0.mesa_id AS mesa from (
		select t1.mesa_id, row_number() over (ORDER BY t1.mesa_id) as rownum
		from mesa t1 
		where t1.mesa_tipo = 'P' 
		and t1.mesa_estado = 1 
		order by t1.mesa_id ) as t0
		where t0.rownum <= 20;

	END $$;


ALTER FUNCTION public.swich_mesas_total_actuales() OWNER TO app_vav;

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
-- Name: candidato; Type: TABLE; Schema: public; Owner: app_vav; Tablespace: 
--

CREATE TABLE candidato (
    candidato_id bigint NOT NULL,
    candidato_tipo character varying(3) DEFAULT 'ALC'::character varying,
    candidato_orden smallint DEFAULT 1 NOT NULL,
    candidato_zona bigint DEFAULT 0 NOT NULL,
    pacto_id bigint DEFAULT 1 NOT NULL,
    partido_id bigint DEFAULT 1 NOT NULL,
    candidato_nombre character varying(128),
    candidato_nombre_corto character varying(128),
    candidato_genero character varying(1) DEFAULT 'n'::character varying,
    candidato_independiente boolean DEFAULT false,
    candidato_lista character varying(12),
    candidato_nombres character varying(64),
    candidato_apellidos character varying(64)
);


ALTER TABLE public.candidato OWNER TO app_vav;

--
-- Name: candidato_candidato_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE candidato_candidato_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.candidato_candidato_id_seq OWNER TO app_vav;

--
-- Name: candidato_candidato_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE candidato_candidato_id_seq OWNED BY candidato.candidato_id;


--
-- Name: candidato_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE candidato_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.candidato_id_seq OWNER TO app_vav;

--
-- Name: candidato_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE candidato_id_seq OWNED BY candidato.candidato_id;


--
-- Name: comuna; Type: TABLE; Schema: public; Owner: app_vav; Tablespace: 
--

CREATE TABLE comuna (
    comuna_id bigint NOT NULL,
    region_id bigint DEFAULT 1 NOT NULL,
    distrito_id smallint NOT NULL,
    comuna_nombre character varying(64)
);


ALTER TABLE public.comuna OWNER TO app_vav;

--
-- Name: comuna_comuna_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE comuna_comuna_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comuna_comuna_id_seq OWNER TO app_vav;

--
-- Name: comuna_comuna_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE comuna_comuna_id_seq OWNED BY comuna.comuna_id;


--
-- Name: comuna_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE comuna_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comuna_id_seq OWNER TO app_vav;

--
-- Name: comuna_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE comuna_id_seq OWNED BY comuna.comuna_id;


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
    usuario_id bigint DEFAULT 1 NOT NULL,
    mesa_tipo character varying(3) DEFAULT 'ALC'::character varying,
    mesa_zona bigint DEFAULT 0 NOT NULL,
    mesa_zona_titulo character varying(64),
    mesa_comuna character varying(64),
    mesa_local character varying(64),
    mesa_numero character varying(64) DEFAULT 'M '::character varying,
    mesa_orden smallint DEFAULT 1 NOT NULL,
    mesa_estado smallint DEFAULT 0 NOT NULL,
    mesa_destacada smallint DEFAULT 0 NOT NULL,
    mesa_votos_blancos smallint DEFAULT 0 NOT NULL,
    mesa_votos_nulos smallint DEFAULT 0 NOT NULL,
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
-- Name: pacto; Type: TABLE; Schema: public; Owner: app_vav; Tablespace: 
--

CREATE TABLE pacto (
    pacto_id bigint NOT NULL,
    pacto_codigo character varying(24),
    pacto_nombre character varying(64)
);


ALTER TABLE public.pacto OWNER TO app_vav;

--
-- Name: pacto_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE pacto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pacto_id_seq OWNER TO app_vav;

--
-- Name: pacto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE pacto_id_seq OWNED BY pacto.pacto_id;


--
-- Name: pacto_pacto_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE pacto_pacto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pacto_pacto_id_seq OWNER TO app_vav;

--
-- Name: pacto_pacto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE pacto_pacto_id_seq OWNED BY pacto.pacto_id;


--
-- Name: partido; Type: TABLE; Schema: public; Owner: app_vav; Tablespace: 
--

CREATE TABLE partido (
    partido_id bigint NOT NULL,
    partido_nombre character varying(64),
    partido_codigo character varying(16)
);


ALTER TABLE public.partido OWNER TO app_vav;

--
-- Name: partido_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE partido_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.partido_id_seq OWNER TO app_vav;

--
-- Name: partido_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE partido_id_seq OWNED BY partido.partido_id;


--
-- Name: partido_partido_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE partido_partido_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.partido_partido_id_seq OWNER TO app_vav;

--
-- Name: partido_partido_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE partido_partido_id_seq OWNED BY partido.partido_id;


--
-- Name: region; Type: TABLE; Schema: public; Owner: app_vav; Tablespace: 
--

CREATE TABLE region (
    region_id bigint NOT NULL,
    region_nombre character varying(32),
    region_codigo character varying(5)
);


ALTER TABLE public.region OWNER TO app_vav;

--
-- Name: region_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE region_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.region_id_seq OWNER TO app_vav;

--
-- Name: region_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE region_id_seq OWNED BY region.region_id;


--
-- Name: region_region_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE region_region_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.region_region_id_seq OWNER TO app_vav;

--
-- Name: region_region_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE region_region_id_seq OWNED BY region.region_id;


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
-- Name: voto; Type: TABLE; Schema: public; Owner: app_vav; Tablespace: 
--

CREATE TABLE voto (
    voto_id bigint NOT NULL,
    candidato_id bigint DEFAULT 1 NOT NULL,
    mesa_id bigint DEFAULT 1 NOT NULL,
    voto_total smallint NOT NULL
);


ALTER TABLE public.voto OWNER TO app_vav;

--
-- Name: voto_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE voto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.voto_id_seq OWNER TO app_vav;

--
-- Name: voto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE voto_id_seq OWNED BY voto.voto_id;


--
-- Name: voto_voto_id_seq; Type: SEQUENCE; Schema: public; Owner: app_vav
--

CREATE SEQUENCE voto_voto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.voto_voto_id_seq OWNER TO app_vav;

--
-- Name: voto_voto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_vav
--

ALTER SEQUENCE voto_voto_id_seq OWNED BY voto.voto_id;


--
-- Name: candidato_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY candidato ALTER COLUMN candidato_id SET DEFAULT nextval('candidato_id_seq'::regclass);


--
-- Name: comuna_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY comuna ALTER COLUMN comuna_id SET DEFAULT nextval('comuna_id_seq'::regclass);


--
-- Name: imagen_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY imagen ALTER COLUMN imagen_id SET DEFAULT nextval('imagen_id_seq'::regclass);


--
-- Name: mesa_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY mesa ALTER COLUMN mesa_id SET DEFAULT nextval('mesa_id_seq'::regclass);


--
-- Name: pacto_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY pacto ALTER COLUMN pacto_id SET DEFAULT nextval('pacto_id_seq'::regclass);


--
-- Name: partido_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY partido ALTER COLUMN partido_id SET DEFAULT nextval('partido_id_seq'::regclass);


--
-- Name: region_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY region ALTER COLUMN region_id SET DEFAULT nextval('region_id_seq'::regclass);


--
-- Name: swich_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY swich ALTER COLUMN swich_id SET DEFAULT nextval('swich_id_seq'::regclass);


--
-- Name: usuario_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY usuario ALTER COLUMN usuario_id SET DEFAULT nextval('usuario_id_seq'::regclass);


--
-- Name: voto_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY voto ALTER COLUMN voto_id SET DEFAULT nextval('voto_id_seq'::regclass);


--
-- Data for Name: candidato; Type: TABLE DATA; Schema: public; Owner: app_vav
--

COPY candidato (candidato_id, candidato_tipo, candidato_orden, candidato_zona, pacto_id, partido_id, candidato_nombre, candidato_nombre_corto, candidato_genero, candidato_independiente, candidato_lista, candidato_nombres, candidato_apellidos) FROM stdin;
14109173	S	12	5003	357	357003	Katherine Elizabeth Lopez Rivera	KATHERINE LÓPEZ	M	f	AA	KATHERINE	LÓPEZ
15501118	S	10	5003	357	357001	Paulina Andrea Nuñez Urrutia	PAULINA NÚÑEZ	M	f	AA	PAULINA	NÚÑEZ
12437024	S	14	5003	367	367157	Paola Amanda Debia Gonzalez	PAOLA DEBIA	M	f	AB	PAOLA	DEBIA
7699367	S	13	5003	357	357003	Daniel Guevara Cortes	DANIEL GUEVARA	M	t	AA	DANIEL 	GUEVARA
14901742	S	11	5003	357	357001	Marco Antonio Diaz Muñoz	MARCO DÍAZ	M	f	AA	MARCO	DÍAZ
15979651	S	16	5003	367	367157	Tamara Jocelyn Gaytan Chavez	TAMARA GAYTÁN	M	f	AB	TAMARA	GAYTÁN
15690372	S	15	5003	367	367157	Ricardo Felipe Vargas Valenzuela	RICARDO VARGAS	M	f	AB	RICARDO	VARGAS
15748308	S	17	5003	363	363135	Galia Tatiana Aguilera Caballero	GALIA AGUILERA	M	f	AE	GALIA	AGUILERA
16007707	S	18	5003	363	363135	Domingo Lara Izquierdo	DOMINGO LARA	M	f	AE	DOMINGO	LARA
8514830	S	21	5003	370	370007	Marcela Hernando Perez	MARCELA HERNANDO	M	f	AH	MARCELA 	HERNANDO
13743556	S	22	5003	370	370002	Jeanette Hurtado Rojas	JEANETTE HURTADO	M	f	AH	JEANETTE	HURTADO
12615234	S	19	5003	370	370004	Pedro Araya Guerrero	PEDRO ARAYA	M	t	AH	PEDRO	ARAYA
16136093	S	20	5003	370	370005	Jacqueline Santander Miranda	JACQUELINE SANTANDER	M	f	AH	JACQUELINE	SANTANDER
13205928	S	26	5003	365	365130	Marta Molina Avila	MARTA MOLINA	M	f	AR	MARTA	MOLINA
13633160	S	23	5003	346	346144	Moises Fabian Ibacache Iguain	MOISÉS IBACACHE	M	f	AN	MOISÉS	IBACACHE
9391709	S	25	5003	365	365130	Esteban Velasquez Nuñez	ESTEBAN VELÁSQUEZ	M	f	AR	ESTEBAN	VELÁSQUEZ
13216055	S	24	5003	346	346144	Maria Susana Vera Ibacache	MARÍA VERA	M	t	AN	MARÍA	VERA
8475205	S	30	5003	349	349180	Cesar Antonio Araya Garcia	CÉSAR ARAYA	M	t	AW	CÉSAR	ARAYA
13076714	S	29	5003	349	349180	German Eugenio Romagnoli Delporte	GERMÁN ROMAGNOLI	M	f	AW	GERMÁN 	ROMAGNOLI
12633106	S	28	5003	365	365045	Ivan Igor Avila Perez	IVÁN ÁVILA	M	f	AR	IVÁN	ÁVILA
7049156	S	27	5003	365	365006	Jan Jose Cademartori Dujisin	JAN CADEMARTORI	M	f	AR	JAN 	CADEMARTORI
9533365	S	10	5005	357	357003	Sergio Gahona Salazar	SERGIO GAHONA	M	f	AA	SERGIO 	GAHONA
13454634	S	11	5005	357	357003	Alejandra Valdovinos Jofre	ALEJANDRA VALDOVINOS	M	f	AA	ALEJANDRA 	VALDOVINOS
15596093	S	13	5005	357	357001	Giannina Teresa Gonzalez Michea	GIANNINA GONZÁLEZ	M	f	AA	GIANNINA	GONZÁLEZ
10231488	S	12	5005	357	357140	Pedro Antonio Velasquez Seguel	PEDRO VELÁSQUEZ	M	t	AA	PEDRO	VELÁSQUEZ
13760298	S	14	5005	367	367157	Eileen Patricia Urqueta Rojas	EILEEN URQUETA	M	f	AB	EILEEN	URQUETA
14386414	S	15	5005	367	367157	Cristian Andres Astorga Cortes	CRISTIAN ASTORGA	M	f	AB	CRISTIAN	ASTORGA
9904842	S	20	5005	365	365006	Daniel Nuñez Arancibia	DANIEL NÚÑEZ	M	f	AR	DANIEL 	NÚÑEZ
6377056	S	18	5005	346	346144	Caterina Teresa Simoncelli Fracchia	CATERINA SIMONCELLI	M	t	AN	CATERINA	SIMONCELLI
10808129	S	16	5005	370	370002	Matias Walker Prieto	MATÍAS WALKER	M	f	AH	MATÍAS	WALKER
6025646	S	17	5005	370	370004	Adriana Muñoz Dalbora	ADRIANA MUÑOZ	M	f	AH	ADRIANA	MUÑOZ
12003311	S	21	5005	365	365149	Marcelo Diaz Diaz	MARCELO DÍAZ	M	t	AR	MARCELO	DÍAZ
10273346	S	19	5005	346	346144	Esteban Vilchez Celis	ESTEBAN VILCHEZ	M	t	AN	ESTEBAN	VILCHEZ
13224502	S	23	5005	365	365143	Edio Eduardo Cortes Lara	EDIO CORTÉS	M	f	AR	EDIO	CORTÉS
9207521	S	24	5005	349	349180	Sergio Arnoldo Rojas Tapia	SERGIO ROJAS	M	t	AW	SERGIO 	ROJAS
13708228	S	22	5005	365	365130	Jeannette Del Carmen Medina Araya	JEANNETTE MEDINA	M	t	AR	JEANNETTE	MEDINA
7022006	S	10	5007	357	357001	Manuel Jose Ossandon Irarrazabal	MANUEL OSSANDÓN	M	f	AA	MANUEL JOSÉ	OSSANDÓN
10608619	S	11	5007	357	357001	Marcela Constanza Sabat Fernandez	MARCELA SABAT	M	f	AA	MARCELA	SABAT
13768447	S	12	5007	357	357003	Daniela Del Pilar Cabezas Vera	DANIELA CABEZAS	M	f	AA	DANIELA	CABEZAS
11978340	S	13	5007	357	357003	Carolina Lavin Aliaga	CAROLINA LAVÍN	M	f	AA	CAROLINA	LAVÍN
7155618	S	15	5007	357	357037	Jaime Mañalich Muxi	JAIME MAÑALICH	M	t	AA	JAIME 	MAÑALICH
10031381	S	14	5007	357	357037	Luciano Cruz-coke Carvallo	LUCIANO CRUZ-COKE	M	f	AA	LUCIANO	CRUZ-COKE
13656550	S	17	5007	367	367157	Erna Del Carmen Perez Gaete	ERNA PÉREZ	M	f	AB	ERNA 	PÉREZ
13030035	S	16	5007	367	367157	Valeska De Las Nieves Oyarce Peña	VALESKA OYARCE	M	f	AB	VALESKA	OYARCE
10667756	S	21	5007	367	367157	Roberto Javier Cofre Cerda	ROBERTO COFRÉ	M	f	AB	ROBERTO	COFRÉ
8665476	S	18	5007	367	367157	Rodrigo Ignacio Silva Alfaro	RODRIGO SILVA	M	f	AB	RODRIGO	SILVA
15844381	S	20	5007	367	367157	Carolina Eilyn Gonzalez Abarca	CAROLINA GONZÁLEZ	M	f	AB	CAROLINA	GONZÁLEZ
12469575	S	19	5007	367	367157	Rodrigo Alejandro Diaz Muñoz	RODRIGO DÍAZ	M	f	AB	RODRIGO	DÍAZ
6908955	S	22	5007	370	370137	Veronica Pilar Pardo Lagos	VERÓNICA PARDO	M	t	AH	VERÓNICA	PARDO
8493329	S	23	5007	370	370002	Eugenio Ortega Frei	EUGENIO ORTEGA	M	f	AH	EUGENIO	ORTEGA
8779559	S	24	5007	370	370002	Gabriel Silber Romo	GABRIEL SILBER	M	f	AH	GABRIEL	SILBER
12710192	S	26	5007	370	370004	Alberto Pizarro Chañilao	ALBERTO PIZARRO	M	f	AH	ALBERTO	PIZARRO
10771962	S	25	5007	370	370005	Paulina Vodanovic Rojas	PAULINA VODANOVIC	M	f	AH	PAULINA 	VODANOVIC
10055396	S	27	5007	370	370004	Natalia Piergentili Domenech	NATALIA PIERGENTILI	M	f	AH	NATALIA	PIERGENTILI
13575634	S	28	5007	355	355142	Celeste Jimenez Riveros	CELESTE JIMÉNEZ	M	f	AL	CELESTE	JIMÉNEZ
16373659	S	30	5007	355	355142	Daiana Squella Venenciano	DAIANA SQUELLA	M	f	AL	DAIANA	SQUELLA
10596570	S	29	5007	355	355142	Patricio Neira Pezoa	PATRICIO NEIRA	M	f	AL	PATRICIO 	NEIRA
5993385	S	32	5007	375	375147	Fresia Monica Quilodran Ramos	FRESIA QUILODRÁN	M	f	AM	FRESIA	QUILODRÁN
7690949	S	31	5007	375	375147	Rafael Alejandro Aravena Egaña	RAFAEL ARAVENA	M	f	AM	RAFAEL	ARAVENA
14153217	S	33	5007	375	375147	Varinia Yuseth Aravena Perez	VARINIA ARAVENA	M	f	AM	VARINIA 	ARAVENA
13298961	S	34	5007	346	346144	Paula Carolina Cancino Cancino	PAULA CANCINO	M	f	AN	PAULA	CANCINO
16429997	S	35	5007	346	346144	Mariana Cecilia Gutierrez Garcia	MARIANA GUTIÉRREZ	M	f	AN	MARIANA	GUTIÉRREZ
11863088	S	37	5007	346	346008	Marcelo Humberto Rioseco Pais	MARCELO RIOSECO	M	f	AN	MARCELO	RIOSECO
16297816	S	36	5007	346	346144	Rodrigo Enrique Urzua Chavez	RODRIGO URZÚA	M	t	AN	RODRIGO	URZÚA
8129286	S	38	5007	346	346008	Mercedes Del Carmen Bravo Valenzuela	MERCEDES BRAVO	M	f	AN	MERCEDES	BRAVO
6163989	S	42	5007	341	341150	Ricardo Fernando Ortega Perrier	RICARDO ORTEGA	M	f	AP	RICARDO	ORTEGA
7824511	S	41	5007	341	341150	Alvaro Emilio Pezoa Bissieres	ÁLVARO PEZOA	M	f	AP	ÁLVARO	PEZOA
13198884	S	39	5007	341	341150	Rojo Edwards Silva	ROJO EDWARDS	M	f	AP	ROJO	EDWARDS
9480453	S	40	5007	341	341150	Maria Idilia Gatica Gajardo	MARÍA GATICA	M	f	AP	MARÍA	GATICA
8698973	S	44	5007	341	341150	Beatriz Maturana Cossio	BEATRIZ MATURANA	M	t	AP	BEATRIZ	MATURANA
14098529	S	43	5007	341	341150	Pamela Andrea Pizarro Villarroel	PAMELA PIZARRO	M	t	AP	PAMELA	PIZARRO
16029379	S	45	5007	365	365143	Karina Loretta Oliva Perez	KARINA OLIVA	M	f	AR	KARINA 	OLIVA
4938564	S	47	5007	365	365006	Guillermo Leon Teillier Del Valle	GUILLERMO TEILLIER	M	f	AR	GUILLERMO	TEILLIER
7514846	S	46	5007	365	365143	Gonzalo Daniel Martner Fanta	GONZALO MARTNER	M	t	AR	GONZALO	MARTNER
12238818	S	48	5007	365	365006	Claudia Pascual Grau	CLAUDIA PASCUAL	M	f	AR	CLAUDIA	PASCUAL
16470244	S	49	5007	365	365045	Rocio Donoso Pineda	ROCÍO DONOSO	M	f	AR	ROCÍO	DONOSO
12962150	S	50	5007	365	365045	Sebastian Depolo Cabrera	SEBASTIÁN DEPOLO	M	f	AR	SEBASTIÁN	DEPOLO
10579566	S	51	5007	349	349180	Cristian Contreras Radovic	CRISTIÁN CONTRERAS	M	f	AW	CRISTIÁN	CONTRERAS
16126286	S	52	5007	349	349180	Fabiola Mabel Moya Hernandez	FABIOLA MOYA	M	f	AW	FABIOLA	MOYA
12474572	S	53	5007	349	349180	Ruth Rojas Mera	RUTH ROJAS	M	f	AW	RUTH	ROJAS
15618732	S	54	5007	999	99	Fabiola Campillai Rojas	FABIOLA CAMPILLAI	M	t	ZZZ	FABIOLA 	CAMPILLAI
13435926	S	10	5008	357	357003	Javier Macaya Danus	JAVIER MACAYA	M	f	AA	JAVIER 	MACAYA
7433074	S	11	5008	357	357003	Ramon Barros Montero	RAMÓN BARROS	M	f	AA	RAMÓN 	BARROS
6383579	S	12	5008	357	357001	Virginia Eugenia Troncoso Hellman	VIRGINIA TRONCOSO	M	t	AA	VIRGINIA	TRONCOSO
15643945	S	13	5008	357	357001	Macarena Del Pilar Matas Picart	MACARENA MATAS	M	f	AA	MACARENA	MATAS
16252367	S	14	5008	367	367157	Claudio Alexis Mella Zamorano	CLAUDIO MELLA	M	f	AB	CLAUDIO	MELLA
9282630	S	15	5008	367	367157	Mario Arturo Leyton Bravo	MARIO LEYTON	M	f	AB	MARIO	LEYTON
8045106	S	17	5008	370	370005	Juan Luis Castro Gonzalez	JUAN CASTRO	M	f	AH	JUAN LUIS	CASTRO
15883479	S	16	5008	367	367157	Ruth Irene Alvarado Montes	RUTH ALVARADO	M	f	AB	RUTH	ALVARADO
12911092	S	18	5008	370	370002	Marcia Isabel Barrera Cisternas	MARCIA BARRERA	M	f	AH	MARCIA	BARRERA
6923053	S	19	5008	370	370007	Jose Antonio Gomez Urrutia	JOSÉ GÓMEZ	M	f	AH	JOSÉ ANTONIO	GÓMEZ
10072180	S	21	5008	365	365130	Alejandra Sepulveda Orbenes	ALEJANDRA SEPÚLVEDA	M	f	AR	ALEJANDRA	SEPÚLVEDA
8967670	S	20	5008	375	375147	Carlos Geraldo Iturrieta Clobares	CARLOS ITURRIETA	M	f	AM	CARLOS	ITURRIETA
13301186	S	22	5008	365	365130	Pablo Dintrans Crivelli	PABLO DINTRANS	M	f	AR	PABLO	DINTRANS
12002235	S	23	5008	365	365006	Monica Valentina Gomez Lira	MÓNICA GÓMEZ	M	f	AR	MÓNICA	GÓMEZ
9093027	S	10	5010	357	357037	Sebastian Keitel Bianchi	SEBASTIÁN KEITEL	M	f	AA	SEBASTIÁN	KEITEL
15180251	S	11	5010	357	357037	Katherine Echaiz Thiele	KATHERINE ECHAIZ	M	t	AA	KATHERINE	ECHAIZ
15214077	S	14	5010	367	367157	Darwin Rodrigo Acuña Becerra	DARWIN ACUÑA	M	f	AB	DARWIN	ACUÑA
13104485	S	12	5010	357	357003	Enrique Van Rysselberghe Herrera	ENRIQUE VAN	M	f	AA	ENRIQUE 	VAN RYSSELBERGHE
7329851	S	13	5010	357	357003	Ivan Norambuena Farias	IVÁN NORAMBUENA	M	f	AA	IVÁN 	NORAMBUENA
9367729	S	15	5010	367	367157	Maria Angelica Ojeda Sanhueza	MARÍA OJEDA	M	f	AB	MARÍA ANGÉLICA	OJEDA
15880192	S	16	5010	367	367157	Sandra America Neira Espinoza	SANDRA NEIRA	M	f	AB	SANDRA	NEIRA
4516100	S	18	5010	370	370007	Jose Perez Arriagada	JOSÉ PÉREZ	M	f	AH	JOSÉ	PÉREZ
15627044	S	17	5010	367	367157	Roberto Alejandro Guzman Avendaño	ROBERTO GUZMÁN	M	f	AB	ROBERTO	GUZMÁN
6721463	S	20	5010	370	370005	Gaston Saavedra Chandia	GASTÓN SAAVEDRA	M	f	AH	GASTÓN 	SAAVEDRA
4657950	S	19	5010	370	370002	Jose Miguel Ortiz Novoa	JOSÉ ORTIZ	M	f	AH	JOSÉ MIGUEL	ORTIZ
16283458	S	21	5010	355	355142	Pablo Riveros Quiroz	PABLO RIVEROS	M	f	AL	PABLO	RIVEROS
14212633	S	23	5010	346	346144	Esteban Mario Arevalo Diaz	ESTEBAN AREVALO	M	t	AN	ESTEBAN	AREVALO
5548583	S	22	5010	375	375147	Zaida Rebeca Falces Salazar	ZAIDA FALCES	M	f	AM	ZAIDA	FALCES
16061808	S	24	5010	341	341162	Antaris Catalina Varela Compagnon	ANTARIS VARELA	M	f	AP	ANTARIS 	VARELA
13480831	S	25	5010	341	341162	Tamara Sephora Gonzalez Celis	TAMARA GONZÁLEZ	M	f	AP	TAMARA	GONZÁLEZ
8589205	S	26	5010	341	341162	Abraham Gonzalo Larrondo Vega	ABRAHAM LARRONDO	M	t	AP	ABRAHAM 	LARRONDO
13108967	S	27	5010	341	341162	Roberto Andres Francesconi Riquelme	ROBERTO FRANCESCONI	M	t	AP	ROBERTO	FRANCESCONI
15027975	S	29	5010	365	365149	Fabio Andres Bogdanic Molina	FABIO BOGDANIC	M	f	AR	FABIO	BOGDANIC
16080027	S	28	5010	365	365045	Daniela Dresdner Vicencio	DANIELA DRESDNER	M	f	AR	DANIELA	DRESDNER
14209834	S	31	5010	365	365130	Francisco Javier Cordova Echeverria	FRANCISCO CORDOVA	M	t	AR	FRANCISCO	CORDOVA
10304747	S	30	5010	365	365006	Oscar Mauricio Menares Hernandez	ÓSCAR MENARES	M	t	AR	ÓSCAR	MENARES
12973215	S	32	5010	349	349180	Angelica San Cristobal Silva	ANGÉLICA SAN	M	f	AW	ANGÉLICA	SAN CRISTOBAL
12927840	S	10	5012	357	357003	Ena Von Baer Jahn	ENA VON	M	f	AA	ENA 	VON BAER
8191414	S	11	5012	357	357037	Margot Cardenas Sandoval	MARGOT CÁRDENAS	M	f	AA	MARGOT 	CÁRDENAS
15333108	S	12	5012	357	357140	Pamela Christi Bolbaran Bolbaran	PAMELA BOLBARÁN	M	f	AA	PAMELA	BOLBARÁN
17177009	S	13	5012	357	357001	Maria Jose Gatica Bertin	MARÍA GATÍCA	M	f	AA	MARÍA JOSÉ	GATÍCA
8882009	S	17	5012	367	367157	Luis Mauricio Proboste Muñoz	LUIS PROBOSTE	M	f	AB	LUIS	PROBOSTE
6863790	S	14	5012	367	367157	Hilda Del Carmen Cerda Espindola	HILDA CERDA	M	f	AB	HILDA	CERDA
10836331	S	16	5012	367	367157	Gustavo Davila Sepulveda	GUSTAVO DÁVILA	M	f	AB	GUSTAVO	DÁVILA
11325188	S	15	5012	367	367157	Carmen Gloria Garate Silva	CARMEN GÁRATE	M	f	AB	CARMEN GLORIA	GÁRATE
9062945	S	18	5012	370	370005	Alfonso De Urresti Longton	ALFONSO DE	M	f	AH	ALFONSO	DE URRESTI
10412982	S	20	5012	370	370002	Sayonara Yañez Barria	SAYONARA YÁÑEZ	M	f	AH	SAYONARA	YÁÑEZ
12104153	S	19	5012	370	370005	Faumelisa Manquepillan Calfuleo	FAUMELISA MANQUEPILLÁN	M	t	AH	FAUMELISA 	MANQUEPILLÁN
6944574	S	21	5012	370	370002	Ivan Flores Garcia	IVÁN FLORES	M	f	AH	IVÁN 	FLORES
8612570	S	22	5012	365	365149	Monica Ines Quiroz Reyes	MÓNICA QUIROZ	M	t	AR	MÓNICA	QUIROZ
14054610	S	23	5012	365	365045	Roberto Giubergia Valderrama	ROBERTO GIUBERGIA	M	f	AR	ROBERTO	GIUBERGIA
12141166	S	24	5012	349	349148	Oscar Almazan Sepulveda	OSCAR ALMAZÁN	M	t	AW	OSCAR	ALMAZÁN
6364944	S	10	5013	357	357003	Ivan Moreira Barros	IVÁN MOREIRA	M	f	AA	IVÁN 	MOREIRA
10053111	S	12	5013	357	357001	Alejandro Santana Tirachini	ALEJANDRO SANTANA	M	f	AA	ALEJANDRO	SANTANA
7371986	S	11	5013	357	357003	Javier Hernandez Hernandez	JAVIER HERNÁNDEZ	M	f	AA	JAVIER	HERNÁNDEZ
6545536	S	13	5013	357	357001	Carlos Ignacio Kuschel Silva	CARLOS KUSCHEL	M	f	AA	CARLOS 	KUSCHEL
13524970	S	14	5013	367	367157	Cristian Arnoldo Alvarez Mansilla	CRISTIÁN ÁLVAREZ	M	f	AB	CRISTIÁN	ÁLVAREZ
13162747	S	16	5013	367	367157	Angelica Maria Henriquez Fernandez	ANGÉLICA HENRÍQUEZ	M	f	AB	ANGÉLICA	HENRÍQUEZ
16236408	S	15	5013	367	367157	Carolina Silvana Figueroa Olave	CAROLINA FIGUEROA	M	f	AB	CAROLINA	FIGUEROA
12935174	S	17	5013	367	367157	Christian Angel Mauricio Cid Barahona	CHRISTIAN CID	M	f	AB	CHRISTIAN	CID
13163646	S	20	5013	370	370002	Pamela Soledad Bertin Hernandez	PAMELA BERTÍN	M	f	AH	PAMELA	BERTÍN
4423698	S	18	5013	370	370005	Rabindranath Quinteros Lara	RABINDRANATH QUINTEROS	M	f	AH	RABINDRANATH	QUINTEROS
11690256	S	19	5013	370	370005	Fidel Espinoza Sandoval	FIDEL ESPINOZA	M	f	AH	FIDEL	ESPINOZA
14431713	S	23	5013	365	365143	Orietta Eliana Llauca Huala	ORIETTA LLAUCA	M	t	AR	ORIETTA	LLAUCA
10995136	S	21	5013	370	370137	Jorge Bruno Keim Gutierrez	JORGE KEIM	M	f	AH	JORGE	KEIM
14161119	S	22	5013	355	355142	Mauricio Martinez Hurtado	MAURICIO MARTÍNEZ	M	f	AL	MAURICIO	MARTÍNEZ
11677215	S	25	5013	365	365006	Paola Alejandra Venegas Arriagada	PAOLA VENEGAS	M	f	AR	PAOLA 	VENEGAS
7478684	S	24	5013	365	365045	Fernanda Hederra Williams	FERNANDA HEDERRA	M	f	AR	FERNANDA	HEDERRA
14395253	S	26	5013	349	349180	Natalia Ravanales Toro	NATALIA RAVANALES	M	t	AW	NATALIA	RAVANALES
8815055	S	27	5013	349	349148	Fabiola Moya Sandoval	FABIOLA MOYA	M	t	AW	FABIOLA	MOYA
8731784	S	10	5015	357	357140	Juan Jose Claudio Arcos Srdanovic	JUAN ARCOS	M	f	AA	JUAN JOSÉ	ARCOS
8070391	S	12	5015	357	357001	Alejandro Juan Kusanovic Glusevic	ALEJANDRO KUSANOVIC	M	t	AA	ALEJANDRO	KUSANOVIC
7164804	S	11	5015	357	357003	Sandra Amar Mancilla	SANDRA AMAR	M	t	AA	SANDRA 	AMAR
16363358	S	14	5015	367	367157	Carla Daniela Amthauer Gonzalez	CARLA AMTHAUER	M	f	AB	CARLA	AMTHAUER
15077705	S	13	5015	367	367157	Jesus Rodrigo Gutierrez Olivares	JESÚS GUTIÉRREZ	M	f	AB	JESÚS	GUTIÉRREZ
15580500	S	16	5015	370	370005	Maria De Los Angeles Flores Rodriguez	MARÍA FLORES	M	f	AH	MARÍA DE LOS ÁNGELES	FLORES
8591405	S	17	5015	346	346008	Juan Del Karano Marquez Borquez	JUAN MÁRQUEZ	M	t	AN	JUAN	MÁRQUEZ
8749581	S	15	5015	370	370002	Ninen Gomez Villegas	NINEN GÓMEZ	M	f	AH	NINEN	GÓMEZ
15308604	S	20	5015	999	99	Karim Antonio Bianchi Retamales	KARIM BIANCHI	M	t	ZZZ	KARIM	BIANCHI
7406584	S	19	5015	365	365149	Julio Gaston Contreras Muñoz	JULIO CONTRERAS	M	t	AR	JULIO	CONTRERAS
15719554	S	18	5015	365	365149	Luz Andrea Bermudez Sandoval	LUZ BERMÚDEZ	M	f	AR	LUZ	BERMÚDEZ
8832758	S	10	5016	357	357003	Jacqueline Van Rysselberghe Herrera	JACQUELINE VAN	M	f	AA	JACQUELINE	VAN RYSSELBERGHE
9178953	S	12	5016	357	357140	Victoria Ortiz Vera	VICTORIA ORTIZ	M	f	AA	VICTORIA	ORTIZ
10438745	S	11	5016	357	357003	Gustavo Adolfo Sanhueza Dueñas	GUSTAVO SANHUEZA	M	f	AA	GUSTAVO	SANHUEZA
12322677	S	15	5016	370	370004	Loreto Carvajal Ambiado	LORETO CARVAJAL	M	f	AH	LORETO	CARVAJAL
15211533	S	14	5016	367	367157	Katherine Rupertina Quilodran Parra	KATHERINE QUILODRÁN	M	f	AB	KATHERINE	QUILODRÁN
13306878	S	13	5016	367	367157	David Keller Freeman	DAVID KELLER	M	f	AB	DAVID	KELLER
11177626	S	17	5016	355	355142	Juan Manuel Rivas Garrido	JUAN RIVAS	M	f	AL	JUAN MANUEL	RIVAS
8103992	S	16	5016	370	370002	Jorge Sabag Villalobos	JORGE SABAG	M	f	AH	JORGE	SABAG
6149774	S	19	5016	346	346144	Samuel Abelardo Jimenez Moraga	SAMUEL JIMÉNEZ	M	t	AN	SAMUEL	JIMÉNEZ
11286248	S	18	5016	355	355142	Eliana Sanhueza Ortiz	ELIANA SANHUEZA	M	f	AL	ELIANA	SANHUEZA
11957437	S	20	5016	365	365006	Cecilia Del Pilar Palacios Leiva	CECILIA PALACIOS	M	f	AR	CECILIA	PALACIOS
9640394	D	63	6001	358	358140	Enrique Lee Flores	ENRIQUE LEE	M	t	AA	ENRIQUE	LEE
15695074	D	66	6001	368	368157	Gonzalo Daniel Campusano Yañez	GONZALO CAMPUSANO	M	f	AB	GONZALO 	CAMPUSANO
17557205	D	65	6001	368	368157	Camila Fernanda Aguilar Torres	CAMILA AGUILAR	M	f	AB	CAMILA 	AGUILAR
17557048	D	62	6001	358	358001	Diego Paco Mamani	DIEGO PACO	M	f	AA	DIEGO	PACO
6419182	D	60	6001	358	358003	Nino Baltolu Rasera	NINO BALTOLU	M	f	AA	NINO	BALTOLU
15636750	D	61	6001	358	358037	Diego Bulnes Valdes	DIEGO BULNES	M	t	AA	DIEGO	BULNES
9314005	D	64	6001	368	368157	Rayko Alejandro Karmelic Pavlov	RAYKO KARMELIC	M	f	AB	RAYKO 	KARMELIC
16469739	D	70	6001	371	371137	Vlado Mirosevic Verdugo	VLADO MIROSEVIC	M	f	AH	VLADO	MIROSEVIC
12437980	D	67	6001	368	368157	Benedicta Isabel Rodriguez Rubio	BENEDICTA RODRÍGUEZ	M	f	AB	BENEDICTA 	RODRÍGUEZ
18239895	D	69	6001	364	364135	Valentina Paz Albarracin Gonzalez	VALENTINA ALBARRACÍN	M	f	AE	VALENTINA 	ALBARRACÍN
18011753	D	71	6001	371	371137	Luis Fabian Malla Valenzuela	LUIS MALLA	M	f	AH	LUIS 	MALLA
16770265	D	68	6001	364	364135	Camilo Martin Jofre Cañipa	CAMILO JOFRÉ	M	f	AE	CAMILO 	JOFRÉ
7901686	D	72	6001	371	371005	Luis Rocafull Lopez	LUIS ROCAFULL	M	f	AH	LUIS	ROCAFULL
10061982	D	74	6001	347	347008	Juan Jacobo Tancara Chambe	JUAN TANCARA	M	t	AN	JUAN 	TANCARA
9296561	D	78	6001	339	339150	Fidel Oscar Arenas Pizarro	FIDEL ARENAS	M	t	AP	FIDEL 	ARENAS
12909953	D	73	6001	371	371005	Gladys Acuña Rosales	GLADYS ACUÑA	M	f	AH	GLADYS	ACUÑA
19494783	D	81	6001	366	366006	Paloma Camila Margott Tapia Barrios	PALOMA TAPIA	M	f	AR	PALOMA 	TAPIA
9004071	D	76	6001	339	339150	Marcelo Andres Zara Pizarro	MARCELO ZARA	M	f	AP	MARCELO	ZARA
10178966	D	75	6001	347	347008	Delia Norma Condori Flores	DELIA CONDORI	M	t	AN	DELIA 	CONDORI
13072258	D	79	6001	366	366130	Ricardo Sanzana Oteiza	RICARDO SANZANA	M	f	AR	RICARDO	SANZANA
12448356	D	77	6001	339	339150	Karla Kepec Alvarez	KARLA KEPEC	M	f	AP	KARLA	KEPEC
15020078	D	80	6001	366	366143	Silvia Jocelyn Muñoz Donoso	SILVIA MUÑOZ	M	t	AR	SILVIA	MUÑOZ
17830355	D	82	6001	354	354126	Fabian Andres Aburto Aburto	FABIÁN ABURTO	M	f	AT	FABIÁN 	ABURTO
10519530	D	61	6002	358	358140	Erica Paniagua Herbas	ERICA PANIAGUA	M	t	AA	ERICA	PANIAGUA
15004297	D	65	6002	368	368157	Mario Hernan Rojas Carrasco	MARIO ROJAS	M	f	AB	MARIO 	ROJAS
13054280	D	60	6002	358	358003	Renzo Trisotti Martinez	RENZO TRISOTTI	M	f	AA	RENZO 	TRISOTTI
6720037	D	64	6002	368	368157	Carlos Alberto Mella Latorre	CARLOS MELLA	M	f	AB	CARLOS	MELLA
10807546	D	67	6002	371	371004	Marco Perez Barria	MARCO PÉREZ	M	t	AH	MARCO	PÉREZ
12231941	D	62	6002	358	358037	Karen Rose Heyne Bolados	KAREN HEYNE	M	t	AA	KAREN	HEYNE
6621973	D	63	6002	358	358001	Ramon Ernesto Galleguillos Castillo	RAMÓN GALLEGUILLOS	M	f	AA	RAMÓN	GALLEGUILLOS
15098956	D	66	6002	368	368157	Denisse Carolina Gallegos Castro	DENISSE GALLEGOS	M	f	AB	DENISSE	GALLEGOS
10620531	D	68	6002	371	371005	Danisa Astudillo Peiretti	DANISA ASTUDILLO	M	f	AH	DANISA 	ASTUDILLO
6376104	D	71	6002	347	347008	Luis Felipe Garcia Merino	LUIS GARCÍA	M	f	AN	LUIS 	GARCÍA
7002375	D	69	6002	371	371002	Eva Teresa Portales Piñones	EVA PORTALES	M	f	AH	EVA	PORTALES
13215210	D	70	6002	347	347008	Carolina Ines Gonzalez Velasquez	CAROLINA GONZALEZ	M	f	AN	CAROLINA 	GONZALEZ
12611978	D	75	6002	339	339150	Cynthia Leslie Karen Broudissond Araya	CYNTHIA BROUDISSOND	M	t	AP	CYNTHIA 	BROUDISSOND
7403940	D	73	6002	339	339150	Carlos Alfonso Arellano Gajardo	CARLOS ARELLANO	M	f	AP	CARLOS 	ARELLANO
4842153	D	72	6002	339	339150	Leonardo Dante Solari Alcota	LEONARDO SOLARI	M	f	AP	LEONARDO 	SOLARI
15918264	D	76	6002	366	366006	Matias Felipe Ramirez Pascal	MATÍAS RAMIREZ	M	f	AR	MATÍAS 	RAMIREZ
15010258	D	78	6002	366	366130	Enzo Morales Norambuena	ENZO MORALES	M	t	AR	ENZO	MORALES
5328145	D	74	6002	339	339150	Minerva Beatriz Campodonico Saluzzi	MINERVA CAMPODONICO	M	f	AP	MINERVA	CAMPODONICO
17431037	D	79	6002	366	366045	Camila Paz Castillo Guerrero	CAMILA CASTILLO	M	f	AR	CAMILA 	CASTILLO
16593650	D	77	6002	366	366143	Alejandra Marjorie Ceballos Rojas	ALEJANDRA CEBALLOS	M	f	AR	ALEJANDRA 	CEBALLOS
12613570	D	80	6002	354	354126	Janet Violeta Ordenes Guerra	JANET ORDENES	M	f	AT	JANET 	ORDENES
7278079	D	63	6003	358	358003	Luis Garrido Ampuero	LUIS GARRIDO	M	f	AA	LUIS 	GARRIDO
10338907	D	60	6003	358	358001	Jose Miguel Castro Bascuñan	JOSÉ CASTRO	M	f	AA	JOSÉ MIGUEL	CASTRO
12441471	D	66	6003	368	368157	Yovana Alejandra Ahumada Palma	YOVANA AHUMADA	M	f	AB	YOVANA 	AHUMADA
9049603	D	62	6003	358	358003	Rossana Diaz Corro	ROSSANA DÍAZ	M	f	AA	ROSSANA 	DÍAZ
16686826	D	71	6003	364	364135	Lester Patricio Calderon Hernandez	LESTER CALDERÓN	M	f	AE	LESTER 	CALDERÓN
13931593	D	68	6003	368	368157	Cesar Antonio Rojas Toro	CÉSAR ROJAS	M	f	AB	CÉSAR	ROJAS
14110304	D	64	6003	358	358037	Yantiel Calderon Valenzuela	YANTIEL CALDERÓN	M	f	AA	YANTIEL	CALDERÓN
10780945	D	61	6003	358	358001	Ledy Osandon Ferrer	LEDY OSANDÓN	M	t	AA	LEDY	OSANDÓN
8328014	D	65	6003	358	358037	Sacha Razmilic Burgos	SACHA RAZMILIC	M	f	AA	SACHA	RAZMILIC
17645363	D	72	6003	364	364135	Karla Jacqueline Peralta Diaz	KARLA PERALTA	M	f	AE	KARLA	PERALTA
16439068	D	69	6003	368	368157	Yerko Alexis Cortes Rojas	YERKO CORTÉS	M	f	AB	YERKO	CORTÉS
16979319	D	74	6003	364	364135	Nathaly Paz Flores Torres	NATHALY FLORES	M	f	AE	NATHALY 	FLORES
16245265	D	80	6003	371	371137	Sebastian Patricio Videla Castillo	SEBASTIÁN VIDELA	M	t	AH	SEBASTIÁN	VIDELA
17074825	D	67	6003	368	368157	Nargaret Viki Cristi Cariaga	NARGARET CRISTI	M	f	AB	NARGARET 	CRISTI
19205170	D	83	6003	347	347144	Yesebel Castillo Paniagua	YESEBEL CASTILLO	M	f	AN	YESEBEL	CASTILLO
21871828	D	73	6003	364	364135	Daniel Andres Vargas Downing	DANIEL VARGAS	M	f	AE	DANIEL 	VARGAS
13014018	D	81	6003	371	371004	Jaime Araya Guerrero	JAIME ARAYA	M	t	AH	JAIME	ARAYA
10930274	D	78	6003	371	371138	Celie Renee Araya Escobar	CELIE ARAYA	M	t	AH	CELIE 	ARAYA
16514519	D	70	6003	368	368157	Omar Paul Heiner Reese Erices	OMAR REESE	M	f	AB	OMAR 	REESE
17514520	D	76	6003	364	364135	Daniela Beatriz Aviles Honores	DANIELA AVILÉS	M	f	AE	DANIELA	AVILÉS
15501356	D	82	6003	371	371005	Paula Nievas Silva	PAULA NIEVAS	M	f	AH	PAULA	NIEVAS
6251099	D	79	6003	371	371002	Arturo Molina Henriquez	ARTURO MOLINA	M	f	AH	ARTURO	MOLINA
11817970	D	88	6003	339	339150	Marcela Ruz Andrade	MARCELA RUZ	M	f	AP	MARCELA	RUZ
10660046	D	77	6003	371	371007	Claudia Marcela Ardiles Tagle	CLAUDIA ARDILES	M	f	AH	CLAUDIA 	ARDILES
18160005	D	94	6003	366	366045	Catalina Perez Salinas	CATALINA PÉREZ	M	f	AR	CATALINA	PÉREZ
17435280	D	75	6003	364	364135	Nestor Luis Vera Rojas	NESTOR VERA	M	f	AE	NESTOR 	VERA
18580499	D	85	6003	347	347144	Nayarit Arteaga Valenzuela	NAYARIT ARTEAGA	M	t	AN	NAYARIT	ARTEAGA
17092315	D	84	6003	347	347144	Sergio Luis Cubillos Verasay	SERGIO CUBILLOS	M	t	AN	SERGIO 	CUBILLOS
7190992	D	87	6003	347	347008	Eliana De Lourdes Rojas Bugueño	ELIANA ROJAS	M	f	AN	ELIANA	ROJAS
9932817	D	90	6003	339	339150	Rita Maria Hojas Escrich	RITA HOJAS	M	f	AP	RITA	HOJAS
10977786	D	86	6003	347	347008	Pedro Luis Luque Arancibia	PEDRO LUQUE	M	f	AN	PEDRO 	LUQUE
7311718	D	89	6003	339	339150	Vittorio Valdes Coron	VITTORIO VALDÉS	M	f	AP	VITTORIO	VALDÉS
13660977	D	93	6003	339	339150	Rogelia Francisca Contreras Lijeron	ROGELIA CONTRERAS	M	t	AP	ROGELIA 	CONTRERAS
17017995	D	99	6003	366	366006	Pablo Andres Iriarte Ramirez	PABLO IRIARTE	M	f	AR	PABLO 	IRIARTE
12170419	D	96	6003	366	366130	Jacqueline Avila Vilca	JACQUELINE AVILA	M	f	AR	JACQUELINE	AVILA
16635731	D	92	6003	339	339150	Macarena Alejandra Pizarro Villarroel	MACARENA PIZARRO	M	t	AP	MACARENA 	PIZARRO
18482209	D	106	6003	350	350180	Felipe Ignacio Araya Perez	FELIPE ARAYA	M	t	AW	FELIPE 	ARAYA
16051237	D	97	6003	366	366130	Fernando San Roman Bascuñan	FERNANDO SAN	M	t	AR	FERNANDO	SAN ROMÁN
14442820	D	95	6003	366	366045	Vianney Paola Sierralta Aracena	VIANNEY SIERRALTA	M	t	AR	VIANNEY	SIERRALTA
15679406	D	91	6003	339	339150	Rosse-mary Rand Contreras	ROSSE-MARY RAND	M	f	AP	ROSSE-MARY	RAND
8617816	D	102	6003	354	354126	Hugo Orlando Morales Silva	HUGO MORALES	M	f	AT	HUGO 	MORALES
9322802	D	105	6003	350	350180	Osvaldo Francisco Sotgiu Quijada	OSVALDO SOTGIU	M	t	AW	OSVALDO 	SOTGIU
7134567	D	98	6003	366	366006	Maria Angelica Ojeda Gonzalez	MARÍA OJEDA	M	f	AR	MARÍA ANGÉLICA	OJEDA
14409465	D	103	6003	350	350180	Zarina Edelmira Guaman Osorio	ZARINA GUAMÁN	M	f	AW	ZARINA 	GUAMÁN
13417434	D	109	6003	373	373139	Janett Shirley Guerra Aburto	JANETT GUERRA	M	f	AY	JANETT 	GUERRA
10817030	D	101	6003	354	354126	Elia Jacqueline Romero Olave	ELIA ROMERO	M	f	AT	ELIA 	ROMERO
14601084	D	104	6003	350	350180	Mariela Alejandra Quispe Sanchez	MARIELA QUISPE	M	f	AW	MARIELA	QUISPE
15616802	D	107	6003	350	350180	Javier Claudio David Oliva Bermedo	JAVIER OLIVA	M	t	AW	JAVIER	OLIVA
18144686	D	100	6003	354	354126	Juan Paulo Basterrechea Madrid	JUAN BASTERRECHEA	M	f	AT	JUAN PAULO	BASTERRECHEA
19101657	D	108	6003	350	350180	Francisco Daniel Gallardo Cortes	FRANCISCO GALLARDO	M	t	AW	FRANCISCO 	GALLARDO
11846940	D	60	6004	358	358001	Sofia Slovena Cid Versalovic	SOFÍA CID	M	f	AA	SOFÍA	CID
11724580	D	61	6004	358	358001	Raul Gonzalo Ardiles Ramirez	RAÚL ARDILES	M	f	AA	RAÚL	ARDILES
10368027	D	62	6004	358	358140	Manuel Alejandro Corrales Gonzalez	MANUEL CORRALES	M	f	AA	MANUEL	CORRALES
17865680	D	70	6004	368	368157	Jean Pierre Varas Delgado	JEAN VARAS	M	f	AB	JEAN PIERRE	VARAS
14114562	D	64	6004	358	358003	Carla Guaita Carrizo	CARLA GUAITA	M	t	AA	CARLA	GUAITA
15372905	D	68	6004	368	368157	Cristian Mauricio Custa Sapiains	CRISTIÁN CUSTA	M	f	AB	CRISTIÁN 	CUSTA
13532545	D	63	6004	358	358140	Carolina Gonzalez Hernandez	CAROLINA GONZÁLEZ	M	t	AA	CAROLINA	GONZÁLEZ
12171037	D	69	6004	368	368157	Alex Farias Perez	ALEX FARÍAS	M	f	AB	ALEX 	FARÍAS
15601091	D	66	6004	368	368157	Paula Andrea Olmos Contreras	PAULA OLMOS	M	f	AB	PAULA 	OLMOS
14168814	D	65	6004	358	358003	Nicolas Noman Garrido	NICOLAS NOMAN	M	f	AA	NICOLAS 	NOMAN
16822100	D	71	6004	371	371005	Daniella Cicardini Milla	DANIELLA CICARDINI	M	f	AH	DANIELLA	CICARDINI
11465358	D	76	6004	356	356142	Pamela Vargas Toledo	PAMELA VARGAS	M	f	AL	PAMELA	VARGAS
14376099	D	74	6004	371	371007	Cesar Esteban Gonzalez Pizarro	CÉSAR GONZÁLEZ	M	f	AH	CÉSAR 	GONZÁLEZ
10186178	D	73	6004	371	371004	Cristian Hernando Tapia Ramos	CRISTIAN TAPIA	M	t	AH	CRISTIAN 	TAPIA
7793537	D	67	6004	368	368157	Nilsa Elcira Guzman Palma	NILSA GUZMÁN	M	f	AB	NILSA 	GUZMÁN
10951712	D	75	6004	371	371002	Gabriela Del Carmen Mancilla Mateluna	GABRIELA MANCILLA	M	f	AH	GABRIELA	MANCILLA
12232211	D	77	6004	356	356142	Rodrigo Perez Lisicic	RODRIGO PÉREZ	M	f	AL	RODRIGO 	PÉREZ
17330700	D	72	6004	371	371005	Juan Santana Castillo	JUAN SANTANA	M	f	AH	JUAN	SANTANA
9303854	D	83	6004	347	347144	Mauricio David Rios Navarrete	MAURICIO RÍOS	M	t	AN	MAURICIO	RÍOS
9893814	D	79	6004	356	356142	Joel Moya Morales	JOEL MOYA	M	f	AL	JOEL	MOYA
6202686	D	78	6004	356	356142	Marta Frez Avila	MARTA FREZ	M	f	AL	MARTA 	FREZ
15385490	D	80	6004	356	356142	Jacqueline Quintana Muñoz	JACQUELINE QUINTANA	M	f	AL	JACQUELINE 	QUINTANA
9060894	D	81	6004	347	347144	Luis Alberto Acuña Castillo	LUIS ACUÑA	M	f	AN	LUIS 	ACUÑA
15020606	D	85	6004	347	347008	Odel David Soto Shee	ODEL SOTO	M	f	AN	ODEL	SOTO
17773581	D	82	6004	347	347144	Mariana Andrea Piñones Hidalgo	MARIANA PIÑONES	M	t	AN	MARIANA 	PIÑONES
9144349	D	86	6004	339	339150	Juan Francisco Fritis Carrizo	JUAN FRITIS	M	f	AP	JUAN FRANCISCO	FRITIS
16012876	D	90	6004	339	339150	Gonzalo Heriberto Tamblay Tapia	GONZALO TAMBLAY	M	t	AP	GONZALO	TAMBLAY
17400301	D	84	6004	347	347008	Yenifer Alejandra Carrasco Torres	YENIFER CARRASCO	M	f	AN	YENIFER 	CARRASCO
15440695	D	88	6004	339	339150	Jonathan Gomez Rojas	JONATHAN GÓMEZ	M	f	AP	JONATHAN	GÓMEZ
18140258	D	95	6004	366	366006	Makarena Isabel Arias Vargas	MAKARENA ARIAS	M	f	AR	MAKARENA 	ARIAS
6846260	D	87	6004	339	339150	Dalva De Los Angeles Cepeda Castro	DALVA CEPEDA	M	f	AP	DALVA 	CEPEDA
7134978	D	91	6004	339	339150	Fresia Maria Sepulveda Hanckes	FRESIA SEPÚLVEDA	M	f	AP	FRESIA	SEPÚLVEDA
12485821	D	93	6004	366	366130	Luis Marcos Perez	LUIS MARCOS	M	f	AR	LUIS 	MARCOS
15033627	D	89	6004	339	339150	Enrique Alexander Almeida Mercado	ENRIQUE ALMEIDA	M	f	AP	ENRIQUE	ALMEIDA
14493756	D	97	6004	366	366143	Nathalie Andrea Mery Ceriche	NATHALIE MERY	M	f	AR	NATHALIE 	MERY
5892999	D	94	6004	366	366006	Lautaro Cesar Carmona Soto	LAUTARO CARMONA	M	f	AR	LAUTARO 	CARMONA
15029251	D	96	6004	366	366143	Inti Eleodoro Salamanca Fernandez	INTI SALAMANCA	M	f	AR	INTI 	SALAMANCA
16559680	D	98	6004	999	99	Sebastian Vicente Carmona Orquera	SEBASTIÁN CARMONA	M	t	ZZZ	SEBASTIÁN	CARMONA
9020696	D	92	6004	366	366130	Jaime Mulet Martinez	JAIME MULET	M	f	AR	JAIME	MULET
9494837	D	60	6005	358	358003	Juan Manuel Fuenzalida Cobo	JUAN FUENZALIDA	M	f	AA	JUAN MANUEL	FUENZALIDA
12633495	D	62	6005	358	358003	Andrea Guzman Herrera	ANDREA GUZMÁN	M	t	AA	ANDREA	GUZMÁN
9940999	D	61	6005	358	358003	Marco Antonio Sulantay Olivares	MARCO SULANTAY	M	f	AA	MARCO ANTONIO	SULANTAY
9292635	D	63	6005	358	358003	Victor Hugo Castañeda Vargas	VÍCTOR CASTAÑEDA	M	t	AA	VÍCTOR HUGO	CASTAÑEDA
16134963	D	64	6005	358	358001	Vinka Estefania Pusich Camacho	VINKA PUSICH	M	f	AA	VINKA	PUSICH
14121438	D	66	6005	358	358001	Gonzalo Andres Chacon Larrain	GONZALO CHACÓN	M	f	AA	GONZALO 	CHACÓN
10902559	D	65	6005	358	358001	Francisco De Borja Eguiguren Correa	FRANCISCO EGUIGUREN	M	f	AA	FRANCISCO	EGUIGUREN
7310546	D	78	6005	371	371004	Rodrigo Bravo Valenzuela	RODRIGO BRAVO	M	t	AH	RODRIGO	BRAVO
7007065	D	67	6005	358	358001	Eugenio Samuel Darrigrande Pizarro	EUGENIO DARRIGRANDE	M	t	AA	EUGENIO	DARRIGRANDE
13874804	D	69	6005	368	368157	Ingrid Patricia Marin Ramos	INGRID MARÍN	M	f	AB	INGRID 	MARÍN
20085106	D	75	6005	371	371005	Daniel Manouchehri Moghadam Kashan Lobos	DANIEL MANOUCHEHRI	M	f	AH	DANIEL	MANOUCHEHRI 
19996787	D	79	6005	371	371004	Maria Paz Rojas Orrego	MARÍA ROJAS	M	t	AH	MARÍA PAZ	ROJAS
15573354	D	77	6005	371	371007	Alonso Alejandro Muñoz Perez	ALONSO MUÑOZ	M	t	AH	ALONSO 	MUÑOZ
13745438	D	76	6005	371	371007	Gabriela Calderon Alvarez	GABRIELA CALDERÓN	M	t	AH	GABRIELA	CALDERÓN
12861552	D	68	6005	368	368157	Victor Alejandro Pino Fuentes	VÍCTOR PINO	M	f	AB	VÍCTOR 	PINO
9195802	D	72	6005	371	371002	Ricardo Cifuentes Lillo	RICARDO CIFUENTES	M	f	AH	RICARDO	CIFUENTES
13875591	D	71	6005	368	368157	Carolina Andrea Downey Diaz	CAROLINA DOWNEY	M	f	AB	CAROLINA 	DOWNEY
20343982	D	82	6005	356	356142	Daniel Leiva Coronel	DANIEL LEIVA	M	f	AL	DANIEL 	LEIVA
14116678	D	73	6005	371	371002	Pablo Yañez Pizarro	PABLO YÁÑEZ	M	f	AH	PABLO	YÁÑEZ
16109769	D	70	6005	368	368157	Marjorie Lissette Araya Robles	MARJORIE ARAYA	M	f	AB	MARJORIE 	ARAYA
14258290	D	84	6005	356	356142	Bridit Ulloa Espinoza	BRIDIT ULLOA	M	f	AL	BRIDIT 	ULLOA
4773834	D	86	6005	347	347008	Gonzalo Felipe Garcia-huidobro Severin	GONZALO GARCÍA-HUIDOBRO	M	f	AN	GONZALO 	GARCÍA-HUIDOBRO
12770738	D	85	6005	347	347008	Susana Carmen Lopez Delgado	SUSANA LÓPEZ	M	t	AN	SUSANA 	LÓPEZ
10773652	D	81	6005	356	356142	Claudia Valenzuela Torres	CLAUDIA VALENZUELA	M	f	AL	CLAUDIA 	VALENZUELA
13970725	D	83	6005	356	356142	Carolina Martinez Santelices	CAROLINA MARTÍNEZ	M	f	AL	CAROLINA 	MARTÍNEZ
8780639	D	74	6005	371	371005	Clara Olivares Araya	CLARA OLIVARES	M	f	AH	CLARA	OLIVARES
8673867	D	80	6005	356	356142	Tirso Gonzalez Alquinta	TIRSO GONZÁLEZ	M	f	AL	TIRSO	GONZÁLEZ
17934346	D	88	6005	347	347144	Juan Alejandro Tirado Barrera	JUAN TIRADO	M	t	AN	JUAN 	TIRADO
13330031	D	92	6005	339	339150	Andres Eduardo Guerra Vega	ANDRÉS GUERRA	M	f	AP	ANDRÉS 	GUERRA
12598383	D	107	6005	350	350180	Alejandra Ester Muñoz Orellana	ALEJANDRA MUÑOZ	M	t	AW	ALEJANDRA 	MUÑOZ
12618980	D	89	6005	347	347144	Susana Maribel Ponce Mollo	SUSANA PONCE	M	t	AN	SUSANA 	PONCE
16773450	D	87	6005	347	347144	Pilar Nuñez Segovia	PILAR NÚÑEZ	M	f	AN	PILAR	NÚÑEZ
15028161	D	98	6005	366	366006	Nathalie Castillo Rojas	NATHALIE CASTILLO	M	f	AR	NATHALIE	CASTILLO
13249805	D	110	6005	350	350180	Cristopher Enrique Suazo Benavides	CRISTOPHER SUAZO	M	t	AW	CRISTOPHER	SUAZO
16007506	D	99	6005	366	366006	Carolina Tello Rojas	CAROLINA TELLO	M	f	AR	CAROLINA 	TELLO
13424205	D	90	6005	347	347144	Cristian Eduardo Monreal Cortes	CRISTIAN MONREAL	M	t	AN	CRISTIAN	MONREAL
13873412	D	103	6005	366	366143	Jocelyn Alejandra Burgos Flores	JOCELYN BURGOS	M	f	AR	JOCELYN	BURGOS
15671463	D	96	6005	339	339150	David Eduardo Wellmann Bustamante	DAVID WELLMANN	M	t	AP	DAVID 	WELLMANN
13320933	D	95	6005	339	339150	Ronald Esteban Brandt Silva	RONALD BRANDT	M	t	AP	RONALD 	BRANDT
18494097	D	100	6005	366	366149	Felipe Javier Carcamo Moreno	FELIPE CARCAMO	M	f	AR	FELIPE 	CARCAMO
13026201	D	108	6005	350	350180	Beatrice Irina Onfray Lecrec	BEATRICE ONFRAY	M	f	AW	BEATRICE 	ONFRAY
10627970	D	111	6005	350	350180	Rene Vicente Romero Pasten	RENÉ ROMERO	M	t	AW	RENÉ	ROMERO
12066403	D	93	6005	339	339150	Myriam Benitez Jofre	MYRIAM BENÍTEZ	M	f	AP	MYRIAM	BENÍTEZ
11939942	D	101	6005	366	366149	Claudia Patricia Avalos Roblero	CLAUDIA ÁVALOS	M	t	AR	CLAUDIA 	ÁVALOS
12424741	D	105	6005	366	366130	Ricardo Vitaly Ledezma Jimenez	RICARDO LEDEZMA	M	t	AR	RICARDO	LEDEZMA
14244816	D	94	6005	339	339150	Erika Thamara Puga Soto	ERIKA PUGA	M	f	AP	ERIKA 	PUGA
7539810	D	97	6005	339	339150	Christian Leopoldo Aguirre Basulto	CHRISTIAN AGUIRRE	M	t	AP	CHRISTIAN 	AGUIRRE
10269062	D	106	6005	350	350180	Maria Loreto Retamal Grimberg	MARÍA RETAMAL	M	f	AW	MARÍA LORETO	RETAMAL
18003809	D	91	6005	347	347144	Francisco Nicolas Jaime Rojas	FRANCISCO JAIME	M	t	AN	FRANCISCO 	JAIME
13424298	D	102	6005	366	366143	Alex Fernando Garrido Tapia	ALEX GARRIDO	M	f	AR	ALEX 	GARRIDO
10538930	D	113	6005	373	373139	Tamara Casado Vergara	TAMARA CASADO	M	f	AY	TAMARA	CASADO
15595996	D	109	6005	350	350180	Maximo Rodrigo Lemus Olivares	MÁXIMO LEMUS	M	t	AW	MÁXIMO 	LEMUS
9288943	D	104	6005	366	366130	Carlos Thenoux Ciudad	CARLOS THENOUX	M	t	AR	CARLOS	THENOUX
9908587	D	112	6005	350	350180	Fanny Carolina Keyer Quiroz	FANNY KEYER	M	t	AW	FANNY 	KEYER
18553904	D	74	6006	368	368157	Gabriela Andrea Alvarez Diaz	GABRIELA ÁLVAREZ	M	f	AB	GABRIELA 	ÁLVAREZ
6072593	D	83	6006	371	371005	Luciano Valle Acevedo	LUCIANO VALLE	M	f	AH	LUCIANO	VALLE
16541201	D	61	6006	358	358001	Camila Alejandra Flores Oporto	CAMILA FLORES	M	f	AA	CAMILA	FLORES
8274464	D	65	6006	358	358003	Maria Ester Munnier Soto	MARIA MUNNIER	M	f	AA	MARIA ESTER	MUNNIER
12041194	D	75	6006	368	368157	Mauricio Rene Oyarce Vera	MAURICIO OYARCE	M	f	AB	MAURICIO 	OYARCE
19956065	D	77	6006	368	368157	Macarena Fabiola Becker Gonzalez	MACARENA BECKER	M	f	AB	MACARENA 	BECKER
13033669	D	70	6006	368	368157	Katherine Muriel Alarcon Giadach	KATHERINE ALARCÓN	M	f	AB	KATHERINE 	ALARCÓN
15097247	D	62	6006	358	358001	Andres Longton Herrera	ANDRÉS LONGTON	M	f	AA	ANDRÉS	LONGTON
13454377	D	69	6006	368	368157	Gaspar Alberto Rivas Sanchez	GASPAR RIVAS	M	f	AB	GASPAR	RIVAS
10372480	D	72	6006	368	368157	Claudio Francisco Rivas Carrasco	CLAUDIO RIVAS	M	f	AB	CLAUDIO 	RIVAS
10397623	D	63	6006	358	358001	Maria Violeta Silva Cajas	MARÍA SILVA	M	t	AA	MARÍA VIOLETA	SILVA
15754100	D	67	6006	358	358003	Raul Fuhrer Sanchez	RAÚL FUHRER	M	f	AA	RAÚL 	FUHRER
8589031	D	78	6006	364	364135	Ewald Enrique Meyer Monsalve	EWALD MEYER	M	f	AE	EWALD 	MEYER
17599473	D	64	6006	358	358003	Benjamin Lorca Inzunza	BENJAMÍN LORCA	M	t	AA	BENJAMÍN	LORCA
15782102	D	68	6006	358	358003	Tomas Hoffmann Opazo	TOMÁS HOFFMANN	M	f	AA	TOMÁS	HOFFMANN
16677617	D	71	6006	368	368157	Daniela Francisca Villarroel Muñoz	DANIELA VILLARROEL	M	f	AB	DANIELA 	VILLARROEL
12847460	D	66	6006	358	358003	Luis Eduardo Cantellano Ampuero	LUIS CANTELLANO	M	f	AA	LUIS 	CANTELLANO
7031361	D	60	6006	358	358001	Luis Rafael Pardo Sainz	LUIS PARDO	M	f	AA	LUIS	PARDO
9399630	D	81	6006	371	371004	Carolina Marzan Pinto	CAROLINA MARZÁN	M	f	AH	CAROLINA	MARZÁN
13463129	D	80	6006	371	371002	Priscila Corsi Caceres	PRISCILA CORSI	M	f	AH	PRISCILA	CORSI
10241974	D	73	6006	368	368157	Ricardo Enrique Brito Galarce	RICARDO BRITO	M	f	AB	RICARDO 	BRITO
14460244	D	91	6006	374	374147	Veronica Andrea Sotomayor Perez	VERÓNICA SOTOMAYOR	M	f	AM	VERÓNICA 	SOTOMAYOR
10502585	D	76	6006	368	368157	Manuel Rodrigo Catalan Reyes	MANUEL CATALÁN	M	f	AB	MANUEL 	CATALÁN
10734303	D	84	6006	371	371005	Nelson Venegas Salazar	NELSON VENEGAS	M	f	AH	NELSON	VENEGAS
8246099	D	82	6006	371	371004	Jorge Lopez Pino	JORGE LÓPEZ	M	f	AH	JORGE	LÓPEZ
6782500	D	79	6006	371	371002	Daniel Verdessi Belemmi	DANIEL VERDESSI	M	f	AH	DANIEL	VERDESSI
11944344	D	87	6006	371	371007	Marcelo David Merino Vergara	MARCELO MERINO	M	f	AH	MARCELO 	MERINO
19663507	D	95	6006	374	374147	Gisella Danitza Cortes Guzman	GISELLA CORTÉS	M	f	AM	GISELLA 	CORTÉS
19726589	D	90	6006	374	374147	Christopher Anttonio Olivares Olivares	CHRISTOPHER OLIVARES	M	f	AM	CHRISTOPHER 	OLIVARES
17857348	D	85	6006	371	371137	Francisca Loreto Aranguiz Vergara	FRANCISCA ARÁNGUIZ	M	t	AH	FRANCISCA	ARÁNGUIZ
15075914	D	89	6006	374	374147	Carolina Beatriz Cabello Valenzuela	CAROLINA CABELLO	M	f	AM	CAROLINA	CABELLO
6513904	D	86	6006	371	371007	Berta Del Carmen De La Fuente Valenzuela	BERTA DE	M	f	AH	BERTA 	DE LA FUENTE
9771177	D	88	6006	374	374147	Luis Humberto Aravena Egaña	LUIS ARAVENA	M	f	AM	LUIS 	ARAVENA
17634113	D	98	6006	347	347008	Ana Gallardo Carrasco	ANA GALLARDO	M	f	AN	ANA 	GALLARDO
14582741	D	93	6006	374	374147	Edith Paola Estay Olguin	EDITH ESTAY	M	f	AM	EDITH 	ESTAY
18287710	D	92	6006	374	374147	Roberto Antonio Manzano Perez	ROBERTO MANZANO	M	f	AM	ROBERTO	MANZANO
19191708	D	94	6006	374	374147	Christopher Rodolfo Vergara Garcia	CHRISTOPHER VERGARA	M	f	AM	CHRISTOPHER 	VERGARA
18299905	D	96	6006	374	374147	Francisco Javier Arias Teruel	FRANCISCO ARIAS	M	f	AM	FRANCISCO	ARIAS
7599952	D	99	6006	347	347008	Claudio Ivan Galarce Gonzalez	CLAUDIO GALARCE	M	f	AN	CLAUDIO 	GALARCE
9585115	D	97	6006	347	347008	Ricardo Georges Cid	RICARDO GEORGES	M	f	AN	RICARDO 	GEORGES
16540115	D	103	6006	347	347144	Leo Tulleres Cabrera	LEO TULLERES	M	t	AN	LEO	TULLERES
13190952	D	100	6006	347	347008	Andrea Patricia Araya Toro	ANDREA ARAYA	M	t	AN	ANDREA	ARAYA
10523961	D	112	6006	339	339150	Gustavo Bertelsen Mayol	GUSTAVO BERTELSEN	M	t	AP	GUSTAVO	BERTELSEN
18522770	D	125	6006	350	350180	Pedro Antonio De Jesus Leal Vergara	PEDRO LEAL	M	f	AW	PEDRO 	LEAL
13426516	D	107	6006	339	339150	Susan Escobar Gatica	SUSAN ESCOBAR	M	f	AP	SUSAN	ESCOBAR
12010963	D	106	6006	339	339150	Dan Hormachea De La Roza	DAN HORMACHEA	M	f	AP	DAN 	HORMACHEA
10670295	D	108	6006	339	339150	Gabriel Esteban Beltrami Woelkar	GABRIEL BELTRAMI	M	f	AP	GABRIEL 	BELTRAMI
9982415	D	109	6006	339	339150	Irene Andrea Ljubetic Villanueva	IRENE LJUBETIC	M	t	AP	IRENE 	LJUBETIC
8664927	D	113	6006	339	339150	Pedro Nolasco Valenzuela Piffaut	PEDRO VALENZUELA	M	t	AP	PEDRO 	VALENZUELA
16970768	D	123	6006	350	350180	Ealeen Chriswort Fox Marshall	EALEEN FOX	M	f	AW	EALEEN 	FOX
17756845	D	118	6006	366	366143	Matias Gabriel Gazmuri Kruberg	MATÍAS GAZMURI	M	f	AR	MATÍAS 	GAZMURI
12825103	D	127	6006	350	350180	Juan Guillermo Diaz Bustamante	JUAN DÍAZ	M	t	AW	JUAN 	DÍAZ
7968102	D	126	6006	350	350180	Marcos Hector Navarrete Guerin	MARCOS NAVARRETE	M	f	AW	MARCOS 	NAVARRETE
8459645	D	110	6006	339	339150	Manuel Antonio Lopez Miranda	MANUEL LÓPEZ	M	f	AP	MANUEL 	LÓPEZ
10103623	D	104	6006	347	347144	Claudio Poblete Duran	CLAUDIO POBLETE	M	t	AN	CLAUDIO	POBLETE
16575804	D	116	6006	366	366006	Sofia Alejandra Gonzalez Cortes	SOFÍA GONZÁLEZ	M	f	AR	SOFÍA	GONZÁLEZ
8472348	D	102	6006	347	347144	Victor Eduardo Ibacache Estay	VÍCTOR IBACACHE	M	t	AN	VÍCTOR	IBACACHE
10813376	D	111	6006	339	339150	Nubia Lorena Vivanco Illanes	NUBIA VIVANCO	M	t	AP	NUBIA 	VIVANCO
19489621	D	105	6006	339	339150	Chiara Barchiesi Chavez	CHIARA BARCHIESI	M	f	AP	CHIARA	BARCHIESI
17388370	D	122	6006	350	350180	Diana Nicol Madariaga Fernandez	DIANA MADARIAGA	M	f	AW	DIANA 	MADARIAGA
13426854	D	101	6006	347	347144	Yazmin Leticia Lorca Benavides	YAZMÍN LORCA	M	t	AN	YAZMÍN 	LORCA
10443737	D	121	6006	366	366045	Carlos Roberto Lezaeta Cabrera	CARLOS LEZAETA	M	t	AR	CARLOS 	LEZAETA
13763131	D	119	6006	366	366130	Francisca Ogalde Vega	FRANCISCA OGALDE	M	f	AR	FRANCISCA	OGALDE
16964937	D	114	6006	366	366149	Diego Eduardo Ibañez Cotroneo	DIEGO IBÁÑEZ	M	f	AR	DIEGO 	IBÁÑEZ
10940349	D	120	6006	366	366045	Lorena Cecilia Donaire Cataldo	LORENA DONAIRE	M	f	AR	LORENA 	DONAIRE
12825106	D	117	6006	366	366006	Cristian Alejandro Luna Salinas	CRISTIAN LUNA	M	t	AR	CRISTIAN	LUNA
16744626	D	115	6006	366	366149	Maria Francisca Bello Campos	MARÍA BELLO	M	f	AR	MARÍA FRANCISCA	BELLO
16010289	D	124	6006	350	350180	Maximiliano Roberto Arrepol Collante	MAXIMILIANO ARREPOL	M	f	AW	MAXIMILIANO	ARREPOL
13249342	D	128	6006	350	350180	Orlando Arturo Segovia Caceres	ORLANDO SEGOVIA	M	t	AW	ORLANDO	SEGOVIA
9606993	D	63	6007	358	358037	Maria De Los Angeles De La Paz Riveros	MARÍA DE	M	f	AA	MARÍA DE LOS ÁNGELES	DE LA PAZ
7765987	D	67	6007	358	358003	Jorge Castro Muñoz	JORGE CASTRO	M	f	AA	JORGE	CASTRO
9884412	D	69	6007	368	368157	Rodrigo Andres Vattuone Garces	RODRIGO VATTUONE	M	f	AB	RODRIGO 	VATTUONE
18162348	D	72	6007	368	368157	Barbara Andrea Vera Sepulveda	BÁRBARA VERA	M	f	AB	BÁRBARA 	VERA
12629615	D	66	6007	358	358003	Maria Angelica Silva Troncoso	MARÍA SILVA	M	f	AA	MARÍA ANGÉLICA	SILVA
6347447	D	62	6007	358	358001	Carmen Patricia Ibañez Soto	CARMEN IBÁÑEZ	M	f	AA	CARMEN 	IBÁÑEZ
14604596	D	61	6007	358	358001	Evelyn Roxana Mansilla Muñoz	EVELYN MANSILLA	M	f	AA	EVELYN	MANSILLA
18585784	D	64	6007	358	358037	Tarek Giacaman Mahana	TAREK GIACAMAN	M	f	AA	TAREK	GIACAMAN
16485167	D	71	6007	368	368157	Juan Marcelo Valenzuela Henriquez	JUAN VALENZUELA	M	f	AB	JUAN	VALENZUELA
6408953	D	73	6007	368	368157	Delia Alicia Pardo Araneda	DELIA PARDO	M	f	AB	DELIA 	PARDO
13272107	D	65	6007	358	358037	Hotuiti Teao Drago	HOTUITI TEAO	M	t	AA	HOTUITI	TEAO
8394414	D	70	6007	368	368157	Jorge Luis Passadore Soto	JORGE PASSADORE	M	f	AB	JORGE LUIS	PASSADORE
14376024	D	60	6007	358	358001	Andres Celis Montt	ANDRÉS CELIS	M	f	AA	ANDRÉS	CELIS
9915807	D	74	6007	368	368157	Fabiola Rosa Maturana Vielma	FABIOLA MATURANA	M	f	AB	FABIOLA 	MATURANA
6703197	D	76	6007	368	368157	Marcela Jovina Torrecilla Henriquez	MARCELA TORRECILLA	M	f	AB	MARCELA	TORRECILLA
17354096	D	68	6007	358	358003	Juan Pablo Rodriguez Oyarzun	JUAN RODRÍGUEZ	M	t	AA	JUAN PABLO	RODRÍGUEZ
17474999	D	77	6007	368	368157	Esteban Alberto Astudillo Henriquez	ESTEBAN ASTUDILLO	M	f	AB	ESTEBAN 	ASTUDILLO
13019384	D	75	6007	368	368157	Adolfo Andres Estrada Aldoney	ADOLFO ESTRADA	M	f	AB	ADOLFO 	ESTRADA
12626603	D	81	6007	364	364135	Catherine Valezka Fuentes Urra	CATHERINE FUENTES	M	f	AE	CATHERINE 	FUENTES
12955597	D	79	6007	364	364135	Natali Andrea Hinojosa Serrano	NATALI HINOJOSA	M	f	AE	NATALI 	HINOJOSA
12826167	D	84	6007	371	371005	Susana Calderon Romero	SUSANA CALDERÓN	M	f	AH	SUSANA 	CALDERÓN
8996164	D	83	6007	364	364135	Denis Renzo Ariel Barria Gonzalez	DENIS BARRÍA	M	f	AE	DENIS	BARRÍA
16469803	D	78	6007	364	364135	Antonio Alejandro Paez Aguilar	ANTONIO PÁEZ	M	f	AE	ANTONIO	PÁEZ
10732302	D	82	6007	364	364135	Gustavo Carlos Burgos Velasquez	GUSTAVO BURGOS	M	f	AE	GUSTAVO	BURGOS
16574281	D	85	6007	371	371005	Tomas De Rementeria Venegas	TOMÁS DE	M	t	AH	TOMÁS 	DE REMENTERÍA
20172614	D	80	6007	364	364135	Lyam Andres Riveros Diaz	LYAM RIVEROS	M	f	AE	LYAM	RIVEROS
15072709	D	89	6007	371	371002	Esteban Vega Toro	ESTEBAN VEGA	M	f	AH	ESTEBAN	VEGA
16427561	D	92	6007	371	371137	Ramon Yuc-liong Kong Gonzalez	RAMON KONG	M	t	AH	RAMON YUC	KONG
16105082	D	106	6007	347	347144	Carla Natalia Allendes Soza	CARLA ALLENDES	M	t	AN	CARLA 	ALLENDES
16888302	D	87	6007	371	371004	Juan Pablo Alarcon Quinteros	JUAN ALARCON	M	f	AH	JUAN PABLO	ALARCON
15383827	D	88	6007	371	371002	Paz Anastasiadis Le Roy	PAZ ANASTASIADIS	M	f	AH	PAZ	ANASTASIADIS
15829427	D	93	6007	374	374147	Jorge Raul Estay Olguin	JORGE ESTAY	M	f	AM	JORGE 	ESTAY
17598625	D	90	6007	371	371007	Tomas Ignacio Lagomarsino Guzman	TOMÁS LAGOMARSINO	M	t	AH	TOMÁS 	LAGOMARSINO
11826631	D	100	6007	374	374147	Marcia Lorena Tapia Navia	MARCIA TAPIA	M	f	AM	MARCIA 	TAPIA
15751674	D	96	6007	374	374147	Beatriz Gabriela Leonor Angelica Olivares Velasco	BEATRIZ OLIVARES	M	f	AM	BEATRIZ	OLIVARES
18539702	D	101	6007	374	374147	Pablo Valentin Recabal Maturana	PABLO RECABAL	M	f	AM	PABLO 	RECABAL
13622324	D	97	6007	374	374147	Ivan Marcelo Arteaga Fuentes	IVÁN ARTEAGA	M	f	AM	IVÁN	ARTEAGA
13021045	D	86	6007	371	371004	Pedro Huichalaf Roa	PEDRO HUICHALAF	M	f	AH	PEDRO	HUICHALAF
15703897	D	91	6007	371	371137	Leslie Sanchez Lobos	LESLIE SÁNCHEZ	M	t	AH	LESLIE	SÁNCHEZ
11635952	D	108	6007	347	347008	Alejandro Ivan Escobar Lobos	ALEJANDRO ESCOBAR	M	t	AN	ALEJANDRO 	ESCOBAR
12110487	D	98	6007	374	374147	Clarisa De Las Mercedes Rios Inostroza	CLARISA RÍOS	M	f	AM	CLARISA 	RÍOS
16964611	D	110	6007	339	339150	Luis Fernando Sanchez Ossa	LUIS SÁNCHEZ	M	f	AP	LUIS 	SÁNCHEZ
13951582	D	111	6007	339	339150	Francisco Clavel Diaz	FRANCISCO CLAVEL	M	f	AP	FRANCISCO	CLAVEL
17806014	D	122	6007	366	366143	Constanza Florencia Valdes Contreras	CONSTANZA VALDÉS	M	f	AR	CONSTANZA 	VALDÉS
18796176	D	107	6007	347	347008	Janyn Estefania Araneda Vasquez	JANYN ARANEDA	M	f	AN	JANYN 	ARANEDA
8395952	D	95	6007	374	374147	Eduardo Eugenio Salgado Reyes	EDUARDO SALGADO	M	f	AM	EDUARDO 	SALGADO
20484900	D	94	6007	374	374147	Ignacia Irune Abarzua Ramirez	IGNACIA ABARZÚA	M	f	AM	IGNACIA	ABARZÚA
8871593	D	128	6007	350	350180	Vanessa Ferrer Radovich	VANESSA FERRER	M	t	AW	VANESSA	FERRER
13989743	D	113	6007	339	339150	Leslie Manuel Thornton Aboitiz	LESLIE THORNTON	M	f	AP	LESLIE 	THORNTON
8869631	D	130	6007	350	350180	Luis Hernan Soto Poblete	LUIS SOTO	M	f	AW	LUIS	SOTO
11945239	D	99	6007	374	374147	Raul Roman Campos	RAÚL ROMÁN	M	f	AM	RAÚL	ROMÁN
13635882	D	123	6007	366	366130	Paula Arriagada Ortiz	PAULA ARRIAGADA	M	t	AR	PAULA	ARRIAGADA
15949038	D	114	6007	339	339150	Jorge David Parra Acuña	JORGE PARRA	M	f	AP	JORGE 	PARRA
8458723	D	115	6007	339	339150	Maria Soledad Hurtado Arellano	MARIA HURTADO	M	f	AP	MARIA SOLEDAD	HURTADO
13670179	D	126	6007	366	366149	Pablo Alejandro Donoso Christie	PABLO DONOSO	M	t	AR	PABLO	DONOSO
12880967	D	103	6007	347	347144	Claudio Antonio Sepulveda Young	CLAUDIO SEPÚLVEDA	M	f	AN	CLAUDIO	SEPÚLVEDA
10086204	D	120	6007	366	366045	Mabel Lucila Zuñiga Valencia	MABEL ZÚÑIGA	M	t	AR	MABEL	ZÚÑIGA
15069174	D	118	6007	339	339150	Barbara Pavez Garcia	BARBARA PÁVEZ	M	t	AP	BARBARA	PÁVEZ
15100548	D	102	6007	347	347144	Frederick Soto Ponce	FREDERICK SOTO	M	f	AN	FREDERICK	SOTO
12661169	D	104	6007	347	347144	Jessica Marcela Garcia Phillips	JESSICA GARCIA	M	t	AN	JESSICA 	GARCIA
13264349	D	124	6007	366	366006	Luis Alberto Cuello Peña Y Lillo	LUIS CUELLO	M	f	AR	LUIS ALBERTO	CUELLO
7019079	D	112	6007	339	339150	Maria Paulina Mayo De Goyeneche	MARÍA MAYO	M	f	AP	MARÍA PAULINA	MAYO
17322675	D	119	6007	366	366045	Jorge Brito Hasbun	JORGE BRITO	M	f	AR	JORGE	BRITO
5392633	D	117	6007	339	339150	Jaime Alfredo Perry Jungk	JAIME PERRY	M	t	AP	JAIME 	PERRY
16452896	D	127	6007	366	366149	Romina Andrea Maragaño Schmidt	ROMINA MARAGAÑO	M	f	AR	ROMINA	MARAGAÑO
17815566	D	121	6007	366	366143	Camila Ruzlay Rojas Valderrama	CAMILA ROJAS	M	f	AR	CAMILA	ROJAS
8995459	D	109	6007	347	347008	Marco Antonio Brauchy Castillo	MARCO BRAUCHY	M	t	AN	MARCO 	BRAUCHY
16812729	D	105	6007	347	347144	Andrea Alejandra Estay Caamaño	ANDREA ESTAY	M	t	AN	ANDREA 	ESTAY
13875124	D	125	6007	366	366006	Oscar Aroca Contreras	OSCAR AROCA	M	f	AR	OSCAR	AROCA
6622672	D	116	6007	339	339150	Paul Alexander Sfeir Rubio	PAUL SFEIR	M	f	AP	PAUL 	SFEIR
17753651	D	129	6007	350	350180	Gabriel Esteban Ramos Nuñez	GABRIEL RAMOS	M	f	AW	GABRIEL	RAMOS
17201921	D	131	6007	350	350180	Nicolas Felipe Arancibia Collao	NICOLÁS ARANCIBIA	M	f	AW	NICOLÁS	ARANCIBIA
13687270	D	60	6008	358	358003	Joaquin Lavin Leon	JOAQUÍN LAVÍN	M	f	AA	JOAQUÍN 	LAVÍN
18933626	D	62	6008	358	358003	Catalina Olavarria Nelson	CATALINA OLAVARRÍA	M	f	AA	CATALINA	OLAVARRÍA
17578848	D	64	6008	358	358037	Frank Almendares Muller	FRANK ALMENDARES	M	t	AA	FRANK	ALMENDARES
13922301	D	61	6008	358	358003	Cristian Labbe Martinez	CRISTIÁN LABBÉ	M	f	AA	CRISTIÁN	LABBÉ
10803467	D	63	6008	358	358037	Angelica Teresa Flores Rodriguez	ANGÉLICA FLORES	M	f	AA	ANGÉLICA	FLORES
15350773	D	71	6008	368	368157	Victor Hugo Antil Cayuqueo	VÍCTOR ANTIL	M	f	AB	VÍCTOR HUGO	ANTIL
17886466	D	66	6008	358	358001	Camilo Moran Bahamondes	CAMILO MORÁN	M	f	AA	CAMILO	MORÁN
13829381	D	68	6008	358	358001	Christian Omar Pino Lanata	CHRISTIAN PINO	M	t	AA	CHRISTIAN	PINO
14156206	D	69	6008	368	368157	Ruben Dario Oyarzo Figueroa	RUBÉN OYARZO	M	f	AB	RUBÉN 	OYARZO
17602818	D	67	6008	358	358001	Alejandra Sepulveda Torres	ALEJANDRA SEPÚLVEDA	M	f	AA	ALEJANDRA	SEPÚLVEDA
14091963	D	77	6008	368	368157	Roxana Del Carmen Jara Romero	ROXANA JARA	M	f	AB	ROXANA 	JARA
10962982	D	74	6008	368	368157	Orlando Christian Machefert Inostroza	ORLANDO MACHEFERT	M	f	AB	ORLANDO	MACHEFERT
13463153	D	72	6008	368	368157	Barbara Marlene Gonzalez Contreras	BÁRBARA GONZÁLEZ	M	f	AB	BÁRBARA 	GONZÁLEZ
17961615	D	65	6008	358	358037	Diego Fernando Bravo Morales	DIEGO BRAVO	M	t	AA	DIEGO 	BRAVO
18670224	D	73	6008	368	368157	Cristobal Ignacio Matamala Henriquez	CRISTÓBAL MATAMALA	M	f	AB	CRISTÓBAL 	MATAMALA
14126310	D	96	6008	356	356142	Alejandro Arevalo Miranda	ALEJANDRO AREVALO	M	f	AL	ALEJANDRO 	AREVALO
9878248	D	89	6008	371	371005	Angelica Cid Venegas	ANGÉLICA CID	M	f	AH	ANGÉLICA	CID
12524260	D	70	6008	368	368157	Lucy Del Carmen Muñoz Marticorena	LUCY MUÑOZ	M	f	AB	LUCY 	MUÑOZ
16628743	D	92	6008	356	356142	Rodrigo Muñoz Soto	RODRIGO MUÑOZ	M	f	AL	RODRIGO	MUÑOZ
10214960	D	108	6008	347	347008	Maria Teresa Alvarez Aguilar	MARÍA ÁLVAREZ	M	t	AN	MARÍA TERESA	ÁLVAREZ
15971941	D	76	6008	368	368157	German Gabriel Delgado Ayala	GERMÁN DELGADO	M	f	AB	GERMÁN 	DELGADO
17499823	D	103	6008	374	374147	Macarena Andrea Parra Parra	MACARENA PARRA	M	f	AM	MACARENA 	PARRA
18627573	D	81	6008	364	364135	Sebastian Alexis Aviles Tapia	SEBASTIÁN AVILÉS	M	f	AE	SEBASTIÁN 	AVILÉS
19040828	D	93	6008	356	356142	Cristina Femenias Salas	CRISTINA FEMENIAS	M	f	AL	CRISTINA 	FEMENIAS
14519812	D	86	6008	371	371137	Cynthia Ana Vivallo Cuevas	CYNTHIA VIVALLO	M	f	AH	CYNTHIA	VIVALLO
17212311	D	94	6008	356	356142	Wilson Gutierrez Gutierrez	WILSON GUTIÉRREZ	M	f	AL	WILSON 	GUTIÉRREZ
14463647	D	75	6008	368	368157	Leyla Massiel Jara Lopez	LEYLA JARA	M	f	AB	LEYLA 	JARA
15590906	D	85	6008	371	371137	Pablo Vidal Rojas	PABLO VIDAL	M	t	AH	PABLO	VIDAL
17402754	D	80	6008	364	364135	Beatriz Alejandra Bravo Vaca	BEATRIZ BRAVO	M	f	AE	BEATRIZ 	BRAVO
12605728	D	88	6008	371	371004	Manuel Ibarra Mondaca	MANUEL IBARRA	M	t	AH	MANUEL	IBARRA
16624052	D	113	6008	347	347144	Luis Eduardo Santibañez Perez	LUIS SANTIBAÑEZ	M	t	AN	LUIS 	SANTIBAÑEZ
11199248	D	98	6008	374	374147	Roxana Del Pilar Miranda Meneses	ROXANA MIRANDA	M	f	AM	ROXANA	MIRANDA
10031435	D	83	6008	371	371002	Alberto Undurraga Vicuña	ALBERTO UNDURRAGA	M	f	AH	ALBERTO	UNDURRAGA
15335786	D	119	6008	339	339150	Jean Pierre Bonvallet Setti	JEAN BONVALLET	M	t	AP	JEAN PIERRE	BONVALLET
7236336	D	87	6008	371	371004	Erto Pantoja Gutierrez	ERTO PANTOJA	M	t	AH	ERTO	PANTOJA
16262251	D	99	6008	374	374147	Johanna Valeska Ortega Larrañaga	JOHANNA ORTEGA	M	f	AM	JOHANNA 	ORTEGA
12640104	D	84	6008	371	371002	Claudia Acevedo Cornejo	CLAUDIA ACEVEDO	M	f	AH	CLAUDIA 	ACEVEDO
21897247	D	115	6008	339	339150	Luz Janeth Espinal Moreno	LUZ ESPINAL	M	f	AP	LUZ 	ESPINAL
12720170	D	114	6008	339	339150	Agustin Matias Romero Leiva	AGUSTÍN ROMERO	M	f	AP	AGUSTÍN	ROMERO
9791299	D	101	6008	374	374147	Mario Enrique Fajardo Perez	MARIO FAJARDO	M	f	AM	MARIO	FAJARDO
10374060	D	107	6008	347	347008	Leandro Patricio Cortez Frias	LEANDRO CORTEZ	M	t	AN	LEANDRO 	CORTEZ
8966611	D	90	6008	371	371005	Monica Sanchez Aceituno	MÓNICA SÁNCHEZ	M	t	AH	MÓNICA	SÁNCHEZ
12218093	D	117	6008	339	339150	Cecilia Susana Collao Carvajal	CECILIA COLLAO	M	f	AP	CECILIA 	COLLAO
19442140	D	120	6008	339	339150	Drazen Andre Markusovic Caceres	DRAZEN MARKUSOVIC	M	t	AP	DRAZEN 	MARKUSOVIC
15181940	D	97	6008	356	356142	Patricio Vivanco Carrasco	PATRICIO VIVANCO	M	f	AL	PATRICIO 	VIVANCO
17105970	D	104	6008	374	374147	Javier Antonio Sanhueza Parra	JAVIER SANHUEZA	M	f	AM	JAVIER	SANHUEZA
17674175	D	79	6008	364	364135	Gabriel Alfonso Muñoz Carrillo	GABRIEL MUÑOZ	M	f	AE	GABRIEL 	MUÑOZ
18641444	D	100	6008	374	374147	Danilo Andres Ramirez Cortes	DANILO RAMÍREZ	M	f	AM	DANILO	RAMÍREZ
19322244	D	95	6008	356	356142	Barbara Araniba Vargas	BÁRBARA ARANIBA	M	f	AL	BÁRBARA 	ARANIBA
12672263	D	102	6008	374	374147	Marisol Jacqueline Llanos Prado	MARISOL LLANOS	M	f	AM	MARISOL	LLANOS
16744541	D	78	6008	364	364135	Javiera Constanza Marquez Basualto	JAVIERA MÁRQUEZ	M	f	AE	JAVIERA	MÁRQUEZ
9586556	D	121	6008	339	339150	Juan Carlos Gomez Escobar	JUAN GÓMEZ	M	t	AP	JUAN CARLOS	GÓMEZ
14447031	D	110	6008	347	347144	Lissette Solange Ponce Olmedo	LISSETTE PONCE	M	t	AN	LISSETTE 	PONCE
17599357	D	105	6008	347	347008	Camila Paz Caceres Fuentes	CAMILA CÁCERES	M	f	AN	CAMILA 	CÁCERES
7350422	D	82	6008	371	371007	Carlos Flores Navarrete	CARLOS FLORES	M	f	AH	CARLOS	FLORES
12492799	D	111	6008	347	347144	Jessica Fabiola Rupayan Ponce	JESSICA RUPAYAN	M	t	AN	JESSICA 	RUPAYAN
16723794	D	109	6008	347	347144	Noelia Alejandra Segovia Reyes	NOELIA SEGOVIA	M	f	AN	NOELIA 	SEGOVIA
11883859	D	106	6008	347	347008	Ignacio Alfredo Allende Cortez	IGNACIO ALLENDE	M	t	AN	IGNACIO 	ALLENDE
12730508	D	91	6008	356	356142	Viviana Delgado Riquelme	VIVIANA DELGADO	M	f	AL	VIVIANA 	DELGADO
12214621	D	124	6008	366	366143	Eduardo Alejandro Acuña Fuentes	EDUARDO ACUÑA	M	f	AR	EDUARDO	ACUÑA
8532104	D	112	6008	347	347144	Manuel Enrique Muñoz Palacios	MANUEL MUÑOZ	M	t	AN	MANUEL 	MUÑOZ
19734595	D	122	6008	339	339150	Eduardo Alexis Toledo Pinto	EDUARDO TOLEDO	M	t	AP	EDUARDO	TOLEDO
15819480	D	125	6008	366	366143	Libertad Angela Mendez Nuñez	LIBERTAD MÉNDEZ	M	f	AR	LIBERTAD 	MÉNDEZ
11404285	D	123	6008	366	366143	Claudia Nathalie Mix Jimenez	CLAUDIA MIX	M	f	AR	CLAUDIA 	MIX
8966401	D	116	6008	339	339150	Gabriela Ines Gallardo Fuentes	GABRIELA GALLARDO	M	f	AP	GABRIELA	GALLARDO
16322402	D	127	6008	366	366006	Florencia Constanza Lagos Neumann	FLORENCIA LAGOS	M	t	AR	FLORENCIA 	LAGOS
13916655	D	118	6008	339	339150	Claudio Rojas Diaz	CLAUDIO ROJAS	M	t	AP	CLAUDIO	ROJAS
18840486	D	132	6008	350	350180	Sebastian Antonio Abarca Mariño	SEBASTIÁN ABARCA	M	f	AW	SEBASTIÁN 	ABARCA
13243043	D	134	6008	373	373139	Alejandra Solange Navarrete Carrasco	ALEJANDRA NAVARRETE	M	f	AY	ALEJANDRA 	NAVARRETE
9907767	D	129	6008	366	366045	Rocio Del Pilar Faundez Garcia	ROCÍO FAÚNDEZ	M	f	AR	ROCÍO	FAÚNDEZ
4779430	D	126	6008	366	366006	Carmen Adelaida Hertz Cadiz	CARMEN HERTZ	M	f	AR	CARMEN 	HERTZ
11840715	D	131	6008	366	366130	Victor Enrique Orellana Parra	VÍCTOR ORELLANA	M	f	AR	VÍCTOR 	ORELLANA
18048208	D	128	6008	366	366006	Juan Pablo Ciudad Perez	JUAN CIUDAD	M	f	AR	JUAN PABLO	CIUDAD
8536442	D	130	6008	366	366045	Julio Salas Gutierrez	JULIO SALAS	M	t	AR	JULIO	SALAS
15429015	D	133	6008	350	350180	Natalia Fernanda Leiva Cepeda	NATALIA LEIVA	M	f	AW	NATALIA 	LEIVA
7543154	D	137	6008	373	373139	Berta Del Carmen Montecinos Duran	BERTA MONTECINOS	M	f	AY	BERTA 	MONTECINOS
15429753	D	135	6008	373	373139	Mauricio Antonio Santander Videla	MAURICIO SANTANDER	M	f	AY	MAURICIO 	SANTANDER
18059371	D	138	6008	999	99	Cesar Leiva Rubio	CÉSAR LEIVA	M	t	ZZZ	CÉSAR	LEIVA
13918318	D	136	6008	373	373139	Sebastian Gonzalo Duarte Vergara	SEBASTIÁN DUARTE	M	f	AY	SEBASTIÁN 	DUARTE
16419878	D	60	6009	358	358003	Jorge Acosta Acosta	JORGE ACOSTA	M	t	AA	JORGE 	ACOSTA
13901346	D	63	6009	358	358001	Jorge Duran Espinoza	JORGE DURÁN	M	f	AA	JORGE	DURÁN
17089399	D	61	6009	358	358003	Magdalena Vergara Vial	MAGDALENA VERGARA	M	t	AA	MAGDALENA 	VERGARA
11986641	D	66	6009	358	358140	Paola Walker Rodriguez	PAOLA WALKER	M	t	AA	PAOLA	WALKER
11977685	D	65	6009	358	358001	Eddy Roldan Cabrera	EDDY ROLDÁN	M	t	AA	EDDY	ROLDÁN
13852751	D	64	6009	358	358001	Erika Alejandra Olivera De La Fuente	ERIKA OLIVERA	M	t	AA	ERIKA 	OLIVERA
19163724	D	69	6009	368	368157	Maria Fernanda Olguin Luengo	MARÍA OLGUÍN	M	f	AB	MARÍA 	OLGUÍN
13894673	D	68	6009	368	368157	Patricio Ismael Romo Vargas	PATRICIO ROMO	M	f	AB	PATRICIO	ROMO
8966181	D	62	6009	358	358003	Dino Paolo Cavaletto Flores	DINO CAVALETTO	M	f	AA	DINO 	CAVALETTO
15440768	D	77	6009	371	371137	Natalia Castillo Muñoz	NATALIA CASTILLO	M	t	AH	NATALIA	CASTILLO
15603900	D	78	6009	371	371137	Margarita Ernestina Guerrero Zamora	MARGARITA GUERRERO	M	t	AH	MARGARITA 	GUERRERO
19521765	D	67	6009	358	358140	Cesar Castillo Maldonado	CÉSAR CASTILLO	M	t	AA	CÉSAR	CASTILLO
16666039	D	70	6009	368	368157	Engel Andrea Zuñiga Orellana	ENGEL ZÚÑIGA	M	f	AB	ENGEL 	ZÚÑIGA
15530908	D	76	6009	364	364135	Viviana Andrea Gonzalez Navarro	VIVIANA GONZÁLEZ	M	f	AE	VIVIANA 	GONZÁLEZ
13472177	D	84	6009	356	356142	Andres Sepulveda Rojas	ANDRÉS SEPÚLVEDA	M	f	AL	ANDRÉS	SEPÚLVEDA
8512366	D	71	6009	368	368157	Cesar Abraham Suay Jerez	CÉSAR SUAY	M	f	AB	CÉSAR 	SUAY
14132397	D	79	6009	371	371004	Millarai Abelleira Peralta	MILLARAI ABELLEIRA	M	t	AH	MILLARAI	ABELLEIRA
10410236	D	82	6009	371	371002	Rodrigo Albornoz Pollmann	RODRIGO ALBORNOZ	M	f	AH	RODRIGO	ALBORNOZ
16742778	D	75	6009	364	364135	Luna Joram Peñaloza Aguirre	LUNA PEÑALOZA	M	f	AE	LUNA 	PEÑALOZA
15588365	D	73	6009	368	368157	Rodrigo Andres Moreno Miranda	RODRIGO MORENO	M	f	AB	RODRIGO	MORENO
13037472	D	85	6009	356	356142	Elizabeth ñanco Lincopi	ELIZABETH ÑANCO	M	f	AL	ELIZABETH	ÑANCO
12239700	D	81	6009	371	371005	Erika Montecinos Urrea	ERIKA MONTECINOS	M	t	AH	ERIKA 	MONTECINOS
15608509	D	74	6009	364	364135	Jonathan Arturo Rios Puebla	JONATHAN RÍOS	M	f	AE	JONATHAN 	RÍOS
9155333	D	83	6009	371	371002	Marcela Paz Canales Hipp	MARCELA CANALES	M	f	AH	MARCELA	CANALES
7046842	D	80	6009	371	371005	Alvaro Erazo Latorre	ÁLVARO ERAZO	M	f	AH	ÁLVARO 	ERAZO
9880179	D	92	6009	374	374147	Ana Maria Arias Agurto	ANA ARIAS	M	f	AM	ANA MARÍA	ARIAS
9406335	D	94	6009	374	374147	Ana Maria Molina Villarreal	ANA MOLINA	M	f	AM	ANA MARÍA	MOLINA
8285451	D	87	6009	356	356142	Viviana Montecinos Suazo	VIVIANA MONTECINOS	M	f	AL	VIVIANA 	MONTECINOS
11801487	D	72	6009	368	368157	Victoria Haydee Soto Lopez	VICTORIA SOTO	M	f	AB	VICTORIA 	SOTO
9159123	D	96	6009	347	347008	Cristian Miguel Inostroza Suarez	CRISTIÁN INOSTROZA	M	f	AN	CRISTIÁN 	INOSTROZA
9879247	D	88	6009	356	356142	Eladio Rojas Vergara	ELADIO ROJAS	M	f	AL	ELADIO	ROJAS
16147067	D	89	6009	374	374147	Alejandro Esteban Ovalle Contreras	ALEJANDRO OVALLE	M	f	AM	ALEJANDRO 	OVALLE
17372144	D	91	6009	374	374147	Jesus Fernando Gomez Orellana	JESÚS GÓMEZ	M	f	AM	JESÚS 	GÓMEZ
20499022	D	93	6009	374	374147	Isidro Alfonso Constanzo Saez	ISIDRO CONSTANZO	M	f	AM	ISIDRO	CONSTANZO
10865007	D	86	6009	356	356142	Robinson Piñeda Vasquez	ROBINSON PIÑEDA	M	f	AL	ROBINSON 	PIÑEDA
10279755	D	97	6009	347	347008	Alfonso Ernesto Barril Aguero	ALFONSO BARRIL	M	t	AN	ALFONSO	BARRIL
17217311	D	98	6009	347	347008	Hector Armando Anabalon Zurita	HÉCTOR ANABALÓN	M	f	AN	HÉCTOR	ANABALÓN
7353071	D	95	6009	347	347008	Pablo Maltes Biskupovic	PABLO MALTÉS	M	f	AN	PABLO 	MALTÉS
20550155	D	90	6009	374	374147	Josefa Michelle Jimenez Aros	JOSEFA JIMÉNEZ	M	f	AM	JOSEFA	JIMÉNEZ
18849026	D	101	6009	347	347144	Oscar Ariel Silva Quiroz	ÓSCAR SILVA	M	t	AN	ÓSCAR	SILVA
15585097	D	99	6009	347	347144	Jessica Del Carmen Cayupi Llancaleo	JESSICA CAYUPI	M	t	AN	JESSICA 	CAYUPI
16084807	D	107	6009	339	339150	Francisco Javier Valencia Muñoz	FRANCISCO VALENCIA	M	t	AP	FRANCISCO	VALENCIA
10394581	D	102	6009	347	347144	Christian Camus Acevedo	CHRISTIAN CAMUS	M	t	AN	CHRISTIAN	CAMUS
14198058	D	108	6009	339	339150	Maritza Venegas Arroyo	MARITZA VENEGAS	M	t	AP	MARITZA	VENEGAS
15837533	D	110	6009	339	339150	Daniel Bustos Aguayo	DANIEL BUSTOS	M	t	AP	DANIEL	BUSTOS
10548642	D	100	6009	347	347144	Ariel Vladimir Encina Cruz	ARIEL ENCINA	M	t	AN	ARIEL 	ENCINA
13035819	D	106	6009	339	339150	Margarita Del Rosario Garrido Acevedo	MARGARITA GARRIDO	M	t	AP	MARGARITA	GARRIDO
13049147	D	116	6009	366	366143	Varinia Lidia Diaz Cortes	VARINIA DÍAZ	M	t	AR	VARINIA	DÍAZ
16577120	D	103	6009	339	339150	Jose Carlos Meza Pereira	JOSÉ MEZA	M	f	AP	JOSÉ	MEZA
12855046	D	109	6009	339	339150	Macarena Kinast Casanova	MACARENA KINAST	M	t	AP	MACARENA	KINAST
16642752	D	111	6009	366	366006	Karol Aida Cariola Oliva	KAROL CARIOLA	M	f	AR	KAROL 	CARIOLA
12706760	D	118	6009	366	366149	Carlos Roberto Muñoz Reyes	CARLOS MUÑOZ	M	t	AR	CARLOS 	MUÑOZ
7040277	D	104	6009	339	339150	Maria Veronica Chelita Welkner Ballas	MARÍA WELKNER	M	f	AP	MARÍA	WELKNER
9665966	D	105	6009	339	339150	Angel Custodio Jadue Pichara	ÁNGEL JADUE	M	f	AP	ÁNGEL 	JADUE
11524485	D	112	6009	366	366006	Boris Anthony Barrera Moreno	BORIS BARRERA	M	f	AR	BORIS 	BARRERA
17676135	D	115	6009	366	366143	Juan Pablo Sanhueza Tortella	JUAN SANHUEZA	M	f	AR	JUAN PABLO	SANHUEZA
16655616	D	114	6009	366	366045	Andres Giordano Salazar	ANDRÉS GIORDANO	M	t	AR	ANDRÉS	GIORDANO
13095568	D	119	6009	350	350180	Carlos Richard Castro Fuentealba	CARLOS CASTRO	M	t	AW	CARLOS 	CASTRO
14134666	D	120	6009	373	373139	Daniel Ibañez Castro	DANIEL IBAÑEZ	M	f	AY	DANIEL	IBAÑEZ
18461832	D	117	6009	366	366149	Rodrigo Tomas Mallea Cardemil	RODRIGO MALLEA	M	f	AR	RODRIGO 	MALLEA
18646562	D	122	6009	373	373139	Ignacio Bustos Saez	IGNACIO BUSTOS	M	f	AY	IGNACIO	BUSTOS
16748421	D	113	6009	366	366045	Maite Orsini Pascal	MAITE ORSINI	M	f	AR	MAITE	ORSINI
13236579	D	121	6009	373	373139	Evelyn Carolina Farias Ailio	EVELYN FARÍAS	M	f	AY	EVELYN 	FARÍAS
14101300	D	61	6010	358	358003	Carlos Cisterna Parra	CARLOS CISTERNA	M	t	AA	CARLOS 	CISTERNA
10828362	D	62	6010	358	358037	Pablo Kast Sommerhoff	PABLO KAST	M	f	AA	PABLO	KAST
15335923	D	72	6010	368	368157	Silvia Fabiola Pereira Foster	SILVIA PEREIRA	M	f	AB	SILVIA 	PEREIRA
18357631	D	78	6010	364	364135	Dauno Totoro Navarro	DAUNO TOTORO	M	f	AE	DAUNO	TOTORO
13657702	D	60	6010	358	358003	Jorge Alessandri Vergara	JORGE ALESSANDRI	M	f	AA	JORGE 	ALESSANDRI
10167505	D	73	6010	368	368157	Hector Orlando Montecinos Sandoval	HÉCTOR MONTECINOS	M	f	AB	HÉCTOR 	MONTECINOS
14119383	D	65	6010	358	358001	Sebastian Torrealba Alvarado	SEBASTIÁN TORREALBA	M	f	AA	SEBASTIÁN	TORREALBA
12677906	D	96	6010	356	356142	Jose Madariaga Labra	JOSÉ MADARIAGA	M	f	AL	JOSÉ	MADARIAGA
4848669	D	67	6010	358	358001	Maria Luisa Cordero Velasquez	MARÍA CORDERO	M	t	AA	MARÍA LUISA	CORDERO
12456692	D	64	6010	358	358037	Savka Pollak Tomasevich	SAVKA POLLAK	M	t	AA	SAVKA	POLLAK
18121810	D	81	6010	364	364135	Alejandra Paz Decap Contreras	ALEJANDRA DECAP	M	f	AE	ALEJANDRA 	DECAP
14144380	D	76	6010	368	368157	Jorge Humberto Rojas Vallejos	JORGE ROJAS	M	f	AB	JORGE 	ROJAS
16960052	D	107	6010	347	347008	Isabel Del Carmen Cayul Piña	ISABEL CAYUL	M	t	AN	ISABEL	CAYUL
9666322	D	85	6010	371	371005	Cristian Aranguiz Salazar	CRISTIÁN ARÁNGUIZ	M	f	AH	CRISTIÁN	ARÁNGUIZ
16608106	D	87	6010	371	371137	Maria Jose Cumplido Baeza	MARÍA CUMPLIDO	M	f	AH	MARÍA JOSÉ	CUMPLIDO
7932775	D	71	6010	368	368157	Mario Isaias Sadovnik Engel	MARIO SADOVNIK	M	f	AB	MARIO 	SADOVNIK
19657869	D	79	6010	364	364135	Yamila De Lourdes Martinez Urrutia	YAMILA MARTÍNEZ	M	f	AE	YAMILA 	MARTÍNEZ
21633984	D	70	6010	368	368157	Jannier Estrella Gilberto Vergara	JANNIER GILBERTO	M	f	AB	JANNIER 	GILBERTO
15465039	D	68	6010	368	368157	Axel Patricio Gonzalez Valdebenito	AXEL GONZÁLEZ	M	f	AB	AXEL 	GONZÁLEZ
14591842	D	93	6010	356	356142	Karla Pinto Timmermann	KARLA PINTO	M	f	AL	KARLA	PINTO
8533732	D	91	6010	371	371004	Yolanda Pizarro Carmona	YOLANDA PIZARRO	M	f	AH	YOLANDA	PIZARRO
5570631	D	90	6010	371	371007	Miriam Ana Josefina Señoret Soto	MIRIAM SEÑORET	M	f	AH	MIRIAM	SEÑORET
15469674	D	94	6010	356	356142	Giovanka Luengo Figueroa	GIOVANKA LUENGO	M	f	AL	GIOVANKA 	LUENGO
10318977	D	95	6010	356	356142	Fernando Neira Pezoa	FERNANDO NEIRA	M	f	AL	FERNANDO 	NEIRA
19569312	D	84	6010	371	371005	Gabriela Carrera Valdes	GABRIELA CARRERA	M	f	AH	GABRIELA	CARRERA
11678593	D	63	6010	358	358037	Hector Rodriguez Mendoza	HÉCTOR RODRÍGUEZ	M	f	AA	HÉCTOR	RODRÍGUEZ
6158746	D	88	6010	371	371002	Jacqueline Saintard Vera	JACQUELINE SAINTARD	M	f	AH	JACQUELINE	SAINTARD
12397526	D	77	6010	364	364135	Claudia Andrea Tassara Ruilova	CLAUDIA TASSARA	M	f	AE	CLAUDIA 	TASSARA
15970175	D	75	6010	368	368157	Jenniffer Liliana Isla Pizarro	JENNIFFER ISLA	M	f	AB	JENNIFFER 	ISLA
17611305	D	98	6010	374	374147	Gaspar Mateo Ortiz Cardenas	GASPAR ORTIZ	M	f	AM	GASPAR	ORTIZ
15456124	D	69	6010	368	368157	Daniela Paz Moscoso Oyarzun	DANIELA MOSCOSO	M	f	AB	DANIELA 	MOSCOSO
7736652	D	99	6010	374	374147	Nancy Cristina Nicul Lincoleo	NANCY NICUL	M	f	AM	NANCY 	NICUL
7747729	D	86	6010	371	371137	Claudio Eugenio Arriagada Macaya	CLAUDIO ARRIAGADA	M	t	AH	CLAUDIO 	ARRIAGADA
20039362	D	80	6010	364	364135	Yuri Ernesto Peña Jimenez	YURI PEÑA	M	f	AE	YURI 	PEÑA
12605804	D	66	6010	358	358001	Alan Valdo Roldan Cabrera	ALAN ROLDÁN	M	t	AA	ALAN 	ROLDÁN
18250342	D	74	6010	368	368157	Cristian Ignacio Sepulveda Muñoz	CRISTIÁN SEPÚLVEDA	M	f	AB	CRISTIÁN 	SEPÚLVEDA
17193875	D	97	6010	356	356142	Norman Romo Grogg	NORMAN ROMO	M	f	AL	NORMAN	ROMO
17705340	D	82	6010	364	364135	Elias Ignacio Muñoz Parra	ELÍAS MUÑOZ	M	f	AE	ELÍAS 	MUÑOZ
8009918	D	103	6010	374	374147	Maria Angelica Cornejo Zuñiga	MARIA CORNEJO	M	f	AM	MARIA ANGELICA	CORNEJO
10938065	D	104	6010	347	347008	Helmut Kramer Angel	HELMUT KRAMER	M	f	AN	HELMUT	KRAMER
10860182	D	100	6010	374	374147	Rodrigo Antonio Maureira Vasquez	RODRIGO MAUREIRA	M	f	AM	RODRIGO 	MAUREIRA
12908796	D	89	6010	371	371002	Rosa Del Carmen Valenzuela Chamorro	ROSA VALENZUELA	M	f	AH	ROSA 	VALENZUELA
7541652	D	106	6010	347	347008	Alfredo Antonio Bruna Orellana	ALFREDO BRUNA	M	f	AN	ALFREDO 	BRUNA
9094669	D	110	6010	347	347144	Sebastian Milos Montes	SEBASTIÁN MILOS	M	t	AN	SEBASTIÁN	MILOS
6025149	D	92	6010	371	371004	Helia Molina Milman	HELIA MOLINA	M	f	AH	HELIA	MOLINA
8964056	D	108	6010	347	347144	Marcela Pat Gonzalez Paredes	MARCELA GONZÁLEZ	M	t	AN	MARCELA 	GONZÁLEZ
15666390	D	109	6010	347	347144	Roberto Campos Weiss	ROBERTO CAMPOS	M	t	AN	ROBERTO	CAMPOS
7017031	D	114	6010	339	339150	Maria Pia Marinovic Merino	MARÍA MARINOVIC	M	f	AP	MARÍA PÍA	MARINOVIC
10473402	D	101	6010	374	374147	Tatiana Rosa Marin Oliva	TATIANA MARÍN	M	f	AM	TATIANA 	MARÍN
8226676	D	83	6010	364	364135	Maria Victoria Torres Sandoval	MARÍA TORRES	M	f	AE	MARÍA	TORRES
13829964	D	116	6010	339	339150	Sonja Del Rio Becker	SONJA DEL	M	f	AP	SONJA	DEL RÍO
8446802	D	105	6010	347	347008	Paulina Teresa Bravo Guzman	PAULINA BRAVO	M	f	AN	PAULINA 	BRAVO
13066711	D	113	6010	339	339150	Johannes Kaiser Barents-von Hohenhagen	JOHANNES KAISER	M	f	AP	JOHANNES	KAISER
13059820	D	115	6010	339	339150	Carolina Angela Garate Vergara	CAROLINA GARATE	M	f	AP	CAROLINA 	GARATE
13264298	D	111	6010	347	347144	Juan Egor Plaza Aguilar	JUAN PLAZA	M	t	AN	JUAN 	PLAZA
11861471	D	112	6010	347	347144	Jose Osorio Cubillos	JOSÉ OSORIO	M	t	AN	JOSÉ	OSORIO
20165425	D	102	6010	374	374147	Tomas Alejandro Jimenez Burnas	TOMÁS JIMÉNEZ	M	f	AM	TOMÁS	JIMÉNEZ
6542451	D	120	6010	339	339150	Jose Vallejo Knockaert	JOSÉ VALLEJO	M	t	AP	JOSÉ	VALLEJO
15316699	D	117	6010	339	339150	Ricardo Alejandro Delgado Gaete	RICARDO DELGADO	M	f	AP	RICARDO 	DELGADO
15501540	D	121	6010	339	339150	Leslie Tamara Miranda Ramos	LESLIE MIRANDA	M	t	AP	LESLIE 	MIRANDA
4356964	D	119	6010	339	339150	Carlos Roberto Traub Gainsborg	CARLOS TRAUB	M	f	AP	CARLOS 	TRAUB
16361963	D	122	6010	366	366149	Gonzalo Winter Etcheberry	GONZALO WINTER	M	f	AR	GONZALO	WINTER
15959045	D	118	6010	339	339150	Camilo Antonio Cammas Brangier	CAMILO CAMMAS	M	f	AP	CAMILO	CAMMAS
8532482	D	123	6010	366	366149	Lorena Fries Monleon	LORENA FRIES	M	t	AR	LORENA	FRIES
18154964	D	130	6010	366	366045	Nicole Martinez Aranda	NICOLE MARTÍNEZ	M	f	AR	NICOLE	MARTÍNEZ
13343270	D	127	6010	366	366006	Manuel Andres Ahumada Letelier	MANUEL AHUMADA	M	f	AR	MANUEL	AHUMADA
13464133	D	128	6010	366	366006	Alejandra Francisca Placencia Cabello	ALEJANDRA PLACENCIA	M	f	AR	ALEJANDRA 	PLACENCIA
19567463	D	124	6010	366	366143	Emilia Schneider Videla	EMILIA SCHNEIDER	M	f	AR	EMILIA	SCHNEIDER
15324112	D	132	6010	350	350180	Ricardo Garcia-huidobro Andai	RICARDO GARCÍA-HUIDOBRO	M	f	AW	RICARDO	GARCÍA-HUIDOBRO
15266268	D	135	6010	350	350180	Gonzalo Andres Carrasco Curilem	GONZALO CARRASCO	M	t	AW	GONZALO 	CARRASCO
17034545	D	126	6010	366	366130	Maidy Ledy Velasquez Vera	MAIDY VELÁSQUEZ	M	t	AR	MAIDY	VELÁSQUEZ
5927229	D	129	6010	366	366045	Ramon Fernando Griffero Sanchez	RAMÓN GRIFFERO	M	f	AR	RAMÓN 	GRIFFERO
7817346	D	125	6010	366	366143	Rene Luis Naranjo Sotomayor	RENÉ NARANJO	M	t	AR	RENÉ	NARANJO
11415416	D	134	6010	350	350180	Paola Margarita Bernales Pantoja	PAOLA BERNALES	M	f	AW	PAOLA 	BERNALES
11833632	D	131	6010	350	350180	Alejandra Herrera Andreucci	ALEJANDRA HERRERA	M	f	AW	ALEJANDRA	HERRERA
17941710	D	136	6010	350	350180	Rodrigo Andres Cabezas Venegas	RODRIGO CABEZAS	M	f	AW	RODRIGO 	CABEZAS
11193952	D	140	6010	373	373139	Luis Alberto Castro Benavides	LUIS CASTRO	M	f	AY	LUIS 	CASTRO
13468568	D	139	6010	373	373139	Raul Alberto Villavicencio Maraboli	RAÚL VILLAVICENCIO	M	f	AY	RAÚL 	VILLAVICENCIO
12880709	D	138	6010	373	373139	Andrea Del Carmen Duarte Vidal	ANDREA DUARTE	M	f	AY	ANDREA	DUARTE
12821383	D	133	6010	350	350180	Lisit Sdelona Fernandez Menay	LISIT FERNÁNDEZ	M	f	AW	LISIT 	FERNÁNDEZ
7032986	D	137	6010	373	373139	Oriele Maria Eugenia Nuñez Serrano	ORIELE NÚÑEZ	M	f	AY	ORIELE	NÚÑEZ
12232369	D	61	6011	358	358003	Francisca Valdes Vigil	FRANCISCA VALDÉS	M	t	AA	FRANCISCA	VALDÉS
10336478	D	66	6011	358	358037	Francisco Undurraga Gazitua	FRANCISCO UNDURRAGA	M	f	AA	FRANCISCO	UNDURRAGA
10293616	D	62	6011	358	358001	Gonzalo Guillermo Fuenzalida Figueroa	GONZALO FUENZALIDA	M	f	AA	GONZALO 	FUENZALIDA
11736760	D	64	6011	358	358001	Karin Claudia Luck Urban	KARIN LUCK	M	f	AA	KARIN 	LUCK
13657451	D	60	6011	358	358003	Guillermo Ramirez Diez	GUILLERMO RAMÍREZ	M	f	AA	GUILLERMO	RAMÍREZ
15466653	D	68	6011	368	368157	David Rodrigo Elgueta Alvarez	DAVID ELGUETA	M	f	AB	DAVID 	ELGUETA
12071705	D	65	6011	358	358037	Luz Poblete Coddou	LUZ POBLETE	M	f	AA	LUZ	POBLETE
7072349	D	63	6011	358	358001	Catalina Del Real Mihovilovic	CATALINA DEL	M	f	AA	CATALINA	DEL REAL
13924988	D	71	6011	368	368157	Angel Rodrigo Rozas Diaz	ÁNGEL ROZAS	M	f	AB	ÁNGEL 	ROZAS
14469902	D	73	6011	371	371138	Ignacia Gomez Martinez	IGNACIA GÓMEZ	M	f	AH	IGNACIA	GÓMEZ
9978882	D	74	6011	371	371138	Darko Alexandar Peric Von Bergen	DARKO PERIC	M	f	AH	DARKO 	PERIC
15369137	D	75	6011	371	371002	Nicolas Preuss Herrera	NICOLÁS PREUSS	M	f	AH	NICOLÁS	PREUSS
15707598	D	72	6011	368	368157	Yerko Hernan Sepulveda Poblete	YERKO SEPÚLVEDA	M	f	AB	YERKO 	SEPÚLVEDA
13631352	D	70	6011	368	368157	Lorena Del Carmen Llamin Millalen	LORENA LLAMÍN	M	f	AB	LORENA 	LLAMÍN
16244695	D	67	6011	368	368157	Elizabeth Rodriguez Sierra	ELIZABETH RODRÍGUEZ	M	f	AB	ELIZABETH	RODRÍGUEZ
19316818	D	76	6011	371	371002	Irene Valentina Espinoza Tapia	IRENE ESPINOZA	M	t	AH	IRENE 	ESPINOZA
14174671	D	69	6011	368	368157	Heerman Paulo Vargas Hoger	HEERMAN VARGAS	M	f	AB	HEERMAN 	VARGAS
8419173	D	77	6011	371	371137	Liliana Muñoz Hernandez	LILIANA MUÑOZ	M	f	AH	LILIANA	MUÑOZ
16749553	D	80	6011	356	356142	Javier Wilden Acosta	JAVIER WILDEN	M	f	AL	JAVIER 	WILDEN
5203995	D	78	6011	371	371004	Abraham Albert Cohen Benadava	ABRAHAM COHEN	M	t	AH	ABRAHAM	COHEN
8740398	D	79	6011	371	371004	Graciela Aida Diaz Merubia	GRACIELA DÍAZ	M	t	AH	GRACIELA	DÍAZ
13154245	D	86	6011	347	347144	Alicia Karolina Cariqueo Naranjo	ALICIA CARIQUEO	M	f	AN	ALICIA 	CARIQUEO
10553034	D	84	6011	347	347008	Rene Omar Acuña Barrera	RENÉ ACUÑA	M	t	AN	RENÉ	ACUÑA
9604921	D	83	6011	347	347008	Susana Cordova Rodriguez	SUSANA CÓRDOVA	M	f	AN	SUSANA	CÓRDOVA
10307624	D	82	6011	347	347008	Nelson Nicolas Peña Gallardo	NELSON PEÑA	M	f	AN	NELSON	PEÑA
17779600	D	85	6011	347	347144	Fernando Enrique Martinez Vergara	FERNANDO MARTÍNEZ	M	f	AN	FERNANDO 	MARTÍNEZ
17082454	D	90	6011	339	339150	Cristian Araya Lerdo De Tejada	CRISTIÁN ARAYA	M	f	AP	CRISTIÁN	ARAYA
13260342	D	81	6011	347	347008	Catalina Valeska Valenzuela Maureira	CATALINA VALENZUELA	M	f	AN	CATALINA	VALENZUELA
7037855	D	89	6011	339	339150	Gonzalo Armando De La Carrera Correa	GONZALO DE	M	f	AP	GONZALO 	DE LA CARRERA
17408591	D	93	6011	339	339150	Gabriel Dominguez Valdes	GABRIEL DOMÍNGUEZ	M	t	AP	GABRIEL	DOMÍNGUEZ
19064106	D	87	6011	347	347144	Jacqueline Alejandra Cozza Viot	JACQUELINE COZZA	M	t	AN	JACQUELINE	COZZA
8674948	D	88	6011	339	339150	Christel Felmer Valdivielso	CHRISTEL FELMER	M	f	AP	CHRISTEL	FELMER
7842009	D	92	6011	339	339150	Christian Oscar Slater Escanilla	CHRISTIAN SLATER	M	t	AP	CHRISTIAN 	SLATER
6242582	D	95	6011	366	366143	Tomas Hirsch Goldschmidt	TOMÁS HIRSCH	M	t	AR	TOMÁS	HIRSCH
13830950	D	91	6011	339	339150	Martin Carvajal Masjuan	MARTÍN CARVAJAL	M	f	AP	MARTÍN 	CARVAJAL
15900261	D	100	6011	366	366149	Cristobal Andres Rodriguez Olivares	CRISTÓBAL RODRÍGUEZ	M	t	AR	CRISTÓBAL 	RODRÍGUEZ
16366992	D	97	6011	366	366045	Miguel Concha Manso	MIGUEL CONCHA	M	f	AR	MIGUEL	CONCHA
16666357	D	96	6011	366	366143	Marcela Cubillos Hevia	MARCELA CUBILLOS	M	t	AR	MARCELA	CUBILLOS
7011276	D	94	6011	339	339150	Pilar Ginesta Bascuñan	PILAR GINESTA	M	t	AP	PILAR	GINESTA
10848292	D	98	6011	366	366045	Daniela Francisca Lavarello Ramirez	DANIELA LAVARELLO	M	f	AR	DANIELA	LAVARELLO
15918139	D	101	6011	366	366006	Esteban Mauricio Chavez Rivera	ESTEBAN CHÁVEZ	M	t	AR	ESTEBAN 	CHÁVEZ
14096665	D	99	6011	366	366149	Grace Eugenia Schmidt Monje	GRACE SCHMIDT	M	f	AR	GRACE	SCHMIDT
19296656	D	102	6011	350	350180	Matias Andres Rosende Briceño	MATÍAS ROSENDE	M	f	AW	MATÍAS 	ROSENDE
15752128	D	105	6011	373	373139	Harlet Heisleben Probst Campodonico	HARLET PROBST	M	f	AY	HARLET 	PROBST
12667285	D	106	6011	373	373139	Hugo Marcelo Alvarez Villagra	HUGO ÁLVAREZ	M	f	AY	HUGO 	ÁLVAREZ
12123863	D	103	6011	350	350180	Claudia Andrea Torres Navarro	CLAUDIA TORRES	M	t	AW	CLAUDIA 	TORRES
10993733	D	104	6011	350	350180	Maria Loreto Allue Prieto	MARÍA ALLUE	M	t	AW	MARÍA 	ALLUE
13075587	D	62	6012	358	358001	Luis Alberto Tapia Bastias	LUIS TAPIA	M	f	AA	LUIS 	TAPIA
14494866	D	70	6012	368	368157	Pablo Andres Soto Zuñiga	PABLO SOTO	M	f	AB	PABLO 	SOTO
11224150	D	61	6012	358	358001	Claudia Del Pilar Faundez Fuentes	CLAUDIA FAÚNDEZ	M	f	AA	CLAUDIA 	FAÚNDEZ
13664701	D	68	6012	368	368157	Alejandra Pamela Jara Quiroz	ALEJANDRA JARA	M	f	AB	ALEJANDRA 	JARA
18077310	D	67	6012	358	358003	Francia Nicole Muñoz Donoso	FRANCIA MUÑOZ	M	f	AA	FRANCIA 	MUÑOZ
15485694	D	63	6012	358	358037	Hilda Fabiola Pino Bastias	HILDA PINO	M	t	AA	HILDA 	PINO
13836940	D	71	6012	368	368157	Leslie Judith Leiva Henriquez	LESLIE LEIVA	M	f	AB	LESLIE 	LEIVA
16724364	D	66	6012	358	358003	Camila Alejandra Medina Gaete	CAMILA MEDINA	M	t	AA	CAMILA 	MEDINA
15963832	D	72	6012	368	368157	Jaime Felipe Retamales Guzman	JAIME RETAMALES	M	f	AB	JAIME 	RETAMALES
16952392	D	74	6012	368	368157	Sergio Antonio Palma Briones	SERGIO PALMA	M	f	AB	SERGIO 	PALMA
13918345	D	64	6012	358	358003	Alvaro Carter Fernandez	ALVARO CARTER	M	t	AA	ALVARO	CARTER
7050861	D	65	6012	358	358003	Eulogia Lavin Infante	EULOGIA LAVÍN	M	f	AA	EULOGIA 	LAVÍN
10612011	D	78	6012	364	364135	Maria Isabel Margarita Martinez Lizama	MARÍA MARTÍNEZ	M	f	AE	MARÍA ISABEL	MARTÍNEZ
7002182	D	60	6012	358	358001	Ximena Ossandon Irarrazabal	XIMENA OSSANDÓN	M	f	AA	XIMENA	OSSANDÓN
16413984	D	75	6012	364	364135	Joseffe Tamara Caceres Torres	JOSEFFE CÁCERES	M	f	AE	JOSEFFE	CÁCERES
17385851	D	76	6012	364	364135	Camila Cristina Meza Herrera	CAMILA MEZA	M	f	AE	CAMILA 	MEZA
16521483	D	73	6012	368	368157	Gloria Evelyn Herrera Perez	GLORIA HERRERA	M	f	AB	GLORIA	HERRERA
12654485	D	81	6012	364	364135	Julio Enrique Hernandez Prado	JULIO HERNÁNDEZ	M	f	AE	JULIO 	HERNÁNDEZ
16521777	D	69	6012	368	368157	Sebastian Noe Gonzalez Donoso	SEBASTIÁN GONZÁLEZ	M	f	AB	SEBASTIÁN	GONZÁLEZ
16475884	D	80	6012	364	364135	Matias Antonio Morales Prado	MATÍAS MORALES	M	f	AE	MATÍAS 	MORALES
13071316	D	77	6012	364	364135	Johanna De Las Nieves Pacheco Curinao	JOHANNA PACHECO	M	f	AE	JOHANNA	PACHECO
17601824	D	83	6012	371	371138	Valeska Alejandra Concha Cisterna	VALESKA CONCHA	M	f	AH	VALESKA	CONCHA
8954861	D	84	6012	371	371137	Jaime Coloma Tirapegui	JAIME COLOMA	M	t	AH	JAIME	COLOMA
14090058	D	86	6012	371	371002	Carola Pia Naranjo Inostroza	CAROLA NARANJO	M	t	AH	CAROLA	NARANJO
20389740	D	79	6012	364	364135	Rodrigo Andres Lopez Jara	RODRIGO LÓPEZ	M	f	AE	RODRIGO 	LÓPEZ
17416140	D	82	6012	371	371138	Camilo Andre Bastias Flores	CAMILO BASTÍAS	M	f	AH	CAMILO 	BASTÍAS
19076836	D	90	6012	356	356142	Rocio Miranda Castillo	ROCÍO MIRANDA	M	f	AL	ROCÍO 	MIRANDA
7071393	D	92	6012	356	356142	Rebeca Tala Arnechino	REBECA TALA	M	f	AL	REBECA 	TALA
11393926	D	88	6012	371	371005	Rodrigo Angulo Santander	RODRIGO ANGULO	M	f	AH	RODRIGO	ANGULO
11317694	D	89	6012	371	371005	Romanina Morales Baltra	ROMANINA MORALES	M	f	AH	ROMANINA	MORALES
13082011	D	85	6012	371	371007	Flor Del Carmen Aleñir Millanao	FLOR ALEÑIR	M	f	AH	FLOR	ALEÑIR
14188439	D	87	6012	371	371004	Paz Andrea Suarez Briones	PAZ SUÁREZ	M	f	AH	PAZ 	SUÁREZ
8516383	D	116	6012	339	339150	Catalina Chappuzeau Lopez	CATALINA CHAPPUZEAU	M	f	AP	CATALINA	CHAPPUZEAU
7813764	D	114	6012	339	339150	Marcela Paz Diaz De Valdes Balbontin	MARCELA DÍAZ	M	f	AP	MARCELA 	DÍAZ DE VALDÉS
12472435	D	95	6012	356	356142	Ruben Rosales Sepulveda	RÚBEN ROSALES	M	f	AL	RÚBEN 	ROSALES
15517499	D	94	6012	356	356142	Monserrat Candia Rocha	MONSERRAT CANDIA	M	f	AL	MONSERRAT	CANDIA
8829179	D	103	6012	374	374147	Jorge Manuel Palma Acuña	JORGE PALMA	M	f	AM	JORGE 	PALMA
22601928	D	99	6012	374	374147	Juana Estefania Lincolao Lincheo	JUANA LINCOLAO	M	f	AM	JUANA 	LINCOLAO
18670544	D	96	6012	356	356142	Ronald Vargas Diaz	RONALD VARGAS	M	f	AL	RONALD 	VARGAS
19033987	D	121	6012	366	366006	Daniela Andrea Serrano Salazar	DANIELA SERRANO	M	f	AR	DANIELA 	SERRANO
13901617	D	123	6012	366	366006	Fernando Andres Monsalve Arias	FERNANDO MONSALVE	M	f	AR	FERNANDO	MONSALVE
17177843	D	98	6012	374	374147	Cesar Andres Retamal Monsalves	CÉSAR RETAMAL	M	f	AM	CÉSAR 	RETAMAL
10459364	D	112	6012	339	339150	Patricio Muñoz Cardenas	PATRICIO MUÑOZ	M	f	AP	PATRICIO	MUÑOZ
17101321	D	105	6012	347	347008	Barbara Bustos Osorio	BÁRBARA BUSTOS	M	f	AN	BÁRBARA	BUSTOS
13441660	D	117	6012	339	339150	Maximiliano Eduardo Murath Mansilla	MAXIMILIANO MURATH	M	t	AP	MAXIMILIANO 	MURATH
8703424	D	100	6012	374	374147	Luis Eduardo Arriaza Villalon	LUIS ARRIAZA	M	f	AM	LUIS 	ARRIAZA
12275987	D	102	6012	374	374147	Alejandro Albercio Jeldres Morales	ALEJANDRO JELDRES	M	f	AM	ALEJANDRO	JELDRES
17485215	D	97	6012	374	374147	Sara Aida Miranda Silva	SARA MIRANDA	M	f	AM	SARA 	MIRANDA
9474646	D	91	6012	356	356142	Allyson Richasse Rubio	ALLYSON RICHASSE	M	f	AL	ALLYSON 	RICHASSE
16409235	D	109	6012	347	347144	Franchesca Caroline Hernandez Veliz	FRANCHESCA HERNÁNDEZ	M	f	AN	FRANCHESCA 	HERNÁNDEZ
18665236	D	101	6012	374	374147	Paula Ignacia Cea Fuentes	PAULA CEA	M	f	AM	PAULA	CEA
8938954	D	104	6012	347	347008	Pamela Jiles Moreno	PAMELA JILES	M	f	AN	PAMELA	JILES
17088026	D	115	6012	339	339150	Francisca Rodriguez Gonzalez	FRANCISCA RODRÍGUEZ	M	f	AP	FRANCISCA	RODRÍGUEZ
16372175	D	107	6012	347	347008	Monica Tamara Arce Castro	MÓNICA ARCE	M	t	AN	MÓNICA 	ARCE
8347004	D	106	6012	347	347008	Hernan Palma Perez	HERNÁN PALMA	M	f	AN	HERNÁN	PALMA
9388497	D	113	6012	339	339150	Gabriel Antonio Gatica Sotomayor	GABRIEL GATICA	M	f	AP	GABRIEL 	GATICA
12467947	D	93	6012	356	356142	Ximena Salinas Gonzalez	XIMENA SALINAS	M	f	AL	XIMENA 	SALINAS
13069042	D	127	6012	350	350180	Carmina Ivonne Farah Rodriguez	CARMINA FARAH	M	f	AW	CARMINA 	FARAH
14145184	D	128	6012	350	350180	Claus Handwerck Feliu	CLAUS HANDWERCK	M	f	AW	CLAUS	HANDWERCK
6242522	D	122	6012	366	366006	Amaro Jamil Jesus Labra Sepulveda	AMARO LABRA	M	f	AR	AMARO 	LABRA
16472473	D	126	6012	366	366149	Camila Arenas Castillo	CAMILA ARENAS	M	f	AR	CAMILA	ARENAS
13472416	D	118	6012	339	339150	Catherine Eugenia Cebulj Navarrete	CATHERINE CEBULJ	M	t	AP	CATHERINE 	CEBULJ
17484728	D	110	6012	347	347144	Camila Vanessa Cartes Cordero	CAMILA CARTES	M	t	AN	CAMILA 	CARTES
15336903	D	119	6012	339	339150	Macarena Alejandra Fernandez Nuñez	MACARENA FERNÁNDEZ	M	t	AP	MACARENA 	FERNÁNDEZ
16426891	D	125	6012	366	366149	Alexander Oliver Salin Espinoza	ALEXANDER SALIN	M	f	AR	ALEXANDER 	SALIN
16080270	D	120	6012	366	366045	Miguel Crispi Serrano	MIGUEL CRISPI	M	f	AR	MIGUEL	CRISPI
9516370	D	111	6012	347	347144	Ricardo Inalef Mora	RICARDO INALEF	M	t	AN	RICARDO	INALEF
17414523	D	108	6012	347	347144	Matias Jair Toledo Herrera	MATÍAS TOLEDO	M	f	AN	MATÍAS 	TOLEDO
7032055	D	124	6012	366	366143	Ana Maria Gazmuri Vieira	ANA GAZMURI	M	t	AR	ANA MARÍA	GAZMURI
17313017	D	129	6012	350	350180	Maria Jose Torres Barrientos	MARÍA TORRES	M	f	AW	MARÍA JOSÉ	TORRES
8475286	D	130	6012	373	373139	Luis Adolfo Jimenez Valderrama	LUIS JIMÉNEZ	M	f	AY	LUIS 	JIMÉNEZ
8523691	D	60	6013	358	358003	Cristhian Moreira Barros	CRISTHIAN MOREIRA	M	f	AA	CRISTHIAN	MOREIRA
12637044	D	62	6013	358	358003	Fabiola Del Socorro Rodriguez Parada	FABIOLA RODRÍGUEZ	M	f	AA	FABIOLA 	RODRÍGUEZ
14395605	D	68	6013	368	368157	Ricardo Alberto Alegria Abarca	RICARDO ALEGRÍA	M	f	AB	RICARDO 	ALEGRÍA
12261393	D	63	6013	358	358001	Eduardo Duran Salinas	EDUARDO DURÁN	M	f	AA	EDUARDO	DURÁN
13708306	D	66	6013	368	368157	Frank Winston Grobier Mella	FRANK GROBIER	M	f	AB	FRANK	GROBIER
16069789	D	64	6013	358	358001	Cristobal Saavedra Alarcon	CRISTÓBAL SAAVEDRA	M	f	AA	CRISTÓBAL	SAAVEDRA
17952087	D	70	6013	368	368157	Tamara Alejandra Ramirez Ramirez	TAMARA RAMÍREZ	M	f	AB	TAMARA 	RAMÍREZ
9024616	D	61	6013	358	358003	Luis Silva Irarrazaval	LUIS SILVA	M	t	AA	LUIS	SILVA
18311494	D	65	6013	358	358001	Susana Salime Hiplan Esteffan	SUSANA HIPLAN	M	f	AA	SUSANA	HIPLAN
16558254	D	73	6013	364	364135	Kevin Andres Bustamante Alamos	KEVIN BUSTAMANTE	M	f	AE	KEVIN 	BUSTAMANTE
18499694	D	75	6013	364	364135	Cristobal Eduardo Espinoza Tobar	CRISTÓBAL ESPINOZA	M	f	AE	CRISTÓBAL 	ESPINOZA
15339233	D	79	6013	371	371137	Nicolas Emilio Freire Castello	NICOLÁS FREIRE	M	t	AH	NICOLÁS 	FREIRE
16561203	D	69	6013	368	368157	Daniela Margarita Esmeralda Riquelme Perez	DANIELA RIQUELME	M	f	AB	DANIELA 	RIQUELME
17775726	D	78	6013	371	371004	Camila Bruna Faundes	CAMILA BRUNA	M	f	AH	CAMILA	BRUNA
16186073	D	67	6013	368	368157	Jeannette Ivonne Medel Quilodran	JEANNETTE MEDEL	M	f	AB	JEANNETTE 	MEDEL
16926106	D	77	6013	364	364135	Alvaro Andres Perez Jorquera	ÁLVARO PÉREZ	M	f	AE	ÁLVARO 	PÉREZ
12356835	D	71	6013	368	368157	Carlos Saul Valenzuela Villar	CARLOS VALENZUELA	M	f	AB	CARLOS 	VALENZUELA
18731567	D	74	6013	364	364135	Suely Cileidi Arancibia Benicio	SUELY ARANCIBIA	M	f	AE	SUELY 	ARANCIBIA
13709927	D	81	6013	371	371005	Daniel Melo Contreras	DANIEL MELO	M	f	AH	DANIEL	MELO
11798402	D	83	6013	356	356142	Irma Perez Llanquin	IRMA PÉREZ	M	f	AL	IRMA	PÉREZ
14003303	D	80	6013	371	371138	Carolina Andrea Flores Marin	CAROLINA FLORES	M	t	AH	CAROLINA 	FLORES
12863183	D	89	6013	374	374147	Josue Albert Ormazabal Morales	JOSUE ORMAZABAL	M	f	AM	JOSUE 	ORMAZABAL
17601881	D	76	6013	364	364135	Anita Paz Jaramillo Gallardo	ANITA JARAMILLO	M	f	AE	ANITA 	JARAMILLO
18277128	D	85	6013	356	356142	Mariana Sandoval Llancafil	MARIANA SANDOVAL	M	f	AL	MARIANA 	SANDOVAL
16475001	D	82	6013	371	371002	Lorenzo Bascuñan Hevia	LORENZO BASCUÑÁN	M	f	AH	LORENZO	BASCUÑÁN
9255691	D	88	6013	356	356142	Facundo Miro Tapia	FACUNDO MIRO	M	f	AL	FACUNDO	MIRO
17401764	D	72	6013	364	364135	Valeria Paz Yañez Alvarez	VALERIA YÁÑEZ	M	f	AE	VALERIA 	YÁÑEZ
13682249	D	87	6013	356	356142	Marcelo Olivares Figueroa	MARCELO OLIVARES	M	f	AL	MARCELO	OLIVARES
13714434	D	84	6013	356	356142	Walter Muñoz Gutierrez	WALTER MUÑOZ	M	f	AL	WALTER 	MUÑOZ
17283787	D	94	6013	347	347144	Miguel Andres Villanueva Garrido	MIGUEL VILLANUEVA	M	t	AN	MIGUEL 	VILLANUEVA
14152809	D	86	6013	356	356142	Daniel Sanchez Huañaco	DANIEL SÁNCHEZ	M	f	AL	DANIEL 	SÁNCHEZ
19701257	D	91	6013	374	374147	Maria Valentina Cofre Reyes	MARÍA COFRÉ	M	f	AM	MARÍA VALENTINA 	COFRÉ
10180846	D	93	6013	347	347144	Julio Oliva Garcia	JULIO OLIVA	M	t	AN	JULIO	OLIVA
11606032	D	90	6013	374	374147	Churi Meira Marambio	CHURI MEIRA	M	f	AM	CHURI	MEIRA
9001813	D	92	6013	347	347144	Veronica Molina Retamal	VERÓNICA MOLINA	M	f	AN	VERÓNICA	MOLINA
18055243	D	95	6013	347	347144	Nicolas Martinez Benimelis	NICOLÁS MARTÍNEZ	M	t	AN	NICOLÁS	MARTÍNEZ
17107936	D	98	6013	366	366149	Gael Fernanda Yeomans Araya	GAEL YEOMANS	M	f	AR	GAEL 	YEOMANS
12461538	D	96	6013	347	347008	Leonel Ruben Jaramillo Coumerme	LEONEL JARAMILLO	M	f	AN	LEONEL 	JARAMILLO
9120645	D	97	6013	347	347008	Juan Eduardo Baeza Carrasco	JUAN BAEZA	M	t	AN	JUAN EDUARDO	BAEZA
12831608	D	104	6013	350	350180	Maria Elena Balcazar Quinteros	MARÍA BALCAZAR	M	f	AW	MARÍA ELENA	BALCAZAR
10434621	D	102	6013	366	366006	Lorena Pizarro Sierra	LORENA PIZARRO	M	f	AR	LORENA	PIZARRO
19039479	D	100	6013	366	366143	Antonio Ignacio Saavedra Gutierrez	ANTONIO SAAVEDRA	M	t	AR	ANTONIO 	SAAVEDRA
17319144	D	105	6013	373	373139	Jaime Antonio Galaz Guzman	JAIME GALAZ	M	f	AY	JAIME 	GALAZ
18443137	D	99	6013	366	366149	Jaime Antonio Fuentes Purran	JAIME FUENTES	M	f	AR	JAIME 	FUENTES
16191607	D	101	6013	366	366006	Luis Lobos Meza	LUIS LOBOS	M	f	AR	LUIS	LOBOS
7476735	D	103	6013	366	366130	Pilar Farfan Villagra	PILAR FARFÁN	M	f	AR	PILAR	FARFÁN
13829856	D	60	6014	358	358003	Juan Antonio Coloma Alamos	JUAN COLOMA	M	f	AA	JUAN ANTONIO	COLOMA
16099521	D	61	6014	358	358003	Sofia Rengifo Ottone	SOFIA RENGIFO	M	t	AA	SOFIA	RENGIFO
17312272	D	66	6014	358	358001	Henry Christopher Boys Loeb	HENRY BOYS	M	t	AA	HENRY 	BOYS
15962445	D	63	6014	358	358003	Nataly Valeska Finlez Zarate	NATALY FINLEZ	M	t	AA	NATALY	FINLEZ
15939025	D	67	6014	368	368157	Gonzalo Enrique Ward Garfias	GONZALO WARD	M	f	AB	GONZALO 	WARD
14199789	D	69	6014	368	368157	Felipe Andres Castillo Soto	FELIPE CASTILLO	M	f	AB	FELIPE 	CASTILLO
15320994	D	65	6014	358	358001	Alejandra Novoa Sandoval	ALEJANDRA NOVOA	M	f	AA	ALEJANDRA	NOVOA
9693986	D	70	6014	368	368157	Maria Trinidad Araya Ortega	MARÍA ARAYA	M	f	AB	MARÍA TRINIDAD	ARAYA
13341720	D	62	6014	358	358003	Myrtha Garate Martinez	MYRTHA GÁRATE	M	t	AA	MYRTHA	GÁRATE
9480115	D	68	6014	368	368157	Leticia Del Carmen Zuñiga Silva	LETICIA ZÚÑIGA	M	f	AB	LETICIA 	ZÚÑIGA
16956466	D	76	6014	371	371002	Camila Ignacia Briceño Carrasco	CAMILA BRICEÑO	M	f	AH	CAMILA	BRICEÑO
16172689	D	64	6014	358	358001	Tomas Fuentes Barros	TOMÁS FUENTES	M	f	AA	TOMÁS	FUENTES
14377036	D	73	6014	368	368157	Ricardo Eliecer Nuñez Martinez	RICARDO NÚÑEZ	M	f	AB	RICARDO 	NÚÑEZ
16665760	D	77	6014	371	371002	Ronald Eduardo Perez Cuevas	RONALD PÉREZ	M	t	AH	RONALD 	PÉREZ
6966361	D	71	6014	368	368157	Juan Alberto Mena Jil	JUAN MENA	M	f	AB	JUAN 	MENA
15448304	D	72	6014	368	368157	Sandra Paz Martinez Rubio	SANDRA MARTÍNEZ	M	f	AB	SANDRA 	MARTÍNEZ
12636469	D	74	6014	371	371005	Raul Leiva Carvajal	RAÚL LEIVA	M	f	AH	RAÚL	LEIVA
10494796	D	75	6014	371	371005	Leonardo Soto Ferrada	LEONARDO SOTO	M	f	AH	LEONARDO 	SOTO
16558470	D	79	6014	371	371007	Juan Pablo Rivera Gonzalez	JUAN RIVERA	M	f	AH	JUAN PABLO	RIVERA
16296716	D	81	6014	356	356142	Andres Bocaz Chacon	ANDRÉS BOCAZ	M	f	AL	ANDRÉS	BOCAZ
16571501	D	80	6014	356	356142	Patricio Rubio Garcia	PATRICIO RUBIO	M	f	AL	PATRICIO	RUBIO
16913433	D	84	6014	347	347144	Josefa Faundez Espinoza	JOSEFA FAÚNDEZ	M	t	AN	JOSEFA	FAÚNDEZ
12063472	D	78	6014	371	371007	Claudia Cristina Acevedo Morales	CLAUDIA ACEVEDO	M	t	AH	CLAUDIA 	ACEVEDO
15636809	D	90	6014	339	339150	Juan Irarrazaval Rossel	JUAN IRARRÁZAVAL	M	f	AP	JUAN	IRARRÁZAVAL
14476154	D	83	6014	347	347144	Francisco Valdes Reyes	FRANCISCO VALDÉS	M	f	AN	FRANCISCO	VALDÉS
16416351	D	82	6014	356	356142	Eduardo Garcia Urzua	EDUARDO GARCÍA	M	f	AL	EDUARDO 	GARCÍA
5995741	D	88	6014	347	347008	Javier Adrian Gonzalez Vergara	JAVIER GONZÁLEZ	M	f	AN	JAVIER 	GONZÁLEZ
9855326	D	87	6014	347	347008	Juan Domingo Villavicencio Pasten	JUAN VILLAVICENCIO	M	f	AN	JUAN DOMINGO	VILLAVICENCIO
14186722	D	86	6014	347	347144	Carolina Santis Gonzalez	CAROLINA SANTIS	M	t	AN	CAROLINA	SANTIS
14173177	D	85	6014	347	347144	Elizabeth Rojas Huenupe	ELIZABETH ROJAS	M	t	AN	ELIZABETH	ROJAS
17590387	D	93	6014	339	339150	Tabita Sarai Silva Leiva	TABITA SILVA	M	f	AP	TABITA	SILVA
12073716	D	89	6014	347	347008	Eduardo Andres Alvarado Espina	EDUARDO ALVARADO	M	t	AN	EDUARDO 	ALVARADO
7644495	D	96	6014	339	339150	Patricio Eduardo Hasbun Charad	PATRICIO HASBÚN	M	t	AP	PATRICIO 	HASBÚN
12585604	D	95	6014	339	339150	Hugo Alejandro Vallejos Landeros	HUGO VALLEJOS	M	t	AP	HUGO 	VALLEJOS
8072265	D	91	6014	339	339150	Cristobal Orrego Sanchez	CRISTÓBAL ORREGO	M	f	AP	CRISTÓBAL	ORREGO
12021238	D	94	6014	339	339150	Pamela Mariana Cordero Avaria	PAMELA CORDERO	M	t	AP	PAMELA 	CORDERO
19954462	D	99	6014	366	366149	Alondra Caterina Libertad Arellano Hernandez	ALONDRA ARELLANO	M	f	AR	ALONDRA 	ARELLANO
12880575	D	97	6014	366	366006	Marisela Santibañez Novoa	MARISELA SANTIBAÑEZ	M	f	AR	MARISELA	SANTIBAÑEZ
13197709	D	92	6014	339	339150	Andrea Rosario Iñiguez Manso	ANDREA IÑIGUEZ	M	f	AP	ANDREA 	IÑIGUEZ
7435205	D	102	6014	366	366045	Luis Eduardo Henriquez Flores	LUIS HENRÍQUEZ	M	t	AR	LUIS 	HENRÍQUEZ
13210810	D	101	6014	366	366045	Marcela Sandoval Osorio	MARCELA SANDOVAL	M	f	AR	MARCELA	SANDOVAL
18497050	D	100	6014	366	366149	Alena Maria Gutierrez Moreno	ALENA GUTIÉRREZ	M	f	AR	ALENA	GUTIÉRREZ
17511860	D	98	6014	366	366143	Camila Fernanda Musante Muller	CAMILA MUSANTE	M	t	AR	CAMILA 	MUSANTE
16415312	D	105	6014	350	350180	Dynko Hanz Kother Valdivia	DYNKO KOTHER	M	f	AW	DYNKO	KOTHER
16149037	D	103	6014	350	350180	Shirley Fabiola Leiva Catalan	SHIRLEY LEIVA	M	f	AW	SHIRLEY	LEIVA
16360809	D	104	6014	350	350180	Felipe Andres Corvalan Destefani	FELIPE CORVALÁN	M	t	AW	FELIPE 	CORVALÁN
10912296	D	106	6014	373	373139	Marcia Del Carmen Millaqueo Ibarra	MARCIA MILLAQUEO	M	f	AY	MARCIA	MILLAQUEO
11656814	D	61	6015	358	358001	Johanna Mariechen Olivares Gribbell	JOHANNA OLIVARES	M	f	AA	JOHANNA 	OLIVARES
15994889	D	64	6015	358	358003	Natalia Romero Talguia	NATALIA ROMERO	M	t	AA	NATALIA	ROMERO
16095240	D	60	6015	358	358001	Diego Ignacio Schalper Sepulveda	DIEGO SCHALPER	M	f	AA	DIEGO	SCHALPER
10292651	D	67	6015	368	368157	Alejandra Carreño Perez	ALEJANDRA CARREÑO	M	f	AB	ALEJANDRA	CARREÑO
13947598	D	65	6015	358	358003	Juan Masferrer Vidal	JUAN MASFERRER	M	f	AA	JUAN 	MASFERRER
17025988	D	70	6015	368	368157	Eduardo Rodrigo Galvez Cancino	EDUARDO GÁLVEZ	M	f	AB	EDUARDO 	GÁLVEZ
20029855	D	69	6015	368	368157	Lindsey Marisol Pavez Tapia	LINDSEY PAVEZ	M	f	AB	LINDSEY 	PAVEZ
8238451	D	63	6015	358	358003	Jose Miguel Urrutia Celis	JOSÉ URRUTIA	M	f	AA	JOSÉ MIGUEL	URRUTIA
8720021	D	66	6015	368	368157	Fabricio Venegas Olivares	FABRICIO VENEGAS	M	f	AB	FABRICIO	VENEGAS
12913235	D	62	6015	358	358001	Ivonne Ulrike Mangelsdorff Galeb	IVONNE MANGELSDORFF	M	f	AA	IVONNE 	MANGELSDORFF
13030499	D	71	6015	371	371005	Natalia Sanchez Aceituno	NATALIA SÁNCHEZ	M	f	AH	NATALIA 	SÁNCHEZ
16796467	D	68	6015	368	368157	Cristopher Sebastian Ahumada Espinoza	CRISTOPHER AHUMADA	M	f	AB	CRISTOPHER	AHUMADA
16846502	D	76	6015	371	371004	Raul Soto Mardones	RAÚL SOTO	M	f	AH	RAÚL	SOTO
9324917	D	73	6015	371	371007	Carlos Ortega Aedo	CARLOS ORTEGA	M	t	AH	CARLOS	ORTEGA
6184882	D	72	6015	371	371005	Felipe Letelier Norambuena	FELIPE LETELIER	M	t	AH	FELIPE	LETELIER
15633875	D	74	6015	371	371002	Mario Augusto Ogaz Orellana	MARIO OGAZ	M	f	AH	MARIO 	OGAZ
11671670	D	79	6015	356	356142	Carlos Miranda Muñoz	CARLOS MIRANDA	M	f	AL	CARLOS 	MIRANDA
10428754	D	78	6015	356	356142	Carolina Fernandez Gonzalez	CAROLINA FERNÁNDEZ	M	f	AL	CAROLINA 	FERNÁNDEZ
10089272	D	83	6015	339	339150	Fuad Hamed Sleman	FUAD HAMED	M	t	AP	FUAD	HAMED
13942790	D	75	6015	371	371004	Marta America Gonzalez Olea	MARTA GONZÁLEZ	M	t	AH	MARTA	GONZÁLEZ
18104300	D	81	6015	339	339150	Ignacio Patricio Vidal Rivers	IGNACIO VIDAL	M	f	AP	IGNACIO 	VIDAL
17344659	D	77	6015	356	356142	Jorge Bustos Mellado	JORGE BUSTOS	M	f	AL	JORGE	BUSTOS
20170453	D	80	6015	374	374147	Vicente Andres Rojas Arancibia	VICENTE ROJAS	M	f	AM	VICENTE 	ROJAS
10403644	D	84	6015	339	339150	Alex Orlando Brucher Hermosilla	ALEX BRUCHER	M	t	AP	ALEX	BRUCHER
16494517	D	82	6015	339	339150	Pablo Sanchez Marquez	PABLO SÁNCHEZ	M	f	AP	PABLO	SÁNCHEZ
8302925	D	87	6015	366	366130	Roberto Villagra Reyes	ROBERTO VILLAGRA	M	t	AR	ROBERTO	VILLAGRA
12962193	D	89	6015	366	366149	Patricia Andrea Torrealba Pino	PATRICIA TORREALBA	M	t	AR	PATRICIA 	TORREALBA
12515467	D	88	6015	366	366149	Marcela Patricia Riquelme Aliaga	MARCELA RIQUELME	M	t	AR	MARCELA 	RIQUELME
15343651	D	91	6015	366	366143	Yerko Edvard Scheihing Sepulveda	YERKO SCHEIHING	M	t	AR	YERKO	SCHEIHING
15384280	D	85	6015	339	339150	Francisca Maria Prieto Alcalde	FRANCISCA PRIETO	M	t	AP	FRANCISCA 	PRIETO
10385330	D	86	6015	366	366130	Hugo Boza Valdenegro	HUGO BOZA	M	f	AR	HUGO 	BOZA
17139066	D	90	6015	366	366006	Raisa Tamara Martinez Muñoz	RAISA MARTÍNEZ	M	f	AR	RAISA 	MARTÍNEZ
17333313	D	93	6015	373	373139	Francisco Javier Baeza Leiva	FRANCISCO BAEZA	M	f	AY	FRANCISCO	BAEZA
13296778	D	92	6015	350	350180	Mercedes Elena Escalona Paredes	MERCEDES ESCALONA	M	f	AW	MERCEDES 	ESCALONA
13302874	D	60	6016	358	358001	Carla Andrea Morales Maldonado	CARLA MORALES	M	f	AA	CARLA 	MORALES
17265538	D	61	6016	358	358001	Juan De Dios Valdivieso Tagle	JUAN VALDIVIESO	M	t	AA	JUAN 	VALDIVIESO
10563334	D	63	6016	358	358003	Julio Diego Ibarra Maldonado	JULIO IBARRA	M	t	AA	JULIO	IBARRA
12248730	D	62	6016	358	358003	Eduardo Cornejo Lagos	EDUARDO CORNEJO	M	f	AA	EDUARDO 	CORNEJO
9802060	D	65	6016	368	368157	Jose Antonio Carvallo Castro	JOSÉ CARVALLO	M	f	AB	JOSÉ ANTONIO	CARVALLO
11278401	D	64	6016	358	358003	Maria Ignacia Castro Rojas	MARÍA CASTRO	M	f	AA	MARÍA IGNACIA	CASTRO
8805246	D	68	6016	371	371005	Carolina Cucumides Calderon	CAROLINA CUCUMIDES	M	t	AH	CAROLINA 	CUCUMIDES
14473936	D	71	6016	374	374147	Gonzalo Del Carmen Rubio Fuenzalida	GONZALO RUBIO	M	f	AM	GONZALO 	RUBIO
16835296	D	66	6016	368	368157	Catalina Beatriz Diaz Henriquez	CATALINA DIAZ	M	f	AB	CATALINA 	DIAZ
8373795	D	67	6016	371	371007	Cosme Mellado Pino	COSME MELLADO	M	f	AH	COSME	MELLADO
10234553	D	72	6016	339	339150	Matias Jose Del Real Richasse	MATÍAS DEL	M	f	AP	MATÍAS 	DEL REAL
15915997	D	70	6016	371	371004	Maria Jose Diaz Becerra	MARÍA DÍAZ	M	t	AH	MARÍA JOSÉ	DÍAZ
11275752	D	69	6016	371	371002	Bernardo Cornejo Ceron	BERNARDO CORNEJO	M	f	AH	BERNARDO	CORNEJO
13686203	D	73	6016	339	339150	Fabiola Torres Farias	FABIOLA TORRES	M	f	AP	FABIOLA	TORRES
13435266	D	74	6016	339	339150	Alejandro Rogers Bozzolo	ALEJANDRO ROGERS	M	f	AP	ALEJANDRO	ROGERS
15340106	D	76	6016	339	339150	Valeria Beatriz Fanny Arancibia Luco	VALERIA ARANCIBIA	M	t	AP	VALERIA	ARANCIBIA
10457976	D	75	6016	339	339150	Mauricio Rene Ramirez Donders	MAURICIO RAMÍREZ	M	t	AP	MAURICIO 	RAMÍREZ
17747506	D	80	6016	366	366006	Iancu Andres Cordescu Donoso	IANCU CORDESCU	M	t	AR	IANCU	CORDESCU
14516997	D	78	6016	366	366130	Ximena Maril Pilquiman	XIMENA MARIL	M	f	AR	XIMENA	MARIL
8842714	D	79	6016	366	366006	Rodrigo Ivan Cordova Seguel	RODRIGO CORDOVA	M	f	AR	RODRIGO 	CORDOVA
12413484	D	77	6016	366	366130	Felix Bugueño Sotelo	FELIX BUGUEÑO	M	f	AR	FELIX	BUGUEÑO
18616466	D	82	6016	350	350180	Matias Jesus Sanchez Diaz	MATÍAS SÁNCHEZ	M	t	AW	MATÍAS 	SÁNCHEZ
10101720	D	81	6016	366	366143	Paola Maria Villegas Delgado	PAOLA VILLEGAS	M	t	AR	PAOLA 	VILLEGAS
9192013	D	83	6016	350	350180	Hugo Del Carmen Arias Gonzalez	HUGO ARIAS	M	f	AW	HUGO	ARIAS
11812503	D	86	6016	999	99	Yasna Zavalla Morales	YASNA ZAVALLA	M	t	ZZZ	YASNA	ZAVALLA
17266672	D	84	6016	350	350180	Andrea Bernardita Flores Calderon	ANDREA FLORES	M	f	AW	ANDREA 	FLORES
12028790	D	85	6016	373	373139	Mauricio Andres Vidal Leyton	MAURICIO VIDAL	M	f	AY	MAURICIO 	VIDAL
14154796	D	66	6017	358	358001	Yazna Maria Barrera Cesareo	YAZNA BARRERA	M	t	AA	YAZNA	BARRERA
16017470	D	60	6017	358	358037	Jorge Guzman Zepeda	JORGE GUZMÁN	M	f	AA	JORGE 	GUZMÁN
16008078	D	61	6017	358	358037	Pablo Ignacio Verdugo Vergara	PABLO VERDUGO	M	t	AA	PABLO 	VERDUGO
17930535	D	68	6017	368	368157	Nicolas Francisco Aguilera Fernandez	NICOLÁS AGUILERA	M	f	AB	NICOLÁS	AGUILERA
15126874	D	71	6017	368	368157	Viviana De Las Mercedes Rodriguez Saavedra	VIVIANA RODRÍGUEZ	M	f	AB	VIVIANA 	RODRÍGUEZ
17267440	D	64	6017	358	358003	Felipe Valdovinos Rodriguez	FELIPE VALDOVINOS	M	f	AA	FELIPE	VALDOVINOS
12417615	D	65	6017	358	358001	Hugo Rey Martinez	HUGO REY	M	f	AA	HUGO	REY
15138645	D	70	6017	368	368157	Pedro Alvaro Alonso Herrera Vergara	PEDRO HERRERA	M	f	AB	PEDRO 	HERRERA
7007198	D	67	6017	358	358001	Pablo Samuel Prieto Lorca	PABLO PRIETO	M	t	AA	PABLO 	PRIETO
15136478	D	62	6017	358	358003	Felipe Donoso Castro	FELIPE DONOSO	M	f	AA	FELIPE	DONOSO
16590320	D	63	6017	358	358003	Maria Paz Muñoz Solis	MARÍA MUÑOZ	M	f	AA	MARÍA PAZ	MUÑOZ
9186798	D	73	6017	371	371002	Gerardo Muñoz Riquelme	GERARDO MUÑOZ	M	f	AH	GERARDO	MUÑOZ
13838211	D	72	6017	368	368157	Abraham Eliseo Ortiz Orellana	ABRAHAM ORTIZ	M	f	AB	ABRAHAM 	ORTIZ
17255073	D	69	6017	368	368157	Madison Waleska Miranda Cea	MADISON MIRANDA	M	f	AB	MADISON 	MIRANDA
10589587	D	74	6017	371	371002	Maria Elena Villagran Paredes	MARÍA VILLAGRÁN	M	f	AH	MARÍA ELENA	VILLAGRÁN
10200271	D	75	6017	371	371007	Alexis Sepulveda Soto	ALEXIS SEPULVEDA	M	f	AH	ALEXIS	SEPULVEDA
16298891	D	76	6017	371	371007	Angelica Velasquez Perez	ANGÉLICA VELÁSQUEZ	M	t	AH	ANGÉLICA 	VELÁSQUEZ
14325541	D	79	6017	371	371005	Boris Duran Reyes	BORIS DURÁN	M	f	AH	BORIS 	DURÁN
12082968	D	82	6017	347	347008	Carlos Alonso Diaz Rojas	CARLOS DÍAZ	M	f	AN	CARLOS 	DÍAZ
6794384	D	80	6017	371	371005	Carlos Soto Gutierrez	CARLOS SOTO	M	f	AH	CARLOS	SOTO
14470727	D	90	6017	339	339150	Juan Carlos Vidaurrazaga Gonzalez	JUAN VIDAURRAZAGA	M	f	AP	JUAN CARLOS	VIDAURRAZAGA
11438429	D	77	6017	371	371138	Claudio Andres Reyes Gonzalez	CLAUDIO REYES	M	t	AH	CLAUDIO 	REYES
16456657	D	86	6017	347	347144	Andrea Valeska Berrios Valenzuela	ANDREA BERRIOS	M	t	AN	ANDREA	BERRIOS
8804212	D	92	6017	339	339150	Rosanna Maria Garcia Chevecich	ROSANNA GARCÍA	M	t	AP	ROSANNA 	GARCÍA
5374133	D	83	6017	347	347008	Victor Benedicto Miranda Marin	VÍCTOR MIRANDA	M	f	AN	VÍCTOR 	MIRANDA
13108039	D	78	6017	371	371138	Mauricio Andres Aguilera Muñoz	MAURICIO AGUILERA	M	f	AH	MAURICIO	AGUILERA
13788225	D	81	6017	347	347008	Paola Rossana Espinosa Cordero	PAOLA ESPINOSA	M	t	AN	PAOLA	ESPINOSA
15380623	D	89	6017	339	339150	Maria Francisca Valenzuela Sermini	MARÍA VALENZUELA	M	f	AP	MARÍA FRANCISCA	VALENZUELA
13841707	D	85	6017	347	347144	Alvaro Eduardo Salas Mena	ÁLVARO SALAS	M	t	AN	ÁLVARO	SALAS
12784750	D	84	6017	347	347008	Pamela Andrea Henriquez Rojas	PAMELA HENRÍQUEZ	M	t	AN	PAMELA 	HENRÍQUEZ
12558502	D	94	6017	339	339150	Roxana Jacqueline Cea Gomez	ROXANA CEA	M	t	AP	ROXANA 	CEA
15598848	D	96	6017	366	366130	Ana Valeska Muñoz Muñoz	ANA MUÑOZ	M	f	AR	ANA	MUÑOZ
12872239	D	87	6017	347	347144	Carlos Grez Rojas	CARLOS GREZ	M	t	AN	CARLOS	GREZ
18394059	D	88	6017	339	339150	Benjamin Moreno Bascur	BENJAMÍN MORENO	M	f	AP	BENJAMÍN	MORENO
5708920	D	95	6017	339	339150	Jorge Cabezas Cortes	JORGE CABEZAS	M	f	AP	JORGE	CABEZAS
14345150	D	91	6017	339	339150	Alejandra Evelyn Apablaza Elizondo	ALEJANDRA APABLAZA	M	f	AP	ALEJANDRA 	APABLAZA
12165609	D	98	6017	366	366130	Romy Nathalie Bernal Diaz	ROMY BERNAL	M	t	AR	ROMY 	BERNAL
10567078	D	93	6017	339	339150	Elias Vistoso Urrutia	ELÍAS VISTOSO	M	t	AP	ELÍAS	VISTOSO
16024686	D	102	6017	366	366006	Ana Cecilia Retamal Ramos	ANA RETAMAL	M	f	AR	ANA 	RETAMAL
14420255	D	101	6017	366	366045	Claudia Paola Vasquez Fuster	CLAUDIA VÁSQUEZ	M	f	AR	CLAUDIA	VÁSQUEZ
8189079	D	97	6017	366	366130	Alejandra Molina Tobar	ALEJANDRA MOLINA	M	f	AR	ALEJANDRA 	MOLINA
19105950	D	106	6017	350	350180	Natalia Aracely Nahuelman Esparza	NATALIA NAHUELMAN	M	t	AW	NATALIA 	NAHUELMAN
15140024	D	100	6017	366	366045	Felipe Ignacio Valdes Bobadilla	FELIPE VALDÉS	M	f	AR	FELIPE 	VALDÉS
6061620	D	99	6017	366	366045	Mercedes Bulnes Nuñez	MERCEDES BULNES	M	t	AR	MERCEDES	BULNES
15989841	D	105	6017	350	350180	Carlos Enrique Vega Ramos	CARLOS VEGA	M	t	AW	CARLOS 	VEGA
17155564	D	103	6017	366	366006	Jenny Araceli Ibarra Concha	JENNY IBARRA	M	t	AR	JENNY 	IBARRA
11893286	D	104	6017	350	350180	Francisco Pulgar Castillo	FRANCISCO PULGAR	M	t	AW	FRANCISCO	PULGAR
19042625	D	107	6017	350	350180	Javier Esteban Alvarado Valdes	JAVIER ALVARADO	M	f	AW	JAVIER	ALVARADO
6379329	D	60	6018	358	358003	Rolando Renteria Moller	ROLANDO RENTERÍA	M	f	AA	ROLANDO 	RENTERÍA
11956382	D	62	6018	358	358037	Maria Angelica Cancino Cisterna	MARÍA CANCINO	M	f	AA	MARÍA ANGÉLICA	CANCINO
13922028	D	70	6018	371	371007	Maria Soledad Villalon Berrios	MARIA VILLALÓN	M	t	AH	MARIA SOLEDAD	VILLALÓN
14596157	D	63	6018	358	358001	John Leandro Sancho Bichet	JOHN SANCHO	M	f	AA	JOHN	SANCHO
7036289	D	61	6018	358	358003	Gustavo Benavente Vergara	GUSTAVO BENAVENTE	M	f	AA	GUSTAVO	BENAVENTE
16286272	D	64	6018	358	358001	Paula Labra Besserer	PAULA LABRA	M	t	AA	PAULA	LABRA
15153416	D	66	6018	371	371002	Jonathan Eduardo Norambuena Barros	JONATHAN NORAMBUENA	M	t	AH	JONATHAN	NORAMBUENA
14451318	D	69	6018	371	371005	Felipe Barnachea Vasquez	FELIPE BARNACHEA	M	f	AH	FELIPE	BARNACHEA
13107981	D	67	6018	371	371002	Claudia Loretto Aravena Lagos	CLAUDIA ARAVENA	M	f	AH	CLAUDIA 	ARAVENA
14288560	D	65	6018	368	368157	Jorge Enrique Rojas Carvajal	JORGE ROJAS	M	f	AB	JORGE 	ROJAS
12966523	D	71	6018	347	347144	Ivan Cruz Apablaza Mendez	IVÁN APABLAZA	M	f	AN	IVÁN 	APABLAZA
14053340	D	72	6018	347	347008	Barbara Andrea Cubillos Flores	BÁRBARA CUBILLOS	M	f	AN	BÁRBARA 	CUBILLOS
13527369	D	76	6018	339	339150	Mery Paola Aguila Gajardo	MERY ÁGUILA	M	t	AP	MERY	ÁGUILA
6821219	D	74	6018	339	339150	Rosa Guillermina Catrileo Araneda	ROSA CATRILEO	M	f	AP	ROSA 	CATRILEO
10584205	D	75	6018	339	339150	Nelson David Alvarez Galleguillos	NELSON ÁLVAREZ	M	f	AP	NELSON 	ÁLVAREZ
11458188	D	73	6018	347	347008	Juan Pablo Espinosa Morales	JUAN ESPINOSA	M	f	AN	JUAN PABLO	ESPINOSA
18520176	D	77	6018	366	366045	Consuelo De Los Angeles Veloso Avila	CONSUELO VELOSO	M	f	AR	CONSUELO 	VELOSO
17884703	D	79	6018	366	366006	Priscila Veronica Gonzalez Carrillo	PRISCILA GONZÁLEZ	M	t	AR	PRISCILA	GONZÁLEZ
6065744	D	68	6018	371	371005	Jaime Naranjo Ortiz	JAIME NARANJO	M	f	AH	JAIME 	NARANJO
15726683	D	78	6018	366	366045	Francisco Javier Pinochet Rojas	FRANCISCO PINOCHET	M	f	AR	FRANCISCO	PINOCHET
13657636	D	82	6018	350	350180	Carla Manterola Acle	CARLA MANTEROLA	M	f	AW	CARLA	MANTEROLA
9167377	D	80	6018	366	366006	Rodrigo Bravo Bustos	RODRIGO BRAVO	M	t	AR	RODRIGO	BRAVO
19097586	D	84	6018	350	350180	Francisco Javier Antonio Perez Villegas	FRANCISCO PÉREZ	M	t	AW	FRANCISCO	PÉREZ
17448690	D	87	6018	999	99	Paula Nuche Garrido	PAULA NUCHE	M	t	ZZZ	PAULA	NUCHE
9324286	D	81	6018	366	366130	Rigoberto Valdivia Aravena	RIGOBERTO VALDIVIA	M	t	AR	RIGOBERTO	VALDIVIA
12536712	D	85	6018	373	373139	Andrea Valeska Morales Penroz	ANDREA MORALES	M	f	AY	ANDREA 	MORALES
15570172	D	86	6018	999	99	Felipe Gonzalez Lopez	FELIPE GONZÁLEZ	M	t	ZZZ	FELIPE	GONZÁLEZ
15148457	D	83	6018	350	350180	Jorge Eduardo Muñoz Saavedra	JORGE MUÑOZ	M	t	AW	JORGE 	MUÑOZ
15782790	D	60	6019	358	358003	Cristobal Martinez Ramirez	CRISTÓBAL MARTÍNEZ	M	f	AA	CRISTÓBAL 	MARTÍNEZ
17640406	D	66	6019	368	368157	Christian Alberto Astudillo Muñoz	CHRISTIAN ASTUDILLO	M	f	AB	CHRISTIAN 	ASTUDILLO
14458590	D	61	6019	358	358003	Marta Pilar Bravo Salinas	MARTA BRAVO	M	f	AA	MARTA 	BRAVO
15678108	D	64	6019	358	358001	Carolina Andrea Chavez Echeverria	CAROLINA CHÁVEZ	M	f	AA	CAROLINA 	CHÁVEZ
8528479	D	67	6019	368	368157	Alexis German Ormeño Silva	ALEXIS ORMEÑO	M	f	AB	ALEXIS 	ORMEÑO
12182810	D	65	6019	358	358001	Frank Carlos Sauerbaum Muñoz	FRANK SAUERBAUM	M	f	AA	FRANK	SAUERBAUM
16217547	D	62	6019	358	358037	Nataly Jazmin De La Hoz Moraga	NATALY DE	M	f	AA	NATALY 	DE LA HOZ
14027132	D	70	6019	371	371007	Cristian Ortiz Rubio	CRISTIÁN ORTIZ	M	f	AH	CRISTIÁN	ORTIZ
8699018	D	68	6019	368	368157	Claudia Alejandra Tapia Saavedra	CLAUDIA TAPIA	M	f	AB	CLAUDIA 	TAPIA
10963760	D	74	6019	371	371004	Patricia Rubio Escobar	PATRICIA RUBIO	M	f	AH	PATRICIA	RUBIO
17813215	D	72	6019	371	371002	Felipe Camaño Cardenas	FELIPE CAMAÑO	M	t	AH	FELIPE	CAMAÑO
13141238	D	63	6019	358	358001	Angelica Del Carmen Cuevas Palominos	ANGÉLICA CUEVAS	M	f	AA	ANGÉLICA 	CUEVAS
3378462	D	71	6019	371	371007	Carlos Parra Merino	CARLOS PARRA	M	f	AH	CARLOS	PARRA
14257406	D	76	6019	356	356142	Julio Becerra Espinoza	JULIO BECERRA	M	f	AL	JULIO	BECERRA
11536780	D	69	6019	368	368157	Daniel Enrique Godoy Lagos	DANIEL GODOY	M	f	AB	DANIEL 	GODOY
15987788	D	79	6019	356	356142	Ruddy Figueroa Gonzalez	RUDDY FIGUEROA	M	f	AL	RUDDY	FIGUEROA
14576523	D	78	6019	356	356142	Graciela Huenuman Lincopi	GRACIELA HUENUMAN	M	f	AL	GRACIELA	HUENUMAN
11537612	D	73	6019	371	371002	Silvana Neira Llanos	SILVANA NEIRA	M	f	AH	SILVANA	NEIRA
8367438	D	75	6019	371	371004	Paulo De La Fuente Paredes	PAULO DE	M	f	AH	PAULO	DE LA FUENTE
10374606	D	80	6019	356	356142	Francisco Gutierrez Figueroa	FRANCISCO GUTIERREZ	M	f	AL	FRANCISCO	GUTIERREZ
18857504	D	84	6019	339	339162	Sara Concha Smith	SARA CONCHA	M	f	AP	SARA 	CONCHA
17343900	D	82	6019	347	347008	Monserrat Alejandra Arratia Zapata	MONSERRAT ARRATIA	M	t	AN	MONSERRAT 	ARRATIA
9617516	D	77	6019	356	356142	Patricio Palma Molina	PATRICIO PALMA	M	f	AL	PATRICIO	PALMA
14283716	D	81	6019	347	347008	Maria Consuelo Villaseñor Soto	MARIA VILLASEÑOR	M	t	AN	MARIA CONSUELO	VILLASEÑOR
10331875	D	88	6019	339	339150	Lilian De Las Mercedes Dinamarca Muñoz	LILIAN DINAMARCA	M	f	AP	LILIAN 	DINAMARCA
15633510	D	85	6019	339	339162	Rodrigo Andres Castro Galaz	RODRIGO CASTRO	M	f	AP	RODRIGO 	CASTRO
14024185	D	90	6019	366	366045	Jonathan Stephano Chandia Iturra	JONATHAN CHANDÍA	M	t	AR	JONATHAN 	CHANDÍA
11264391	D	91	6019	366	366006	Evelyn Lourdes Montalba Palma	EVELYN MONTALBA	M	t	AR	EVELYN 	MONTALBA
14056795	D	86	6019	339	339162	Jocelyn Pamela Goretti Neira Diaz	JOCELYN NEIRA	M	f	AP	JOCELYN 	NEIRA
14442980	D	83	6019	347	347144	Luis Alexis Orellana Peña	LUIS ORELLANA	M	t	AN	LUIS 	ORELLANA
13999474	D	89	6019	366	366045	Susana Mabel Yañez Balague	SUSANA YÁÑEZ	M	t	AR	SUSANA 	YÁÑEZ
15179440	D	93	6019	373	373139	Boris Leandro Martinez Labra	BORIS MARTÍNEZ	M	f	AY	BORIS 	MARTÍNEZ
9553552	D	92	6019	366	366006	Maria Victoria Negrete Mendez	MARÍA NEGRETE	M	t	AR	MARÍA VICTORIA	NEGRETE
8229552	D	87	6019	339	339150	Freddy Reinaldo Blanc Sperberg	FREDDY BLANC	M	f	AP	FREDDY 	BLANC
12123985	D	66	6020	358	358037	Francesca Parodi Oppliger	FRANCESCA PARODI	M	f	AA	FRANCESCA	PARODI
12380679	D	61	6020	358	358003	Marlene Perez Cartes	MARLENE PÉREZ	M	t	AA	MARLENE 	PÉREZ
8093904	D	60	6020	358	358003	Sergio Bobadilla Muñoz	SERGIO BOBADILLA	M	f	AA	SERGIO 	BOBADILLA
7210203	D	64	6020	358	358001	Leonidas Andres Romero Saez	LEONIDAS ROMERO	M	f	AA	LEONIDAS 	ROMERO
17046383	D	62	6020	358	358003	Paz Charpentier Rajcevich	PAZ CHARPENTIER	M	t	AA	PAZ	CHARPENTIER
9638248	D	65	6020	358	358001	Claudio Fabian Etchevers Flores	CLAUDIO ETCHEVERS	M	f	AA	CLAUDIO 	ETCHEVERS
14580857	D	63	6020	358	358001	Francesca Muñoz Gonzalez	FRANCESCA MUÑOZ	M	f	AA	FRANCESCA	MUÑOZ
13952099	D	67	6020	358	358037	Marco Loyola Quiroz	MARCO LOYOLA	M	f	AA	MARCO	LOYOLA
14390316	D	75	6020	368	368157	Antonio Silva Reyes	ANTONIO SILVA	M	f	AB	ANTONIO	SILVA
6013102	D	71	6020	368	368157	Walter Aldo Wojciechowski Zara	WALTER WOJCIECHOWSKI	M	f	AB	WALTER 	WOJCIECHOWSKI
17862183	D	68	6020	358	358037	Cristian Eduardo Puentes Rivas	CRISTIÁN PUENTES	M	t	AA	CRISTIÁN	PUENTES
17044484	D	76	6020	368	368157	Josefa Sofia Bonilla Moreno	JOSEFA BONILLA	M	f	AB	JOSEFA	BONILLA
13135807	D	74	6020	368	368157	Rosalet Marylina Constanzo Otey	ROSALET CONSTANZO	M	f	AB	ROSALET 	CONSTANZO
17042072	D	82	6020	371	371007	Camila Alondra Polizzi Fonceca	CAMILA POLIZZI	M	t	AH	CAMILA 	POLIZZI
15182251	D	80	6020	371	371004	Leocan Portus Urbina	LEOCAN PORTUS	M	t	AH	LEOCAN	PORTUS
8611309	D	70	6020	368	368157	Veronica Del Pilar Nuñez Barra	VERÓNICA NUÑEZ	M	f	AB	VERÓNICA	NUÑEZ
10242670	D	84	6020	371	371002	Eric Aedo Jeldres	ERIC AEDO	M	f	AH	ERIC	AEDO
9375716	D	69	6020	368	368157	Roberto Enrique Arroyo Muñoz	ROBERTO ARROYO	M	f	AB	ROBERTO 	ARROYO
8209223	D	78	6020	371	371005	Hugo Cautivo Baltierra	HUGO CAUTIVO	M	f	AH	HUGO	CAUTIVO
13723609	D	79	6020	371	371005	Patricio Fierro Garces	PATRICIO FIERRO	M	f	AH	PATRICIO 	FIERRO
18389662	D	81	6020	371	371007	Natalia Araya Aviles	NATALIA ARAYA	M	f	AH	NATALIA	ARAYA
17969759	D	72	6020	368	368157	Paola Andrea Cofre Villalobos	PAOLA COFRÉ	M	f	AB	PAOLA 	COFRÉ
13725305	D	83	6020	371	371002	Aldo Mardones Alarcon	ALDO MARDONES	M	f	AH	ALDO	MARDONES
18235269	D	88	6020	356	356142	Sofia Duran Escobar	SOFÍA DURÁN	M	f	AL	SOFÍA	DURÁN
10387277	D	86	6020	356	356142	Elizabeth Mujica Zepeda	ELIZABETH MUJICA	M	f	AL	ELIZABETH	MUJICA
17569924	D	73	6020	368	368157	Andres Carrera Oliveros	ANDRÉS CARRERA	M	f	AB	ANDRÉS	CARRERA
9668588	D	91	6020	356	356142	Cristhian Lagos Palma	CRISTHIAN LAGOS	M	f	AL	CRISTHIAN	LAGOS
12975982	D	77	6020	368	368157	Mauricio Aaron Burgos Fernandez	MAURICIO BURGOS	M	f	AB	MAURICIO 	BURGOS
17861707	D	90	6020	356	356142	Loreto Bustos Salgado	LORETO BUSTOS	M	f	AL	LORETO	BUSTOS
18149675	D	87	6020	356	356142	Brian Rivas Tiznado	BRIAN RIVAS	M	f	AL	BRIAN	RIVAS
10963849	D	89	6020	356	356142	Domingo Torres Sanchez	DOMINGO TORRES	M	f	AL	DOMINGO	TORRES
18812158	D	94	6020	374	374147	Natascha Carolina Gotschlich Enriquez	NATASCHA GOTSCHLICH	M	f	AM	NATASCHA 	GOTSCHLICH
12175668	D	85	6020	356	356142	Felix Gonzalez Gatica	FÉLIX GONZÁLEZ	M	f	AL	FÉLIX	GONZÁLEZ
18000889	D	93	6020	374	374147	Gaston Alfredo Flores Ordenes	GASTÓN FLORES	M	f	AM	GASTÓN 	FLORES
9197852	D	96	6020	374	374147	Rosa Ester Arias Solis	ROSA ARIAS	M	f	AM	ROSA 	ARIAS
7994669	D	98	6020	347	347144	Mauricio Concha Alarcon	MAURICIO CONCHA	M	f	AN	MAURICIO	CONCHA
7525949	D	95	6020	374	374147	Hector Bernardo Poblete Beltran	HÉCTOR POBLETE	M	f	AM	HÉCTOR	POBLETE
19812798	D	97	6020	374	374147	Ivanna Alexandra Bustamante Riveros	IVANNA BUSTAMANTE	M	f	AM	IVANNA 	BUSTAMANTE
12016613	D	100	6020	347	347144	Carolina Jeannette Monsalves Sanhueza	CAROLINA MONSALVES	M	t	AN	CAROLINA 	MONSALVES
15221237	D	99	6020	347	347144	Viviana Soledad Gonzalez Herrera	VIVIANA GONZÁLEZ	M	t	AN	VIVIANA 	GONZÁLEZ
16550357	D	92	6020	356	356142	Maria Jose Leiva Jopia	MARÍA LEIVA	M	f	AL	MARÍA JOSÉ	LEIVA
16768127	D	104	6020	347	347008	Ruben Dario Marcos Velasquez	RUBÉN MARCOS	M	f	AN	RUBÉN 	MARCOS
10221120	D	106	6020	366	366130	Susana Herrera Quezada	SUSANA HERRERA	M	t	AR	SUSANA	HERRERA
17349197	D	101	6020	347	347144	Pamela Andrea Hidalgo Parra	PAMELA HIDALGO	M	t	AN	PAMELA	HIDALGO
17510314	D	102	6020	347	347144	Carlos Contreras Parra	CARLOS CONTRERAS	M	t	AN	CARLOS	CONTRERAS
8991758	D	111	6020	366	366006	Eduardo Alfonso Barra Jofre	EDUARDO BARRA	M	f	AR	EDUARDO	BARRA
14273718	D	105	6020	347	347008	Paola Andrea Laporte Victoriano	PAOLA LAPORTE	M	t	AN	PAOLA 	LAPORTE
13106632	D	116	6020	350	350180	Maria Alejandra Jara Marin	MARÍA JARA	M	f	AW	MARÍA ALEJANDRA	JARA
16432405	D	113	6020	366	366045	Felipe Alfonso Rodriguez Vasquez	FELIPE RODRÍGUEZ	M	f	AR	FELIPE	RODRÍGUEZ
13612804	D	112	6020	366	366006	Pablo Emilio Blaset Garrido	PABLO BLASET	M	f	AR	PABLO	BLASET
11901678	D	103	6020	347	347008	Ivan Lenin Valeria Rodriguez	IVÁN VALERIA	M	t	AN	IVÁN 	VALERIA
13306268	D	117	6020	350	350180	Macarena Cristina Arias Hernandez	MACARENA ARIAS	M	t	AW	MACARENA 	ARIAS
10855591	D	119	6020	350	350180	Carla Andrea Gonzalez Liapiz	CARLA GONZÁLEZ	M	f	AW	CARLA 	GONZÁLEZ
11251736	D	107	6020	366	366130	Mario Gonzalez Figueroa	MARIO GONZÁLEZ	M	t	AR	MARIO	GONZÁLEZ
16038790	D	108	6020	366	366149	Sindy Salazar Pincheira	SINDY SALAZAR	M	t	AR	SINDY	SALAZAR
18419068	D	114	6020	366	366045	Alexandra Machuca Norambuena	ALEXANDRA MACHUCA	M	t	AR	ALEXANDRA	MACHUCA
15681043	D	109	6020	366	366149	Anibal Andres Navarrete Carrasco	ANÍBAL NAVARRETE	M	t	AR	ANÍBAL	NAVARRETE
6838016	D	110	6020	366	366006	Maria Candelaria Acevedo Saez	MARÍA ACEVEDO	M	f	AR	MARÍA 	ACEVEDO
8627874	D	121	6020	350	350180	Jaime Rodolfo Fica Carrasco	JAIME FICA	M	f	AW	JAIME 	FICA
18685239	D	118	6020	350	350180	Jonnathan Agustin Remaggi Sanhueza	JONNATHAN REMAGGI	M	f	AW	JONNATHAN	REMAGGI
10684589	D	122	6020	350	350180	Edilia Ester Stuardo Barriga	EDILIA STUARDO	M	t	AW	EDILIA 	STUARDO
15579739	D	115	6020	350	350180	Juan Pablo Moya Caceres	JUAN MOYA	M	f	AW	JUAN PABLO	MOYA
12381413	D	123	6020	350	350180	Margarita Elena Sanchez Becerra	MARGARITA SÁNCHEZ	M	f	AW	MARGARITA 	SÁNCHEZ
6678337	D	120	6020	350	350180	Patricio Alejandro Toledo Lobos	PATRICIO TOLEDO	M	f	AW	PATRICIO	TOLEDO
16988136	D	60	6021	358	358037	Javiera Hormazabal Martin	JAVIERA HORMAZABAL	M	t	AA	JAVIERA	HORMAZABAL
17344246	D	61	6021	358	358001	Manuel Antonio Rios Saavedra	MANUEL RÍOS	M	t	AA	MANUEL 	RÍOS
17616425	D	62	6021	358	358001	Jean-paul Sierra Hidalgo	JEAN SIERRA	M	f	AA	JEAN PAUL	SIERRA
14248201	D	67	6021	368	368157	Cristian Bernardo Astorga Canales	CRISTIÁN ASTORGA	M	f	AB	CRISTIÁN	ASTORGA
15627805	D	65	6021	368	368157	Nelson Alexander Cares Ormeño	NELSON CARES	M	f	AB	NELSON	CARES
17345485	D	63	6021	358	358003	Tamara Rogers Sufan	TAMARA ROGERS	M	t	AA	TAMARA 	ROGERS
15212355	D	66	6021	368	368157	Karen Andrea Medina Vasquez	KAREN MEDINA	M	f	AB	KAREN	MEDINA
7828977	D	64	6021	358	358003	Flor Weisse Novoa	FLOR WEISSE	M	f	AA	FLOR 	WEISSE
13102726	D	69	6021	368	368157	Alex Marcelo Vega Aguayo	ALEX VEGA	M	f	AB	ALEX 	VEGA
13096942	D	70	6021	371	371002	Joanna Perez Olea	JOANNA PÉREZ	M	f	AH	JOANNA	PÉREZ
7326829	D	71	6021	371	371005	Juan De Dios Parra Sepulveda	JUAN PARRA	M	f	AH	JUAN DE DIOS 	PARRA
10716563	D	68	6021	368	368157	Cecilia Del Carmen Gonzalez Ananias	CECILIA GONZÁLEZ	M	f	AB	CECILIA	GONZÁLEZ
14298516	D	72	6021	371	371007	Paula Antonia Acuña Leon	PAULA ACUÑA	M	f	AH	PAULA 	ACUÑA
18404568	D	75	6021	356	356142	Joaquin Saldivia Jarpa	JOAQUÍN SALDIVIA	M	f	AL	JOAQUÍN	SALDIVIA
10583279	D	73	6021	371	371004	Rodrigo Daroch Yañez	RODRIGO DAROCH	M	f	AH	RODRIGO	DAROCH
19088051	D	78	6021	356	356142	Francisco Santana Cardenas	FRANCISCO SANTANA	M	f	AL	FRANCISCO	SANTANA
10870485	D	76	6021	356	356142	Reinaldo Rozas Silva	REINALDO ROZAS	M	f	AL	REINALDO	ROZAS
14538876	D	74	6021	371	371137	Anwar Farran Veloso	ANWAR FARRÁN	M	t	AH	ANWAR	FARRÁN
16041996	D	79	6021	374	374147	Marcos Rafael Paz Silva	MARCOS PAZ	M	f	AM	MARCOS 	PAZ
11418058	D	77	6021	356	356142	Pedro Pablo Valenzuela Castro	PEDRO VALENZUELA	M	f	AL	PEDRO PABLO	VALENZUELA
14436847	D	81	6021	339	339162	Robinson Lizama Gatica	ROBINSON LIZAMA	M	f	AP	ROBINSON	LIZAMA
11699058	D	88	6021	366	366006	Alvaro Valentin Sanchez Rojas	ÁLVARO SÁNCHEZ	M	t	AR	ÁLVARO 	SÁNCHEZ
15209322	D	82	6021	339	339162	Brigida Beroiza Levi	BRÍGIDA BEROIZA	M	f	AP	BRÍGIDA	BEROIZA
12855109	D	84	6021	339	339150	Cristobal Urruticoechea Rios	CRISTÓBAL URRUTICOECHEA	M	f	AP	CRISTÓBAL	URRUTICOECHEA
17559293	D	80	6021	339	339162	Esteban Hernan Barahona Contreras	ESTEBAN BARAHONA	M	f	AP	ESTEBAN 	BARAHONA
10252917	D	85	6021	339	339150	Maria Solange Etchepare Lacoste	MARÍA ETCHEPARE	M	t	AP	MARÍA 	ETCHEPARE
17366053	D	83	6021	339	339162	Jorge Alejandro Sepulveda Rosales	JORGE SEPÚLVEDA	M	f	AP	JORGE	SEPÚLVEDA
13137667	D	90	6021	366	366130	Nadine Sepulveda Arias	NADINE SEPÚLVEDA	M	f	AR	NADINE	SEPÚLVEDA
13313335	D	87	6021	366	366149	Cristian Alfredo Ramirez Henriquez	CRISTIÁN RAMÍREZ	M	t	AR	CRISTIÁN	RAMÍREZ
8475506	D	89	6021	366	366006	Ricardo Alfredo Gierke Correa	RICARDO GIERKE	M	t	AR	RICARDO	GIERKE
7213971	D	86	6021	366	366149	Clara Ines Sagardia Cabezas	CLARA SAGARDÍA	M	t	AR	CLARA 	SAGARDÍA
11467709	D	91	6021	366	366130	Hernan Mauricio Cortes Bernal	HERNAN CORTÉS	M	f	AR	HERNAN 	CORTÉS
10592391	D	62	6022	358	358001	Maria Soledad Castillo Henriquez	MARÍA CASTILLO	M	f	AA	MARÍA SOLEDAD	CASTILLO
16794763	D	64	6022	358	358003	Karin Mella Candia	KARIN MELLA	M	f	AA	KARIN	MELLA
10832480	D	68	6022	371	371004	Andrea Parra Sauterel	ANDREA PARRA	M	f	AH	ANDREA	PARRA
10411749	D	60	6022	358	358001	Jorge Rathgeb Schifferli	JORGE RATHGEB	M	f	AA	JORGE	RATHGEB
5596475	D	63	6022	358	358003	Pablo Herdener Truan	PABLO HERDENER	M	f	AA	PABLO	HERDENER
9293458	D	61	6022	358	358001	Juan Carlos Beltran Silva	JUAN BELTRÁN	M	f	AA	JUAN CARLOS	BELTRÁN
13970874	D	67	6022	368	368157	Guido Antonio Diaz Vergara	GUIDO DÍAZ	M	f	AB	GUIDO 	DÍAZ
12233597	D	70	6022	371	371005	Liliana Maulen Gonzalez	LILIANA MAULÉN	M	f	AH	LILIANA 	MAULÉN
8301951	D	71	6022	371	371002	Jorge Saffirio Espinoza	JORGE SAFFIRIO	M	f	AH	JORGE	SAFFIRIO
7378458	D	66	6022	368	368157	Maria Cristobalina Del Carmen Sepulveda Chacon	MARÍA SEPÚLVEDA	M	f	AB	MARÍA	SEPÚLVEDA
5767122	D	72	6022	371	371002	Renato Hauri Gomez	RENATO HAURI	M	f	AH	RENATO	HAURI
17450488	D	65	6022	368	368157	Silvana Andrea Carcamo Jerez	SILVANA CARCAMO	M	f	AB	SILVANA 	CARCAMO
13239257	D	76	6022	347	347008	Ingrid Conejeros Montecino	INGRID CONEJEROS	M	t	AN	INGRID	CONEJEROS
10348070	D	69	6022	371	371004	Manuel Painiqueo Tragnolao	MANUEL PAINIQUEO	M	f	AH	MANUEL	PAINIQUEO
11907601	D	75	6022	347	347008	Ivonne Maria Martinez Molinas	IVONNE MARTÍNEZ	M	f	AN	IVONNE	MARTÍNEZ
13153485	D	74	6022	347	347008	Evaristo Rene Curical ñanco	EVARISTO CURICAL	M	f	AN	EVARISTO 	CURICAL
18438021	D	78	6022	339	339162	Estrella Constanza Meza Lavandero	ESTRELLA MEZA	M	f	AP	ESTRELLA	MEZA
17261634	D	73	6022	356	356142	Luis Fuentes Lobos	LUIS FUENTES	M	f	AL	LUIS 	FUENTES
18719973	D	79	6022	339	339162	Patricio Javier Pichun Castillo	PATRICIO PICHUN	M	f	AP	PATRICIO 	PICHUN
17366257	D	82	6022	339	339150	Enrique Estay Cuevas	ENRIQUE ESTAY	M	t	AP	ENRIQUE	ESTAY
12191278	D	77	6022	347	347144	Jose Millalen Paillal	JOSÉ MILLALEN	M	t	AN	JOSÉ	MILLALEN
13961759	D	80	6022	339	339150	Patrick Alan Casanova Tobar	PATRICK CASANOVA	M	f	AP	PATRICK	CASANOVA
14512664	D	85	6022	366	366130	Marcela Gutierrez Mella	MARCELA GUTIÉRREZ	M	t	AR	MARCELA	GUTIÉRREZ
13812112	D	86	6022	366	366130	Gerson Cayuqueo Riquelme	GERSON CAYUQUEO	M	f	AR	GERSON	CAYUQUEO
18247028	D	84	6022	366	366045	Mauricio Alejandro Lepin Aniñir	MAURICIO LEPIN	M	t	AR	MAURICIO 	LEPIN
7051021	D	81	6022	339	339150	Gloria Naveillan Arriagada	GLORIA NAVEILLÁN	M	f	AP	GLORIA	NAVEILLÁN
17461091	D	87	6022	366	366006	Nicolas Esteban Pino Barrera	NICOLÁS PINO	M	t	AR	NICOLÁS 	PINO
16114172	D	89	6022	373	373139	Dorian Obryan Godoy Acuña	DORIAN GODOY	M	f	AY	DORIAN 	GODOY
16641747	D	88	6022	350	350180	Daniela Nataly Gonzalez Fariña	DANIELA GONZÁLEZ	M	f	AW	DANIELA 	GONZÁLEZ
18196855	D	83	6022	366	366045	Gabriela Del Carmen España Collio	GABRIELA ESPAÑA	M	t	AR	GABRIELA 	ESPAÑA
8904057	D	60	6023	358	358037	Andres Molina Magofke	ÁNDRES MOLINA	M	f	AA	ÁNDRES	MOLINA
10513911	D	61	6023	358	358037	Sebastian Alvarez Ramirez	SEBASTIÁN ÁLVAREZ	M	f	AA	SEBASTIÁN	ÁLVAREZ
19580681	D	62	6023	358	358037	Llacolen Millaquir Peña	LLACOLÉN MILLAQUIR	M	t	AA	LLACOLÉN 	MILLAQUIR
6842230	D	64	6023	358	358001	Pablo Santiago Astete Mermoud	PABLO ASTETE	M	f	AA	PABLO 	ASTETE
6646540	D	63	6023	358	358001	Miguel Alejandro Mellado Suazo	MIGUEL MELLADO	M	f	AA	MIGUEL	MELLADO
13318402	D	70	6023	368	368157	Yolanda Marisel Pedreros Venegas	YOLANDA PEDREROS	M	f	AB	YOLANDA	PEDREROS
9815477	D	73	6023	371	371004	Hilario Huirilef Barra	HILARIO HUIRILEF	M	f	AH	HILARIO	HUIRILEF
13584214	D	69	6023	368	368157	Roberto Andres Moncada Hernandez	ROBERTO MONCADA	M	f	AB	ROBERTO 	MONCADA
8325011	D	67	6023	358	358003	Claudia Elena Lillo Echeverria	CLAUDIA LILLO	M	t	AA	CLAUDIA 	LILLO
13675408	D	71	6023	368	368157	Cesar Andres Levio Martinez	CÉSAR LEVIO	M	f	AB	CÉSAR 	LEVIO
11688448	D	76	6023	371	371002	Marcelo Garcia Soto	MARCELO GARCÍA	M	f	AH	MARCELO	GARCÍA
13154500	D	66	6023	358	358003	Henry Leal Bizama	HENRY LEAL	M	f	AA	HENRY 	LEAL
17261090	D	78	6023	371	371007	Waleska Lissette Morales Morales	WALESKA MORALES	M	t	AH	WALESKA	MORALES
10432384	D	75	6023	371	371005	Minerva Castañeda Meliñan	MINERVA CASTAÑEDA	M	f	AH	MINERVA 	CASTAÑEDA
17650239	D	72	6023	364	364135	Camila Andrea Delgado Troncoso	CAMILA DELGADO	M	f	AE	CAMILA	DELGADO
8182789	D	65	6023	358	358001	Miguel Angel Becker Alvear	MIGUEL BECKER	M	f	AA	MIGUEL	BECKER
19957432	D	84	6023	356	356142	Constanza Gonzalez Gonzalez	CONSTANZA GONZÁLEZ	M	f	AL	CONSTANZA	GONZÁLEZ
10784325	D	77	6023	371	371007	Andres Jouannet Valderrama	ANDRÉS JOUANNET	M	t	AH	ANDRÉS	JOUANNET
9970358	D	68	6023	368	368157	Pablo Alberto Diaz Salazar	PABLO DÍAZ	M	f	AB	PABLO 	DÍAZ
15231149	D	74	6023	371	371004	Paola Moncada Venegas	PAOLA MONCADA	M	f	AH	PAOLA	MONCADA
14308634	D	83	6023	356	356142	Ivan Gorky Rojas Villagra	IVÁN ROJAS	M	f	AL	IVÁN 	ROJAS
10559489	D	82	6023	356	356142	Monica Castro Canales	MÓNICA CASTRO	M	f	AL	MÓNICA	CASTRO
15656884	D	80	6023	356	356142	Lorena Jara Jara	LORENA JARA	M	f	AL	LORENA	JARA
9941888	D	86	6023	347	347144	Aucan Huilcaman Paillama	AUCÁN HUILCAMAN	M	t	AN	AUCÁN	HUILCAMAN
18196077	D	92	6023	339	339162	Karen Cona Huenchulaf	KAREN CONA	M	f	AP	KAREN	CONA
15681459	D	79	6023	371	371007	Jaime Aravena Aravena	JAIME ARAVENA	M	t	AH	JAIME	ARAVENA
10608304	D	81	6023	356	356142	Edgardo Lovera Riquelme	EDGARDO LOVERA	M	f	AL	EDGARDO	LOVERA
12144952	D	87	6023	347	347144	Luz Eliana Alca Turra	LUZ ALCA	M	t	AN	LUZ 	ALCA
8285458	D	85	6023	356	356142	Hector Santos Villablanca	HÉCTOR SANTOS	M	f	AL	HÉCTOR	SANTOS
9013913	D	97	6023	339	339150	Cesar Augusto Vargas Zurita	CÉSAR VARGAS	M	f	AP	CÉSAR 	VARGAS
13965413	D	91	6023	347	347008	Miguel Angel Cortes Ibarra	MIGUEL CORTÉS	M	t	AN	MIGUEL ÁNGEL	CORTÉS
5655590	D	95	6023	339	339162	Antonio Stuardo Pineda	ANTONIO STUARDO	M	t	AP	ANTONIO	STUARDO
15245066	D	107	6023	366	366130	Hector Cumilaf Huentemil	HÉCTOR CUMILAF	M	t	AR	HÉCTOR 	CUMILAF
7964842	D	102	6023	366	366006	Luis Alejandro Catrileo Gaete	LUIS CATRILEO	M	f	AR	LUIS 	CATRILEO
12721474	D	94	6023	339	339162	Danilo Jose Caroca Salgado	DANILO CAROCA	M	t	AP	DANILO	CAROCA
15656291	D	89	6023	347	347008	Luis Antonio Levi Aninao	LUIS LEVI	M	t	AN	LUIS 	LEVI
12192925	D	88	6023	347	347008	Andrea Quijon Godoy	ANDREA QUIJÓN	M	f	AN	ANDREA	QUIJÓN
16432580	D	93	6023	339	339162	Tamara Del Carmen Avendaño Levinao	TAMARA AVENDAÑO	M	f	AP	TAMARA 	AVENDAÑO
15256333	D	99	6023	339	339150	Mauricio Antonio Ojeda Rebolledo	MAURICIO OJEDA	M	t	AP	MAURICIO	OJEDA
10996829	D	101	6023	366	366045	Veronica Andrea Lopez-videla Pino	VERÓNICA LOPEZ-VIDELA	M	t	AR	VERÓNICA	LOPEZ-VIDELA
20354622	D	96	6023	339	339162	Nicolas Ringler Araneda Moreno	NICOLÁS ARANEDA	M	t	AP	NICOLÁS	ARANEDA
18195019	D	100	6023	366	366045	Ericka ñanco Vasquez	ERICKA ÑANCO	M	f	AR	ERICKA	ÑANCO
15978146	D	112	6023	350	350148	Luis Casado Zurita	LUIS CASADO	M	t	AW	LUIS 	CASADO
14532395	D	103	6023	366	366006	Pablo Andres Tapia Pinto	PABLO TAPIA	M	t	AR	PABLO	TAPIA
13471731	D	98	6023	339	339150	Stephan Herbert Schubert Rubio	STEPHAN SCHUBERT	M	t	AP	STEPHAN 	SCHUBERT
10919678	D	109	6023	350	350148	Jose Olave Martinez	JOSÉ OLAVE	M	f	AW	JOSÉ	OLAVE
12268562	D	90	6023	347	347008	Alejandra Aillapan Huiriqueo	ALEJANDRA AILLAPÁN	M	t	AN	ALEJANDRA 	AILLAPÁN
15258820	D	113	6023	350	350180	Ademar Octavio Muñoz Rifo	ADEMAR MUÑOZ	M	f	AW	ADEMAR 	MUÑOZ
15721898	D	105	6023	366	366130	Onesima Riquelme Lienqueo	ONESIMA RIQUELME	M	t	AR	ONESIMA	RIQUELME
7624245	D	111	6023	350	350148	Omar Ortiz Concha	OMAR ORTIZ	M	f	AW	OMAR 	ORTIZ
12593568	D	114	6023	350	350180	Cristian Aliro Muñoz Garrido	CRISTIAN MUÑOZ	M	t	AW	CRISTIAN 	MUÑOZ
13655612	D	108	6023	350	350148	Miguel Arteaga Cares	MIGUEL ARTEAGA	M	f	AW	MIGUEL	ARTEAGA
10159284	D	104	6023	366	366006	Elena Marisol Varela Lopez	ELENA VARELA	M	t	AR	ELENA 	VARELA
16534613	D	110	6023	350	350148	Carolina Olate Sanchez	CAROLINA OLATE	M	f	AW	CAROLINA	OLATE
10398318	D	106	6023	366	366130	Arnoldo ñanculef Huaiquinao	ARNOLDO ÑANCULEF	M	t	AR	ARNOLDO	ÑANCULEF
12747281	D	115	6023	373	373139	Marco Antonio Lobos Vasquez	MARCO LOBOS	M	f	AY	MARCO	LOBOS
3685751	D	62	6024	358	358140	Hugo Ortiz De Filippi	HUGO ORTIZ	M	f	AA	HUGO	ORTIZ
6543149	D	60	6024	358	358003	Gaston Von Muhlenbrock Zamora	GASTÓN VON	M	f	AA	GASTÓN 	VON MUHLENBROCK
10787158	D	63	6024	358	358140	Waleska Fehrmann Atero	WALESKA FEHRMANN	M	f	AA	WALESKA	FEHRMANN
8709108	D	64	6024	358	358001	Soledad Estela Cuesta Vallejos	SOLEDAD CUESTA	M	t	AA	SOLEDAD 	CUESTA
16564758	D	66	6024	368	368157	Tabina Gabriela Manque Manque	TABINA MANQUE	M	f	AB	TABINA	MANQUE
10721649	D	61	6024	358	358003	Maria Paz Lagos Valdivieso	MARÍA LAGOS	M	f	AA	MARÍA PAZ	LAGOS
10486198	D	67	6024	368	368157	Emma Patricia Cifuentes Barrientos	EMMA CIFUENTES	M	f	AB	EMMA 	CIFUENTES
5738529	D	65	6024	358	358001	Bernardo Jose Berger Fett	BERNARDO BERGER	M	t	AA	BERNARDO	BERGER
10937857	D	71	6024	371	371005	Marcos Ilabaca Cerda	MARCOS ILABACA	M	f	AH	MARCOS	ILABACA
16049041	D	69	6024	368	368157	Felipe Emilio Aranda Saravia	FELIPE ARANDA	M	f	AB	FELIPE 	ARANDA
13521338	D	70	6024	368	368157	Jose Miguel Barria Valenzuela	JOSÉ BARRÍA	M	f	AB	JOSÉ MIGUEL	BARRÍA
4856538	D	73	6024	371	371002	Carlos Amtmann Moyano	CARLOS AMTMANN	M	f	AH	CARLOS	AMTMANN
18173803	D	68	6024	368	368157	Diego Alejandro Baeza Sepulveda	DIEGO BAEZA	M	f	AB	DIEGO 	BAEZA
17863360	D	75	6024	371	371004	Daniela Asenjo Garrido	DANIELA ASENJO	M	t	AH	DANIELA	ASENJO
12587922	D	74	6024	371	371002	Marcela Suarez Muñoz	MARCELA SUÁREZ	M	f	AH	MARCELA	SUÁREZ
16271551	D	81	6024	347	347008	Teresa Matilde Albertina Almonacid Almonacid	TERESA ALMONACID	M	f	AN	TERESA 	ALMONACID
12430678	D	72	6024	371	371005	Ana Maria Bravo Castro	ANA BRAVO	M	f	AH	ANA MARÍA	BRAVO
10630981	D	79	6024	347	347008	Maria Angelica Alvear Montecinos	MARÍA ALVEAR	M	f	AN	MARÍA ANGÉLICA	ALVEAR
10708380	D	77	6024	347	347008	Luz Celena Soto Vega	LUZ SOTO	M	f	AN	LUZ 	SOTO
11445515	D	78	6024	347	347008	Victor Barra Quijada	VÍCTOR BARRA	M	f	AN	VÍCTOR	BARRA
11093269	D	76	6024	371	371004	Oriana Paredes Perez	ORIANA PAREDES	M	t	AH	ORIANA	PAREDES
13379634	D	80	6024	347	347008	Pablo Andres Cabrera Vergara	PABLO CABRERA	M	f	AN	PABLO	CABRERA
13516704	D	85	6024	339	339150	Catherine Alejandra Pacheco Orias	CATHERINE PACHECO	M	t	AP	CATHERINE 	PACHECO
10494278	D	82	6024	347	347008	Margarita Morales Valero	MARGARITA MORALES	M	t	AN	MARGARITA	MORALES
16564240	D	83	6024	339	339150	Leandro Kunstmann Collado	LEANDRO KUNSTMANN	M	f	AP	LEANDRO	KUNSTMANN
10488532	D	84	6024	339	339150	Jorge Enrique De La Maza Schleyer	JORGE DE	M	t	AP	JORGE 	DE LA MAZA
7460994	D	90	6024	366	366149	Patricio Eduardo Rosas Barrientos	PATRICIO ROSAS	M	t	AR	PATRICIO 	ROSAS
8816744	D	87	6024	339	339150	Manuel Jesus Oliva Perez	MANUEL OLIVA	M	t	AP	MANUEL 	OLIVA
8457102	D	86	6024	339	339150	Claudia Carolina Latorre Aravena	CLAUDIA LATORRE	M	t	AP	CLAUDIA 	LATORRE
18238920	D	92	6024	366	366006	Angel Andres Delgado Cardenas	ÁNGEL DELGADO	M	t	AR	ÁNGEL 	DELGADO
7719942	D	88	6024	339	339150	Mario Alonso Hormazabal Novoa	MARIO HORMAZÁBAL	M	t	AP	MARIO	HORMAZÁBAL
18459961	D	89	6024	366	366149	Ninoska Del Pilar Gallardo Peralta	NINOSKA GALLARDO	M	f	AR	NINOSKA	GALLARDO
16271657	D	94	6024	366	366045	Vanessa Huaiquimilla Pinochet	VANESSA HUAIQUIMILLA	M	t	AR	VANESSA	HUAIQUIMILLA
11115504	D	93	6024	366	366045	Sandra Isabel Cheuquepan Quezada	SANDRA CHEUQUEPAN	M	f	AR	SANDRA 	CHEUQUEPAN
15243674	D	91	6024	366	366006	Paola Veronica Nahuelhual Catalan	PAOLA NAHUELHUAL	M	f	AR	PAOLA 	NAHUELHUAL
6928545	D	61	6025	358	358001	Evelyn Guillermina Zottele Garcia	EVELYN ZOTTELE	M	f	AA	EVELYN 	ZOTTELE
8789563	D	60	6025	358	358001	Ingrid Schettino Pinto	INGRID SCHETTINO	M	f	AA	INGRID	SCHETTINO
10810292	D	64	6025	358	358003	Soraya Said Teuber	SORAYA SAID	M	f	AA	SORAYA	SAID
5852632	D	63	6025	358	358003	Daniel Lilayu Vivanco	DANIEL LILAYU	M	f	AA	DANIEL 	LILAYU
17496123	D	66	6025	368	368157	Enrique Jose Parra Mena	ENRIQUE PARRA	M	f	AB	ENRIQUE 	PARRA
17532189	D	62	6025	358	358003	Carlos Alfredo Oyarzun Concha	CARLOS OYARZÚN	M	f	AA	CARLOS	OYARZÚN
10792683	D	72	6025	371	371002	Karla Benavides Henriquez	KARLA BENAVIDES	M	f	AH	KARLA	BENAVIDES
8514354	D	71	6025	371	371007	Rosemberg Francis Hernandez Bello	ROSEMBERG HERNÁNDEZ	M	f	AH	ROSEMBERG	HERNÁNDEZ
19641166	D	68	6025	368	368157	Maria Paz Gomez Asenjo	MARÍA GÓMEZ	M	f	AB	MARÍA PAZ	GÓMEZ
17657752	D	67	6025	368	368157	Abigail Alejandra Carcamo Martinez	ABIGAIL CÁRCAMO	M	f	AB	ABIGAIL 	CÁRCAMO
12870251	D	65	6025	368	368157	Claudio Ariel Del Rio Malgarini	CLAUDIO DEL	M	f	AB	CLAUDIO 	DEL RÍO
13823439	D	70	6025	371	371005	Claudia Pailalef Montiel	CLAUDIA PAILALEF	M	f	AH	CLAUDIA 	PAILALEF
11411643	D	69	6025	371	371005	Emilia Nuyado Ancapichun	EMILIA NUYADO	M	f	AH	EMILIA	NUYADO
13823854	D	73	6025	371	371002	Hector Alejandro Barria Angulo	HÉCTOR BARRÍA	M	f	AH	HÉCTOR 	BARRÍA
12753805	D	74	6025	356	356142	Hector Ojeda Ruiz	HÉCTOR OJEDA	M	f	AL	HÉCTOR	OJEDA
8809602	D	76	6025	339	339150	Pamela Bongain Acevedo	PAMELA BONGAIN	M	f	AP	PAMELA	BONGAIN
15689327	D	75	6025	339	339150	Marisol Del Carmen Bañares Zuñiga	MARISOL BAÑARES	M	f	AP	MARISOL 	BAÑARES
8300590	D	77	6025	339	339150	Harry Jurgensen Rundshagen	HARRY JURGENSEN	M	t	AP	HARRY	JURGENSEN
9819228	D	79	6025	339	339150	Natacha Odette Rivas Morales	NATACHA RIVAS	M	t	AP	NATACHA	RIVAS
17243412	D	80	6025	366	366045	Daniela Abigail Carvacho Diaz	DANIELA CARVACHO	M	f	AR	DANIELA	CARVACHO
7562068	D	78	6025	339	339150	Sebastian Cristi Alfonso	SEBASTIÁN CRISTI	M	t	AP	SEBASTIÁN	CRISTI
18904336	D	82	6025	366	366149	Nestor Nicolas Abarzua Aviles	NÉSTOR ABARZÚA	M	t	AR	NÉSTOR 	ABARZÚA
7095290	D	83	6025	366	366006	Angelica Gallegos Toledo	ANGÉLICA GALLEGOS	M	f	AR	ANGÉLICA	GALLEGOS
10392281	D	85	6025	350	350148	Jorge Garcia Malherbe	JORGE GARCÍA	M	f	AW	JORGE	GARCÍA
18106576	D	84	6025	366	366006	Danitza Scarleth Ortiz Viveros	DANITZA ORTIZ	M	f	AR	DANITZA 	ORTIZ
12754419	D	81	6025	366	366045	German Rodrigo Cartes Oyarzo	GERMÁN CARTES	M	f	AR	GERMÁN 	CARTES
13964206	D	86	6025	350	350180	Alberto Alejandro Lopez Engel	ALBERTO LÓPEZ	M	f	AW	ALBERTO 	LÓPEZ
13218570	D	87	6025	350	350180	Gerardo Andres Del Lago Cuvertino	GERARDO DEL	M	t	AW	GERARDO	DEL LAGO
10175599	D	63	6026	358	358003	Marcos Emilfork Konow	MARCOS EMILFORK	M	t	AA	MARCOS 	EMILFORK
9060276	D	64	6026	358	358003	Fernando Borquez Montecinos	FERNANDO BÓRQUEZ	M	t	AA	FERNANDO	BÓRQUEZ
16779238	D	60	6026	358	358001	Daniel Cardenas Mansilla	DANIEL CARDENAS	M	t	AA	DANIEL	CARDENAS
10648105	D	62	6026	358	358001	Jose Eulogio Aburto Ancapan	JOSÉ ABURTO	M	f	AA	JOSÉ	ABURTO
16136292	D	61	6026	358	358001	Mauro Daniel Gonzalez Villarroel	MAURO GONZÁLEZ	M	f	AA	MAURO 	GONZÁLEZ
15300079	D	66	6026	368	368157	Ximena Alejandra Uribe Canobra	XIMENA URIBE	M	f	AB	XIMENA 	URIBE
19790055	D	68	6026	368	368157	Nataly Javiera Oyarzo Cardenas	NATALY OYARZO	M	f	AB	NATALY 	OYARZO
15997241	D	71	6026	371	371002	Carolina Carcamo Hernandez	CAROLINA CÁRCAMO	M	f	AH	CAROLINA	CÁRCAMO
16136537	D	65	6026	358	358003	Andres Alejandro Santana Riquelme	ANDRÉS SANTANA	M	f	AA	ANDRÉS 	SANTANA
15285307	D	67	6026	368	368157	Javier Antonio Olavarria Morales	JAVIER OLAVARRÍA	M	f	AB	JAVIER	OLAVARRÍA
6913397	D	73	6026	371	371005	Alban Mancilla Diaz	ALBÁN MANCILLA	M	f	AH	ALBÁN	MANCILLA
13609677	D	70	6026	371	371137	Alejandro Javier Bernales Maldonado	ALEJANDRO BERNALES	M	f	AH	ALEJANDRO 	BERNALES
16155426	D	72	6026	371	371004	Guillermo Roa Urzua	GUILLERMO ROA	M	f	AH	GUILLERMO	ROA
11503440	D	74	6026	371	371138	Hector David Ulloa Aguilera	HÉCTOR ULLOA	M	t	AH	HÉCTOR	ULLOA
13029768	D	76	6026	356	356142	Carol Varas Pantoja	CAROL VARAS	M	f	AL	CAROL	VARAS
15299561	D	80	6026	339	339150	Ivan Bustamante Navarro	IVÁN BUSTAMANTE	M	f	AP	IVÁN	BUSTAMANTE
16526049	D	69	6026	368	368157	Vanessa Natalie Barria Barria	VANESSA BARRÍA	M	f	AB	VANESSA 	BARRÍA
10825701	D	75	6026	356	356142	Alfonso Belmar Rodriguez	ALFONSO BELMAR	M	f	AL	ALFONSO	BELMAR
18165582	D	77	6026	356	356142	Ariel Marchioni Bowen	ARIEL MARCHIONI	M	f	AL	ARIEL	MARCHIONI
9147545	D	84	6026	339	339150	Arturo Bernardo Grandon Arredondo	ARTURO GRANDÓN	M	t	AP	ARTURO 	GRANDÓN
12999361	D	78	6026	356	356142	Ingrid Jara Andrade	INGRID JARA	M	f	AL	INGRID	JARA
6373718	D	81	6026	339	339150	Daniel Prieto Vial	DANIEL PRIETO	M	f	AP	DANIEL 	PRIETO
7367592	D	82	6026	339	339150	Jairo Miguel Quinteros Rodriguez	JAIRO QUINTEROS	M	t	AP	JAIRO 	QUINTEROS
14393817	D	85	6026	339	339150	Veronica Becerra Vergara	VERÓNICA BECERRA	M	t	AP	VERÓNICA	BECERRA
10687838	D	79	6026	356	356142	Marisol Parancan Soto	MARISOL PARANCÁN	M	f	AL	MARISOL	PARANCÁN
16988372	D	88	6026	366	366006	Eduardo Antonio Ocampo Castillo	EDUARDO OCAMPO	M	f	AR	EDUARDO 	OCAMPO
14313117	D	87	6026	366	366045	Mariela Cecilia Nuñez Avila	MARIELA NÚÑEZ	M	t	AR	MARIELA 	NÚÑEZ
15551271	D	86	6026	366	366045	Jaime Salvador Saez Quiroz	JAIME SÁEZ	M	f	AR	JAIME	SÁEZ
7366722	D	83	6026	339	339150	David Alberto Zambrano Garay	DAVID ZAMBRANO	M	t	AP	DAVID	ZAMBRANO
16796368	D	89	6026	366	366006	Valeska Francisca Gomez Urrutia	VALESKA GÓMEZ	M	f	AR	VALESKA 	GÓMEZ
13499706	D	95	6026	350	350180	Orlando Castillo Valencia	ORLANDO CASTILLO	M	t	AW	ORLANDO	CASTILLO
20064631	D	93	6026	350	350148	Damaris Solange Jara Navarro	DAMARIS JARA	M	t	AW	DAMARIS 	JARA
14403562	D	90	6026	366	366143	Maria Cristina Bustos Concha	MARÍA BUSTOS	M	t	AR	MARÍA CRISTINA	BUSTOS
10483916	D	97	6026	999	99	Arturo Sanchez Gatica	ARTURO SÁNCHEZ	M	t	ZZZ	ARTURO	SÁNCHEZ
19200960	D	96	6026	350	350180	Maria Noelia Muñoz Ponte	MARÍA MUÑOZ	M	t	AW	MARÍA NOELIA	MUÑOZ
11714546	D	91	6026	366	366149	Francisco Alberto Chavez Catepillan	FRANCISCO CHÁVEZ	M	t	AR	FRANCISCO 	CHÁVEZ
8242746	D	94	6026	350	350148	Elisa Triviño Mancilla	ELISA TRIVIÑO	M	f	AW	ELISA	TRIVIÑO
15402287	D	92	6026	350	350148	Josefa Belmar Bahamondez	JOSEFA BELMAR	M	f	AW	JOSEFA	BELMAR
14493248	D	60	6027	358	358140	Jaime Briceño Sazo	JAIME BRICEÑO	M	t	AA	JAIME	BRICEÑO
8378883	D	61	6027	358	358001	Marcia Raphael Mora	MARCIA RAPHAEL	M	f	AA	MARCIA	RAPHAEL
12362098	D	62	6027	358	358037	Eugenio Canales Canales	EUGENIO CANALES	M	t	AA	EUGENIO 	CANALES
12919307	D	63	6027	358	358003	Alejandra Valdebenito Torres	ALEJANDRA VALDEBENITO	M	f	AA	ALEJANDRA	VALDEBENITO
14042800	D	64	6027	368	368157	Juan Ruben Cardenas Arriagada	JUAN CARDENAS	M	f	AB	JUAN RUBÉN	CARDENAS
17287602	D	66	6027	368	368157	Americo Eugenio Aedo Urra	AMÉRICO AEDO	M	f	AB	AMÉRICO 	AEDO
16102239	D	65	6027	368	368157	Nathali Valeska Roa Rebolledo	NATHALI ROA	M	f	AB	NATHALI 	ROA
10398789	D	75	6027	366	366045	Marianela Paola Molina Mansilla	MARIANELA MOLINA	M	f	AR	MARIANELA	MOLINA
10010248	D	70	6027	371	371007	Karina Alejandra Acevedo Auad	KARINA ACEVEDO	M	f	AH	KARINA 	ACEVEDO
16102058	D	68	6027	371	371002	Miguel Angel Calisto Aguila	MIGUEL CALISTO	M	f	AH	MIGUEL ANGEL	CALISTO
16960451	D	69	6027	371	371005	Rodrigo Saldivia Vera	RODRIGO SALDIVIA	M	f	AH	RODRIGO 	SALDIVIA
10064791	D	67	6027	368	368157	Karin Pamela Contreras Murtschwa	KARIN CONTRERAS	M	f	AB	KARIN 	CONTRERAS
8601442	D	71	6027	371	371004	Rene Alinco Bustos	RENÉ ALINCO	M	t	AH	RENÉ	ALINCO
13160111	D	72	6027	366	366006	Juan Enrique Catalan Jara	JUAN CATALÁN	M	f	AR	JUAN ENRIQUE	CATALÁN
13170875	D	76	6027	999	99	Hansy Paola Chavez Gomez	HANSY CHÁVEZ	M	t	ZZZ	HANSY 	CHÁVEZ
18304125	D	73	6027	366	366006	Isabel Garrido Casassa	ISABEL GARRIDO	M	f	AR	ISABEL	GARRIDO
13244595	D	74	6027	366	366045	Julio Francisco ñanco Antilef	JULIO ÑANCO	M	f	AR	JULIO 	ÑANCO
6626858	D	63	6028	358	358037	Christian Matheson Villan	CHRISTIAN MATHESON	M	t	AA	CHRISTIAN 	MATHESON
10380439	D	62	6028	358	358003	Liz Natalia Casanueva Mendez	LIZ CASANUEVA	M	f	AA	LIZ 	CASANUEVA
10965357	D	60	6028	358	358140	Cesar Cifuentes Muñoz	CÉSAR CIFUENTES	M	t	AA	CÉSAR	CIFUENTES
13970493	D	61	6028	358	358140	Paola Yañez Riquelme	PAOLA YÁÑEZ	M	t	AA	PAOLA	YÁÑEZ
14229808	D	67	6028	368	368157	Jose Fernando Olivares Ojeda	JOSÉ OLIVARES	M	f	AB	JOSÉ	OLIVARES
9440974	D	66	6028	368	368157	Patricia Liliana Vivar Vivar	PATRICIA VIVAR	M	f	AB	PATRICIA 	VIVAR
17892899	D	64	6028	368	368157	Katia Andrea Trujillo Hidalgo	KATIA TRUJILLO	M	f	AB	KATIA	TRUJILLO
16753007	D	65	6028	368	368157	Jesus Alier Torres Roldan	JESÚS TORRES	M	f	AB	JESÚS 	TORRES
7961707	D	68	6028	371	371007	Jaime Mauricio Jelincic Aguilar	JAIME JELINCIC	M	f	AH	JAIME 	JELINCIC
16966666	D	69	6028	371	371002	Constanza Andrea Vargas Aguila	CONSTANZA VARGAS	M	f	AH	CONSTANZA	VARGAS
9753595	D	72	6028	347	347008	Nieves Del Carmen Rain Cayun	NIEVES RAIN	M	f	AN	NIEVES 	RAIN
17586825	D	71	6028	371	371005	Vanja Rogosich Cvitanic	VANJA ROGOSICH	M	f	AH	VANJA	ROGOSICH
16066441	D	70	6028	371	371005	Christian Ariel Gallardo Castro	CHRISTIAN GALLARDO	M	f	AH	CHRISTIAN 	GALLARDO
11882175	D	76	6028	339	339162	David Natanael Romo Garrido	DAVID ROMO	M	f	AP	DAVID 	ROMO
9390231	D	74	6028	339	339162	David Paillan Coney	DAVID PAILLÁN	M	f	AP	DAVID	PAILLÁN
15580272	D	78	6028	366	366149	Javiera Ignacia Morales Alvarado	JAVIERA MORALES	M	t	AR	JAVIERA	MORALES
6577795	D	81	6028	366	366006	Luis Miguel Burgos Sanhueza	LUIS BURGOS	M	t	AR	LUIS 	BURGOS
8250042	D	73	6028	347	347008	Luis Ricardo Legaza Soto	LUIS LEGAZA	M	t	AN	LUIS 	LEGAZA
10333951	D	77	6028	339	339150	Maximiliano Ulises Carcamo Gonzalez	MAXIMILIANO CARCAMO	M	f	AP	MAXIMILIANO 	CARCAMO
19295749	D	75	6028	339	339162	Javiera Cristina Calvo Rifo	JAVIERA CALVO	M	f	AP	JAVIERA	CALVO
19253795	D	80	6028	366	366006	Nikos Sued Ortega Cardenas	NIKOS ORTEGA	M	f	AR	NIKOS	ORTEGA
7452450	D	82	6028	999	99	Carlos Bianchi Chelech	CARLOS BIANCHI	M	t	ZZZ	CARLOS	BIANCHI
10337442	D	79	6028	366	366149	Doris Nelly Sandoval Miranda	DORIS SANDOVAL	M	t	AR	DORIS 	SANDOVAL
16163631	P	1	0	365	149	Gabriel Boric Font	GABRIEL BORIC	M	f	A	GABRIEL	BORIC
8653179	P	3	0	370	2	Yasna Provoste Campillay	YASNA PROVOSTE	M	f	A	YASNA	PROVOSTE
10273010	P	4	0	357	37	Sebastian Sichel Ramirez	SEBASTIÁN SICHEL	M	f	A	SEBASTIÁN	SICHEL
6195038	P	5	0	374	147	Eduardo Artes Brichetti	EDUARDO ARTÉS	M	f	A	EDUARDO	ARTÉS
6872197	P	7	0	367	157	Franco Parisi Fernandez	FRANCO PARISI	M	f	A	FRANCO	PARISI
13436389	P	6	0	373	139	Marco Enriquez-ominami Gumucio	MARCO E-OMINAMI	M	f	A	MARCO	ENRÍQUEZ-OMINAMI
7477226	P	2	0	339	150	Jose Antonio Kast Rist	JOSE KAST	M	f	A	JOSÉ ANTONIO	KAST
\.


--
-- Name: candidato_candidato_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('candidato_candidato_id_seq', 1, false);


--
-- Name: candidato_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('candidato_id_seq', 1, true);


--
-- Data for Name: comuna; Type: TABLE DATA; Schema: public; Owner: app_vav
--

COPY comuna (comuna_id, region_id, distrito_id, comuna_nombre) FROM stdin;
2739	3011	27	Aysén
2740	3011	27	Cisnes
2741	3011	27	Guaitecas
2751	3012	28	Cabo De Hornos
2752	3012	28	Antártica
2508	3002	3	Antofagasta
2509	3002	3	Mejillones
2510	3002	3	Sierra Gorda
2511	3002	3	Taltal
2654	3008	21	Lebu
2655	3008	21	Arauco
2656	3008	21	Cañete
2657	3008	21	Contulmo
2658	3008	21	Curanilahue
2659	3008	21	Los Alamos
2660	3008	21	Tirúa
2822	3015	1	Arica
2823	3015	1	Camarones
2661	3008	21	Los ángeles
2662	3008	21	Antuco
2663	3008	21	Cabrero
2664	3008	21	Laja
2665	3008	21	Mulchén
2666	3008	21	Nacimiento
2667	3008	21	Negrete
2668	3008	21	Quilaco
2669	3008	21	Quilleco
2670	3008	21	San Rosendo
2671	3008	21	Santa Bárbara
2672	3008	21	Tucapel
2673	3008	21	Yumbel
2674	3008	21	Alto Biobío
2579	3006	15	Rancagua
2580	3006	15	Codegua
2581	3006	15	Coinco
2582	3006	15	Coltauco
2583	3006	15	Doñihue
2584	3006	15	Graneros
2585	3006	16	Las Cabras
2586	3006	15	Machalí
2587	3006	15	Malloa
2588	3006	15	Mostazal
2589	3006	15	Olivar
2590	3006	16	Peumo
2591	3006	16	Pichidegua
2592	3006	15	Quinta De Tilcoco
2593	3006	15	Rengo
2594	3006	15	Requínoa
2595	3006	16	San Vicente
2742	3011	27	Cochrane
2743	3011	27	Ohiggins
2744	3011	27	Tortel
2596	3006	16	Pichilemu
2597	3006	16	La Estrella
2598	3006	16	Litueche
2599	3006	16	Marchigue
2600	3006	16	Navidad
2601	3006	16	Paredones
2622	3007	18	Cauquenes
2623	3007	18	Chanco
2624	3007	18	Pelluhue
2675	3009	23	Temuco
2686	3009	23	Padre Las Casas
2676	3009	23	Carahue
2677	3009	23	Cunco
2678	3009	23	Curarrehue
2679	3009	23	Freire
2680	3009	22	Galvarino
2681	3009	23	Gorbea
2682	3009	22	Lautaro
2683	3009	23	Loncoche
2684	3009	22	Melipeuco
2685	3009	23	Nueva Imperial
2687	3009	22	Perquenco
2688	3009	23	Pitrufquén
2689	3009	23	Pucón
2690	3009	23	Saavedra
2691	3009	23	Teodoro Schmidt
2692	3009	23	Toltén
2693	3009	22	Vilcún
2694	3009	23	Villarrica
2695	3009	23	Cholchol
2793	3013	8	Colina
2794	3013	8	Lampa
2795	3013	8	Tiltil
2520	3003	4	Chañaral
2521	3003	4	Diego De Almagro
2716	3010	26	Castro
2717	3010	26	Ancud
2718	3010	26	Chonchi
2719	3010	26	Curaco De Vélez
2720	3010	26	Dalcahue
2721	3010	26	Puqueldón
2722	3010	26	Queilén
2723	3010	26	Quellón
2724	3010	26	Quemchi
2725	3010	26	Quinchao
2532	3004	5	Illapel
2533	3004	5	Canela
2534	3004	5	Los Vilos
2535	3004	5	Salamanca
2602	3006	16	San Fernando
2603	3006	16	Chépica
2604	3006	16	Chimbarongo
2605	3006	16	Lolol
2606	3006	16	Nancagua
2607	3006	16	Palmilla
2608	3006	16	Peralillo
2609	3006	16	Placilla
2610	3006	16	Pumanque
2611	3006	16	Santa Cruz
2648	3008	20	Penco
2651	3008	20	Talcahuano
2652	3008	20	Tomé
2653	3008	20	Hualpén
2642	3008	20	Concepción
2644	3008	20	Chiguayante
2645	3008	20	Florida
2643	3008	20	Coronel
2646	3008	20	Hualqui
2647	3008	21	Lota
2649	3008	20	San Pedro De La Paz
2650	3008	20	Santa Juana
2517	3003	4	Copiapó
2518	3003	4	Caldera
2519	3003	4	Tierra Amarilla
2790	3013	12	Puente Alto
2791	3013	12	Pirque
2792	3013	12	San José De Maipo
2737	3011	27	Coyhaique
2738	3011	27	Lago Verde
2625	3007	17	Curicó
2626	3007	17	Hualañé
2627	3007	17	Licantén
2628	3007	17	Molina
2629	3007	17	Rauco
2630	3007	17	Romeral
2631	3007	17	Sagrada Familia
2632	3007	17	Teno
2633	3007	17	Vichuquén
2826	3016	19	Chillán
2827	3016	19	Bulnes
2828	3016	19	Chillán Viejo
2829	3016	19	El Carmen
2830	3016	19	Pemuco
2831	3016	19	Pinto
2832	3016	19	Quillón
2833	3016	19	San Ignacio
2834	3016	19	Yungay
2512	3002	3	Calama
2513	3002	3	Ollagüe
2514	3002	3	San Pedro De Atacama
2526	3004	5	La Serena
2527	3004	5	Coquimbo
2528	3004	5	Andacollo
2529	3004	5	La Higuera
2530	3004	5	Paihuano
2531	3004	5	Vicuña
2745	3011	27	Chile Chico
2746	3011	27	Río Ibañez
2522	3003	4	Vallenar
2523	3003	4	Alto Del Carmen
2524	3003	4	Freirina
2525	3003	4	Huasco
2501	3001	2	Iquique
2502	3001	2	Alto Hospicio
2548	3005	7	Isla De Pascua
2835	3016	19	Quirihue
2836	3016	19	Cobquecura
2837	3016	19	Coelemu
2838	3016	19	Ninhue
2839	3016	19	Portezuelo
2840	3016	19	Ránquil
2841	3016	19	Trehuaco
2536	3004	5	Ovalle
2537	3004	5	Combarbalá
2538	3004	5	Monte Patria
2539	3004	5	Punitaqui
2540	3004	5	Río Hurtado
2634	3007	18	Linares
2635	3007	18	Colbún
2636	3007	18	Longaví
2637	3007	18	Parral
2638	3007	18	Retiro
2639	3007	18	San Javier
2640	3007	18	Villa Alegre
2641	3007	18	Yerbas Buenas
2707	3010	26	Puerto Montt
2708	3010	26	Calbuco
2709	3010	26	Cochamó
2710	3010	25	Fresia
2711	3010	25	Frutillar
2712	3010	25	Los Muermos
2713	3010	25	Llanquihue
2714	3010	26	Maullín
2715	3010	25	Puerto Varas
2549	3005	6	Los Andes
2550	3005	6	Calle Larga
2551	3005	6	Rinconada
2552	3005	6	San Esteban
2747	3012	28	Punta Arenas
2748	3012	28	Laguna Blanca
2749	3012	28	Río Verde
2750	3012	28	San Gregorio
2796	3013	14	San Bernardo
2797	3013	14	Buin
2798	3013	14	Calera De Tango
2799	3013	14	Paine
2696	3009	22	Angol
2697	3009	22	Collipulli
2698	3009	22	Curacautín
2699	3009	22	Ercilla
2700	3009	22	Lonquimay
2701	3009	22	Los Sauces
2702	3009	22	Lumaco
2703	3009	22	Purén
2704	3009	22	Renaico
2705	3009	22	Traiguén
2706	3009	22	Victoria
2575	3005	6	Quilpué
2576	3005	6	Limache
2577	3005	6	Olmué
2578	3005	6	Villa Alemana
2800	3013	14	Melipilla
2801	3013	14	Alhué
2802	3013	14	Curacaví
2803	3013	14	María Pinto
2804	3013	14	San Pedro
2726	3010	25	Osorno
2727	3010	25	Puerto Octay
2728	3010	25	Purranque
2729	3010	25	Puyehue
2730	3010	25	Río Negro
2731	3010	25	San Juan De La Costa
2732	3010	25	San Pablo
2733	3010	26	Chaitén
2734	3010	26	Futaleufú
2735	3010	26	Hualaihué
2736	3010	26	Palena
2824	3015	1	Putre
2825	3015	1	General Lagos
2553	3005	6	La Ligua
2554	3005	6	Cabildo
2555	3005	6	Papudo
2556	3005	6	Petorca
2557	3005	6	Zapallar
2842	3016	19	San Carlos
2843	3016	19	Coihueco
2844	3016	19	ñiquén
2845	3016	19	San Fabián
2846	3016	19	San Nicolás
2558	3005	6	Quillota
2559	3005	6	Calera
2560	3005	6	Hijuelas
2561	3005	6	La Cruz
2562	3005	6	Nogales
2818	3014	24	La Unión
2819	3014	24	Futrono
2820	3014	24	Lago Ranco
2821	3014	24	Río Bueno
2563	3005	7	San Antonio
2564	3005	7	Algarrobo
2565	3005	7	Cartagena
2566	3005	7	El Quisco
2567	3005	7	El Tabo
2568	3005	7	Santo Domingo
2569	3005	6	San Felipe
2570	3005	6	Catemu
2571	3005	6	Llaillay
2572	3005	6	Panquehue
2573	3005	6	Putaendo
2574	3005	6	Santa María
2761	3013	9	Conchalí
2764	3013	9	Huechuraba
2781	3013	8	Pudahuel
2782	3013	8	Quilicura
2785	3013	9	Renca
2758	3013	10	Santiago
2760	3013	9	Cerro Navia
2765	3013	9	Independencia
2774	3013	9	Lo Prado
2783	3013	9	Quinta Normal
2784	3013	9	Recoleta
2759	3013	8	Cerrillos
2763	3013	8	Estación Central
2776	3013	8	Maipú
2770	3013	11	La Reina
2771	3013	11	Las Condes
2772	3013	11	Lo Barnechea
2777	3013	10	ñuñoa
2780	3013	10	Providencia
2789	3013	11	Vitacura
2767	3013	12	La Florida
2768	3013	10	La Granja
2775	3013	10	Macul
2779	3013	11	Peñalolén
2786	3013	10	San Joaquín
2762	3013	13	El Bosque
2766	3013	13	La Cisterna
2769	3013	12	La Pintana
2773	3013	13	Lo Espejo
2778	3013	13	Pedro Aguirre Cerda
2787	3013	13	San Miguel
2788	3013	13	San Ramón
2805	3013	14	Talagante
2806	3013	14	El Monte
2807	3013	14	Isla De Maipo
2808	3013	14	Padre Hurtado
2809	3013	14	Peñaflor
2612	3007	17	Talca
2613	3007	17	Constitución
2614	3007	17	Curepto
2615	3007	17	Empedrado
2616	3007	17	Maule
2617	3007	17	Pelarco
2618	3007	17	Pencahue
2619	3007	17	Río Claro
2620	3007	17	San Clemente
2621	3007	17	San Rafael
2503	3001	2	Pozo Almonte
2504	3001	2	Camiña
2505	3001	2	Colchane
2506	3001	2	Huara
2507	3001	2	Pica
2753	3012	28	Porvenir
2754	3012	28	Primavera
2755	3012	28	Timaukel
2515	3002	3	Tocopilla
2516	3002	3	María Elena
2756	3012	28	Natales
2757	3012	28	Torres Del Paine
2810	3014	24	Valdivia
2811	3014	24	Corral
2812	3014	24	Lanco
2813	3014	24	Los Lagos
2814	3014	24	Mafil
2815	3014	24	Mariquina
2816	3014	24	Paillaco
2817	3014	24	Panguipulli
2543	3005	7	Concón
2545	3005	6	Puchuncaví
2546	3005	6	Quintero
2547	3005	7	Viña Del Mar
2541	3005	7	Valparaíso
2542	3005	7	Casablanca
2544	3005	7	Juan Fernández
\.


--
-- Name: comuna_comuna_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('comuna_comuna_id_seq', 1, false);


--
-- Name: comuna_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('comuna_id_seq', 1, false);


--
-- Data for Name: imagen; Type: TABLE DATA; Schema: public; Owner: app_vav
--

COPY imagen (imagen_id, imagen_orden, imagen_objeto, imagen_tipo, imagen_estado, imagen_titulo, imagen_bajada, imagen_tags, imagen_extension, imagen_cambio, imagen_creado) FROM stdin;
8	0	4	USU	1	\N	\N	\N	.jpg	1602265410	2020-10-09 14:43:31.094739
7	1	4	USU	1	\N	\N	\N	.png	1600980043	2020-09-24 17:40:43.731684
4	2	4	USU	1	\N	\N	\N	.jpg	1583847203	2020-03-10 10:33:24.036709
6	0	5	USU	1	\N	\N	\N	.png	1600980020	2020-09-24 17:40:21.014274
5	1	5	USU	1	\N	\N	\N	.jpg	1583847295	2020-03-10 10:34:55.266077
\.


--
-- Name: imagen_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('imagen_id_seq', 8, true);


--
-- Name: imagen_imagen_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('imagen_imagen_id_seq', 1, false);


--
-- Data for Name: mesa; Type: TABLE DATA; Schema: public; Owner: app_vav
--

COPY mesa (mesa_id, usuario_id, mesa_tipo, mesa_zona, mesa_zona_titulo, mesa_comuna, mesa_local, mesa_numero, mesa_orden, mesa_estado, mesa_destacada, mesa_votos_blancos, mesa_votos_nulos, mesa_cambio, mesa_creado) FROM stdin;
108	4	D	6011	Distrito 11	Vitacura	Nombre de un colegio	M 3	1	1	0	0	0	2021-11-20 17:11:55.114945	2021-11-20 17:11:40.289914
110	4	P	0	Región de Valparaíso	Viña Del Mar	Nombre de un colegio	M 3	1	0	0	0	0	2021-11-20 19:28:41.290954	2021-11-20 19:01:19.675495
106	4	P	0	Región Metropolitana	Vitacura	Nombre de un colegio	M 1	1	1	0	0	0	2021-11-20 19:28:51.015754	2021-11-20 17:08:05.241189
109	4	P	0	Región Metropolitana	Las Condes	Nombre de un colegio	M 2	1	1	0	0	0	2021-11-20 19:29:00.891877	2021-11-20 18:39:14.273658
107	4	S	5007	Circunscripción 7	Vitacura	Nombre de un colegio	M 2	1	0	0	0	0	2021-11-20 19:00:39.161291	2021-11-20 17:10:05.065173
\.


--
-- Name: mesa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('mesa_id_seq', 110, true);


--
-- Name: mesa_mesa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('mesa_mesa_id_seq', 1, false);


--
-- Data for Name: pacto; Type: TABLE DATA; Schema: public; Owner: app_vav
--

COPY pacto (pacto_id, pacto_codigo, pacto_nombre) FROM stdin;
315		Sin Pacto
318	AC	Ecologistas E Independientes
319	AU	Chile Vamos Renovacion Nacional - Independientes
320	AD	Chile Vamos Udi - Independientes
321	AQ	Chile Vamos Evopoli - Independientes
322	AI	Chile Vamos - Pri E Independientes
323	AV	Frente Amplio
324	AG	Unidad Constituyente
325	AJ	Democracia Ciudadana
326	AS	Cambio Radical Progresista
341	AP	Frente Social Cristiano
344	BD	Republicanos E Independientes
345	AZ	Partido Conservador Cristiano E Independientes
346	AN	Dignidad Ahora
347	AN	Dignidad Ahora
348	AF	Humanicemos Chile
349	AW	Independientes Unidos
350	AW	Independientes Unidos
351	AW	Independientes Unidos
352	AX	Regionalistas Verdes E Independientes
353	AT	Nuevo Tiempo
354	AT	Nuevo Tiempo
355	AL	Partido Ecologista Verde
356	AL	Partido Ecologista Verde
358	AA	Chile Podemos +
359	AO	Por Un Chile Digno
362	AK	Frente Por La Unidad De La Clase Trabajadora
363	AE	Partido De Trabajadores Revolucionarios
364	AE	Partido De Trabajadores Revolucionarios
366	AR	Apruebo Dignidad
368	AB	Partido De La Gente
369	AB	Partido De La Gente
371	AH	Nuevo Pacto Social
375	AM	Union Patriotica
376	AM	Union Patriotica
999		Independiente
365	A. DIGNIDAD	Apruebo Dignidad
339	F. S. CRISTIANO	Frente Social Cristiano
370	N. PACTO SOCIAL	Nuevo Pacto Social
357	CHILE PODEMOS+	Chile Podemos +
374	U. PATRIÓTICA	Union Patriotica
373	P. PROGRESISTA	Partido Progresista De Chile
367	P. DE LA GENTE	Partido De La Gente
\.


--
-- Name: pacto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('pacto_id_seq', 1, false);


--
-- Name: pacto_pacto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('pacto_pacto_id_seq', 1, false);


--
-- Data for Name: partido; Type: TABLE DATA; Schema: public; Owner: app_vav
--

COPY partido (partido_id, partido_nombre, partido_codigo) FROM stdin;
2	Partido Democrata Cristiano	DC
37	Evolucion Politica	EVO
99	Independientes	IND
139	Partido Progresista De Chile	PRO
147	Union Patriotica	UPA
149	Convergencia Social	CS
150	Partido Republicano De Chile	REP
157	Partido De La Gente	PDG
319001	Renovacion Nacional	RN
319099	Independientes	IND
320003	Union Democrata Independiente	UDI
320099	Independientes	IND
321037	Evolucion Politica	EVO
321099	Independientes	IND
322099	Independientes	IND
322140	Partido Regionalista Independiente Democrata	PRI
339150	Partido Republicano De Chile	REP
339162	Partido Conservador Cristiano	PCC
341150	Partido Republicano De Chile	REP
341162	Partido Conservador Cristiano	PCC
344099	Independientes	IND
344150	Partido Republicano De Chile	PLR
345099	Independientes	IND
345162	Partido Conservador Cristiano	PCC
346008	Partido Humanista	PH
346144	Igualdad	PI
347008	Partido Humanista	PH
347144	Igualdad	PI
348008	Partido Humanista	PH
348099	Independientes	IND
349148	Partido Nacional Ciudadano	PNC
349180	Centro Unido	CU
350148	Partido Nacional Ciudadano	PNC
350180	Centro Unido	CU
351099	Independientes	IND
351148	Partido Nacional Ciudadano	PNC
351180	Centro Unido	CU
352099	Independientes	IND
352130	Federacion Regionalista Verde Social	FRVS
353126	Nuevo Tiempo	NT
354126	Nuevo Tiempo	NT
355142	Partido Ecologista Verde	PEV
356142	Partido Ecologista Verde	PEV
357001	Renovacion Nacional	RN
357003	Union Democrata Independiente	UDI
357037	Evolucion Politica	EVO
357140	Partido Regionalista Independiente Democrata	PRI
358001	Renovacion Nacional	RN
358003	Union Democrata Independiente	UDI
358037	Evolucion Politica	EVO
358140	Partido Regionalista Independiente Democrata	PRI
362099	Independientes	IND
362135	Partido De Trabajadores Revolucionarios	PTR
363135	Partido De Trabajadores Revolucionarios	PTR
364135	Partido De Trabajadores Revolucionarios	PTR
365006	Partido Comunista De Chile	PC
365045	Revolucion Democratica	RD
365130	Federacion Regionalista Verde Social	FRVS
365143	Comunes	COM
365149	Convergencia Social	CS
366006	Partido Comunista De Chile	PC
366045	Revolucion Democratica	RD
366130	Federacion Regionalista Verde Social	FRVS
366143	Comunes	COM
366149	Convergencia Social	CS
367157	Partido De La Gente	PDG
368157	Partido De La Gente	PDG
369157	Partido De La Gente	PDG
370002	Partido Democrata Cristiano	DC
370004	Partido Por La Democracia	PPD
370005	Partido Socialista De Chile	PS
370007	Partido Radical De Chile	PR
370137	Partido Liberal De Chile	PL
371002	Partido Democrata Cristiano	DC
371004	Partido Por La Democracia	PPD
371005	Partido Socialista De Chile	PS
371007	Partido Radical De Chile	PR
371137	Partido Liberal De Chile	PL
371138	Ciudadanos	CIU
373139	Partido Progresista De Chile	PRO
374147	Union Patriotica	UPA
375147	Union Patriotica	UPA
376147	Union Patriotica	UPA
318327099	Independientes	IND
318327142	Partido Ecologista Verde	PEV
323328099	Independientes	IND
323328149	Convergencia Social	CS
323329045	Revolucion Democratica	RD
323329099	Independientes	IND
323330099	Independientes	IND
323330137	Partido Liberal De Chile	PL
323331099	Independientes	IND
323331143	Comunes	COM
324332005	Partido Socialista De Chile	PS
324332099	Independientes	IND
324333004	Partido Por La Democracia	PPD
324333099	Independientes	IND
325334002	Partido Democrata Cristiano	PDC
325334099	Independientes	IND
325335099	Independientes	IND
325335138	Ciudadanos	CIU
326336007	Partido Radical De Chile	PR
326336099	Independientes	IND
326337099	Independientes	IND
326337139	Partido Progresista De Chile	PRO
359360006	Partido Comunista De Chile	PCC
359360099	Independientes	IND
359361099	Independientes	IND
359361144	Igualdad	PI
\.


--
-- Name: partido_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('partido_id_seq', 1, true);


--
-- Name: partido_partido_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('partido_partido_id_seq', 1, false);


--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: app_vav
--

COPY region (region_id, region_nombre, region_codigo) FROM stdin;
3015	Región de Arica y Parinacota	XV
3001	Región de Tarapacá	I
3002	Región de Antofagasta	II
3003	Región de Atacama	III
3004	Región de Coquimbo	IV
3005	Región de Valparaíso	V
3013	Región Metropolitana	RM
3006	Región de O’higgins	VI
3007	Región del Maule	VII
3016	Región de Ñuble	XVI
3008	Región del Biobio	VIII
3009	Región de la Araucania	IX
3014	Región de Los Rios	XIV
3010	Región de Los Lagos	X
3011	Región de Aysén	XI
3012	Región de Magallanes	XII
\.


--
-- Name: region_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('region_id_seq', 1, false);


--
-- Name: region_region_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('region_region_id_seq', 1, false);


--
-- Data for Name: swich; Type: TABLE DATA; Schema: public; Owner: app_vav
--

COPY swich (swich_id, swich_mesas, swich_mesa_1, swich_mesa_2, swich_mesa_3, swich_mesa_4, swich_votos, swich_cambio, swich_modo) FROM stdin;
1	1	108	0	0	0	0	2021-11-20 18:55:46.355883	0
\.


--
-- Name: swich_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('swich_id_seq', 1, true);


--
-- Name: swich_swich_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('swich_swich_id_seq', 1, false);


--
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: app_vav
--

COPY usuario (usuario_id, usuario_rol, usuario_estado, usuario_genero, usuario_nombre, usuario_email, usuario_password, usuario_etiqueta, usuario_login, usuario_creado) FROM stdin;
4	AD	0	m	Ivan Villarroel	ivan.villarroel@turner.com	leon	3	2020-03-10 10:33:05.700099	2020-03-10 10:33:05.700099
11	AD	0	n	Jaima Lara	jaime	warner	1	2020-10-14 11:05:01.113423	2020-10-14 11:05:01.113423
25	VZ	1	n	Boris	boris	chv	1	2021-05-12 16:34:27.4793	2021-05-12 16:34:27.4793
29	OP	1	n	Prensa 1	prensa1	chv	1	2021-05-15 19:06:10.580988	2021-05-15 19:06:10.580988
30	OP	1	n	Prensa 2	prensa2	chv	1	2021-05-16 12:02:19.180109	2021-05-16 12:02:19.180109
32	OP	1	n	Prensa 4	prensa4	chv	1	2021-05-16 12:30:59.800617	2021-05-16 12:30:59.800617
33	OP	1	n	Prensa 5	prensa5	chv	1	2021-05-16 12:32:27.107286	2021-05-16 12:32:27.107286
34	OP	1	n	prensa6	prensa6	chv	1	2021-05-16 12:32:44.65376	2021-05-16 12:32:44.65376
35	OP	1	n	Prensa 7	prensa7	chv	1	2021-05-16 12:33:04.883941	2021-05-16 12:33:04.883941
36	OP	1	n	Prensa 8	prensa8	chv	1	2021-05-16 12:33:26.60897	2021-05-16 12:33:26.60897
37	OP	1	n	Prensa 9	prensa9	chv	1	2021-05-16 12:33:42.400539	2021-05-16 12:33:42.400539
38	OP	1	n	Prensa 10	prensa10	chv	1	2021-05-16 12:34:02.97873	2021-05-16 12:34:02.97873
39	OP	1	n	Prensa 11	prensa11	chv	1	2021-05-16 12:34:24.488852	2021-05-16 12:34:24.488852
40	OP	1	n	Prensa 12	prensa12	chv	1	2021-05-16 12:34:43.359367	2021-05-16 12:34:43.359367
42	OP	1	n	Prensa 14	prensa14	chv	1	2021-05-16 12:35:20.881198	2021-05-16 12:35:20.881198
43	OP	1	n	Prensa 15	prensa15	chv	1	2021-05-16 12:35:46.504819	2021-05-16 12:35:46.504819
41	OP	1	n	Prensa 13	prensa13	chv	1	2021-05-16 12:35:05.598766	2021-05-16 12:35:05.598766
31	OP	1	n	Prensa 3	prensa3	chv	1	2021-05-16 12:09:04.143502	2021-05-16 12:09:04.143502
44	AD	1	n	Monitor	monitor	chv	1	2021-05-16 13:18:19.743646	2021-05-16 13:18:19.743646
47	OP	1	n	APP Pudahuel	app_pudahuel	chv	1	2021-07-18 11:57:29.84005	2021-07-18 11:57:29.84005
45	OP	1	m	APP Providencia	app_providencia	chv	1	2021-07-18 11:55:54.131111	2021-07-18 11:55:54.131111
46	OP	1	n	APP La Florida	app_la_florida	chv	1	2021-07-18 11:57:02.888659	2021-07-18 11:57:02.888659
5	AD	0	m	Alexis Farfan	afarfan	1234	8	2020-03-10 10:34:22.738729	2020-03-10 10:34:22.738729
\.


--
-- Name: usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('usuario_id_seq', 47, true);


--
-- Name: usuario_usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('usuario_usuario_id_seq', 1, false);


--
-- Data for Name: voto; Type: TABLE DATA; Schema: public; Owner: app_vav
--

COPY voto (voto_id, candidato_id, mesa_id, voto_total) FROM stdin;
9601	8653179	106	0
9602	10273010	106	0
9603	6195038	106	0
9607	7022006	107	0
9608	10608619	107	0
9609	13768447	107	0
9610	11978340	107	0
9611	7155618	107	0
9612	10031381	107	0
9613	13656550	107	0
9614	13030035	107	0
9615	10667756	107	0
9616	8665476	107	0
9617	15844381	107	0
9618	12469575	107	0
9619	6908955	107	0
9620	8493329	107	0
9621	8779559	107	0
9622	12710192	107	0
9623	10771962	107	0
9624	10055396	107	0
9625	13575634	107	0
9626	16373659	107	0
9627	10596570	107	0
9628	5993385	107	0
9629	7690949	107	0
9630	14153217	107	0
9631	13298961	107	0
9632	16429997	107	0
9633	11863088	107	0
9634	16297816	107	0
9635	8129286	107	0
9636	6163989	107	0
9637	7824511	107	0
9638	13198884	107	0
9639	9480453	107	0
9640	8698973	107	0
9641	14098529	107	0
9642	16029379	107	0
9643	4938564	107	0
9644	7514846	107	0
9645	12238818	107	0
9646	16470244	107	0
9647	12962150	107	0
9648	10579566	107	0
9649	16126286	107	0
9650	12474572	107	0
9651	15618732	107	0
9652	12232369	108	0
9653	10336478	108	0
9654	10293616	108	0
9655	11736760	108	0
9656	13657451	108	0
9657	15466653	108	0
9658	12071705	108	0
9659	7072349	108	0
9660	13924988	108	0
9661	14469902	108	0
9662	9978882	108	0
9663	15369137	108	0
9664	15707598	108	0
9665	13631352	108	0
9666	16244695	108	0
9667	19316818	108	0
9668	14174671	108	0
9669	8419173	108	0
9670	16749553	108	0
9671	5203995	108	0
9672	8740398	108	0
9673	13154245	108	0
9674	10553034	108	0
9675	9604921	108	0
9676	10307624	108	0
9677	17779600	108	0
9678	17082454	108	0
9679	13260342	108	0
9680	7037855	108	0
9681	17408591	108	0
9682	19064106	108	0
9683	8674948	108	0
9684	7842009	108	0
9685	6242582	108	0
9686	13830950	108	0
9687	15900261	108	0
9688	16366992	108	0
9689	16666357	108	0
9690	7011276	108	0
9691	10848292	108	0
9692	15918139	108	0
9693	14096665	108	0
9694	19296656	108	0
9695	15752128	108	0
9696	12667285	108	0
9697	12123863	108	0
9698	10993733	108	0
9604	6872197	106	0
9706	16163631	110	0
9605	13436389	106	0
9707	8653179	110	0
9708	10273010	110	0
9700	8653179	109	0
9702	6195038	109	0
9704	13436389	109	0
9710	6872197	110	0
9711	13436389	110	0
9712	7477226	110	0
9606	7477226	106	2
9705	7477226	109	25
9699	16163631	109	25
9709	6195038	110	0
9701	10273010	109	0
9703	6872197	109	0
9600	16163631	106	1
\.


--
-- Name: voto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('voto_id_seq', 9712, true);


--
-- Name: voto_voto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_vav
--

SELECT pg_catalog.setval('voto_voto_id_seq', 1, false);


--
-- Name: candidato_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY candidato
    ADD CONSTRAINT candidato_pkey PRIMARY KEY (candidato_id);


--
-- Name: comuna_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY comuna
    ADD CONSTRAINT comuna_pkey PRIMARY KEY (comuna_id);


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
-- Name: pacto_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY pacto
    ADD CONSTRAINT pacto_pkey PRIMARY KEY (pacto_id);


--
-- Name: partido_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY partido
    ADD CONSTRAINT partido_pkey PRIMARY KEY (partido_id);


--
-- Name: region_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY region
    ADD CONSTRAINT region_pkey PRIMARY KEY (region_id);


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
-- Name: voto_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY voto
    ADD CONSTRAINT voto_pkey PRIMARY KEY (voto_id);


--
-- Name: candidato_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY voto
    ADD CONSTRAINT candidato_id_fk FOREIGN KEY (candidato_id) REFERENCES candidato(candidato_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: candidato_pacto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY candidato
    ADD CONSTRAINT candidato_pacto_id_fkey FOREIGN KEY (pacto_id) REFERENCES pacto(pacto_id) ON DELETE CASCADE;


--
-- Name: candidato_partido_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY candidato
    ADD CONSTRAINT candidato_partido_id_fkey FOREIGN KEY (partido_id) REFERENCES partido(partido_id) ON DELETE CASCADE;


--
-- Name: comuna_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY comuna
    ADD CONSTRAINT comuna_region_id_fkey FOREIGN KEY (region_id) REFERENCES region(region_id) ON DELETE RESTRICT;


--
-- Name: mesa_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY voto
    ADD CONSTRAINT mesa_id_fk FOREIGN KEY (mesa_id) REFERENCES mesa(mesa_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: mesa_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY mesa
    ADD CONSTRAINT mesa_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES usuario(usuario_id) ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: app_vav
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM app_vav;
GRANT ALL ON SCHEMA public TO app_vav;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: candidato; Type: ACL; Schema: public; Owner: app_vav
--

REVOKE ALL ON TABLE candidato FROM PUBLIC;
REVOKE ALL ON TABLE candidato FROM app_vav;
GRANT ALL ON TABLE candidato TO app_vav;


--
-- Name: comuna; Type: ACL; Schema: public; Owner: app_vav
--

REVOKE ALL ON TABLE comuna FROM PUBLIC;
REVOKE ALL ON TABLE comuna FROM app_vav;
GRANT ALL ON TABLE comuna TO app_vav;


--
-- Name: mesa; Type: ACL; Schema: public; Owner: app_vav
--

REVOKE ALL ON TABLE mesa FROM PUBLIC;
REVOKE ALL ON TABLE mesa FROM app_vav;
GRANT ALL ON TABLE mesa TO app_vav;


--
-- Name: pacto; Type: ACL; Schema: public; Owner: app_vav
--

REVOKE ALL ON TABLE pacto FROM PUBLIC;
REVOKE ALL ON TABLE pacto FROM app_vav;
GRANT ALL ON TABLE pacto TO app_vav;


--
-- Name: partido; Type: ACL; Schema: public; Owner: app_vav
--

REVOKE ALL ON TABLE partido FROM PUBLIC;
REVOKE ALL ON TABLE partido FROM app_vav;
GRANT ALL ON TABLE partido TO app_vav;


--
-- Name: region; Type: ACL; Schema: public; Owner: app_vav
--

REVOKE ALL ON TABLE region FROM PUBLIC;
REVOKE ALL ON TABLE region FROM app_vav;
GRANT ALL ON TABLE region TO app_vav;


--
-- Name: voto; Type: ACL; Schema: public; Owner: app_vav
--

REVOKE ALL ON TABLE voto FROM PUBLIC;
REVOKE ALL ON TABLE voto FROM app_vav;
GRANT ALL ON TABLE voto TO app_vav;


--
-- PostgreSQL database dump complete
--

