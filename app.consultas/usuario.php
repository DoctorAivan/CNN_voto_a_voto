<?php

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	OBTENER LISTADO DE USUARIOS
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

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

	    SELECT * FROM usuario_contar_total();

	";

//	Ejecutar Query
	$QUERY_OBJETOS_TOTAL					=	pg_query($CONF_DB_CONNECT, $QUERY_TOTAL);

//	Obtener el total de Objetos
	$_TOTAL									=	pg_fetch_object($QUERY_OBJETOS_TOTAL);

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Construir SQL
	$QUERY									=	"

		SELECT * FROM usuario_listado( $CCNF_RESULTADOS_PAGINAS , ( $CCNF_RESULTADOS_PAGINAS * $CONF_PAGINA_ACTUAL ) );

	";

//	Ejecutar Query
	$QUERY_USUARIO							=	pg_query($CONF_DB_CONNECT, $QUERY);

//	Obtener el Numero de Filas
	$TOTAL_OBJETOS							=	pg_numrows($QUERY_USUARIO);

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Numero de Paginas disponibles
	$TOTAL_PAGINAS							=	$_TOTAL->objetos / $CCNF_RESULTADOS_PAGINAS;

?>