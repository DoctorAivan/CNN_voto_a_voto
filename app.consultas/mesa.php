<?php

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	OBTENER LISTADO DE MESAS
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

//	Obtener listado de usuarios
	$QUERY									=	"

		SELECT * FROM usuario_listado( 100 , 0 );

	";

	//	Ejecutar Query
	$QUERY_USUARIO							=	pg_query($CONF_DB_CONNECT, $QUERY);

	while($_USUARIO							=	pg_fetch_object($QUERY_USUARIO))
	{
		$_ARRAY_USUARIOS[$_USUARIO->usuario_id]	=	array(
			't'		=>	$_USUARIO->usuario_nombre
		);
	}

?>