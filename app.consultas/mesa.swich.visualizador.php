<?php

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	OBTENER LISTADO DE MESAS
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Construir SQL
	$QUERY									=	"

		SELECT * FROM mesa_listado( 200 , 0 );

	";

//	Ejecutar Query
	$QUERY_MESAS							=	pg_query($CONF_DB_CONNECT, $QUERY);

	while($_MESA							=	pg_fetch_object($QUERY_MESAS))
	{
		
	//	Información de la Imagen
		$_RESULTADOS[$_MESA->mesa_id]		=	array	
		(
			'mesa_id'							=>	$_MESA->mesa_id,
			'mesa_nombre'						=>	$_MESA->mesa_nombre,
			'mesa_numero'						=>	$_MESA->mesa_numero,
			'mesa_region'						=>	$_MESA->mesa_region,
			'mesa_ciudad'						=>	$_MESA->mesa_ciudad,
			'mesa_voto_a'						=>	$_MESA->mesa_voto_a,
			'mesa_voto_r'						=>	$_MESA->mesa_voto_r,
			'mesa_voto_cm'						=>	$_MESA->mesa_voto_cm,
			'mesa_voto_cc'						=>	$_MESA->mesa_voto_cc
		);
	}
	
//	Encodear a Json el Colector
	$_JSON									=	json_encode($_RESULTADOS);
	
//	Escribir resultado
	print_r($_RESULTADOS);

?>