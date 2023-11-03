
--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

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
    swich_cambio timestamp without time zone DEFAULT now() NOT NULL
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
-- Name: swich_id; Type: DEFAULT; Schema: public; Owner: app_vav
--

ALTER TABLE ONLY swich ALTER COLUMN swich_id SET DEFAULT nextval('swich_id_seq'::regclass);


--
-- Name: swich_pkey; Type: CONSTRAINT; Schema: public; Owner: app_vav; Tablespace: 
--

ALTER TABLE ONLY swich
    ADD CONSTRAINT swich_pkey PRIMARY KEY (swich_id);

--
-- PostgreSQL database dump complete
--


	SELECT * FROM swich_obtener_datos(1);

	DROP FUNCTION swich_obtener_datos();

	CREATE FUNCTION swich_obtener_datos
	(
		in_swich_id bigint
	)
	
		RETURNS TABLE
		(
			swich_mesas smallint,
			swich_modo smallint,
			swich_mesa_1 smallint,
			swich_mesa_2 smallint,
			swich_mesa_3 smallint,
			swich_mesa_4 smallint,
			swich_votos character varying,
			swich_cambio timestamp without time zone
		)
		
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

--			-			-			-			-			-			-			-			-

	CREATE FUNCTION swich_editar
	(
		in_swich_id bigint,
		in_swich_modo bigint,
		in_swich_mesas bigint,
		in_swich_mesa_1 bigint,
		in_swich_mesa_2 bigint,
		in_swich_mesa_3 bigint,
		in_swich_mesa_4 bigint,
		in_swich_votos character varying
	)
		RETURNS bigint
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

--			-			-			-			-			-			-			-			-

	CREATE FUNCTION swich_actual
	(

	)
		RETURNS TABLE
		(
		    swich_mesa_1 smallint,
			swich_mesa_2 smallint,
			swich_mesa_3 smallint
		)
		
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

--			-			-			-			-			-			-			-			-

	SELECT * FROM swich_mesas( 24 , 0 , 0 );

	DROP FUNCTION swich_mesas
	(
		bigint,
		bigint,
		bigint
	);

	CREATE FUNCTION swich_mesas
	(
		in_mesa_1 bigint,
		in_mesa_2 bigint,
		in_mesa_3 bigint
	)
		RETURNS TABLE
		(
            mesa_id bigint,
		    mesa_tipo character varying,
			mesa_zona bigint,
            mesa_zona_titulo character varying,
			mesa_comuna character varying,
            mesa_local character varying,
            mesa_numero character varying
		)
		
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

--			-			-			-			-			-			-			-			-

	SELECT * FROM swich_mesas_total( 'P' );

	DROP FUNCTION swich_mesas_total
	(
		character varying
	);

	CREATE FUNCTION swich_mesas_total
	(
		in_mesa_tipo character varying
	)
		RETURNS TABLE
		(
            votos_total bigint,
			candidato_id bigint,
			candidato_nombres character varying,
			candidato_apellidos character varying,
			partido_codigo character varying
		)
		
	    LANGUAGE plpgsql
	    AS $$
	    
		BEGIN
		return QUERY
		
		SELECT
            sum(t2.voto_total) as votos_total,
            t3.candidato_id,
            t3.candidato_nombres,
            t3.candidato_apellidos,
            t4.partido_codigo
        from
            mesa t1,
            voto t2,
            candidato t3,
            partido t4
        WHERE
            t1.mesa_tipo = 'P' AND
            t1.mesa_estado = 1 AND
            t2.mesa_id = t1.mesa_id AND
            t3.candidato_id = t2.candidato_id AND
            t4.partido_id = t3.partido_id
        group by
            t3.candidato_id,
            t3.candidato_apellidos,
            t4.partido_codigo;

	END $$;

	CREATE FUNCTION swich_mesas_total_RESPALDO
	(
		in_mesa_tipo character varying
	)
		RETURNS TABLE
		(
            votos_total bigint,
			round decimal,
			candidato_id bigint,
			candidato_nombres character varying,
			candidato_apellidos character varying,
			partido_codigo character varying
		)
		
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




	SELECT * FROM swich_mesas_total_actuales();

	DROP FUNCTION swich_mesas_total_actuales
	(
	);

	CREATE FUNCTION swich_mesas_total_actuales
	(
	)
		RETURNS TABLE
		(
            mesa bigint
		)
		
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
		where t0.rownum <= 20 

	END $$;
