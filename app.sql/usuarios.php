<?php
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	FUNCIONALIDAD SQL DE LOS USUARIOS
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

	//	Usuario Nuevo
		case "usuarioNuevo"							:
		{
		//	Construir SQL
			$QUERY									=	"
			
				SELECT * FROM usuario_nuevo();
			
			";

		//	Ejecutar Query
			$QUERY_USUARIO_NUEVO				=	pg_query($CONF_DB_CONNECT, $QUERY);
			
		//	Respuesta
			$_USUARIO_NUEVO						=	pg_fetch_object($QUERY_USUARIO_NUEVO);
			
		//	Obtener Nuevo ID
			$usuario_id							=	$_USUARIO_NUEVO->usuario_nuevo;

		//	Validar Error
			if( $usuario_id == 0 )
			{
			//	Construir URL de Destino
				$LOCATION						=	$_URL_USUARIO_LISTADO;	
			}
			else
			{
			//	Construir URL de Destino
				$LOCATION						=	$_URL_USUARIO_EDITAR.$usuario_id;
			}
			
		//	Redirigir
			header("Location: $LOCATION");
		}
		break;
		
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Usuario Editar
		case "usuarioEditar"						:
		{
		//	Obtener Variables
			$usuario_id								=	filtrarVAR($_POST[usuario_id]);
			$usuario_rol							=	filtrarVAR($_POST[usuario_rol]);
			$usuario_nombre							=	filtrarVAR($_POST[usuario_nombre]);
			$usuario_email							=	filtrarVAR($_POST[usuario_email]);
			$usuario_pwd							=	$_POST[usuario_password];
			$usuario_genero							=	filtrarVAR($_POST[usuario_genero]);
			$usuario_etiqueta						=	filtrarID($_POST[usuario_etiqueta]);
			$usuario_imagenes						=	$_POST[objeto_fotografias];
		
		//	Obtener Password		
			$usuario_password						=	filtrarVAR( $usuario_pwd[0] );
			$password_repetir						=	filtrarVAR( $usuario_pwd[1] );

		//	Validar Cambio de Password
			if( $usuario_password == "" )
			{
				$usuario_password					=	"NULL";
			}
			else
			{
			//	Comparar ambas Password
				if( $usuario_password == $password_repetir )
				{
					$usuario_password				=	$usuario_password;
				}
				else
				{
					$usuario_password				=	"NULL";
				}
			}

		//	Salir del Formulario
			$abandonar								=	filtrarVAR($_POST[abandonar]);

		//	Construir SQL
			$QUERY									=	"
			
				SELECT * FROM
				usuario_editar
				(
					$usuario_id,
					'$usuario_rol',
					'$usuario_nombre',
					'$usuario_email',
					'$usuario_password',
					'$usuario_genero',
					$usuario_etiqueta,
					'$usuario_imagenes'
				);
			
			";

		//	Ejecutar Query
			$QUERY_USUARIO_EDITAR				=	pg_query($CONF_DB_CONNECT, $QUERY);
			
		//	Respuesta
			$_USUARIO_EDITAR					=	pg_fetch_object($QUERY_USUARIO_EDITAR);

		//	Validar Error
			if( $_USUARIO_EDITAR->usuario_editar == 1 && $abandonar == "" )
			{
			//	Construir URL de Destino
				$LOCATION						=	$_URL_USUARIO_EDITAR.$usuario_id;
			}
			else
			{
			//	Construir URL de Destino
				$LOCATION						=	$_URL_USUARIO_LISTADO;
			}
			
		//	Redirigir
			header("Location: $LOCATION");
		}
		break;
		
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Usuario Eliminar
		case "usuarioEliminar"						:
		{
		//	Obtener Variables
			$usuario_id								=	filtrarID($_POST[objeto_id]);

		//	Construir SQL
			$QUERY									=	"
			
				SELECT * FROM usuario_eliminar( $usuario_id , 'USU' );
			
			";

		//	Ejecutar Query
			$QUERY_USUARIO_ELIMINAR					=	pg_query($CONF_DB_CONNECT, $QUERY);

		//	Listado de Imagenes Disponibles
			while($_USUARIO_ELIMINAR				=	pg_fetch_object($QUERY_USUARIO_ELIMINAR))
			{
			//	Crear rutas de las imagenes creadas
				$objeto_imagen_900					=	$_IMAGENES."/".$_IMAGENES_USUARIOS."/".$_USUARIO_ELIMINAR->imagen_id."_900".$_USUARIO_ELIMINAR->imagen_extension;
				$objeto_imagen_600					=	$_IMAGENES."/".$_IMAGENES_USUARIOS."/".$_USUARIO_ELIMINAR->imagen_id."_600".$_USUARIO_ELIMINAR->imagen_extension;
				$objeto_imagen_80					=	$_IMAGENES."/".$_IMAGENES_USUARIOS."/".$_USUARIO_ELIMINAR->imagen_id."_80".$_USUARIO_ELIMINAR->imagen_extension;

			//	Validar que la Imagen Existe
				if(file_exists($objeto_imagen_900))
				{
					unlink($objeto_imagen_900);
				}
				if(file_exists($objeto_imagen_600))
				{
					unlink($objeto_imagen_600);
				}
				if(file_exists($objeto_imagen_80))
				{
					unlink($objeto_imagen_80);
				}
			}
		}
		break;

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Usuario Nuevo
		case "usuarioValidar"						:
		{
		//	Obtener Variables
			$usuario_email							=	filtrarVAR($_POST['usuario_email']);
			$usuario_password						=	filtrarVAR($_POST['usuario_password']);
			
		//	Construir SQL
			$QUERY									=	"
			
				SELECT * FROM
				usuario_iniciar_sesion
				(
					'$usuario_email',
					'$usuario_password'
				);
			
			";

		//	Ejecutar Query
			$QUERY_USUARIO_INICIAR_SESION			=	pg_query($CONF_DB_CONNECT, $QUERY);
			
		//	Respuesta
			$_USUARIO_INICIAR_SESION				=	pg_fetch_object($QUERY_USUARIO_INICIAR_SESION);

		//	Validar Error
			if( $_USUARIO_INICIAR_SESION->usuario_iniciar_sesion != 0 )
			{
			//	Obtener ID del Usuario
				$usuario_id							=	$_USUARIO_INICIAR_SESION->usuario_iniciar_sesion;

			//	Construir SQL
				$QUERY								=	"
				
					SELECT * FROM
					usuario_obtener_datos
					(
						$usuario_id
					);
				
				";
	
			//	Ejecutar Query
				$QUERY_USUARIO_INICIAR_SESION		=	pg_query($CONF_DB_CONNECT, $QUERY);
				
			//	Respuesta
				$_USUARIO_INICIAR_SESION			=	pg_fetch_object($QUERY_USUARIO_INICIAR_SESION);
	
			//	Generar Variables en Sesion
				$_SESSION['usuario_id']				=	$_USUARIO_INICIAR_SESION->usuario_id;
				$_SESSION['usuario_rol']			=	$_USUARIO_INICIAR_SESION->usuario_rol;
				$_SESSION['usuario_genero']			=	$_USUARIO_INICIAR_SESION->usuario_genero;
				$_SESSION['usuario_nombre']			=	$_USUARIO_INICIAR_SESION->usuario_nombre;
				$_SESSION['usuario_etiqueta']		=	$_USUARIO_INICIAR_SESION->usuario_etiqueta;
				$_SESSION['usuario_poster']			=	$_USUARIO_INICIAR_SESION->usuario_poster;

			//	Redireccion a la Accion Permitida
				if( $_USUARIO_INICIAR_SESION->usuario_rol == "AD" )
				{
				//	Construir URL de Destino
					$LOCATION							=	$_URL_MESA_LISTADO;
				}
				else if( $_USUARIO_INICIAR_SESION->usuario_rol == "AM" )
				{
				//	Construir URL de Destino
					$LOCATION							=	$_URL_MESA_LISTADO;
				}
				else if( $_USUARIO_INICIAR_SESION->usuario_rol == "OP" )
				{
				//	Construir URL de Destino
					$LOCATION							=	$_URL_MESA_OPERADOR;
				}
				else if( $_USUARIO_INICIAR_SESION->usuario_rol == "VZ" )
				{
				//	Construir URL de Destino
					$LOCATION							=	$_URL_MESA_SWICH;
				}
			}
			else
			{
			//	Construir URL de Destino
				$LOCATION							=	$_URL_SESION_LOGIN;
			}
			
		//	Redirigir
			header("Location: $LOCATION");

		}
		break;
		
	//		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
		
	//	Cerrar Sesion de Usuario
		case "usuarioSalir"							:
		{
		//	Destruir la Sesion
			session_unset();
			session_destroy();

		//	Eliminar Variables de la Sesion
			unset($_SESSION['usuario_id']);
			unset($_SESSION['usuario_rol']);
			unset($_SESSION['usuario_genero']);
			unset($_SESSION['usuario_nombre']);
			unset($_SESSION['usuario_etiqueta']);
			unset($_SESSION['usuario_poster']);
			
		//	Redireccionar
			header("Location: $_URL_SESION_LOGIN");
		}
		break;

	//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Usuario Nuevo
		case "usuarioJson"						:
		{
		//	Construir SQL
			$QUERY								=	"

				SELECT * FROM usuario_listado_movil();

			";

			//	Ejecutar Query
			$QUERY_USUARIO						=	pg_query($CONF_DB_CONNECT, $QUERY);

			while($_USUARIO						=	pg_fetch_object($QUERY_USUARIO))
			{
				$USUARIO[$_USUARIO->usuario_id]	=	array(
					'id'		=>	$_USUARIO->usuario_id,
					'nombre'	=>	$_USUARIO->usuario_nombre,
					'password'	=>	md5($_USUARIO->usuario_password),
					'etiqueta'	=>	$_USUARIO->usuario_etiqueta
				);
			}

			echo json_encode($USUARIO);
		}
		break;

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Usuario Nuevo
		case "usuarioMovil"						:
		{
		//	Construir SQL
			$QUERY								=	"

				SELECT * FROM usuario_listado_movil();

			";

		//	Ejecutar Query
			$QUERY_USUARIO						=	pg_query($CONF_DB_CONNECT, $QUERY);

			while($_USUARIO						=	pg_fetch_object($QUERY_USUARIO))
			{
				if($_USUARIO->usuario_estado == 1)
				{
					$USUARIO[$_USUARIO->usuario_id]	=	array(
						'id'		=>	$_USUARIO->usuario_id,
						'genero'	=>	$_USUARIO->usuario_genero,
						'nombre'	=>	$_USUARIO->usuario_nombre,
						'password'	=>	md5($_USUARIO->usuario_password),
						'etiqueta'	=>	$_USUARIO->usuario_etiqueta
					);
				}
			}

			echo json_encode($USUARIO);
		}
		break;
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Cerrar Concción
	pg_close($CONF_DB_CONNECT);
	
?>