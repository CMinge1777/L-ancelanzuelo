<?php

	include_once("./Generales.php");

	// make connection and select db
	$conexion = new  mysqli(MYSQL_HOSTFB, MYSQL_USERFB, MYSQL_PASSWORDFB, MYSQL_DBFB);
	if ($conexion->connect_error) {
		die('Connect Error (' . mysqli_connect_errno() . ') ' . mysqli_connect_error());
	}
	$consulta = "SELECT `TURNO`.`TURNO_ID` AS `TURNO_ID`, `TURNO`.`INSERCION` AS `INSERCION`, `JUEGO`.`DURACION_TURNOS` AS `DURACION_TURNOS`, `TURNO`.`JUEGO_ID` AS `JUEGO_ID`
FROM TURNO, JUEGO
WHERE ((`TURNO`.`TURNO_ID`  = (SELECT MAX(`TURNO`.`TURNO_ID`) AS TURNO_ID FROM `TURNO` WHERE (`TURNO`.`JUEGO_ID` = `JUEGO`.`JUEGO_ID`))) AND (`JUEGO`.`FINALIZADO` = 0) AND (`JUEGO`.`JUEGO_ID` =`TURNO`.`JUEGO_ID`));";
	$turnoActual = 0;
	$todoQuery = array();
	if ($resultado = $conexion->query($consulta)) { // entra si la consulta anterior entrega una tabla de respuesta
		$curdate = date('Y-m-d H:i:s', strtotime("+1 minutes"));
		while ($objAssoc = $resultado->fetch_assoc()) { // se ejecuta siempre y cuando retorne una fila como un objeto associativo
			$turnInsertDate = date('Y-m-d H:i:s',(strtotime($objAssoc["INSERCION"] . " +" . $objAssoc["DURACION_TURNOS"] . " minutes" )));
			if ($curdate>$turnInsertDate){ // entra si se debe insertar un turno
				$turnoActual = (int)$objAssoc["TURNO_ID"];
				$qry = "INSERT INTO TURNO (TURNO_ID,JUEGO_ID) VALUES (" . ($turnoActual + 1) . ", ".(int)$objAssoc["JUEGO_ID"].");";
				$todoQuery[] = $qry;
			}
		}
		$resultado->close();
		// ejecuta las querys que se guardaron antes
		foreach ($todoQuery as $qrytd) {
			$conexion->query($qrytd);
		}
	}
	
	$conexion->close();
?>
