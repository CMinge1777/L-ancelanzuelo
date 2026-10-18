package
{
	import flash.display.Bitmap;
	import flash.display.Shader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author Fulgore
	 */
	public class VistaInicio extends Sprite
	{
		
		[Embed(source = 'data/graficos/vistas/VistaPrincipal.jpg')] private var Fondo:Class;
		[Embed(source = 'data/graficos/textos/Titlulo.png')] private var Titulo:Class;
		[Embed(source = 'data/graficos/botones/BotonJugar.png')] private var BotonJugar:Class;
		[Embed(source = 'data/graficos/textos/TextoCompania.png')] private var TXTCompania:Class;
		[Embed(source = 'data/graficos/textos/TextoContrasena.png')] private var TXTContrasena:Class;
		[Embed(source = 'data/graficos/textos/TextoJuego.png')] private var TXTjuego:Class;
		
		
		public static const PLAY_EVENT:String = "jugar";
		
		private var bmTitulo:Bitmap;
		private var bmBackGround:Bitmap;
		private var btPlay:IconoVisual;
		private var bmCompania:Bitmap;
		private var bmContrasena:Bitmap;
		private var bmJuego:Bitmap;
		private var tfCompania:TextField;
		private var tfContrasena:TextField;
		private var tfJuego:TextField;
		private var shTFBGCompania:Shape;
		private var shTFBGContrasena:Shape;
		private var shTFBGJuego:Shape;
		private var splashIniciando:SplashScreen;
		
		public function VistaInicio() {
			//inicializacion
			bmTitulo = new Titulo as Bitmap;
			bmBackGround = new Fondo as Bitmap;
			bmCompania = new TXTCompania as Bitmap;
			bmContrasena = new TXTContrasena as Bitmap;
			bmJuego = new TXTjuego as Bitmap;
			btPlay = new IconoVisual(BotonJugar);
			tfCompania = new TextField();
			tfContrasena = new TextField();
			tfJuego = new TextField();
			shTFBGCompania = new Shape();
			shTFBGContrasena = new Shape();
			shTFBGJuego = new Shape();
			var tf:TextFormat = new TextFormat();
			
			//modificacion de propiedades
			tf.font = "Verdana";
			tf.bold = true;
			tf.size = 20;
			tf.color = 0x001111;
			tf.align = TextFormatAlign.LEFT;
			tfCompania.defaultTextFormat = tf;
			tfCompania.type = TextFieldType.INPUT;
			tfCompania.width = 225;
			tfCompania.height = 35;
			tfContrasena.defaultTextFormat = tf;
			tfContrasena.type = TextFieldType.INPUT;
			tfContrasena.width = 225;
			tfContrasena.height = 35;
			tfContrasena.displayAsPassword = true;
			tfJuego.defaultTextFormat = tf;
			tfJuego.type = TextFieldType.INPUT;
			tfJuego.width = 225;
			tfJuego.height = 35;
			tfJuego.restrict = "1234567890";
			shTFBGCompania.graphics.beginFill(0xaa9954, 0.6);
			shTFBGCompania.graphics.drawRoundRect(0, 0, 225, 35, 10, 10);
			shTFBGContrasena.graphics.beginFill(0xaa9954, 0.6);
			shTFBGContrasena.graphics.drawRoundRect(0, 0, 225, 35, 10, 10);
			shTFBGJuego.graphics.beginFill(0xaa9954, 0.6);
			shTFBGJuego.graphics.drawRoundRect(0, 0, 225, 35, 10, 10);
			btPlay.addEventListener(MouseEvent.CLICK, playEvent);
			
			//adhecion al DL
			addChild(bmBackGround);
			addChild(bmTitulo);
			addChild(bmCompania);
			addChild(bmContrasena);
			addChild(bmJuego);
			addChild(btPlay);
			addChild(shTFBGCompania);
			addChild(shTFBGContrasena);
			addChild(shTFBGJuego);
			addChild(tfCompania);
			addChild(tfContrasena);
			addChild(tfJuego);
			
			
			//ubicacion
			bmTitulo.x = 30;
			bmTitulo.y = 30;
			bmCompania.x = 309;
			bmCompania.y = 145;
			bmContrasena.x = 285;
			bmContrasena.y = 190;
			bmJuego.x = 405;
			bmJuego.y = 234;
			btPlay.x = 650;
			btPlay.y = 320;
			tfCompania.x = 555;
			tfCompania.y = 148;
			tfContrasena.x = 555;
			tfContrasena.y = 193;
			tfJuego.x = 555;
			tfJuego.y = 236;
			shTFBGCompania.x = 555;
			shTFBGCompania.y = 145;
			shTFBGContrasena.x = 555;
			shTFBGContrasena.y = 190;
			shTFBGJuego.x = 555;
			shTFBGJuego.y = 233;
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			
			//PLACEHOLDER
			//tfCompania.text = "uno";
			//tfContrasena.text = "uno";
			//tfJuego.text = "7";
		}
		
		private function addedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed, false, 0, true);
		}
		
		private function keyPressed(e:KeyboardEvent):void 
		{
			if (e.keyCode == 13)
				playEvent();
		}
		
		public function iniciarLaVista():void {
			//posible metodo q hega tweens para mostrar las cosas
		}
		
		private function playEvent(e:MouseEvent = null):void {
			dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, "", PLAY_EVENT));
		}
		
		public function getNombreCompania():String {
			return(tfCompania.text);
		}
		
		public function getContrasenaCompania():String {
			return(tfContrasena.text);
		}
		
		public function getNumeroJuego():String {
			return (tfJuego.text);
		}
		
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