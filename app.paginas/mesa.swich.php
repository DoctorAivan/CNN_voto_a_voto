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
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>jquery.sorteable.js<?php echo $_CONF_VERSION; ?>"></script>

<!--	Librerias -->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>cis.listado.js<?php echo $_CONF_VERSION; ?>"></script>
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>cis.listado.css<?php echo $_CONF_VERSION; ?>"/>
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>cis.formulario.css<?php echo $_CONF_VERSION; ?>"/>

<!--	Librerias Jquery -->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>jquery.timeago.js<?php echo $_CONF_VERSION; ?>"></script>

<!--	Librerias Tipsy -->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>jquery.tipsy.js<?php echo $_CONF_VERSION; ?>"></script>
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>jquery.tipsy.css<?php echo $_CONF_VERSION; ?>"/>
		
<!--	Librerias PubNub -->
        <script src="https://cdn.pubnub.com/sdk/javascript/pubnub.4.17.0.min.js"></script>
        
<!--	Funcionalidades por Defecto -->
		<script type="text/javascript">

		//	Mesas Almacenadas
			var swich_modo		=	<?php echo $_SWICH->swich_modo; ?>;
			var swich_mesas		=	<?php echo $_SWICH->swich_mesas; ?>;
			var swich_mesa_1	=	<?php echo $_SWICH->swich_mesa_1; ?>;
			var swich_mesa_2	=	<?php echo $_SWICH->swich_mesa_2; ?>;
			var swich_mesa_3	=	<?php echo $_SWICH->swich_mesa_3; ?>;
			var swich_mesa_4	=	<?php echo $_SWICH->swich_mesa_4; ?>;
			var swich_votos		=	0;

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

<!--	Funcionalidad PubNub -->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>pubNub.mesas.swich.js<?php echo $_CONF_VERSION; ?>"></script>

<!--	Librerias Administrar Swich -->
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>vav.swich.css<?php echo $_CONF_VERSION; ?>"/>

	</head>
	<body>

<?php

	//	Navegacion
		include_once "$_COMPONENTES/navegacion.principal.php";

	//	Header
		include_once "$_COMPONENTES/header.php";

?>

		<section class="main">
			
			<section class="main-cnt cols x1 margin-bottom">
				<section class="bg-blanco box-shadow bordes-radius crop">
					<header class="titulo-seccion no-border">
						<div class="icono"><i class="fab fa-slideshare"></i></div>
						<h2 class="icono-on">Administrar Swich</h2>
						<h3 class="icono-on">Listado completo de mesas</h3>

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
			<section class="main-cnt swich">
				<section class="swich-l">
					<section class="swich-l-scroll relacionados cols x4" id="mesas">
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
					<article class="mesa mesa-swich bg-blanco box-shadow bordes-radius filtro-mesa <?php echo $_MESA->mesa_tipo; ?>" id="<?php echo $_OBJETO_TIPO.$_MESA->mesa_id; ?>" mesa="<?php echo $_MESA->mesa_id; ?>" date="<?php echo $_MESA->mesa_cambio; ?>">
						<div class="cambios bordes-radius"></div>
						<div class="destacado">
<?php
					if($_MESA->mesa_destacada == 1)
					{
?>
							<i class="fas fa-star"></i>
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
							<h6 class="line-1" id="<?php echo $_MESA->mesa_id; ?>_mesa_cambio"><time class="timeago line-1" data="<?php echo $_MESA->mesa_id; ?>" datetime="<?php echo $_MESA->mesa_cambio; ?>"></time></h6>
						</header>
					</article>
<?php
							$_ID++;
						}
					}
