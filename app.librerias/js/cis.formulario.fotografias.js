
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	FUNCIONES PARA LA MANIPULACIÓN DE FOTOGRAFIAS
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	ID de la Fotografía seleccionada
	var fotografia_actual					=	0;

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Ejecturar al Inicio
	$(function()
	{
	//	Configurar funcionalidad Subir nueva Imagen
	    $('#fotografia-subir-archivo').fileupload({

	        acceptFileTypes: /(\.|\/)(jpe?g)$/i,
	        maxFileSize: 2000000,
	        
		//	Detectar nueva Imagen
	        add: function (e, data)
	        {
			//	Enviar la informacion
	            var jqXHR = data.submit();
	            
			//	Mostar Funcionalidad de carga
	            $(".fotografias-cargando").fadeIn( 500 );
	        },
	        
		//	Progreso de la funcion
	        progress: function(e, data)
	        {
			//	Calcular el porcentaje de la Carga
	            var progress = parseInt(data.loaded / data.total * 100, 10);

			//	Escalar la barra de Carga
				$(".fotografias-cargando-barra-bg").css("width" , progress + "%");

			//	Cambiar el icono del Boton cancelar
	            if(progress == 100)
	            {
				//	Mostar Funcionalidad de carga
					$(".fotografias-cargando").delay( 1500 ).fadeOut( 500 , function()
					{
					//	Reiniciar el Largo del contenedor
						$(".fotografias-cargando-barra-bg").css("width" , "0%");
					});
	            }
	        },
	        
		//	Proceso terminado
			done: function(e, data)
			{
		//	Convertir Respuesta en Objeto jSon
			var json	=	jQuery.parseJSON(data.result);

			//	Agregar la imagen al Listado
				$("#fotografias article").remove();

			//	Construir Objeto
			var obj		=	'<div id="foto-' + json.imagen_id + '" data="' + json.imagen_id + '" class="ui-sortable-handle">';
				obj		+=	'	<img src="' + json.imagen_url + '?' + json.imagen_cambio + '">';
				obj		+=	'	<label class="opciones">';
				obj		+=	'		<i onclick="fotografiaEditar(' + json.imagen_id + ');" class="fas fa-tools"></i>';
				obj		+=	'		<i onclick="fotografiaEliminar(' + json.imagen_id + ');" class="fas fa-minus-circle"></i>';
				obj		+=	'	</label>';
				obj		+=	'</div>';
				
			//	Agregar la imagen al Listado
				$("#fotografias").prepend( obj );
				
			//	Serializar el Orden de las Fotografias
				fotografiasSerializar();
			}
	    });
		
	//	Funcionalidad Sortable a las fotografias
		$("#fotografias").sortable(
		{
			placeholder: "drag",
			stop: function()
			{
			//	Serializar el Orden de las Fotografias
				fotografiasSerializar();
			}
		});
		
	//	Serializar el Orden de las Fotografias
		fotografiasSerializar();
		
	//	Agregar funciones de Editar y Eliminar a las Fotos
		fotografiasAgregarOpciones();
	});
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Serializar el Orden de las Fotografias
	function fotografiasSerializar()
	{
	//	Total de Fotografias actuales
		var total_fotos			=	$("#fotografias div").length;
		
	//	Id de los Tags
		var id_foto				=	1;
		
	//	Objeto con los Tags
		var fotos				=	"";
		
	//	Recorrer tags actuales
		$( "#fotografias div" ).each(function()
		{
		//	Validar la separacion
			if(id_foto == total_fotos)
			{
				fotos		+=	$( this ).attr('data');
			}
			else
			{
				fotos		+=	$( this ).attr('data') + ",";
			}
			
		//	Aumentar el ID del los tag
			id_foto++;
		});
		
	//	Actualizar tags actuales
		$("#objeto-fotografias").val( fotos );
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Agregar funciones de Editar y Eliminar a las Fotos
	function fotografiasAgregarOpciones()
	{
	//	Recorrer tags actuales
		$( "#fotografias div" ).each(function()
		{
			var id	=	$( this ).attr('data');
			
		//	Construir Opciones del Objeto
			var opciones	=	'<label class="opciones">';
				opciones	+=	'	<i onClick="fotografiaEditar(' + id + ');" class="fas fa-tools"></i>';
				opciones	+=	'	<i onClick="fotografiaEliminar(' + id + ');" class="fas fa-minus-circle"></i>';
				opciones	+=	'</label>';
			
			$(this).append(opciones);
		});
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Editar Fotografia
	function fotografiaEditar(id)
	{
	//	Iniciar Livebox
		abrirLivebox('fotografia-editar');
		
	//	Almacenar ID
		fotografia_actual	=	id;
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Eliminar Fotografia
	function fotografiaEliminar(id)
	{
	//	Iniciar Livebox
		abrirLivebox('fotografia-eliminar');
		
	//	Almacenar ID
		fotografia_actual	=	id;
	}

	//	Eliminar Fotografia Confirmación
		function fotografiaEliminarConfirmar()
		{
		//	Mostrar Usabilidad Cargando
			cargandoLivebox();

			$.post( path_app + "/objeto/imagen/eliminar/",
			{
				imagen_id		:	fotografia_actual,
				imagen_objeto	:	imagen_objeto
			})
			.done(function( data )
			{
			//	Animacion para eliminar el Tag
				$( '#foto-' + fotografia_actual ).fadeOut( "normal" , function()
				{
				//	Eliminar Div
					$("#foto-" + fotografia_actual).remove();
					
				//	Cerrar Livebox
					cerrarLivebox();
				});
			});
			
		}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Funcionalidad para seleccionar las Imagenes
	function fotografiaNueva()
	{
		$("#fotografia-subir-archivo-input").click();
	}