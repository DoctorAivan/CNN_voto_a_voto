<!DOCTYPE html>
<html lang="es">
	<head>

<?php

	//	Etiquetas Metags
		include_once "$_COMPONENTES/head.metatags.php";

	//	Librerias JS y CSS globales
		include_once "$_COMPONENTES/librerias.js.css.php";

?>

<!--	Libreria Listados	-->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>cis.listado.js<?php echo $_CONF_VERSION; ?>"></script>
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>cis.listado.css<?php echo $_CONF_VERSION; ?>"/>
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>cis.formulario.css<?php echo $_CONF_VERSION; ?>"/>

<!--	Livebox	-->		
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>livebox.js<?php echo $_CONF_VERSION; ?>"></script>
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>livebox.css<?php echo $_CONF_VERSION; ?>"/>

		<script>
			
			$(function()
			{
				liveboxAbrir('iniciar-sesion');
			});
			
			function iniciarSesion()
			{
				$( "#form-iniciar-sesion" ).submit();
			}

		</script>

	</head>
	<body>

		<form action="<?php echo $_URL_SESION_VALIDAR; ?>" autocomplete="off" name="form-iniciar-sesion" id="form-iniciar-sesion" method="post" enctype="application/x-www-form-urlencoded">			

<!--	Livebox Editar Fotografia -->		
		<div class="livebox" id="livebox-iniciar-sesion" style="width: 420px;">
			<header>
				<span><i class="fas fa-user-lock"></i></span>
				<h2 class="icono-on">Voto a Voto</h2>
				<h3 class="icono-on">Iniciar sesión para continuar</h3>
			</header>
			<article class="formulario bg-1">
				<div class="col-1">
					<h2>Correo Electronico <span>Obligatorio</span></h2>
					<input name="usuario_email" type="text" autocomplete="off" class="box-shadow-light bordes-radius" placeholder="juan.pablo.martinez@turner.com" />
				</div>
				<div class="col-1">
					<h2>Password <span>Obligatorio</span></h2>
					<input name="usuario_password" type="password" autocomplete="off" placeholder="******" class="box-shadow-light bordes-radius" />
				</div>
			</article>
			<footer>
				<div class="livebox-cargando">
					<i class="far fa-futbol"></i>
				</div>
				<div class="on" onclick="iniciarSesion();">
					<h2>Ingresar</h2>
				</div>
				<div class="of">
					<h2>Cancelar</h2>
				</div>
			</footer>
		</div>
		
		</form>
		
<!--	Livebox Fondo -->
		<div class="livebox-bg"></div>

	</body>
</html>