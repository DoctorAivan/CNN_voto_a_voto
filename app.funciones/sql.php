<?php
	
//	Obtener el Ultimo ID
	function sqlID($NEXTVAL)
	{
		global $CONF_DB_CONNECT;

	//	Consultar por el Ultimo ID de la tabla
		$QUERY								=	"

			SELECT nextval('$NEXTVAL');

		";

	//	Resultado de la Consulta
		$_QUERY								=	pg_query($CONF_DB_CONNECT, $QUERY);
		$_NEXTVAL							=	pg_fetch_array($_QUERY);

	//	Generar Nuevo ID
		$_ID								=	$_NEXTVAL[nextval];

	//	Enviar Salida
		return $_ID;
	}
	
?>