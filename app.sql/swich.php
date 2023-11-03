<?php
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	FUNCIONALIDAD SQL PARA EL SWICH
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
	
//	Configuracion Inicial
	include_once "../configuracion.php";

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	Librerias Necesarias
	require_once("$_FUNCIONES/sql.php");
	require_once("$_FUNCIONES/filtros.php");
	require_once("$_FUNCIONES/fechas.php");
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Recibir Funcion Requerida
	$FUNCION										=	filtrarVAR($_REQUEST['f']);

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	Arbol de Funciones
	switch($FUNCION)
	{
		
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Swich Editar
		case "swichEditar"							:
		{
		//	Obtener Variables
			$swich_id								=	filtrarID($_POST['swich_id']);
			$swich_modo								=	filtrarID($_POST['swich_modo']);
			$swich_mesas							=	filtrarID($_POST['swich_mesas']);
			$swich_mesa_1							=	filtrarID($_POST['swich_mesa_1']);
			$swich_mesa_2							=	filtrarID($_POST['swich_mesa_2']);
			$swich_mesa_3							=	filtrarID($_POST['swich_mesa_3']);
			$swich_mesa_4							=	filtrarID($_POST['swich_mesa_4']);
			$swich_votos							=	filtrarVAR($_POST['swich_votos']);

		//	Construir SQL
			$QUERY									=	"
			
				SELECT * FROM
				swich_editar
				(
					$swich_id,
					$swich_modo,
					$swich_mesas,
					$swich_mesa_1,
					$swich_mesa_2,
					$swich_mesa_3,
					$swich_mesa_4,
					'$swich_votos'
				);
			
			";

		//	Ejecutar Query
			$QUERY_SWICH_EDITAR						=	pg_query($CONF_DB_CONNECT, $QUERY);
			
		//	Respuesta
			$_SWICH_EDITAR							=	pg_fetch_object($QUERY_SWICH_EDITAR);
			
			echo $_SWICH_EDITAR->swich_editar;
		}
		break;
		
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Obtener Mesas del Swich
		case "swichMesas"							:
		{
		//	Construir SQL
			$QUERY									=	"
		
				SELECT * FROM mesa_listado( 100 , 0 );
		
			";
		
		//	Ejecutar Query
			$QUERY_MESAS							=	pg_query($CONF_DB_CONNECT, $QUERY);
		
		//	Generar listado
			while($_MESA							=	pg_fetch_object($QUERY_MESAS))
			{
			//	Crear Array
				$_RESULTADOS[$_MESA->mesa_id]		=	array	
				(
					'mesa_id'						=>	$_MESA->mesa_id,
					'mesa_nombre'					=>	$_MESA->mesa_nombre,
					'mesa_numero'					=>	$_MESA->mesa_numero,
					'mesa_voto_a'					=>	$_MESA->mesa_voto_a,
					'mesa_voto_r'					=>	$_MESA->mesa_voto_r,
					'mesa_voto_cm'					=>	$_MESA->mesa_voto_cm,
					'mesa_voto_cc'					=>	$_MESA->mesa_voto_cc
				);
			}
			
		//	Encodear a Json el Colector
			$_JSON									=	json_encode($_RESULTADOS);
			
		//	Escribir resultado
			echo($_JSON);
		}
		break;

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Obtener Mesas del Swich
		case "swichMesasActuales"					:
		{
		//	Obtener Mesas almacenadas en el Swich
			$QUERY									=	"
		
				SELECT * FROM swich_actual();
		
			";
		
		//	Ejecutar Query
			$QUERY_SWICH_MESAS						=	pg_query($CONF_DB_CONNECT, $QUERY);
			$_SWICH_MESAS							=	pg_fetch_object($QUERY_SWICH_MESAS);

		//	Obtener la información de las Mesas almacenadas en el Swich
			$QUERY									=	"
		
				SELECT * FROM swich_mesas( $_SWICH_MESAS->swich_mesa_1 , $_SWICH_MESAS->swich_mesa_2 , $_SWICH_MESAS->swich_mesa_3 );
		
			";
			
		//	Ejecutar Query
			$QUERY_MESAS							=	pg_query($CONF_DB_CONNECT, $QUERY);
			
			$MESA_ID = 0;

		//	Generar listado
			while($_MESA							=	pg_fetch_object($QUERY_MESAS))
			{
			//	Construir SQL
				$QUERY								=	"SELECT * FROM mesa_candidatos_swich( $_MESA->mesa_id );";
			
			//	Ejecutar Query
				$QUERY_MESA_CANDIDATOS				=	pg_query($CONF_DB_CONNECT, $QUERY);
			
				$_CANDIDATOS['candidatos']			=	array();

			//	Obtener listado de candidatos
				while($_MESA_CANDIDATOS				=	pg_fetch_object($QUERY_MESA_CANDIDATOS))
				{
				//	Asignar información del candidato
					$_CANDIDATOS['candidatos'][]			=	array	
					(
						'objeto'					=>	(int) $_MESA_CANDIDATOS->voto_id,
						'id'						=>	(int) $_MESA_CANDIDATOS->candidato_id,
						'nombres'					=>	$_MESA_CANDIDATOS->candidato_nombres,
						'apellidos'					=>	$_MESA_CANDIDATOS->candidato_apellidos,
						'ind'						=>	$_MESA_CANDIDATOS->candidato_independiente,
						'genero'					=>	$_MESA_CANDIDATOS->candidato_genero,
						'votos'						=>	(int) $_MESA_CANDIDATOS->voto_total,
						'partido'					=>	$_MESA_CANDIDATOS->partido_codigo,
						'pacto'						=>	$_MESA_CANDIDATOS->pacto_codigo
					);
				}

			//	Crear Array
				$_OBJETO['mesas'][$_MESA->mesa_id]					=	array	
				(
					'id' => (int) $_MESA->mesa_id,
					'tipo' => $_MESA->mesa_tipo,
					'zona_id' => $_MESA->mesa_zona,
					'zona' => $_MESA->mesa_zona_titulo,
					'comuna' => $_MESA->mesa_comuna,
					'local' => $_MESA->mesa_local,
					'numero' => $_MESA->mesa_numero,
					'candidatos' =>	$_CANDIDATOS['candidatos']
				);

				$MESA_ID++;
			}

			if( $MESA_ID == 0 )
			{
				$_OBJETO['mesas']					=	array();
			}
			
		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Encodear Resultados
			$_JSON									=	json_encode($_OBJETO);

		//	Asignar formato Json
			header('Content-Type: application/json');

		//	Generar Json con los Datos
			echo $_JSON;
		}
		break;

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Obtener Mesas Consolidadas
		case "swichMesasTotales"					:
		{
		//	Obtener la información de las Mesas almacenadas en el Swich
			$QUERY									=	"
		
				SELECT * FROM swich_mesas_total( 'P' );
		
			";
			
		//	Ejecutar Query
			$QUERY_MESAS							=	pg_query($CONF_DB_CONNECT, $QUERY);

		//	Obtener la información de las Mesas almacenadas en el Swich
			$QUERY									=	"
		
				SELECT COUNT(mesa_id) FROM mesa WHERE mesa_tipo = 'P' AND mesa_estado = 1
		
			";
			
		//	Ejecutar Query
			$QUERY_MESAS_TOTALES					=	pg_query($CONF_DB_CONNECT, $QUERY);
			$_MESAS_TOTALES							=	pg_fetch_object($QUERY_MESAS_TOTALES);

		//	Listado de Candidatos
			$_CANDIDATOS['mesas']					=	(int) $_MESAS_TOTALES->count;

		//	Listado de Candidatos
			$_CANDIDATOS['candidatos']				=	array();

			$votos_totales = 0;

		//	Generar listado
			while($_MESA							=	pg_fetch_object($QUERY_MESAS))
			{
				$porcentaje							=	str_replace( "." , "," , $_MESA->round );

			//	Definir Orden de los candidatos
				if( $_MESA->candidato_id == 16163631 )
				{
					$orden = 1;
				}
				else if( $_MESA->candidato_id == 7477226 )
				{
					$orden = 2;
				}
				else if( $_MESA->candidato_id == 8653179 )
				{
					$orden = 3;
				}
				else if( $_MESA->candidato_id == 10273010 )
				{
					$orden = 4;
				}
				else if( $_MESA->candidato_id == 6195038 )
				{
					$orden = 5;
				}
				else if( $_MESA->candidato_id == 13436389 )
				{
					$orden = 6;
				}
				else if( $_MESA->candidato_id == 6872197 )
				{
					$orden = 7;
				}

			//	Asignar información del candidato
				$_CANDIDATOS['candidatos'][]		=	array	
				(
					'id'							=>	(int) $_MESA->candidato_id,
					'orden'							=>	$orden,
					'nombres'						=>	$_MESA->candidato_nombres,
					'apellidos'						=>	$_MESA->candidato_apellidos,
					'votos'							=>	(int) $_MESA->votos_total,
					'votos_p'						=>	puntos($_MESA->votos_total),
					'porcentaje'					=>	$porcentaje,
					'partido'						=>	$_MESA->partido_codigo
				);

				$votos_totales = $votos_totales + $_MESA->votos_total;
			}

		//	Listado de Candidatos
			$_CANDIDATOS['totales']					=	puntos($votos_totales);
			
		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Obtener la información de las Mesas almacenadas en el Swich
			$QUERY									=	"
		
				SELECT * FROM swich_mesas_total_actuales();
		
			";
			
		//	Ejecutar Query
			$QUERY_MESAS_ACTUALES					=	pg_query($CONF_DB_CONNECT, $QUERY);

		//	Generar listado
			while($_MESAS_ACTUALES					=	pg_fetch_object($QUERY_MESAS_ACTUALES))
			{
				//	Asignar información del candidato
				$_CANDIDATOS['actuales'][]			=	array	
				(
					'id'							=>	(int) $_MESAS_ACTUALES->mesa,
				);
			}

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Encodear Resultados
			$_JSON									=	json_encode($_CANDIDATOS);

		//	Asignar formato Json
			header('Content-Type: application/json');

		//	Generar Json con los Datos
			echo $_JSON;
		}
		break;

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Obtener Mesas del Swich
		case "swichMesasActualesR"					:
		{
		//	Obtener Mesas almacenadas en el Swich
			$QUERY									=	"
		
				SELECT * FROM swich_actual();
		
			";
		
		//	Ejecutar Query
			$QUERY_SWICH_MESAS						=	pg_query($CONF_DB_CONNECT, $QUERY);
			$_SWICH_MESAS							=	pg_fetch_object($QUERY_SWICH_MESAS);

		//	Obtener la información de las Mesas almacenadas en el Swich
			$QUERY									=	"
		
				SELECT * FROM swich_mesas( $_SWICH_MESAS->swich_mesa_1 , $_SWICH_MESAS->swich_mesa_2 , $_SWICH_MESAS->swich_mesa_3 );
		
			";
			
		//	Ejecutar Query
			$QUERY_MESAS							=	pg_query($CONF_DB_CONNECT, $QUERY);
			
		//	Generar listado
			while($_MESA							=	pg_fetch_object($QUERY_MESAS))
			{
			//	Crear Array
				$_OBJETO['mesas'][$_MESA->mesa_id]		=	array	
				(
					'mesa_id'						=>	(int) $_MESA->mesa_id,
					'mesa_tipo'						=>	$_MESA->mesa_tipo,
					'mesa_zona_titulo'				=>	$_MESA->mesa_zona_titulo,
					'mesa_comuna'					=>	$_MESA->mesa_comuna,
					'mesa_local'					=>	$_MESA->mesa_local,
					'mesa_numero'					=>	$_MESA->mesa_numero
				);

			//	Construir SQL
				$QUERY									=	"SELECT * FROM mesa_candidatos_swich( $_MESA->mesa_id );";
			
			//	Ejecutar Query
				$QUERY_MESA_CANDIDATOS					=	pg_query($CONF_DB_CONNECT, $QUERY);
			
			//	Obtener listado de candidatos
				while($_MESA_CANDIDATOS					=	pg_fetch_object($QUERY_MESA_CANDIDATOS))
				{
				//	Validar candidato independiente
					if($_MESA_CANDIDATOS->candidato_independiente == 't')
					{
						if($_MESA_CANDIDATOS->partido_codigo == 'IND')
						{
							$partido = 'IND';
							$variacion = 0;
						}
						else
						{
							$partido = 'IND-'.$_MESA_CANDIDATOS->partido_codigo;
							$variacion = 1;
						}
					}
					else
					{
						$partido = $_MESA_CANDIDATOS->partido_codigo;
						$variacion = 0;
					}

				//	Asignar información del candidato
					$_OBJETO['mesas'][$_MESA->mesa_id]['candidatos'][]			=	array	
					(
						'objeto'						=>	(int) $_MESA_CANDIDATOS->voto_id,
						'id'							=>	(int) $_MESA_CANDIDATOS->candidato_id,
						'nombre'						=>	$_MESA_CANDIDATOS->candidato_nombre_corto,
						'votos'							=>	(int) $_MESA_CANDIDATOS->voto_total,
						'lista'							=>	$_MESA_CANDIDATOS->candidato_lista,
						'genero'						=>	$_MESA_CANDIDATOS->candidato_genero,
						'partido'						=>	$partido
					);
				}
			}
			
		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Encodear Resultados
			$_JSON									=	json_encode($_OBJETO);

		//	Asignar formato Json
			header('Content-Type: application/json');

		//	Generar Json con los Datos
			echo $_JSON;
		}
		break;

	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Cerrar Concción
	pg_close($CONF_DB_CONNECT);
	
?>	