
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	FUNCIONALIDAD TAGS
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Identificador de los Tags
	var tag_id					=	0;

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Deshabilitar envio del formulario con el Enter
	function noEnter(field, event)
	{		
		var keyCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
		if (keyCode == 13)
		{
			return false;
		}
		else
		return true;
	}      

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Agregar Tag al Listado
	function agregarTag( objeto )
	{	
	//	Obtener Tag
		var tag				=	$('#' + objeto + '_input').val().toLowerCase().trim();
		
	//	Validar contenido
		if(tag)
		{
		//	Quitar Error
			$('#' + objeto + '_input').removeClass("input-tags-error").addClass("input-tags");		
	
		//	Tags Duplicados
			var tag_existe		=	0;
			
		//	Validar Tag Duplucado
			$( '#' + objeto + '_listado div' ).each(function()
			{
				var tag_div		=	$( this ).text();
				
				if(tag_div == tag)
				{
					tag_existe++;
				}
			});
			
		//	Tag no duplicado
			if(tag_existe == 0)
			{
			//	ID del nuevo Tag
				var id				=	$( '#' + objeto + '_listado div' ).length + 1;
				
			//	Html del Objeto
				var html			=	'<div id="' + objeto + '_tag_' + id + '" class="bordes-radius box-shadow-light">' + tag + '<i class="fas fa-minus-circle" onClick="quitarTag(' + id + ',' + "'" + objeto + "'" + ');"></i></div>';
				
			//	Agregar Nuevo tag
				$( '#' + objeto + '_listado' ).append( html );
				
			//	Reiniciar Input
				$( '#' + objeto + '_input' ).val("");
				$( '#' + objeto + '_input' ).focus();

			//	Almacenar tags actuales
				tags( objeto );
			}
			else
			{
			//	Reiniciar Input
				$( '#' + objeto + '_input' ).val("");
				$( '#' + objeto + '_input' ).focus();		
			}
		}
	}
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Quitar Tag al Listado
	function quitarTag( id , objeto )
	{
	//	Animacion para eliminar el Tag
		$( '#' + objeto + '_tag_' + id ).fadeOut( "normal" , function()
		{
		//	Eliminar Div
			$( '#' + objeto + '_tag_' + id ).remove();
			
		//	Almacenar tags actuales
			tags( objeto );
		});
	}
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Almacenar tags actuales	en el Input Hidden
	function tags( objeto )
	{		
	//	Total de Tags actuales
		var total_tags	=	$( '#' + objeto + '_listado div' ).length;

	//	Id de los Tags
		var id_tags		=	1;
		
	//	Objeto con los Tags
		var tags		=	"";
		
	//	Recorrer tags actuales
		$( '#' + objeto + '_listado div' ).each(function()
		{
		//	Validar la separacion
			if(id_tags == total_tags)
			{
				tags		+=	$( this ).text();
			}
			else
			{
				tags		+=	$( this ).text() + ",";
			}
			
		//	Aumentar el ID del los tag
			id_tags++;
		});
		
	//	Actualizar tags actuales
		$( '#' + objeto ).val( tags );
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Iniciar al cargar
	$(document).ready(function()
	{
	//	Limitar Caracteres en los Tags
		$('.input-tag').keyup(function (event)
		{
		//	Caracteres aceptados
			if (this.value.match(/[^A-Za-z0-9ÑñÁáÉéÍíÓóÚú ]/g))
			{
			    this.value = this.value.replace(/[^A-Za-z0-9ÑñÁáÉéÍíÓóÚú ]/g, '');
			}
			
		//	Obtener ID de la Tecla
			var keycode = (event.keyCode ? event.keyCode : event.which);

		//	Aceptar tecla ENTER
			if(keycode == '13' || keycode == '188')
			{
			//	Obtener el Objeto Contenedor
				var objeto	=	$( this ).parent().parent().attr('data');

			//	Agregar Tag al Listado
				agregarTag( objeto );
			}
		});
		
	//	Funcionalidad Sortable a los Tags
		$(".tags-items").sortable(
		{
			placeholder: "drag",
			start: function(e,ui)
			{
			//	Tags Seleccionado
				var objeto = ui.helper.context.id;
				
			//	Obtener el Ancho del Objeto
				var ancho = $( "#" + objeto ).width();

			//	Asignar el Ancho al handlie
				$( "#" + objeto ).parent().find('.drag').css( "width" , ancho );
			},
			stop: function()
			{
			//	Obtener Objeto Contenedor
				var objeto = $( this ).context.id.replace("_listado", "");
				
			//	Almacenar tags actuales	en el Input Hidden
				tags( objeto );
			}
		});
	});