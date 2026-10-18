package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import flash.filters.BevelFilter;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	
	/**
	 * ...
	 * @author Fulgore
	 */
	public class IconoVisual extends SimpleButton
	{
		public static const CLICKED:String = "clicked";
		
		private var bmGraficoUp:Bitmap;
		private var bmGraficoOn:Bitmap;
		private var bmGraficoPress:Bitmap;
		private var bmGraficoHit:Bitmap;
		private var nombreIcono:String;
		
		public function IconoVisual(graficoBitmap:Class,nombre:String = "") {
			
			//inicializacion var
			nombreIcono = nombre;
			bmGraficoUp = new graficoBitmap as Bitmap;
			bmGraficoOn = new graficoBitmap as Bitmap;
			bmGraficoPress = new graficoBitmap as Bitmap;
			bmGraficoHit = new Bitmap(new BitmapData(bmGraficoUp.width, bmGraficoUp.height, false, 0x000000));
			//bmGraficoUp.filters = [];
			bmGraficoOn.filters = [new GlowFilter(0xaa9955,.8,6,6)];
			bmGraficoPress.filters = [new GlowFilter(0xaa9955, .8,6,6,2,1,true)];
			super(bmGraficoUp, bmGraficoOn, bmGraficoPress, bmGraficoHit);
			if(nombre != ""){
				addEventListener(MouseEvent.MOUSE_OVER, showName, false, 0, true);
			}
			
			//modificacion de propiedades
		}
		
		private function showName(e:MouseEvent):void {
			
			var splash:SplashScreen = new SplashScreen(nombreIcono, 2.5);
			splash.x = this.x + (this.width/2) - (splash.width/2);
			splash.y = this.y + (this.height/2) - (splash.height/2);
			this.parent.addChild(splash);
		}
	}

}