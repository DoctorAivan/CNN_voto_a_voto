//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	FUNCIONALIDAD PUBNUB
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	var sortValues =
	{
		rojo: 2,
		amarillo: 1,
		verde: 0
	};

	var rexValues = /(rojo|amarillo|verde)/;

	var myVar = setInterval(myTimer, 1000);

	function myTimer()
	{
		mesas_orden_listado();
	}

//	Iniciar Funcionalidad
	pubnub.addListener(
	{
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
			//	Actualizar Pagina
				location.reload();
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
				
			/*

			//	Recorrer Mesas
				$( "#mesas > .mesa" ).each(function( index )
				{
				//	Obtener primera Mesa
					if(i == 1)
					{
					//	Otener ID de la primera mesa
						let div				=	$(this).attr('data');

					//	Concatenar ID
						let primeraMesa		=	"#MES" + div;

					//	Cambiar orden de las Mesas
						$("#MES" + mesa_id ).insertBefore( primeraMesa );
					}

				//	Aumentar Listado
					i++;
				});

			*/

			}
		},
		presence: function(presenceEvent)
		{

		}
	});

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

//	Suscribir al Canal PubNub
    pubnub.subscribe(
	{
        channels: ['vav_mesas'],
        withPresence: true
    });
