//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	FUNCIONALIDAD PUBNUB SWICH
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Obtener Variables de la Mesa
	var swich_mesas						=	0;
	var swich_modo						=	0;
	var swich_mesa_1					=	0;
	var swich_mesa_2					=	0;
	var swich_mesa_3					=	0;
	var swich_mesa_4					=	0;
	var swich_votos						=	0;
	var template_actual					=	0;

//	Modo Render Actual
	var modo_render						=	0;

//	Almacenar templace Anterior
	var template_anterior				=	0;

//	Velocidad de la animacion de las mesas
	var animacion_velocidad				=	600;
	var animacion_actualizar			=	300;
	var animacion_candidatos_delay     	=   230;
	var animacion_candidatos_fade		=   1000;
	var animacion_candidatos_easing		=   "easeOutBounce";
		animacion_candidatos_easing		=   "easeOutCubic";

//	Almacenar datos de la mesa en objeto
	var objeto_mesas					=	Object();
	var objeto_mesas_disponibles		=	Array();

//	Configuración de los path para las imagenes
	var path_imagen_candidato			=	vav_path + 'app.imagenes/candidatos/';
	var path_imagen_defecto_f			=	vav_path + 'app.imagenes/candidatos/no.foto.f.png';
	var path_imagen_defecto_m			=	vav_path + 'app.imagenes/candidatos/no.foto.m.png';

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	FUNCIONALIDAD PUBNUB
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

			}

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Accion : Cambio de switch
			if( accion == 'preview' )
			{
			//	Almacenar Template
				swich_mesas		=	datoPubNub.template;

			//	Modo de visualización
				swich_modo		=	datoPubNub.modo;

			//	Almacenar ID de las mesas en pantalla
				swich_mesa_1	=	datoPubNub.mesa_1;
				swich_mesa_2	=	datoPubNub.mesa_2;
				swich_mesa_3	=	datoPubNub.mesa_3;
				swich_mesa_4	=	datoPubNub.mesa_4;

			//	Validar la vista solicitada
				if( swich_modo == modo_render )
				{
				//	Validar Templeate Actual
					if( swich_mesas == template_anterior )
					{
					//	Ocultar todos los Template
						$("#swich-template-" + template_anterior ).fadeOut( animacion_velocidad , function()
						{
						//	Obtener Mesas Creadas
							switch_mesas();
						});
					}
					else
					{
					//	Obtener Mesas Creadas
						switch_mesas();
					}
				}
				else
				{
				//	Vaciar Modo
					switch_template(0);
				}
			}

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Accion : Voto Emitido
			if( accion == 'voto' )
			{
			//	Actualizar Votos de una Mesa y validar Modo actual
				if( swich_modo == modo_render )
				{
				//	Validar que la Mesa este en pantalla para interactuar con los votos
					if( objeto_mesas_disponibles.includes(datoPubNub.mesa) )
					{
					//	Declarar variables
						let candidato_id		=	datoPubNub.id;
						let candidato_voto		=	datoPubNub.valor;

					//	Asignar votos al objeto candidato
						$( '#candidato-' + candidato_id ).attr( 'data-votos' , candidato_voto );

					//	Quitar Clase sin voto
						$( '#candidato-' + candidato_id ).removeClass( 'voto-0' );

					//	Animar fondo con nuevo voto
						$( '#candidato-' + candidato_id + ' .candidato-voto' ).fadeIn( animacion_actualizar , function()
						{
							$( '#candidato-' + candidato_id + ' .candidato-voto' ).delay( 100 ).fadeOut( animacion_actualizar );
						});

					//	Animar digito con nuevo voto
						$( '#candidato-votos-' + candidato_id ).delay( 200 ).animate({ opacity: 0.2 } , animacion_actualizar , "linear", function()
						{
						//	Animar el valor del voto
							$( '#candidato-votos-' + candidato_id ).animate({ opacity: 1 });

						//	Asignar votos al candidato
							$( '#candidato-votos-' + candidato_id ).html( candidato_voto );
						});

					//	Ordenar candidatos por sus votos
						mesa_ordenar_votos( datoPubNub.mesa );
					}
				}
			}
		}
	});

