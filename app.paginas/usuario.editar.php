<!DOCTYPE html>
<html lang="es">
	<head>

<?php

	//	Etiquetas Metags
		include_once "$_COMPONENTES/head.metatags.php";

	//	Librerias JS y CSS globales
		include_once "$_COMPONENTES/librerias.js.css.php";

?>

		<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

		<!-- Formularios -->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>cis.formulario.js<?php echo $_CONF_VERSION; ?>"></script>
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>cis.formulario.tags.js<?php echo $_CONF_VERSION; ?>"></script>
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>cis.formulario.fotografias.js<?php echo $_CONF_VERSION; ?>"></script>
		
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>cis.formulario.css<?php echo $_CONF_VERSION; ?>"/>
		
		<!-- Livebox -->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>livebox.js<?php echo $_CONF_VERSION; ?>"></script>
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>livebox.css<?php echo $_CONF_VERSION; ?>"/>

		<!-- Datepicker -->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>jquery.datepicker.js<?php echo $_CONF_VERSION; ?>"></script>
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>jquery.datepicker.css<?php echo $_CONF_VERSION; ?>"/>
		
		<!-- Tipsy -->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>jquery.tipsy.js<?php echo $_CONF_VERSION; ?>"></script>
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>jquery.tipsy.css<?php echo $_CONF_VERSION; ?>"/>
		
		<!-- Funcionalidades Gestor de Imagenes -->
		<script src="<?php echo $_LIBRERIAS_JS; ?>jquery.ui.widget.js"></script>
		<script src="<?php echo $_LIBRERIAS_JS; ?>jquery.iframe-transport.js"></script>
		<script src="<?php echo $_LIBRERIAS_JS; ?>jquery.fileupload.js"></script>
		
		<script>
			
			var imagen_objeto	=	<?php echo $_USUARIO->usuario_id; ?>;

			$( function()
			{
				$("#datepicker").datepicker({
					'format': 'yyyy-mm-dd',
					'todayHighlight': true,
					'autoclose': false
				});
			});

		</script>

	</head>
	<body>

<?php

	//	Navegacion
		include_once "$_COMPONENTES/navegacion.principal.php";

	//	Header
		include_once "$_COMPONENTES/header.php";
		
	//	Livebox Funcionalidad Fotografías
		include_once "$_COMPONENTES/livebox.fotografias.php";

	//	Livebox Fondo
		include_once "$_COMPONENTES/livebox.bg.php";

?>

		<section class="main">
			
			<form action="<?php echo $_URL_USUARIO_EDITAR_GUARDAR; ?>" name="form-usuario-nuevo" id="form-usuario-nuevo" method="post" enctype="multipart/form-data">			
			
			<section class="main-cnt cols x1 margin-bottom">
				<section class="bg-blanco box-shadow bordes-radius">
					<header class="titulo-seccion">
						<div class="icono"><i class="fas fa-user"></i></div>
						<h2 class="icono-on">Editar Usuario</h2>
						<h3 class="icono-on">Modifica la configuración de la cuenta</h3>
						<div class="opciones">
							<div class="input">
								<label>
									<div>Guardar<br>y Salir</div><input type="checkbox" name="abandonar" value="salir" />
								</label>
							</div>
							<button type="submit" class="boton nuevo box-shadow-light bordes-radius"><i class="fas fa-save"></i> Guardar</button>
							<a href="<?php echo $_URL_USUARIO_LISTADO; ?>">
								<div class="boton eliminar box-shadow-light bordes-radius"><i class="fas fa-ban"></i> Salir</div>
							</a>
						</div>
					</header>
				</section>
			</section>
			
			<section class="main-cnt cols x3">
				<section class="bg-blanco box-shadow bordes-radius">
					<header class="titulo-formulario">
						<span><i class="fas fa-user-alt"></i></span>
						<h2>Información Personal</h2>
						<h3>Completa todos los campos del formulario</h3>
					</header>
					<section class="formulario bg-1">
						<div class="col-1">
							<h2>Nombre <span>Obligatorio</span></h2>
							<input name="usuario_nombre" placeholder="Juan Pablo Martinez" type="text" class="alfanumerico box-shadow-light bordes-radius" value="<?php echo $_USUARIO->usuario_nombre; ?>" />
						</div>
						<div class="col-1">						
							<h2>Genero <span>Obligatorio</span></h2>
<?php
						//	Generar Listado de Objetos seleccionables
						//	Configuración 	[ Id Objeto ] , [ Actual ] , [ Array ] , [ Posición TollTip ]
							generarOpciones( 'icono' , 'usuario_genero' , $_USUARIO->usuario_genero , $_ARRAY_USUARIO_GENERO , 'top' );
?>
						</div>
						<div class="col-1">						
							<h2>Selecciona una Etiqueta <span>Opcional</span></h2>
