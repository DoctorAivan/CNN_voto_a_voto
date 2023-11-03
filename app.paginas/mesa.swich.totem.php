<!DOCTYPE html>
<html lang="es">
	<head>

		<!-- Greensock Lib -->
		<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.8.0/gsap.min.js" integrity="sha512-eP6ippJojIKXKO8EPLtsUMS+/sAGHGo1UN/38swqZa1ypfcD4I0V/ac5G3VzaHfDaklFmQLEs51lhkkVaqg60Q==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

        <!-- Libreria Iconos Fontawesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.2/css/all.min.css" integrity="sha512-HK5fgLBL+xu6dm/Ii3z4xhlSUyZgTT9tuc/hSrtw6uzJOvgRr2a9jyxxT1ely+B+xFAmJKVSTbpM/CuL7qxO8w==" crossorigin="anonymous" />

		<!-- Librerias Highcharts -->
		<script src="https://code.highcharts.com/highcharts.js"></script>

		<!-- Librerias PubNub -->
        <script src="https://cdn.pubnub.com/sdk/javascript/pubnub.4.17.0.min.js"></script>

		<!-- Funcionalidades por Defecto -->
		<script type="text/javascript">

		//	Ruta principal de la APP
			const path_app = '<?php echo $_APP; ?>';

		//	Pubnub Monitoreo de Mesas
		    pubnub = new PubNub(
			{
				subscribeKey	:	"<?php echo $_PUBNUB_SUS_MESAS; ?>",
				publishKey		:	"<?php echo $_PUBNUB_PUB_MESAS; ?>"
		    });

		</script>

		<!-- Funcionalidades por Defecto -->
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>vav.swich.totem.css<?php echo $_CONF_VERSION; ?>"/>

	</head>
	<body>

		<div id="render">
			<div id="no-cursor"></div>

			<div id="render-mesa-1" class="tottem transition-on"></div>
			<div id="render-mesa-2" class="tottem transition-on"></div>

			<div id="bg-tottem"></div>
		</div>

		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>pubNub.swich.totem.js<?php echo $_CONF_VERSION; ?>"></script>

	</body>
</html>