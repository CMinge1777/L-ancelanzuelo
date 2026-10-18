package  {
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	
	/**
	 * ...
	 * @author Fulgore
	 */
	public class ControladorGolfo extends EventDispatcher{
		
		public static const IR_COMPANIA:String = "ir a compañia";
		
		private var compania:CompaniaDTO;
		private var cantidadCompanias:int;
		private var companiasAgenas:Vector.<CompaniaDTO>;
		
		private var vista:VistaGolfo;
		private var seIrCompania:StatusEvent;
		private var conexionBD:DataBaseConexion;
		private var dtotAux:DTOTabla;
		private var lastSynch:Number;
		private var iniciando:Boolean;
		
		public function ControladorGolfo(conexionBD:DataBaseConexion) { 
			this.conexionBD = conexionBD;
			seIrCompania = new StatusEvent(StatusEvent.STATUS, false, false, "", IR_COMPANIA );
		}
		
		public function controlar(vista:VistaGolfo):void {
			iniciando = true;
			lastSynch = (new Date()).getTime();
			this.vista = vista;
			conexionBD.addEventListener(StatusEvent.STATUS, iniciarVista, false, 15, true);
			conexionBD.iniciarGolfo(compania.juego);
			this.vista.addEventListener(StatusEvent.STATUS, escucharEstatus, false, 10, true);
			this.vista.adherirSplashIniciando();
		}
		
		/**
		 * es importante q este metodo se ejecute antes de controlar la vista
		 * @param	compania
		 */
		public function ingresarJuegoYCompania(compania:CompaniaDTO):void {
			this.compania = compania;
		}
		
		private function iniciarVista(e:StatusEvent):void {
			conexionBD.removeEventListener(StatusEvent.STATUS, iniciarVista);
			var dtoT:DTOTabla = conexionBD.retornarTablaDatos();
			var nombres:Vector.<String> = entregarNombres(dtoT);
			this.vista.ponerCompanias(nombres.length, nombres);
			ubicarBarcos(dtoT);
			this.vista.animacionOleaje();
			
			switch(compania.ubicacion_terrestre) {
				case 1: {
					this.vista.aduenarseDeCompania(VistaGolfo.ZONA_TERRESTRE_NECOCLI);
					break;
				} case 2: {
					this.vista.aduenarseDeCompania(VistaGolfo.ZONA_TERRESTRE_TURBO);
					break;
				} case 3: {
					this.vista.aduenarseDeCompania(VistaGolfo.ZONA_TERRESTRE_BOCASATRATO);
					break;
				} case 4: {
					this.vista.aduenarseDeCompania(VistaGolfo.ZONA_TERRESTRE_ACANDI);
					break;
				}
				
			}
			conexionBD.addEventListener(StatusEvent.STATUS, actualizarTablaPosiciones, false, 16, true);
			conexionBD.balanceCompanias(compania.juego);
		}
		
		private function actualizarTablaPosiciones(e:StatusEvent):void {
			conexionBD.removeEventListener(StatusEvent.STATUS, actualizarTablaPosiciones);
			var dtoT:DTOTabla = conexionBD.retornarTablaDatos();
			var length:uint = dtoT.datosFilas.length;
			if (length > 0) {
				var vecNom:Vector.<String> = new Vector.<String>();
				var vecNum:Vector.<int> = new Vector.<int>();
				var i:int = 0;
				for (i; i < length; i++) {
					vecNom.push(new String((dtoT.datosFilas[i]["COMPANIA_NOMBRE"])));
					vecNum.push(new int((dtoT.datosFilas[i]["ESTADO_RESULTADOS"])));
				}
				
				// buble sort
				var n:uint = length - 1;
				i = 0;
				for (i; i <= n; i++) {
					for (var j:int = n; j > i; j--) {
						if ( vecNum[j - 1] > vecNum[j] ) {
							
							var temp1:int = vecNum[j - 1];
							vecNum[j - 1] = vecNum[j];
							vecNum[j] = temp1;
							
							var temp2:String = vecNom[j - 1];
							vecNom[j - 1] = vecNom[j];
							vecNom[j] = temp2;
						}
					}
				}
				vecNom = vecNom.reverse();
				vista.ponerCorona(retornaZonaTerrestre(dtoT, vecNom[0]));
				vista.actualizarTablaDePosiciones(vecNom);
			}
			conexionBD.turnoActual(compania.juego);
			conexionBD.addEventListener(StatusEvent.STATUS, iniciarTemp, false, 17, true);
		}
		
		private function retornaZonaTerrestre(dtoT:DTOTabla, nombre:String):String {
			var ubT:int;
			for each (var item:* in dtoT.datosFilas) {
				if (nombre == item["COMPANIA_NOMBRE"]) {
					ubT = new int(item["UBICACION_TERRESTRE"]);
				}
			}
			switch (ubT) {
				case 1: {
					return(VistaGolfo.ZONA_TERRESTRE_NECOCLI);
					break;
				}case 2: {
					return(VistaGolfo.ZONA_TERRESTRE_TURBO);
					break;
				}case 3: {
					return(VistaGolfo.ZONA_TERRESTRE_BOCASATRATO);
					break;
				}case 4: {
					return(VistaGolfo.ZONA_TERRESTRE_ACANDI);
					break;
				}
			}
			return(null);
		}
		
	
		
		private function iniciarTemp(e:StatusEvent):void {
			conexionBD.removeEventListener(StatusEvent.STATUS, iniciarTemp);
			dtotAux = conexionBD.retornarTablaDatos();
			conexionBD.iniciarTemporizador(compania.juego);
			conexionBD.addEventListener(StatusEvent.STATUS, iniciarTempP2, false, 18, true);
		}
		
		private function iniciarTempP2(e:StatusEvent):void {
			conexionBD.removeEventListener(StatusEvent.STATUS, iniciarTempP2);
			var dtot:DTOTabla = conexionBD.retornarTablaDatos();
			vista.iniciarTemporizador(stringToDate((dtot.datosFilas[0])["CURRENT_TIMESTAMP"]), (dtot.datosFilas[0])["DURACION_TURNOS"], retornaTurnoActual(dtotAux));
			iniciando = false;
			vista.quitarSplashIniciando();
		}
		
		private function retornaTurnoActual(dtoT:DTOTabla):TurnoDTO {
			var t:TurnoDTO = new TurnoDTO();
			if (dtoT.datosFilas.length > 0) {
				t.juego_id = new int(dtoT.datosFilas[0]["JUEGO_ID"]); 
				t.turno_id = new int(dtoT.datosFilas[0]["TURNO_ID"]);
				t.insercion = stringToDate(dtoT.datosFilas[0]["INSERCION"]);
				return(t);
			}
			return(null);
		}
		
		private function stringToDate(fecha:String):Date {
			fecha = fecha.split("-").join("/");
			return new Date(Date.parse(fecha));
		}
		
		private function ubicarBarcos(dtoT:DTOTabla):void {
			for (var i:int = 0; i < dtoT.datosFilas.length; i++) {
				var zm:String = new String("");
				switch ((dtoT.datosFilas[i])["UBICACION"]) {
					case "MAR PROFUNDO": {
						zm = VistaGolfo.ZONA_MARITIMA_PROFUNDO;
						break;
					} case "COSTA": {
						zm = VistaGolfo.ZONA_MARITIMA_COSTA;
						break;
					} 
				}
				
				var cb:int =  (dtoT.datosFilas[i])["BARCOS"];
				var tb:String;
				switch ((dtoT.datosFilas[i])["TIPO_BARCO"]) {
					case "PANGA": {
						tb = VistaGolfo.BARCO_PANGA;
						break;
					} case "CHALUPA": {
						tb = VistaGolfo.BARCO_CHALUPA;
						break;
					} case "BARCO PESQUERO": {
						tb = VistaGolfo.BARCO_PESQUERO;
						break;
					} 
				}
				
				var col:String;
				switch ((dtoT.datosFilas[i])["UBICACION_COMPANIA"]) {
					case "1": {
						col = VistaGolfo.COLOR_AZUL;
						break;
					} case "2": {
						col = VistaGolfo.COLOR_VERDE;
						break;
					} case "3": {
						col = VistaGolfo.COLOR_ROJO;
						break;
					} case "4": {
						col = VistaGolfo.COLOR_AMARILLO;
						break;
					}
				}
				if (cb > 0 && zm != "") {
					this.vista.ubicarBarcos(zm, cb, tb, col);
				}
			}
		}
		
		private function entregarNombres(dtoT:DTOTabla):Vector.<String>{
			var vec:Vector.<String> = new Vector.<String>;
			var length:uint = dtoT.datosFilas.length;
			companiasAgenas = new Vector.<CompaniaDTO>();
			for (var i:int = 0; i < length; i++) { //recorre el vector de datos
				if (compania.nombre != (dtoT.datosFilas[i])["COMPANIA"] ) { // veriica si la compania es la principal
					var esta:Boolean = false;
					for (var c:int = 0; c < companiasAgenas.length; c++) {
						if ((companiasAgenas[c]).nombre == (dtoT.datosFilas[i])["COMPANIA"]) {
							esta = true;
						}
					}
					if (!esta) {
						var dtoC:CompaniaDTO = new CompaniaDTO((dtoT.datosFilas[i])["COMPANIA"],"",compania.juego,(dtoT.datosFilas[i])["UBICACION_COMPANIA"]);
						companiasAgenas.push(dtoC);
					}
				}
			}
			
			cantidadCompanias = companiasAgenas.length + 1;
			for (var j:int = 0; j < cantidadCompanias; j++) {
				vec.push("");
			}
			
			for (var k:int = 0; k < cantidadCompanias; k++) {
				if (k == cantidadCompanias - 1) {
					vec[compania.ubicacion_terrestre - 1] = compania.nombre;
				} else {
					vec[companiasAgenas[k].ubicacion_terrestre - 1] = companiasAgenas[k].nombre;
				}
			}
			return(vec);
		}
		
		private function escucharEstatus(e:StatusEvent):void {
			if(!iniciando){
				switch (e.level) {
					case VistaGolfo.EVENTO_IR_COMPANIA: {
						dispatchEvent(seIrCompania);
						break;
					} case VistaGolfo.EVENTO_MOSTRAR_COMPANIA: {
						// TRABAJO FUTURO aqui deberia de mostrar algo para q pueda comprar las estadisticas de esa compania, y asi verlas
						// pero esto todavia no es para esta version
						break;
					} case Temporizador.SINCRONIZAR: {
						// se reinicia la vista
						var auxSync:Number = (new Date()).getTime();
						if ((lastSynch + 15000) < auxSync) {
							lastSynch = auxSync;
							this.vista.resetearVista();
							this.vista.splashSincronizando();
							iniciando = true;
							conexionBD.addEventListener(StatusEvent.STATUS, iniciarVista, false, 14, true);
							conexionBD.iniciarGolfo(compania.juego);
							this.vista.adherirSplashIniciando();
						}
						break;
					}
					// cualquier otro evento, como ver estadisticas de la poblacion de peces o cualquier otra cosa se puede poner aqui siempre 
					// y cuando se ponga el evento y el disparador en la vista golfo
				}
			} else {
				this.vista.splashSincronizando();
			}
		}
		
	}

}