<?php
						//	Generar Listado de Objetos seleccionables
						//	Configuración 	[ Id Objeto ] , [ Actual ] , [ Array ] , [ Posición TollTip ]
							generarOpciones( 'clase' , 'usuario_etiqueta' , $_USUARIO->usuario_etiqueta , $_ARRAY_FORMULARIO_ETIQUETAS , 'top' );
?>
						</div>
					</section>
				</section>
				<section class="bg-blanco box-shadow bordes-radius">
					<header class="titulo-formulario">
						<span><i class="fas fa-lock"></i></span>
						<h2>Credenciales de Acceso</h2>
						<h3>Configuración de la Cuenta</h3>
					</header>
					<section class="formulario bg-1">
						<div class="col-1">
							<h2>Correo Electronico <span>Obligatorio</span></h2>
							<input name="usuario_email" type="text" autocomplete="nope" class="box-shadow-light bordes-radius" value="<?php echo $_USUARIO->usuario_email; ?>" placeholder="juan.pablo.martinez@turner.com" />
						</div>
						<div class="col-2">
							<h2>Password <span>Obligatorio</span></h2>
							<input name="usuario_password[]" type="password" autocomplete="new-password" placeholder="******" class="box-shadow-light bordes-radius" />
						</div>
						<div class="col-2">
							<h2>Re Password<span>Obligatorio</span></h2>
							<input name="usuario_password[]" type="password" autocomplete="new-password" placeholder="******" class="box-shadow-light bordes-radius" />
						</div>
					</section>
					<header class="titulo-formulario titulo-formulario-border">
						<span><i class="fas fa-shield-alt"></i></span>
						<h2>Usuarios Disponibles</h2>
						<h3>Listado completo de usuarios</h3>
					</header>
					<section class="formulario bg-1">
						<div class="col-1">						
							<h2>Titulo de Prueba <span>Obligatorio</span></h2>
<?php
						//	Generar Listado de Objetos seleccionables
						//	Configuración 	[ Id Objeto ] , [ Actual ] , [ Array ] , [ Posición TollTip ]
							generarOpciones( 'texto' , 'usuario_rol' , $_USUARIO->usuario_rol , $_ARRAY_USUARIO_ROLES , 'top' );
?>
						</div>
					</section>
				</section>
				<section class="bg-blanco box-shadow bordes-radius">
					<header class="titulo-formulario">
						<span><i class="fas fa-image"></i></span>
						<h2>Administrar las Imagenes</h2>
						<h3>Listado completo de usuarios</h3>
						<div class="opciones">
							<div class="boton editar box-shadow-light bordes-radius" onclick="fotografiaNueva();"><i class="fas fa-cloud-upload-alt"></i> Subir</div>
						</div>
					</header>
					<section class="fotografias-cargando">
						<div class="fotografias-cargando-barra box-shadow-light bordes-radius">
							<div class="fotografias-cargando-barra-bg"></div>
						</div>
					</section>
					<section class="fotografias bg-1" id="fotografias">
<?php
					//	Generar Listado de Imagenes Relacionadas
					//	Configuración 	[ Array ] , [ Tipo ] , [ Tamaño ]
						generarImagenes( $_ARRAY_IMAGENES , 'USU' , 80 );
?>
					</section>
					<input type="hidden" name="objeto_fotografias" id="objeto-fotografias" class="objeto-fotografias" />
					<header class="titulo-formulario">
						<span><i class="fas fa-info"></i></span>
						<h2>Información recomendada</h2>
						<h3>Listado completo de usuarios</h3>
					</header>
					<section class="formulario">
						<div class="col-1">
							<h2>Titulo de Prueba <span>Obligatorio</span></h2>
							<label>
								<i class="fas fa-file-image"></i> <span>Solo podrás subir imagenes en <b>formato JPG</b></span>
							</label>
							<label>
								<i class="fas fa-server"></i> <span>Archivos con un tamaño máximo de <b>5 Megas</b></span>
							</label>
							<label>
								<i class="far fa-object-ungroup"></i> <span>Serán generadas copias reducidas</span>
							</label>
							<label>
								<i class="fas fa-tag"></i> <span>Recuerda agregar información a las imágenes</span>
							</label>
						</div>
					</section>
				</section>
			</section>

			<input type="hidden" name="usuario_id" value="<?php echo $_USUARIO->usuario_id; ?>" />
			</form>

		</section>
		
		<form id="fotografia-subir-archivo" method="post" action="<?php echo $_URL_OBJETO_IMAGEN_NUEVA; ?>" enctype="multipart/form-data">
			<input id="fotografia-subir-archivo-input" type="file" name="upl" accept="image/x-png,image/gif,image/jpeg" style="display:none;" />
			<input type="hidden" name="imagen_objeto" value="<?php echo $_USUARIO->usuario_id; ?>" />
			<input type="hidden" name="imagen_tipo" value="USU" />
		</form>

<?php

	//	Footer
		include_once "$_COMPONENTES/footer.php";

?>

	</body>
</html>