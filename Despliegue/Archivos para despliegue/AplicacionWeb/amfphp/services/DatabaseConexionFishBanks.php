<?php

include_once("../../Generales.php");
/**
*	Este servicio crea una conexion con la base de datos para le juego fishbanks y permite 
*   todos los datos necesarios para trabajar con esta
*/

class DatabaseConexionFishBanks {
	private $conexion;
	private $resultado;
	
	/**
	 * Hace la conexion con la bd
	 */
	function __construct(){
		global $conexion;
		$conexion = new  mysqli(MYSQL_HOSTFB, MYSQL_USERFB, MYSQL_PASSWORDFB, MYSQL_DBFB);
		if ($conexion->connect_error) {
			die('Connect Error (' . mysqli_connect_errno() . ') ' . mysqli_connect_error());
		}
	}
	
	/**
	 * deberia cerrarse siempre
	 */
	function cerrarResultado(){
		global $resultado;
		$resultado->free();
	}
	
	/**
	 * cierra la conexion con la bd
	 */
	function cerrarConexion(){
		global $conexion;
		$conexion->close();
	}
	
	/**
	* Verifica los datos de registro del jugador en la base de datos
	*/
	function login($compania,$password,$juego){
		global $conexion;
		global $resultado;
		$consulta = "SELECT * 
					FROM COMPANIA 
					WHERE NOMBRE = '" . $compania . "' AND JUEGO_ID = " . $juego . " AND PASSWORD = '" . $password . "';";
		$resultado = $conexion->query($consulta);
		if($resultado != false) {
			$arr = array();
			while ($row = $resultado->fetch_assoc()) {
				array_push($arr,$row);
			}
			return $arr;
		}
		return false;
	}
	
	function seleccionarCompanias($juego){
		global $conexion;
		global $resultado;
		$consulta = "SELECT `COMPANIA`.`NOMBRE` AS COMPANIA
					FROM `COMPANIA` 
					WHERE JUEGO_ID = " .$juego. ";";
		$resultado = $conexion->query($consulta);
		if($resultado != false) {
			$arr = array();
			while ($row = $resultado->fetch_assoc()) {
				array_push($arr,$row);
			}
			return $arr;
		}
		return false;
	}
	
	function iniciarGolfo($juego){
		global $conexion;
		global $resultado;
		$consulta = "SELECT `COMPANIA`.`NOMBRE` AS COMPANIA, `COMPANIA`.`UBICACION_TERRESTRE` AS UBICACION_COMPANIA, `BARCOSXCOMPANIA`.`CANTIDAD_BARCOS` AS BARCOS, `UBICACION`.`NOMBRE` AS UBICACION, `TIPO_BARCO`.`NOMBRE` AS TIPO_BARCO 
					FROM `TIPO_BARCO`, `COMPANIA`, `BARCOSXCOMPANIA`, `UBICACION` 
					WHERE ((`UBICACION`.`UBICACION_ID`  = `BARCOSXCOMPANIA`.`UBICACION_ID`) AND (`BARCOSXCOMPANIA`.`JUEGO_ID` = `COMPANIA`.`JUEGO_ID`) AND (`BARCOSXCOMPANIA`.`COMPANIA_NOMBRE` = `COMPANIA`.`NOMBRE`) AND (`COMPANIA`.`JUEGO_ID` = " . $juego . ") AND (`TIPO_BARCO`.`TIPO_BARCO_ID` = `BARCOSXCOMPANIA`.`TIPO_BARCO_ID`)) 
					ORDER BY `COMPANIA`.`NOMBRE` ASC, `UBICACION`.`UBICACION_ID` ASC, `UBICACION`.`NOMBRE` ASC;";
		$resultado = $conexion->query($consulta);
		if($resultado != false) {
			$arr = array();
			while ($row = $resultado->fetch_assoc()) {
				array_push($arr,$row);
			}
			return $arr;
		}
		return false;
	}
	
