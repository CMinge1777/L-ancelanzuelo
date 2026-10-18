package  {
	import adobe.utils.CustomActions;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	
	/**
	 * ...
	 * @author Fulgore
	 */
	public class ControladorCompania extends EventDispatcher{
		
		private var vista_estadisticas:VistaEstadisticas;
		private var vista_noticias:VistaNoticias;
		private var vista_pedidos:VistaPedidos;
		private var vista_posicion:VistaPosicion;
		private var vista_subasta:VistaSubasta;
		private var vista_balance:VistaBanco;
		
		public static const IR_GOLFO:String = "ir a golfo";
		
		private var consultaActual:String;
		private var esperarConsulta:Boolean;
		private var mostrandoVentanita:Boolean;
		private var vista:VistaCompania;
		private var seIrGolfo:StatusEvent;
		private var conexionBD:DataBaseConexion;
		private var sincronizando:Boolean;
		private var iniciando:Boolean;
		
		private var dtoTablaAuxiliar:DTOTabla;
		private var dtoTablaAuxiliar2:DTOTabla;
		
		private var compania:CompaniaDTO;
		
		public function ControladorCompania(conexionBD:DataBaseConexion) {
			this.conexionBD = conexionBD;
			seIrGolfo = new StatusEvent(StatusEvent.STATUS, false, false, "", IR_GOLFO );
		}
		
		public function controlar(vista:VistaCompania):void {
			iniciando = true;
			this.vista = vista;
			this.vista.adherirSplashIniciando();
			conexionBD.addEventListener(StatusEvent.STATUS, iniciarTemporizador,false,15,true);
			conexionBD.turnoActual(compania.juego);
			esperarConsulta = true;
			mostrandoVentanita = false;
		}
		
		private function iniciarTemporizador(e:StatusEvent):void {
			conexionBD.removeEventListener(StatusEvent.STATUS, iniciarTemporizador);
			dtoTablaAuxiliar = conexionBD.retornarTablaDatos();
			conexionBD.addEventListener(StatusEvent.STATUS, iniciarVista,false,16,true);
			conexionBD.iniciarTemporizador(compania.juego);
		}
		
		private function iniciarVista(e:StatusEvent):void {
			conexionBD.removeEventListener(StatusEvent.STATUS, iniciarVista);
			this.vista.quitarSplashIniciando();
			esperarConsulta = false;
			var dtot:DTOTabla = conexionBD.retornarTablaDatos();
			vista.iniciarTemporizador(stringToDate((dtot.datosFilas[0])["CURRENT_TIMESTAMP"]),(dtot.datosFilas[0])["DURACION_TURNOS"],retornaTurnoActual(dtoTablaAuxiliar));
			this.vista.addEventListener(StatusEvent.STATUS, escucharEstatus, false, 10, true);
			iniciando = false;
		}
		
		private function stringToDate(fecha:String):Date {
			fecha = fecha.split("-").join("/");
			return new Date(Date.parse(fecha));
		}
		
		/**
		 * es importante q este metodo se ejecute antes de controlar la vista
		 * @param	compania
		 */
		public function ingresarJuegoYCompania(compania:CompaniaDTO):void { 
			this.compania = compania;
		}
		
		
		/**
		 * entra aqui cuando se pide abrir una ventanita desde la vista
		 * @param	e
		 */
		private function escucharEstatus(e:StatusEvent):void {
			if (!iniciando) {
				if (!esperarConsulta && !mostrandoVentanita ) {
					if(!this.vista.vistaDesincronizada()){
						esperarConsulta = true;
						conexionBD.addEventListener(StatusEvent.STATUS, consultaFinalizada, false, 14, true);
					}
					switch(e.level) {
						case VistaCompania.STATUS_BANCO: {
							if(!this.vista.vistaDesincronizada()){
								consultaActual = VistaCompania.STATUS_BANCO;
								conexionBD.removeEventListener(StatusEvent.STATUS, consultaFinalizada);
								conexionBD.addEventListener(StatusEvent.STATUS, consultaIntermedia, false, 14, true);
								conexionBD.balanceBanco(compania.juego, compania.nombre);
							}
							break;
						} case VistaCompania.STATUS_ESTADISTICAS: {
							if(!this.vista.vistaDesincronizada()){
								consultaActual = VistaCompania.STATUS_ESTADISTICAS;
								conexionBD.obtenerDatosEstadisticas(compania.juego,compania.nombre);
							}
							break;
						} case VistaCompania.STATUS_MAPA: { // FUNCIONADO
							if(!this.vista.vistaDesincronizada()){
								consultaActual = VistaCompania.STATUS_MAPA;
								conexionBD.removeEventListener(StatusEvent.STATUS, consultaFinalizada);
								conexionBD.addEventListener(StatusEvent.STATUS, consultaIntermedia, false,14, true);
								conexionBD.desicionDeLaCompania(compania.juego, compania.nombre);
							}
							break;
						} case VistaCompania.STATUS_MERCADO: { // FUNCIONANDO
							if(!this.vista.vistaDesincronizada()){
								consultaActual = VistaCompania.STATUS_MERCADO;
								conexionBD.removeEventListener(StatusEvent.STATUS, consultaFinalizada);
								conexionBD.addEventListener(StatusEvent.STATUS, consultaIntermedia, false, 14, true);
								conexionBD.tiposBarco();
							}
							break;
						} case VistaCompania.STATUS_PERIODICO: { // TODO falta ponerle a la vista el boton de cierre
							if(!this.vista.vistaDesincronizada()){
								consultaActual = VistaCompania.STATUS_PERIODICO;
								conexionBD.mensajeAlentador(compania.juego);
							}
							break;
						} case VistaCompania.STATUS_SALIR: {
							conexionBD.removeEventListener(StatusEvent.STATUS, consultaFinalizada);
							dispatchEvent(seIrGolfo);
							esperarConsulta = false;
							break;
						} case VistaCompania.STATUS_SUBASTA: { // FUNCIONANDO
							if(!this.vista.vistaDesincronizada()){
								consultaActual = VistaCompania.STATUS_SUBASTA;
								conexionBD.removeEventListener(StatusEvent.STATUS, consultaFinalizada);
								conexionBD.addEventListener(StatusEvent.STATUS, consultaIntermedia, false, 14, true);
								conexionBD.subastaActiva(compania.juego);
							}
							break;
						} default : {
							esperarConsulta = false;
						}
					}
				}
				
				if (e.level == Temporizador.SINCRONIZAR) {
					if (esperarConsulta) {
						// entra cuando se esta haciendo una consulta, q nunca va a entrar
						
					} else {
						// si no se esta haciendo consulta hay q averiguar si hay una ventana abierta
						if (mostrandoVentanita) {
							mostrandoVentanita = false;
							this.vista.addEventListener(StatusEvent.STATUS, escucharEstatus, false, 10, true);
							// la ventanita abierta se cierra para q tenga q consultar de nuevo
							switch (consultaActual) {
								case VistaCompania.STATUS_MERCADO: {
									vista_pedidos.removeEventListener(StatusEvent.STATUS, estatusVetanas);
									esperarConsulta = false;
									vista.removeChild(vista_pedidos);
									break;
								} case VistaCompania.STATUS_ESTADISTICAS: {
									vista_estadisticas.removeEventListener(StatusEvent.STATUS, estatusVetanas);
									esperarConsulta = false;
									vista.removeChild(vista_estadisticas);
									break;
								} case VistaCompania.STATUS_MAPA: {
									vista_posicion.removeEventListener(StatusEvent.STATUS, estatusVetanas);
									esperarConsulta = false;
									vista.removeChild(vista_posicion);
									break;
								} case VistaCompania.STATUS_PERIODICO: {
									vista_noticias.removeEventListener(StatusEvent.STATUS, estatusVetanas);
									esperarConsulta = false;
									vista.removeChild(vista_noticias);
									break;
								} case VistaCompania.STATUS_SUBASTA: { 
									vista_subasta.removeEventListener(StatusEvent.STATUS, estatusVetanas);
									esperarConsulta = false;
									vista.removeChild(vista_subasta);
									break;
									
								} case VistaCompania.STATUS_BANCO:  {
									vista_balance.removeEventListener(StatusEvent.STATUS, estatusVetanas);
									esperarConsulta = false;
									vista.removeChild(vista_balance);
									break;
								}
							}
							this.vista.removerTemporizador();
							iniciando = true;
							this.vista.adherirSplashIniciando();
							conexionBD.addEventListener(StatusEvent.STATUS, iniciarTemporizador,false,15,true);
							conexionBD.turnoActual(compania.juego);
							esperarConsulta = true;
							mostrandoVentanita = false;
						} else {
							this.vista.removerTemporizador();
							this.vista.adherirSplashIniciando();
							iniciando = true;
							conexionBD.addEventListener(StatusEvent.STATUS, iniciarTemporizador,false,15,true);
							conexionBD.turnoActual(compania.juego);
							esperarConsulta = true;
							mostrandoVentanita = false;
						}
					}
				}
			} else {
				this.vista.splashSincronizando();
			}
		}
		
		/**
		 * este metodo se ejecuta para llenar la tabla auxiliar, cuando una vista nesecite datos muy diferentes, sacados de consultas diferentes
		 * @param	e
		 */
		private function consultaIntermedia(e:StatusEvent):void {
			dtoTablaAuxiliar = conexionBD.retornarTablaDatos();
			conexionBD.removeEventListener(StatusEvent.STATUS, consultaIntermedia);
			conexionBD.addEventListener(StatusEvent.STATUS, consultaFinalizada, false, 14, true);
			switch(consultaActual) {
				case VistaCompania.STATUS_SUBASTA: {
					conexionBD.balanceCompanias(compania.juego);
					break;
				} case VistaCompania.STATUS_MAPA: {
					conexionBD.barcosPorCompania(compania.juego, compania.nombre);
					break;
				} case VistaCompania.STATUS_MERCADO: {
					conexionBD.removeEventListener(StatusEvent.STATUS, consultaFinalizada);
					conexionBD.addEventListener(StatusEvent.STATUS, consultaExtra, false, 14, true);
					conexionBD.verificarPedido(compania.juego,compania.nombre);
					break;
				} case VistaCompania.STATUS_BANCO: {
					conexionBD.removeEventListener(StatusEvent.STATUS, consultaFinalizada);
					conexionBD.addEventListener(StatusEvent.STATUS, consultaExtra, false, 14, true);
					conexionBD.tiposPez();
					break;
				}
			}
		}
		
		/**
		 * Metodo q se ejecuta para llenar la tabla auxiliar 2
		 * @param	e
		 */
		private function consultaExtra(e:StatusEvent):void {
			dtoTablaAuxiliar2 = conexionBD.retornarTablaDatos();
			conexionBD.removeEventListener(StatusEvent.STATUS, consultaExtra);
			conexionBD.addEventListener(StatusEvent.STATUS, consultaFinalizada, false, 14, true);
			switch(consultaActual) {
				case VistaCompania.STATUS_MERCADO: {
					conexionBD.balanceCompanias(compania.juego);
					break;
				} case VistaCompania.STATUS_BANCO: {
					conexionBD.calcularCostosOperativos(compania.juego,compania.nombre);
					break;
				}
			}
		}
		
		/**
		 * entra cuando la consulta previa para inicializar las ventanitas esta hecha, con lo q puede ya llenar datos dentro de las ventanitas
		 * @param	e
		 */
		private function consultaFinalizada(e:StatusEvent):void {
			var dtoT:DTOTabla;
			conexionBD.removeEventListener(StatusEvent.STATUS, consultaFinalizada);
			esperarConsulta = false;
			mostrandoVentanita = true;
			switch(consultaActual) {
				case VistaCompania.STATUS_BANCO: {
					dtoT = conexionBD.retornarTablaDatos();
					vista_balance = new VistaBanco(retornaReportes(dtoTablaAuxiliar),retornaTiposPez(dtoTablaAuxiliar2),new int(dtoT.datosFilas[0]["COSTOS_OPERATIVOS"]));
					vista.addChild(vista_balance);
					vista_balance.x = 400 - 320;
					vista_balance.y = 35;
					vista_balance.addEventListener(StatusEvent.STATUS, estatusVetanas, false, 5, true);
					break;
				} case VistaCompania.STATUS_ESTADISTICAS: {
					dtoT = conexionBD.retornarTablaDatos();
					vista_estadisticas = new VistaEstadisticas(retornaReportes(dtoT));
					vista.addChild(vista_estadisticas);
					vista_estadisticas.x = 400 - 320;
					vista_estadisticas.y = 35;
					vista_estadisticas.addEventListener(StatusEvent.STATUS, estatusVetanas, false, 5, true);
					break;
				} case VistaCompania.STATUS_MAPA: {
					dtoT = conexionBD.retornarTablaDatos();
					vista_posicion = new VistaPosicion(retornarDecision(dtoTablaAuxiliar), retornaBarcosXCompania(dtoT));
					vista.addChild(vista_posicion);
					vista_posicion.x = 400 - 320;
					vista_posicion.y = 35;
					vista_posicion.addEventListener(StatusEvent.STATUS, estatusVetanas, false, 5, true);
					break;
				} case VistaCompania.STATUS_MERCADO: {
					dtoT = conexionBD.retornarTablaDatos();
					vista_pedidos = new VistaPedidos(retornaEstadoResultadosCompania(dtoT,compania.nombre),retornaTiposBarco(dtoTablaAuxiliar),retornaPedido(dtoTablaAuxiliar2));
					vista.addChild(vista_pedidos);
					vista_pedidos.x = 400 - 320;
					vista_pedidos.y = 35;
					vista_pedidos.addEventListener(StatusEvent.STATUS, estatusVetanas, false, 5, true);
					break;
				} case VistaCompania.STATUS_PERIODICO: {
					dtoT = conexionBD.retornarTablaDatos();
					var str:String = "";
					if (dtoT.datosFilas.length > 0) {
						str = (dtoT.datosFilas[0])["TEXTO"];
					}
					vista_noticias = new VistaNoticias(str);
					//vista_noticias.x = 400 - (vista_noticias.width / 2);
					//vista_noticias.y = 300 - (vista_noticias.height / 2);
					vista_noticias.x = 400 - 320;
					vista_noticias.y = 35;
					vista.addChild(vista_noticias);
					vista_noticias.addEventListener(StatusEvent.STATUS, estatusVetanas, false, 5, true);
					break;
				} case VistaCompania.STATUS_SUBASTA: {
					dtoT = conexionBD.retornarTablaDatos();
					vista_subasta = new VistaSubasta(retornaSubastaActual(dtoTablaAuxiliar),retornaEstadoResultadosCompania(dtoT,compania.nombre));
					vista.addChild(vista_subasta);
					vista_subasta.x = 400 - 320;
					vista_subasta.y = 35;
					vista_subasta.addEventListener(StatusEvent.STATUS, estatusVetanas, false, 5, true);
					break;
				}
			}
		}
		
		private function retornaTiposPez(dtoT:DTOTabla):Vector.<TipoPezDTO> {
			var vtp:Vector.<TipoPezDTO> = new Vector.<TipoPezDTO>();
			var length:uint = dtoT.datosFilas.length;
			for (var i:int = 0; i < length; i++) {
				var tb:TipoPezDTO = new TipoPezDTO();
				tb.tipo_pez_id = new int(dtoT.datosFilas[i]["TIPO_PEZ_ID"]);
				tb.nombre = dtoT.datosFilas[i]["NOMBRE"];
				tb.precio = new int(dtoT.datosFilas[i]["PRECIO"]);
				vtp.push(tb);
			}
			return(vtp);
		}
		
		/**
		 * 
		 */
		private function retornaPedido(dtoT:DTOTabla):PedidoDTO {
			var ped:PedidoDTO = new PedidoDTO();
			if (dtoT.datosFilas.length > 0) {
				ped.compania_nombre = dtoT.datosFilas[0]["COMPANIA_NOMBRE"];
				ped.juego_id = new int(dtoT.datosFilas[0]["JUEGO_ID"]); 
				ped.turno_id = new int(dtoT.datosFilas[0]["TURNO_ID"]);
				ped.numero_chalupas = new int(dtoT.datosFilas[0]["NUMERO_CHALUPAS"]);
				ped.numero_pangas = new int(dtoT.datosFilas[0]["NUMERO_PANGAS"]);
				ped.numero_barco_pesquero = new int(dtoT.datosFilas[0]["NUMERO_BARCO_PESQUERO"]);
				return(ped);
			}
			return(null);
		}
		
		private function retornaTurnoActual(dtoT:DTOTabla):TurnoDTO{
			var t:TurnoDTO = new TurnoDTO();
			if (dtoT.datosFilas.length > 0) {
				t.juego_id = new int(dtoT.datosFilas[0]["JUEGO_ID"]); 
				t.turno_id = new int(dtoT.datosFilas[0]["TURNO_ID"]);
				t.insercion = stringToDate(dtoT.datosFilas[0]["INSERCION"]);
				return(t);
			}
			return(null);
		}
		
		private function retornaReportes(dtoT:DTOTabla):Vector.<ReporteDTO> {
			var vtb:Vector.<ReporteDTO> = new Vector.<ReporteDTO>();
			var length:uint = dtoT.datosFilas.length;
			for (var i:int = 0; i < length; i++) {
				var tb:ReporteDTO = new ReporteDTO();
				tb.turno_id 					= new int(dtoT.datosFilas[i]["TURNO_ID"]);
				tb.juego_id 					= new int(dtoT.datosFilas[i]["JUEGO_ID"]);
				tb.compania_nombre 				= dtoT.datosFilas[i]["COMPANIA_NOMBRE"];
				tb.captura_pargo_costa 			= new int(dtoT.datosFilas[i]["CAPTURA_PARGO_COSTA"]);
				tb.captura_pargo_mar_profundo 	= new int(dtoT.datosFilas[i]["CAPTURA_PARGO_MAR_PROFUNDO"]);
				tb.captura_robalo_costa 		= new int(dtoT.datosFilas[i]["CAPTURA_ROBALO_COSTA"]);
				tb.captura_robalo_mar_profundo 	= new int(dtoT.datosFilas[i]["CAPTURA_ROBALO_MAR_PROFUNDO"]);
				tb.captura_sierra_costa 		= new int(dtoT.datosFilas[i]["CAPTURA_SIERRA_COSTA"]);
				tb.captura_sierra_mar_proundo 	= new int(dtoT.datosFilas[i]["CAPTURA_SIERRA_MAR_PROFUNDO"]);
				tb.balance_general 				= new int(dtoT.datosFilas[i]["BALANCE_GENERAL"]);
				vtb.push(tb);
			}
			return(vtb);
		}
		
		/**
		 * 
		 */
		private function retornaTiposBarco(dtoT:DTOTabla):Vector.<TipoBarcoDTO> {
			var vtb:Vector.<TipoBarcoDTO> = new Vector.<TipoBarcoDTO>();
			var length:uint = dtoT.datosFilas.length;
			for (var i:int = 0; i < length; i++) {
				var tb:TipoBarcoDTO = new TipoBarcoDTO();
				tb.capacidad = new int(dtoT.datosFilas[i]["CAPACIDAD"]);
				tb.nombre = dtoT.datosFilas[i]["NOMBRE"];
				tb.precio = new int(dtoT.datosFilas[i]["PRECIO"]);
				tb.tipo_barco_id = new int(dtoT.datosFilas[i]["TIPO_BARCO_ID"]);
				vtb.push(tb);
			}
			return(vtb);
		}
		
		
		private function retornaBarcosXCompania(dtoT:DTOTabla):Vector.<BarcosXCompaniaDTO> {
			var vbxc:Vector.<BarcosXCompaniaDTO> = new Vector.<BarcosXCompaniaDTO>();
			var length:uint = dtoT.datosFilas.length;
			for (var i:int = 0; i < length; i++) {
				var bxc:BarcosXCompaniaDTO = new BarcosXCompaniaDTO();
				bxc.cantidad_barcos = new int(dtoT.datosFilas[i]["CANTIDAD_BARCOS"]);
				bxc.compania_nombre = dtoT.datosFilas[i]["COMPANIA_NOMBRE"];
				bxc.juego_id = new int(dtoT.datosFilas[i]["JUEGO_ID"]);
				bxc.tipo_barco_id = new int(dtoT.datosFilas[i]["TIPO_BARCO_ID"]);
				bxc.ubicacion_id = new int(dtoT.datosFilas[i]["UBICACION_ID"]);
				vbxc.push(bxc);
			}
			return(vbxc);
		}
		
		/**
		 * 
		 */
		private function retornarDecision(dtoT:DTOTabla):DecisionDTO {
			var dec:DecisionDTO = new DecisionDTO();
			if (dtoTablaAuxiliar.datosFilas.length > 0) {
				dec.decision_id = new int(dtoT.datosFilas[0]["DECISION_ID"]);
				dec.compania_nombre = dtoT.datosFilas[0]["COMPANIA_NOMBRE"]; 
				dec.juego_id = new int(dtoT.datosFilas[0]["JUEGO_ID"]); 
				dec.turno_id = new int(dtoT.datosFilas[0]["TURNO_ID"]);
				dec.chalupas_costa = new int(dtoT.datosFilas[0]["CHALUPAS_COSTA"]);
				dec.chalupas_mar_profundo = new int(dtoT.datosFilas[0]["CHALUPAS_MAR_PROFUNDO"]);
				dec.chalupas_puerto = new int(dtoT.datosFilas[0]["CHALUPAS_PUERTO"]);
				dec.panga_costa = new int(dtoT.datosFilas[0]["PANGA_COSTA"]);
				dec.panga_mar_profundo = new int(dtoT.datosFilas[0]["PANGA_MAR_PROFUNDO"]);
				dec.panga_puerto = new int(dtoT.datosFilas[0]["PANGA_PUERTO"]);
				dec.barco_pesquero_costa = new int(dtoT.datosFilas[0]["BARCO_PESQUERO_COSTA"]);
				dec.barco_pesquero_puerto = new int(dtoT.datosFilas[0]["BARCO_PESQUERO_PUERTO"]);
				dec.barco_pesquero_mar_profundo = new int(dtoT.datosFilas[0]["BARCO_PESQUERO_MAR_PROFUNDO"]);
				return(dec);
			}
			return(null);
		}
		
		/**
		 * 
		 */
		private function retornaSubastaActual(dtoT:DTOTabla):SubastaDTO {
			var sub:SubastaDTO = new SubastaDTO();
			if (dtoT.datosFilas.length > 0) {
				sub.costo = new int(dtoT.datosFilas[0]["COSTO"]);
				sub.juego_id = new int(dtoT.datosFilas[0]["JUEGO_ID"]);
				sub.numero_barco_pesquero = new int(dtoT.datosFilas[0]["NUMERO_BARCO_PESQUERO"]);
				sub.numero_chalupas = new int(dtoT.datosFilas[0]["NUMERO_CHALUPAS"]);
				sub.numero_pangas = new int(dtoT.datosFilas[0]["NUMERO_PANGAS"]);
				sub.subasta_abierta = new int(dtoT.datosFilas[0]["SUBASTA_ABIERTA"]);
				sub.turno_id = new int(dtoT.datosFilas[0]["TURNO_ID"]);
				return(sub);
			}
			return(null);
		}
		
		/**
		 * retorna el dinero de la compañia
		 * @param	dtoT
		 * @param	nombreCompania
		 * @return
		 */
		private function retornaEstadoResultadosCompania(dtoT:DTOTabla, nombreCompania:String):Number {
			var estadoResultados:Number = 0.0;
			var length:uint = dtoT.datosFilas.length;
			for (var i:int = 0; i < length; i++) {
				if (nombreCompania == (dtoT.datosFilas[i])["COMPANIA_NOMBRE"]) {
					estadoResultados = new Number((dtoT.datosFilas[i])["ESTADO_RESULTADOS"]);
				}
			}
			return(estadoResultados);
		}
		
		/**
		 * cuando desde una ventanita se ejecuta un evento entra aqui, y con respecto a q evento , actualiza la bd o cierra la ventanita
		 * @param	e
		 */
		private function estatusVetanas(e:StatusEvent):void {
			// cierra la vista y si hizo un update a la bd no deja abrir otra vista hasta q este se confirme
			mostrandoVentanita = false;
			switch (e.currentTarget) {
				case vista_pedidos: {
					vista_pedidos.removeEventListener(StatusEvent.STATUS, estatusVetanas);
					switch (e.level) {
						case VistaPedidos.CERRAR: {
							esperarConsulta = false;
							vista.removeChild(vista_pedidos);
							break;
						} case VistaPedidos.COMPRAR: {
							if (!this.vista.vistaDesincronizada()) {
								vista.removeChild(vista_pedidos);
								this.vista.addChild(new SplashScreen("Compra Hecha", 2.5));
								esperarConsulta = true;
								conexionBD.addEventListener(StatusEvent.STATUS, actualizarDatos, false, 20, true);
								conexionBD.hacerPedidos(compania.juego, compania.nombre, vista_pedidos.numChalupas, vista_pedidos.numPangas, vista_pedidos.numBarcosPesqueros);
							} else {
								this.vista.addChild(new SplashScreen("vista desincronizada", 2.5));
								esperarConsulta = false;
								vista.removeChild(vista_pedidos);
							}
							break;
						}
					}
					break;
				} case vista_estadisticas: {
					vista_estadisticas.removeEventListener(StatusEvent.STATUS, estatusVetanas);
					switch (e.level) {
						case VistaEstadisticas.CERRAR: {
							esperarConsulta = false;
							vista.removeChild(vista_estadisticas);
							break;
						} 
					}
					break;
				} case vista_posicion: { //FUNCIONANDO
					vista_posicion.removeEventListener(StatusEvent.STATUS, estatusVetanas);
					switch (e.level) {
						case VistaPosicion.CERRAR:  {
							esperarConsulta = false;
							vista.removeChild(vista_posicion);
							break;
						} case VistaPosicion.CAMBIAR:  {
							if (!this.vista.vistaDesincronizada()) {
								this.vista.addChild(new SplashScreen("Posicionando los Barcos", 2.5));
								esperarConsulta = true;
								vista.removeChild(vista_posicion);
								conexionBD.addEventListener(StatusEvent.STATUS, actualizarDatos, false, 20, true);
								var ncp:int=vista_posicion.numeroChalupasPuerto;
								var ncc:int=vista_posicion.numeroChalupasCosta;
								var ncmp:int=vista_posicion.numeroChalupasMarProfundo;
								var npmp:int=vista_posicion.numeroPangasMarProfundo;
								var npc:int=vista_posicion.numeroPangasCosta;
								var npp:int=vista_posicion.numeroPangasPuerto;
								var nbpc:int=vista_posicion.numeroPesquerosCosta;
								var nbpp:int=vista_posicion.numeroPesquerosPuerto;
								var nbpmp:int=vista_posicion.numeroPesquerosMarProfundo;
								conexionBD.posicionarBarcos(compania.juego, compania.nombre, ncc, ncmp, ncp, npc, npmp, npp, nbpc, nbpmp, nbpp);
							} else {
								this.vista.addChild(new SplashScreen("vista desincronizada", 2.5));
								esperarConsulta = false;
								vista.removeChild(vista_posicion);
							}
							break;
							
						}
					}
					break;
				} case vista_noticias: {
					vista_noticias.removeEventListener(StatusEvent.STATUS, estatusVetanas);
					switch (e.level) {
						case VistaNoticias.CERRAR:  {
							esperarConsulta = false;
							vista.removeChild(vista_noticias);
							break;
						}
					}
					break;
				} case vista_subasta: { //FUNCIONANDO
					vista_subasta.removeEventListener(StatusEvent.STATUS, estatusVetanas);
					switch (e.level) {
						case VistaSubasta.CERRAR: {
							esperarConsulta = false;
							vista.removeChild(vista_subasta);
							break;
						} case VistaSubasta.OFERTAR: {
							if (!this.vista.vistaDesincronizada()) {
								this.vista.addChild(new SplashScreen("Suerte en su oferta", 2.5));
								esperarConsulta = true;
								vista.removeChild(vista_subasta);
								conexionBD.addEventListener(StatusEvent.STATUS, actualizarDatos, false, 20, true);
								conexionBD.hacerOferta(compania.juego, compania.nombre, vista_subasta.oferta);
							} else {
								this.vista.addChild(new SplashScreen("vista desincronizada", 2.5));
								esperarConsulta = false;
								vista.removeChild(vista_subasta);
							}
							break;
						}
					}
					break;
				} case vista_balance:  {
					vista_balance.removeEventListener(StatusEvent.STATUS, estatusVetanas);
					switch (e.level) {
						case VistaBanco.CERRAR:  {
							esperarConsulta = false;
							vista.removeChild(vista_balance);
							break;
						}
					}
					break;
				}
			}
		}
		
		/**
		 * ingresa cuando los datos de las ventanitas se actualizaron y permite otraves hacer consultas
		 * @param	e
		 */
		private function actualizarDatos(e:StatusEvent):void {
			esperarConsulta = false;
		}
	}
}