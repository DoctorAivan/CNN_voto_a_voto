//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	FUNCIONALIDAD PUBNUB SWICH
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Iniciar al Cargar
	$(function()
	{

	});

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

    //	Enviar Información a PubNub
    function enviarPubNub( parametro )
    {
        var publishConfig = {
            channel : "vav_mesas",
            message : parametro
        }

		pubnub.publish( publishConfig , function( status , response )
		{
		//	Validar Respuesta
			if( status.statusCode == 200 )
			{
	        //  Enviar Listado de Mesas
	            if( parametro.accion == 'listadoMesas' )
	            {

	            }

			//	Enviar un Voto
	            else if( parametro.accion == 'enviarVotos' )
	            {
				
	            }
			}
		})
    }

//	Objeto con los valores de Pubnub
	var datoPubNub              =   String();
	var pubNub					=	String();

//	Variables requeridas
	var accion					=	String();
	var mesa_id					=	Number();
	var mesa_voto_a				=	Number();
	var mesa_voto_r				=	Number();
	var mesa_voto_cm			=	Number();
	var mesa_voto_cc			=	Number();

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Iniciar Funcionalidad
	pubnub.addListener({
		message: function(message)
		{
		//	Obtener Datos desde Pubnub
			datoPubNub			=	message.message;
		}
	});

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Suscribirse al Canal
    pubnub.subscribe({
        channels: ['vav_mesas'],
        withPresence: true
    });

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Actualizar Votos de la Mesa
	function actualizarMesa()
	{
	//	Obtener los valores
		var mesa_id			=	1;
		var mesa_voto_a		=	1;
		var mesa_voto_r		=	1;
		var mesa_voto_cm	=	1;
		var mesa_voto_cc	=	1;

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

		});
	}
