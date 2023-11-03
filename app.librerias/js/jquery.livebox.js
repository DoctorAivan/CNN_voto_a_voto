//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	FUNCIONALIDAD LIVEBOX
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Velocidad de la animacion
	var ANIMACION						=	300;

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Cerrar Funcionalidad Livebox
	function abrirLivebox(DIV)
	{
	//	Obtener Alto del Contenedor
		var alto_div	=	Number($("#livebox-" +  DIV).height()) / 2;
		var ancho_div	=	Number($("#livebox-" +  DIV).width()) / 2;

	//	Asignar nueva posicion
		$("#livebox-" +  DIV).css("top","calc( 50% - " + alto_div + "px )");
		$("#livebox-" +  DIV).css("left","calc( 50% - " + ancho_div + "px )");
		
	//	Mostrar el Background Oscuro
		$( ".livebox-bg" ).fadeIn( ANIMACION , function()
		{
		//	Mostrar el Contenedor seleccionado
			$("#livebox-" +  DIV).fadeIn( ANIMACION );
		});
	}
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Cerrar Funcionalidad Livebox
	function cerrarLivebox()
	{
	//	Mostrar el Background Oscuro
		$( ".livebox" ).fadeOut( ANIMACION , function()
		{
		//	Mostrar el Contenedor seleccionado
			$( ".livebox-bg" ).fadeOut( ANIMACION );
		});
	}