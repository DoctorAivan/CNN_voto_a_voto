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
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>vav.mesas.js<?php echo $_CONF_VERSION; ?>"></script>

		<!-- Libreria Autocomplate -->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>jquery.autocomplete.js"></script>

<!--	Libreria Listados	-->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>cis.listado.js<?php echo $_CONF_VERSION; ?>"></script>
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>cis.formulario.js<?php echo $_CONF_VERSION; ?>"></script>
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>cis.listado.css<?php echo $_CONF_VERSION; ?>"/>
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>cis.formulario.css<?php echo $_CONF_VERSION; ?>"/>

<!--	Livebox	-->		
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>livebox.js<?php echo $_CONF_VERSION; ?>"></script>
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>livebox.css<?php echo $_CONF_VERSION; ?>"/>

		<!-- Tipsy -->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>jquery.tipsy.js<?php echo $_CONF_VERSION; ?>"></script>
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>jquery.tipsy.css<?php echo $_CONF_VERSION; ?>"/>
		
		<!-- Librerias PubNub -->
        <script src="https://cdn.pubnub.com/sdk/javascript/pubnub.4.17.0.min.js"></script>
        
<!--	Funcionalidades por Defecto -->
		<script type="text/javascript">

		//	Pubnub Monitoreo de Mesas
            pubnub = new PubNub({
				subscribeKey	:	"<?php echo $_PUBNUB_SUS_MESAS; ?>",
				publishKey		:	"<?php echo $_PUBNUB_PUB_MESAS; ?>"
            });

		//	Enviar Información a PubNub
            function enviarPubNub( parametro )
            {
				var publishConfig = {
					channel : "vav_mesas",
					message : parametro
				}
				pubnub.publish( publishConfig , function( status , response )
				{
					
				})
            }

		</script>

	</head>
	<body>

<?php

	//	Navegacion
		include_once "$_COMPONENTES/navegacion.principal.php";

	//	Header
		include_once "$_COMPONENTES/header.php";

	//	Livebox Objeto Eliminar
		include_once "$_COMPONENTES/livebox.objeto.eliminar.php";

	//	Livebox Editar Mesa
		include_once "$_COMPONENTES/livebox.mesa.php";

	//	Livebox Fondo
		include_once "$_COMPONENTES/livebox.bg.php";

?>

		<section class="main">
			
			<section class="main-cnt cols x1 margin-bottom">
				<section class="bg-blanco box-shadow bordes-radius crop">
					<header class="titulo-seccion no-border">
						<div class="icono"><i class="fas fa-person-booth"></i></div>
						<h2 class="icono-on">Administrar Mesas</h2>
						<h3 class="icono-on">Listado completo de mesas creadas</h3>
						<div class="opciones">
							<div class="input">
								<label>
									<div>Filtrar<br>Mesas</div>
								</label>
							</div>
							<div class="boton activo box-shadow-light bordes-radius tipsy-top" id="opcion-voto-P" title="Constituyentes" onclick="mesa_filtrar('P');">🟡</div>
							<div class="separador"></div>
							<div class="boton boton-sin-margen editar box-shadow-light bordes-radius" onclick="mesa_nueva();"><i class="fas fa-plus-circle"></i> Nueva Mesa</div>

							<noscript>
								<div class="boton activo box-shadow-light bordes-radius tipsy-top" id="opcion-voto-1" title="Gobernadores" onclick="mesa_filtrar(1);"><i class="fas fa-university"></i></div>
								<div class="boton nuevo box-shadow-light bordes-radius tipsy-top" id="opcion-voto-2" title="Alcaldes" onclick="mesa_filtrar(2);"><i class="fas fa-user"></i></div>
								<div class="boton nuevo box-shadow-light bordes-radius tipsy-top" id="opcion-voto-3" title="Concejales" onclick="mesa_filtrar(3);"><i class="fas fa-users"></i></div>
								<div class="boton nuevo box-shadow-light bordes-radius tipsy-top" id="opcion-voto-4" title="Constituyentes" onclick="mesa_filtrar(4);"><i class="fas fa-book"></i></div>
								<div class="separador"></div>
								<div class="boton editar box-shadow-light bordes-radius" onclick="mesa_nueva();"><i class="fas fa-plus-circle"></i> Nueva Mesa</div>
							</noscript>
						</div>
					</header>
				</section>
			</section>
			
			<section class="main-cnt cols x5 margin-bottom" id="mesas">
<?php
			//	ID del Listado
				$_ID								=	1;

			//	Listado de Objetos Disponibles
				while($_MESA						=	pg_fetch_object($QUERY_MESAS))
				{
					$mesa_tipo_titulo				=	obtener_titulo($_MESA->mesa_tipo);
					$mesa_tipo_icono				=	obtener_icono($_MESA->mesa_tipo);
?>
				<article class="filtro-mesa mesa estado-<?php echo $_MESA->mesa_estado; ?> <?php echo $_MESA->mesa_tipo; ?> bg-blanco box-shadow bordes-radius gris" id="mesa-<?php echo $_MESA->mesa_id; ?>" data="<?php echo $_MESA->mesa_id; ?>">
					<div class="opciones bordes-radius box-shadow-light">
						<i class="fas fa-highlighter tipsy-top" title="<h2>Modificar Mesa</h2><p>Podrás modificar la información de la Mesa y los Votos asociados.</p>" onclick="mesa_detalles( <?php echo $_MESA->mesa_id; ?> );"></i>
						<i class="fas fa-copy tipsy-top invisible" title="<h2>Duplicar Mesa</h2><p>Podrás duplicar la información de la Mesa y los Votos asociados.</p>" onclick="duplicarMesa( <?php echo $_MESA->mesa_id; ?> );"></i>
						<i class="fas fa-trash-alt tipsy-top"  title="<h2>Eliminar Mesa</h2><p>La Mesa será eliminada junto a toda la información relacionada.</p>" onclick="mesa_eliminar( <?php echo $_MESA->mesa_id; ?> );"></i>
					</div>

					<header>

						<noscript>
						<div onclick="mesaDestacada( <?php echo $_MESA->mesa_id; ?> );" class="estado estado-<?php echo $_MESA->mesa_destacada; ?> box-shadow-light" id="<?php echo $_MESA->mesa_id; ?>">
							<div></div>
						</div>
						</noscript>

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
						<h6 class="line-1" id="<?php echo $_MESA->mesa_id; ?>_mesa_cambio"><i class="fas fa-clock"></i> Actualizado hace <?php echo tiempoTranscurrido($_MESA->mesa_cambio); ?></h6>
					</header>
				</article>
<?php
					$_ID++;
				}
?>
			</section>
			
			<section class="main-cnt cols x1">
				<section class="bg-blanco box-shadow bordes-radius crop">
					<div class="paginacion">
<?php

					//	Paginacion
						include_once "$_COMPONENTES/listados.paginacion.php";

?>

					</div>
				</section>
			</section>
		</section>

<?php

	//	Footer
		include_once "$_COMPONENTES/footer.php";

?>

	</body>
</html>