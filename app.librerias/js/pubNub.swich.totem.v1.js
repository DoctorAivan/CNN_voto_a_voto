//	URL del diccionario de zonas
const path_app_zonas = path_app + '/app.librerias/zonas.json?v=1.2'

//	Mode de la Aplicación
	let app_modo = 0

//	Template de Mesas
	let app_template = 0
	let app_template_historico = 0

//	Diccionario
	let objeto_regiones
	let objeto_circunscripciones
	let objeto_distritos

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

//	Transiciones
	let tiempo_transiciones = 750
	let tiempo_transiciones_adicional = 1000

//	-			-			-			-			-			-			-			-			-			-			-			-			

//	Render de la aplicación en el DOM
	const render = document.getElementById("render")

//	Render Fondo de Tottem
	const bg_tottem = document.getElementById("bg-tottem")

//	Render de las mesas en el DOM
	const render_mesa_1 = document.getElementById("render-mesa-1")
	const render_mesa_2 = document.getElementById("render-mesa-2")

//	-			-			-			-			-			-			-			-			-			-			-			-			

//	Posicion de los Elementos en las Animaciones

//	Cordenadas de la Mesa 1
	const mesa_1_cordenadas = {
		'template_tottem' : {
			'visible' : {
				'x' : '133px',
				'y' : '195px',
				'z' : 'unset'
			//	'z' : 'rotateY(0deg)'
			},
			'oculta' : {
				'x' : '-340px',
				'y' : '195px',
				'z' : 'unset'
			//	'z' : 'rotateY(112deg)'
			}
		},
		'template_floating' : {
			'visible' : {
				'x' : '133px',
				'y' : '195px',
				'z' : 'unset'
			//	'z' : 'rotateY(0deg)'
			},
			'oculta' : {
				'x' : '-340px',
				'y' : '195px',
				'z' : 'unset'
			//	'z' : 'rotateY(112deg)'
			}
		}
	}

//	Cordenadas de la Mesa 2
	const mesa_2_cordenadas = {
		'template_tottem' : {
			'visible' : {
				'x' : '133px',
				'y' : '625px',
				'z' : 'unset'
			//	'z' : 'rotateY(0deg)'
			},
			'oculta' : {
				'x' : '-340px',
				'y' : '625px',
				'z' : 'unset'
			//	'z' : 'rotateY(112deg)'
			}
		},
		'template_floating' : {
			'visible' : {
				'x' : '1446px',
				'y' : '195px',
				'z' : 'unset'
			//	'z' : 'rotateY(0deg)'
			},
			'oculta' : {
				'x' : '1920px',
				'y' : '195px',
				'z' : 'unset'
			//	'z' : 'rotateY(-90deg)'
			}
		}
	}

//	Cordenadas del fondo de Tottem
	const bg_tottem_cordenadas = {
		'mesas_0' : {
			'h' : '0px'
		},
		'mesas_1' : {
			'h' : '439px'
		},
		'mesas_2' : {
			'h' : '912px'
		}
	}

