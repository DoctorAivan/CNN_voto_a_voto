<?php

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	OBTENER LISTADO DE MESAS
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	$CCNF_RESULTADOS_PAGINAS				=	100;

//	Configuración Paginación
	if(filtrarID($_GET['p']))
	{
	//	Pagina Solicitada
		$CONF_PAGINA_ACTUAL					=	filtrarID($_GET['p']);
	}
	else
	{
	//	Pagina por Defecto
		$CONF_PAGINA_ACTUAL					=	0;
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Construir SQL
	$QUERY_TOTAL							=	"

	    SELECT * FROM mesa_contar_total();

	";

//	Ejecutar Query
	$QUERY_OBJETOS_TOTAL					=	pg_query($CONF_DB_CONNECT, $QUERY_TOTAL);

//	Obtener el total de Objetos
	$_TOTAL									=	pg_fetch_object($QUERY_OBJETOS_TOTAL);

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Construir SQL
	$QUERY									=	"

		SELECT * FROM mesa_listado( $CCNF_RESULTADOS_PAGINAS , ( $CCNF_RESULTADOS_PAGINAS * $CONF_PAGINA_ACTUAL ) );

	";

//	Ejecutar Query
	$QUERY_MESAS							=	pg_query($CONF_DB_CONNECT, $QUERY);

//	Obtener el Numero de Filas
	$TOTAL_OBJETOS							=	pg_numrows($QUERY_MESAS);

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Numero de Paginas disponibles
	$TOTAL_PAGINAS							=	$_TOTAL->objetos / $CCNF_RESULTADOS_PAGINAS;

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	OBTENER MESAS ALMACENADAS
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Construir SQL
	$QUERY									=	"

		SELECT * FROM swich_obtener_datos( 1 );

	";

//	Ejecutar Query
	$QUERY_SWICH							=	pg_query($CONF_DB_CONNECT, $QUERY);

//	Obtener información del Swich
	$_SWICH									=	pg_fetch_object($QUERY_SWICH);

?>