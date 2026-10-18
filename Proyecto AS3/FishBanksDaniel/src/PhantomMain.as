package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class PhantomMain extends Sprite 
	{
		
		public function PhantomMain():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);				
		}
		
		private function init(e:Event = null):void 
		{
			trace("added");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//var ventana:VistaPedidos =  new VistaPedidos(20000000);
			
			// un array de prueba de barcos
			var barcos:Array = new Array();
			barcos.push(new Chalupa());
			barcos.push(new Chalupa());
			barcos.push(new Chalupa());
			
			barcos.push(new Panga());
			barcos.push(new Panga());
			
			barcos.push(new Pesquero());
			barcos.push(new Pesquero());
			barcos.push(new Pesquero());
			barcos.push(new Pesquero());
			
			//var ventana:VistaSubasta =  new VistaSubasta();
			
			//var ventana:VistaPosicion =  new VistaPosicion();
			
			//var ventana:VistaNoticias =  new VistaNoticias();
			
			var ventana:VistaEstadisticas = new VistaEstadisticas();

			//var ventana:VistaAdminMenu = new VistaAdminMenu();
			
			//var ventana:VistaAdminCrearJuego = new VistaAdminCrearJuego();
			
			//var ventana:VistaBanco = new VistaBanco();
			
			addChild(ventana);			
			ventana.x = 0;
			ventana.y = 0;
			// entry point
		}
		
	}
	
}