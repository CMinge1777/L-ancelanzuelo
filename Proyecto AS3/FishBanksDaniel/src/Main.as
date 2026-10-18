package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.StatusEvent;
	
	/**
	 * ...
	 * @author Fulgore
	 */
	public class Main extends Sprite 
	{
		
		private var vista_inicio:VistaInicio;				// se identifica con el 1
		private var vista_golfo:VistaGolfo;					// se identifica con el 2
		private var vista_compania:VistaCompania;			// se identifica con el 3
		private var control_inicio:ControladorInicio;
		private var control_golfo:ControladorGolfo;
		private var control_compania:ControladorCompania;
		private var conexionBD:DataBaseConexion;
		private var maskara:Bitmap;
		private var compania:CompaniaDTO;
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//this.tabChildren = false;
			// entry point
			//MASCARA VISUAL
			maskara = new Bitmap(new BitmapData(800, 600, false, 0xffffff));
			this.mask = maskara;
			addChild(maskara);
			
			//inicializacion de variables
			compania = new CompaniaDTO();
			conexionBD = new DataBaseConexion();
			control_inicio = new ControladorInicio(conexionBD);
			control_golfo = new ControladorGolfo(conexionBD);
			control_compania = new ControladorCompania(conexionBD);
			
			adherirVista(1);
		}
		
		private function adherirVista(screen:int):void {
			switch(screen) {
				case 1:  {
						vista_inicio = new VistaInicio();
						addChild(vista_inicio);
						control_inicio.controlar(vista_inicio);
						control_inicio.addEventListener(StatusEvent.STATUS, escuchadorControlador, false, 0, true);
					break;
				} case 2:  {
						vista_golfo = new VistaGolfo();
						addChild(vista_golfo);
						control_golfo.ingresarJuegoYCompania(compania);
						control_golfo.controlar(vista_golfo);
						control_golfo.addEventListener(StatusEvent.STATUS, escuchadorControlador, false, 0, true);
					break;
				} case 3:  {
						vista_compania = new VistaCompania();
						addChild(vista_compania);
						control_compania.ingresarJuegoYCompania(compania);
						control_compania.controlar(vista_compania);
						control_compania.addEventListener(StatusEvent.STATUS, escuchadorControlador, false, 0, true);
					break;
				}
			}
		}
		
		private function removerVista(screen:int):void {
			switch(screen) {
				case 1:  {
						removeChild(vista_inicio);
						compania = control_inicio.retornarCompania();
						vista_inicio = null;
						control_inicio.removeEventListener(StatusEvent.STATUS, escuchadorControlador);
						control_inicio = null;
						control_inicio = new ControladorInicio(conexionBD);
					break;
				} case 2:  {
						removeChild(vista_golfo);
						vista_golfo = null;
						control_golfo.removeEventListener(StatusEvent.STATUS, escuchadorControlador);
						control_golfo = null;
						control_golfo = new ControladorGolfo(conexionBD);
					break;
				} case 3:  {
						removeChild(vista_compania);
						vista_compania = null;
						control_compania.removeEventListener(StatusEvent.STATUS, escuchadorControlador);
						control_compania = null;
						control_compania = new ControladorCompania(conexionBD);
					break;
				}
			}
		}
		
		private function escuchadorControlador(se:StatusEvent):void {
			if (se.currentTarget === control_inicio) {
				removerVista(1);
				adherirVista(2);
			} else if (se.currentTarget === control_golfo) {
				removerVista(2);
				adherirVista(3);
			} else if (se.currentTarget === control_compania) {
				removerVista(3);
				adherirVista(2);
			}
		}
		
		//funcion para ejecutar algo antes de iniciar la vista, como por ejemplo una pantalla de trancicion o un fade-in, etc.
		private function preVista():void { }
		//funcion para ejecutar algo antes de cerrar la vista, como por ejemplo una pantalla de trancicion o un fade-out, etc.
		private function posVista():void { }
	}
	
}