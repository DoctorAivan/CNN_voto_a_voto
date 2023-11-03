<?php

//  Obtener el icono relacionado
    function obtener_icono( $icono )
    {
        if( $icono == 'P' )
        {
            return 'fa-sticky-note';
        }
        else if( $icono == 'S' )
        {
            return 'fa-sticky-note';
        }
        else if( $icono == 'D' )
        {
            return 'fa-sticky-note';
        }
    }

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//  Obtener el titulo del tipo
    function obtener_titulo( $icono )
    {
        if( $icono == 'P' )
        {
            return '🟡&nbsp;&nbsp;&nbsp;CONSTITUYENTES';
        }
        else if( $icono == 'S' )
        {
            return '🔴&nbsp;&nbsp;SENADORES';
        }
        else if( $icono == 'D' )
        {
            return '🔵&nbsp;&nbsp;DIPUTADOS';
        }
    }

?>