//	URL del diccionario de zonas
	const path_app_zonas = path_app + '/app.librerias/zonas.json'

//	Mode de la Aplicación
	let app_modo = 0
	let app_modo_anterior = 0

//	Template de Mesas
	let app_template = 0
	let app_template_historico = 0

//	Animación de salida
	let app_mesa_consolidados_salida = 0

//	Listado de las 20 Mesas
	let mesas_actuales

//	Total de Mesas Presidenciales
	let mesas_totales

//	Diccionario
	let dicc_region
	let dicc_circunscripcion
	let dicc_distrito

	let mesas_en_pantalla

//	Estructura de Datos
	let mesa_1 = null
	let mesa_1_candidatos = null
	let mesa_1_historico = 0
	let switch_mesa_1 = 0
	let switch_mesa_1_anterior = 0

	let mesa_2 = null
	let mesa_2_candidatos = null
	let mesa_2_historico = 0
	let switch_mesa_2 = 0
	let switch_mesa_2_anterior = 0

	let mesa_votos_totales = 0
	let mesa_candidatos_totales = []

//	Estado de la Mesa en Pantalla
	let estado_mesa = 0

//	Estado Consolidados
	let estado_consolidados = 'of'

//	Transiciones
	let tiempo_transiciones = 750
	let tiempo_transiciones_adicional = 1000

//	-			-			-			-			-			-			-			-			-			-			-			-			

//	Render de la aplicación en el DOM
	const render = document.getElementById("render")

//	Render de las mesas en el DOM
	const render_mesa_1 = document.getElementById("render-mesa-1")
	const render_mesa_2 = document.getElementById("render-mesa-2")

//	Render de las mesas en el DOM
	const render_totales = document.getElementById("render-totales")

//	Configuraciones de la escena
	TweenLite.set( render , { perspective: 1920 });
	TweenLite.set( render_mesa_1 , { transformStyle: "preserve-3d" })
	TweenLite.set( render_mesa_2 , { transformStyle: "preserve-3d" })

//	-			-			-			-			-			-			-			-			-			-			-			-			

//	Posicion de los Elementos en las Animaciones

//	Cordenadas de la Mesa 1
	const mesa_1_cordenadas = {
		'template_tottem' : {
			'visible' : {
				'x' : '68px',
				'y' : '180px',
				'z' : 'rotateY(0deg)'
			},
			'oculta' : {
				'x' : '-195px',
				'y' : '180px',
				'z' : 'rotateY(112deg)'
			}
		},
		'template_floating' : {
			'visible' : {
				'x' : '68px',
				'y' : '180px',
				'z' : 'rotateY(0deg)'
			},
			'oculta' : {
				'x' : '-195px',
				'y' : '180px',
				'z' : 'rotateY(112deg)'
			}
		}
	}

//	Cordenadas de la Mesa 2
	const mesa_2_cordenadas = {
		'template_tottem' : {
			'visible' : {
				'x' : '68px',
				'y' : '606px',
				'z' : 'rotateY(0deg)'
			},
			'oculta' : {
				'x' : '-195px',
				'y' : '606px',
				'z' : 'rotateY(112deg)'
			}
		},
		'template_floating' : {
			'visible' : {
				'x' : '1502px',
				'y' : '180px',
				'z' : 'rotateY(0deg)'
			},
			'oculta' : {
				'x' : '1855px',
				'y' : '180px',
				'z' : 'rotateY(-90deg)'
			}
		}
	}

//	Cordenadas de la Mesa con los Totales
	const mesa_totales_cordenadas = {
		'template_tottem' : {
			'visible' : {
				'x' : '68px',
				'y' : '456px',
				'z' : 'rotateY(0deg)'
			},
			'oculta' : {
				'x' : '-195px',
				'y' : '456px',
				'z' : 'rotateY(112deg)'
			}
		},
		'template_floating' : {
			'visible' : {
				'x' : '68px',
				'y' : '180px',
				'z' : 'rotateY(0deg)'
			},
			'oculta' : {
				'x' : '-195px',
				'y' : '180px',
				'z' : 'rotateY(112deg)'
			}
		}
	}

//	Titulo de la Gráfica
	const mesa_totales_titulo = 'VOTO A VOTO'

//	-			-			-			-			-			-			-			-			-			-			-			-			

	//	Objetos Highcharts
	let chart_1;
	let chart_2;

	//	Configuraciones Highcharts
	const chartBorderColor = "#ffffff";
	const chartBorderWidth = 0;
	const chartAnimacion = 1500;
	const chartDistance = 15;

	//	Colores para Highcharts
	const chartColores = ['#0286db', '#d61158'];
	const chartBrighten = 0.3;

	//	Configuración de Degradación del Grafico
	Highcharts.setOptions(
	{
		colors: Highcharts.map(chartColores, function (color)
		{
			return {
				radialGradient: { cx: 0.5 , cy: 0.5, r: 0.6
			},
			stops: [
				[0, Highcharts.color(color).brighten( chartBrighten ).get('rgb')] , [1, color]
			]
			};
		})
	});

