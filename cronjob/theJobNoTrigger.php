<?php

	define ('DB_USER','a1312880_adminFB');
	define ('DB_PASSWORD','adminFB8813');
	define ('DB_HOST','mysql8.000webhost.com');
	define ('DB_NAME','a1312880_FBDB');

	// make connection and select db
	$conexion = new  mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
	if ($conexion->connect_error) {
		die('Connect Error (' . mysqli_connect_errno() . ') ' . mysqli_connect_error());
	}
	$consulta = "SELECT `TURNO`.`TURNO_ID` AS `TURNO_ID`, `TURNO`.`INSERCION` AS `INSERCION`, `JUEGO`.`DURACION_TURNOS` AS `DURACION_TURNOS`, `TURNO`.`JUEGO_ID` AS `JUEGO_ID`
FROM TURNO, JUEGO
WHERE ((`TURNO`.`TURNO_ID`  = (SELECT MAX(`TURNO`.`TURNO_ID`) AS TURNO_ID FROM `TURNO` WHERE (`TURNO`.`JUEGO_ID` = `JUEGO`.`JUEGO_ID`))) AND (`JUEGO`.`FINALIZADO` = 0) AND (`JUEGO`.`JUEGO_ID` =`TURNO`.`JUEGO_ID`));";
	$turnoActual = 0;
	$todoQuery = array();
	// echo("something here ");
	if ($resultado = $conexion->query($consulta)) { // entra si la consulta anterior entrega una tabla de respuesta
		$curdate = date('Y-m-d H:i:s', strtotime("+1 minutes"));
		// echo("<br /> la consulta dio resultado. fechaactual + 1minuto: " . $curdate );
		while ($objAssoc = $resultado->fetch_assoc()) { // se ejecuta siempre y cuando retorne una fila como un objeto associativo
			$turnInsertDate = date('Y-m-d H:i:s',(strtotime($objAssoc["INSERCION"] . " +" . $objAssoc["DURACION_TURNOS"] . " minutes" )));
			// echo("<br /> el turno siguiente se deberia insertar en : " . $turnInsertDate);
			if ($curdate > $turnInsertDate){ // entra si se debe insertar un turno
				// echo("<br /> por lo tanto aqui deberia de insertar algo");
				$turnoActual = (int)$objAssoc["TURNO_ID"];
				$qry = "INSERT INTO TURNO (TURNO_ID,JUEGO_ID) VALUES (" . ($turnoActual + 1) . ", ".(int)$objAssoc["JUEGO_ID"].");";
				$todoQuery[] = $qry;
				if (($turnoActual + 1) < 12) {
					$qry = "CALL TURNO_FINALIZADO(".($turnoActual + 1).",".(int)$objAssoc["JUEGO_ID"].");";
					$todoQuery[] = $qry;
				} else {
					$qry = "CALL TURNO_FINALIZADO(".($turnoActual + 1).",".(int)$objAssoc["JUEGO_ID"].");";
					$todoQuery[] = $qry;
					$qry = "UPDATE JUEGO SET FINALIZADO = 1 WHERE JUEGO_ID = ".(int)$objAssoc["JUEGO_ID"].";";
					$todoQuery[] = $qry;
				}
				// echo("<br /> por lo tanto aqui deberia de insertar algo");
			}
		}
		$resultado->close();
		// ejecuta las querys que se guardaron antes
		foreach ($todoQuery as $qrytd) {
			// echo("<br /> esta vuelta es la q deberia ejecutarse en la bd: " . $qrytd);
			$conexion->query($qrytd);
		}
	}
	
	$conexion->close();
?>