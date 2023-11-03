<!--	Livebox Editar Fotografia -->		
		<div class="livebox" id="livebox-fotografia-editar">
			<div onclick="cerrarLivebox();" class="livebox-cerrar"><i class="fas fa-times"></i></div>
			<header>
				<span><i class="far fa-clipboard"></i></span>
				<h2 class="icono-on">Editar Fotografía</h2>
				<h3 class="icono-on">Completa más información de la imagen</h3>
			</header>
			<article class="formulario bg-1">
				<div class="col-1">
					<h2>Nombre <span>Obligatorio</span></h2>
					<input name="usuario_nombre" type="text" class="alfanumerico box-shadow-light bordes-radius" placeholder="Placeholder de Prueba" />
				</div>
			</article>
			<footer>
				<div class="livebox-cargando">
					<i class="far fa-futbol"></i>
				</div>
				<div class="on" onclick="fotografiaEliminarConfirmar();">
					<h2>Confirmar</h2>
				</div>
				<div class="of" onclick="cerrarLivebox();">
					<h2>Cancelar</h2>
				</div>
			</footer>
		</div>

<!--	Livebox Eliminar Fotografia -->		
		<div class="livebox" id="livebox-fotografia-eliminar">
			<div onclick="cerrarLivebox();" class="livebox-cerrar"><i class="fas fa-times"></i></div>
			<header>
				<span><i class="far fa-trash-alt"></i></span>
				<h2 class="icono-on">Eliminar Fotografía</h2>
				<h3 class="icono-on">Listado completo de usuarios</h3>
			</header>
			<footer>
				<div class="livebox-cargando">
					<i class="far fa-futbol"></i>
				</div>
				<div class="on" onclick="fotografiaEliminarConfirmar();">
					<h2>Confirmar</h2>
				</div>
				<div class="of" onclick="cerrarLivebox();">
					<h2>Cancelar</h2>
				</div>
			</footer>
		</div>
