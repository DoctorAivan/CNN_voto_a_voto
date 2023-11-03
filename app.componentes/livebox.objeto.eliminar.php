<!--	Livebox Eliminar Objeto -->		
		<div class="livebox" id="livebox-objeto-eliminar">
			<div onclick="cerrarLivebox();" class="livebox-cerrar"><i class="fas fa-times"></i></div>
			<header>
				<span><i class="far fa-trash-alt"></i></span>
				<h2 class="icono-on" id="objeto-eliminar-h2">Eliminar Mesa</h2>
				<h3 class="icono-on">Todos los datos relacionados serán eliminados</h3>
			</header>
			<footer>
				<div class="livebox-cargando">
					<i class="far fa-futbol"></i>
				</div>
				<div class="of" onclick="cerrarLivebox();">
					<h2>Cancelar</h2>
				</div>
				<div class="on" onclick="objetoEliminarConfirmar();">
					<h2>Confirmar</h2>
				</div>
			</footer>
		</div>

<!--	Livebox Duplicar Mesa Objeto -->		
		<div class="livebox" id="livebox-mesa-duplicar">
			<div onclick="cerrarLivebox();" class="livebox-cerrar"><i class="fas fa-times"></i></div>
			<header>
				<span><i class="far fa-copy"></i></span>
				<h2 class="icono-on" id="objeto-eliminar-h2">Duplicar Mesa</h2>
				<h3 class="icono-on">Todos los datos serán duplicados en un nuevo objeto</h3>
			</header>
			<footer>
				<div class="livebox-cargando">
					<i class="far fa-futbol"></i>
				</div>
				<div class="of" onclick="cerrarLivebox();">
					<h2>Cancelar</h2>
				</div>
				<div class="on" onclick="duplicarMesaConfirmar();">
					<h2>Confirmar</h2>
				</div>
			</footer>
		</div>

