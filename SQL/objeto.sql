--	OBJETOS
--			-			-			-			-			-			-			-			-

--	MODIFICAR ESTADO DE PUBLICACIÓN DEL OBJETO
	CREATE OR REPLACE FUNCTION objeto_estado
	(
		in_objeto_id bigint,
		in_objeto_tipo character varying
	)
	
		RETURNS bigint
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