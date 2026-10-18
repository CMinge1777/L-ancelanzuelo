package  {
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	/**
	 * ...
	 * @author Fulgore
	 */
	public class ControladorInicio extends EventDispatcher{
		
		public static const INGRESAR:String = "ingreso_concedido";
		
		private var compania:CompaniaDTO;
		
		private var vista:VistaInicio;
		private var seIngresar:StatusEvent;
		private var conexionBD:DataBaseConexion;
		private var verificandoDatos:Boolean;
		
		public function ControladorInicio(conexionBD:DataBaseConexion) {
			this.conexionBD = conexionBD;
			seIngresar = new StatusEvent(StatusEvent.STATUS, false, false, "", INGRESAR );
			verificandoDatos = false;
		}
		
		public function controlar(vista:VistaInicio):void {
			this.vista = vista;
			this.vista.addEventListener(StatusEvent.STATUS, verificarIngresoDatos, false, 0, true);
		}
		
		private function verificarIngresoDatos(e:StatusEvent):void {
			this.vista.adherirSplashIniciando();
			if (!verificandoDatos) {
				verificandoDatos = true;
				conexionBD.addEventListener(StatusEvent.STATUS, datosValidados, false, 10, true);
				conexionBD.loginCompany(vista.getNombreCompania(),vista.getContrasenaCompania(),new int(vista.getNumeroJuego()));
			} else {
				this.vista.splashSincronizando();
			}
		}
		
		private function datosValidados(e:StatusEvent):void {
			this.vista.quitarSplashIniciando();
			verificandoDatos = false;
			var dtoT:DTOTabla = conexionBD.retornarTablaDatos();
			conexionBD.removeEventListener(StatusEvent.STATUS, datosValidados);
			if (dtoT.datosFilas.length == 0) {
				var ss:SplashScreen = new SplashScreen("alguno/s de los\n3 datos ingresados\n esta/n erroneo/s", 3);
				ss.x = 400;
				ss.y = 300;
				vista.addChild(ss);
			} else {
				compania = new CompaniaDTO();
				compania.juego = new int((dtoT.datosFilas[0])["JUEGO_ID"]);
				compania.nombre = (dtoT.datosFilas[0])["NOMBRE"];
				compania.ubicacion_terrestre = new int((dtoT.datosFilas[0])["UBICACION_TERRESTRE"]);
				compania.costo_ultimo_turno = new int((dtoT.datosFilas[0])["COSTO_ULTIMO_TURNO"]);
				compania.password = (dtoT.datosFilas[0])["PASSWORD"];
				dispatchEvent(seIngresar);
			}
			
		}
		
		public function retornarCompania():CompaniaDTO {
			return(compania);
		}
		
	}

}