//	Titulo Mesa Conteo
	const mesa_titulo = 'VOTO A VOTO'

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

			//	Almacenar el Template actual
				app_template = datoPubNub.template

			// Validar el template
				if( datoPubNub.template == 0 )
				{
				//	Mesa totales en la Escena
					setTimeout(function()
					{
						bg_tottem.style.left = '-473px';
					}, tiempo_transiciones );
				}
				else if( datoPubNub.template == 1 )
				{
				//	Mesa totales en la Escena
					setTimeout(function()
					{
						bg_tottem.style.left = '0px';
						bg_tottem.style.height = bg_tottem_cordenadas.mesas_1.h;
					}, tiempo_transiciones );
				}
				else if( datoPubNub.template == 2 )
				{
				//	Mesa totales en la Escena
					setTimeout(function()
					{
						bg_tottem.style.left = '0px';
						bg_tottem.style.height = bg_tottem_cordenadas.mesas_2.h;
					}, tiempo_transiciones );
				}

				if( datoPubNub.modo == 1 )
				{
				//	Mesa totales en la Escena
					setTimeout(function()
					{
						bg_tottem.style.left = '-473px';
					}, tiempo_transiciones );
				}
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
			}

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Accion : Actualizar conteo total
			if( accion == 'recargar' )
			{

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
	//	Crear diccionarios
		zone : async function()
		{
		//	Solicitar la mesa asignada
			const api = await fetch( path_app_zonas )
			.then( res => res.json() )
			.then( res => res || [] );

		//	Generar diccionario
			objeto_regiones = api.regiones
			objeto_circunscripciones = api.circunscripciones
			objeto_distritos = api.distritos
		},

	//	Iniciar la App
		init : async function()
		{
		//	Solicitar la mesa asignada
			const api = await fetch( path_app + '/swich/mesas-actuales/' )
			.then( res => res.json() )
			.then( res => res.mesas || [] );

		//	Asignar modo de render
			if( app_modo == 0 )
			{
			//	Asignar clase al modo
				render_mesa_1.classList.remove('floating');
				render_mesa_1.classList.add('tottem');

				render_mesa_2.classList.remove('floating');
				render_mesa_2.classList.add('tottem');
			}
			else if( app_modo == 1 )
			{
			//	Asignar clase al modo
				render_mesa_1.classList.remove('tottem');
				render_mesa_1.classList.add('floating');

				render_mesa_2.classList.remove('tottem');
				render_mesa_2.classList.add('floating');
			}

		//	Validar que exista la Mesa 1
			if( switch_mesa_1 != null )
			{
			//	Obtener la primera mesa
				mesa_1 = api[switch_mesa_1];

			//	Asignar Cupos por región
				mesa_1.cupos = App.obtener_cupos(mesa_1.zona_id);

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

				//	Asignar Cupos por región
					mesa_2.cupos = App.obtener_cupos(mesa_2.zona_id);

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
						}

					//	Validar template anterior
						if( app_modo == 1 )
						{
						//	Reiniciar Mesa
							render_mesa_2.classList.remove('transition-on')	
							render_mesa_2.style.bottom = mesa_2_cordenadas.template_floating.oculta.y;
							render_mesa_2.style.left = mesa_2_cordenadas.template_floating.oculta.x;
							render_mesa_2.style.transform = mesa_2_cordenadas.template_floating.oculta.z;
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

		//	Almacenar ID Historico de la Mesa
			if( api[switch_mesa_1] )
			{
				mesa_1_historico = api[switch_mesa_1].id
			}

			if( api[switch_mesa_2] )
			{
				mesa_2_historico = api[switch_mesa_2].id
			}

		//	Almacenar Template
			app_template_historico = app_template
		},

	//	Dibujar la mesa en el DOM
		draw : function( posicion , mesa )
		{
		//	Obtener información de la Región
			const region = objeto_regiones.find(({ i }) => i === Number(mesa.zona_id));

        //  DIV render en el DOM
            const render	=	document.getElementById('render-mesa-' + posicion );

		//	Vaciar el contenedor
			render.innerHTML = '';

		//	Crear el DIV de la mesa
			let div_mesa = document.createElement('div');
			div_mesa.id = 'mesa-' + mesa.id

			//	Asignar las clases a la mesa
			div_mesa.className = `box pos-${posicion} conteo-simple`

			let mesa_h2
			let mesa_h3

		//	Validar Ciudad en el Extranjero
			if(mesa.zona.includes('Región'))
			{
				mesa_h2 = mesa.comuna
			}
			else
			{
				mesa_h2 = mesa.comuna + '<span class="country">' + mesa.zona + '</span>'
			}

		//	Validar Numero de Mesa
			if(mesa.numero)
			{
				mesa_h3 = `${mesa.local} <span>${mesa.numero}</span>`
			}
			else
			{
				mesa_h3 = mesa.local
			}

		//	Crear elementos en el DIV
			div_mesa.innerHTML =   `<div class="title">
										<h2>${region.n}</h2>
										<h3><i class="fas fa-users"></i> ${region.c} ESCAÑOS</h3>
									</div>
									<div class="border"></div>
									<div class="header">
										<h2>${mesa_h2}</h2>
										<h3>${mesa_h3}</h3>
									</div>
									<div class="columns" respaldo="letters_zoom_in" id="mesa-${mesa.id}-candidatos"></div>`;

        //	Dibujar la Mesa en el DOM
			render.appendChild(div_mesa);

		//	Render de los candidatos en la mesa
			const render_candidatos = document.getElementById('mesa-' + mesa.id + '-candidatos');

		//	Indice del orden
			let id_orden = 1;

		//	Ordenar los candidatos por sus votos
			mesa.candidatos.sort((a, b) => (b.votos > a.votos) ? 1 : -1)

        //	Recorrer el listado de candidatos
			mesa.candidatos.forEach(candidato =>
            {
			//	Marcar candidato electo
				let marcar_candidato;

			// Validar candidatos marcados
				if( id_orden <= mesa.cupos )
				{
					marcar_candidato = 'electo';
				}
				else
				{
					marcar_candidato = 'no-electo';
				}

            //	Crear el div contenedor del candidato
                let objeto = document.createElement('div');
				objeto.className = `candidato order-${id_orden} ${marcar_candidato}`

            //	Asignar las propiedades del div
                objeto.id = 'candidate-' + candidato.objeto

			//	Obtener el primer caracter del nombre
				let candidato_nombre_letra = candidato.nombres.split('')[0];

			//	Asignar los elementos al div
				objeto.innerHTML = `<div class="candidato-detalles">
										<h2><span>${candidato.nombres}</span> ${candidato.apellidos}</h2>
										<h3><span>Partido Republicano</span> ${ candidato.ind === 't' ? 'IND-' : '' }${candidato.partido}</h3>
									</div>
									<div class="candidato-votos" id="candidato-${candidato.objeto}-votos">
										${candidato.votos}<img src="/vav_plebiscito/app.imagenes/voto_cnn_negro.png" />
									</div>
									<div class="candidato-voto"></div>`

            //	Crear candidato en el listado
				render_candidatos.appendChild(objeto);

			//	Aumentar el Orden
				if( id_orden <= 5 )
				{
					id_orden++;
				}
            });

		//	Asignar posición 2 en pantalla
			if( posicion == 1 )
			{
				if( app_template != 0 )
				{
					App.animar_entrada_mesa_1();
				}
			}

		//	Asignar posición 2 en pantalla
			if( posicion == 2 )
			{
				if( app_template != 0 )
				{
					App.animar_entrada_mesa_2();
				}
			}
		},

	//	Asignar votos a un candidato
		voto : function( id , mesa, candidato, votos )
		{
		//	Actualizar votos en el DOM
			const candidato_voto = document.querySelector('#candidate-' + id + ' > div.candidato-votos');

		//	Validar que exista el elemento
			if( candidato_voto != null )
			{
			//	Identificar el contenedor del cambio de voto
				const candidato_div_voto_fondo = document.querySelector( '#candidate-' + id + ' > div.candidato-voto' );
				candidato_div_voto_fondo.classList.add('animar_voto');

				const candidato_div_voto_imagen = document.querySelector( '#candidate-' + id + ' > div.candidato-votos > img' );
				candidato_div_voto_imagen.classList.add('animar_voto_icono');

				candidato_voto.classList.add('animar_voto_texto')

			//	Reiniciar animación del voto
				setTimeout(function()
				{
					candidato_div_voto_fondo.classList.remove('animar_voto');
					candidato_div_voto_imagen.classList.remove('animar_voto_icono');
					candidato_voto.classList.remove('animar_voto_texto');
					
				}, tiempo_transiciones_adicional);

			//	Actualizar los valores
				setTimeout(function()
				{
					candidato_voto.innerHTML = votos + '<img src="/vav_plebiscito/app.imagenes/voto_cnn_negro.png" />';
				}, 500);

			//	Validar ID de la Mesa
				if( mesa == mesa_1.id)
				{
					const result = mesa_1.candidatos.find(({ objeto }) => objeto === id);
					result.votos = votos;

					App.ordenar_votos(mesa);
				}
				else
				{
					const result = mesa_2.candidatos.find(({ objeto }) => objeto === id);
					result.votos = votos;

					App.ordenar_votos(mesa);
				}
			}
			else
			{
				console.log('NO RENDER');
			}
		},

	//	Ordenar Votos de los candidatos
		ordenar_votos : function (mesa)
		{
		//	Mesa Candidatos por cambiar
			let mesa_candidatos
			let mesa_cupos

		//	Validar ID de la Mesa
			if( mesa == mesa_1.id )
			{
			//	Ordenar los candidatos por sus votos
				mesa_1.candidatos.sort((a, b) => (b.votos > a.votos) ? 1 : -1)

			//	Guardar Mesa
				mesa_candidatos = mesa_1.candidatos;
				mesa_cupos = mesa_1.cupos;
			}
			else
			{
			//	Ordenar los candidatos por sus votos
				mesa_2.candidatos.sort((a, b) => (b.votos > a.votos) ? 1 : -1)

			//	Guardar Mesa
				mesa_candidatos = mesa_2.candidatos;
				mesa_cupos = mesa_2.cupos;
			}

		//	Orden del candidato
			let orden = 1;

        //	Iterar listado de candidatos
			mesa_candidatos.forEach(candidato =>
            {
			//	Marcar candidato electo
				let marcar_candidato;

			// Validar candidatos marcados
				if( orden <= mesa_cupos )
				{
					marcar_candidato = 'electo';
				}
				else
				{
					marcar_candidato = 'no-electo';
				}

			//  Get object from DOM
				let candidato_div = document.querySelector(`#candidate-${candidato.objeto}`);
				candidato_div.classList = `candidato order-${orden} ${marcar_candidato}`;

			//	Aumentar el Orden
				if( orden <= 5 )
				{
					orden++;
				}
			});
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
			}, tiempo_transiciones_adicional / 2);
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

				}, tiempo_transiciones_adicional );
			}
			else
			{
			//	Limpiar mesa
				setTimeout(function()
				{
				//	Limpiar el Objeto
					mesa_2 = null

				//	Limpiar el DOM
					render_mesa_2.innerHTML = ''

				}, tiempo_transiciones_adicional );
			}
		},

	//	Obtener los cupos disponibles en la región
		obtener_cupos : function ( id )
		{
		//	Obtener información de la Región
			const region = objeto_regiones.find(({ i }) => i === Number(id));
			
		//	Cupos de los candidatos por región
			const cupos_region = region.c;

		//	Retornar los cupos
			return cupos_region
		}
	}

//	Iniciar las Zonas
	App.zone();