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

<!--	Livebox	-->		
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>livebox.js<?php echo $_CONF_VERSION; ?>"></script>
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>livebox.css<?php echo $_CONF_VERSION; ?>"/>

	</head>
	<body>

<?php

	//	Navegacion
		include_once "$_COMPONENTES/navegacion.principal.php";

	//	Header
		include_once "$_COMPONENTES/header.php";

	//	Livebox Objeto Eliminar
		include_once "$_COMPONENTES/livebox.objeto.eliminar.php";

	//	Livebox Fondo
		include_once "$_COMPONENTES/livebox.bg.php";

?>

		<section class="main">
			
			<section class="main-cnt cols x1 margin-bottom">
				<section class="bg-blanco box-shadow bordes-radius crop">
					<header class="titulo-seccion no-border">
						<div class="icono"><i class="fas fa-users"></i></div>
						<h2 class="icono-on">Usuarios Disponibles</h2>
						<h3 class="icono-on">Listado completo de usuarios</h3>
						<div class="opciones">
							<a href="<?php echo $_URL_USUARIO_NUEVO; ?>">
								<div class="boton nuevo box-shadow-light bordes-radius"><i class="fas fa-plus-circle"></i> Nuevo Usuario</div>
							</a>
						</div>
					</header>
				</section>
			</section>
			
			<section class="main-cnt cols x1">
				<section class="bg-blanco box-shadow bordes-radius crop">
					<div class="lista lista-usuarios">
						<div class="box titulo">
							<div class="texto"></div>
							<div class="texto">Estado</div>
							<div class="texto"></div>
							<div class="texto">Nombre</div>
							<div class="texto">Rol</div>
							<div class="texto">Último ingreso</div>
							<div class="texto">Fecha de Creación</div>
							<div class="texto"></div>
						</div>
<?php
				//	ID del Listado
					$_ID								=	1;

				//	Tipo de Objeto
					$_OBJETO_TIPO						=	'USU';

				//	Listado de Objetos Disponibles
					while($_USUARIO						=	pg_fetch_object($QUERY_USUARIO))
					{
?>
						<div class="box" id="<?php echo $_OBJETO_TIPO.$_USUARIO->usuario_id; ?>">
							<div class="id"><?php echo ( $CONF_PAGINA_ACTUAL * $CCNF_MAX_PAGINAS ) + $_ID; ?></div>
							<div class="estado estado-<?php echo $_USUARIO->usuario_estado; ?> box-shadow-light" id="<?php echo $_USUARIO->usuario_id; ?>">
								<div onclick="objetoEstado( <?php echo $_USUARIO->usuario_id; ?> , '<?php echo $_OBJETO_TIPO; ?>' );"></div>
							</div>
							<div class="img crop box-shadow-light bordes-radius">
								<img src="<?php echo objetoPoster( $_USUARIO->usuario_poster , $_OBJETO_TIPO , 80 ); ?>" />
							</div>
							<div class="texto bold color-principal"><?php echo $_USUARIO->usuario_nombre; ?></div>
							<div class="texto icono color-verde">
								<i class="fas fa-id-badge"></i> <?php echo usuario_rol($_USUARIO->usuario_rol); ?>
							</div>
							<div class="texto icono color-secundario"><i class="far fa-clock"></i> Hace <?php echo tiempoTranscurrido($_USUARIO->usuario_login); ?></div>
							<div class="texto icono color-gris"><i class="far fa-calendar"></i> <?php echo creacion($_USUARIO->usuario_creado , 1); ?></div>
							<div class="opciones">
								<a href="<?php echo $_URL_USUARIO_EDITAR.$_USUARIO->usuario_id; ?>">
									<div class="boton boton-editar box-shadow-light bordes-radius"><i class="fas fa-highlighter"></i> Editar</div>
								</a>
								<div onclick="objetoEliminar( <?php echo $_USUARIO->usuario_id; ?> , '<?php echo $_OBJETO_TIPO; ?>' );" class="boton boton-eliminar box-shadow-light bordes-radius"><i class="fas fa-minus-circle"></i> Eliminar</div>
							</div>
						</div>
<?php
						$_ID++;
					}
?>
					</div>
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