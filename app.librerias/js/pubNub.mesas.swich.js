//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	FUNCIONALIDAD PUBNUB PARA EL SWICH
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Estado de los cambios en la configuracion
	var swich_cambios = 0;

//	Estado de la actualización de datos
	var recargar_estado = 0;

//	Definir valores anteriores
	var swich_modo_anterior = 0;
	var swich_mesas_anterior = 0;

//	Iniciar al Cargar
	$(function()
	{
	//	Iniciar funcionalidad TimeAgo
		$("time.timeago").timeago();
		
	//	Mover Mesas Almacenadas
		cargarSwich();
	});

	var sortValues =
	{
		rojo: 2,
		amarillo: 1,
		verde: 0
	};

	var rexValues = /(rojo|amarillo|verde)/;

	var myVar = setInterval(myTimer, 3000);

	function myTimer()
	{
	//	mesas_orden_listado();
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Ordenar Mesas
	function mesas_orden_listado()
	{
		var elem = $('#mesas').find('.mesa').sort(sortMe);
		$('#mesas').append(elem);

	//	Reiniciar Timeago
		$("time.timeago").timeago();
	}

	function sortMe(a, b)
	{
		var aclass = a.className.match(rexValues);
		var avalue = aclass ? sortValues[aclass[0]] : 99;
		var bclass = b.className.match(rexValues);
		var bvalue = bclass ? sortValues[bclass[0]] : 99;
		return avalue - bvalue;
	}


//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Iniciar PubNub
	pubnub.addListener(
	{
	//	Recibir Mensajes
		message: function(message)
		{
		//	Obtener Nuevo Dato
			let datoPubNub			=	message.message;

		//	Obtener Accion desde PubNub
			let accion				=	datoPubNub.accion;

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Accion : Actualizar el contenido
			if( accion == 'recargar' )
			{
			//	Esperar para realizar cambios
				if( swich_cambios == 1 )
				{
					console.log( 'recarga pausada' );
				}
				else
				{
				//	Actualizar Pagina
					location.reload();
				}

			//	Almacenar Estado
				recargar_estado = 1;
			}

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Accion : Voto Emitido
			if( accion == 'voto' )
			{
			//	Obtener Variables de la Mesa
				let mesa_id				=	datoPubNub.mesa;
				
			//	Mostar Funcionalidad de carga
				$("#MES" + mesa_id + " .cambios" ).fadeIn( 250 , function()
				{
				//	Reiniciar el Largo del contenedor
					$("#MES" + mesa_id + " .cambios" ).delay( 100 ).fadeOut( 250 );
				});
				
			//	Calcular Fecha y Hora
				let today		=	new Date();
				let date		=	today.getFullYear() + '-' + (today.getMonth()+1) + '-' + today.getDate();
				let time		=	today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
				let dateTime	=	date+' '+time;
				
			//	Asignar Fecha actual
				$( "#" + mesa_id + "_mesa_cambio" ).html( '<time class="timeago line-1" data="' + mesa_id + '"  datetime="'+ dateTime + '"></time>' );
				
			//	Reiniciar Timeago
				$("time.timeago").timeago();
			}
		},
		presence: function(presenceEvent)
		{

		}
	});

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Suscribir al Canal PubNub
    pubnub.subscribe(
	{
        channels: ['vav_mesas'],
        withPresence: true
    });

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Mover Mesas Almacenadas
	function cargarSwich()
	{
	//	Validar Espacio 1
		if( swich_mesa_1 != 0 )
		{
			let	mesa	=	$( "#MES" + swich_mesa_1 );
			mesa.clone().prependTo('#mesa-1');
			mesa.remove();
		}
		
	//	Validar Espacio 2
		if( swich_mesa_2 != 0 )
		{
			let mesa	=	$( "#MES" + swich_mesa_2 );
			mesa.clone().prependTo('#mesa-2');
			mesa.remove();
		}
		
	//	Validar Espacio 3
		if( swich_mesa_3 != 0 )
		{
			let mesa	=	$( "#MES" + swich_mesa_3 );
			mesa.clone().prependTo('#mesa-3');
			mesa.remove();
		}
		
	//	Validar Espacio 4
		if( swich_mesa_4 != 0 )
		{
			let mesa	=	$( "#MES" + swich_mesa_4 );
			mesa.clone().prependTo('#mesa-4');
			mesa.remove();
		}
		
	//	Iniciar Funcionalidad Sortable
		$( ".relacionados" ).sortable(
		{
			placeholder: "drag",
			connectWith: ".relacionados"
		});

	//	Marcar modo de render
		$("#swich-opcion-modo-" + swich_modo).removeClass("of").addClass("on");

	//	Marcar Numero de Mesas a Mostrar
		$("#swich-opcion-mesas-" + swich_mesas).removeClass("of").addClass("on");
		
	//	Marcar Tipo de Votos a Mostrar
		$("#swich-opcion-votos-" + swich_votos).removeClass("of").addClass("on");
		
	//	Validar Template y mesas Seleccionado
		swichMesasActivas( swich_mesas );		
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Vaciar Mesas del Espacio
	function vaciarEspacio(id)
	{
	//	Destruir Funcionalidad Sortable
		$('.relacionados').sortable('destroy');
		
	//	Obtener Listado de Mesas en el Listado
		$( '#mesa-' + id + ' > article' ).each(function()
		{
			let mesa	=	$("#" + $(this).attr('id'));
				mesa.clone().prependTo('#mesas');
				mesa.remove();
		});
		
	//	Reiniciar Funcionalidad Sortable
		$( ".relacionados" ).sortable(
		{
			placeholder: "drag",
			connectWith: ".relacionados"
		});
		
	//	Reiniciar Timeago
		$("time.timeago").timeago();
		
	//	Aplicar Cambios a los Botones
		swich_cambios	=	1;

	//	Estado de Cambios en el Swich
		estadoSwich();
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Vaciar Total de Mesas del Espacio
	function espacioValidar()
	{
	//	Destruir Funcionalidad Sortable
		$('.relacionados').sortable('destroy');

	//	ID del Listado
		var i	=	0;

	//	Obtener Listado de Mesas en el Listado 1
		$( '#mesa-1 > .mesa-swich' ).each(function()
		{
		//	Excluir el Primer Child
			if( i > 0 )
			{
			//	Mover Mesa al Listado Principal
			let mesa	=	$("#" + $(this).attr('id'));
				mesa.clone().prependTo('#mesas');
				mesa.remove();
			}
			
		//	Aumentar Child
			i++;
		});

	//		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	ID del Listado
		var i	=	0;

	//	Obtener Listado de Mesas en el Listado 2
		$( '#mesa-2 > .mesa-swich' ).each(function()
		{
		//	Excluir el Primer Child
			if( i > 0 )
			{
			//	Mover Mesa al Listado Principal
			let mesa	=	$("#" + $(this).attr('id'));
				mesa.clone().prependTo('#mesas');
				mesa.remove();
			}
			
		//	Aumentar Child
			i++;
		});

	//		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	ID del Listado
		var i	=	0;

	//	Obtener Listado de Mesas en el Listado 3
		$( '#mesa-3 > .mesa-swich' ).each(function()
		{
		//	Excluir el Primer Child
			if( i > 0 )
			{
			//	Mover Mesa al Listado Principal
			let mesa	=	$("#" + $(this).attr('id'));
				mesa.clone().prependTo('#mesas');
				mesa.remove();
			}
			
		//	Aumentar Child
			i++;
		});

	//		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	ID del Listado
		var i	=	0;

	//	Obtener Listado de Mesas en el Listado 4
		$( '#mesa-4 > .mesa-swich' ).each(function()
		{
		//	Excluir el Primer Child
			if( i > 0 )
			{
			//	Mover Mesa al Listado Principal
			let mesa	=	$("#" + $(this).attr('id'));
				mesa.clone().prependTo('#mesas');
				mesa.remove();
			}
			
		//	Aumentar Child
			i++;
		});

	//	Reiniciar Funcionalidad Sortable
		$( ".relacionados" ).sortable(
		{
			placeholder: "drag",
			connectWith: ".relacionados"
		});
		
	//	Estado de Cambios en el Swich
		estadoSwich();
	}
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Estado de Cambios en el Swich
	function estadoSwich()
	{
	//	Cambiar Estado de los Botones
		if(swich_cambios == 0)
		{
			$("#cambios-on").css("display","none");
			$("#cambios-of").css("display","block");
		}
		else
		{
			$("#cambios-on").css("display","block");
			$("#cambios-of").css("display","none");
		}
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Seleccionar Numero de Mesas a Mostrar
	function swichMesas( id )
	{
	//	Guardar opcion seleccionada
		swich_mesas		=	id;
		
	//	Obtener Listado de Mesas en el Listado
		$( '#swich-opcion-mesas > div' ).each(function()
		{
			$(this).removeClass("on").addClass("of");
		});

	//	Destacar la Opcion seleccionada
		$("#swich-opcion-mesas-" + id).removeClass("of").addClass("on");

	//	Validar Template y mesas Seleccionado
		swichMesasActivas( id );

	//	Aplicar Cambios a los Botones
		swich_cambios	=	1;

	//	Estado de Cambios en el Swich
		estadoSwich();
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Validar Template y mesas Seleccionado
	function swichMesasActivas( id )
	{
	//	Template 1 Mesa
		if( swich_mesas == 0 )
		{
			$("#swich-mesa-1").css("opacity","0.5");
			$("#swich-mesa-1").css("filter","blur(0.075rem)");
			
			$("#swich-mesa-2").css("opacity","0.5");
			$("#swich-mesa-2").css("filter","blur(0.075rem)");
			
			$("#swich-mesa-3").css("opacity","0.5");
			$("#swich-mesa-3").css("filter","blur(0.075rem)");
			
			$("#swich-mesa-4").css("opacity","0.5");
			$("#swich-mesa-4").css("filter","blur(0.075rem)");
		}
		
	//	Template 1 Mesa
		if( swich_mesas == 1 )
		{
			$("#swich-mesa-1").css("opacity","1");
			$("#swich-mesa-1").css("filter","blur(0rem)");
			
			$("#swich-mesa-2").css("opacity","0.5");
			$("#swich-mesa-2").css("filter","blur(0.075rem)");
			
			$("#swich-mesa-3").css("opacity","0.5");
			$("#swich-mesa-3").css("filter","blur(0.075rem)");
			
			$("#swich-mesa-4").css("opacity","0.5");
			$("#swich-mesa-4").css("filter","blur(0.075rem)");
		}

	//	Template 2 Mesas
		if( swich_mesas == 2 )
		{
			$("#swich-mesa-1").css("opacity","1");
			$("#swich-mesa-1").css("filter","blur(0rem)");

			$("#swich-mesa-2").css("opacity","1");
			$("#swich-mesa-2").css("filter","blur(0rem)");
			
			$("#swich-mesa-3").css("opacity","0.5");
			$("#swich-mesa-3").css("filter","blur(0.075rem)");
			
			$("#swich-mesa-4").css("opacity","0.5");
			$("#swich-mesa-4").css("filter","blur(0.075rem)");
		}

	//	Template 3 Mesas
		if( swich_mesas == 3 )
		{
			$("#swich-mesa-1").css("opacity","1");
			$("#swich-mesa-1").css("filter","blur(0rem)");

			$("#swich-mesa-2").css("opacity","1");
			$("#swich-mesa-2").css("filter","blur(0rem)");
			
			$("#swich-mesa-3").css("opacity","1");
			$("#swich-mesa-3").css("filter","blur(0rem)");
			
			$("#swich-mesa-4").css("opacity","0.5");
			$("#swich-mesa-4").css("filter","blur(0.075rem)");
		}

	//	Template 4 Mesas
		if( swich_mesas == 4 )
		{
			$("#swich-mesa-1").css("opacity","1");
			$("#swich-mesa-1").css("filter","blur(0rem)");

			$("#swich-mesa-2").css("opacity","1");
			$("#swich-mesa-2").css("filter","blur(0rem)");
			
			$("#swich-mesa-3").css("opacity","1");
			$("#swich-mesa-3").css("filter","blur(0rem)");
			
			$("#swich-mesa-4").css("opacity","1");
			$("#swich-mesa-4").css("filter","blur(0rem)");
		}		
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Seleccionar Modo a mostrar
	function swichModo( id )
	{
	//	Guardar opcion seleccionada
		swich_modo		=	id;
		
	//	Obtener Listado de Mesas en el Listado
		$( '#swich-opcion-modo > div' ).each(function()
		{
			$(this).removeClass("on").addClass("of");
		});

	//	Destacar la Opcion seleccionada
		$("#swich-opcion-modo-" + id).removeClass("of").addClass("on");

	//	Aplicar Cambios a los Botones
		swich_cambios	=	1;

	//	Estado de Cambios en el Swich
		estadoSwich();
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
	
//	Editar las Mesas que serán Mostradas
	function swichGuardar()
	{
	//	Obtener ID de las Mesas
		let swich_mesa_1			=	$( "#mesa-1 > .mesa-swich" ).first().attr('mesa');
		let swich_mesa_2			=	$( "#mesa-2 > .mesa-swich" ).first().attr('mesa');
		let swich_mesa_3			=	$( "#mesa-3 > .mesa-swich" ).first().attr('mesa');
		let swich_mesa_4			=	$( "#mesa-4 > .mesa-swich" ).first().attr('mesa');

	//	Actualizar de las Mesas
		$.post( path_app + '/swich/editar/' ,
		{
			swich_id				:	1,
			swich_modo				:	swich_modo,
			swich_mesas				:	swich_mesas,
			swich_mesa_1			:	swich_mesa_1,
			swich_mesa_2			:	swich_mesa_2,
			swich_mesa_3			:	swich_mesa_3,
			swich_mesa_4			:	swich_mesa_4,
			swich_votos				:	swich_votos
		})
		.done(function( data )
		{
		//	Aplicar Cambios a los Botones
			swich_cambios	=	0;

		//	Estado de Cambios en el Swich
			estadoSwich();
			
        //	Construir Variable para enviar a PubNub
            let pubnub       	=
            {
                'accion'		:	'switch',
                'modo'          :	swich_modo,
				'template'		:	swich_mesas,
                'mesa_1'		:	Number(swich_mesa_1),
				'mesa_2'		:	Number(swich_mesa_2)
            }

        //	Enviar Notificación a PubNub
			enviarPubNub( pubnub );

		//	Esperar para realizar cambios
			if( recargar_estado == 1 )
			{
			//	Actualizar Pagina
				location.reload();
			}

		//	Validar modo actual
			if( swich_modo != swich_modo_anterior || swich_mesas == 0 )
			{
			//	Desactivar consolidados
				estadoConsolidadosActual('of');

			//	Almacenar modo actual
				swich_modo_anterior = swich_modo;
			}
		});
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
	
//	Editar las Mesas que serán Mostradas
	function swichPreview()
	{
	//	Obtener ID de las Mesas
		let swich_mesa_1			=	$( "#mesa-1 > .mesa-swich" ).first().attr('mesa');
		let swich_mesa_2			=	$( "#mesa-2 > .mesa-swich" ).first().attr('mesa');
		let swich_mesa_3			=	$( "#mesa-3 > .mesa-swich" ).first().attr('mesa');
		let swich_mesa_4			=	$( "#mesa-4 > .mesa-swich" ).first().attr('mesa');

	//	Actualizar de las Mesas
		$.post( path_app + '/swich/editar/' ,
		{
			swich_id				:	1,
			swich_modo				:	swich_modo,
			swich_mesas				:	swich_mesas,
			swich_mesa_1			:	swich_mesa_1,
			swich_mesa_2			:	swich_mesa_2,
			swich_mesa_3			:	swich_mesa_3,
			swich_mesa_4			:	swich_mesa_4,
			swich_votos				:	swich_votos
		})
		.done(function( data )
		{
		//	Aplicar Cambios a los Botones
		//	swich_cambios	=	0;

		//	Estado de Cambios en el Swich
		//	estadoSwich();
			
        //	Construir Variable para enviar a PubNub
            let pubnub       	=
            {
                'accion'		:	'preview',
                'modo'          :	swich_modo,
				'template'		:	swich_mesas,
                'mesa_1'		:	Number(swich_mesa_1),
				'mesa_2'		:	Number(swich_mesa_2),
				'mesa_3'		:	Number(swich_mesa_3),
				'mesa_4'		:	Number(swich_mesa_4)
            }

        //	Enviar Notificación a PubNub
			enviarPubNub( pubnub );
		});
	}