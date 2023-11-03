<?php

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	FUNCIONES DE LOS FORMULARIOS
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
	
//	Crear Array con los Dias Disponibles
	$_ARRAY_FORMULARIO_DIAS			=	array();
	
	foreach(range(1, 31) as $i)
	{		
	    $_ARRAY_FORMULARIO_DIAS[$i] = $i;
	}
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Crear Array con los Meses Disponibles
	$_ARRAY_FORMULARIO_MESES		=	array
	(
        '01'						=>	array('t' => 'Enero'),
        '02'						=>	array('t' => 'Febrero'),
        '03'						=>	array('t' => 'Marzo'),
        '04'						=>	array('t' => 'Abril'),
        '05'						=>	array('t' => 'Mayo'),
        '06'						=>	array('t' => 'Junio'),
        '07'						=>	array('t' => 'Julio'),
        '08'						=>	array('t' => 'Agosto'),
        '09'						=>	array('t' => 'Septiembre'),
        '10'						=>	array('t' => 'Octubre'),
        '11'						=>	array('t' => 'Noviembre'),
        '12'						=>	array('t' => 'Diciembre')
	);

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Crear Array con los Meses Disponibles
	$_ARRAY_FORMULARIO_CHECKBOX		=	array
	(
        '01'						=>	'Opcion Checkbox Listado prueba 1',
        '02'						=>	'Opcion Checkbox Listado prueba 2',
        '03'						=>	'Opcion Checkbox Listado prueba 3',
        '04'						=>	'Opcion Checkbox Listado prueba 4',
        '05'						=>	'Opcion Checkbox Listado prueba 5'
	);
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
	
