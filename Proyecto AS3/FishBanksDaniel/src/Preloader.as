package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Fulgore
	 */
	

	public class Preloader extends MovieClip 
	{
		private var maiandraGD:TextFormat;
		public var loadProgressT:TextField;
		public var illusionwareName:TextField;
		public var percent:int;
		//public var playField:Sprite;
		
		public function Preloader() {
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			// show loader
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageEvents, false, 0, true);
			//playField = new Sprite();
			
			maiandraGD = new TextFormat();
			//maiandraGD.font = "Maiandra GD";
			maiandraGD.color = 0x000000;
			maiandraGD.size = 40;
			
			loadProgressT = new TextField();
			loadProgressT.defaultTextFormat = maiandraGD;
			loadProgressT.text = "000 %";
			loadProgressT.width = loadProgressT.textWidth + 5;
			loadProgressT.selectable = false;
			
			maiandraGD.size = 20;
			maiandraGD.align = TextFormatAlign.CENTER;
			
			illusionwareName = new TextField();
			illusionwareName.embedFonts = true;
			illusionwareName.defaultTextFormat = maiandraGD;
			illusionwareName.text = "Hecho por/Made By - Illusionware Games";
			//trace(illusionwareName.textWidth);
			//illusionwareName.width = illusionwareName.textWidth + 5;
			illusionwareName.selectable = false;
			
			maiandraGD.size = 100;
			maiandraGD.align = TextFormatAlign.LEFT;
			
			//addhiriendo hijos
			addChild(loadProgressT);
			addChild(illusionwareName);
			
			//posisionar los childs
			loadProgressT.x = 400 - (loadProgressT.width / 2);
			loadProgressT.y = 50;
			//illusionwareName.x = 400 - (illusionwareName.width / 2);
			//trace(illusionwareName.textWidth);
			illusionwareName.x = 150 ;
			illusionwareName.y = 440;
			//playField.x = 400 - (playField.width / 2);
			//playField.y = 370;
			
		}
		
		private function addedToStageEvents(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageEvents);
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
		
		private function progress(e:ProgressEvent):void {
			// update loader
			percent = (e.bytesLoaded / e.bytesTotal) * 100;
			var sp:String = percent + " %";
			loadProgressT.text = sp;
		}
		
		private function checkFrame(e:Event):void {
			if (currentFrame == totalFrames) {
				removeEventListener(Event.ENTER_FRAME, checkFrame);
				//startup();
				maiandraGD.color = 0x000000;
				maiandraGD.size = 26;
				//var tx:TextField = new TextField();
				//tx.defaultTextFormat = maiandraGD;
				//tx.text = "INICIO";
				//tx.x = 3;
				//tx.y = 3;
				//tx.selectable = false;
				//playField.graphics.beginFill(0xFFFFFF);
				//playField.graphics.drawRoundRect(0, 0, 6 + tx.textWidth + 6 , tx.textHeight , 8, 8);
				//playField.graphics.endFill();
				//playField.addChild(tx);
				//playField.x = 400 - (playField.width / 2);
				//addChild(playField);
				//playField.addEventListener(MouseEvent.CLICK, startup);
				//loadProgressT.text = "100%"; // solo para FlashGameLicense
				startup();
			}
		}
		
		private function startup(/*e:MouseEvent*/):void 
		{
			// hide loader
			//playField.removeEventListener(MouseEvent.CLICK, startup);
			
			removeChild(loadProgressT);
			//removeChild(playField);
			removeChild(illusionwareName);
			
			maiandraGD = null;
			loadProgressT = null;
			//playField = null;
			illusionwareName = null;
			
			stop();
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass() as DisplayObject);
		}
		
	}
	
}