//	Suscribirse al Canal
	pubnub.subscribe(
	{
		channels: ['vav_mesas'],
		withPresence: true
	});

//	Obtener historial de PubNub
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
		let datoPubNub			=	response.messages[0].entry;

	//	Obtener Accion desde PubNub
		let accion				=	datoPubNub.accion;

	//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Accion : Voto Emitido
		if( accion == 'switch' )
		{
		//	Almacenar Template
			swich_mesas		=	datoPubNub.template;

		//	Modo de visualización
			swich_modo		=	datoPubNub.modo;

		//	Almacenar ID de las mesas en pantalla
			swich_mesa_1	=	datoPubNub.mesa_1;
			swich_mesa_2	=	datoPubNub.mesa_2;
			swich_mesa_3	=	datoPubNub.mesa_3;
			swich_mesa_4	=	datoPubNub.mesa_4;

		//	Validar la vista solicitada
			if( swich_modo == modo_render )
			{
			//	Obtener Mesas Creadas
				switch_mesas();
			}
			else
			{
			//	Vaciar Modo
				switch_template(0);
			}
		}
	});

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Obtener Mesas Seleccionadas
	function switch_mesas()
	{
	//	Obtener Json
		$.getJSON( vav_path + '/swich/mesas-actuales/' , function( objeto )
		{
		//	Vaciar Coleccion de Mesas
			objeto_mesas_disponibles = [];

		//	Validar Cadena de datos
			if(objeto !== null)
			{
			//	Alimentar Coleccion
				$.each(objeto.mesas, function(i, mesa) 
				{
				//	Agregar el ID de la Mesa al listado de disponibles
					objeto_mesas_disponibles.push(mesa.mesa_id);
				});

			//	Guardar Coleccion de Mesas
				objeto_mesas = objeto.mesas;

			//	Asignar la imformación de las Mesas
				switch_mesas_asignar();
			}
			else
			{
				console.log("No existen mesas asignadas");
			}
		});
	}

//	Asignar Mesas a los template seleccionados
	function switch_mesas_asignar()
	{
	//	Template 1
		if( swich_mesas == 1 )
		{
		//	Vaciar Templates
			$("#swich-template-1").html("");

		//	Construir Mesas
			let mesa1				=	objeto_mesas[ swich_mesa_1 ];

		//		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Validar que exista Mesa 1
			if(mesa1)
			{
			//	Construir Mesa 1
				mesa_construir.template_1( mesa1 )
			}
		}

	//		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Template 2
		if( swich_mesas == 2 )
		{
		//	Vaciar Templates
			$("#swich-template-2").html("");

		//	Construir Mesas
			let mesa1				=	objeto_mesas[ swich_mesa_1 ];
			let mesa2				=	objeto_mesas[ swich_mesa_2 ];

		//		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Validar que exista Mesa 1
			if(mesa1)
			{
			//	Construir Mesa 1
				mesa_construir.template_2( mesa1 )
			}

		//		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Validar que exista Mesa 2
			if(mesa2)
			{
			//	Construir Mesa 2
				mesa_construir.template_2( mesa2 )
			}
		}

	//		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Template 3
		if( swich_mesas == 3 )
		{
		//	Vaciar Templates
			$("#swich-template-3").html("");

		//	Construir Mesas
			let mesa1				=	objeto_mesas[ swich_mesa_1 ];

		//		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Validar que exista Mesa 1
			if(mesa1)
			{
			//	Construir Mesa 1
				mesa_construir.template_3( mesa1 )
			}
		}

	//		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Validar Template y mesas Seleccionado
		switch_template( swich_mesas );
	}

