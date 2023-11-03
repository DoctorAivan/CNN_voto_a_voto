//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	FUNCIONES DE LOS LISTADOS
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Obtener Valor Guardado
	var template	=	0;

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Iniciar al Cargar
	$(function()
	{
	//	Obtener Valor Guardado
		template		=	$.cookie('vav_template');

		if(template)
		{
			template	=	template;
		}
		else
		{
			template	=	1;
		}

	//	Aplicar Template
		cargarTemplate();
	});

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Aplicar Template
	function cambiarColor()
	{
		console.log(template);
				
		if(template == 1)
		{					
			// Create new link Element 
			var moon = document.createElement('link');
			
			$("#header-template").removeClass('fa-sun').addClass('fa-moon');
			
			moon.rel = 'stylesheet';  
			moon.type = 'text/css'; 
			moon.href = path_app + '/app.librerias/css/cis.moon.css?v=' + $.now();

			// link element to it  
			document.getElementsByTagName('HEAD')[0].appendChild(moon); 
			
			template = 0;
		}
		else
		{
			// Create new link Element 
			var sun = document.createElement('link');  
			
			$("#header-template").removeClass('fa-moon').addClass('fa-sun');
			
			sun.rel = 'stylesheet';  
			sun.type = 'text/css'; 
			sun.href = path_app + '/app.librerias/css/cis.sun.css?v=' + $.now();

			// link element to it  
			document.getElementsByTagName('HEAD')[0].appendChild(sun);  

			template = 1;
		}
		
	//	Almacenar Opcion en Cookie
		$.cookie('vav_template', template , { expires: 365, path: '/' });
	}
	
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Aplicar Template
	function cargarTemplate()
	{				
		if(template == 1)
		{					
			// Create new link Element 
			var sun = document.createElement('link');  
			
			$("#header-template").removeClass('fa-moon').addClass('fa-sun');
			
			sun.rel = 'stylesheet';  
			sun.type = 'text/css'; 
			sun.href = path_app + '/app.librerias/css/cis.sun.css?v=' + $.now();

			// link element to it  
			document.getElementsByTagName('HEAD')[0].appendChild(sun);  
		}
		else
		{					
			// Create new link Element 
			var moon = document.createElement('link');
			
			$("#header-template").removeClass('fa-sun').addClass('fa-moon');
			
			moon.rel = 'stylesheet';  
			moon.type = 'text/css'; 
			moon.href = path_app + '/app.librerias/css/cis.moon.css?v=' + $.now();

			// link element to it  
			document.getElementsByTagName('HEAD')[0].appendChild(moon); 
		}
	}