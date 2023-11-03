<?php
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	FUNCIONES PARA OBTENER LAS IMAGENES DE LOS OBJETOS
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Obtener el Poster del Objeto
	function objetoPoster( $OBJETO , $TIPO , $SIZE )
	{
	//	Obtener Variable
		global $_LIBRERIAS_IMG;
		global $_IMAGENES;
	
	//	Segmentar Valores del Objeto
		array($IMAGEN							=	explode("|", $OBJETO));

	//	Generar Variables Necesarias		
		$imagen_objeto							=	$IMAGEN[0];
		$imagen_id								=	$IMAGEN[1];
		$imagen_extension						=	$IMAGEN[2];
		$imagen_size							=	$SIZE;

	//	Obtener el Tipo de Imagen
		switch( $TIPO )
		{
		//	Usuarios
			case 'USU'							:
			{
			//	Obtener Variable
				global $_IMAGENES_USUARIOS;
				
			//	Crear Directorio
				$objeto_imagen_ruta				=	$_IMAGENES."/".$_IMAGENES_USUARIOS."/".$imagen_id."_".$imagen_size.$imagen_extension;
				
			//	Construir Ruta a la Imagen
				$imagen_url						=	$_LIBRERIAS_IMG.$_IMAGENES_USUARIOS."/".$imagen_id."_".$imagen_size.$imagen_extension;
			}
			break;
			
		//	Estadios
			case 'EST'							:
			{
			//	Obtener Variable
				global $_IMAGENES_ESTADIOS;
				
			//	Crear Directorio
				$objeto_imagen_ruta				=	$_IMAGENES."/".$_IMAGENES_ESTADIOS."/".$imagen_id."_".$imagen_size.$imagen_extension;
				
			//	Construir Ruta a la Imagen
				$imagen_url						=	$_LIBRERIAS_IMG.$_IMAGENES_ESTADIOS."/".$imagen_id."_".$imagen_size.$imagen_extension;
			}
			break;
			
		//	Arbitros
			case 'ARB'							:
			{
			//	Obtener Variable
				global $_IMAGENES_ARBITROS;
				
			//	Crear Directorio
				$objeto_imagen_ruta				=	$_IMAGENES."/".$_IMAGENES_ARBITROS."/".$imagen_id."_".$imagen_size.$imagen_extension;
				
			//	Construir Ruta a la Imagen
				$imagen_url						=	$_LIBRERIAS_IMG.$_IMAGENES_ARBITROS."/".$imagen_id."_".$imagen_size.$imagen_extension;
			}
			break;
			
		//	Dts
			case 'DTS'							:
			{
			//	Obtener Variable
				global $_IMAGENES_DTS;
				
			//	Crear Directorio
				$objeto_imagen_ruta				=	$_IMAGENES."/".$_IMAGENES_DTS."/".$imagen_id."_".$imagen_size.$imagen_extension;
				
			//	Construir Ruta a la Imagen
				$imagen_url						=	$_LIBRERIAS_IMG.$_IMAGENES_DTS."/".$imagen_id."_".$imagen_size.$imagen_extension;
			}
			break;

		}

	//	Validar que la imagen exista
		if(file_exists( $objeto_imagen_ruta ))
		{
		//	Construir Ruta a la Imagen
			$return								=	$imagen_url;
		}
		else
		{
		//	Construir Ruta a la Imagen
			$return								=	$_LIBRERIAS_IMG."no_foto.png";
		}
		
		return $return;
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Obtener Bandera del Pais
	function imagenPais( $ISO )
	{
	//	Variables Globales
		global $_IMAGENES;
		global $_IMAGENES_PAISES;
		global $_LIBRERIAS_IMG;

	//	Validar que la imagen exista
		if(file_exists($_IMAGENES."/".$_IMAGENES_PAISES."/".strtolower($ISO).".png"))
		{
			return $_LIBRERIAS_IMG.$_IMAGENES_PAISES."/".strtolower($ISO).".png";
		}
		else
		{
			return $_LIBRERIAS_IMG.$_IMAGENES_PAISES."/none.png";
		}
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Obtener Extension de la Imagen
	function obtenerExtension($mime)
	{
		switch($mime)
		{
			case "image/png"							:
			{
				return ".png";
			}
			break;
			
			case "image/jpeg"							:
			{
				return ".jpg";
			}
			break;
			
			case "image/gif"							:
			{
				return ".gif";
			}
			break;
		}
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Obtener el MIME del Objeto
	function file_mime_type($file)
	{
		$regexp = '/^([a-z\-]+\/[a-z0-9\-\.\+]+)(;\s.+)?$/';

		if (function_exists('finfo_file'))
		{
			$finfo = finfo_open(FILEINFO_MIME);
			if (is_resource($finfo))
			{
				$mime = @finfo_file($finfo, $file['tmp_name']);
				finfo_close($finfo);
				if (is_string($mime) && preg_match($regexp, $mime, $matches))
				{
					$file_type = $matches[1];
					return $file_type;
				}
			}
		}

		if (DIRECTORY_SEPARATOR !== '\\')
		{
			$cmd = 'file --brief --mime ' . escapeshellarg($file['tmp_name']) . ' 2>&1';
			if (function_exists('exec'))
			{
				$mime = @exec($cmd, $mime, $return_status);
				if ($return_status === 0 && is_string($mime) && preg_match($regexp, $mime, $matches))
				{
					$file_type = $matches[1];
					return $file_type;
				}
			}
			if ( (bool) @ini_get('safe_mode') === FALSE && function_exists('shell_exec'))
			{
				$mime = @shell_exec($cmd);
				if (strlen($mime) > 0)
				{
					$mime = explode("\n", trim($mime));
					if (preg_match($regexp, $mime[(count($mime) - 1)], $matches))
					{
						$file_type = $matches[1];
						return $file_type;
					}
				}
			}
			if (function_exists('popen'))
			{
				$proc = @popen($cmd, 'r');
				if (is_resource($proc))
				{
					$mime = @fread($proc, 512);
					@pclose($proc);
					if ($mime !== FALSE)
					{
						$mime = explode("\n", trim($mime));
						if (preg_match($regexp, $mime[(count($mime) - 1)], $matches))
						{
							$file_type = $matches[1];
							return $file_type;
						}
					}
				}
			}
		}
		if (function_exists('mime_content_type'))
		{
			$file_type = @mime_content_type($file['tmp_name']);
			if (strlen($file_type) > 0)
			{
				return $file_type;
			}
		}
		return $file['type'];
	}

?>