//	-			-			-			-			-			-			-			-			-			-			-			-			

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

		//	Accion : Cambio de switch
			if( accion == 'switch' )
			{
			//	Asignar los ID de las Mesas enviadas
				switch_mesa_1 = datoPubNub.mesa_1
				switch_mesa_2 = datoPubNub.mesa_2

			//	Validar que exista cambio de template
				if( app_modo == datoPubNub.modo )
				{
				//	Validar que la mesa 1 sea distinta a la actual
					if( switch_mesa_1 != switch_mesa_1_anterior || app_template != datoPubNub.template )
					{
						App.animar_salida_mesa_1( datoPubNub.template , datoPubNub.modo , datoPubNub.mesa_1 )
					}
	
				//	Validar que la mesa 2 sea distinta a la actual
					if( switch_mesa_2 != switch_mesa_2_anterior || app_template != datoPubNub.template )
					{
						App.animar_salida_mesa_2( datoPubNub.template , datoPubNub.modo , datoPubNub.mesa_2 )
					}

				//	Dibujar mesas en la escena
					setTimeout(function()
					{
					//	Iniciar Animaciones
						App.init();
					}, tiempo_transiciones_adicional );
				}
				else
				{
				//	Cambiar estado de la salida
					app_mesa_consolidados_salida = 0

				//	Quitar la Mesa de consolidados
					App.totales_animar_salida()
					
				//	Reiniciar ID Historicos
					mesa_1_historico = 0
					mesa_2_historico = 0

				//	Animar la salida del bloque
					App.animar_salida_mesa_1( datoPubNub.template , datoPubNub.modo , datoPubNub.mesa_1 )
					App.animar_salida_mesa_2( datoPubNub.template , datoPubNub.modo , datoPubNub.mesa_2 )

				//	Dibujar mesas en la escena
					setTimeout(function()
					{
					//	Iniciar Animaciones
						App.init();
					}, tiempo_transiciones_adicional );

				//	Almacenar el Template actual
					app_modo = datoPubNub.modo
				}

				if( datoPubNub.template == 0 )
				{
					if( estado_consolidados == 'on' )
					{
						App.totales_animar_salida()
					}
					else
					{
					//	Asignar Posiciones
						render_totales.style.bottom = mesa_totales_cordenadas.template_floating.visible.y;
					}
				}

			//	Almacenar el Template actual
				app_template = datoPubNub.template
			}

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Accion : Voto Emitido
			if( accion == 'voto' )
			{
			//	Variables necesarias
				let id = datoPubNub.id
				let voto = datoPubNub.valor
				let mesa = datoPubNub.mesa
				let candidato = datoPubNub.candidato

			//	Validar que el voto emitido este en pantalla
				App.voto( id , mesa , candidato , voto );

			//	Actualizar conteo de Votos
				App.totales_voto( candidato );
			}

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Accion : Actualizar conteo total
			if( accion == 'recargar' )
			{
			//	Solo permitir mesas de presidentes
				if( datoPubNub.mesa_tipo == 'P' )
				{
					App.totales_actualizar()
				}
			}

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Accion : Estado consolidados
			if( accion == 'cons_estado' )
			{
			//	Variables necesarias
				let estado = datoPubNub.estado

			//	Validar estado del Modulo
				if( estado == 'on' )
				{
					App.totales_animar_entrada()
				}
				else
				{
				//	Cambiar estado de la salida
					app_mesa_consolidados_salida = 1

					App.totales_animar_salida()
				}

			//	Almacenar estado
				estado_consolidados = estado
			}

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Accion : Posicion consolidados
			if( accion == 'cons_posicion' )
			{
			//	Variables necesarias
				let mesas_totales = datoPubNub.posicion

			//	Validar posicion del Modulo
				App.totales_mostrar_mesa( mesas_totales )
			}
		}
	});

//	Suscribirse al Canal
	pubnub.subscribe(
	{
		channels: ['vav_mesas'],
		withPresence: true
	});

//	-			-			-			-			-			-			-			-			-			-			-			-			

