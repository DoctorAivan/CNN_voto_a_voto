//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	FUNCIONALIDAD PUBNUB SWICH
//	Actualización 
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Obtener Variables de la Mesa
	var swich_mesas				=	0;
	var swich_mesa_1			=	0;
	var swich_mesa_2			=	0;
	var swich_mesa_3			=	0;
	var swich_mesa_4			=	0;
	var swich_votos				=	1;
	
	var template_anterior		=	0;
	
	var animacion_velocidad		=	600;
	
	var objeto_mesas			=	{};

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Iniciar al Cargar
	$(function()
	{
	//	Obtener Mesas Creadas
		swichMesas();
	});

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Iniciar Funcionalidad
	pubnub.addListener({
		message: function(message)
		{
		//	Obtener Nuevo Dato
			datoPubNub			=	message.message;
			
		//	Validar Actualización
			if(datoPubNub == 'refresh')
			{
			//	Actualizar Mesas
				swichMesas();
			
			//	Debug
				console.log( "Actualizar Mesas : " + datoPubNub );
			}
			else
			{
			//	Crear Array
				var objeto				=	datoPubNub.split('|');
				
			//	Accion enviada
				var pubNub_accion		=	objeto[0];
	
			//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
	
			//	Actualizar Votos de una Mesa
				if( pubNub_accion == "V" )
				{
				//	Obtener Variables de la Mesa
					var mesa_id			=	objeto[1];
					var mesa_voto_a		=	objeto[2];
					var mesa_voto_r		=	objeto[3];
					var mesa_voto_cm	=	objeto[4];
					var mesa_voto_cc	=	objeto[5];
					
				//	Asignar valores a la Mesa
					$( "." + mesa_id + " .mesa_voto_a" ).html( '<h2>A</h2><h3>' + mesa_voto_a + '</h3>' );
					$( "." + mesa_id + " .mesa_voto_r" ).html( '<h2>R</h2><h3>' + mesa_voto_r + '</h3>' );
					$( "." + mesa_id + " .mesa_voto_cm" ).html( '<h2>CM</h2><h3>' + mesa_voto_cm + '</h3>' );
					$( "." + mesa_id + " .mesa_voto_cc" ).html( '<h2>CC</h2><h3>' + mesa_voto_cc + '</h3>' );
	
				//	Mostar Funcionalidad de carga
					$("." + mesa_id + " .mesa-votos-cambio" ).fadeIn( 200 , function()
					{
					//	Reiniciar el Largo del contenedor
						$("." + mesa_id + " .mesa-votos-cambio" ).delay( 100 ).fadeOut( 200 );
					});
	
				//	Actualizar Objeto
					objeto_mesas[mesa_id].mesa_voto_a = mesa_voto_a;
					objeto_mesas[mesa_id].mesa_voto_r = mesa_voto_r;
					objeto_mesas[mesa_id].mesa_voto_cm = mesa_voto_cm;
					objeto_mesas[mesa_id].mesa_voto_cc = mesa_voto_cc;
	
				//	Debug
					console.log( "Nuevo Voto : " + datoPubNub );
				//	console.log( objeto_mesas[mesa_id] );
				}
	
			//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
	
			//	Actualizar Cambios en el Swich
				if( pubNub_accion == "S" )
				{
				//	Obtener Variables de la Mesa
					swich_mesas		=	objeto[1];
					swich_mesa_1	=	objeto[2];
					swich_mesa_2	=	objeto[3];
					swich_mesa_3	=	objeto[4];
					swich_mesa_4	=	objeto[5];
					swich_votos		=	objeto[6];
	
				//	Asignar Mesas al Template
					swichAsignarMesas();
	
				//	Debug
					console.log( "Cambio en el Swich : " + datoPubNub );
				}
			}
		}
	});

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Obtener ultimo Dato Almacenado en PubNub
	pubnub.history(
    	{
        	channel: 'vav_mesas',
        	reverse: false,
        	count: 1,
        	stringifiedTimeToken: true
    	},
    	function (status, response)
    	{
		//	Obtener Nuevo Dato
			datoPubNub				=	response.messages[0].entry;

		//	Crear Array
			var objeto				=	datoPubNub.split('|');

		//	Accion enviada
			var pubNub_accion		=	objeto[0];

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Actualizar Votos de una Mesa
			if( pubNub_accion == "V" )
			{

			}

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Actualizar Cambios en el Swich
			if( pubNub_accion == "S" )
			{
			//	Obtener Variables de la Mesa
				swich_mesas		=	objeto[1];
				swich_mesa_1	=	objeto[2];
				swich_mesa_2	=	objeto[3];
				swich_mesa_3	=	objeto[4];
				swich_mesa_4	=	objeto[5];
				swich_votos		=	objeto[6];
				
			//	Asignar Mesas al Template
				swichAsignarMesas();
			}
		}
	);

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Suscribirse al Canal
    pubnub.subscribe({
        channels: ['vav_mesas'],
        withPresence: true
    });

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Obtener Mesas Creadas
	function swichMesas()
	{
	//	Obtener Json
		$.getJSON( path_app + '/swich/mesas/' , function( data )
		{			
		//	Guardar Mesas
			objeto_mesas	=	data;
		});
	}
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Asignar la imformación de las Mesas
	function swichAsignarMesas()
	{
	//	Validar Array 1
		if( objeto_mesas[ swich_mesa_1 ] )
		{
		//	Obtener Variables
		var mesa_id			=	objeto_mesas[ swich_mesa_1 ].mesa_id;
		var mesa_nombre		=	objeto_mesas[ swich_mesa_1 ].mesa_nombre;
		var mesa_numero		=	objeto_mesas[ swich_mesa_1 ].mesa_numero;
		var mesa_voto_a		=	objeto_mesas[ swich_mesa_1 ].mesa_voto_a;
		var mesa_voto_r		=	objeto_mesas[ swich_mesa_1 ].mesa_voto_r;
		var mesa_voto_cm	=	objeto_mesas[ swich_mesa_1 ].mesa_voto_cm;
		var mesa_voto_cc	=	objeto_mesas[ swich_mesa_1 ].mesa_voto_cc;
	
		//	Construir Contenedor
		var mesa1	=	'<div class="mesa ' + mesa_id + '">';
			mesa1	+=	'	<div class="mesa-info">';
			mesa1	+=	'		<div class="mesa_nombre">' + mesa_nombre + '</div>';
			mesa1	+=	'		<div class="mesa_numero">' + mesa_numero + '</div>';
			mesa1	+=	'	</div>';
			mesa1	+=	'	<div class="mesa-votos">';
			mesa1	+=	'		<div class="mesa-votos-cambio"></div>';
			mesa1	+=	'		<div class="mesa-votos-p">';
			mesa1	+=	'			<div class="mesa_voto_a"><h2>A</h2><h3>' + mesa_voto_a + '</h3></div>';
			mesa1	+=	'			<div class="mesa_voto_r"><h2>R</h2><h3>' + mesa_voto_r + '</h3></div>';
			mesa1	+=	'		</div>';
			mesa1	+=	'		<div class="mesa-votos-c">';
			mesa1	+=	'			<div class="mesa_voto_cm"><h2>CM</h2><h3>' + mesa_voto_cm + '</h3></div>';
			mesa1	+=	'			<div class="mesa_voto_cc"><h2>CC</h2><h3>' + mesa_voto_cc + '</h3></div>';
			mesa1	+=	'		</div>';
			mesa1	+=	'	</div>';
			mesa1	+=	'</div>';
			
			console.log( swich_mesa_1 + " - " + mesa_id );
			
			if( swich_mesa_1 == mesa_id )
			{
			//	Generar Mesa
				$(".mesa-1").html( mesa1 );
			}
			else
			{
			//	Vaciar Mesa
				$(".mesa-1").html( "" );
			}
			
		}
		else
		{
		//	Vaciar Mesa
			$(".mesa-1").html( "" );
		}
		
	//		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Validar Array 2
		if( objeto_mesas[ swich_mesa_2 ] )
		{
		//	Obtener Variables
		var mesa_id			=	objeto_mesas[ swich_mesa_2 ].mesa_id;
		var mesa_nombre		=	objeto_mesas[ swich_mesa_2 ].mesa_nombre;
		var mesa_numero		=	objeto_mesas[ swich_mesa_2 ].mesa_numero;
		var mesa_voto_a		=	objeto_mesas[ swich_mesa_2 ].mesa_voto_a;
		var mesa_voto_r		=	objeto_mesas[ swich_mesa_2 ].mesa_voto_r;
		var mesa_voto_cm	=	objeto_mesas[ swich_mesa_2 ].mesa_voto_cm;
		var mesa_voto_cc	=	objeto_mesas[ swich_mesa_2 ].mesa_voto_cc;
	
		//	Construir Contenedor
		var mesa2	=	'<div class="mesa ' + mesa_id + '">';
			mesa2	+=	'	<div class="mesa-info">';
			mesa2	+=	'		<div class="mesa_nombre">' + mesa_nombre + '</div>';
			mesa2	+=	'		<div class="mesa_numero">' + mesa_numero + '</div>';
			mesa2	+=	'	</div>';
			mesa2	+=	'	<div class="mesa-votos">';
			mesa2	+=	'		<div class="mesa-votos-cambio"></div>';
			mesa2	+=	'		<div class="mesa-votos-p">';
			mesa2	+=	'			<div class="mesa_voto_a"><h2>A</h2><h3>' + mesa_voto_a + '</h3></div>';
			mesa2	+=	'			<div class="mesa_voto_r"><h2>R</h2><h3>' + mesa_voto_r + '</h3></div>';
			mesa2	+=	'		</div>';
			mesa2	+=	'		<div class="mesa-votos-c">';
			mesa2	+=	'			<div class="mesa_voto_cm"><h2>CM</h2><h3>' + mesa_voto_cm + '</h3></div>';
			mesa2	+=	'			<div class="mesa_voto_cc"><h2>CC</h2><h3>' + mesa_voto_cc + '</h3></div>';
			mesa2	+=	'		</div>';
			mesa2	+=	'	</div>';
			mesa2	+=	'</div>';
			
		//	Generar Mesa
			$(".mesa-2").html( mesa2 );
		}
		else
		{
		//	Vaciar Mesa
			$(".mesa-2").html( "" );
		}
		
	//		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Validar Array 3
		if( objeto_mesas[ swich_mesa_3 ] )
		{
		//	Obtener Variables
		var mesa_id			=	objeto_mesas[ swich_mesa_3 ].mesa_id;
		var mesa_nombre		=	objeto_mesas[ swich_mesa_3 ].mesa_nombre;
		var mesa_numero		=	objeto_mesas[ swich_mesa_3 ].mesa_numero;
		var mesa_voto_a		=	objeto_mesas[ swich_mesa_3 ].mesa_voto_a;
		var mesa_voto_r		=	objeto_mesas[ swich_mesa_3 ].mesa_voto_r;
		var mesa_voto_cm	=	objeto_mesas[ swich_mesa_3 ].mesa_voto_cm;
		var mesa_voto_cc	=	objeto_mesas[ swich_mesa_3 ].mesa_voto_cc;
	
		//	Construir Contenedor
		var mesa3	=	'<div class="mesa ' + mesa_id + '">';
			mesa3	+=	'	<div class="mesa-info">';
			mesa3	+=	'		<div class="mesa_nombre">' + mesa_nombre + '</div>';
			mesa3	+=	'		<div class="mesa_numero">' + mesa_numero + '</div>';
			mesa3	+=	'	</div>';
			mesa3	+=	'	<div class="mesa-votos">';
			mesa3	+=	'		<div class="mesa-votos-cambio"></div>';
			mesa3	+=	'		<div class="mesa-votos-p">';
			mesa3	+=	'			<div class="mesa_voto_a"><h2>A</h2><h3>' + mesa_voto_a + '</h3></div>';
			mesa3	+=	'			<div class="mesa_voto_r"><h2>R</h2><h3>' + mesa_voto_r + '</h3></div>';
			mesa3	+=	'		</div>';
			mesa3	+=	'		<div class="mesa-votos-c">';
			mesa3	+=	'			<div class="mesa_voto_cm"><h2>CM</h2><h3>' + mesa_voto_cm + '</h3></div>';
			mesa3	+=	'			<div class="mesa_voto_cc"><h2>CC</h2><h3>' + mesa_voto_cc + '</h3></div>';
			mesa3	+=	'		</div>';
			mesa3	+=	'	</div>';
			mesa3	+=	'</div>';
			
		//	Generar Mesa
			$(".mesa-3").html( mesa3 );
		}
		else
		{
		//	Vaciar Mesa
			$(".mesa-3").html( "" );
		}
		
	//		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Validar Array 4
		if( objeto_mesas[ swich_mesa_4 ] )
		{
		//	Obtener Variables
		var mesa_id			=	objeto_mesas[ swich_mesa_4 ].mesa_id;
		var mesa_nombre		=	objeto_mesas[ swich_mesa_4 ].mesa_nombre;
		var mesa_numero		=	objeto_mesas[ swich_mesa_4 ].mesa_numero;
		var mesa_voto_a		=	objeto_mesas[ swich_mesa_4 ].mesa_voto_a;
		var mesa_voto_r		=	objeto_mesas[ swich_mesa_4 ].mesa_voto_r;
		var mesa_voto_cm	=	objeto_mesas[ swich_mesa_4 ].mesa_voto_cm;
		var mesa_voto_cc	=	objeto_mesas[ swich_mesa_4 ].mesa_voto_cc;
	
		//	Construir Contenedor
		var mesa4	=	'<div class="mesa ' + mesa_id + '">';
			mesa4	+=	'	<div class="mesa-info">';
			mesa4	+=	'		<div class="mesa_nombre">' + mesa_nombre + '</div>';
			mesa4	+=	'		<div class="mesa_numero">' + mesa_numero + '</div>';
			mesa4	+=	'	</div>';
			mesa4	+=	'	<div class="mesa-votos">';
			mesa4	+=	'		<div class="mesa-votos-cambio"></div>';
			mesa4	+=	'		<div class="mesa-votos-p">';
			mesa4	+=	'			<div class="mesa_voto_a"><h2>A</h2><h3>' + mesa_voto_a + '</h3></div>';
			mesa4	+=	'			<div class="mesa_voto_r"><h2>R</h2><h3>' + mesa_voto_r + '</h3></div>';
			mesa4	+=	'		</div>';
			mesa4	+=	'		<div class="mesa-votos-c">';
			mesa4	+=	'			<div class="mesa_voto_cm"><h2>CM</h2><h3>' + mesa_voto_cm + '</h3></div>';
			mesa4	+=	'			<div class="mesa_voto_cc"><h2>CC</h2><h3>' + mesa_voto_cc + '</h3></div>';
			mesa4	+=	'		</div>';
			mesa4	+=	'	</div>';
			mesa4	+=	'</div>';
			
		//	Generar Mesa
			$(".mesa-4").html( mesa4 );
		}
		else
		{
		//	Vaciar Mesa
			$(".mesa-4").html( "" );
		}
		
	//	Cambiar Template
		swichTemplate( swich_mesas );
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Validar Template y mesas Seleccionado
	function swichTemplate( template )
	{
	//	Validar Templeate Actual
		if( template != template_anterior )
		{			
		//	Ocultar todos los Template
			$("#swich-template-" + template_anterior ).fadeOut( animacion_velocidad , function()
			{
			//	Reiniciar el Largo del contenedor
				$("#swich-template-" + template ).fadeIn( animacion_velocidad );
			});
	
			//	Almacenar Template Actual
			template_anterior		=	template;
		}

		if( swich_votos == "1" )
		{
			$(".mesa-votos-p").css("display","block");
			$(".mesa-votos-c").css("display","none");
		}
		else
		{
			$(".mesa-votos-p").css("display","none");
			$(".mesa-votos-c").css("display","block");
		}
	}
