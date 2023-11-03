						<div class="total">
							<h2>Registros :</h2>
							<h3><?php echo $_TOTAL->objetos; ?> Objetos</h3>
						</div>
						<div class="paginas">
<?php
					//	Generar Listado de Paginas
						for ($ID = 0; $ID <= $TOTAL_PAGINAS; $ID++)
						{
						//	Validar Pagina Actual
							if( $CONF_PAGINA_ACTUAL == $ID )
							{
?>
							<div class="on bordes-radius"><?php echo ( $ID + 1 ); ?></div>
<?php
							}
							else
							{
?>
							<a href="<?php echo $ID; ?>">
								<div class="box-shadow-light bordes-radius"><?php echo ( $ID + 1 ); ?></div>
							</a>
<?php
							}
						}
?>
						</div>
						<div class="navegacion">
<?php
					//	Estado Boton Siguiente
						if($TOTAL_OBJETOS >= $CCNF_RESULTADOS_PAGINAS)
						{
?>
							<a href="<?php echo ( $CONF_PAGINA_ACTUAL + 1 ); ?>">
								<div class="on box-shadow-light bordes-radius">Siguiente <i class="fas fa-chevron-right"></i></div>
							</a>
<?php
						}
						else
						{
?>
							<div class="of box-shadow-light bordes-radius">Siguiente <i class="fas fa-chevron-right"></i></div>
<?php
						}

					//	Estado Boton Anterior
						if($CONF_PAGINA_ACTUAL == 0)
						{
?>
							<div class="of box-shadow-light bordes-radius"><i class="fas fa-chevron-left"></i> Anterior</div>
<?php
						}
						else
						{
?>
							<a href="<?php echo ( $CONF_PAGINA_ACTUAL - 1 ); ?>">
								<div class="on box-shadow-light bordes-radius"><i class="fas fa-chevron-left"></i> Anterior</div>
							</a>
<?php
						}
?>
						</div>