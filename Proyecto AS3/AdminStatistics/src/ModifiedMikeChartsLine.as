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
	
	public class ModifiedMikeChartsLine extends MovieClip
	{
		
		private var chartXMLList:XMLList;
		private var chart_height:int;
		private var chart_width:int;
		private var x_scope:int;
		private var y_scope:int;
		private var chart_margin:int;
		private var dotArrayX:Array;
		private var dotArrayY:Array;
		
		public function ModifiedMikeChartsLine():void
		{			
			dotArrayX = [];
			dotArrayY = [];
		}
		
		public function loadDataXML(theXML:XML):void 
		{
			var d:uint;
			var s:uint;
			var v:uint;
			var y_Label:MovieClip
			var graphLine:Sprite
			var point_x:int;
			var point_y:int;
			var dot_mc:MovieClip
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
				x_Label.vertLine_mc.height = chart_height + (chart_margin * 2);
				x_Label.vertLine_mc.y = -chart_height - (chart_margin);
				x_Label.label_txt.text = chartXMLList.settings.captionh[b];
				addChild(x_Label);
			}
			
			if (int(chartXMLList.settings.@min_y_val) > 0) 
			{
				//	we add horizontal lines
				for (v = 0; v <= chartXMLList.settings.captionv.length() - 1; v++) {
					y_Label = new y_LabelMC();
					y_Label.horizLine_mc.width = chart_width;
					y_Label.y = -((int(chartXMLList.settings.captionv[v].@y_val) - Math.abs(int(chartXMLList.settings.@min_y_val))) * chart_height / y_scope) - chart_margin/2;
					y_Label.label_txt.text = chartXMLList.settings.captionv[v];
					addChild(y_Label);
				}
				
				// 	we add the data segments
				graphLine = new Sprite();
				addChild(graphLine);
				graphLine.graphics.lineStyle(3, 0x333333);	
				for (d = 0; d <= chartXMLList.figures.dot.length() - 1; d++) {
					point_x;
					point_y;
					if (d == 0) {
						point_x = ((int(chartXMLList.figures.dot[0].@x_val) + Math.abs(int(chartXMLList.settings.@min_x_val))) * chart_width / x_scope);
						point_y = -((int(chartXMLList.figures.dot[0].@y_val) - Math.abs(int(chartXMLList.settings.@min_y_val))) * chart_height / y_scope) - chart_margin/2;
						//point_y = ((int(chartXMLList.figures.pile[0].@y_val) + Math.abs(int(chartXMLList.settings.@min_y_val))) * chart_height / y_scope) - chart_margin/2;
						graphLine.graphics.moveTo(point_x, point_y);
					}else{
						point_x = ((int(chartXMLList.figures.dot[d].@x_val) + Math.abs(int(chartXMLList.settings.@min_x_val))) * chart_width / x_scope);
						point_y = -((int(chartXMLList.figures.dot[d].@y_val) - Math.abs(int(chartXMLList.settings.@min_y_val))) * chart_height / y_scope) - chart_margin/2;
						graphLine.graphics.lineTo(point_x, point_y);
					}
					dotArrayX.push(int(point_x));
					dotArrayY.push(int(point_y));
				}
				
				//	Now we add the dots and load some data on it
				for (s = 0; s <= chartXMLList.figures.dot.length() - 1; s++) {
					dot_mc = new chartDotMC();
					dot_mc.x = dotArrayX[s];
					dot_mc.y = dotArrayY[s];
					addChild(dot_mc);
					dot_mc.buble_mc.bub_title_txt.text = chartXMLList.figures.dot[s];
					dot_mc.buble_mc.y_val_txt.text = chartXMLList.figures.dot[s].@y_val;
					dot_mc.addEventListener(MouseEvent.ROLL_OVER, showBuble);
					dot_mc.addEventListener(MouseEvent.ROLL_OUT, hideBuble);
					dot_mc.buttonMode = true;
					dot_mc.buble_mc.visible = false;
				}
			}/********************************************************************************/
			else
			{
				//	we add horizontal lines
				for (v = 0; v <= chartXMLList.settings.captionv.length() - 1; v++) {
					y_Label = new y_LabelMC();
					y_Label.horizLine_mc.width = chart_width;
					y_Label.y = -((int(chartXMLList.settings.captionv[v].@y_val) + Math.abs(int(chartXMLList.settings.@min_y_val))) * chart_height / y_scope) - chart_margin/2;
					y_Label.label_txt.text = chartXMLList.settings.captionv[v];
					addChild(y_Label);
				}
				
				// 	we add the data segments
				graphLine = new Sprite();
				addChild(graphLine);
				graphLine.graphics.lineStyle(3, 0x333333);	
				for (d = 0; d <= chartXMLList.figures.dot.length() - 1; d++) {
					point_x;
					point_y;
					if (d == 0) {
						point_x = ((int(chartXMLList.figures.dot[0].@x_val) + Math.abs(int(chartXMLList.settings.@min_x_val))) * chart_width / x_scope);
						point_y = -((int(chartXMLList.figures.dot[0].@y_val) + Math.abs(int(chartXMLList.settings.@min_y_val))) * chart_height / y_scope) - chart_margin/2;
						//point_y = ((int(chartXMLList.figures.pile[0].@y_val) + Math.abs(int(chartXMLList.settings.@min_y_val))) * chart_height / y_scope) - chart_margin/2;
						graphLine.graphics.moveTo(point_x, point_y);
					}else{
						point_x = ((int(chartXMLList.figures.dot[d].@x_val) + Math.abs(int(chartXMLList.settings.@min_x_val))) * chart_width / x_scope);
						point_y = -((int(chartXMLList.figures.dot[d].@y_val) + Math.abs(int(chartXMLList.settings.@min_y_val))) * chart_height / y_scope) - chart_margin/2;
						graphLine.graphics.lineTo(point_x, point_y);
					}
					dotArrayX.push(int(point_x));
					dotArrayY.push(int(point_y));
				}
				
				//	Now we add the dots and load some data on it
				for (s = 0; s <= chartXMLList.figures.dot.length() - 1; s++) {
					dot_mc = new chartDotMC();
					dot_mc.x = dotArrayX[s];
					dot_mc.y = dotArrayY[s];
					addChild(dot_mc);
					dot_mc.buble_mc.bub_title_txt.text = chartXMLList.figures.dot[s];
					dot_mc.buble_mc.y_val_txt.text = chartXMLList.figures.dot[s].@y_val;
					dot_mc.addEventListener(MouseEvent.ROLL_OVER, showBuble);
					dot_mc.addEventListener(MouseEvent.ROLL_OUT, hideBuble);
					dot_mc.buttonMode = true;
					dot_mc.buble_mc.visible = false;
				}
			}
			this.y = chart_height * 1.3;
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