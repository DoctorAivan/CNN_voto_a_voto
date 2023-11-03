<?php
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	FUNCIONALIDAD SQL DE LOS OBJETOS
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

	//	Estado del Objeto
		case "objetoEstado"							:
		{
		    $objeto_id								=	filtrarID($_POST['objeto_id']);
		    $objeto_tipo							=	filtrarVAR($_POST['objeto_tipo']);
			
		//	Construir SQL
			$QUERY									=	"
			
				SELECT * FROM objeto_estado( $objeto_id , '$objeto_tipo' );
			
			";

		//	Ejecutar Query
			$QUERY_OBJETO_ESTADO					=	pg_query($CONF_DB_CONNECT, $QUERY);
			
		//	Respuesta
			$_OBJETO_ESTADO							=	pg_fetch_object($QUERY_OBJETO_ESTADO);
			
		//	Obtener Nuevo ID
			$objeto_estado							=	$_OBJETO_ESTADO->objeto_estado;
			
			echo $objeto_estado;
			
		}
		break;

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Cerrar Concción
	pg_close($CONF_DB_CONNECT);
	
?>