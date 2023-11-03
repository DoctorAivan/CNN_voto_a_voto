<?php
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	CONFIGURACION DE SESION ACTIVA
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Validar que el usuario tenga permisos de acceso
	if(!isset($_SESSION['usuario_id']) || (trim($_SESSION['usuario_id']) == ''))
	{
	//	Enviar al usuario a la vista de Inicio
		header("Location: $_URL_SESION_LOGIN");
		
	//	Terminar Ejecución
		exit();
	}
	else
	{
	//	Obtener Privilegios del Usuario
		$usuario_rol	=	$_SESSION['usuario_rol'];

	//	Validar Privilegios de Acceso		
		if (in_array( $usuario_rol , $usuario_permitido ))
		{

		}
		else
		{
		//	Enviar al usuario a la vista de Inicio
			header("Location: $_URL_SESION_LOGIN");
		}
	}

?>