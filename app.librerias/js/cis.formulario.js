
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	FUNCIONES DE LOS FORMULARIOS
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Funcionalidad para elegir una Opcion
	function marcarListado( OBJETO )
	{
	//	Obtener ID del Contructor
		let PADRE	=	$( OBJETO ).parent().attr('data');

	//	Obtener ID del Objeto
		let ID		=	$( OBJETO ).attr('data');
		
	//	Obtener Valor del Objeto
		let VALOR	=	$( OBJETO ).text();

	//	Quitar Objeto Seleccionado
		$( "#form-listado-" + PADRE + " .listado-opciones-items > div" ).each(function()
		{
			$( this ).removeClass( "on" );
		});
		
	//	Marcar Objeto Seleccionado
		$( OBJETO ).addClass( "on" );

	//	Almacenar opción seleccionada en el Listado
		$( "#form-listado-" + PADRE + " .listado-opciones-actual").html( "<span>" + VALOR + "</span>" );
		
	//	Almacenar opción seleccionada
		$( "#" + PADRE ).val( ID );
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Funcionalidad para elegir una Opcion
	function marcarListadoOpcion( ID , OBJETO )
	{
	//	Quitar clase de selección
		$( ".listado-opciones-items > div" ).each(function()
		{
			$( this ).removeClass( "on" );
		});

	//	Agregar clase de selección
		$( "#" + ID + "_op_" + OBJETO ).addClass( "on" );

	//	Obtener Valor del Objeto
		let VALOR	=	$( "#" + ID + "_op_" + OBJETO ).text();

	//	Almacenar opción seleccionada en el Listado
		$( "#form-listado-" + ID + " .listado-opciones-actual").html( "<span>" + VALOR + "</span>" );
		
	//	Almacenar opción seleccionada
		$( "#" + ID ).val( OBJETO );
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Funcionalidad para elegir una Opcion
	function marcarOpcion( ID , OBJETO )
	{
	//	Quitar clase de selecciÃ³n
		$( "#form-opcion-" + ID + " > div" ).each(function()
		{
			$( this ).removeClass( "on" );
		});
		
	//	Agregar clase de selecciÃ³n
		$( "#" + ID + "-" + OBJETO ).addClass( "on" );
		
	//	Almacenar opciÃ³n seleccionada
		$( "#" + ID ).val( OBJETO );
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Iniciar al cargar
	$(document).ready(function()
	{		
	//	Asignar el valor seleccionado
		$( ".listado-opciones" ).each(function()
		{
			$( this ).find('.listado-opciones-actual').html('<span>' + $(this).find('.on').text() + '</span>');
		});
		
	//	Restricción para los Input
		$('.alfanumerico').keyup(function (event)
		{
			if (this.value.match(/[^A-Za-z0-9´ÑñÁáÉéÍíÓóÚú()-. ]/g))
			{
				this.value = this.value.replace(/[^A-Za-z0-9´ÑñÁáÉéÍíÓóÚú()-. ]/g, '');
			}
		});
		
	//	Restricción para los Input
		$('.numerico').keyup(function (event)
		{
			if (this.value.match(/[^0-9]/g))
			{
				this.value = this.value.replace(/[^0-9]/g, '');
			}
		});
		
	//	Restricción para los Input
		$('.email').keyup(function (event)
		{
			if (this.value.match(/[^A-Za-z0-9_.@-]/g))
			{
				this.value = this.value.replace(/[^A-Za-z0-9_.@-]/g, '');
			}
		});
	});