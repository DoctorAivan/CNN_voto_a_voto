<?php

//	Configuracion Inicial
	include_once "configuracion.php";

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
	
//	Perfiles Permitidos
	$usuario_permitido	=	array( "AD" , "AM" );

//	Configuracion de Sesion Activa
	include_once "configuracion.sesion.php";

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Librerias Necesarias
	require_once("$_FUNCIONES/usuarios.php");
	require_once("$_FUNCIONES/filtros.php");
	require_once("$_FUNCIONES/imagenes.php");
	require_once("$_FUNCIONES/fechas.php");

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Construir SQL
	$QUERY									=	"

		DELETE FROM voto;
		DELETE FROM mesa;
		
		alter sequence mesa_id_seq restart with 1;
		alter sequence voto_id_seq restart with 100;

	";

//	Ejecutar Query
	$QUERY_OBJETOS							=	pg_query($CONF_DB_CONNECT, $QUERY);

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-				

	print "Reboot [OK]";

//	Cerrar Concción SQL
	pg_close($CONF_DB_CONNECT);

?>