<?php
/*
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	APLICACION :
	VAV - Voto a Voto
	Plebiscito Septiembre 2022
	Created : 19 de Julio del 2022

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
*/

//	Reportes de errores para la Aplicacion
	ini_set("display_errors",1);
	error_reporting(E_ERROR | E_WARNING | E_PARSE);

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	CONFIGURACION DE DB

//	Servidor
	$CONF_DB_IP 						=	'localhost';

//	Configuracion
	$CONF_DB_USER						=	'app_vav';
	$CONF_DB_PASS						=	'nBwMQ6lj6OK2kAoI';
	$CONF_DB_NAME						=	'VAV';
	$CONF_DB_PORT						=	'5432';

//	Construir Conexion
	$CONF_DB_BUILD						=	"host=$CONF_DB_IP dbname=$CONF_DB_NAME user=$CONF_DB_USER password=$CONF_DB_PASS port=$CONF_DB_PORT options='--client_encoding=UTF8'";

//	Conexion Mysql
    $CONF_DB_CONNECT					=	pg_connect($CONF_DB_BUILD);

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	CONFIGURACIONES DE LOS DIRECTORIOS

	$_APP								=	"/vav_plebiscito";
	$_ROOT								=	$_SERVER["DOCUMENT_ROOT"].$_APP;
	$_SQL								=	"$_ROOT/app.sql";
	$_FUNCIONES							=	"$_ROOT/app.funciones";
	$_CONSULTAS							=	"$_ROOT/app.consultas";
	$_PAGINAS							=	"$_ROOT/app.paginas";
	$_COMPONENTES						=	"$_ROOT/app.componentes";
	$_JSONS								=	"$_ROOT/app.json";
	$_IMAGENES							=	"$_ROOT/app.imagenes";
		$_IMAGENES_USUARIOS				=	"usuarios";

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	EXTRUCTURA DE LOS DIRECTORIOS

	$_LIBRERIAS_CSS						=	"$_APP/app.librerias/css/";
	$_LIBRERIAS_JS						=	"$_APP/app.librerias/js/";
	$_LIBRERIAS_IMG						=	"$_APP/app.imagenes/";
	$_LIBRERIAS_JSON					=	"/app.jsons/";
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	INFORMACION DE LA APLICACION

	$_CONF_VERSION						=	"?alpha.".time();
//	$_CONF_VERSION						=	"?version.1.6";

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-	
//	CREACION DE URLS AMIGABLES

//	Iniciar Sesion
	$_URL_SESION_LOGIN					=	"$_APP/iniciar-sesion/";
	$_URL_SESION_VALIDAR				=	"$_APP/iniciar-sesion/validar/";
	$_URL_SESION_SALIR					=	"$_APP/iniciar-sesion/salir/";
	$_URL_SESION_INGRESO				=	"/";

//	Robot Movil
	$_URL_MONITOR_MOVILES				=	"$_APP/monitor-moviles/";

//	Mesas
	$_URL_MESA_LISTADO					=	"$_APP/mesas/";
	$_URL_MESA_NUEVO					=	"$_APP/mesas/nueva/";
	$_URL_MESA_EDITAR					=	"$_APP/mesas/editar/";
	$_URL_MESA_EDITAR_GUARDAR			=	"$_APP/mesas/editar/guardar/";
	$_URL_MESA_ELIMINAR					=	"$_APP/mesas/eliminar/";
	$_URL_MESA_VISUALIZADOR				=	"$_APP/mesas/visualizador/";
	$_URL_MESA_VISUALIZADOR_PUBLICO		=	"$_APP/mesas/visualizador-publico/";
	$_URL_MESA_SWICH					=	"$_APP/mesas/swich/";
	$_URL_MESA_SWICH_VISUALIZADOR		=	"$_APP/mesas/swich/visualizador/";
	$_URL_MESA_SWICH_TOTEM				=	"$_APP/mesas/swich/totem/";
	$_URL_MESA_SWICH_TOTEM_PREVIEW		=	"$_APP/mesas/swich/totem-preview/";
	$_URL_MESA_SWICH_CHROMA				=	"$_APP/mesas/swich/chroma/";
	$_URL_MESA_SWICH_CHROMA_PREVIEW		=	"$_APP/mesas/swich/chroma-preview/";
	$_URL_MESA_OPERADOR					=	"$_APP/mesas/operador/";

//	Usuarios
	$_URL_USUARIO_LISTADO				=	"$_APP/usuarios/";
	$_URL_USUARIO_NUEVO					=	"$_APP/usuarios/nuevo/";
	$_URL_USUARIO_EDITAR				=	"$_APP/usuarios/editar/";
	$_URL_USUARIO_EDITAR_GUARDAR		=	"$_APP/usuarios/editar/guardar/";
	$_URL_USUARIO_ELIMINAR				=	"$_APP/usuarios/eliminar/";

//	Objeto Subir Nueva Imagen
	$_URL_OBJETO_IMAGEN_NUEVA			=	"$_APP/objeto/imagen-nueva/";

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	LIMITE DE REGISTROS POR PAGINAS
	$CCNF_RESULTADOS_PAGINAS			=	50;

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	CONFIGURACION DE LAS SESIONES

//	Variable Expiracion en Minutos			1 Año 
	$CONF_EXPIRACION_SESSION			=	( 60 * 24 * 365 );

//	Variable Expiracion en Segundos			1 Año
	$CONF_EXPIRACION_SESSION_SEG		=	( 60 * 24 * 365 ) * 60;

//	Tiempo de Expiracion
	session_cache_expire($CONF_EXPIRACION_SESSION);
	
	ini_set("session.cookie_lifetime","$CONF_EXPIRACION_SESSION_SEG");
	ini_set("session.gc_maxlifetime","$CONF_EXPIRACION_SESSION_SEG");
	
//	Crear Sesion
	session_start();
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	CONFIGURACION DE FECHA Y HORA

//	Zona horaria Principal
	date_default_timezone_set("America/Santiago");

//	Crear Formatos para las Fechas
	$_ANO								=	date("Y");
	$_MES								=	date("m");
	$_DIA								=	date("d");

//	Crear Formatos para la Hora	
	$_HORA								=	date("H");
	$_MINUTO							=	date("i");
	$_SEGUNDO							=	date("s");

//	Construir Objeto Fecha
	$_FECHA								=	$_ANO.'-'.$_MES.'-'.$_DIA;

//	Construir Objeto Hora
	$_HORA								=	date("H:i:s");

//	Construir Objeto Fecha y Hora
	$_FECHA_HORA						=	"$_FECHA $_HORA";

//	Construir Objeto Timestap
	$_TIMESTAP							=	time();

//	Variable para Evitar el Cache en archivos Json
	$_CONF_NOCACHE						=	$_ANO.$_MES.$_DIA.$_HORA.$_MINUTO;

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	CONFIGURACION PARA PUBNUB

	$_PUBNUB_PUB_MESAS					=	"pub-c-8b5c6d4e-d082-4615-a3a6-788949653edf";
	$_PUBNUB_SUS_MESAS					=	"sub-c-f7873e1d-1a48-4553-be89-86e9a189d093";

?>