//	Asignar template seleccionados
	function switch_template( template )
	{
	//	Obtener contenedores de los templates
		const swich_template_1 = document.getElementById('swich-template-1');
		const swich_template_2 = document.getElementById('swich-template-2');
		const swich_template_3 = document.getElementById('swich-template-3');

	//	Validar Templeate Actual
		if( template != template_anterior )
		{
		//	Ocultar todos los Template
			$("#swich-template-" + template_anterior ).fadeOut( animacion_velocidad , function()
			{
			//	Reiniciar el Largo del contenedor
				$("#swich-template-" + template ).fadeIn( animacion_velocidad );

			//	Liberar Dom
				if(template == 0)
				{
					swich_template_1.innerHTML = '';
					swich_template_2.innerHTML = '';
					swich_template_3.innerHTML = '';
				}
				if(template == 1)
				{
					swich_template_2.innerHTML = '';
					swich_template_3.innerHTML = '';

				//	Ordenar candidatos por sus votos
					mesa_ordenar_votos( swich_mesa_1 );
				}
				else if(template == 2)
				{
					swich_template_1.innerHTML = '';
					swich_template_3.innerHTML = '';

				//	Ordenar candidatos por sus votos
					mesa_ordenar_votos( swich_mesa_1 );
					mesa_ordenar_votos( swich_mesa_2 );
				}
				else if(template == 3)
				{
					swich_template_1.innerHTML = '';
					swich_template_2.innerHTML = '';

				//	Ordenar candidatos por sus votos
					mesa_ordenar_votos( swich_mesa_1 );
					mesa_ordenar_votos( swich_mesa_2 );
					mesa_ordenar_votos( swich_mesa_3 );
				}

			//	Obtener Imagenes de los candidatos
				candidato_poster();

			//  Delay para animacion de los objetos
				let delay_animacion_candidato   =   0.5;

			//  Animar candidatos
				$( ".candidato" ).each(function()
				{
				//  Animacion del Bloque
					$( this ).delay(( animacion_candidatos_delay * delay_animacion_candidato )).animate({ opacity: 1, left: 0 } , animacion_candidatos_fade , animacion_candidatos_easing );
					
				//  Aumentar Delay
					delay_animacion_candidato++;
				});
			});

		//	Almacenar Template Actual
			template_anterior			=	template;
		}
		else
		{
		//	Ocultar todos los Template
			$("#swich-template-" + template ).fadeOut( 0 , function()
			{
				if(template == 1)
				{
				//	Ordenar candidatos por sus votos
					mesa_ordenar_votos( swich_mesa_1 );
				}
				else if(template == 2)
				{
				//	Ordenar candidatos por sus votos
					mesa_ordenar_votos( swich_mesa_1 );
					mesa_ordenar_votos( swich_mesa_2 );
				}
				else if(template == 3)
				{
				//	Ordenar candidatos por sus votos
					mesa_ordenar_votos( swich_mesa_1 );
					mesa_ordenar_votos( swich_mesa_2 );
					mesa_ordenar_votos( swich_mesa_3 );
				}

			//	Reiniciar el Largo del contenedor
				$("#swich-template-" + template ).fadeIn( animacion_velocidad );

			//	Obtener Imagenes de los candidatos
				candidato_poster();

			//  Delay para animacion de los objetos
				let delay_animacion_candidato   =   0;

			//  Animar candidatos
				$( ".candidato" ).each(function()
				{
				//  Animacion del Bloque
					$( this ).delay(( animacion_candidatos_delay * delay_animacion_candidato )).animate({ opacity: 1, left: 0 } , animacion_candidatos_fade , animacion_candidatos_easing );
					
				//  Aumentar Delay
					delay_animacion_candidato++;
				});
			});
		}
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	FUNCIONALIDADES DE LAS MESAS
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Construir HTML de las mesas
	const mesa_construir =
	{
	//	Construcción del Template 1
		template_1 : function(mesa)
		{
		//	Definir Div contenedor
			const template_render	=	document.getElementById('swich-template-1')

		//	Div con la estructura de los candidatos
			let mesa_candidatos		=	''
			let mesa_candidatos_a	=	''
			let mesa_candidatos_b	=	''

		//	Generar listado de Candidatos
			mesa.candidatos.forEach(candidato =>
			{
			//	Estado del voto
				let voto_estado = '';

			//	Validar estado del Voto
				if(candidato.votos == 0)
				{
					voto_estado = ' voto-0';
				}

			//	Agregar los Candidatos
				mesa_candidatos		=	`<div class="candidato${voto_estado}" id="candidato-${candidato.objeto}" data-votos="${candidato.votos}">
											<div class="candidato-voto"></div>
											<div class="candidato-foto">
												<div class="border"></div>
												<img class="candidato-imagen" id="candidato-imagen-${candidato.objeto}" data-objeto="${ candidato.objeto }" data-candidato="${ candidato.id }" data-type="${ mesa.mesa_tipo }" data-name="${ candidato.nombre }" data-genero="${ candidato.genero }" src="" />
											</div>
											<div class="candidato-datos">
												<h2>${candidato_nombre(candidato.nombre)}</h2>
												<h3>${candidato.partido}</h3>
												<h4>
													<span id="candidato-votos-${candidato.objeto}">${candidato.votos}</span> <div class="img"></div>
												</h4>
											</div>
										</div>`

			//	Validar lista del candidato
				if(candidato.lista == 'A')
				{
					mesa_candidatos_a += mesa_candidatos;
				}
				else
				{
					mesa_candidatos_b += mesa_candidatos;
				}
			})

		//	Crear Mesa
			let mesa_objeto			=	document.createElement('div')

		//	Asignar configuración de la Mesa
			mesa_objeto.id			=	'mesa-' + mesa.mesa_id
			mesa_objeto.className	=	'tottem template-1'

		//	Numero de Mesas
			let mesa_numero = '';

		//	Validar si existe
			if(mesa.mesa_numero)
			{
				mesa_numero = `<div></div> <span>${mesa.mesa_numero}</span>`;
			}

		//	Estructura HTML de la Mesa
			mesa_objeto.innerHTML	=	`<div class="template-1-header">
											<h3>${mesa.mesa_comuna}</h3>
											<h4>${mesa.mesa_local} ${mesa_numero}</h4>
										</div>
										<div class="template-1-listas">
											<div class="template-1-listas-candidatos lista-b" id="candidatos-lista-b-${mesa.mesa_id}">
												${mesa_candidatos_b}
											</div>
										</div>`

		//	Agregar la mesa al DOM
			template_render.appendChild(mesa_objeto)
		},

	//		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Construcción del Template 2
		template_2 : function(mesa)
		{
		//	Definir Div contenedor
			const template_render	=	document.getElementById('swich-template-2')

		//	Div con la estructura de los candidatos
			let mesa_candidatos		=	''
			let mesa_candidatos_a	=	''
			let mesa_candidatos_b	=	''

		//	Generar listado de Candidatos
			mesa.candidatos.forEach(candidato =>
			{
			//	Agregar los Candidatos
				mesa_candidatos		=	`<div class="candidato voto-${candidato.votos}" id="candidato-${candidato.objeto}" data-votos="${candidato.votos}">
											<div class="candidato-voto"></div>
											<div class="candidato-foto">
												<div class="border"></div>
												<img class="candidato-imagen" id="candidato-imagen-${candidato.objeto}" data-objeto="${ candidato.objeto }" data-candidato="${ candidato.id }" data-type="${ mesa.mesa_tipo }" data-name="${ candidato.nombre }" data-genero="${ candidato.genero }" src="" />
											</div>
											<div class="candidato-datos">
												<h2>${candidato_nombre(candidato.nombre)}</h2>
												<h3>${candidato.partido}</h3>
												<h4>
													<span id="candidato-votos-${candidato.objeto}">${candidato.votos}</span> <div class="img"></div>
												</h4>
											</div>
										</div>`

			//	Validar lista del candidato
				if(candidato.lista == 'A')
				{
					mesa_candidatos_a += mesa_candidatos;
				}
				else
				{
					mesa_candidatos_b += mesa_candidatos;
				}
			})

		//	Crear Mesa
			let mesa_objeto			=	document.createElement('div')

		//	Asignar configuración de la Mesa
			mesa_objeto.id			=	'mesa-' + mesa.mesa_id
			mesa_objeto.className	=	'tottem template-1'

		//	Numero de Mesas
			let mesa_numero = '';

		//	Validar si existe
			if(mesa.mesa_numero)
			{
				mesa_numero = `<div></div> <span>${mesa.mesa_numero}</span>`;
			}

		//	Estructura HTML de la Mesa
			mesa_objeto.innerHTML	=	`<div class="template-1-header">
											<h3>${mesa.mesa_comuna}</h3>
											<h4>${mesa.mesa_local} ${mesa_numero}</h4>
										</div>
										<div class="template-1-listas">
											<div class="template-1-listas-candidatos lista-b" id="candidatos-lista-b-${mesa.mesa_id}">
												${mesa_candidatos_b}
											</div>
										</div>`

		//	Agregar la mesa al DOM
			template_render.appendChild(mesa_objeto)
		}
	}

//	Ordenar votos de la mesa
	function mesa_ordenar_votos( mesa )
	{
	//	Obtener objeto de la lista A
		let lista_a = $('#candidatos-lista-a-' + mesa);

	//	Ordenar y asignar nuevo orden
		lista_a.find('.candidato').sort(function (a, b)
		{
			return +b.dataset.votos - +a.dataset.votos;
		}).appendTo( lista_a );

	//	Obtener objeto de la lista B
		let lista_b = $('#candidatos-lista-b-' + mesa);

	//	Ordenar y asignar nuevo orden
		lista_b.find('.candidato').sort(function (a, b)
		{
			return +b.dataset.votos - +a.dataset.votos;
		}).appendTo( lista_b );
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	FUNCIONALIDADES DE LOS CANDIDATOS
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Segmentar Nombre del Candidato
	function candidato_nombre( obj )
	{
	//	Separar Nombre
		let nombre	=	obj.split(" ");

	//	Validar Posibles apellidos
		return nombre[1];
	}

//	Obtener la imagen del Candidato
	const candidato_poster = async () =>
	{
	//	Limpiar consola
	//	console.clear();

	//	Recorrer las imagenes de los candidatos
		Array.from(document.querySelectorAll('.candidato-imagen')).forEach(function(e)
		{
			candidato_poster_crear( e.dataset.objeto );
		});
	}

//	Validar la imagen del Candidato
	const candidato_poster_crear = async ( id ) =>
	{
	//	Obtener información del objeto
		let objeto = document.getElementById('candidato-imagen-' + id);

	//	Variables del objeto
		let candidato = objeto.dataset.candidato;
		let nombre = objeto.dataset.name;
		let genero = objeto.dataset.genero;
		let type = objeto.dataset.type;

	//	Version de cache de las imagenes
		let version = '1.1.1';

	//	Construir ruta de la imagen
		let objeto_imagen = path_imagen_candidato + candidato + '.png?v=' + version;

	//	Validar el tipo de objeto
		if(type == "CNT")
		{
			if(genero == "F")
			{
				objeto.src = path_imagen_defecto_f;
			}
			else
			{
				objeto.src = path_imagen_defecto_m;
			}
		}
		else
		{
		//	Solicitar la imagen
			await fetch( objeto_imagen , { method: 'GET' }).then(res =>
			{
				if (res.ok)
				{
					objeto.src = objeto_imagen;
				}
				else
				{
					if(genero == "F")
					{
						objeto.src = path_imagen_defecto_f;
					}
					else
					{
						objeto.src = path_imagen_defecto_m;					
					}
					
					console.log( candidato , '-' , nombre , '[404]' );
				}
			});
		}
	}