<?php
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	FUNCIONALIDAD SQL DE LOS USUARIOS
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
	//	Activar Mesa
		case "mesaActivar"						:
		{
		//	Obtener el ID de la mesa
			$mesa_id								=	filtrarID($_POST['mesa_id']);
			$mesa_numero							=	filtrarVAR($_POST['mesa_numero']);
			
		//	Construir SQL
			$QUERY									=	"
			
				SELECT * FROM mesa_activar( $mesa_id , '$mesa_numero' );
			
			";

		//	Ejecutar Query
			$QUERY_MESA_ACTIVAR						=	pg_query($CONF_DB_CONNECT, $QUERY);
			
		//	Respuesta
			$_MESA_ACTIVAR							=	pg_fetch_object($QUERY_MESA_ACTIVAR);
			
		//	Debug
			echo $_MESA_ACTIVAR->mesa_activar;
		}
		break;

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Destacar Mesa
		case "mesaDestacada"						:
		{
		//	Obtener el ID de la mesa
		    $mesa_id								=	filtrarID($_POST['mesa_id']);
			
		//	Construir SQL
			$QUERY									=	"
			
				SELECT * FROM mesa_destacada( $mesa_id );
			
			";

		//	Ejecutar Query
			$QUERY_OBJETO_ESTADO					=	pg_query($CONF_DB_CONNECT, $QUERY);
			
		//	Respuesta
			$_OBJETO_ESTADO							=	pg_fetch_object($QUERY_OBJETO_ESTADO);
			
		//	Obtener Nuevo ID
			$objeto_estado							=	$_OBJETO_ESTADO->mesa_destacada;
			
			echo $objeto_estado;
		}
		break;

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Mesa Nuevo
		case "mesa_nueva"							:
		{
		//	Obtener ID del Usuario
			$usuario_id								=	$_SESSION['usuario_id'];
			$mesa_tipo								=	filtrarVAR($_POST['mesa_tipo']);
			$mesa_zona								=	filtrarVAR($_POST['mesa_zona']);
			$mesa_zona_titulo						=	filtrarVAR($_POST['mesa_zona_titulo']);
			$mesa_comuna							=	filtrarVAR($_POST['mesa_comuna']);

		//	Declarar Header
			header('Content-Type: application/json');

		//	Construir SQL
			$QUERY									=	"
			
				SELECT * FROM mesa_nuevo( $usuario_id , '$mesa_tipo' , $mesa_zona , '$mesa_zona_titulo' , '$mesa_comuna' );
			
			";

		//	Ejecutar Query
			$QUERY_MESA_NUEVO						=	pg_query($CONF_DB_CONNECT, $QUERY);
			
		//	Respuesta
			$_MESA_NUEVA							=	pg_fetch_object($QUERY_MESA_NUEVO);
			
		//	Obtener Nuevo ID
			$mesa_id								=	$_MESA_NUEVA->mesa_nuevo;

		//	Validar Error
			if( $mesa_id == 0 )
			{
				echo 0;
			}
			else
			{
				echo $mesa_id;
			}
		}
		break;
		
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Mesa Guardar
		case "mesa_guardar"							:
		{
		//	Obtener Variables
			$mesa_id								=	filtrarID($_POST['mesa_id']);
			$usuario_id								=	filtrarID($_POST['usuario_id']);
			$mesa_estado							=	filtrarID($_POST['mesa_estado']);
			$mesa_comuna							=	filtrarVAR($_POST['mesa_comuna']);
			$mesa_local								=	filtrarVAR($_POST['mesa_local']);
			$mesa_numero							=	filtrarVAR($_POST['mesa_numero']);
		
		//	Construir SQL
			$QUERY									=	"
			
				SELECT * FROM
				mesa_guardar
				(
					$mesa_id,
					$usuario_id,
					$mesa_estado,
					'$mesa_comuna',
					'$mesa_local',
					'$mesa_numero'
				);
			
			";

		//	Ejecutar Query
			$QUERY_MESA_GUARDAR					=	pg_query($CONF_DB_CONNECT, $QUERY);
			
		//	Respuesta
			$_MESA_GUARDAR						=	pg_fetch_object($QUERY_MESA_GUARDAR);

		//	Imprimir Salida
			echo $_MESA_GUARDAR->mesa_guardar;
		}
		break;
		
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Mesa Guardar
		case "mesa_candidato_guardar"				:
		{
		//	Obtener Variables
			$candidato_id							=	filtrarID($_POST['candidato_id']);
			$candidato_nombres						=	filtrarVAR($_POST['candidato_nombres']);
			$candidato_apellidos					=	filtrarVAR($_POST['candidato_apellidos']);

		//	Construir SQL
			$QUERY									=	"
			
				SELECT * FROM mesa_candidato_guardar
				(
					$candidato_id,
					'$candidato_nombres',
					'$candidato_apellidos'
				);
			
			";

		//	Ejecutar Query
			$QUERY_MESA_CANDIDATO_GUARDAR		=	pg_query($CONF_DB_CONNECT, $QUERY);
			
		//	Respuesta
			$_MESA_CANDIDATO_GUARDAR			=	pg_fetch_object($QUERY_MESA_CANDIDATO_GUARDAR);

		//	Imprimir Salida
			echo $_MESA_CANDIDATO_GUARDAR->mesa_candidato_guardar;
		}
		break;
		
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Mesa Eliminar
		case "mesa_eliminar"						:
		{
		//	Obtener Variables
			$mesa_id								=	filtrarID($_POST['mesa_id']);

		//	Construir SQL
			$QUERY									=	"
			
				SELECT * FROM mesa_eliminar( $mesa_id );
			
			";

		//	Ejecutar Query
			$QUERY_MESA_ELIMINAR					=	pg_query($CONF_DB_CONNECT, $QUERY);
		}
		break;

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Mesas Obtener Detalles
		case "mesa_detalles"						:
		{
		//	Obtener Variables
			$mesa_id								=	filtrarID($_GET['i']);

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
		//	OBTENER INFORMACIÓN DE LA MESA

		//	Construir SQL
			$QUERY									=	"SELECT * FROM mesa_detalles( $mesa_id );";
		
		//	Ejecutar Query
			$QUERY_MESA								=	pg_query($CONF_DB_CONNECT, $QUERY);
		
		//	Obtener información de la mesa
			$_MESA									=	pg_fetch_object($QUERY_MESA);

		//	Asignar información de la mesa
			$_OBJETO['mesa']						=   $_MESA;

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
		//	OBTENER INFORMACIÓN DE LA MESA
		
		//	Construir SQL
			$QUERY									=	"SELECT * FROM mesa_candidatos( $mesa_id );";
		
		//	Ejecutar Query
			$QUERY_MESA_CANDIDATOS					=	pg_query($CONF_DB_CONNECT, $QUERY);
		
		//	Obtener listado de candidatos
			while($_MESA_CANDIDATOS					=	pg_fetch_object($QUERY_MESA_CANDIDATOS))
			{
			//	Asignar información del candidato
				$_OBJETO['candidatos'][]			=   $_MESA_CANDIDATOS;
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

	//	Actualizar Votos de la Mesa
		case "mesa_voto"							:
		{
		//	Obtener Variables
			$mesa_id								=	filtrarID($_POST['mesa_id']);
			$voto_id								=	filtrarID($_POST['voto_id']);
			$voto_total								=	filtrarID($_POST['voto_total']);

		//	Construir SQL
			$QUERY									=	"SELECT * FROM mesa_voto( $mesa_id , $voto_id , $voto_total );";

		//	Ejecutar Query
			$QUERY_MESA_VOTOS						=	pg_query($CONF_DB_CONNECT, $QUERY);
			
		//	Respuesta
			$_MESA_VOTOS						=	pg_fetch_object($QUERY_MESA_VOTOS);

		//	Imprimir Salida
			echo $_MESA_VOTOS->mesa_voto;
		}
		break;

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Obtener las Mesas del usuario
		case "moviles_mesas"						:
		{
		//	Obtener Datos
			$usuario_id								=	filtrarID($_GET['i']);

		//	Construir SQL
			$QUERY									=	"SELECT * FROM mesa_usuario_listado( $usuario_id , 100 , 0 );";

		//	Ejecutar Query
			$QUERY_MESAS							=	pg_query($CONF_DB_CONNECT, $QUERY);

		//	ID del Listado
			$ID_LISTADO								=	0;

		//	Generar Listado de Mesas
			while($_MESA							=	pg_fetch_object($QUERY_MESAS))
			{
			//	Construir SQL
				$QUERY									=	"SELECT * FROM mesa_detalles( $_MESA->mesa_id );";
			
			//	Ejecutar Query
				$QUERY_MESA								=	pg_query($CONF_DB_CONNECT, $QUERY);
			
			//	Obtener información de la mesa
				$_MESA									=	pg_fetch_object($QUERY_MESA);

			//	Asignar información de la mesa
				$_OBJETO[$_MESA->mesa_id]		=	array
				(
					'id' => (int) $_MESA->mesa_id,
					'tipo' => $_MESA->mesa_tipo,
					'estado' => $_MESA->mesa_estado,
					'local' => $_MESA->mesa_local,
					'numero' => $_MESA->mesa_numero,
				);

			//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
			//	OBTENER INFORMACIÓN DE LA MESA
			
			//	Construir SQL
				$QUERY									=	"SELECT * FROM mesa_candidatos( $_MESA->mesa_id );";
			
			//	Ejecutar Query
				$QUERY_MESA_CANDIDATOS					=	pg_query($CONF_DB_CONNECT, $QUERY);
			
			//	Obtener listado de candidatos
				while($_MESA_CANDIDATOS					=	pg_fetch_object($QUERY_MESA_CANDIDATOS))
				{
					$nombre = explode( " " , $_MESA_CANDIDATOS->candidato_nombre_corto );
					
				//	Asignar información del candidato
					$_OBJETO[$_MESA->mesa_id]['candidatos'][$_MESA_CANDIDATOS->voto_id] =	array
					(
						'i' => $_MESA_CANDIDATOS->voto_id,
						'n' => $nombre[1],
						'l' => $_MESA_CANDIDATOS->candidato_lista,
						'v'	=> $_MESA_CANDIDATOS->voto_total
					);
				}

				$ID_LISTADO++;
			}
		
		//	Generar Salida
			echo json_encode($_OBJETO);
		}
		break;

	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Cerrar Concción
	pg_close($CONF_DB_CONNECT);
	
?>