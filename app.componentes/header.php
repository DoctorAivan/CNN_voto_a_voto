		<header class="bg-blanco main header box-shadow">
			<div class="main-cnt">
				<div class="header-logo">
					<i class="fas fa-vote-yea"></i>
					<h1>VAV</h1>
					<h2>
						Voto a Voto : Convención Constitucional 2023<br>
						<span>Warner Media Discovery - Chile</span>
					</h2>
				</div>
				<div class="header-usuario">
					<div class="header-usuario-info">
						<div class="header-usuario-info-imagen"><img src="<?php echo objetoPoster( $_SESSION['usuario_poster'] , 'USU' , 80 ); ?>" /></div>
						<div class="header-usuario-info-nombre">
							<h2><?php echo $_SESSION['usuario_nombre']; ?></h2>
							<h3><i class="fas fa-id-badge"></i> <?php echo usuario_rol( $_SESSION['usuario_rol'] ); ?></h3>
						</div>
					</div>
					<div class="header-usuario-opciones">
						<i class="fas fa-moon tipsy-bottom" id="header-template" title="Cambiar Template" onclick="cambiarColor();"></i>
						<a href="<?php echo $_URL_SESION_SALIR; ?>">
							<i class="fas fa-sign-out-alt tipsy-bottom" title="Salir"></i>
						</a>
					</div>
				</div>
			</div>
		</header>