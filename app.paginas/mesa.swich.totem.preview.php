<!DOCTYPE html>
<html lang="es">
	<head>

<?php

	//	Etiquetas Metags
		include_once "$_COMPONENTES/head.metatags.php";

?>

		<!-- Librerias Javascript Principales -->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>jquery.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-easing/1.4.1/jquery.easing.min.js" integrity="sha512-0QbL0ph8Tc8g5bLhfVzSqxe9GERORsKhIn1IrpxDAgUsbBGz/V7iSav2zzW325XGd1OMLdL4UiqRJj702IeqnQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

		<!-- Fuentes -->
		<link href="https://fonts.googleapis.com/css2?family=Oswald:wght@200;300;400;500;600&display=swap" rel="stylesheet">

		<!-- Librerias PubNub -->
        <script src="https://cdn.pubnub.com/sdk/javascript/pubnub.4.17.0.min.js"></script>

		<!-- Funcionalidades por Defecto -->
		<script type="text/javascript">

		//	Pubnub Monitoreo de Mesas
		    pubnub = new PubNub(
			{
				subscribeKey	:	"<?php echo $_PUBNUB_SUS_MESAS; ?>",
				publishKey		:	"<?php echo $_PUBNUB_PUB_MESAS; ?>"
		    });

		</script>

<!--	Configuraciones -->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>vav.configuracion.js<?php echo $_CONF_VERSION; ?>"></script>

<!--	Funcionalidad PubNub -->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>pubNub.swich.totem.preview.js<?php echo $_CONF_VERSION; ?>"></script>

<!--	Librerias -->
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>vav.swich.totem.css<?php echo $_CONF_VERSION; ?>"/>

	</head>
	<body>

		<div id="swich">
			<div class="box-preview">PREVIEW</div>
			<div id="swich-template-0"></div>
			<div id="swich-template-1"></div>
			<div id="swich-template-2"></div>
			<div id="swich-template-3"></div>
		</div>

	</body>
</html>