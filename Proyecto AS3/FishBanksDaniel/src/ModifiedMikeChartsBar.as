package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	/**
	 * Do whatever you want with this file, even money if it's what you like doing ;)
	 * Just make sure you come visit my website more often!
	 * http://wordpress.mikeland.us	
	 * @author mike
	*/
	
	public class ModifiedMikeChartsBar extends MovieClip
	{
		
		private var chartXMLList:XMLList;
		private var chart_height:int;
		private var chart_width:int;
		private var x_scope:int;
		private var y_scope:int;
		private var chart_margin:int;
		private var dotArrayX:Array;
		private var dotArrayY:Array;
		
		public function ModifiedMikeChartsBar() 
		{
			dotArrayX = [];
			dotArrayY = [];
		}
		
		public function loadDataXML(theXML:XML):void 
		{
			var chartXML:XML = theXML;
			chartXMLList = new XMLList(chartXML);	
			
			//	passing the layout properties from <settings> in the xml
			chart_height = chartXMLList.settings.@height;
			chart_width = chartXMLList.settings.@width;
			x_scope = int(chartXMLList.settings.@max_x_val) - int(chartXMLList.settings.@min_x_val);
			y_scope = int(chartXMLList.settings.@max_y_val) - int(chartXMLList.settings.@min_y_val);
			chart_margin = chartXMLList.settings.@margin;
			(this.getChildByName("topHead_mc") as MovieClip).y = -(chart_height)- (chart_margin * 2);
			((this.getChildByName("topHead_mc") as MovieClip).getChildByName("line_top_mc")as MovieClip).width = chart_width;
			(this.getChildByName("footLine_mc") as MovieClip).width = chart_width;
			(this.getChildByName("zeroVLine_mc") as MovieClip).height = chart_height + (chart_margin * 3);
			(this.getChildByName("zeroVLine_mc") as MovieClip).y = chartXMLList.settings.@margin;
			((this.getChildByName("topHead_mc") as MovieClip).getChildByName("label_txt") as TextField).text = chartXMLList.settings.@main_caption;
			
			
			// 	we add vertical lines
			for (var b:uint = 0; b <= chartXMLList.settings.captionh.length() - 1; b++) {
				var x_Label:MovieClip = new x_LabelMC();
				x_Label.x = int(chartXMLList.settings.captionh[b].@x_val) * chart_width / x_scope;
				x_Label.vertLine_mc.height = (chart_height + (chart_margin * 2));
				x_Label.vertLine_mc.y = (-chart_height - (chart_margin));
				x_Label.label_txt.text = chartXMLList.settings.captionh[b];
				addChild(x_Label);
			}
			chart_margin = 0;
			//	we add horizontal lines
			for (var v:uint = 0; v <= chartXMLList.settings.captionv.length() - 1; v++) {
				var y_Label:MovieClip = new y_LabelMC();
				y_Label.horizLine_mc.width = chart_width;
				y_Label.y = ( -((int(chartXMLList.settings.captionv[v].@y_val) + Math.abs(int(chartXMLList.settings.@min_y_val))) * chart_height / y_scope) - chart_margin / 2)*0.85;
				y_Label.label_txt.text = chartXMLList.settings.captionv[v];
				addChild(y_Label);
			}
			
			// 	we add the data segments
			var graphLine:Sprite = new Sprite();
			addChild(graphLine);
			graphLine.graphics.lineStyle(3, 0x333333);	
			for (var d:uint = 0; d <= chartXMLList.figures.pile.length() - 1; d++) {
				var point_x:int;
				var point_y:int;
				if (d == 0) {
					point_x = ((int(chartXMLList.figures.pile[0].@x_val) + Math.abs(int(chartXMLList.settings.@min_x_val))) * chart_width / x_scope);
					point_y = ((int(chartXMLList.figures.pile[0].@y_val) + Math.abs(int(chartXMLList.settings.@min_y_val))) * chart_height / y_scope) - chart_margin/2;
				}else{
					point_x = ((int(chartXMLList.figures.pile[d].@x_val) + Math.abs(int(chartXMLList.settings.@min_x_val))) * chart_width / x_scope);
					point_y = ((int(chartXMLList.figures.pile[d].@y_val) + Math.abs(int(chartXMLList.settings.@min_y_val))) * chart_height / y_scope) - chart_margin/2;
				}
				dotArrayX.push(int(point_x));
				dotArrayY.push(int(point_y));
			}
			
			//	Now we add the dots and load some data on it
			for (var s:uint = 0; s <= chartXMLList.figures.pile.length() - 1; s++) {
				var pile_mc:MovieClip = new chartPileMC();
				pile_mc.x = chart_margin/2 + s * (chart_width / chartXMLList.figures.pile.length());
				pile_mc.y = -(chart_margin/2)*0;
				pile_mc.pilon_mc.height = int(dotArrayY[s])*0.85;
				pile_mc.pilon_mc.width = chart_width / chartXMLList.figures.pile.length();
				pile_mc.hitArea_btn.height = pile_mc.pilon_mc.height;
				pile_mc.hitArea_btn.height = pile_mc.pilon_mc.width;
				
				pile_mc.buble_mc.y = -(pile_mc.pilon_mc.height);
				
				addChild(pile_mc);
				pile_mc.buble_mc.bub_title_txt.text = chartXMLList.figures.pile[s];
				pile_mc.buble_mc.y_val_txt.text = getFormatedMoney(new Number(chartXMLList.figures.pile[s].@y_val));
				pile_mc.addEventListener(MouseEvent.ROLL_OVER, showBuble);
				pile_mc.addEventListener(MouseEvent.ROLL_OUT, hideBuble);
				pile_mc.buttonMode = true;
				pile_mc.buble_mc.visible = false;
				trace(pile_mc.pilon_mc.height);
			}
			
			this.y = chart_height * 1.3;
		}	
			
		private function getFormatedMoney(value:Number):String
		{
			var formatedMoney:String = new String();
			var stringValue:String = value.toString();
			if (value < 0)
				stringValue = stringValue.slice(1, stringValue.length);
			if(stringValue.length % 3 != 0)
				formatedMoney = formatedMoney + stringValue.slice(0, stringValue.length % 3)+".";
			var i:uint = stringValue.length % 3;
			var numerOfDivisors:int = stringValue.length / 3;		
			for (i; i < stringValue.length; i++ )
			{
				formatedMoney = formatedMoney + stringValue.slice(i, i + 3) + ".";
				i = i + 2;
			}
			return(formatedMoney.slice(0,formatedMoney.length-1));
		}
		
		private function hideBuble(e:MouseEvent):void 
		{
			e.currentTarget.buble_mc.visible = false;
		}
		
		private function showBuble(e:MouseEvent):void 
		{
			e.currentTarget.buble_mc.visible = true;
		}
		
	}
}