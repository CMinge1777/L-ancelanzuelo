package  
{
	import flash.events.*;
	import flash.net.*;
	
	/**
	 * ...
	 * @author Daniel "Fulgore" Isaza from ILLUSIONWARE
	 */
	
	public class DataBaseConexion extends EventDispatcher
	{
		public static const CONSULTA_TERMINADA:String = "finalizo_consulta";
		public static const CONSULTA_TERMINADA_ERROR:String = "fallo_consulta";
		
		public var myService:NetConnection;
		protected var responder:Responder;
		private var dtoTabla:DTOTabla;
		private var falloConsulta:Boolean;
		private var consultaHecha:Boolean;
		
		//public function DataBaseConexion(gateway:String = "http://lancelanzuelo.netne.net/amfphp/gateway.php") { // 
		//public function DataBaseConexion(gateway:String = "http://ingenieria.udea.edu.co/appludens/fishbanks/amfphp/gateway.php") {
		public function DataBaseConexion(gateway:String = "http://illusionwaregames.com/ludens/amfphp/gateway.php") {
			try{
				myService = new NetConnection();
				myService.connect(gateway);
				responder = new Responder(resultadoBaseDatos, controlarFalla);
			} catch (err:Error) {
				trace(err);
			}
		}
		
		/**
		 * crea una tabla de la siguiente manera
		 * 
		 * --------------------------------------------------------------
		 * | NOMBRE 	| PASSWORD	| JUEGO_ID 	| UBICACION_TERRESTRE 	|
		 * --------------------------------------------------------------
		 * | Compania1 	| XXXXXX	| 1 		| 1						|
		 * --------------------------------------------------------------
		 * 
		 * @param	nombre
		 * @param	password
		 * @param	juego
		 */
		public function loginCompany(nombre:String, password:String, juego:int):void {
			consultaHecha = false;
			myService.call("DatabaseConexionFishBanks.login", responder,nombre,password,juego);
		}
		
		/**
		 * crea una tabla de la siguiente manera
		 * 
		 * ----------------------------------------------------------------------------------
		 * | COMPANIA 	| UBICACION_COMPANIA	| BARCOS 	| UBICACION 	| TIPO_BARCO	|
		 * ----------------------------------------------------------------------------------
		 * | Compania1 	| 1						| 3 		| PUERTO 		| PANGA			|
		 * | Compania1 	| 1						| 3 		| MAR PROFUNDO 	| CHALUPA		|
		 * | Compania1 	| 1						| 9 		| MAR PROFUNDO 	| BARCO PESQUERO|
		 * | Compania2 	| 2						| 3 		| PUERTO 		| CHALUPA		|
		 * | Compania2 	| 2						| 3 		| PUERTO 		| BARCO PESQUERO|
		 * | Compania3 	| 3						| 3			| PUERTO 		| PANGA			|
		 * | Compania3 	| 3						| 3 		| PUERTO 		| PANGA			|
		 * | Compania3 	| 3						| 3 		| PUERTO 		| CHALUPA		|
		 * | Compania3 	| 3						| 3 		| PUERTO 		| BARCO PESQUERO|
		 * | Compania4 	| 4						| 3 		| PUERTO 		| CHALUPA		|
		 * | Compania4 	| 4						| 3 		| PUERTO 		| BARCO PESQUERO|
		 * | Compania4 	| 4						| 3 		| PUERTO 		| PANGA			|
		 * ----------------------------------------------------------------------------------
		 * 
		 * se lee la compania C ubicada en U, tiene X barcos en Z ubicacion, y los barcos son de Y tipo
		 * 
		 * @param	juego
		 */
		public function iniciarGolfo(juego:int):void {
			consultaHecha = false;
			myService.call("DatabaseConexionFishBanks.iniciarGolfo", responder,juego);
		}
		
		public function seleccionarCompanias(juego:int):void {
			consultaHecha = false;
			myService.call("DatabaseConexionFishBanks.seleccionarCompanias", responder,juego);
		}
		
		/**
		 * 
		 * crea una tabla de la siguiente manera
		 * 
		 * ------------------------------------------
		 * | COMPANIA_NOMBRE	| ESTADO_RESULTADOS	|
		 * ------------------------------------------
		 * | Compania1 			| 0					|
		 * | Compania2 			| 0					|
		 * | Compania3 			| 100254000			|
		 * | Compania4 			| -113000000		|
		 * ------------------------------------------
		 * 
		 * @param	juego
		 */
		public function balanceCompanias(juego:int): void {
			consultaHecha = false;
			myService.call("DatabaseConexionFishBanks.balanceCompanias", responder,juego);
		}
		
		/**
		 * 
		 * crea una tabla de la siguiente manera
		 * 
		 * ------------------------------------------------------------------------------------------------
		 * | NOMBRE_BARCO 		| PRECIO_BARCO 	| CAPACIDAD_BARCO 	| UBICACION 	| BARCOS_EN_UBICACION |
		 * ------------------------------------------------------------------------------------------------
		 * | CHALUPA 			| 3000000 		| 900 				| PUERTO 		| 3					  |
		 * | PANGA 				| 30000000 		| 2000 				| PUERTO 		| 3					  |
		 * | BARCO PESQUERO 	| 80000000 		| 9000 				| PUERTO 		| 3					  |
		 * | CHALUPA 			| 3000000 		| 900 				| COSTA 		| 0					  |
		 * | PANGA 				| 30000000 		| 2000 				| COSTA 		| 0					  |
		 * | BARCO PESQUERO 	| 80000000 		| 9000 				| COSTA 		| 1					  |
		 * | CHALUPA 			| 3000000 		| 900 				| MAR PROFUNDO 	| 0					  |
		 * | PANGA 				| 30000000 		| 2000 				| MAR PROFUNDO 	| 0					  |
		 * | BARCO PESQUERO 	| 80000000 		| 9000 				| MAR PROFUNDO 	| 0					  |
		 * ------------------------------------------------------------------------------------------------
		 * 
		 * 
		 * @param	juego
		 * @param	compania
		 */
		public function estadoActualDeBarcos(juego:int, compania:String):void {
			consultaHecha = false;
			myService.call("DatabaseConexionFishBanks.estadoActualDeBarcos", responder,juego,compania);
		}
		
		
		/**
		 * Crea un retorna una tabla para llenar el dto DecisionDTO
		 * @param	juego
		 * @param	compania
		 */
		public function desicionDeLaCompania(juego:int, compania:String):void {
			consultaHecha = false;
			myService.call("DatabaseConexionFishBanks.desicionDeLaCompania", responder,juego,compania);
		}
		
		/**
		 * Crea un retorna una tabla para llenar el dto BarcosXCompaniaDTO
		 * @param	juego
		 * @param	compania
		 */
		public function barcosPorCompania(juego:int, compania:String):void {
			consultaHecha = false;
			myService.call("DatabaseConexionFishBanks.barcosPorCompania", responder,juego,compania);
		}
		
		/**
		 * 
		 * crea una tabla de la siguiente manera (para el dto SubastaDTO)
		 * 
		 * ------------------------------------------------------------------------------
		 * | COSTO 		| NUMERO_CHALUPAS 	| NUMERO_PANGAS 	| NUMERO_BARCO_PESQUERO	|
		 * ------------------------------------------------------------------------------
		 * | 1000000 	| 10		 		| 2 				| 1				 		| 
		 * ------------------------------------------------------------------------------
		 * 
		 * @param	juego
		 */
		public function subastaActiva(juego:int):void {
			consultaHecha = false;
			myService.call("DatabaseConexionFishBanks.subastaActiva", responder,juego);
		}
		
		/**
		 * 
		 */
		public function obtenerDatosEstadisticas(juego:int, compania:String):void {
			consultaHecha = false;
			myService.call("DatabaseConexionFishBanks.obtenerDatosEstadisticas", responder,juego,compania);
		}
		
		/**
		 * 
		 */
		public function obtenerPoblacion(juego:int):void {
			consultaHecha = false;
			myService.call("DatabaseConexionFishBanks.obtenerPoblacion", responder,juego);
		}
		
		/**
		 * 
		 */
		
		public function obtenerJuegos():void {
			consultaHecha = false;
			myService.call("DatabaseConexionFishBanks.obtenerJuegos", responder);
		}
		 
		/**
		 * 
		 */
		public function balanceBanco(juego:int, compania:String):void {
			consultaHecha = false;
			myService.call("DatabaseConexionFishBanks.obtenerDatosEstadisticas", responder,juego,compania);
		}
		
		/**
		 * 
		 * crea una tabla de la siguiente manera
		 * 
		 * ----------------------------------------------------------------------
		 * | JUEGO_ID	| DESCRIPCION 	| DURACION_TURNOS 	| FECHA_INICIO		|
		 * ----------------------------------------------------------------------
		 * | 1		 	| blablablabla	| 120 				| 10-10-10 10:10:10	| 
		 * ----------------------------------------------------------------------
		 * 
		 * @param	juego
		 */
		public function iniciarTemporizador(juego:int):void {
			consultaHecha = false;
			myService.call("DatabaseConexionFishBanks.iniciarTemporizador", responder,juego);
		}
		
		/**
		 * 
		 * crea una tabla de la siguiente manera
		 * 
		 * ------------------
		 * | TEXTO			| 
		 * ------------------
		 * | blablablabla	| 
		 * ------------------
		 * 
		 * @param	juego
		 */
		public function mensajeAlentador(juego:int):void {
			consultaHecha = false;
			myService.call("DatabaseConexionFishBanks.mensajeAlentador", responder,juego);
		}
		
		/**
		 * crea una tabla de la siguiente manera
		 * 
		 * -------------------------------------------------------
		 * | TIPO_BARCO_ID 	NOMBRE 			PRECIO 		CAPACIDAD
		 * -------------------------------------------------------
		 * 	 1 				CHALUPA 		3000000 	900
		 *   2 				PANGA 			30000000 	2000
		 *   3 				BARCO PESQUERO 	80000000 	9000 
		 */
		public function tiposBarco():void {
			consultaHecha = false;
			myService.call("DatabaseConexionFishBanks.tiposBarco", responder);
		}
		
		/**
		 * crea una tabla de la siguiente manera
		 * 
		 * ----------------------------------------
		 * | TIPO_PEZ_ID 	NOMBRE 		PRECIO 		
		 * ----------------------------------------
		 * 	 1 				PEZ1 		3000000 	
		 *   2 				PEZ2 		30000000 	
		 *   3 				PEZ3 		80000000 	
		 */
		public function tiposPez():void {
			consultaHecha = false;
			myService.call("DatabaseConexionFishBanks.tiposPez", responder);
		}
		
		/**
		 * crea una tabla de la siguiente manera
		 * 
		 * --------------------
		 * | COSTOS_OPERATIVOS 		
		 * --------------------
		 * 	 3000000 	
		 */
		public function calcularCostosOperativos(juego:int,compania:String):void {
			consultaHecha = false;
			myService.call("DatabaseConexionFishBanks.calcularCostosOperativos", responder,juego,compania);
		}
		
		public function turnoActual(juego:int):void {
			consultaHecha = false;
			myService.call("DatabaseConexionFishBanks.turnoActual", responder,juego);
		}
		
		
		
		/**
		 * crea una tabla de la siguiente manera
		 * 
		 * ---------------------------------------------------------------------------------------------------
		 * COMPANIA_NOMBRE 	JUEGO_ID 	TURNO_ID 	NUMERO_CHALUPAS 	NUMERO_PANGAS 	NUMERO_BARCO_PESQUERO
		 * ---------------------------------------------------------------------------------------------------
		 * UNO 				1 			0 			1 					1 				1
		 * 
		 * 
		 * @param	juego
		 * @param	compania
		 */
		public function verificarPedido(juego:int,compania:String):void {
			consultaHecha = false;
			myService.call("DatabaseConexionFishBanks.verificarPedido", responder, juego, compania);
		}
		
		/**
		 * metodo para ingresar datos en la bd
		 * @param	juego
		 * @param	compania
		 * @param	num_chalupas
		 * @param	num_pangas
		 * @param	num_pesqueros
		 */
		public function hacerPedidos(juego:int, compania:String, num_chalupas:int, num_pangas:int, num_pesqueros:int):void {
			consultaHecha = false;
			myService.call("DatabaseConexionFishBanks.hacerPedidos", responder, juego, compania, num_chalupas, num_pangas, num_pesqueros);
		}
		
		public function hacerOferta(juego:int, compania:String, oferta:int):void {
			consultaHecha = false;
			myService.call("DatabaseConexionFishBanks.hacerOferta", responder, juego, compania, oferta);
		}
		
		public function posicionarBarcos(juego:int,compania:String,num_chalupas_costa:int,num_chalupas_mar_profundo:int,num_chalupas_puerto:int,num_pangas_costa:int,num_pangas_mar_profundo:int,num_pangas_puerto:int,num_pesqueros_costa:int,num_pesqueros_mar_profundo:int,num_pesqueros_puerto:int):void {
			consultaHecha = false;
			myService.call("DatabaseConexionFishBanks.posicionarBarcos", responder, juego, compania, num_chalupas_costa, num_chalupas_mar_profundo, num_chalupas_puerto, num_pangas_costa, num_pangas_mar_profundo, num_pangas_puerto, num_pesqueros_costa, num_pesqueros_mar_profundo, num_pesqueros_puerto);
		}
		
		
		
		/**
		 * dependiendo del metodo antes ejecutado y si la consulta es exitosa se retorna una tabla como cada metodo especifica
		 * 
		 * @return la tabla q se retorna queda de la siguiente manera
		 * DTOTabla -- nombreColumnas:Vector.<String> --[nombreColumna1,nombreColumna2,...,nombreColumnaN] 
		 *          |- datosFilas:Array -- [ Objeto0 -- nombreColumna1 = datoFila1Columna1
		 * 											 |- nombreColumna2 = datoFila1Columna2
		 * 											 |- nombreColumnaN = datoFila1ColumnaN
		 * 									,Objeto1 -- nombreColumna1 = datoFila2Columna1
		 * 											 |- nombreColumna2 = datoFila2Columna2
		 * 											 |- nombreColumnaN = datoFila2ColumnaN
		 * 									,...,
		 * 									,ObjetoN -- nombreColumna1 = datoFilaNColumna1
		 * 											 |- nombreColumna2 = datoFilaNColumna2
		 * 											 |- nombreColumnaN = datoFilaNColumnaN
		 * 									] 
		 */
		public function retornarTablaDatos():DTOTabla {
			return(dtoTabla);
		}
		
		private function resultadoBaseDatos(databaseArray:Object):void {
			dtoTabla = new DTOTabla();
			if (!(databaseArray is Boolean)){
				var i:int = 0;
				for (var name:String in databaseArray[0]) {
					dtoTabla.nombreColumnas[i] = new String(name.toLowerCase());
					i++;
				}
				dtoTabla.datosFilas = databaseArray as Array;
			}
			consultaHecha = true;
			falloConsulta = false;
			dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, "", CONSULTA_TERMINADA));
			
		}
		
		private function controlarFalla(error:Object):void {
			falloConsulta = true;
			dtoTabla = new DTOTabla();
			//trace(error);
			dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, "", CONSULTA_TERMINADA_ERROR));
		}
	}

}