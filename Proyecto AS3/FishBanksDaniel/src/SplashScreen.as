package  {
	import com.gskinner.motion.GTween;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author Fulgore
	 */
	public class SplashScreen extends Sprite{
		
		private var tiempo:Number;
		private var mensaje:String;
		private var tween:GTween;
		private var tfMensaje:TextField;
		
		public function SplashScreen(mensaje:String, tiempo:Number) {
			//icializacion variables
			this.mensaje = mensaje;
			this.tiempo = tiempo;
			tfMensaje = new TextField();
			var tf:TextFormat = new TextFormat();
			if(tiempo>0){
				tween = new GTween(this, this.tiempo, { alpha:0 } );
			} 
			
			//modificacion de propiedades
			tf.font = "Maiandra GD";
			tf.size = 15;
			tf.color = 0xFFFFFF;
			tf.align = TextFormatAlign.CENTER;
			tfMensaje.selectable = false;
			//tfMensaje.border = true;
			//tfMensaje.borderColor = 0xaa9955;
			tfMensaje.background = true;
			tfMensaje.backgroundColor = 0x001111;
			tfMensaje.defaultTextFormat = tf;
			tfMensaje.text = this.mensaje;
			tfMensaje.width = tfMensaje.textWidth + 6;
			tfMensaje.height = tfMensaje.textHeight + 4;
			if (tiempo > 0) {
				tween.onComplete = destroyMySelf;
			}
			
			//adding dl
			addChild(tfMensaje);
			
			this.x = 400 - (this.width / 2);
			this.x = 300 - (this.height / 2);
		}
		
		private function destroyMySelf(gt:GTween):void {
			//this.parent.removeChild(this);
			this.parent.removeChildAt(this.parent.getChildIndex(this));
		}
		
		public function destroyMe():void {
			//tween.end();
			this.parent.removeChildAt(this.parent.getChildIndex(this));
			
		}
	}
}