?>
					</section>
				</section>
				<section class="swich-r">
					<section class="swich-r-cnt cols x2" id="mesas-swich">
						<div class="swich-r-box box-shadow" id="swich-mesa-1">
							<div class="swich-r-box-opciones" onclick="vaciarEspacio(1);">
								<h2>MESA 1</h2>
								<h3><i class="fas fa-times-circle"></i></h3>
							</div>
							<div class="swich-espacio cols x1 relacionados" id="mesa-1"></div>
						</div>
						<div class="swich-r-box box-shadow" id="swich-mesa-2">
							<div class="swich-r-box-opciones" onclick="vaciarEspacio(2);">
								<h2>MESA 2</h2>
								<h3><i class="fas fa-times-circle"></i></h3>
							</div>
							<div class="swich-espacio cols x1 relacionados" id="mesa-2"></div>
						</div>
						<div class="swich-r-box box-shadow" id="swich-mesa-3" style="display:none;">
							<div class="swich-r-box-opciones" onclick="vaciarEspacio(3);">
								<h2>MESA 3</h2>
								<h3><i class="fas fa-times-circle"></i></h3>
							</div>
							<div class="swich-espacio cols x1 relacionados" id="mesa-3"></div>
						</div>
						<div class="swich-r-box box-shadow" id="swich-mesa-4" style="display:none;">
							<div class="swich-r-box-opciones" onclick="vaciarEspacio(4);">
								<h2>MESA 4</h2>
								<h3><i class="fas fa-times-circle"></i></h3>
							</div>
							<div class="swich-espacio cols x1 relacionados" id="mesa-4"></div>
						</div>

						<div class="swich-r-box swich-nav box-shadow">
							<div class="swich-mesas" id="swich-opcion-modo">
								<h2>Template</h2>
								<div onclick="swichModo(0);" id="swich-opcion-modo-0" class="bordes-radius box-shadow-light of tipsy-top" title="<h2>Modo Tótem</h2><p>Desplegada a la izquierda</p>"><i class="fas fa-window-restore"></i></div>
								<div onclick="swichModo(1);" id="swich-opcion-modo-1" class="bordes-radius box-shadow-light of tipsy-top" title="<h2>Modo Flotante</h2><p>Desplegada en el centro</p>"><i class="fas fa-window-maximize"></i></div>
							</div>
							<div class="swich-separador"></div>
							<div class="swich-mesas" id="swich-opcion-mesas">
								<h2>Cantidad de Mesas</h2>
								<div onclick="swichMesas(0);" id="swich-opcion-mesas-0" class="bordes-radius box-shadow-light of tipsy-top" title="<h2>Template Sin Mesas</h2><p>Se ocultaran todas las Mesas</p>"><i class="fas fa-ban"></i></div>
								<div onclick="swichMesas(1);" id="swich-opcion-mesas-1" class="bordes-radius box-shadow-light of tipsy-top" title="<h2>Template 1 Mesa</h2><p>Se mostrara en pantalla 1 Mesa</p>">1</div>
								<div onclick="swichMesas(2);" id="swich-opcion-mesas-2" class="bordes-radius box-shadow-light of tipsy-top" title="<h2>Template 2 Mesa</h2><p>Se mostrara en pantalla 2 Mesa</p>">2</div>
							</div>
							<div class="swich-separador"></div>
							<div class="swich-controles">
								<h2>Visualización en pantalla</h2>
								<noscript>
									<div class="preview bordes-radius" onclick="swichPreview();">PREVIEW</div>
								</noscript>
								<div id="cambios-on" class="on bordes-radius" onclick="swichGuardar();">PUBLICAR</div>
								<div id="cambios-of" class="of bordes-radius">PUBLICAR</div>
							</div>
						</div>

						<div class="swich-r-box swich-nav box-shadow">
							<div class="swich-consolidados">
								<noscript>
								<div>
									<div class="swich-consolidados-titulo">Mostrar total de Mesas</div>
									<div class="swich-consolidados-items">
										<div id="consolidados-posicion-l" class="item on" onclick="posicionConsolidados('l');">OCULTO</div>
										<div id="consolidados-posicion-r" class="item of" onclick="posicionConsolidados('r');">VISIBLE</div>
									</div>
								</div>
								</noscript>
								<div>
									<div class="swich-consolidados-titulo">Resultado Parcial CNN</div>
									<div class="swich-consolidados-items">
										<div id="consolidados-estado-of" class="item on" onclick="estadoConsolidados('of');"><i class="far fa-eye-slash"></i> &nbsp;&nbsp;OCULTO</div>
										<div id="consolidados-estado-on" class="item of" onclick="estadoConsolidados('on');"><i class="fas fa-eye"></i> &nbsp;&nbsp;VISIBLE</div>
									</div>
								</div>
							</div>
						</div>

					</section>
				</section>
			</section>	
		</section>

<?php

	//	Footer
	//	include_once "$_COMPONENTES/footer.php";

?>

	</body>
</html>