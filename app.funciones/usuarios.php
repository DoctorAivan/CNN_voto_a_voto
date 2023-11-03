<?php

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	FUNCIONES PARA LOS USUARIOS
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
	
//	Roles de los Usuario
	$_ARRAY_USUARIO_ROLES			=	array
	(
        'AD'						=>	array
        (
            'titulo'				=>	'Administrador',
            'detalle'				=>	'La cuenta de Administrador permite un control total de la aplicación.',
            'icono'					=>	'fas fa-user-shield'
        ),
        'AM'						=>	array
        (
            'titulo'				=>	'Jefe Mesas',
            'detalle'				=>	'La cuenta de Jefe Mesas permite monitorear el trabajo de los Operadores.',
            'icono'					=>	'fas fa-user-edit'
        ),
        'OP'						=>	array
        (
            'titulo'				=>	'Operador',
            'detalle'				=>	'Los operadores de Mesa son los encargados de completar la información de las Mesas',
            'icono'					=>	'fas fa-user-clock'
        ),
        'VZ'						=>	array
        (
            'titulo'				=>	'Salida TV',
            'detalle'				=>	'El operador de Swich es el encargado de cordinar la salida a TV.',
            'icono'					=>	'fas fa-chalkboard-teacher'
        )
	);
		
//	Roles de los Usuario
	$_ARRAY_IMPORTANCIA				=	array
	(
        '1'							=>	array
        (
            'titulo'				=>	'Importancia Muy Baja',
            'detalle'				=>	'',
            'clase'					=>	'muy-baja'
        ),
        '2'							=>	array
        (
            'titulo'				=>	'Importancia Baja',
            'detalle'				=>	'',
            'clase'					=>	'baja'
        ),
        '3'							=>	array
        (
            'titulo'				=>	'Importancia Media',
            'detalle'				=>	'',
            'clase'					=>	'media'
        ),
        '4'							=>	array
        (
            'titulo'				=>	'Importancia Alta',
            'detalle'				=>	'',
            'clase'					=>	'alta'
        ),
        '5'							=>	array
        (
            'titulo'				=>	'Importancia Muy Alta',
            'detalle'				=>	'',
            'clase'					=>	'muy-alta'
        ),
        '6'							=>	array
        (
            'titulo'				=>	'Importancia Muy Importante',
            'detalle'				=>	'',
            'clase'					=>	'importante'
        )
	);

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Obtener Roles
	function usuario_rol( $ROL )
	{
	//	Obtener Array
		global $_ARRAY_USUARIO_ROLES;
		
	//	Envier respuesta
		return $_ARRAY_USUARIO_ROLES[$ROL]['titulo'];
	}

?>