	function balanceCompanias($juego) {
		global $conexion;
		global $resultado;
		$consulta = "SELECT `REPORTE`.`COMPANIA_NOMBRE`, SUM(`REPORTE`.`BALANCE_GENERAL`) AS ESTADO_RESULTADOS, `COMPANIA`.`UBICACION_TERRESTRE`
					FROM REPORTE, `COMPANIA`
					WHERE ((`REPORTE`.`JUEGO_ID` = " . $juego . ") AND (`COMPANIA`.`NOMBRE` =  `REPORTE`.`COMPANIA_NOMBRE`)) AND (`COMPANIA`.`JUEGO_ID` = `REPORTE`.`JUEGO_ID`)
					GROUP BY `REPORTE`.`COMPANIA_NOMBRE`;";
		$resultado = $conexion->query($consulta);
		if($resultado != false) {
			$arr = array();
			while ($row = $resultado->fetch_assoc()) {
				array_push($arr,$row);
			}
			return $arr;
		}
		return false;
	}
	
	function desicionDeLaCompania($juego, $compania) {
		global $conexion;
		global $resultado;
		$consulta = "SELECT * 
					FROM DECISION
					WHERE COMPANIA_NOMBRE = '" . $compania . "' AND JUEGO_ID = " . $juego . " AND TURNO_ID = (SELECT MAX(`TURNO`.`TURNO_ID`) FROM `TURNO` WHERE (`TURNO`.`JUEGO_ID` = " . $juego . "));";
		$resultado = $conexion->query($consulta);
		if($resultado != false) {
			$arr = array();
			while ($row = $resultado->fetch_assoc()) {
				array_push($arr,$row);
			}
			return $arr;
		}
		return false;
	}
	
	function barcosPorCompania($juego, $compania) {
		global $conexion;
		global $resultado;
		$consulta = "SELECT * 
					FROM `BARCOSXCOMPANIA`
					WHERE `BARCOSXCOMPANIA`.`COMPANIA_NOMBRE` = '" . $compania . "' AND `BARCOSXCOMPANIA`.`JUEGO_ID` = " . $juego . ";";
		$resultado = $conexion->query($consulta);
		if($resultado != false) {
			$arr = array();
			while ($row = $resultado->fetch_assoc()) {
				array_push($arr,$row);
			}
			return $arr;
		}
		return false;
	}
	
	function estadoActualDeBarcos($juego, $compania) {
		global $conexion;
		global $resultado;
		$consulta = "SELECT `TIPO_BARCO`.`NOMBRE` AS NOMBRE_BARCO, `TIPO_BARCO`.`PRECIO` AS PRECIO_BARCO, `TIPO_BARCO`.`CAPACIDAD` AS CAPACIDAD_BARCO, `UBICACION`.`NOMBRE` AS UBICACION, `BARCOSXCOMPANIA`.`CANTIDAD_BARCOS` AS BARCOS_EN_UBICACION 
					FROM `BARCOSXCOMPANIA`, `TIPO_BARCO`, `UBICACION`
					WHERE ((`BARCOSXCOMPANIA`.`JUEGO_ID` = " . $juego . ") AND (`BARCOSXCOMPANIA`.`COMPANIA_NOMBRE` = '" . $compania . "') AND (`BARCOSXCOMPANIA`.`TIPO_BARCO_ID` = `TIPO_BARCO`.`TIPO_BARCO_ID`) AND (`BARCOSXCOMPANIA`.`UBICACION_ID` = `UBICACION`.`UBICACION_ID`));";
		$resultado = $conexion->query($consulta);
		if($resultado != false) {
			$arr = array();
			while ($row = $resultado->fetch_assoc()) {
				array_push($arr,$row);
			}
			return $arr;
		}
		return false;
	}
	
	function subastaActiva($juego) {
		global $conexion;
		global $resultado;
		$consulta = "SELECT *
				FROM SUBASTA
				WHERE JUEGO_ID = " . $juego . " AND TURNO_ID = (SELECT MAX(`TURNO`.`TURNO_ID`) FROM `TURNO` WHERE (`TURNO`.`JUEGO_ID` = " . $juego . "));";
		$resultado = $conexion->query($consulta);
		if($resultado != false) {
			$arr = array();
			while ($row = $resultado->fetch_assoc()) {
				array_push($arr,$row);
			}
			return $arr;
		}
		return false;
	}
	
