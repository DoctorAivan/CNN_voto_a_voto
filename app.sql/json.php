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
	//	Jugador Equipo Listado
		case "diccionario"							:
		{
		//	Obtener Listado de Regiones
			$QUERY									=	"SELECT * FROM region";

		//	Ejecutar Query
			$QUERY_REGIONES							=	pg_query($CONF_DB_CONNECT, $QUERY);

		//	Listado de Objetos Disponibles
			while($_REGION							=	pg_fetch_object($QUERY_REGIONES))
			{
			//	Construir Respuesta
				$_RESPUESTA['regiones'][]			=	array
				(
					'id'							=>	$_REGION->region_id,
					'nombre'						=>	$_REGION->region_nombre
				);
			}

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Obtener Listado de Comunas
			$QUERY									=	"SELECT * FROM comuna";

		//	Ejecutar Query
			$QUERY_COMUNAS							=	pg_query($CONF_DB_CONNECT, $QUERY);

		//	Listado de Objetos Disponibles
			while($_COMUNA							=	pg_fetch_object($QUERY_COMUNAS))
			{
			//	Construir Respuesta
				$_RESPUESTA['comunas'][]			=	array
				(
					'id'							=>	$_COMUNA->comuna_id,
					'nombre'						=>	$_COMUNA->comuna_nombre
				);
			}

			for ($i = 1; $i <= 28; $i++)
			{
				$_RESPUESTA['distritos'][]			=	array
				(
					'id'							=>	$i,
					'nombre'						=>	"Distrito $i"
				);
			}

		//	Agregar codificación
			header('Content-type: application/json');

		//	Retornar Json
			echo json_encode($_RESPUESTA);
		}
		break;

	
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Cerrar Concción
	pg_close($CONF_DB_CONNECT);
	
?>