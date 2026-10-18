package  
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author 
	 */
	public class VistaEstadisticas extends MovieClip
	{
		
		[Embed(source = 'data/graficos/botones/X.png')] public var XGraph:Class;
		[Embed(source = 'data/graficos/botones/Captura.png')] public var CapturaGraph:Class;
		[Embed(source = 'data/graficos/botones/Balance.png')] public var BalanceGraph:Class;
		
		public static const CERRAR:String = "cierre";
		
		private var datosEstadisticos:Vector.<ReporteDTO>;
		private var graficoEstadisticoLinea:chartMC;
		private var graficoEstadisticoBarra:barChartMC;
		
		public function VistaEstadisticas(graphData:Vector.<ReporteDTO>) 
		{
			var dibujo:Sprite = new Sprite;
			dibujo.graphics.lineStyle(3, 0x000000, 1);
			dibujo.graphics.beginFill(0xFFF9B9, 2);
			dibujo.graphics.drawRect(0,0,640,480);
			dibujo.graphics.endFill();
			addChild(dibujo);
			dibujaLineasCuaderno();
			pintarVentana();
			datosEstadisticos = graphData;
			graficoEstadisticoBarra = new barChartMC;
			graficoEstadisticoLinea = new chartMC;
		}
		
		public function dibujaLineasCuaderno():void
		{
			var lineas:Sprite = new Sprite;
			lineas.graphics.lineStyle(1, 0x808080, 0.8);
			for (var i:int = 1; i <= 11; i++ )
			{
				lineas.graphics.moveTo(0, i * 40);
				lineas.graphics.lineTo(640, i * 40);
			}
			lineas.graphics.moveTo(560 , 0);
			lineas.graphics.lineTo(560, 480);
			
			addChild(lineas);
		}
		
		public function pintarVentana():void
		{
			// Boton Cerrar
			
			var botonCerrarUp:Bitmap;
			var botonCerrarDown:Bitmap;
			var botonCerrar:SimpleButton;
			
			botonCerrarUp  = new XGraph as Bitmap;
			botonCerrarDown  = new XGraph as Bitmap;
			botonCerrar = new SimpleButton();			
			
			botonCerrarUp.scaleX = botonCerrarUp.scaleY = 0.5;
			botonCerrarDown.scaleX = botonCerrarDown.scaleY = 0.4;
			
			botonCerrar.upState = botonCerrarUp;
			botonCerrar.downState = botonCerrarDown;
			botonCerrar.overState = botonCerrarUp;
			botonCerrar.hitTestState = botonCerrar.upState;
			
			botonCerrarDown.x = 5;
			botonCerrarDown.y = 5;
			
			botonCerrar.x = 610;
			botonCerrar.y = 10;
			
			addChild(botonCerrar);
			botonCerrar.addEventListener(MouseEvent.CLICK, cerrar, false, 0, true);
			botonCerrar.tabEnabled = false;
			
			// Titulo
			var titulo:TextField = new TextField();
			titulo.text = "Estadisticas";
			titulo.x = 10;
			titulo.y = 10;
			titulo.width = 300;
			var estiloTitulo:TextFormat = new TextFormat();
			estiloTitulo.font = "Maiandra GD";
			estiloTitulo.size = 25;
			estiloTitulo.bold = true;
			estiloTitulo.color = 0x0C676B;
			titulo.selectable = false;
			titulo.setTextFormat(estiloTitulo);			
			addChild(titulo);	
			
			// Boton de balance
						
			var botonBalanceUp:Bitmap;
			var botonBalanceDown:Bitmap;
			var botonBalance:SimpleButton;
			
			botonBalanceUp  = new BalanceGraph as Bitmap;
			botonBalanceDown  = new BalanceGraph as Bitmap;
			botonBalance = new SimpleButton();			
			
			botonBalanceUp.scaleX = botonBalanceUp.scaleY = 0.8;
			botonBalanceDown.scaleX = botonBalanceDown.scaleY = 0.7;
			
			botonBalance.upState = botonBalanceUp;
			botonBalance.downState = botonBalanceDown;
			botonBalance.overState = botonBalanceUp;
			botonBalance.hitTestState = botonBalance.upState;
			
			botonBalanceDown.x = 5;
			botonBalanceDown.y = 5;
			
			botonBalance.x = 10;
			botonBalance.y = 50;
			
			addChild(botonBalance);
			botonBalance.addEventListener(MouseEvent.CLICK, estadisticasBalance, false, 0, true);
			botonBalance.tabEnabled = false;
			
			// Boton de captura
			
			var botonCapturaUp:Bitmap;
			var botonCapturaDown:Bitmap;
			var botonCaptura:SimpleButton;
			
			botonCapturaUp  = new CapturaGraph as Bitmap;
			botonCapturaDown  = new CapturaGraph as Bitmap;
			botonCaptura = new SimpleButton();			
			
			botonCapturaUp.scaleX = botonCapturaUp.scaleY = 0.8;
			botonCapturaDown.scaleX = botonCapturaDown.scaleY = 0.7;
			
			botonCaptura.upState = botonCapturaUp;
			botonCaptura.downState = botonCapturaDown;
			botonCaptura.overState = botonCapturaUp;
			botonCaptura.hitTestState = botonCaptura.upState;
			
			botonCapturaDown.x = 5;
			botonCapturaDown.y = 5;
			
			botonCaptura.x = 510;
			botonCaptura.y = 50;
			
			addChild(botonCaptura);
			botonCaptura.addEventListener(MouseEvent.CLICK, estadisticasCaptura, false, 0, true);
			botonCaptura.tabEnabled = false;
			
		}
		
		private function estadisticasBalance(e:MouseEvent):void 
		{
			// Removemos el grafico si lo hay
			if (graficoEstadisticoBarra && this.contains(graficoEstadisticoBarra))
			{
				this.removeChild(graficoEstadisticoBarra);
				graficoEstadisticoBarra = null;
			}
			if (graficoEstadisticoLinea && this.contains(graficoEstadisticoLinea))
			{
				this.removeChild(graficoEstadisticoLinea);
				graficoEstadisticoLinea = null;
			}
			
			var xmlData:ChartXMLConstructor 	= new ChartXMLConstructor("Estadisticas Balance", "200", "400", "20", ChartXMLConstructor.LINE_CHART);
			graficoEstadisticoLinea  	= new chartMC();
			var debugData:DebugStatisticalData  = new DebugStatisticalData();
			
			addChild(graficoEstadisticoLinea);
			graficoEstadisticoLinea.x = 100;
			xmlData.setData(debugData.GetGeneralBalanceData(datosEstadisticos));
			graficoEstadisticoLinea.loadDataXML(xmlData.getXML());
			graficoEstadisticoLinea.y = 400;
			graficoEstadisticoLinea.tabChildren = false;
		}
		
		private function estadisticasCaptura(e:MouseEvent):void 
		{
			// Removemos el grafico si lo hay
			if (graficoEstadisticoBarra && this.contains(graficoEstadisticoBarra))
			{
				this.removeChild(graficoEstadisticoBarra);
				graficoEstadisticoBarra = null;
			}
			if (graficoEstadisticoLinea && this.contains(graficoEstadisticoLinea))
			{
				this.removeChild(graficoEstadisticoLinea);
				graficoEstadisticoLinea = null;
			}
			
			var xmlData:ChartXMLConstructor 	= new ChartXMLConstructor("Estadisticas Captura", "200", "560", "20", ChartXMLConstructor.BAR_CHART);
			graficoEstadisticoBarra	= new barChartMC();
			var debugData:DebugStatisticalData  = new DebugStatisticalData();
			var datosEstadisticosBarra:Vector.<ReporteDTO> = datosEstadisticos.slice(1,datosEstadisticos.length);
			addChild(graficoEstadisticoBarra);
			graficoEstadisticoBarra.x = 40;
			xmlData.setData(debugData.GetFishingReportData(datosEstadisticosBarra));
			graficoEstadisticoBarra.loadDataXML(xmlData.getXML());
			graficoEstadisticoBarra.y = 400;
			graficoEstadisticoBarra.tabChildren = false;
		}
		
		private function cerrar(e:MouseEvent):void
		{
			dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, "", CERRAR));
			// Le devuelve el control a lo otro y se muere
		} 
		
		
		
		
		
	}

}