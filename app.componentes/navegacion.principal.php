		<nav class="nav-principal">
			<div class="box">
				<i class="fas fa-home"></i>
				<span>Voto&nbsp;a&nbsp;voto</span>
			</div>
<?php
		if( $_SESSION['usuario_rol'] == 'VZ' )
		{
?>
			<a href="<?php echo $_URL_MESA_SWICH_TOTEM; ?>" target="_blank">
				<div class="box">
					<i class="fas fa-tv"></i>
					<span>Ver&nbsp;Tótem</span>
				</div>
			</a>
			<a href="<?php echo $_URL_MESA_SWICH; ?>">
				<div class="box">
					<i class="fab fa-slideshare"></i>
					<span>Administrar&nbsp;Swich</span>
				</div>
			</a>
<?php
		}
		else if( $_SESSION['usuario_rol'] == 'OP' )
		{
?>
			<a href="<?php echo $_URL_MESA_OPERADOR; ?>">
				<div class="box">
					<i class="fas fa-person-booth"></i>
					<span>Administrar&nbsp;Mesas</span>
				</div>
			</a>
<?php
		}
		else if( $_SESSION['usuario_rol'] == 'AM' )
		{
?>
			<a href="<?php echo $_URL_MESA_VISUALIZADOR; ?>">
				<div class="box">
					<i class="fas fa-poll"></i>
					<span>Visualizador&nbsp;Mesas</span>
				</div>
			</a>
			<a href="<?php echo $_URL_MESA_LISTADO; ?>">
				<div class="box">
					<i class="fas fa-person-booth"></i>
					<span>Administrar&nbsp;Mesas</span>
				</div>
			</a>
			<a href="<?php echo $_URL_USUARIO_LISTADO; ?>">
				<div class="box">
					<i class="fas fa-users"></i>
					<span>Administrar&nbsp;Usuarios</span>
				</div>
			</a>
<?php
		}
		else
		{
?>
		<noscript>
			<a href="<?php echo $_URL_MONITOR_MOVILES; ?>">
				<div class="box">
				<i class="fas fa-mobile-alt"></i>
					<span>Monitor&nbsp;Moviles</span>
				</div>
			</a>
		</noscript>
			<a href="<?php echo $_URL_MESA_VISUALIZADOR_PUBLICO; ?>" target="_blank">
				<div class="box">
					<i class="fas fa-tachometer-alt"></i>
					<span>Visualizador&nbsp;Publico</span>
				</div>
			</a>
			<a href="<?php echo $_URL_MESA_VISUALIZADOR; ?>">
				<div class="box">
					<i class="fas fa-poll"></i>
					<span>Visualizador&nbsp;Mesas</span>
				</div>
			</a>
			<a href="<?php echo $_URL_MESA_SWICH_TOTEM; ?>" target="_blank">
				<div class="box">
					<i class="fas fa-tv"></i>
					<span>Visualizador&nbsp;vMix</span>
				</div>
			</a>
			<a href="<?php echo $_URL_MESA_SWICH; ?>">
				<div class="box">
					<i class="fab fa-slideshare"></i>
					<span>Administrar&nbsp;Swich</span>
				</div>
			</a>
			<a href="<?php echo $_URL_MESA_LISTADO; ?>">
				<div class="box">
					<i class="fas fa-person-booth"></i>
					<span>Administrar&nbsp;Mesas</span>
				</div>
			</a>
			<a href="<?php echo $_URL_USUARIO_LISTADO; ?>">
				<div class="box">
					<i class="fas fa-users"></i>
					<span>Administrar&nbsp;Usuarios</span>
				</div>
			</a>
<?php
		}
?>
		</nav>
