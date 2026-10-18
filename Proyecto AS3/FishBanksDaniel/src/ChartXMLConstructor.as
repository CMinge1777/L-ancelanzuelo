package  
{
	/**
	 * ...
	 * @author juan felipe from ILLUSIONWARE
	 */
	public class ChartXMLConstructor
	{
		private var minValueX:String;
		private var minValueY:String;
		private var maxValueX:String;
		private var maxValueY:String;
		private var mainCaption:String;
		private var height:String;
		private var widht:String;
		private var margin:String;
		private var theXML:XML;
		private var dataArray:Array;
		private var chartType:String;
		
		public static const LINE_CHART:String = "line";
		public static const BAR_CHART:String = "bar";
		
		public function ChartXMLConstructor(mainCaption:String, height:String, width:String, margin:String, chartType:String) 
		{
			this.chartType 	 = chartType;
			this.mainCaption = mainCaption;
			this.height		 = height;
			this.widht		 = width;
			if(int(margin) < 20)
				this.margin		 = "20";
			else
				this.margin		 = margin;
			
			theXML			   = <{"chart"}> </{"chart"}>;
			theXML.appendChild(<{"settings"} {"main_caption"}={mainCaption}{"height"}={height}{"width"}={width}{"margin"}={margin}{"min_x_val"}={0}{"max_x_val"}={0}{"min_y_val"}={0}{"max_y_val"}={0}> </{"settings"}>);
			theXML.appendChild(<{"figures"}> </{"figures"}>);
		}
		
		public function setData(dataArray:Array):void
		{
			this.dataArray = dataArray;
			var lowValueY:Number;
			var lowValueX:Number;
			var hightValueX:Number;
			var hightValueY:Number;
			
			for (var i:uint = 0; i < dataArray.length; i++ )
			{
				if (dataArray[i][0]) // si se pide dibujar linea horizontal entra a este
					theXML.settings.appendChild(<{"captionh"} {"x_val"}={dataArray[i][4]} {"line"}={"true"}>{dataArray[i][2]}</{"captionh"}>);	
				else if(dataArray[i][0] == "true")
					theXML.settings.appendChild(<{"captionh"} {"x_val"}={dataArray[i][4]}>{dataArray[i][2]}</{"captionh"}>);	
				
				if (dataArray[i][1]) // si se pide dibujar linea verical entra a este
					theXML.settings.appendChild(<{"captionv"} {"y_val"}={dataArray[i][5]} {"line"}={"true"}>{dataArray[i][3]}</{"captionv"}>);	
				else if(dataArray[i][0] == "true")
					theXML.settings.appendChild(<{"captionv"} {"y_val"}={dataArray[i][5]}>{dataArray[i][3]}</{"captionv"}>);	
				if(chartType == LINE_CHART)
					theXML.figures.appendChild(<{"dot"} {"x_val"}={dataArray[i][4]} {"y_val"}={dataArray[i][5]}>{dataArray[i][6]}</{"dot"}>);
				else if (chartType == BAR_CHART)
					theXML.figures.appendChild(<{"pile"} {"x_val"}={dataArray[i][4]} {"y_val"}={dataArray[i][5]}>{dataArray[i][6]}</{"pile"}>);
				if (i == 0)
				{
					lowValueX = hightValueX = dataArray[i][4]; 
					lowValueY = hightValueY = dataArray[i][5]; 
				}
				else
				{
					if (int(dataArray[i][5]) > hightValueY)
						hightValueY = dataArray[i][5];
					if (int(dataArray[i][5]) < lowValueY)
						lowValueY = dataArray[i][5];
					if (int(dataArray[i][4]) > hightValueX)
						hightValueX = dataArray[i][4];
					if (int(dataArray[i][4]) < lowValueX)
						lowValueX = dataArray[i][4];
				}
			}
			
			if (chartType == LINE_CHART)
			{
				theXML.settings.appendChild(<{"captionv"} {"y_val"}={lowValueY.toString()} {"line"}={"true"}>{lowValueY.toString()}</{"captionv"}>);	
				theXML.settings.appendChild(<{"captionv"} {"y_val"}={hightValueY.toString()} {"line"}={"true"}>{hightValueY.toString()}</{"captionv"}>);	
				if (lowValueY < 0)
					theXML.settings.appendChild(<{"captionv"} {"y_val"}={"0"} {"line"}={"true"}>{"0"}</{"captionv"}>);	
			}
			else if(chartType == BAR_CHART)
			{	
				lowValueY = 0;
			}
			theXML.settings.@min_x_val = lowValueX;
			theXML.settings.@min_y_val = lowValueY;
			theXML.settings.@max_x_val = hightValueX;
			theXML.settings.@max_y_val = hightValueY;
		}
		
		public function getData():Array
		{
			return(dataArray);
		}
		
		public function getXML():XML
		{
			return(theXML);
		}
	}
}