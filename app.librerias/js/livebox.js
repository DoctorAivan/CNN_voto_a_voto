//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	FUNCIONALIDAD LIVEBOX
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Velocidad de la animacion
	var ANIMATION_TIME						=	"normal";

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Cerrar Funcionalidad Livebox
	function liveboxAbrir( DIV )
	{
	//	Quitar scroll del body
		$("body").css("overflow","hidden");
		
	//	Obtener Alto del Contenedor
		var alto_div	=	Number($("#livebox-" +  DIV).height()) / 2;
		var ancho_div	=	Number($("#livebox-" +  DIV).width()) / 2;

	//	Asignar nueva posicion
		$("#livebox-" +  DIV).css("top","calc( 50% - " + alto_div + "px )");
		$("#livebox-" +  DIV).css("left","calc( 50% - " + ancho_div + "px )");
		
	//	Mostrar el Background Oscuro
		$( ".livebox-bg" ).fadeIn( ANIMATION_TIME , function()
		{
		//	Mostrar el Contenedor seleccionado
			$("#livebox-" +  DIV).fadeIn( ANIMATION_TIME );
		});
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Mostrar Usabilidad Cargando
	function liveboxCargando()
	{
		$( ".livebox-bloqueado" ).fadeIn( ANIMATION_TIME );
		$( ".livebox-cargando" ).fadeIn( ANIMATION_TIME );
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Quitar Usabilidad Cargando
	function liveboxCargandoCompleto()
	{
		$( ".livebox-bloqueado" ).fadeOut( ANIMATION_TIME );
		$( ".livebox-cargando" ).fadeOut( ANIMATION_TIME );
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-	

//	Accion del Livebox
	function liveboxAccion( accion )
	{
	//	Ocultar todas las acciones
		$( ".livebox-accion" ).each(function()
		{
			$(this).css("display","none");
		});

	//	Mostrar la accion solocitada		
		$( ".livebox ." + accion ).css("display","block");
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Cerrar Funcionalidad Livebox
	function liveboxCerrar()
	{
	//	Mostrar el Background Oscuro
		$( ".livebox" ).fadeOut( ANIMATION_TIME , function()
		{
		//	Mostrar el Contenedor seleccionado
			$( ".livebox-bg" ).fadeOut( ANIMATION_TIME );
			
		//	Mostrar el Background Oscuro
			$( ".livebox-bg" ).fadeOut( ANIMATION_TIME , function()
			{
			//	Quitar scroll del body
				$("body").css("overflow","auto");

			//	Ocultar funcionalidad de Precarga 
				$( ".livebox-cargando" ).fadeOut( 0 );

			//	Quitar Usabilidad Cargando
				liveboxCargandoCompleto();
			});
		});
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Cambiar de Livebox
	function liveboxCambio()
	{
	//	Quitar otros contenedores
		$( ".livebox" ).fadeOut( ANIMATION_TIME );
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Modificar Ancho del Livebox
	function liveboxAncho( DIV , PIXELES )
	{
		$("#livebox-" + DIV).css("width", PIXELES + "px");

		liveboxPosicionar();
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Recalcular Posición Funcionalidad Livebox
	function liveboxPosicionar()
	{
	//	Validar Tag Duplucado
		$( '.livebox' ).each(function()
		{
			var livebox			=	$( this );
			
		//	Obtener Alto del Contenedor
			var livebox_alto	=	livebox.height() / 2;
			var livebox_ancho	=	livebox.width() / 2;
	
		//	Asignar nueva posicion
			livebox.css("top","calc( 50% - " + livebox_alto + "px )");
			livebox.css("left","calc( 50% - " + livebox_ancho + "px )");
		});
	}
