		<!-- Informacion General -->
		<title><?php echo $_SEO['TITLE']; ?></title>
		<meta name="description" content="<?php echo $_SEO['DESCRIPCION']; ?>"/>
		<meta name="keywords" content="<?php echo $_SEO['KEYWORDS']; ?>"/>
	    <meta name="author" content="<?php echo $_SEO['AUTOR']; ?>" />
		<meta name="copyright"content="<?php echo $_CONF_TITULO; ?>">
		<meta name="apple-mobile-web-app-title" content="CIS">

<?php
	//	Comprobar acceso de Robots
		if($_SEO['ROBOTS'] == "true")
		{
?>
		<!-- Robots Activos -->
	    <meta name="Googlebot" content="all"/>
	    <meta name="revisit-after" content="1 days"/>
	    <meta name="robots" content="index,follow"/>
		<meta name="language" content="ES">
<?php
		}else{
?>
		<!-- Robots Inactivos -->
	    <meta name="Googlebot" content="noindex"/>
	    <meta name="robots" content="noindex,nofollow"/>
		<meta name="language" content="ES">
<?php
		}
?>

		<!-- Tags de Configuracion -->
		<meta name="html" content="text/html;" http-equiv="content-type" charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