//	Constructor de la Aplicación
	const App =
	{
	//	Mesa con resultados totales
		totales : async function()
		{
		//	Solicitar la mesa asignada
			const api = await fetch( path_app + '/swich/mesas-totales/' )
			.then( res => res.json() )
			.then( res => res || [] );

		//	Obtener el total de mesas
			mesas_totales = api.mesas

		//	Obtener las mesas actuales
			mesas_actuales = api.actuales

		//	Obtener los candidatos de la mesa
			mesa_candidatos_totales = api.candidatos

		//	Obtener el total de Mesas
			mesa_votos_totales = api.totales

		//	Asignar Posiciones
			render_totales.style.bottom = mesa_totales_cordenadas.template_floating.oculta.y;
			render_totales.style.left = mesa_totales_cordenadas.template_floating.oculta.x;
			render_totales.style.transform = mesa_totales_cordenadas.template_tottem.oculta.z;

		//	Crear Elemento en el DOM
			App.totales_draw();
		},

	//	Crear la mesa con los totales
		totales_draw : function()
		{
        //  DIV render en el DOM
            const render	=	document.getElementById('render-totales');

		//	Vaciar el contenedor
			render.innerHTML = '';

		//	Crear el DIV de la mesa
			let div_mesa = document.createElement('div');
			div_mesa.className = `results conteo-total`
			div_mesa.id = 'mesa-0'

		//	Crear elementos en el DIV
			div_mesa.innerHTML =   `<div class="header">
										<h2>${mesa_totales_titulo}</h2>
										<h4>
											<div class="totales">${mesas_totales} MESAS</div>
											<div class="total">
												Total Votos : <span>${mesa_votos_totales}</span>
											</div>
										</h4>
									</div>
									<div class="columns" id="mesa-0-candidatos"></div>`;

        //	Dibujar la Mesa en el DOM
			render.appendChild(div_mesa);

		//	Render de los candidatos en la mesa
			const render_candidatos = document.getElementById('mesa-0-candidatos');

		//	Ordenar Opciones
			mesa_candidatos_totales.sort((a, b) => (a.orden > b.orden) ? 1 : (a.orden === b.orden) ? 1 : -1 );

        //	Recorrer el listado de candidatos
			mesa_candidatos_totales.forEach(candidato =>
            {
            //	Crear el div contenedor del candidato
                let objeto = document.createElement('div');
				objeto.className = 'candidato'

            //	Asignar las propiedades del div
                objeto.id = 'candidate-' + candidato.id

			//	Asignar los elementos al div
				objeto.innerHTML = `<div class="candidato-datos ${candidato.nombres == 'APRUEBO' ? 'apruebo' : 'rechazo'}">
										<div class="candidato-datos-nombre">
											<h2>${candidato.nombres == 'APRUEBO' ? 'A' : 'R'}</h2>
										</div>
										<div class="candidato-datos-votos">
											<div class="candidato-datos-votos-icono"><img src="" /></div>
											<div class="candidato-datos-votos-valor">${candidato.votos_p}</div>
											<div class="candidato-voto"></div>
										</div>
									</div>`

            //	Crear candidato en el listado
				render_candidatos.appendChild(objeto);
			});
		},

	//	Actualizar el total de Votos
		totales_actualizar : async function()
		{
		//	Solicitar la mesa asignada
			const api = await fetch( path_app + '/swich/mesas-totales/' )
			.then( res => res.json() )
			.then( res => res || [] );

		//	Obtener el total de mesas
			mesas_totales = api.mesas

		//	Obtener las mesas actuales
			mesas_actuales = api.actuales;

		//	Obtener los candidatos de la mesa
			mesa_candidatos_totales = api.candidatos;

		//	Obtener el total de Mesas
			mesa_votos_totales = api.totales;

		//	Asignar el total de Mesas
			document.querySelector("#mesa-0 > div.header > h4").innerHTML = `
				<div class="totales">${api.mesas} MESAS</div>
				<div class="total">
					Total Votos : <span>${api.totales}</span>
				</div>
			`

        //	Recorrer el listado de candidatos
			api.candidatos.forEach(candidato =>
            {
			//	Actualizar votos en el DOM
				document.querySelector('#candidate-' + candidato.id + ' > div.candidato-datos > div.candidato-datos-votos > div.candidato-datos-votos-valor').innerHTML =  candidato.votos_p;
			});
		},

	//	Asignar votos a un candidato
		totales_voto : function( id )
		{
		//	Identificar al candidato
			const candidato = mesa_candidatos_totales.findIndex((obj => obj.id == Number(id)));

		//	Validar que el candidato exista en el objeto
			if( candidato != -1 )
			{
			//	Actualizar el total de Votos
				App.totales_actualizar()

			//	Identificar el voto en el candidato
				const candidato_div_voto = document.querySelector( '#candidate-' + id + ' > div > div.candidato-datos-votos > div.candidato-voto' );
				const candidato_div_voto_texto = document.querySelector( '#candidate-' + id + ' > div > div.candidato-datos-votos > div.candidato-datos-votos-valor');
				const candidato_div_voto_icono = document.querySelector( '#candidate-' + id + ' >div > div.candidato-datos-votos > div.candidato-datos-votos-icono > img');

			//	Agreguar animación al voto
				candidato_div_voto.classList.add('animar_voto');
				candidato_div_voto_texto.classList.add('animar_voto_texto');
				candidato_div_voto_icono.classList.add('animar_voto_icono');

			//	Reiniciar animación del voto
				setTimeout(function()
				{
					candidato_div_voto.classList.remove('animar_voto');
					candidato_div_voto_texto.classList.remove('animar_voto_texto');
					candidato_div_voto_icono.classList.remove('animar_voto_icono');
				}, tiempo_transiciones );
			}
		},

	//	Animar la entrada del bloque
		totales_animar_entrada : function()
		{
		//	Actualizar el estado
			estado_consolidados = 'on'

		//	Template Totem
			if( app_modo == 0 )
			{
			//	Validar que exista una mesa
				if( mesa_2 != null )
				{
				//	Quitar la Mesa 1 de pantalla
					render_mesa_2.style.bottom = mesa_2_cordenadas.template_tottem.oculta.y;
					render_mesa_2.style.left = mesa_2_cordenadas.template_tottem.oculta.x;
					render_mesa_2.style.transform = mesa_2_cordenadas.template_tottem.oculta.z;

				//	Tiempo de espera
					setTimeout(function()
					{
						if( app_template == 0 )
						{
						//	Asignar Posiciones en el eje X
							render_totales.style.bottom = mesa_totales_cordenadas.template_floating.visible.y;
							render_totales.style.left = mesa_totales_cordenadas.template_floating.visible.x;
							render_totales.style.transform = mesa_totales_cordenadas.template_tottem.visible.z;
						}
						else
						{
						//	Asignar Posiciones en el eje X
							render_totales.style.bottom = mesa_totales_cordenadas.template_tottem.visible.y;
							render_totales.style.left = mesa_totales_cordenadas.template_tottem.visible.x;
							render_totales.style.transform = mesa_totales_cordenadas.template_tottem.visible.z;
						}
					}, tiempo_transiciones_adicional );
				}
				else
				{
					if( mesa_1 != null )
					{
						if( app_template == 0 )
						{
						//	Asignar Posiciones en el eje X
							render_totales.style.bottom = mesa_totales_cordenadas.template_floating.visible.y;
							render_totales.style.left = mesa_totales_cordenadas.template_floating.visible.x;
							render_totales.style.transform = mesa_totales_cordenadas.template_floating.visible.z;
						}
						else
						{
						//	Asignar Posiciones en el eje X
							render_totales.style.bottom = mesa_totales_cordenadas.template_tottem.visible.y;
							render_totales.style.left = mesa_totales_cordenadas.template_tottem.visible.x;
							render_totales.style.transform = mesa_totales_cordenadas.template_tottem.visible.z;
						}
					}
					else
					{
					//	Asignar Posiciones en el eje X
						render_totales.style.bottom = mesa_totales_cordenadas.template_floating.visible.y;
						render_totales.style.left = mesa_totales_cordenadas.template_floating.visible.x;
						render_totales.style.transform = mesa_totales_cordenadas.template_floating.visible.z;
					}
				}
			}

		//	Template Floating
			if( app_modo == 1 )
			{
			//	Validar que exista una mesa
				if( mesa_1 != null )
				{
				//	Quitar la Mesa 1 de pantalla
					render_mesa_1.style.bottom = mesa_1_cordenadas.template_floating.oculta.y;
					render_mesa_1.style.left = mesa_1_cordenadas.template_floating.oculta.x;
					render_mesa_1.style.transform = mesa_1_cordenadas.template_floating.oculta.z;

				//	Tiempo de espera
					setTimeout(function()
					{
					//	Asignar Posiciones en el eje X
						render_totales.style.bottom = mesa_totales_cordenadas.template_floating.visible.y;
						render_totales.style.left = mesa_totales_cordenadas.template_floating.visible.x;
						render_totales.style.transform = mesa_totales_cordenadas.template_floating.visible.z;
					}, tiempo_transiciones_adicional );
				}
				else
				{
				//	Asignar Posiciones en el eje X
					render_totales.style.bottom = mesa_totales_cordenadas.template_floating.visible.y;
					render_totales.style.left = mesa_totales_cordenadas.template_floating.visible.x;
					render_totales.style.transform = mesa_totales_cordenadas.template_floating.visible.z;
				}
			}
		},

	//	Animar la salida del bloque
		totales_animar_salida : function()
		{
		//	Actualizar el estado
			estado_consolidados = 'of'

		//	Reparar Bug de las transición
			render_mesa_2.classList.add('transition-on')

		//	Template Totem
			if( app_modo == 0 )
			{
				if( app_template == 0 )
				{
				//	Asignar Posiciones
					render_totales.style.bottom = mesa_totales_cordenadas.template_floating.oculta.y;
					render_totales.style.left = mesa_totales_cordenadas.template_floating.oculta.x;
					render_totales.style.transform = mesa_totales_cordenadas.template_floating.oculta.z;
				}
				else
				{
					if( mesa_2 != null )
					{
					//	Asignar Posiciones en el eje X
						render_totales.style.bottom = mesa_totales_cordenadas.template_tottem.oculta.y;
						render_totales.style.left = mesa_totales_cordenadas.template_tottem.oculta.x;
						render_totales.style.transform = mesa_totales_cordenadas.template_tottem.oculta.z;

						if( app_mesa_consolidados_salida == 1 )
						{
							if( app_template != 0 )
							{
							//	Tiempo de espera
								setTimeout(function()
								{
								//	Asignar Posiciones en el eje X
									render_mesa_2.style.bottom = mesa_2_cordenadas.template_tottem.visible.y;
									render_mesa_2.style.left = mesa_2_cordenadas.template_tottem.visible.x;
									render_mesa_2.style.transform = mesa_2_cordenadas.template_tottem.visible.z;
								}, tiempo_transiciones_adicional );

								app_mesa_consolidados_salida = 0
							}
						}
					}
					else
					{
						if( mesa_1 != null )
						{
						//	Asignar Posiciones
							render_totales.style.bottom = mesa_totales_cordenadas.template_tottem.oculta.y;
							render_totales.style.left = mesa_totales_cordenadas.template_tottem.oculta.x;
							render_totales.style.transform = mesa_totales_cordenadas.template_tottem.oculta.z;
						}
						else
						{
						//	Asignar Posiciones en el eje X
							render_totales.style.bottom = mesa_totales_cordenadas.template_floating.oculta.y;
							render_totales.style.left = mesa_totales_cordenadas.template_floating.oculta.x;
							render_totales.style.transform = mesa_totales_cordenadas.template_floating.oculta.z;
						}
					}
				}
			}

		//	Template Floating
			if( app_modo == 1 )
			{
				if( mesa_1 != null )
				{
				//	Asignar Posiciones en el eje X
					render_totales.style.bottom = mesa_totales_cordenadas.template_floating.oculta.y;
					render_totales.style.left = mesa_totales_cordenadas.template_floating.oculta.x;
					render_totales.style.transform = mesa_totales_cordenadas.template_floating.oculta.z;

					if( app_mesa_consolidados_salida == 1 )
					{
						if( app_template != 0 )
						{
						//	Tiempo de espera
							setTimeout(function()
							{
							//	Asignar Posiciones
								render_mesa_1.style.bottom = mesa_1_cordenadas.template_tottem.visible.y;
								render_mesa_1.style.left = mesa_1_cordenadas.template_tottem.visible.x;
								render_mesa_1.style.transform = mesa_1_cordenadas.template_tottem.visible.z;
							}, tiempo_transiciones_adicional );

							app_mesa_consolidados_salida = 0
						}
					}
				}
				else
				{
				//	Asignar Posiciones en el eje X
					render_totales.style.bottom = mesa_totales_cordenadas.template_floating.oculta.y;
					render_totales.style.left = mesa_totales_cordenadas.template_floating.oculta.x;
					render_totales.style.transform = mesa_totales_cordenadas.template_floating.oculta.z;
				}
			}
		},

	//	Animar la posicion del bloque
		totales_mostrar_mesa : function( estado )
		{
		//	Objecto a modificar
			const total_mesas = document.querySelector("#mesa-0 > div.header > h4 > div.totales")

		//	Validar estado del titulo
			if( estado == 'l' )
			{
				total_mesas.style.opacity = 0
			}
			else
			{
				total_mesas.style.opacity = 1
			}
		},

//			-			-			-			-			-			-			-			-			-			-			-

	//	Crear diccionarios
		zone : async function()
		{
		//	Solicitar la mesa asignada
			const api = await fetch( path_app_zonas )
			.then( res => res.json() )
			.then( res => res || [] );

		//	Generar diccionario
			dicc_region = api.regiones
			dicc_circunscripcion = api.circunscripciones
			dicc_distrito = api.distritos
		},

	//	Iniciar la App
		init : async function()
		{
		//	Solicitar la mesa asignada
			const api = await fetch( path_app + '/swich/mesas-actuales/' )
			.then( res => res.json() )
			.then( res => res.mesas || [] );

		//	Almacenar Mesas en Pantalla
			mesas_en_pantalla = api

		//	Validar que exista la Mesa 1
			if( switch_mesa_1 != null )
			{
			//	Obtener la primera mesa
				mesa_1 = api[switch_mesa_1];

				//	Validar Rendereo de la mesa con Historicos
				if( mesa_1_historico != mesa_1.id || app_template_historico != app_template )
				{
				//	Obtener los candidatos de la mesa
					mesa_1_candidatos = mesa_1.candidatos;

				//	Dibujar la mesa en el DOM		
					App.draw( 1 , mesa_1 );
				}
			}

		//	Validar que el template sea compatible
			if( app_template == 2 )
			{
			//	Asignar clase al modo
				render_mesa_1.classList.remove('template-1');
				render_mesa_1.classList.add('template-2');

			//	Asignar clase al modo
				render_mesa_2.classList.remove('template-1');
				render_mesa_2.classList.add('template-2');

			//	Validar que exista la Mesa 2
				if( switch_mesa_2 != null )
				{
				//	Obtener la primera mesa
					mesa_2 = api[switch_mesa_2];

				//	Validar Rendereo de la mesa con Historicos
					if( mesa_2_historico != mesa_2.id || app_template_historico != app_template )
					{
					//	Obtener los candidatos de la mesa
						mesa_2_candidatos = mesa_2.candidatos;

					//	Validar template anterior
						if( app_modo == 0 )
						{
						//	Reiniciar Mesa
							render_mesa_2.classList.remove('transition-on')
							render_mesa_2.style.bottom = mesa_2_cordenadas.template_tottem.oculta.y;
							render_mesa_2.style.left = mesa_2_cordenadas.template_tottem.oculta.x;
							render_mesa_2.style.transform = mesa_2_cordenadas.template_tottem.oculta.z;

						//	Almacenar modo actual
							app_modo_anterior = 0
						}

					//	Validar template anterior
						if( app_modo == 1 )
						{
						//	Reiniciar Mesa
							render_mesa_2.classList.remove('transition-on')	
							render_mesa_2.style.bottom = mesa_2_cordenadas.template_floating.oculta.y;
							render_mesa_2.style.left = mesa_2_cordenadas.template_floating.oculta.x;
							render_mesa_2.style.transform = mesa_2_cordenadas.template_floating.oculta.z;

						//	Almacenar modo actual
							app_modo_anterior = 0
						}

					//	Dibujar la mesa en el DOM		
						App.draw( 2 , mesa_2 );
					}
				}
			}
			else
			{
			//	Vaciar el contenedor
				render_mesa_2.innerHTML = ''

			//	Asignar clase al modo
				render_mesa_1.classList.remove('template-2');
				render_mesa_1.classList.add('template-1');

			//	Asignar clase al modo
				render_mesa_2.classList.remove('template-2');
				render_mesa_2.classList.add('template-1');
			}

		//	Asignar modo de render
			if( app_modo == 0 )
			{
			//	Asignar clase al modo
				render_mesa_1.classList.remove('floating');
				render_mesa_1.classList.add('tottem');

			//	Asignar clase al modo
				render_mesa_2.classList.remove('floating');
				render_mesa_2.classList.add('tottem');

			//	Asignar Posiciones en el eje X
				render_totales.style.bottom = mesa_totales_cordenadas.template_tottem.oculta.y;
			}
			else
			{
			//	Asignar clase al modo
				render_mesa_1.classList.remove('tottem');
				render_mesa_1.classList.add('floating');

			//	Asignar clase al modo
				render_mesa_2.classList.remove('tottem');
				render_mesa_2.classList.add('floating');

			//	Asignar Posiciones en el eje X
				render_totales.style.bottom = mesa_totales_cordenadas.template_floating.oculta.y;
			}

		//	Almacenar ID Historico de la Mesa
			mesa_1_historico = api[switch_mesa_1].id
			mesa_2_historico = api[switch_mesa_2].id

			app_template_historico = app_template
		},

	//	Dibujar la mesa en el DOM
		draw : function( posicion , mesa )
		{
        //  DIV render en el DOM
            const render	=	document.getElementById('render-mesa-' + posicion );

		//	Vaciar el contenedor
			render.innerHTML = '';

		//	Crear el DIV de la mesa
			let div_mesa = document.createElement('div');
			div_mesa.id = 'mesa-' + mesa.id

		//	Estado de la mesa con resultados totales
			if( estado_consolidados == 'on' )
			{
			//	Asignar las clases a la mesa
				div_mesa.className = `box conteo-simple`
			}
			else
			{
			//	Asignar las clases a la mesa
				div_mesa.className = `box conteo-simple`
			}

		//	Crear elementos en el DIV
			div_mesa.innerHTML =   `<div class="header">
										<h2>${mesa.comuna}</h2>
										<h3>${mesa.local} <span>${mesa.numero}</span></h3>
									</div>
									<div class="columns" id="mesa-${mesa.id}-candidatos">
									</div>
									<div class="chart">
										<div class="chart-details" id="chart-details-${mesa.id}">
											<div class="chart-details-a">39.5%</div>
											<div class="chart-details-r">60.5%</div>
										</div>
										<div class="chart-render" id="chart-${mesa.id}" data="${posicion}"></div>
									</div>`;

        //	Dibujar la Mesa en el DOM
			render.appendChild(div_mesa);

		//	Crear los gráficos
			if( posicion == 1 )
			{
				chart_1	=	Highcharts.chart( "chart-" + mesa.id,
				{
					chart: { plotBackgroundColor: null , plotBorderWidth: 0 , plotShadow: false , backgroundColor: 'rgba(0,0,0,0)'},
					title: { text: null },
					tooltip: { enabled: false },
					plotOptions: {
						pie: {
							borderWidth: chartBorderWidth ,
							borderColor: chartBorderColor,
							allowPointSelect: true,
							cursor: 'pointer',
							dataLabels: {
								enabled: false,
							},
							startAngle: -90,
							endAngle: 90,
							center: ['50%', '75%'],
							size: '110%'
						}
					},
					series: [{
					animation: {duration: chartAnimacion},
					type: 'pie',
					innerSize: '54%',
					data: [['A', Number( mesa.candidatos[0].votos )],['R', Number( mesa.candidatos[1].votos )]]}]
				});
			}
			else
			{
				chart_2	=	Highcharts.chart( "chart-" + mesa.id,
				{
					chart: { plotBackgroundColor: null , plotBorderWidth: 0 , plotShadow: false , backgroundColor: 'rgba(0,0,0,0)'},
					title: { text: null },
					tooltip: { enabled: false },
					plotOptions: {
						pie: {
							borderWidth: chartBorderWidth ,
							borderColor: chartBorderColor,
							allowPointSelect: true,
							cursor: 'pointer',
							dataLabels: {
								enabled: false,
							},
							startAngle: -90,
							endAngle: 90,
							center: ['50%', '75%'],
							size: '110%'
						}
					},
					series: [{
					animation: {duration: chartAnimacion},
					type: 'pie',
					innerSize: '54%',
					data: [['A', Number( mesa.candidatos[0].votos )],['R', Number( mesa.candidatos[1].votos )]]}]
				});
			}

		//	Render de los candidatos en la mesa
			const render_candidatos = document.getElementById('mesa-' + mesa.id + '-candidatos');

        //	Recorrer el listado de candidatos
			mesa.candidatos.forEach(candidato =>
            {
            //	Crear el div contenedor del candidato
                let objeto = document.createElement('div');
				objeto.className = 'candidato'

            //	Asignar las propiedades del div
                objeto.id = 'candidate-' + candidato.objeto

			//	Asignar los elementos al div
				objeto.innerHTML = `<div class="candidato-datos ${candidato.nombres == 'APRUEBO' ? 'apruebo' : 'rechazo'}">
										<div class="candidato-datos-nombre">
											<h2>${candidato.nombres}</h2>
										</div>
										<div class="candidato-datos-votos">
											<div class="candidato-datos-votos-icono"><img src="" /></div>
											<div class="candidato-datos-votos-valor">${candidato.votos}</div>
											<div class="candidato-voto"></div>
										</div>
									</div>`

            //	Crear candidato en el listado
				render_candidatos.appendChild(objeto);
            });

		//	Asignar posición 2 en pantalla
			if( posicion == 1 )
			{
			//	Validar visibilidad del modulo consolidados
				if( app_modo == 1 && estado_consolidados == 'on' )
				{
					app_mesa_consolidados_salida == 1 
				}
				else
				{
					if( app_template != 0 )
					{
						App.animar_entrada_mesa_1();
					}
				}
			}

		//	Asignar posición 2 en pantalla
			if( posicion == 2 )
			{
			//	Validar visibilidad del modulo consolidados
				if( app_modo == 0 && estado_consolidados == 'on' )
				{
					app_mesa_consolidados_salida == 1 
				}
				else
				{
					if( app_template != 0 )
					{
						App.animar_entrada_mesa_2();
					}
				}
			}
		},

	//	Asignar votos a un candidato
		voto : function( id , mesa, candidato, votos )
		{
		//	Actualizar votos en el DOM
			const candidato_voto = document.querySelector('#candidate-' + id + ' > div.candidato-datos > div.candidato-datos-votos > div.candidato-datos-votos-valor');

		//	Validar que exista el elemento
			if( candidato_voto != null )
			{
			//	Actualizar el voto
				candidato_voto.innerHTML = votos

			//	Identificar el voto en el candidato
				const candidato_div_voto = document.querySelector( '#candidate-' + id + ' > div.candidato-datos > div.candidato-datos-votos > div.candidato-voto' );
				const candidato_div_voto_texto = document.querySelector( '#candidate-' + id + ' > div.candidato-datos > div.candidato-datos-votos > div.candidato-datos-votos-valor');
				const candidato_div_voto_icono = document.querySelector( '#candidate-' + id + ' > div.candidato-datos > div.candidato-datos-votos > div.candidato-datos-votos-icono > img');

			//	Agreguar animación al voto
				candidato_div_voto.classList.add('animar_voto');
				candidato_div_voto_texto.classList.add('animar_voto_texto');
				candidato_div_voto_icono.classList.add('animar_voto_icono');

			//	Reiniciar animación del voto
				setTimeout(function()
				{
					candidato_div_voto.classList.remove('animar_voto');
					candidato_div_voto_texto.classList.remove('animar_voto_texto');
					candidato_div_voto_icono.classList.remove('animar_voto_icono');
				}, tiempo_transiciones_adicional);

			//	-		-		-		-		-		-		-		-		-		-		-		-		-		-

			//	Obtener el contenedor del gráfico
				const chart = Number( document.getElementById('chart-' + mesa ).getAttribute('data') )

			//	Validar Posición del gráfico 1
				if(chart == 1)
				{
					if( candidato == 1 )
					{
						chart_1.series[0].data[0].update( Number(votos) );
					}
					else
					{
						chart_1.series[0].data[1].update( Number(votos) );
					}
				}
				
			//	Validar Posición del gráfico 1
				if(chart == 2)
				{
					if( candidato == 1 )
					{
						chart_2.series[0].data[0].update( Number(votos) );
					}
					else
					{
						chart_2.series[0].data[1].update( Number(votos) );
					}
				}

			//	-		-		-		-		-		-		-		-		-		-		-		-		-		-

				console.log('VOTO :', id, mesa, candidato, votos);

				const resultado = mesas_en_pantalla[mesa].candidatos.find( candidato => candidato.objeto === id );
				resultado.votos = votos

				console.log(resultado);

			//	Obtener los valores y sus votos
				const mesa_datos = document.querySelectorAll('#mesa-' + mesa + '-candidatos > .candidato')

				mesa_datos.forEach((item, index) => {

					const voto = item.querySelector(".candidato-datos > .candidato-datos-votos > .candidato-datos-votos-valor").textContent

					console.log( index, voto );
				})

			//	Obtener el contenedor del gráfico
				const chart_details = document.getElementById('chart-details-' + mesa )
				

			}
			else
			{
				console.log('NO RENDER');
			}
		},

	//			-			-			-			-			-			-			-			-			-			-			-

	//	Animar la entrada del bloque
		animar_entrada_mesa_1 : function()
		{
		//	Template Totem
			if( app_modo == 0 )
			{
			//	Asignar Posiciones en el eje X
				render_mesa_1.style.bottom = mesa_1_cordenadas.template_tottem.visible.y;
				render_mesa_1.style.left = mesa_1_cordenadas.template_tottem.visible.x;
				render_mesa_1.style.transform = mesa_1_cordenadas.template_tottem.visible.z;
			}

		//	Template Floating
			if( app_modo == 1 )
			{
			//	Asignar Posiciones en el eje X
				render_mesa_1.style.bottom = mesa_1_cordenadas.template_floating.visible.y;
				render_mesa_1.style.left = mesa_1_cordenadas.template_floating.visible.x;
				render_mesa_1.style.transform = mesa_1_cordenadas.template_floating.visible.z;
			}
		},

	//	Animar la entrada del bloque
		animar_entrada_mesa_2 : function()
		{
		//	Corrección para el Bug del salto
			setTimeout(function()
			{
				render_mesa_2.classList.add('transition-on')

				//	Template Totem
				if( app_modo == 0 )
				{
				//	Asignar Posiciones en el eje X
					render_mesa_2.style.bottom = mesa_2_cordenadas.template_tottem.visible.y;
					render_mesa_2.style.left = mesa_2_cordenadas.template_tottem.visible.x;
					render_mesa_2.style.transform = mesa_2_cordenadas.template_tottem.visible.z;
				}

			//	Template Floating
				if( app_modo == 1 )
				{
				//	Asignar Posiciones en el eje X
					render_mesa_2.style.bottom = mesa_2_cordenadas.template_floating.visible.y;
					render_mesa_2.style.left = mesa_2_cordenadas.template_floating.visible.x;
					render_mesa_2.style.transform = mesa_2_cordenadas.template_floating.visible.z;
				}
			}, 10);
		},

	//			-			-			-			-			-			-			-			-			-			-			-

	//	Animar la entrada del bloque
		animar_salida_mesa_1 : function( template , modo , mesa_id )
		{
		//	Template Totem
			if( app_modo == 0 )
			{
				render_mesa_1.style.bottom = mesa_1_cordenadas.template_tottem.oculta.y;
				render_mesa_1.style.left = mesa_1_cordenadas.template_tottem.oculta.x;
				render_mesa_1.style.transform = mesa_1_cordenadas.template_tottem.oculta.z;
			}

		//	Template Floating
			if( app_modo == 1 )
			{
				render_mesa_1.style.bottom = mesa_1_cordenadas.template_floating.oculta.y;
				render_mesa_1.style.left = mesa_1_cordenadas.template_floating.oculta.x;
				render_mesa_1.style.transform = mesa_1_cordenadas.template_floating.oculta.z;
			}

		//	Validar que exista un mesa que mostrar
			if( mesa_id != null )
			{
			//	Asignar mesa anterior
				switch_mesa_1_anterior = mesa_id

			//	Reiniciar animación del voto
				setTimeout(function()
				{
				//	Asignar mode del Render
					app_modo = modo;
				}, tiempo_transiciones_adicional );
			}
			else
			{
			//	Limpiar mesa
				setTimeout(function()
				{
				//	Limpiar el Objeto
					mesa_1 = null

				//	Limpiar el DOM
					render_mesa_1.innerHTML = ''
				}, tiempo_transiciones_adicional );
			}	
		},

	//	Animar la entrada del bloque
		animar_salida_mesa_2 : function( template , modo , mesa_id )
		{
		//	Template Totem
			if( app_modo == 0 )
			{
			//	Asignar Posiciones en el eje X
				render_mesa_2.style.bottom = mesa_2_cordenadas.template_tottem.oculta.y;
				render_mesa_2.style.left = mesa_2_cordenadas.template_tottem.oculta.x;
				render_mesa_2.style.transform = mesa_2_cordenadas.template_tottem.oculta.z;
			}

		//	Template Floating
			if( app_modo == 1 )
			{
			//	Asignar Posiciones en el eje X
				render_mesa_2.style.bottom = mesa_2_cordenadas.template_floating.oculta.y;
				render_mesa_2.style.left = mesa_2_cordenadas.template_floating.oculta.x;
				render_mesa_2.style.transform = mesa_2_cordenadas.template_floating.oculta.z;
			}

		//	Validar que exista un mesa que mostrar
			if( mesa_id != null )
			{
			//	Asignar mesa anterior
				switch_mesa_2_anterior = mesa_id

			//	Reiniciar animación del voto
				setTimeout(function()
				{
				//	Asignar mode del Render
					app_modo = modo;

					if( modo == 0 )
					{
						app_modo_anterior = 1
					}

					if( modo == 1 )
					{
						app_modo_anterior = 2
					}
					
				}, tiempo_transiciones_adicional );
			}
			else
			{
				if( modo == 0 )
				{
					app_modo_anterior = 1
				}

				if( modo == 1 )
				{
					app_modo_anterior = 2
				}

			//	Limpiar mesa
				setTimeout(function()
				{
				//	Limpiar el Objeto
					mesa_2 = null

				//	Limpiar el DOM
					render_mesa_2.innerHTML = ''
				}, tiempo_transiciones_adicional );
			}
		}
	}

//	Iniciar las Zonas
	App.zone();

//	Crear mesa con los totales
	App.totales();