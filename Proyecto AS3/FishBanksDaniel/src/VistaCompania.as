package  
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	
	/**
	 * ...
	 * @author Fulgore
	 */
	public class VistaCompania extends Sprite
	{
		[Embed(source = 'data/graficos/vistas/VistaCompania.jpg')] public var Fondo:Class;
		[Embed(source = 'data/graficos/iconos/IconoBanco.png')] public var Banco:Class;
		[Embed(source = 'data/graficos/iconos/IconoEstadisticas.png')] public var Estadisticas:Class;
		[Embed(source = 'data/graficos/iconos/IconoMapa.png')] public var Mapa:Class;
		[Embed(source = 'data/graficos/iconos/IconoMercado.png')] public var Mercado:Class;
		[Embed(source = 'data/graficos/iconos/IconoPeriodico.png')] public var Periodico:Class;
		[Embed(source = 'data/graficos/iconos/IconoPuerta.png')] public var Puerta:Class;
		[Embed(source = 'data/graficos/iconos/IconoSubasta.png')] public var Martillo:Class;
		
		public static const STATUS_BANCO:String = "ventana_banco";
		public static const STATUS_ESTADISTICAS:String = "ventana_estadisticas";
		public static const STATUS_MAPA:String = "ventana_mapa";
		public static const STATUS_MERCADO:String = "ventana_mercado";
		public static const STATUS_PERIODICO:String = "ventana_periodico";
		public static const STATUS_SALIR:String = "ir_a_golfo";
		public static const STATUS_SUBASTA:String = "ventana_subasta";
		
		private var fondo:Bitmap;
		private var iconoBanco:IconoVisual;
		private var iconoEstadisticas:IconoVisual;
		private var iconoMapa:IconoVisual;
		private var iconoMercado:IconoVisual;
		private var iconoPeriodico:IconoVisual;
		private var iconoPuerta:IconoVisual;
		private var iconoSubasta:IconoVisual;
		private var temporizador:Temporizador;
		private var splashIniciando:SplashScreen;
		
		public function VistaCompania() {
			
			
			//inicializacion de variables
			fondo = new Fondo as Bitmap;
			iconoBanco = new IconoVisual(Banco,"Estado Financiero");
			iconoEstadisticas = new IconoVisual(Estadisticas, "Estadisticas");
			iconoMapa = new IconoVisual(Mapa, "Posicionamiento de Barcos");
			iconoMercado = new IconoVisual(Mercado, "Mercado de Embarcaciones");
			iconoPeriodico = new IconoVisual(Periodico, "Noticias");
			iconoPuerta = new IconoVisual(Puerta, "Vista General del Golfo");
			iconoSubasta = new IconoVisual(Martillo, "Subastas");
			
			
			//modificacion de propiedades
			
			//adhecion al DL
			addChild(fondo);
			addChild(iconoPuerta);
			addChild(iconoBanco);
			addChild(iconoEstadisticas);
			addChild(iconoMapa);
			addChild(iconoMercado);
			addChild(iconoPeriodico);
			addChild(iconoSubasta);
			
			// inhabilito el tab
			iconoPuerta.tabEnabled = false;
			iconoBanco.tabEnabled = false;
			iconoEstadisticas.tabEnabled = false;
			iconoMapa.tabEnabled = false;
			iconoMercado.tabEnabled = false;
			iconoPeriodico.tabEnabled = false;
			iconoSubasta.tabEnabled = false;
			
			
			//hubicacion
			iconoBanco.x = 71;
			iconoBanco.y = 340;
			iconoSubasta.x = 281;
			iconoSubasta.y = 165;
			iconoEstadisticas.x = 276;
			iconoEstadisticas.y = 264;
			iconoMapa.x = 459;
			iconoMapa.y = 175;
			iconoMercado.x = 154;
			iconoMercado.y = 187;
			iconoPeriodico.x = 545;
			iconoPeriodico.y = 329;
			iconoPuerta.x = 568;
			
			//adhecion de listeners
			iconoBanco.addEventListener(MouseEvent.CLICK, statusDispatcher, false, 0, true);
			iconoEstadisticas.addEventListener(MouseEvent.CLICK, statusDispatcher, false, 0, true);
			iconoMapa.addEventListener(MouseEvent.CLICK, statusDispatcher, false, 0, true);
			iconoMercado.addEventListener(MouseEvent.CLICK, statusDispatcher, false, 0, true);
			iconoPeriodico.addEventListener(MouseEvent.CLICK, statusDispatcher, false, 0, true);
			iconoPuerta.addEventListener(MouseEvent.CLICK, statusDispatcher, false, 0, true);
			iconoSubasta.addEventListener(MouseEvent.CLICK, statusDispatcher, false, 0, true);
		}
		
		/**
		 * Pone el temporizador en la vista, el que muestra el tiempo faltante para la finalizacion del turno
		 * @param	fechaInicio
		 * @param	duracionTurnoMinutos
		 */
		public function iniciarTemporizador(fechaInicio:Date, duracionTurnoMinutos:Number, turnoActual:TurnoDTO):void {
			temporizador = new Temporizador();
			temporizador.iniciarTemporizador(fechaInicio, duracionTurnoMinutos,turnoActual);
			temporizador.x = 140 - (temporizador.width/2);
			temporizador.y = 515;
			temporizador.addEventListener(StatusEvent.STATUS, sincronizarVista, false, 0, true);
			addChild(temporizador);
		}
		
		public function removerTemporizador():void {
			temporizador.removeEventListener(StatusEvent.STATUS, sincronizarVista);
			temporizador.destruir();
			removeChild(temporizador);
			temporizador = null;
			
		}
		
		private function sincronizarVista(e:StatusEvent):void {
			dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, "", Temporizador.SINCRONIZAR));
		}
		
		private function statusDispatcher(e:MouseEvent):void {
			if (e.currentTarget === iconoBanco) {
				dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, "", STATUS_BANCO));
			} else if (e.currentTarget === iconoEstadisticas) {
				dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, "", STATUS_ESTADISTICAS));
			} else if (e.currentTarget === iconoMapa) {
				dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, "", STATUS_MAPA));
			} else if (e.currentTarget === iconoMercado) {
				dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, "", STATUS_MERCADO));
			} else if (e.currentTarget === iconoPeriodico) {
				dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, "", STATUS_PERIODICO));
			} else if (e.currentTarget === iconoPuerta) {
				dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, "", STATUS_SALIR));
			} else if (e.currentTarget === iconoSubasta) {
				dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, "", STATUS_SUBASTA));
			} 
		}
		
		public function vistaDesincronizada():Boolean { return(temporizador.temporizadorDesincronizado()); }
		
		public function splashSincronizando():void {
			var splashSync:SplashScreen = new SplashScreen("SINCRONIZANDO", 2);
			splashSync.x = 400 - splashSync.width / 2;
			splashSync.y = 300;
			addChild(splashSync);
		}
		
		public function adherirSplashIniciando():void {
			splashIniciando = new SplashScreen("CARGANDO", 0);
			splashIniciando.x = 400 - splashIniciando.width / 2;
			splashIniciando.y = 100;
			addChild(splashIniciando);
		}
		
		public function quitarSplashIniciando():void {
			splashIniciando.destroyMe();
		}
		
	}

}