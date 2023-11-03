<!DOCTYPE html>
<html lang="es">
	<head>

		<!-- Librerias jQuery -->
		<script src="https://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>

		<!-- Librerias PubNub -->
        <script src="https://cdn.pubnub.com/sdk/javascript/pubnub.4.17.0.min.js"></script>
        
<!--	Funcionalidades por Defecto -->
		<script type="text/javascript">

		//	Pubnub Monitoreo de Mesas
		    pubnub				=	new PubNub({
				subscribeKey	:	"<?php echo $_PUBNUB_SUS_MESAS; ?>",
				publishKey		:	"<?php echo $_PUBNUB_PUB_MESAS; ?>"
			});
			
		//	Pubnub Monitoreo de Mesas
			pubnubMovil			=	new PubNub({
				subscribeKey	:	"<?php echo $_PUBNUB_SUS_MESAS; ?>",
				publishKey		:	"<?php echo $_PUBNUB_PUB_MESAS; ?>"
		    });

		</script>

<!--	Funcionalidad PubNub -->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>pubNub.movil.js<?php echo $_CONF_VERSION; ?>"></script>
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>pubNub.movil.acciones.js<?php echo $_CONF_VERSION; ?>"></script>

	</head>
	<body>

		<section class="main">
			
		</section>

	</body>
</html>