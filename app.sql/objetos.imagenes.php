<?php
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	FUNCIONALIDAD DE LAS IMAGENES
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
	
//	Configuracion Inicial
	include_once "../configuracion.php";

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	Librerias Necesarias
	require_once("$_FUNCIONES/sql.php");
	require_once("$_FUNCIONES/filtros.php");
	require_once("$_FUNCIONES/imagenes.php");
	require_once("$_FUNCIONES/fechas.php");

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
	
//	Incluir Libreria de manipulacion de Imagenes
	require_once("$_FUNCIONES/imagenes.gd.php");
	require_once("$_FUNCIONES/imagenes.gd.lib.php");

	use \Gumlet\ImageResize;
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Recibir Funcion Requerida
	$FUNCION										=	filtrarVAR($_REQUEST[f]);

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	Arbol de Funciones
	switch($FUNCION)
	{

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Agregar Imagen
		case "objetoImagenNueva"					:
		{
		//	Obtener Imagen
			$objeto_imagen							=	$_FILES['upl']['tmp_name'];
			$objeto_imagen_mine						=	file_mime_type($_FILES['upl']);
			$objeto_imagen_extension				=	obtenerExtension($objeto_imagen_mine);
			$objeto_id								=	filtrarID($_POST[imagen_objeto]);
			$objeto_tipo							=	filtrarVAR($_POST[imagen_tipo]);

		//	Obtener Parametros
			$objeto_imagen_id						=	sqlID("imagen_id_seq");
			
		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
		//	ALMACENAR IMAGEN Y GENERAR COPIAS
						
		//	Obtener el Tipo de Imagen
			switch($objeto_tipo)
			{
			//	Usuarios
				case "USU"							:
				{
				//	Crear Directorio
					$objeto_imagen_ruta				=	$_IMAGENES."/".$_IMAGENES_USUARIOS;
					
				//	Construir Ruta a la Imagen
					$imagen_url						=	$_LIBRERIAS_IMG.$_IMAGENES_USUARIOS."/".$objeto_imagen_id."_80".$objeto_imagen_extension;
				}
				break;
				
			//	Estadios
				case "EST"							:
				{
				//	Crear Directorio
					$objeto_imagen_ruta				=	$_IMAGENES."/".$_IMAGENES_ESTADIOS;
					
				//	Construir Ruta a la Imagen
					$imagen_url						=	$_LIBRERIAS_IMG.$_IMAGENES_ESTADIOS."/".$objeto_imagen_id."_80".$objeto_imagen_extension;
				}
				break;
				
			//	Arbitros
				case "ARB"							:
				{
				//	Crear Directorio
					$objeto_imagen_ruta				=	$_IMAGENES."/".$_IMAGENES_ARBITROS;
					
				//	Construir Ruta a la Imagen
					$imagen_url						=	$_LIBRERIAS_IMG.$_IMAGENES_ARBITROS."/".$objeto_imagen_id."_80".$objeto_imagen_extension;
				}
				break;
				
			//	Dts
				case "DTS"							:
				{
				//	Crear Directorio
					$objeto_imagen_ruta				=	$_IMAGENES."/".$_IMAGENES_DTS;
					
				//	Construir Ruta a la Imagen
					$imagen_url						=	$_LIBRERIAS_IMG.$_IMAGENES_DTS."/".$objeto_imagen_id."_80".$objeto_imagen_extension;
				}
				break;
			}
			
		//	Crear rutas de las imagenes creadas
			$objeto_imagen_900						=	$objeto_imagen_ruta."/".$objeto_imagen_id."_900".$objeto_imagen_extension;
			$objeto_imagen_600						=	$objeto_imagen_ruta."/".$objeto_imagen_id."_600".$objeto_imagen_extension;
			$objeto_imagen_80						=	$objeto_imagen_ruta."/".$objeto_imagen_id."_80".$objeto_imagen_extension;

		//	Crear Copias en Disco
			$image = new ImageResize($objeto_imagen);
			$image
			
			    ->resizeToWidth(900)
			    ->gamma(false)
			    ->save($objeto_imagen_900)
			    
			    ->resizeToWidth(600)
			    ->gamma(false)
			    ->save($objeto_imagen_600)
			    
			    ->resizeToHeight(80)
			    ->gamma(false)
			    ->save($objeto_imagen_80)
			;
						
		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
		//	INSERTAR IMAGEN A LA BASE DE DATOS
		
		//	Crear Variables para SQL
			$imagen_id								=	$objeto_imagen_id;
			$imagen_objeto							=	$objeto_id;
			$imagen_tipo							=	$objeto_tipo;
			$imagen_extension						=	$objeto_imagen_extension;
			$imagen_cambio							=	$_TIMESTAP;
			
		//	Construir SQL
			$QUERY									=	"
			
				SELECT * FROM
				imagen_nueva
				(
		        	$imagen_id,
		        	$imagen_objeto,
		        	'$imagen_tipo',
		        	'$imagen_extension',
		        	$imagen_cambio
				);
			
			";

		//	Ejecutar Query
			$QUERY_IMAGEN_NUEVA						=	pg_query($CONF_DB_CONNECT, $QUERY);

		//	Información de la Imagen
			$_RESULTADOS							=	array	
			(
				'imagen_id'							=>	$imagen_id,
				'imagen_objeto'						=>	$imagen_objeto,
				'imagen_tipo'						=>	$imagen_tipo,
				'imagen_extension'					=>	$imagen_extension,
				'imagen_cambio'						=>	$imagen_cambio,
				'imagen_url'						=>	$imagen_url
			);

		//	Encodear a Json el Colector
			$_JSON									=	json_encode($_RESULTADOS);
			
		//	Escribir resultado
			echo $_JSON;
		}
		break;
		
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Eliminar Imagen
		case "objetoImagenEliminar"					:
		{
		//	Obtener Variables
			$imagen_id								=	filtrarID($_POST[imagen_id]);
			$imagen_objeto							=	filtrarID($_POST[imagen_objeto]);
			
		//	Construir SQL
			$QUERY									=	"
			
				SELECT * FROM
				imagen_eliminar
				(
		        	$imagen_id,
		        	$imagen_objeto
				);
			
			";
			
		//	Ejecutar Query
			$QUERY_IMAGEN_ELIMINAR					=	pg_query($CONF_DB_CONNECT, $QUERY);

		//	Listado de Imagenes Disponibles
			while($_IMAGEN_ELIMINAR					=	pg_fetch_object($QUERY_IMAGEN_ELIMINAR))
			{
			//	Obtener el Tipo de Imagen
				switch( $_IMAGEN_ELIMINAR->imagen_tipo )
				{
				//	Usuarios
					case "USU"						:
					{
						$objeto_imagen_ruta			=	$_IMAGENES."/".$_IMAGENES_USUARIOS;
					}
					break;
					
				//	Estadios
					case "EST"						:
					{
						$objeto_imagen_ruta			=	$_IMAGENES."/".$_IMAGENES_ESTADIOS;
					}
					break;
					
				//	Arbitros
					case "ARB"						:
					{
						$objeto_imagen_ruta			=	$_IMAGENES."/".$_IMAGENES_ARBITROS;
					}
					break;
					
				//	Dts
					case "DTS"						:
					{
						$objeto_imagen_ruta			=	$_IMAGENES."/".$_IMAGENES_DTS;
					}
					break;

				}

			//	Crear rutas de las imagenes creadas
				$objeto_imagen_900					=	$objeto_imagen_ruta."/".$_IMAGEN_ELIMINAR->imagen_id."_900".$_IMAGEN_ELIMINAR->imagen_extension;
				$objeto_imagen_600					=	$objeto_imagen_ruta."/".$_IMAGEN_ELIMINAR->imagen_id."_600".$_IMAGEN_ELIMINAR->imagen_extension;
				$objeto_imagen_80					=	$objeto_imagen_ruta."/".$_IMAGEN_ELIMINAR->imagen_id."_80".$_IMAGEN_ELIMINAR->imagen_extension;

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

	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Cerrar Concción
	pg_close($CONF_DB_CONNECT);
	
?>