//	Etiquetas de Colores
	$_ARRAY_FORMULARIO_ETIQUETAS	=	array
	(
        '1'							=>	array
        (
            'titulo'				=>	'Gris',
            'detalle'				=>	'',
            'clase'					=>	'etiqueta-gris'
        ),
        '2'							=>	array
        (
            'titulo'				=>	'Morado',
            'detalle'				=>	'',
            'clase'					=>	'etiqueta-morado'
        ),
        '3'							=>	array
        (
            'titulo'				=>	'Azul',
            'detalle'				=>	'',
            'clase'					=>	'etiqueta-azul'
        ),
        '4'							=>	array
        (
            'titulo'				=>	'Celeste',
            'detalle'				=>	'',
            'clase'					=>	'etiqueta-celeste'
        ),
        '5'							=>	array
        (
            'titulo'				=>	'Verde',
            'detalle'				=>	'',
            'clase'					=>	'etiqueta-verde'
        ),
        '6'							=>	array
        (
            'titulo'				=>	'Amarillo',
            'detalle'				=>	'',
            'clase'					=>	'etiqueta-amarillo'
        ),
        '7'							=>	array
        (
            'titulo'				=>	'Naranja',
            'detalle'				=>	'',
            'clase'					=>	'etiqueta-naranja'
        ),
        '8'							=>	array
        (
            'titulo'				=>	'Rojo',
            'detalle'				=>	'',
            'clase'					=>	'etiqueta-rojo'
        )
	);

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Genero de los Usuarios
	$_ARRAY_USUARIO_GENERO			=	array
	(
        'n'							=>	array
        (
            'titulo'				=>	'Prefiero no Revelarlo',
            'detalle'				=>	'',
            'icono'					=>	'fas fa-ban'
        ),
        'm'							=>	array
        (
            'titulo'				=>	'Masculino',
            'detalle'				=>	'',
            'icono'					=>	'fas fa-male'
        ),
        'f'							=>	array
        (
            'titulo'				=>	'Femenino',
            'detalle'				=>	'',
            'icono'					=>	'fas fa-female'
        )
	);

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Genero de los Usuarios
	$_ARRAY_ESTADO_MESAS			=	array
	(
		'0'							=>	array
		(
			'titulo'				=>	'Mesa Inactiva',
			'detalle'				=>	'Estará oculta para el operador',
			'icono'					=>	'fas fa-ban'
		),
		'1'							=>	array
		(
			'titulo'				=>	'Mesa Activa',
			'detalle'				=>	'Estará visible para el operador',
			'icono'					=>	'fas fa-eye'
		),
		'2'							=>	array
		(
			'titulo'				=>	'Mesa Cerrada',
			'detalle'				=>	'Estará oculta para el operador',
			'icono'					=>	'fas fa-lock'
		)
	);

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Crear Array con los Años Disponibles
	$_ARRAY_FORMULARIO_ANOS			=	array();
	
	foreach(range(1900, $_ANO) as $i)
	{
	    $_ARRAY_FORMULARIO_ANOS[$i] = $i;
	}
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Crear Array con los Años Disponibles
	$_ARRAY_FORMULARIO_HORAS			=	generarHoras( 0, 86400, 900, 'H:i' );
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	function generarHoras( $start = 0, $end = 86400, $step = 3600, $format = 'g:i a' )
	{
	    $times = array();
	    foreach ( range( $start, $end, $step ) as $timestamp ) {
	            $hour_mins = gmdate( 'H:i', $timestamp );
	            if ( ! empty( $format ) )
	                    $times[$hour_mins] = gmdate( $format, $timestamp );
	            else $times[$hour_mins] = $hour_mins;
	    }
	    return $times;
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Generar Listado de Checkbox
	function generarCheckbox( $ID , $ACTUAL , $ARRAY )
	{
	//	Generar array con los valores actuales
		$ARRAY_ACTUALES	= explode(",", $ACTUAL);
		
	//	Generar Listado desde el Array
		foreach ($ARRAY as $ARRAY_ID => $ARRAY_VALOR)
		{
		//	Marcar Opción Seleccionada
			if (in_array( $ARRAY_ID , $ARRAY_ACTUALES ))
			{
				$CHECK	=	'checked="checked"';
			}
			else
			{
				$CHECK	=	'';
			}
			
			$html	.=	'<label>'."\n";
			$html	.=	'	<input type="checkbox" class="box-shadow-light" name="'.$ID.'[]" value="'.$ARRAY_ID.'" '.$CHECK.'>'."\n";
			$html	.=	'	<span>'.$ARRAY_VALOR.'</span>'."\n";
			$html	.=	'</label>'."\n";
		}

	//	Generar HTML
		echo $html;
	}
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Generar Listado de Radio Button
	function generarRadioButton( $ID , $ACTUAL , $ARRAY )
	{
	//	Generar Listado desde el Array
		foreach ($ARRAY as $ARRAY_ID => $ARRAY_VALOR)
		{
		//	Marcar Opción Seleccionada
			if($ACTUAL == $ARRAY_ID)
			{
				$CHECK	=	'checked="checked"';
			}
			else
			{
				$CHECK	=	'';
			}
			
			$html	.=	'<label>'."\n";
			$html	.=	'	<input type="radio" class="box-shadow-light" name="'.$ID.'" value="'.$ARRAY_ID.'" '.$CHECK.'>';
			$html	.=	'	<span>'.$ARRAY_VALOR.'</span>'."\n";
			$html	.=	'</label>'."\n";
		}

	//	Generar HTML
		echo $html;
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Generar Listado seleccionable
	function generarSelect( $ID , $ACTUAL , $ARRAY )
	{
	//	Constriur objeto
		$html	=	'<div id="form-listado-'.$ID.'" class="listado-opciones bordes-radius box-shadow-light">'."\n";
		$html	.=	'	<div class="listado-opciones-icono"><i class="fas fa-angle-down"></i></div>'."\n";
		$html	.=	'	<div class="listado-opciones-actual"></div>'."\n";
		$html	.=	'	<div class="listado-opciones-items box-shadow-light" data="'.$ID.'">'."\n";

	//	Generar Listado desde el Array
		foreach ($ARRAY as $ARRAY_ID => $ARRAY_VALOR)
		{
		//	Marcar Opción Seleccionada
			if($ACTUAL == $ARRAY_ID)
			{
				$CSS	=	'class="on"';
			}
			else
			{
				$CSS	=	'';
			}

		//	Validar Array Asociativo
			if(is_array($ARRAY_VALOR))
			{
				$VALOR		=	$ARRAY_VALOR['t'];
			}
			else
			{
				$VALOR		=	$ARRAY_VALOR;
			}

			$html	.=	'		<div '.$CSS.'data="'.$ARRAY_ID.'" id="'.$ID.'_op_'.$ARRAY_ID.'" onclick="marcarListado(this);"><span>'.$VALOR.'</span></div>'."\n";
		}

		$html	.=	'	</div>'."\n";
		$html	.=	'	<input type="hidden" id="'.$ID.'" name="'.$ID.'" value="'.$ACTUAL.'" />'."\n";
		$html	.=	'</div>'."\n";

	//	Generar HTML
		echo $html;
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Generar Listado seleccionable
	function generarOpciones( $TIPO , $ID , $ACTUAL , $ARRAY , $TOOLTIP )
	{
	//	Constriur objeto
		$html	=	'<div id="form-opcion-'.$ID.'" class="opciones crop box-shadow-light bordes-radius">'."\n";

	//	Generar Listado desde el Array
		foreach ($ARRAY as $ARRAY_ID => $ARRAY_VALOR)
		{
		//	Marcar Opción Seleccionada
			if($ACTUAL == $ARRAY_ID)
			{
				$CSS	=	'on';
			}
			else
			{
				$CSS	=	'';
			}
			
			if($TIPO == "texto")
			{
				$TITLE	=	'<span>'.$ARRAY_VALOR['titulo'].'</span>';
			}
			if($TIPO == "icono")
			{
				$TITLE	=	'<i class="'.$ARRAY_VALOR['icono'].'"></i>';
			}
			if($TIPO == "clase")
			{
				$TITLE	=	'<div class="color box-shadow-light '.$ARRAY_VALOR['clase'].'"></div>';
			}
			
		//	Mostrar ToolTip
			if($TOOLTIP)
			{
				$html	.=	'	<div class="tipsy-'.$TOOLTIP.' '.$CSS.'" title="<h2>'.$ARRAY_VALOR['titulo'].'</h2><p>'.$ARRAY_VALOR['detalle'].'</p>" id="'.$ID.'-'.$ARRAY_ID.'" onclick="marcarOpcion('."'".$ID."','".$ARRAY_ID."'".');">'.$TITLE.'</div>'."\n";
			}
			else
			{
				$html	.=	'	<div class="'.$CSS.'" id="'.$ID.'-'.$ARRAY_ID.'" onclick="marcarOpcion('."'".$ID."','".$ARRAY_ID."'".');">'.$TITLE.'</div>'."\n";
			}
		}

		$html	.=	'	<input type="hidden" name="'.$ID.'" id="'.$ID.'" value="'.$ACTUAL.'" />'."\n";
		$html	.=	'</div>'."\n";

	//	Generar HTML
		echo $html;
	}


//	Generar Estado de la Mesa
	function generarMesaEstado( $TIPO , $ID , $ACTUAL , $ARRAY , $TOOLTIP )
	{
	//	Constriur objeto
		$html	=	'<div id="form-opcion-'.$ID.'" class="opciones crop box-shadow-light bordes-radius">'."\n";

	//	Generar Listado desde el Array
		foreach ($ARRAY as $ARRAY_ID => $ARRAY_VALOR)
		{
		//	Marcar Opción Seleccionada
			if($ACTUAL == $ARRAY_ID)
			{
				$CSS	=	'on';
			}
			else
			{
				$CSS	=	'';
			}
			
			if($TIPO == "texto")
			{
				$TITLE	=	'<span>'.$ARRAY_VALOR['titulo'].'</span>';
			}
			if($TIPO == "icono")
			{
				$TITLE	=	'<i class="'.$ARRAY_VALOR['icono'].'"></i>';
			}
			if($TIPO == "clase")
			{
				$TITLE	=	'<div class="color box-shadow-light '.$ARRAY_VALOR['clase'].'"></div>';
			}
			
		//	Mostrar ToolTip
			if($TOOLTIP)
			{
				$html	.=	'	<div class="tipsy-'.$TOOLTIP.' '.$CSS.'" title="<h2>'.$ARRAY_VALOR['titulo'].'</h2><p>'.$ARRAY_VALOR['detalle'].'</p>" id="'.$ID.'-'.$ARRAY_ID.'" onclick="mesa_cambiar_estado('."'".$ID."','".$ARRAY_ID."'".');">'.$TITLE.'</div>'."\n";
			}
			else
			{
				$html	.=	'	<div class="'.$CSS.'" id="'.$ID.'-'.$ARRAY_ID.'" onclick="mesa_cambiar_estado('."'".$ID."','".$ARRAY_ID."'".');">'.$TITLE.'</div>'."\n";
			}
		}

		$html	.=	'	<input type="hidden" name="'.$ID.'" id="'.$ID.'" value="'.$ACTUAL.'" />'."\n";
		$html	.=	'</div>'."\n";

	//	Generar HTML
		echo $html;
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Generar Funcionalidad para administrar Tags
	function generarTags( $OBJETO , $ARRAY )
	{		
	//	Generar Arreglo con los tags
		$TAGS	=	explode( ",", $ARRAY );
		
	//	ID del tag
		$ID		=	1;
		
	//	Constriur objeto
		$html	=	'<div class="tags" data="'.$OBJETO.'">'."\n";
		$html	.=	'	<div class="tags-input">'."\n";
		$html	.=	'		<input id="'.$OBJETO.'_input" onkeypress="return noEnter(this, event)" type="text" class="input-tag box-shadow-light" placeholder="Placeholder de Prueba" />'."\n";
		$html	.=	'	</div>';
		$html	.=	'	<div class="tags-boton box-shadow-light" onclick="agregarTag('. "'".$OBJETO."'".');">'."\n";
		$html	.=	'		<span><i class="fas fa-plus-circle"></i> Agregar Tag</span>';
		$html	.=	'	</div>';
		$html	.=	'	<div class="tags-items" id="'.$OBJETO.'_listado" data="'.$OBJETO.'">';

	//	Validar Existencia de Tags
		if( $ARRAY == '' )
		{

		}
		else
		{
		//	Generar Listado desde Tags Actuales
			foreach ($TAGS as $TAGS_ID => $TAGS_OBJ)
			{
				$html	.=	'	<div id="'.$OBJETO.'_tag_'.$ID.'" class="bordes-radius box-shadow-light">'.$TAGS_OBJ.'<i class="fas fa-minus-circle" onclick="quitarTag('.$ID.','."'".$OBJETO."'".');"></i></div>';
				
				$ID++;
			}
		}

		$html	.=	'	</div>';
		$html	.=	'	<input type="hidden" name="'.$OBJETO.'" id="'.$OBJETO.'" value="'.$ARRAY.'" />';
		$html	.=	'</div>';

	//	Generar HTML
		echo $html;
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Generar Listado de Imagenes
	function generarImagenes( $IMAGENES , $TIPO , $SIZE )
	{
	//	Obtener Variables Globales
		global $_LIBRERIAS_IMG;

	//	Tipo de Objeto
		switch($TIPO)
		{
		//	Usuarios
			case "USU"			:
			{
			//	Obtener Variables Globales
				global $_IMAGENES_USUARIOS;
				
			//	Construir Ruta a la Imagen
				$_IMG			=	$_LIBRERIAS_IMG.$_IMAGENES_USUARIOS;
			}
			break;
			
		//	Estadios
			case "EST"			:
			{
			//	Obtener Variables Globales
				global $_IMAGENES_ESTADIOS;
				
			//	Construir Ruta a la Imagen
				$_IMG			=	$_LIBRERIAS_IMG.$_IMAGENES_ESTADIOS;
			}
			break;
			
		//	Arbitros
			case "ARB"			:
			{
			//	Obtener Variables Globales
				global $_IMAGENES_ARBITROS;
				
			//	Construir Ruta a la Imagen
				$_IMG			=	$_LIBRERIAS_IMG.$_IMAGENES_ARBITROS;
			}
			break;
			
		//	Dts
			case "DTS"			:
			{
			//	Obtener Variables Globales
				global $_IMAGENES_DTS;
				
			//	Construir Ruta a la Imagen
				$_IMG			=	$_LIBRERIAS_IMG.$_IMAGENES_DTS;
			}
			break;

		}

	//	Validar Existencia de Imagenes
		if( count($IMAGENES) == 0 )
		{
			$html	.=	'	<article>'."\n";
			$html	.=	'		Aun no existen imágenes disponibles'."\n";
			$html	.=	'	</article>'."\n";
		}
		else
		{
		//	Generar Listado de Imagenes
			foreach ($IMAGENES as $IMAGEN_ID => $OBJ)
			{
				$html	.=	'	<div id="foto-'.$OBJ->imagen_id.'" data="'.$OBJ->imagen_id.'">'."\n";
				$html	.=	'		<img src="'. $_IMG ."/". $OBJ->imagen_id .'_'. $SIZE . $OBJ->imagen_extension .'?'. $OBJ->imagen_cambio .'" />'."\n";
				$html	.=	'	</div>'."\n";
			}
		}
		
	//	Generar HTML
		echo $html;
	}