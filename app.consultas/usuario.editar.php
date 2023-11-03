<?php

//	Obtener el ID de el Usuario
	if(filtrarID($_GET['i']))
	{
	//	ID Usuario
		$usuario_id							=	filtrarID($_GET['i']);
	}
	else
	{
	//	ID Usuario
		$usuario_id							=	0;
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	OBTENER INFORMACIÓN DEL USUARIO
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Construir SQL
	$QUERY									=	"

	    SELECT * FROM usuario_obtener_datos( $usuario_id );

	";

//	Ejecutar Query
	$QUERY_USUARIO							=	pg_query($CONF_DB_CONNECT, $QUERY);

//	Obtener información del Usuario
	$_USUARIO								=	pg_fetch_object($QUERY_USUARIO);

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	OBTENER IMAGENES DEL USUARIO
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Construir SQL
	$QUERY									=	"

	    SELECT * FROM imagen_listado( $usuario_id , 'USU' );

	";

//	Ejecutar Query
	$QUERY_USUARIO_IMAGENES					=	pg_query($CONF_DB_CONNECT, $QUERY);

//	Arreglo con las Imagenes
	$_ARRAY_IMAGENES						=	array();

//	Listado de Imagenes Disponibles
	while($_USUARIO_IMAGENES				=	pg_fetch_object($QUERY_USUARIO_IMAGENES))
	{
	//	Poblar Arreglo con las Imagenes
		$_ARRAY_IMAGENES[]					=	$_USUARIO_IMAGENES;		
	}

?>