	function iniciarTemporizador($juego) {
		global $conexion;
		global $resultado;
		$consulta = "SELECT *, CURRENT_TIMESTAMP
					FROM `JUEGO`
					WHERE `JUEGO`.`JUEGO_ID` = " . $juego . ";";
		$resultado = $conexion->query($consulta);
		if($resultado != false) {
			$arr = array();
			while ($row = $resultado->fetch_assoc()) {
				array_push($arr,$row);
			}
			return $arr;
		}
		return false;
	}
	
	function mensajeAlentador($juego) {
		global $conexion;
		global $resultado;
		$consulta = "SELECT TEXTO 
					FROM MENSAJE
					WHERE JUEGO_ID = " . $juego . " AND TURNO_ID = (SELECT MAX(`TURNO`.`TURNO_ID`) FROM `TURNO` WHERE (`TURNO`.`JUEGO_ID` = " . $juego . "));";
		$resultado = $conexion->query($consulta);
		if($resultado != false) {
			$arr = array();
			while ($row = $resultado->fetch_assoc()) {
				array_push($arr,$row);
			}
			return $arr;
		}
		return false;
	}
	
	function tiposBarco() {
		global $conexion;
		global $resultado;
		$consulta = "SELECT * FROM `TIPO_BARCO`;";
		$resultado = $conexion->query($consulta);
		if($resultado != false) {
			$arr = array();
			while ($row = $resultado->fetch_assoc()) {
				array_push($arr,$row);
			}
			return $arr;
		}
		return false;
	}
	
	function tiposPez() {
		global $conexion;
		global $resultado;
		$consulta = "SELECT * FROM `TIPO_PEZ`;";
		$resultado = $conexion->query($consulta);
		if($resultado != false) {
			$arr = array();
			while ($row = $resultado->fetch_assoc()) {
				array_push($arr,$row);
			}
			return $arr;
		}
		return false;
	}
	
	function obtenerJuegos() {
		global $conexion;
		global $resultado;
		$consulta = "SELECT * FROM `JUEGO`;";
		$resultado = $conexion->query($consulta);
		if($resultado != false) {
			$arr = array();
			while ($row = $resultado->fetch_assoc()) {
				array_push($arr,$row);
			}
			return $arr;
		}
		return false;
	}
	
	function calcularCostosOperativos($juego, $compania) {
		global $conexion;
		global $resultado;
		$consulta = "SELECT COSTO_ULTIMO_TURNO AS COSTOS_OPERATIVOS FROM COMPANIA WHERE NOMBRE = '".$compania."' AND JUEGO_ID = ".$juego.";";
		$resultado = $conexion->query($consulta);
		if($resultado != false) {
			$arr = array();
			while ($row = $resultado->fetch_assoc()) {
				array_push($arr,$row);
			}
			return $arr;
		}
		return false;
	}
	
	function verificarPedido($juego,$compania) {
		global $conexion;
		global $resultado;
		$consulta = "SELECT * 
					FROM PEDIDO
					WHERE COMPANIA_NOMBRE = '" . $compania . "' AND JUEGO_ID = " . $juego . " AND TURNO_ID = (SELECT MAX(`TURNO`.`TURNO_ID`) FROM `TURNO` WHERE (`TURNO`.`JUEGO_ID` = " . $juego . "));";
		$resultado = $conexion->query($consulta);
		if($resultado != false) {
			$arr = array();
			while ($row = $resultado->fetch_assoc()) {
				array_push($arr,$row);
			}
			return $arr;
		}
		return false;
	}
	
	function turnoActual($juego) {
		global $conexion;
		global $resultado;
		$consulta = "SELECT * FROM `TURNO` WHERE (`TURNO`.`JUEGO_ID` = " . $juego . ") AND TURNO_ID = (SELECT MAX(`TURNO`.`TURNO_ID`) FROM `TURNO` WHERE (`TURNO`.`JUEGO_ID` = " . $juego . ")) ;";
		$resultado = $conexion->query($consulta);
		if($resultado != false) {
			$arr = array();
			while ($row = $resultado->fetch_assoc()) {
				array_push($arr,$row);
			}
			return $arr;
		}
		return false;
	}
	
	function obtenerPoblacion($juego) {
		global $conexion;
		global $resultado;
		$consulta = "SELECT * FROM `PEZ` WHERE `JUEGO_ID` =  " . $juego . ";";
		$resultado = $conexion->query($consulta);
		if($resultado != false) {
			$arr = array();
			while ($row = $resultado->fetch_assoc()) {
				array_push($arr,$row);
			}
			return $arr;
		}
		return false;
	}
	
