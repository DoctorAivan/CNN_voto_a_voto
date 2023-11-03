<?php

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Obtener la Hora del Objeto
	function obteneHora($fecha)
	{
		array($fecha_y_hora			=	explode(" ", $fecha));
		list($a,$m,$d)				=	explode("-",$fecha_y_hora[0]);
		list($h,$mi,$s) 			=	explode(":",$fecha_y_hora[1]);
		
		return "$h:$m";
	}
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
	
//	Obtener el Nombre del Dia del Objeto
	function obtenerNombreDia($fecha)
	{
		array($fecha_y_hora			=	explode(" ", $fecha));
		list($a,$m,$d)				=	explode("-",$fecha_y_hora[0]);
		
		$nombre_dia					=	dia($d,$m,$a);
		
		return $nombre_dia;
	}
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
	
//	Obtener Dia y mes Corto
	function obtenerDiaMes($fecha)
	{
		array($fecha_y_hora			=	explode(" ", $fecha));
		list($a,$m,$d)				=	explode("-",$fecha_y_hora[0]);
		
		$mes_corto					=	mesCorto($m);
		
		return "$d $mes_corto";
	}
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Generar formato de fecha de publicacion
	function creacion($fecha,$formato = 1)
	{
		array($fecha_y_hora			=	explode(" ", $fecha));
		list($a,$m,$d)				=	explode("-",$fecha_y_hora[0]);
		list($h,$mi,$s) 			=	explode(":",$fecha_y_hora[1]);
		
	//	Obtener nombres
		$nombre_dia					=	dia($d,$m,$a);
		$nombre_mes					=	mes($m);
		$nombre_mes_corto			=	mesCorto($m);
		
	//	Generar Formato
			 if($formato == 1)
		{
		//	Formato					=	Lunes 01 de Enero del 2011
			$salida					=	"$nombre_dia $d de $nombre_mes del $a";
		}
		else if($formato == 2)
		{
		//	Formato					=	Lunes 01 de Enero del 2011 a las 12:00 Hrs
			$salida					=	"$nombre_dia $d de $nombre_mes del $a a las $h:$mi Hrs";
		}
		else if($formato == 3)
		{
		//	Formato					=	01 de Enero del 2011
			$salida					=	"$d de $nombre_mes_corto del $a";
		}
		else if($formato == 4)
		{
		//	Formato					=	01 de Enero del 2011 a las 12:00
			$salida					=	"$d de $nombre_mes del $a a las $h:$mi";
		}
		else if($formato == 5)
		{
		//	Formato					=	01 de Enero del 2011 a las 12:00
			$salida					=	"$d/$m/$a";
		}
		else if($formato == 6)
		{
		//	Formato					=	01 de Enero
			$salida					=	"$d de $nombre_mes";
		}
		else
		{
			$salida					=	"";
		}

		return "$salida";

	}
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
	
//	Generar nombre para el dia
	function dia($dia,$mes,$ano)
	{
		$fecha						=	date("l", mktime(0,0,0,$mes,$dia,$ano));

		$cadena_inicial				=	array("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday");
		$cadena_reemplazar			=	array("Lunes","Martes","Miercoles","Jueves","Viernes","Sabado","Domingo");
		$salida						=	str_replace($cadena_inicial, $cadena_reemplazar, $fecha);
		
		return $salida;	
	}
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
	
//	Generar nombre para el mes
	function mes($mes)
	{
		$cadena_inicial				=	array("01","02","03","04","05","06","07","08","09","10","11","12");
		$cadena_reemplazar			=	array("Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre");
		$salida						=	str_replace($cadena_inicial, $cadena_reemplazar, $mes);
		
		return $salida;
	}
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
	
//	Generar nombre para el mes
	function mesCorto($mes)
	{
		$cadena_inicial				=	array("01","02","03","04","05","06","07","08","09","10","11","12");
		$cadena_reemplazar			=	array("ENE","FEB","MAR","ABR","MAY","JUN","JUL","AGO","SEP","OCT","NOV","DIC");
		$salida						=	str_replace($cadena_inicial, $cadena_reemplazar, $mes);
		
		return $salida;
	}
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
	
//	Generar nombre para el mes
	function edad($fechanacimiento)
	{
		array($fecha_y_hora			=	explode(" ", $fechanacimiento));
	
	    list($ano,$mes,$dia)		=	explode("-",$fecha_y_hora[0]);
	    $ano_diferencia				=	date("Y") - $ano;
	    $mes_diferencia				=	date("m") - $mes;
	    $dia_diferencia				=	date("d") - $dia;
	    
	    if ($dia_diferencia < 0 || $mes_diferencia < 0)
	        $ano_diferencia--;
	        
	    return $ano_diferencia;
	}
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
	
//	Generar nombre para el mes
	function tiempoTranscurrido( $date )
	{		
	    if( empty( $date ) )
	    {
	        return "No date provided";
	    }
	
	    $periods = array("segundo", "minuto", "hora", "dia", "semana", "mes", "año", "decada");
	
	    $lengths = array("60","60","24","7","4.35","12","10");
	
	    $now = time();
	
	    $unix_date = strtotime( $date );
	
	    // check validity of date
	
	    if( empty( $unix_date ) )
	    {
	        return "Bad date";
	    }
	
	    // is it future date or past date
	
	    if( $now > $unix_date )
	    {
	        $difference = $now - $unix_date;
	        $tense = "atrás";
	    }
	    else
	    {
	        $difference = $unix_date - $now;
	        $tense = "desde ahora";
	    }
	
	    for( $j = 0; $difference >= $lengths[$j] && $j < count($lengths)-1; $j++ )
	    {
	        $difference /= $lengths[$j];
	    }
	
	    $difference = round( $difference );
	
	    if( $difference != 1 )
	    {
	        $periods[$j].= "s";
	    }
	
		if($difference == 0)
		{
		    return "$periods[$j]";
		}
		else
		{
		    return "$difference $periods[$j]";
		}
	
//	    return "$difference $periods[$j] {$tense}";
//	    return "$difference $periods[$j]";
	
	}

?>