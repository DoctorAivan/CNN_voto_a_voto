//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	FUNCIONALIDAD PUBNUB PARA MOVILES
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//  Listado de Usarios
    var usuarios    =   {};

//  Notificación de Audio
    var audio       =   new Audio( path_app + 'app.librerias/audio/notificacion.ogg');

//	Iniciar al Cargar
    $(function()
    {
    //  Obtener Listado de Usuarios
        $.getJSON( path_app + "/usuarios/json/", function( data )
        {
        //  Agregar Usuarios
            usuarios    =   data;
        });
    });

//	Objeto con los valores de Pubnub
    var pubNubMovil				    =	String();

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Enviar Información a PubNub
    function enviarPubNubMovil( parametro )
    {
        var publishConfig = {
            channel : "vav_movil",
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
                //  Crear Objeto Debug
                    let obj   =   {
                        'metodo'    :   'POST',
                        'icono'     :   'fas fa-paper-plane',
                        'msg'       :   'Enviando el listado de mesas asignadas',
                        'usuario'   :   parametro.usuario
                    }

                //  Debug
                    debug( obj );
                }

            //	Enviar un Voto
                else if( parametro.accion == 'votoEnviar' )
                {
                
                }
            }
        })
    }

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//  Debugear Estados
    function debug( obj )
    {
    //  Crear objeto con la Fecha y Hora
        var date    =    new Date();

    //  Construir objeto 
        var dateStr     =   ("00" + (date.getMonth() + 1)).slice(-2) + "/" + ("00" + date.getDate()).slice(-2) + "/" + date.getFullYear() + " " + ("00" + date.getHours()).slice(-2) + ":" + ("00" + date.getMinutes()).slice(-2) + ":" + ("00" + date.getSeconds()).slice(-2);

    //  Infirmacion de Usuarios
        let usuario =   usuarios[obj.usuario];

    //  Crear Div
        let div     =   `<div class="box monitor nuevo-dato">
                            <div class="hora"><i class="fas fa-user"></i> ${usuario.nombre}</div>
                            <div class="icon"><i class="${obj.icono}"></i></div>
                            <div class="mensaje">${obj.msg}</div>
                            <div class="hora"><i class="fas fa-clock"></i> ${ dateStr }</div>
                        </div>`;

    //  Agregar Div a la Inteface
        $("#debug").prepend( div );

    //  Quitar mensaje de vacio
        $("#debug").find('.vacio').remove();

    //  Reproducir Sonido
        audio.pause();
        audio.currentTime = 0;
        audio.play();
    }

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//  Borrar Historial
    function borrarHistorial()
    {
        $("#debug").html('');

    //  Crear Div
        let div     =   `<div class="box vacio">
            Aun no existen notificaciones
        </div>`;

        //  Agregar Div a la Inteface
        $("#debug").prepend( div );
    }

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Iniciar Funcionalidad
    pubnubMovil.addListener(
    {
        message: function(message)
        {
        //	Obtener Datos desde Pubnub
            const datoPubNub		=	message.message;

        //  Obtener accion solicitada
            let accion			    =	datoPubNub.accion;

    //	    -		-		-		-		-		-		-		-		-		-		-		-		-		-		-

        //  Obtener el Listado de Mesas
            if( accion == 'obtenerMesas' )
            {
            //  Obtener ID del usuario
                let usuario     =	datoPubNub.usuario;

            //  Crear Objeto Debug
                let objDebug    =     {
                    'metodo'    :   'GET',
                    'icono'     :   'fas fa-chalkboard-teacher',
                    'msg'       :   'Solicitó el listado de mesas asignadas',
                    'usuario'   :   usuario
                }

            //  Debug
                debug( objDebug );

            //  Obtener Listado de mesas
                $.getJSON( path_app + '/movil/obtener-mesas/' + usuario , function( data )
                {
                //  Construir respuesta
                    let obj         =   {
                        'accion'    :   'listadoMesas',
                        'usuario'   :   usuario,
                        'mesas'     :   data
                    }

                //  Enviar listado de Mesas
                    enviarPubNubMovil(obj);
                });
            }

        //  Recibir votos de una Mesa
            else if( accion == 'votoEnviar' )
            {
            //  Obtener ID del usuario
                let usuario = datoPubNub.usuario;
                let mesa_id = datoPubNub.mesa;
                let voto_id = datoPubNub.candidato;
                let voto_total = datoPubNub.voto;

            //	Actualizar los votos de la Mesa
                $.post( path_app + '/mesas/voto/' ,
                {
                    mesa_id                     :   mesa_id,
                    voto_id                     :   voto_id,
                    voto_total                  :   voto_total
                })
                .done(function( dataBase )
                {
                //  Validar Respuesta de la DB
                    if( dataBase == 1 )
                    {
                    //	Construir Variable para enviar a PubNub
                        let pubnub       	=
                        {
                            'accion'		:	'voto',
                            'mesa'          :	mesa_id,
                            'id'            :   voto_id,
                            'valor'         :	voto_total
                        }

                    //	Enviar Notificación a PubNub
                        enviarPubNub( pubnub );
                    
                    //  Crear Objeto Debug
                        let objDebug    =   {
                            'metodo'    :   'POST',
                            'icono'     :   'fas fa-check-circle',
                            'msg'       :   'Votos actualizados en la <b>Mesa ' + datoPubNub.mesa + '</b>',
                            'usuario'   :   usuario
                        }

                    //  Debug
                        debug( objDebug );

                    //  Construir respuesta
                        let obj         =   {
                            'accion'    :   'votoRespuesta',
                            'usuario'   :   usuario,
                            'estado'    :   Number(1)
                        }

                    //  Enviar listado de Mesas
                        enviarPubNubMovil(obj);
                    }
                    else
                    {

                    }
                });
            }

        //  Activación de una mesa
            else if( accion == 'activarMesa' )
            {
                //	Actualizar los votos de la Mesa
                $.post( path_app + '/mesas/activar/' ,
                {
                    mesa_id			:	datoPubNub.mesa.id,
                    mesa_numero     :   datoPubNub.mesa.numero
                })
                .done(function( dataBase )
                {
                //  Validar Respuesta de la DB
                    if( dataBase == 1 )
                    {
                    //  Crear Objeto Debug
                        let objDebug    =   {
                            'metodo'    :   'POST',
                            'icono'     :   'fas fa-check-circle',
                            'msg'       :   'la <b>Mesa ' + datoPubNub.mesa.id + '</b> fue activada',
                            'usuario'   :   datoPubNub.usuario
                        }

                    //  Debug
                        debug( objDebug );

                    //  Construir respuesta
                        let obj_pub     =   {
                            'accion'    :   'recargar'
                        }

                    //	Enviar Notificación a PubNub
                        enviarPubNub( obj_pub );

                    //  -       -       -       -       -       -       -       -

                    //  Construir respuesta
                        let obj         =   {
                            'accion'    :   'activarMesaRespuesta',
                            'usuario'   :   datoPubNub.usuario
                        }

                    //  Enviar listado de Mesas
                        enviarPubNubMovil(obj);
                    }
                    else
                    {

                    }
                });
            }

        //  Editar una mesa
            else if( accion == 'editarMesa' )
            {
                //	Actualizar los votos de la Mesa
                $.post( path_app + '/mesas/activar/' ,
                {
                    mesa_id			:	datoPubNub.mesa.id,
                    mesa_numero     :   datoPubNub.mesa.numero
                })
                .done(function( dataBase )
                {
                //  Validar Respuesta de la DB
                    if( dataBase == 1 )
                    {
                    //  Crear Objeto Debug
                        let objDebug    =   {
                            'metodo'    :   'POST',
                            'icono'     :   'fas fa-check-circle',
                            'msg'       :   'la <b>Mesa ' + datoPubNub.mesa.id + '</b> fue editara',
                            'usuario'   :   datoPubNub.usuario
                        }

                    //  Debug
                        debug( objDebug );

                    //  Construir respuesta
                        let obj_pub     =   {
                            'accion'    :   'recargar'
                        }

                    //	Enviar Notificación a PubNub
                        enviarPubNub( obj_pub );

                    //  -       -       -       -       -       -       -       -

                    //  Construir respuesta
                        let obj         =   {
                            'accion'    :   'editarMesaRespuesta',
                            'usuario'   :   datoPubNub.usuario
                        }

                    //  Enviar listado de Mesas
                        enviarPubNubMovil(obj);
                    }
                    else
                    {

                    }
                });
            }
        }
    });

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Suscribirse al Canal
    pubnubMovil.subscribe({
        channels: ['vav_movil'],
        withPresence: true
    });