	function hacerPedidos($juego,$compania,$num_chalupas,$num_pangas,$num_pesqueros) {
		global $conexion;
		global $resultado;
		$consulta = "INSERT INTO PEDIDO 
					VALUES ('".$compania."',".$juego.", (SELECT MAX(`TURNO`.`TURNO_ID`) FROM `TURNO` WHERE (`TURNO`.`JUEGO_ID` = " . $juego . ")), ".$num_chalupas.", ".$num_pangas.", ".$num_pesqueros.")
					ON DUPLICATE KEY UPDATE
					NUMERO_CHALUPAS = ".$num_chalupas." , NUMERO_PANGAS = ".$num_pangas." , NUMERO_BARCO_PESQUERO = ".$num_pesqueros.";";
		$resultado = $conexion->query($consulta);
		if($resultado != false) {
			return $resultado;
		}
		return false;
	}
	
	function hacerOferta($juego,$compania,$oferta) {
		global $conexion;
		global $resultado;
		$consulta = "INSERT INTO OFERTA VALUES(".$oferta.",'".$compania."' , ".$juego.", (SELECT MAX(`TURNO`.`TURNO_ID`) FROM `TURNO` WHERE (`TURNO`.`JUEGO_ID` = " . $juego . ")))
					ON DUPLICATE KEY UPDATE 
					VALOR = ".$oferta.";";
		$resultado = $conexion->query($consulta);
		if($resultado != false) {
			return $resultado;
		}
		return false;
	}

	function posicionarBarcos($juego,$compania,$num_chalupas_costa,$num_chalupas_mar_profundo,$num_chalupas_puerto,$num_pangas_costa,$num_pangas_mar_profundo,$num_pangas_puerto,$num_pesqueros_costa,$num_pesqueros_mar_profundo,$num_pesqueros_puerto) {
		global $conexion;
		global $resultado;
		$consulta = "INSERT INTO DECISION 
					VALUES ('" . $compania . "', " . $juego . ", (SELECT MAX(`TURNO`.`TURNO_ID`) FROM `TURNO` WHERE (`TURNO`.`JUEGO_ID` = " . $juego . ")), " . $num_chalupas_costa . ", " . $num_chalupas_mar_profundo . ", " . $num_chalupas_puerto . ", " . $num_pangas_costa . ", " . $num_pangas_mar_profundo . ", " . $num_pangas_puerto . ", " . $num_pesqueros_costa . ", " . $num_pesqueros_puerto . ", " . $num_pesqueros_mar_profundo . ")
					ON DUPLICATE KEY UPDATE 
					CHALUPAS_COSTA = " . $num_chalupas_costa . " , 
					CHALUPAS_MAR_PROFUNDO = " . $num_chalupas_mar_profundo . " ,
					CHALUPAS_PUERTO = " . $num_chalupas_puerto . " , 
					PANGA_COSTA = " . $num_pangas_costa . " , 
					PANGA_MAR_PROFUNDO = " . $num_pangas_mar_profundo . " , 
					PANGA_PUERTO = " . $num_pangas_puerto . " , 
					BARCO_PESQUERO_COSTA = " . $num_pesqueros_costa . " , 
					BARCO_PESQUERO_PUERTO = " . $num_pesqueros_puerto . " , 
					BARCO_PESQUERO_MAR_PROFUNDO = " . $num_pesqueros_mar_profundo . ";";
		$resultado = $conexion->query($consulta);
		if($resultado != false) {
			return $resultado;
		}
		return false;
	}
	
	function obtenerDatosEstadisticas($juego,$compania) {
		global $conexion;
		global $resultado;
		$consulta = "SELECT * 
					FROM REPORTE
					WHERE JUEGO_ID = " . $juego . " AND COMPANIA_NOMBRE = '" . $compania . "';";
		$resultado = $conexion->query($consulta);
		if($resultado != false) {
			$arr = array();
			while ($row = $resultado->fetch_assoc()) {
				array_push($arr,$row);
			}
			return $arr;
		}
		return false;
	}
}
?>