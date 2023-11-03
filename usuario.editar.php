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
	require_once("$_FUNCIONES/filtros.php");
	require_once("$_FUNCIONES/imagenes.php");
	require_once("$_FUNCIONES/fechas.php");
	require_once("$_FUNCIONES/usuarios.php");
	require_once("$_FUNCIONES/formulario.php");

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Consulta SQL
	include_once "$_CONSULTAS/usuario.editar.php";

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-				

//	Configuracion del SEO
	$_SEO				=	array
	(
		"TITLE"			=>	"TITLE",
		"DESCRIPCION"	=>	"DESCRIPCION",
		"KEYWORDS"		=>	"KEYWORDS",
		"IMAGE"			=>	"IMAGE",
		"AUTOR"			=>	"AUTOR",
		"OB-TYPE"		=>	"website",
		"ROBOTS"		=>	"false"
	);

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-				

//	Incluir HTML
	include_once("$_PAGINAS/usuario.editar.php");

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-				

//	Cerrar Concción SQL
	pg_close($CONF_DB_CONNECT);

?>