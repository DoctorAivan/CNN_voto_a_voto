        <!--	Livebox Editar Mesa -->		
        <div class="livebox" id="livebox-mesa-editar" style="width: 800px;">
			<div class="livebox-bloqueado"></div>
			<div onclick="cerrarLivebox();" class="livebox-cerrar"><i class="fas fa-times"></i></div>
			<header>
				<div class="livebox-id"><span>20</span></div>
				<span style="width: 80px;"><i class="far fa-clipboard"></i></span>
				<h2 class="icono-on">Editar Mesa</h2>
				<h3 class="icono-on">Podrás modificar toda la información relacionada</h3>
			</header>
			<article class="formulario bg-1">
				<div class="col-3">						
					<h2>Estado <span>Obligatorio</span></h2>
<?php
				//	Generar Listado de Objetos seleccionables
				//	Configuración 	[ Id Objeto ] , [ Actual ] , [ Array ] , [ Posición TollTip ]
					generarOpciones( 'icono' , 'mesa_estado' , $_USUARIO->usuario_genero , $_ARRAY_ESTADO_MESAS , 'top' );
?>
				</div>
				<div class="col-3">						
					<h2>Dueño <span>Obligatorio</span></h2>
<?php
				//	Generar Listado de Objetos seleccionables
				//	Configuración 	[ Id Objeto ] , [ Actual ] , [ Array ]
					generarSelect( 'usuario_id' , 0 , $_ARRAY_USUARIOS );
