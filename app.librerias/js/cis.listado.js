
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	FUNCIONES DE LOS LISTADOS
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	ID del Objeto
	var objeto_id		=	0;

//	Tipo del Objeto
	var objeto_tipo		=	"";

//	ID de la Mesa
	var mesa_id			=	0;

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Iniciar al Cargar
	$(function()
	{
	//	Obtener Valor Guardado
		var mesa_votos	=	$.cookie('vav_mesas_votos');

	//	Mostrar tipo de Votos
		mostrarVotos( mesa_votos );
	});

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Funcionalidad para cambiar el Estado del Objeto
	function objetoEstado( id , tipo )
	{
	//	ID del Objeto
		var objeto_id		=	id;

	//	Tipo de Objeto		
		var objeto_tipo		=	tipo;

	//	Funcionalidad Cargando
		$( "#" + objeto_id ).removeClass( "estado-0" ).removeClass( "estado-1" ).addClass( "enviando" );
		$( "#" + objeto_id ).append('<article id="objeto-estado-cargando"><i class="fas fa-spinner"></i></article>');
		
	//	Enviar Petición
		$.post( path_app + "/objeto/estado/",
		{
			objeto_id		:	objeto_id,
			objeto_tipo		:	objeto_tipo
		})
		.done(function( estado )
		{
		//	Eliminar Funcionalidad Cargando
			$( "#objeto-estado-cargando" ).remove();

		//	Cambiar Opción de Estado
			if( estado == 1 )
			{
				$( "#" + objeto_id ).removeClass( "enviando" ).removeClass( "estado-0" ).addClass( "estado-1" );
			}
			else
			{
				$( "#" + objeto_id ).removeClass( "enviando" ).removeClass( "estado-1" ).addClass( "estado-0" );
			}
			
		//	Enviar Notificación a PubNub
			enviarPubNub( 'refresh' );
		});
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Eliminar un Objeto
	function objetoEliminar( id , tipo )
	{
	//	Almacenar el ID del Objeto
		objeto_id		=	id;
		
	//	Almacenar el Tipo de Objeto
		objeto_tipo		=	tipo;
		
	//	Abrir Funcionalidad Livebox
		liveboxAbrir('objeto-eliminar');
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Eliminar un Objeto Confirmación	
	function objetoEliminarConfirmar()
	{
	//	Mostrar Usabilidad Cargando
		liveboxCargando();
		
	//	URL para el envio de Datos
		var post	=	"";
		
	//	Usuarios Eliminar
		if( objeto_tipo == "USU" )
		{
			post	=	path_app + "/usuarios/eliminar/";	
		}
		
	//	Mesas Eliminar
		if( objeto_tipo == "MES" )
		{
			post	=	path_app + "/mesas/eliminar/";	
		}

	//		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Enviar Petición
		$.post( post ,
		{
			objeto_id		:	objeto_id
		})
		.done(function( estado )
		{
		//	Cerrar Livebox
			liveboxCerrar();
			
		//	Cerrar Livebox
			liveboxCargandoCompleto();
			
		//	Eliminar Div
			$( "#" + objeto_tipo + objeto_id ).remove();
			
		//	Enviar Notificación a PubNub
			enviarPubNub( 'refresh' );
		});
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Seleccionar que votos Mostrar
	function mostrarVotos( opcion )
	{
	//	Almacenar Opcion en Cookie
		$.cookie('vav_mesas_votos', opcion , { expires: 7, path: '/' });
		
	//	Espacio MÃ³vil
		if( opcion == 1 )
		{
			$(".votos-plebiscito").css("display","block");
			$(".votos-comision").css("display","block");
			
			$("#opcion-voto-1").removeClass("nuevo").addClass("activo");
			$("#opcion-voto-2").removeClass("activo").addClass("nuevo");
			$("#opcion-voto-3").removeClass("activo").addClass("nuevo");
			$("#opcion-voto-4").removeClass("activo").addClass("nuevo");
		}

	//	Espacio MÃ³vil
		if( opcion == 2 )
		{
			$(".votos-plebiscito").css("display","none");
			$(".votos-comision").css("display","none");
			
			$("#opcion-voto-1").removeClass("activo").addClass("nuevo");
			$("#opcion-voto-2").removeClass("nuevo").addClass("activo");
			$("#opcion-voto-3").removeClass("activo").addClass("nuevo");
			$("#opcion-voto-4").removeClass("activo").addClass("nuevo");
		}

	//	Espacio MÃ³vil
		if( opcion == 3 )
		{
			$(".votos-plebiscito").css("display","block");
			$(".votos-comision").css("display","none");
			
			$("#opcion-voto-1").removeClass("activo").addClass("nuevo");
			$("#opcion-voto-2").removeClass("activo").addClass("nuevo");
			$("#opcion-voto-3").removeClass("nuevo").addClass("activo");
			$("#opcion-voto-4").removeClass("activo").addClass("nuevo");
		}

	//	Espacio MÃ³vil
		if( opcion == 4 )
		{
			$(".votos-plebiscito").css("display","none");
			$(".votos-comision").css("display","block");
			
			$("#opcion-voto-1").removeClass("activo").addClass("nuevo");
			$("#opcion-voto-2").removeClass("activo").addClass("nuevo");
			$("#opcion-voto-3").removeClass("activo").addClass("nuevo");
			$("#opcion-voto-4").removeClass("nuevo").addClass("activo");
		}
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Nueva Mesa
	function nuevaMesa()
	{
	//	Solicitar Nuevo ID
		$.getJSON( path_app + '/mesas/nueva/' , function( id )
		{
		//	Completar Información
			editarMesa( id );
			
		//	Obtener el Nombre de Usuario
			let mesa_usuario	=	$('.listado-opciones-actual').text();

		//	Construir nuevo Div
			var box	=	'<article class="mesa bg-blanco box-shadow bordes-radius gris" id="MES' + id + '" data="' + id + '">';
				box	+=	'	<div class="opciones bordes-radius box-shadow-light">';
				box	+=	'		<i class="fas fa-highlighter tipsy-top" title="<h2>Modificar Mesa</h2><p>Podrás modificar la información de la Mesa y los Votos asociados.</p>" onclick="editarMesa( ' + id + ' );"></i>';
				box	+=	'		<i class="fas fa-copy tipsy-top" title="<h2>Duplicar Mesa</h2><p>Podrás duplicar la información de la Mesa y los Votos asociados.</p>" onclick="duplicarMesa( ' + id + ' );"></i>';
				box	+=	'		<i class="fas fa-trash-alt tipsy-top"  title="<h2>Eliminar Mesa</h2><p>La Mesa será eliminada junto a toda la información relacionada.</p>" onclick="objetoEliminar( ' + id + ' , ' + "'MES'" + ' );"></i>';
				box	+=	'	</div>';
				box	+=	'	<header>';
				box +=	'		<div onclick="mesaDestacada( ' + id + ' );" class="estado estado-0 box-shadow-light" id="' + id + '"><div></div></div>';
				box	+=	'		<h2><i class="fas fa-passport"></i> ' + id + '</h2>';
				box +=	'		<h1 class="line-1" id="' + id + '_mesa_usuario"><i class="fas fa-user"></i> ' + mesa_usuario + '</h1>';
				box	+=	'		<h3 class="line-1" id="' + id + '_mesa_nombre"></h3>';
				box	+=	'		<h4 class="line-1" id="' + id + '_mesa_numero"></h3>';
				box	+=	'		<h5 class="line-1" id="' + id + '_mesa_ciudad"><i class="fas fa-globe-americas"></i></h3>';
				box	+=	'		<h6 class="line-1" id="' + id + '_mesa_cambio"><i class="fas fa-clock"></i> Cambios : Hace menos de un minuto</h2>';
				box	+=	'	</header>';
				box	+=	'	<footer class="votos-plebiscito">';
				box	+=	'		<article>';
				box	+=	'			<h2><i class="far fa-thumbs-up"></i> Apruebo</h2>';
				box	+=	'			<h3 id="' + id + '_mesa_voto_a">0</h3>';
				box	+=	'		</article>';
				box	+=	'		<article>';
				box	+=	'			<h2><i class="far fa-thumbs-down"></i> Rechazo</h2>';
				box	+=	'			<h3 id="' + id + '_mesa_voto_r">0</h3>';
				box	+=	'		</article>';
				box	+=	'	</footer>';
				box	+=	'	<footer class="votos-comision">';
				box	+=	'		<article>';
				box	+=	'			<h2>Comisión C.</h2>';
				box	+=	'			<h3 id="' + id + '_mesa_voto_cc">0</h3>';
				box	+=	'		</article>';
				box	+=	'		<article>';
				box	+=	'			<h2>Comisión M.</h2>';
				box	+=	'			<h3 id="' + id + '_mesa_voto_cm">0</h3>';
				box	+=	'		</article>';
				box	+=	'	</footer>';
				box	+=	'</article>';

		//	Agregar Nueva Mesa
			$("#mesas").append( box );

		//	Almacenar Opcion en Cookie
			var ver_mesa	=	$.cookie('vav_mesas_votos');
			
		//	Marcar Opcion de Votos guardados
			mostrarVotos( ver_mesa );
		});
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Editar Mesa
	function editarMesa( id )
	{
	//	Obtener Información de la Mesa
		$.getJSON( path_app + '/mesas/datos/' + id , function( data )
		{
		//	Marcar Dueño de la mesa
			marcarListadoOpcion( 'usuario_id' , data.usuario_id )

		//	Marcar Estado de la Mesa
			marcarOpcion( 'mesa_estado' , data.mesa_estado );

		//	Abrir Livebox
			abrirLivebox('mesa-editar');

		//	Asignar ID de la Mesa
			$(".livebox-id").html( '<span>' + id + '</span>' );

		//	Obtener Información de la Mesa
			$("#mesa_nombre").val( data.mesa_nombre );
			$("#mesa_numero").val( data.mesa_numero );
			$("#mesa_region").val( data.mesa_region );
			$("#mesa_ciudad").val( data.mesa_ciudad );

		//	Asignar Votos Constitución
			$("#mesa_voto_a").val( data.mesa_voto_a );
			$("#mesa_voto_r").val( data.mesa_voto_r );
			
			$("#mesa_voto_ar_blanco").val( data.mesa_voto_ar_blanco );
			$("#mesa_voto_ar_nulo").val( data.mesa_voto_ar_nulo );

		//	Asignar Votos Comisión			
			$("#mesa_voto_cm").val( data.mesa_voto_cm );
			$("#mesa_voto_cc").val( data.mesa_voto_cc );
			
			$("#mesa_voto_cmcc_blanco").val( data.mesa_voto_cmcc_blanco );
			$("#mesa_voto_cmcc_nulo").val( data.mesa_voto_cmcc_nulo );
			
		//	Calcular Total de Votos
			calcularTotales();
			
		//	Guardar ID de la Mesa
			mesa_id	= id;
		});
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Editar Mesa Confirmación
	function editarMesaConfirmar()
	{
	//	Mostrar Usabilidad Cargando
		cargandoLivebox();

	//		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Obtener dueño de la Mesa
		let usuario_id				=	$("#usuario_id").val();

	//	Estado de la Mesa
		let mesa_estado				=	$("#mesa_estado").val();

	//	Obtener Información de la Mesa
		let mesa_nombre				=	$("#mesa_nombre").val();
		let mesa_numero				=	$("#mesa_numero").val();
		let mesa_region				=	$("#mesa_region").val();
		let mesa_ciudad				=	$("#mesa_ciudad").val();
		
	//	Votos Constitución Politica
		let mesa_voto_a				=	$("#mesa_voto_a").val();
		let mesa_voto_r				=	$("#mesa_voto_r").val();
		let mesa_voto_ar_blanco		=	$("#mesa_voto_ar_blanco").val();
		let mesa_voto_ar_nulo		=	$("#mesa_voto_ar_nulo").val();
		
	//	Votos Tipo de Organo
		let mesa_voto_cm			=	$("#mesa_voto_cm").val();
		let mesa_voto_cc			=	$("#mesa_voto_cc").val();
		let mesa_voto_cmcc_blanco	=	$("#mesa_voto_cmcc_blanco").val();
		let mesa_voto_cmcc_nulo		=	$("#mesa_voto_cmcc_nulo").val();

	//	Actualizar los votos de la Mesa
		$.post( path_app + '/mesas/editar/guardar/' ,
		{
			mesa_id					:	mesa_id,
			usuario_id				:	usuario_id,
			mesa_estado				:	mesa_estado,
			mesa_nombre				:	mesa_nombre,
			mesa_numero				:	mesa_numero,
			mesa_region				:	mesa_region,
			mesa_ciudad				:	mesa_ciudad,
			mesa_voto_a				:	mesa_voto_a,
			mesa_voto_r				:	mesa_voto_r,
			mesa_voto_ar_blanco		:	mesa_voto_ar_blanco,
			mesa_voto_ar_nulo		:	mesa_voto_ar_nulo,
			mesa_voto_cm			:	mesa_voto_cm,
			mesa_voto_cc			:	mesa_voto_cc,
			mesa_voto_cmcc_blanco	:	mesa_voto_cmcc_blanco,
			mesa_voto_cmcc_nulo		:	mesa_voto_cmcc_nulo
		})
		.done(function( data )
		{
		//	Cerrar Livebox
			cargandoLiveboxCompleto();
	
			$( "#MES" + mesa_id ).removeClass( 'estado-0' ).removeClass( 'estado-1' ).removeClass( 'estado-2' ).addClass( 'estado-' + mesa_estado );

		//	Obtener el Nombre de Usuario
			let mesa_usuario	=	$('.listado-opciones-actual').text();

		//	Actualizar valor en el Listado
			$( "#" + mesa_id + "_mesa_nombre" ).html( mesa_nombre );
			$( "#" + mesa_id + "_mesa_usuario" ).html( '<i class="fas fa-user"></i> ' + mesa_usuario );
			$( "#" + mesa_id + "_mesa_numero" ).html( mesa_numero );
			$( "#" + mesa_id + "_mesa_ciudad" ).html( '<i class="fas fa-globe-americas"></i> ' + mesa_ciudad );
			
			$( "#" + mesa_id + "_mesa_voto_a" ).html( mesa_voto_a );
			$( "#" + mesa_id + "_mesa_voto_r" ).html( mesa_voto_r );
			$( "#" + mesa_id + "_mesa_voto_cm" ).html( mesa_voto_cm );
			$( "#" + mesa_id + "_mesa_voto_cc" ).html( mesa_voto_cc );
			
		//	Enviar Notificación a PubNub
			enviarPubNub( 'refresh' );
		});
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Duplicar Mesa
	function duplicarMesa( id )
	{
	//	Almacenar ID de la Mesa
		mesa_id		=	id;

	//	Abrir Livebox de confirmación
		abrirLivebox('mesa-duplicar');
	}

//	Duplicar Mesa Confirmar
	function duplicarMesaConfirmar( )
	{
	//	Información de la Mesa
		var objeto_mesa;

	//	Obtener Información de la Mesa
		$.getJSON( path_app + '/mesas/datos/' + mesa_id , function( data )
		{
		//	Almacenar la Información de la Mesa
			objeto_mesa 	=	data;

			//	Solicitar Nuevo ID
			$.getJSON( path_app + '/mesas/nueva/' , function( id )
			{
			//	Guardar ID de la Mesa
				mesa_id		=	id;

			//	Actualizar los votos de la Mesa
				$.post( path_app + '/mesas/editar/guardar/' ,
				{
					mesa_id					:	id,
					usuario_id				:	objeto_mesa.usuario_id,
					mesa_estado				:	0,
					mesa_nombre				:	objeto_mesa.mesa_nombre,
					mesa_numero				:	objeto_mesa.mesa_numero,
					mesa_region				:	objeto_mesa.mesa_region,
					mesa_ciudad				:	objeto_mesa.mesa_ciudad,
					mesa_voto_a				:	0,
					mesa_voto_r				:	0,
					mesa_voto_ar_blanco		:	0,
					mesa_voto_ar_nulo		:	0,
					mesa_voto_cm			:	0,
					mesa_voto_cc			:	0,
					mesa_voto_cmcc_blanco	:	0,
					mesa_voto_cmcc_nulo		:	0
				})
				.done(function( data )
				{
				//	Marcar Dueño de la mesa
					marcarListadoOpcion( 'usuario_id' , objeto_mesa.usuario_id )

				//	Marcar Estado de la Mesa
					marcarOpcion( 'mesa_estado' , 0 );

				//	Asignar ID de la Mesa
					$(".livebox-id").html( '<span>' + mesa_id + '</span>' );

				//	Obtener Información de la Mesa
					$("#mesa_nombre").val( objeto_mesa.mesa_nombre );
					$("#mesa_numero").val( 'Mesa ' );
					$("#mesa_region").val( objeto_mesa.mesa_region );
					$("#mesa_ciudad").val( objeto_mesa.mesa_ciudad );

				//	Asignar Votos Constitución
					$("#mesa_voto_a").val( 0 );
					$("#mesa_voto_r").val( 0 );
					$("#mesa_voto_ar_blanco").val( 0 );
					$("#mesa_voto_ar_nulo").val( 0 );

				//	Asignar Votos Comisión			
					$("#mesa_voto_cm").val( 0 );
					$("#mesa_voto_cc").val( 0 );
					$("#mesa_voto_cmcc_blanco").val( 0 );
					$("#mesa_voto_cmcc_nulo").val( 0 );
					
				//	Calcular Total de Votos
					calcularTotales();

				//	Abrir Livebox
					abrirLivebox('mesa-editar');

				//	Seleccionar Input al Abrir
					$("#mesa_numero").focus();

				//	Enviar Notificación a PubNub
					enviarPubNub( 'refresh' );

				//	-		-		-		-		-		-		-		-		-		-		-		-		-		-
				//	Crear Objeto en el listado

				//	Obtener el Nombre de Usuario
					let mesa_usuario	=	$('.listado-opciones-actual').text();

				//	Construir nuevo Div
					let box	=	'<article class="mesa bg-blanco box-shadow bordes-radius gris" id="MES' + mesa_id + '" data="' + mesa_id + '">';
					box	+=	'	<div class="opciones bordes-radius box-shadow-light">';
					box	+=	'		<i class="fas fa-highlighter tipsy-top" title="<h2>Modificar Mesa</h2><p>Podrás modificar la información de la Mesa y los Votos asociados.</p>" onclick="editarMesa( ' + mesa_id + ' );"></i>';
					box	+=	'		<i class="fas fa-copy tipsy-top" title="<h2>Duplicar Mesa</h2><p>Podrás duplicar la información de la Mesa y los Votos asociados.</p>" onclick="duplicarMesa( ' + mesa_id + ' );"></i>';
					box	+=	'		<i class="fas fa-trash-alt tipsy-top"  title="<h2>Eliminar Mesa</h2><p>La Mesa será eliminada junto a toda la información relacionada.</p>" onclick="objetoEliminar( ' + mesa_id + ' , ' + "'MES'" + ' );"></i>';
					box	+=	'	</div>';
					box	+=	'	<header>';
					box +=	'		<div onclick="mesaDestacada( ' + mesa_id + ' );" class="estado estado-0 box-shadow-light" id="' + mesa_id + '"><div></div></div>';
					box	+=	'		<h2><i class="fas fa-passport"></i> ' + mesa_id + '</h2>';
					box +=	'		<h1 class="line-1" id="' + mesa_id + '_mesa_usuario"><i class="fas fa-user"></i> ' + mesa_usuario + '</h1>';
					box	+=	'		<h3 class="line-1" id="' + mesa_id + '_mesa_nombre">' + objeto_mesa.mesa_nombre + '</h3>';
					box	+=	'		<h4 class="line-1" id="' + mesa_id + '_mesa_numero">Mesa </h3>';
					box	+=	'		<h5 class="line-1" id="' + mesa_id + '_mesa_ciudad"><i class="fas fa-globe-americas"></i> ' + objeto_mesa.mesa_ciudad + '</h3>';
					box	+=	'		<h6 class="line-1" id="' + mesa_id + '_mesa_cambio"><i class="fas fa-clock"></i> Cambios : Hace menos de un minuto</h2>';
					box	+=	'	</header>';
					box	+=	'	<footer class="votos-plebiscito">';
					box	+=	'		<article>';
					box	+=	'			<h2><i class="far fa-thumbs-up"></i> Apruebo</h2>';
					box	+=	'			<h3 id="' + mesa_id + '_mesa_voto_a">' + objeto_mesa.mesa_voto_a + '</h3>';
					box	+=	'		</article>';
					box	+=	'		<article>';
					box	+=	'			<h2><i class="far fa-thumbs-down"></i> Rechazo</h2>';
					box	+=	'			<h3 id="' + mesa_id + '_mesa_voto_r">' + objeto_mesa.mesa_voto_r + '</h3>';
					box	+=	'		</article>';
					box	+=	'	</footer>';
					box	+=	'	<footer class="votos-comision">';
					box	+=	'		<article>';
					box	+=	'			<h2>Comisión C.</h2>';
					box	+=	'			<h3 id="' + mesa_id + '_mesa_voto_cc">' + objeto_mesa.mesa_voto_cc + '</h3>';
					box	+=	'		</article>';
					box	+=	'		<article>';
					box	+=	'			<h2>Comisión M.</h2>';
					box	+=	'			<h3 id="' + mesa_id + '_mesa_voto_cm">' + objeto_mesa.mesa_voto_cm + '</h3>';
					box	+=	'		</article>';
					box	+=	'	</footer>';
					box	+=	'</article>';

					//	Agregar Nueva Mesa
					$("#mesas").prepend( box );

					//	Almacenar Opcion en Cookie
					let ver_mesa	=	$.cookie('vav_mesas_votos');

					//	Marcar Opcion de Votos guardados
					mostrarVotos( ver_mesa );

					//	Reiniciar Tipsy
					$('.tipsy-top').tipsy({gravity: "s" , title: function() { return this.getAttribute('original-title'); } });
				});
			});
		});
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Funcionalidad para cambiar el Estado del Objeto
	function mesaDestacada( id )
	{
	//	ID del Objeto
		var objeto_id		=	id;

	//	Funcionalidad Cargando
		$( "#" + objeto_id ).removeClass( "estado-0" ).removeClass( "estado-1" ).addClass( "enviando" );
		$( "#" + objeto_id ).append('<article id="objeto-estado-cargando"><i class="fas fa-spinner"></i></article>');
		
	//	Enviar Petición
		$.post( path_app + "/mesas/destacada/",
		{
			mesa_id			:	id
		})
		.done(function( estado )
		{
		//	Eliminar Funcionalidad Cargando
			$( "#objeto-estado-cargando" ).remove();

		//	Cambiar Opción de Estado
			if( estado == 1 )
			{
				$( "#" + objeto_id ).removeClass( "enviando" ).removeClass( "estado-0" ).addClass( "estado-1" );
			}
			else
			{
				$( "#" + objeto_id ).removeClass( "enviando" ).removeClass( "estado-1" ).addClass( "estado-0" );
			}
			
        //	Construir Variable para enviar a PubNub
            let pubnub       	=
            {
                'accion'		:	'recargar'
            }

        //	Enviar Notificación a PubNub
            enviarPubNub( pubnub );
		});
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Calcular Votos
	function votos( objeto , accion )
	{
	//	Obtener Votos Actuales
		var valor	=	Number( $( "#" + objeto ).val() );

	//	Sumar Votos
		if( accion == "sumar" )
		{
			if( valor == 999 )
			{
				var resultado	=	valor;
			}
			else
			{
				var resultado	=	valor + 1;
			}
		}
		
	//	Restar Votos
		if( accion == "restar" )
		{
			if( valor == 0 )
			{
				var resultado	=	valor;
			}
			else
			{
				var resultado	=	valor - 1;
			}
		}
		
	//	Actualizar valor en el Input
		$( "#" + objeto ).val( resultado );
		
	//	Actualizar valor en el Listado
		$( "#" + mesa_id + "_" + objeto ).html( resultado );
		
	//	Votos Constitución Politica
		var mesa_voto_a				=	$("#mesa_voto_a").val();
		var mesa_voto_r				=	$("#mesa_voto_r").val();
		var mesa_voto_cm			=	$("#mesa_voto_cm").val();
		var mesa_voto_cc			=	$("#mesa_voto_cc").val();
		
	//	Construir Variable para enviar a PubNub
		var pubnub					=	"V" + "|" + mesa_id + "|" + mesa_voto_a + "|" + mesa_voto_r + "|" + mesa_voto_cm + "|" + mesa_voto_cc + "|D";
		
	//	Enviar Notificación a PubNub
		enviarPubNub( pubnub );
		
	//	Actualizar Votos de la Mesa
		votosGuardar();
		
	//	Calcular Total de Votos
		calcularTotales();
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Actualizar Votos de la Mesa
	function votosGuardar()
	{
	//	Mostrar Usabilidad Cargando
		cargandoLivebox();

	//		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Obtener los valores
		var mesa_voto_a		=	$("#mesa_voto_a").val();
		var mesa_voto_r		=	$("#mesa_voto_r").val();
		var mesa_voto_cm	=	$("#mesa_voto_cm").val();
		var mesa_voto_cc	=	$("#mesa_voto_cc").val();

	//	Actualizar los votos de la Mesa
		$.post( path_app + '/mesas/votos/' ,
		{
			mesa_id			:	mesa_id,
			mesa_voto_a		:	mesa_voto_a,
			mesa_voto_r		:	mesa_voto_r,
			mesa_voto_cm	:	mesa_voto_cm,
			mesa_voto_cc	:	mesa_voto_cc
		})
		.done(function( data )
		{
		//	Cerrar Livebox
			cargandoLiveboxCompleto();
		});
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Calcular Total de Votos
	function calcularTotales()
	{
	//	Obtener Votos Constitución
		var mesa_voto_a				=	Number( $("#mesa_voto_a").val() );
		var mesa_voto_r				=	Number( $("#mesa_voto_r").val() );
		
		var mesa_voto_ar_blanco		=	Number( $("#mesa_voto_ar_blanco").val() );
		var mesa_voto_ar_nulo		=	Number( $("#mesa_voto_ar_nulo").val() );

	//	Obtener Votos Comisión			
		var mesa_voto_cm			=	Number( $("#mesa_voto_cm").val() );
		var mesa_voto_cc			=	Number( $("#mesa_voto_cc").val() );
		
		var mesa_voto_cmcc_blanco	=	Number( $("#mesa_voto_cmcc_blanco").val() );
		var mesa_voto_cmcc_nulo		=	Number( $("#mesa_voto_cmcc_nulo").val() );

	//	Calcular Totales
		var mesa_voto_ar_total		=	( mesa_voto_a + mesa_voto_r + mesa_voto_ar_blanco + mesa_voto_ar_nulo );
		var mesa_voto_cmcc_total	=	( mesa_voto_cm + mesa_voto_cc + mesa_voto_cmcc_blanco + mesa_voto_cmcc_nulo );

	//	Asignar Totales
		$("#mesa_voto_ar_total").val( mesa_voto_ar_total );
		$("#mesa_voto_cmcc_total").val( mesa_voto_cmcc_total );
	}
