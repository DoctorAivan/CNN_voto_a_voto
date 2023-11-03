<!DOCTYPE html>
<html lang="es">
	<head>

<?php

	//	Etiquetas Metags
		include_once "$_COMPONENTES/head.metatags.php";

	//	Librerias JS y CSS globales
		include_once "$_COMPONENTES/librerias.js.css.php";

?>

<!--	Libreria Funcionalidad Mesas	-->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>vav.mesas.js<?php echo $_CONF_VERSION; ?>"></script>

<!--	Librerias -->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>cis.listado.js<?php echo $_CONF_VERSION; ?>"></script>
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>cis.listado.css<?php echo $_CONF_VERSION; ?>"/>
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>cis.formulario.css<?php echo $_CONF_VERSION; ?>"/>

<!--	Librerias Jquery -->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>jquery.timeago.js<?php echo $_CONF_VERSION; ?>"></script>

<!--	Librerias LiveBox -->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>livebox.js<?php echo $_CONF_VERSION; ?>"></script>
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>livebox.css<?php echo $_CONF_VERSION; ?>"/>

<!--	Librerias Tipsy -->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>jquery.tipsy.js<?php echo $_CONF_VERSION; ?>"></script>
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>jquery.tipsy.css<?php echo $_CONF_VERSION; ?>"/>
		
<!--	Librerias PubNub -->
        <script src="https://cdn.pubnub.com/sdk/javascript/pubnub.4.17.0.min.js"></script>
        
<!--	Funcionalidades por Defecto -->
		<script type="text/javascript">

		//	Pubnub Monitoreo de Mesas
		    pubnub = new PubNub({
				subscribeKey	:	"<?php echo $_PUBNUB_SUS_MESAS; ?>",
				publishKey		:	"<?php echo $_PUBNUB_PUB_MESAS; ?>"
		    });
		    
		//	Iniciar al Cargar
			$(function()
			{
			//	Iniciar funcionalidad TimeAgo
				$("time.timeago").timeago();
			});
		
		</script>
		
<!--	Funcionalidad PubNub -->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>pubNub.mesas.visualizador.js<?php echo $_CONF_VERSION; ?>"></script>

<!--	Funcionalidad PubNub -->
		<style type="text/css">

			.rojo
			{
				
			}

		</style>

	</head>
	<body>

<?php

	//	Navegacion
		include_once "$_COMPONENTES/navegacion.principal.php";

	//	Header
		include_once "$_COMPONENTES/header.php";

	//	Livebox Fondo
		include_once "$_COMPONENTES/livebox.bg.php";

?>

		<section class="main">
			
			<section class="main-cnt cols x1 margin-bottom">
				<section class="bg-blanco box-shadow bordes-radius crop">
					<header class="titulo-seccion no-border">
						<div class="icono"><i class="fas fa-poll"></i></div>
						<h2 class="icono-on">Visualizador Mesas</h2>
						<h3 class="icono-on">Listado completo de mesas disponibles</h3>
						<div class="opciones">
							<div class="input">
								<label>
									<div>Filtrar<br>Mesas</div>
								</label>
							</div>
							<div class="boton activo box-shadow-light bordes-radius tipsy-top" id="opcion-voto-P" title="Plebiscito" onclick="mesa_filtrar('P');">🟡</div>
						</div>
					</header>
				</section>
			</section>
			
			<section class="main-cnt cols x5" id="mesas">
<?php

	//	ID del Listado
		$_ID								=	1;

	//	Tipo de Objeto
		$_OBJETO_TIPO						=	'MES';

	//	Listado de Objetos Disponibles
		while($_MESA						=	pg_fetch_object($QUERY_MESAS))
		{
		//	Ocultar Mesas Inactivas
			if($_MESA->mesa_estado != 0)
			{
				$mesa_tipo_titulo			=	obtener_titulo($_MESA->mesa_tipo);
				$mesa_tipo_icono			=	obtener_icono($_MESA->mesa_tipo);
?>
				<article class="filtro-mesa mesa bg-blanco box-shadow bordes-radius <?php echo $_MESA->mesa_tipo; ?>" id="<?php echo $_OBJETO_TIPO.$_MESA->mesa_id; ?>" data="<?php echo $_MESA->mesa_id; ?>" date="<?php echo $_MESA->mesa_cambio; ?>">
					<div class="cambios bordes-radius"></div>
					<div class="destacado">
						<i id="M<?php echo $_MESA->mesa_id; ?>" class="fas fa-mobile-alt"></i>
						<i id="D<?php echo $_MESA->mesa_id; ?>" class="fas fa-laptop"></i>
<?php
					if($_MESA->mesa_destacada == 1)
					{
?>
						<i class="fas fa-star tipsy-top"></i>
<?php
					}
					if($_MESA->mesa_estado == 2)
					{
?>
						<i class="fas fa-lock tipsy-top"></i>
<?php
					}
?>
					</div>
					<header>
						<h2><i class="fas fa-passport"></i> <?php echo $_MESA->mesa_id; ?></h2>
						<h1 class="line-1" id="<?php echo $_MESA->mesa_id; ?>_mesa_usuario"><i class="fas fa-user"></i> <?php echo $_MESA->usuario_nombre; ?></h1>
						<div class="tipo"><?php echo $mesa_tipo_titulo; ?></div>
						<div class="zona"><?php echo $_MESA->mesa_zona_titulo; ?></div>
						<h3 class="line-1" id="<?php echo $_MESA->mesa_id; ?>_mesa_nombre"><?php echo $_MESA->mesa_local; ?></h3>
<?php
					if( $_MESA->mesa_numero )
					{
?>
						<h4 class="line-1" id="<?php echo $_MESA->mesa_id; ?>_mesa_numero"><?php echo $_MESA->mesa_numero; ?></h4>
<?php
					}
					else
					{
?>
						<h4 class="line-1" id="<?php echo $_MESA->mesa_id; ?>_mesa_numero">-&nbsp;&nbsp;&nbsp;-&nbsp;&nbsp;&nbsp;-</h4>
<?php
					}
?>
						<h5 class="line-1" id="<?php echo $_MESA->mesa_id; ?>_mesa_ciudad"><i class="fas fa-globe-americas"></i> <?php echo $_MESA->mesa_comuna; ?></h5>
						<h6 class="line-1" id="<?php echo $_MESA->mesa_id; ?>_mesa_cambio"><time class="timeago" data="<?php echo $_MESA->mesa_id; ?>" datetime="<?php echo $_MESA->mesa_cambio; ?>"></time></h6>
					</header>
				</article>
<?php
				$_ID++;
			}
		}
?>
			</section>
		</section>

<?php

	//	Footer
		include_once "$_COMPONENTES/footer.php";

?>

	</body>
</html>