?>
				</div>
				<div class="col-3">
					<h2>Numero Mesa <span>Obligatorio</span></h2>
					<input maxlength="20" name="mesa_numero" id="mesa_numero" type="text" autocomplete="off" class="alfanumerico box-shadow-light bordes-radius" placeholder="Mesa 25" />
				</div>
				<div class="col-3">
					<h2>Nombre Local <span>Obligatorio</span></h2>
					<input maxlength="20" name="mesa_nombre" id="mesa_nombre" type="text" autocomplete="new-password" class="alfanumerico box-shadow-light bordes-radius" placeholder="Estadio Nacional" />
				</div>
				<div class="col-3">
					<h2>Región <span>Obligatorio</span></h2>
					<input name="mesa_region" id="mesa_region" type="text" autocomplete="off" class="alfanumerico box-shadow-light bordes-radius" placeholder="R. Metropolitana" />
				</div>
				<div class="col-3">
					<h2>Ciudad <span>Obligatorio</span></h2>
					<input name="mesa_ciudad" id="mesa_ciudad" type="text" autocomplete="off" class="alfanumerico box-shadow-light bordes-radius" placeholder="Providencia" />
				</div>
			</article>
			<div class="votos-coinstitucion" onselectstart="return false">
				<header>
					<span><i class="fas fa-book"></i></span>
					<h2 class="icono-on">Constitución Política</h2>
					<h3 class="icono-on">Administrar Votación de Papeleta</h3>
				</header>
				<article class="formulario bg-1">
					<div class="col-2">
						<h2>Apruebo</h2>
						<div class="votos">
							<div class="votos-input">
								<input name="mesa_voto_a" id="mesa_voto_a" type="text" maxlength="3" autocomplete="off" class="alfanumerico box-shadow-light bordes-radius" placeholder="0" />
							</div>
							<div class="votos-sumar" onclick="votos( 'mesa_voto_a' , 'sumar' );"><i class="fas fa-plus-circle"></i></div>
							<div class="votos-restar" onclick="votos( 'mesa_voto_a' , 'restar' );"><i class="fas fa-minus-circle"></i></div>
						</div>
					</div>
					<div class="col-2">
						<h2>Rechazo</h2>
						<div class="votos">
							<div class="votos-input">
								<input name="mesa_voto_r" id="mesa_voto_r" type="text" maxlength="3" autocomplete="off" class="alfanumerico box-shadow-light bordes-radius" placeholder="0" />
							</div>
							<div class="votos-sumar" onclick="votos( 'mesa_voto_r' , 'sumar' );"><i class="fas fa-plus-circle"></i></div>
							<div class="votos-restar" onclick="votos( 'mesa_voto_r' , 'restar' );"><i class="fas fa-minus-circle"></i></div>
						</div>
					</div>
					<div class="col-3">
						<h2>Blancos</h2>
						<input name="mesa_voto_ar_blanco" id="mesa_voto_ar_blanco" type="text" maxlength="3" autocomplete="off" class="alfanumerico box-shadow-light bordes-radius" placeholder="0" />
					</div>
					<div class="col-3">
						<h2>Nulos</h2>
						<input name="mesa_voto_ar_nulo" id="mesa_voto_ar_nulo" type="text" maxlength="3" autocomplete="off" class="alfanumerico box-shadow-light bordes-radius" placeholder="0" />
					</div>
					<div class="col-3">
						<h2>Totales</h2>
						<input name="mesa_voto_ar_total" id="mesa_voto_ar_total" type="text" maxlength="3" autocomplete="off" readonly="readonly" class="alfanumerico box-shadow-light bordes-radius" placeholder="0" />
					</div>
				</article>
			</div>
			<div class="votos-organo" onselectstart="return false">
				<header>
					<span><i class="fas fa-users"></i></span>
					<h2 class="icono-on">Tipo de Órgano</h2>
					<h3 class="icono-on">Administrar Votación de Papeleta</h3>
				</header>
				<article class="formulario bg-1">
					<div class="col-2">
						<h2>C. Constituyente</h2>
						<div class="votos">
							<div class="votos-input">
								<input name="mesa_voto_cc" id="mesa_voto_cc" type="text" maxlength="3" autocomplete="off" class="alfanumerico box-shadow-light bordes-radius" placeholder="0" />
							</div>
							<div class="votos-sumar" onclick="votos( 'mesa_voto_cc' , 'sumar' );"><i class="fas fa-plus-circle"></i></div>
							<div class="votos-restar" onclick="votos( 'mesa_voto_cc' , 'restar' );"><i class="fas fa-minus-circle"></i></div>
						</div>
					</div>
					<div class="col-2">
						<h2>C. Mixta</h2>
						<div class="votos">
							<div class="votos-input">
								<input name="mesa_voto_cm" id="mesa_voto_cm" type="text" maxlength="3" autocomplete="off" class="alfanumerico box-shadow-light bordes-radius" placeholder="0" />
							</div>
							<div class="votos-sumar" onclick="votos( 'mesa_voto_cm' , 'sumar' );"><i class="fas fa-plus-circle"></i></div>
							<div class="votos-restar" onclick="votos( 'mesa_voto_cm' , 'restar' );"><i class="fas fa-minus-circle"></i></div>
						</div>
					</div>
					<div class="col-3">
						<h2>Blancos</h2>
						<input name="mesa_voto_cmcc_blanco" id="mesa_voto_cmcc_blanco" maxlength="3" type="text" autocomplete="off" class="alfanumerico box-shadow-light bordes-radius" placeholder="0" />
					</div>
					<div class="col-3">
						<h2>Nulos</h2>
						<input name="mesa_voto_cmcc_nulo" id="mesa_voto_cmcc_nulo" maxlength="3" type="text" autocomplete="off" class="alfanumerico box-shadow-light bordes-radius" placeholder="0" />
					</div>
					<div class="col-3">
						<h2>Totales</h2>
						<input name="mesa_voto_cmcc_total" id="mesa_voto_cmcc_total" maxlength="3" type="text" autocomplete="off" readonly="readonly" class="alfanumerico box-shadow-light bordes-radius" placeholder="0" />
					</div>
				</article>
			</div>
			<footer onselectstart="return false">
				<div class="livebox-cargando">
					<i class="fas fa-spinner"></i>
				</div>
				<div class="of" onclick="cerrarLivebox();">
					<h2>Cerrar</h2>
				</div>
				<div class="on" onclick="editarMesaConfirmar();">
					<h2>Guardar Cambios</h2>
				</div>
			</footer>
		</div>