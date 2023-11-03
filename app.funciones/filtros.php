<?php
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	FILTROS PARA LIMPIAR VARIABLES RECIBIDAS
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Detectar Dispositivo Movil
	function detectarMovil()
	{
		return preg_match("/(android|avantgo|blackberry|bolt|boost|cricket|docomo|fone|hiptop|mini|mobi|palm|phone|pie|tablet|up\.browser|up\.link|webos|wos)/i", $_SERVER["HTTP_USER_AGENT"]);
	}
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Filtrar las variables antes de enviar SQL
	function sqlEscape($value)
	{
	//	return htmlentities(addcslashes($value,"\n\r\t\0\\\'\""));
		return addcslashes($value,"\n\r\t\0\\\'\"");
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Validar que el ID sea numerico
	function filtrarID($id)
	{
	    if(is_numeric($id))
	    {
			$salida						=	$id;
	    }
	    else
	    {
		    $salida						=	0;
	    }

		return sqlEscape($salida);
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Validar que la variable sea un String
	function filtrarVAR($var)
	{
	    if(is_string($var))
	    {
			$salida						=	$var;
	    }
	    else
	    {
		    $salida						=	"";
	    }

		return sqlEscape($salida);
	}
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Limpiar Campos Textarea
	function filtrarTEXTO($var)
	{
		$salida						=	filter_var($var, FILTER_SANITIZE_STRING);
		
		$str = str_replace("'", "''", $salida);
		$str = addcslashes($str,"\n\r\t\0\\\"");
		return $str;
	}
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Validar que la variable sea un String
	function filtrarTEXTAREA($var)
	{
	    $cadena_reemplazar				=	array(
		    										'&quot;',
		    										'&apos;',
		    										'&grave;',
		    										'&lsquo;',
		    										'&rsquo;'
		);
		
	    $cadena_no_permitidos			=	array(
		    										'"',
		    										"'",
		    										"`",
		    										"’",
		    										"‘"
	    );
		
	    if(is_string($var))
	    {	
		    $salida							=	str_replace($cadena_no_permitidos, $cadena_reemplazar, $var);
	    }
	    else
	    {
		    $salida						=	"";
	    }

		return addcslashes($salida,"\0\\\'\"");
	}
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Solo aceptar Numeros y Letras	
	function alfanumerico($var)
	{
	//	Solo aceptar numeros y letras
		$aplicar_regla					=	preg_match('/^[A-Za-z0-9 .\-]+$/i', $var);
		
	//	Validar condicion
		if($aplicar_regla == 1)
		{
			return $var;
		}
		else
		{
			exit();
		}
	}
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Quitar los Puntos de los Numeros
	function quitarPuntos($input)
	{
		if($input)
		{
		    $cadena_reemplazar				=	array('');
		    $cadena_no_permitidos			=	array('.');
	
		    $salida							=	str_replace($cadena_no_permitidos, $cadena_reemplazar, $input);	
		}
		else
		{
			$salida							=	0;
		}

	    return sqlEscape($salida);
	}
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Validar que el Usuario sea valido
	function usuarioValido($usuario)
	{
		if (preg_match('/^[A-Za-z0-9-_. ]{1}[A-Za-z0-9-_. ]{3,16}$/', $usuario))
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Validar que el Email sea valido
	function emailValido($email)
	{
	    return !!filter_var($email, FILTER_VALIDATE_EMAIL);
	}
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
	
//	Validar que la Password sea valida
	function passwordValido($password)
	{
	//	Contar el total de caracteres
		$caracteres	=	strlen($password);
		
	//	Validar que sea mayor al solicitado
		if($caracteres >= 5)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Filtrar email Correcto
	function filtrarMail($var)
	{
		$permitir						=	'/^[^@\s<&>]+@([-a-z0-9]+\.)+[a-z]{2,}$/i';
		
		if (preg_match($permitir, $var)) 
		{
			$varFilter					=	$var;
		}
		else
		{
			$varFilter					=	"";
		}
		
		return sqlEscape($varFilter);
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Filtrar email Correcto
	function filtrarPassword($var)
	{
		return sqlEscape(md5($var));
	}
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
	
//	Limitar la cadena de texto
	function limitar($texto,$caracteres)
	{
	//	Acortar cadena
		$texto_limitado		=	substr($texto , 0 ,$caracteres);
		
	//	Validar el Largo obtenido
		if (strlen($texto)	>=	$caracteres)
		{
			$salida			=	$texto_limitado."&hellip;";
		}
		else
		{
			$salida			=	$texto_limitado;
		}
		
		return $salida;
	}
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Formatear Numeros
	function puntos($numero)
	{
	//	Formato aplicado 1.000 - 10.000 - 100.000
		$numero_con_puntos		=	number_format($numero,0,'.','.');
		
		return $numero_con_puntos;
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
	
//	Encriptar valores
	function codificar($len)
	{
		$min_lenght= 0;
		$max_lenght = 100;
		$bigL = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		$smallL = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		$number = time();
		$bigB = str_shuffle($bigL);
		$smallS = str_shuffle($smallL);
		$numberS = str_shuffle($number);
		$subA = substr($bigB,0,5);
		$subB = substr($bigB,6,5);
		$subC = substr($bigB,10,5);
		$subD = substr($smallS,0,5);
		$subE = substr($smallS,6,5);
		$subF = substr($smallS,10,5);
		$subG = substr($numberS,0,5);
		$subH = substr($numberS,6,5);
		$subI = substr($numberS,10,5);
		$RandCode1 = str_shuffle($subA.$subD.$subB.$subF.$subC.$subE);
		$RandCode2 = str_shuffle($RandCode1);
		$RandCode = $RandCode1.$RandCode2;
		
		if ($len>$min_lenght && $len<$max_lenght)
		{
			$CodeEX = substr($RandCode,0,$len);
		}
		else
		{
			$CodeEX = $RandCode;
		}
		
		return $CodeEX;
	}
	
	function modRewrite($input)
	{		
		$cadena_reemplazar				=	array("n","n","u","u","o","o","i","i","e","e","a","a");
		$cadena_no_permitidos			=	array("Ñ","ñ","Ú","ú","Ó","ó","Í","í","É","é","Á","á");
		
	    $string							=	str_replace($cadena_no_permitidos, $cadena_reemplazar, $input);

		$string = str_replace(array('[\', \']'), '', $string);
	    $string = preg_replace('/\[.*\]/U', '', $string);
	    $string = preg_replace('/&(amp;)?#?[a-z0-9]+;/i', '-', $string);
	    $string = htmlentities($string, ENT_COMPAT, 'utf-8');
	    $string = preg_replace('/&([a-z])(acute|uml|circ|grave|ring|cedil|slash|tilde|caron|lig|quot|rsquo);/i', '\\1', $string );
	    $string = preg_replace(array('/[^a-z0-9]/i', '/[-]+/') , '-', $string);
	    return strtolower(trim($string, '-'));
	}
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Limpiar Campos Textarea
	function filtrarTag($var)
	{
		$salida						=	filter_var($var, FILTER_SANITIZE_STRING);
		
		$str = str_replace("-", " ", $salida);
		$str = addcslashes($str,"\n\r\t\0\\\"");
		return $str;
	}

?>