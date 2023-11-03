<!DOCTYPE html>
<html lang="es">
	<head>

<?php

	//	Etiquetas Metags
		include_once "$_COMPONENTES/head.metatags.php";

	//	Librerias JS y CSS globales
		include_once "$_COMPONENTES/librerias.js.css.php";

?>

		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>cis.listado.css<?php echo $_CONF_VERSION; ?>"/>

	</head>
	<body>

<?php

	//	Navegacion Principal
		include_once "$_COMPONENTES/navegacion.principal.php";
		
	//	Header Principal
		include_once "$_COMPONENTES/header.php";

?>

		<section class="main margin-bottom">
			<header class="titulo-principal">
				<figure class="box-shadow">
					<i class="fas fa-shield-alt"></i>
				</figure>
				<h2 class="logo">Titulo Sección</h2>
				<h3 class="logo">Información adicional del titulo</h3>
				<div class="opciones">
					<div class="boton boton-nuevo box-shadow bordes-radius"><i class="fas fa-plus-circle"></i> Nuevo</div>
					<div class="boton boton-nuevo box-shadow bordes-radius"><i class="fas fa-plus-circle"></i> Nuevo</div>
				</div>
			</header>
			<section class="main-cnt cols x7">
				<article class="jugador crop bg-blanco box-shadow bordes-radius">
					<figure>
						<div class="trama"></div>
						<img src="/cis/app.borrar/01.png" />
					</figure>
					<header>
						<span class="box-shadow">8</span>
						<h2 class="line-1">Maximiliano <b>Fernancillo</b></h2>
						<h3 class="line-1">Delantero</h3>
						<h4 class="line-1"><i class="fas fa-shield-alt"></i> Universidad de Chile</h3>
					</header>
				</article>
				<article class="jugador crop bg-blanco box-shadow bordes-radius">
					<figure>
						<div class="trama"></div>
						<img src="/cis/app.borrar/02.png" />
					</figure>
					<header>
						<span class="box-shadow">7</span>
						<h2 class="line-1">Lionel <b>Messi</b></h2>
						<h3 class="line-1">Delantero</h3>
						<h4 class="line-1"><i class="fas fa-shield-alt"></i> Barcelona</h3>
					</header>
				</article>
				<article class="jugador crop bg-blanco box-shadow bordes-radius">
					<figure>
						<div class="trama"></div>
						<img src="/cis/app.borrar/03.png" />
					</figure>
					<header>
						<span class="box-shadow">11</span>
						<h2 class="line-1">Lionel <b>Messi</b></h2>
						<h3 class="line-1">Delantero</h3>
						<h4 class="line-1"><i class="fas fa-shield-alt"></i> Barcelona</h3>
					</header>
				</article>
				<article class="jugador crop bg-blanco box-shadow bordes-radius">
					<figure>
						<div class="trama"></div>
						<img src="/cis/app.borrar/04.png" />
					</figure>
					<header>
						<span class="box-shadow">14</span>
						<h2 class="line-1">Lionel <b>Messi</b></h2>
						<h3 class="line-1">Delantero</h3>
						<h4 class="line-1"><i class="fas fa-shield-alt"></i> Barcelona</h3>
					</header>
				</article>
				<article class="jugador crop bg-blanco box-shadow bordes-radius">
					<figure>
						<div class="trama"></div>
						<img src="/cis/app.borrar/05.png" />
					</figure>
					<header>
						<span class="box-shadow">7</span>
						<h2 class="line-1">Lionel <b>Messi</b></h2>
						<h3 class="line-1">Delantero</h3>
						<h4 class="line-1"><i class="fas fa-shield-alt"></i> Barcelona</h3>
					</header>
				</article>
				<article class="jugador crop bg-blanco box-shadow bordes-radius">
					<figure>
						<div class="trama"></div>
						<img src="/cis/app.borrar/06.png" />
					</figure>
					<header>
						<span class="box-shadow">3</span>
						<h2 class="line-1">Lionel <b>Messi</b></h2>
						<h3 class="line-1">Delantero</h3>
						<h4 class="line-1"><i class="fas fa-shield-alt"></i> Barcelona</h3>
					</header>
				</article>
				<article class="jugador crop bg-blanco box-shadow bordes-radius">
					<figure>
						<div class="trama"></div>
						<img src="/cis/app.borrar/07.png" />
					</figure>
					<header>
						<span class="box-shadow">17</span>
						<h2 class="line-1">Lionel <b>Messi</b></h2>
						<h3 class="line-1">Delantero</h3>
						<h4 class="line-1"><i class="fas fa-shield-alt"></i> Barcelona</h3>
					</header>
				</article>
			</section>
		</section>
		
		<section class="main margin-bottom">
			<header class="titulo-principal">
				<figure class="box-shadow">
					<i class="fas fa-shield-alt"></i>
				</figure>
				<h2 class="logo">Torneo Nacional 2020</h2>
				<h3 class="logo">Campeonato de Fútbol Propesional</h3>
				<div class="opciones">
					<div class="boton boton-nuevo box-shadow bordes-radius"><i class="fas fa-plus-circle"></i> Nuevo</div>
					<div class="boton boton-nuevo box-shadow bordes-radius"><i class="fas fa-plus-circle"></i> Nuevo</div>
				</div>
			</header>
			<section class="main-cnt torneo-fixture">
				<div class="torneo-fixture-bg box-shadow-light bordes-radius">
					<div class="torneo-fixture-bg-progreso"></div>
				</div>
				<article>
					<figure class="on box-shadow-light"></figure>
					<h2>Fecha</h2>
					<h3>1</h3>
				</article>
				<article>
					<figure class="on box-shadow-light"></figure>
					<h2>Fecha</h2>
					<h3>2</h3>
				</article>
				<article>
					<figure class="on box-shadow-light"></figure>
					<h2>Fecha</h2>
					<h3>3</h3>
				</article>
				<article>
					<figure class="on box-shadow-light"></figure>
					<h2>Fecha</h2>
					<h3>4</h3>
				</article>
				<article>
					<figure class="on box-shadow-light"></figure>
					<h2>Fecha</h2>
					<h3>5</h3>
				</article>
				<article>
					<figure class="box-shadow-light"></figure>
					<h2>Fecha</h2>
					<h3>6</h3>
				</article>
				<article>
					<figure class="box-shadow-light"></figure>
					<h2>Fecha</h2>
					<h3>7</h3>
				</article>
				<article>
					<figure class="box-shadow-light"></figure>
					<h2>Fecha</h2>
					<h3>8</h3>
				</article>
				<article>
					<figure class="box-shadow-light"></figure>
					<h2>Fecha</h2>
					<h3>9</h3>
				</article>
				<article>
					<figure class="box-shadow-light"></figure>
					<h2>Fecha</h2>
					<h3>10</h3>
				</article>
			</section>
		</section>
		
		<section class="main margin-bottom">
			<header class="titulo-principal">
				<figure class="box-shadow">
					<i class="fas fa-shield-alt"></i>
				</figure>
				<h2 class="logo">Torneo Nacional 2020</h2>
				<h3 class="logo">Campeonato de Fútbol Propesional</h3>
				<div class="opciones">
					<div class="boton boton-nuevo box-shadow bordes-radius"><i class="fas fa-plus-circle"></i> Nuevo</div>
					<div class="boton boton-nuevo box-shadow bordes-radius"><i class="fas fa-plus-circle"></i> Nuevo</div>
				</div>
			</header>
			<section class="main-cnt cols x3">
				<article class="partido crop bg-blanco box-shadow bordes-radius">
					<header>
						<h2 class="line-1">Torneo Nacional 2020</h2>
						<h3 class="line-1">Fixture Quinta Fecha</h2>
					</header>
					<div class="equipo">
						<figure>
							<img src="/cis/app.borrar/equipo.01.png" />
						</figure>
						<h2 class="line-1">U. de Chile</h2>
						<h3>Local</h3>
					</div>
					<div class="goles">2 <span>:</span> 0</div>
					<div class="estado confirmar box-shadow-light bordes-radius">Confirmar</div>
					<div class="equipo">
						<figure>
							<img src="/cis/app.borrar/equipo.02.png" />
						</figure>
						<h2 class="line-1">Colo - Colo</h2>
						<h3>Visita</h3>
					</div>
					<footer>
						<h2 class="line-1">Sábado 20 de noviembre <span>20:30 Hrs</span></h2>
					</footer>
				</article>
				<article class="partido crop bg-blanco box-shadow bordes-radius">
					<header>
						<h2 class="line-1">Torneo Nacional 2020</h2>
						<h3 class="line-1">Fixture Quinta Fecha</h2>
					</header>
					<div class="equipo">
						<figure>
							<img src="/cis/app.borrar/equipo.03.png" />
						</figure>
						<h2 class="line-1">O'Higgins</h2>
						<h3>Local</h3>
					</div>
					<div class="goles">2 <span>:</span> 0</div>
					<div class="estado jugando box-shadow-light bordes-radius"><i class="fas fa-microphone"></i> En vivo</div>
					<div class="equipo">
						<figure>
							<img src="/cis/app.borrar/equipo.04.png" />
						</figure>
						<h2 class="line-1">U. Española</h2>
						<h3>Visita</h3>
					</div>
					<footer>
						<h2 class="line-1">Sábado 20 de noviembre <span>20:30 Hrs</span></h2>
					</footer>
				</article>
				<article class="partido crop bg-blanco box-shadow bordes-radius">
					<header>
						<h2 class="line-1">Torneo Nacional 2020</h2>
						<h3 class="line-1">Fixture Quinta Fecha</h2>
					</header>
					<div class="equipo">
						<figure>
							<i class="fas fa-shield-alt"></i>
						</figure>
						<h2 class="line-1">U. de Chile</h2>
						<h3>Local</h3>
					</div>
					<div class="goles">2 <span>:</span> 0</div>
					<div class="estado terminado box-shadow-light bordes-radius">Terminado</div>
					<div class="equipo">
						<figure>
							<i class="fas fa-shield-alt"></i>
						</figure>
						<h2 class="line-1">Colo - Colo</h2>
						<h3>Visita</h3>
					</div>
					<footer>
						<h2 class="line-1">Sábado 20 de noviembre <span>20:30 Hrs</span></h2>
					</footer>
				</article>
			</section>
		</section>

		<section class="main margin-bottom">
			<section class="main-cnt cols x1">
				<section class="bg-blanco box-shadow bordes-radius">
					<header class="titulo-seccion">
						<h2>Partidos Disponibles</h2>
						<h3>Información adicional del titulo</h3>
						<div class="opciones">
							<div class="boton nuevo box-shadow-light bordes-radius"><i class="fas fa-plus-circle"></i> Nuevo</div>
						</div>
					</header>
					<div class="lista lista-partidos">
						<div class="box titulo">
							<div class="lista-partidos-titulo"></div>
							<div class="lista-partidos-titulo">Estado</div>
							<div class="lista-partidos-titulo">Fecha</div>
							<div class="lista-partidos-titulo">Hora</div>
							<div class="lista-partidos-titulo">Equipo Local</div>
							<div class="lista-partidos-titulo"></div>
							<div class="lista-partidos-titulo">Goles</div>
							<div class="lista-partidos-titulo"></i></div>
							<div class="lista-partidos-titulo">Equipo Visita</div>
							<div class="lista-partidos-titulo">Estadio</div>
							<div class="lista-partidos-titulo">Opciones</div>
						</div>
						<div class="box">
							<div class="id">1</div>
							<div class="lista-partidos-estado confirmar box-shadow-light bordes-radius"><i class="far fa-clipboard"></i> Por confirmar</div>
							<div class="lista-partidos-fecha icono"><i class="far fa-calendar-alt"></i> 20 / 01 / 2020</div>
							<div class="lista-partidos-hora icono"><i class="far fa-clock"></i> 20:30 Hrs</div>
							<div class="lista-partidos-local">Palestino</div>
							<div class="lista-partidos-escudo"><i class="fas fa-shield-alt"></i></div>
							<div class="lista-partidos-goles">0 <span>:</span> 0</div>
							<div class="lista-partidos-escudo"><i class="fas fa-shield-alt"></i></div>
							<div class="lista-partidos-visita">Cobreloa</div>
							<div class="lista-partidos-estadio icono"><i class="fas fa-ring"></i> Estadio La Florida</div>
							<div class="opciones">
								<div class="boton boton-editar box-shadow-light bordes-radius"><i class="fas fa-highlighter"></i></div>
								<div class="boton boton-nuevo box-shadow-light bordes-radius"><i class="far fa-eye"></i></div>
							</div>
						</div>
						<div class="box">
							<div class="id">1</div>
							<div class="lista-partidos-estado jugando box-shadow-light bordes-radius"><i class="fas fa-microphone"></i> Primer Tiempo</div>
							<div class="lista-partidos-fecha icono"><i class="far fa-calendar-alt"></i> 20 / 01 / 2020</div>
							<div class="lista-partidos-hora icono"><i class="far fa-clock"></i> 20:30 Hrs</div>
							<div class="lista-partidos-local">Everton</div>
							<div class="lista-partidos-escudo"><i class="fas fa-shield-alt"></i></div>
							<div class="lista-partidos-goles">1 <span>:</span> 1</div>
							<div class="lista-partidos-escudo"><i class="fas fa-shield-alt"></i></div>
							<div class="lista-partidos-visita">Wanders</div>
							<div class="lista-partidos-estadio icono"><i class="fas fa-ring"></i> Estadio Sausalito</div>
							<div class="opciones">
								<div class="boton boton-editar box-shadow-light bordes-radius"><i class="fas fa-highlighter"></i></div>
								<div class="boton boton-nuevo box-shadow-light bordes-radius"><i class="far fa-eye"></i></div>
							</div>
						</div>
						<div class="box">
							<div class="id">2</div>
							<div class="lista-partidos-estado terminado box-shadow-light bordes-radius"><i class="fas fa-check-circle"></i> Finalizado</div>
							<div class="lista-partidos-fecha icono"><i class="far fa-calendar-alt"></i> 20 / 01 / 2020</div>
							<div class="lista-partidos-hora icono"><i class="far fa-clock"></i> 20:30 Hrs</div>
							<div class="lista-partidos-local ganador">Universidad de Chile</div>
							<div class="lista-partidos-escudo"><i class="fas fa-shield-alt"></i></div>
							<div class="lista-partidos-goles">3 <span>:</span> 0</div>
							<div class="lista-partidos-escudo"><i class="fas fa-shield-alt"></i></div>
							<div class="lista-partidos-visita">Universidad Católica</div>
							<div class="lista-partidos-estadio icono"><i class="fas fa-ring"></i> Estadio Nacional</div>
							<div class="opciones">
								<div class="boton boton-editar box-shadow-light bordes-radius"><i class="fas fa-highlighter"></i></div>
								<div class="boton boton-nuevo box-shadow-light bordes-radius"><i class="far fa-eye"></i></div>
							</div>
						</div>
						<div class="box">
							<div class="id">3</div>
							<div class="lista-partidos-estado terminado box-shadow-light bordes-radius"><i class="fas fa-check-circle"></i> Finalizado</div>
							<div class="lista-partidos-fecha icono"><i class="far fa-calendar-alt"></i> 20 / 01 / 2020</div>
							<div class="lista-partidos-hora icono"><i class="far fa-clock"></i> 20:30 Hrs</div>
							<div class="lista-partidos-local">Colo - Colo</div>
							<div class="lista-partidos-escudo"><i class="fas fa-shield-alt"></i></div>
							<div class="lista-partidos-goles">1 <span>:</span> 2</div>
							<div class="lista-partidos-escudo"><i class="fas fa-shield-alt"></i></div>
							<div class="lista-partidos-visita ganador">Union Española</div>
							<div class="lista-partidos-estadio icono"><i class="fas fa-ring"></i> Estadio Monumental</div>
							<div class="opciones">
								<div class="boton boton-editar box-shadow-light bordes-radius"><i class="fas fa-highlighter"></i></div>
								<div class="boton boton-nuevo box-shadow-light bordes-radius"><i class="far fa-eye"></i></div>
							</div>
						</div>
					</div>
				</section>
			</section>
		</section>

		<section class="main margin-bottom">
			<section class="main-cnt cols x1">
				<section class="bg-blanco box-shadow bordes-radius">
					<header class="titulo-seccion">
						<h2>Titulo Sección</h2>
						<h3>Información adicional del titulo</h3>
						<div class="opciones">
							<div class="boton nuevo box-shadow-light bordes-radius"><i class="fas fa-plus-circle"></i> Nuevo</div>
						</div>
					</header>
					<div class="lista basico">
						<div class="box">
							<div class="id">10</div>
							<div class="img box-shadow-light bordes-radius"></div>
							<div class="texto nombre">Nombre Objeto</div>
							<div class="texto">Fecha Publicación</div>
							<div class="opciones">
								<div class="boton boton-editar box-shadow-light bordes-radius"><i class="fas fa-highlighter"></i> Editar</div>
								<div class="boton boton-eliminar box-shadow-light bordes-radius"><i class="fas fa-minus-circle"></i> Eliminar</div>
							</div>
						</div>
						<div class="box">
							<div class="id">10</div>
							<div class="img box-shadow-light bordes-radius"></div>
							<div class="texto nombre">Nombre Objeto</div>
							<div class="texto">Fecha Publicación</div>
							<div class="opciones">
								<div class="boton boton-editar box-shadow-light bordes-radius"><i class="fas fa-highlighter"></i> Editar</div>
								<div class="boton boton-eliminar box-shadow-light bordes-radius"><i class="fas fa-minus-circle"></i> Eliminar</div>
							</div>
						</div>
						<div class="box">
							<div class="id">10</div>
							<div class="img box-shadow-light bordes-radius"></div>
							<div class="texto nombre">Nombre Objeto</div>
							<div class="texto">Fecha Publicación</div>
							<div class="opciones">
								<div class="boton boton-editar box-shadow-light bordes-radius"><i class="fas fa-highlighter"></i> Editar</div>
								<div class="boton boton-eliminar box-shadow-light bordes-radius"><i class="fas fa-minus-circle"></i> Eliminar</div>
							</div>
						</div>
					</div>
				</section>
			</section>
		</section>

		<section class="main">
			<section class="main-cnt cols x2">
				<section class="bg-blanco box-shadow bordes-radius">
					<header class="titulo-seccion">
						<h2>Titulo Sección</h2>
						<h3>Información adicional del titulo</h3>
						<div class="opciones">
							<div class="boton nuevo box-shadow-light bordes-radius"><i class="fas fa-plus-circle"></i> Nuevo</div>
						</div>
					</header>
					<div class="lista basico">
						<div class="box">
							<div class="id">10</div>
							<div class="img box-shadow-light bordes-radius"></div>
							<div class="texto nombre">Nombre Objeto</div>
							<div class="texto">Fecha Publicación</div>
							<div class="opciones">
								<div class="boton boton-editar box-shadow-light bordes-radius"><i class="fas fa-highlighter"></i> Editar</div>
								<div class="boton boton-eliminar box-shadow-light bordes-radius"><i class="fas fa-minus-circle"></i> Eliminar</div>
							</div>
						</div>
						<div class="box">
							<div class="id">10</div>
							<div class="img box-shadow-light bordes-radius"></div>
							<div class="texto nombre">Nombre Objeto</div>
							<div class="texto">Fecha Publicación</div>
							<div class="opciones">
								<div class="boton boton-editar box-shadow-light bordes-radius"><i class="fas fa-highlighter"></i> Editar</div>
								<div class="boton boton-eliminar box-shadow-light bordes-radius"><i class="fas fa-minus-circle"></i> Eliminar</div>
							</div>
						</div>
						<div class="box">
							<div class="id">10</div>
							<div class="img box-shadow-light bordes-radius"></div>
							<div class="texto nombre">Nombre Objeto</div>
							<div class="texto">Fecha Publicación</div>
							<div class="opciones">
								<div class="boton boton-editar box-shadow-light bordes-radius"><i class="fas fa-highlighter"></i> Editar</div>
								<div class="boton boton-eliminar box-shadow-light bordes-radius"><i class="fas fa-minus-circle"></i> Eliminar</div>
							</div>
						</div>
					</div>
				</section>
				<section class="bg-blanco box-shadow bordes-radius">
					<header class="titulo-seccion">
						<h2>Titulo Sección</h2>
						<h3>Información adicional del titulo</h3>
						<div class="opciones">
							<div class="boton nuevo box-shadow-light bordes-radius"><i class="fas fa-plus-circle"></i> Nuevo</div>
						</div>
					</header>
					<div class="lista basico">
						<div class="box">
							<div class="id">10</div>
							<div class="img box-shadow-light bordes-radius"></div>
							<div class="texto nombre">Nombre Objeto</div>
							<div class="texto">Fecha Publicación</div>
							<div class="opciones">
								<div class="boton boton-editar box-shadow-light bordes-radius"><i class="fas fa-highlighter"></i> Editar</div>
								<div class="boton boton-eliminar box-shadow-light bordes-radius"><i class="fas fa-minus-circle"></i> Eliminar</div>
							</div>
						</div>
						<div class="box">
							<div class="id">10</div>
							<div class="img box-shadow-light bordes-radius"></div>
							<div class="texto nombre">Nombre Objeto</div>
							<div class="texto">Fecha Publicación</div>
							<div class="opciones">
								<div class="boton boton-editar box-shadow-light bordes-radius"><i class="fas fa-highlighter"></i> Editar</div>
								<div class="boton boton-eliminar box-shadow-light bordes-radius"><i class="fas fa-minus-circle"></i> Eliminar</div>
							</div>
						</div>
						<div class="box">
							<div class="id">10</div>
							<div class="img box-shadow-light bordes-radius"></div>
							<div class="texto nombre">Nombre Objeto</div>
							<div class="texto">Fecha Publicación</div>
							<div class="opciones">
								<div class="boton boton-editar box-shadow-light bordes-radius"><i class="fas fa-highlighter"></i> Editar</div>
								<div class="boton boton-eliminar box-shadow-light bordes-radius"><i class="fas fa-minus-circle"></i> Eliminar</div>
							</div>
						</div>
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