package  
{
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author 
	 */
	public class VistaBanco extends Sprite 
	{
		[Embed(source = 'data/graficos/botones/X.png')] public var XGraph:Class;
		public static const CERRAR:String = "cierre";
		
		private var datosReporte:Vector.<ReporteDTO>;
		private var datosPeces:Vector.<TipoPezDTO>;
		private var costoOperativo:int;
		
		public function VistaBanco(data:Vector.<ReporteDTO>,dataPeces:Vector.<TipoPezDTO>, costo:int) 
		{
			var dibujo:Sprite = new Sprite;
			datosReporte   = data;
			datosPeces     = dataPeces;
			costoOperativo = costo;
			dibujo.graphics.lineStyle(3, 0x000000, 1);
			dibujo.graphics.beginFill(0xFFF9B9, 2);
			dibujo.graphics.drawRect(0,0,640,480);
			dibujo.graphics.endFill();
			addChild(dibujo);
			dibujaLineasCuaderno();
			pintarVentana();
			agregarDatos();
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
			titulo.text = "Estado de resultados";
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
			
			dibujarBalance();
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
			if(value < 0)
				return("-" + formatedMoney.slice(0, formatedMoney.length - 1));
			else
				return(formatedMoney.slice(0, formatedMoney.length - 1));
		}
		
		public function cerrar(event:Event):void
		{
			dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, "", CERRAR));
			// Le devuelve el control a lo otro y se muere
		} 
		
		public function dibujarBalance():void
		{
			// Dibujamos lo que se va a mostrar en balance
			// No estoy seguro de que se muestra aqui
		}
		
		private function agregarDatos():void
		{
			var nombreColumnas:Array = new Array("Pargo costa	", "Pargo mar profundo	", "Robalo costa	");
			var datosTabla:Array     = new Array();
			var capturaPargo:uint;
			var capturaSierra:uint;
			var capturaRobalo:uint;
			var valorVenta:uint;
			var arregloAux:Array = new Array();
			var balanceAnterior:Number = 0;
			var balanceActual:Number = 0;
			var posicion:uint = datosReporte.length - 1;
			
			arregloAux.push(getFormatedMoney(datosReporte[posicion].captura_pargo_costa));
			arregloAux.push(getFormatedMoney(datosReporte[posicion].captura_pargo_mar_profundo));
			arregloAux.push(getFormatedMoney(datosReporte[posicion].captura_robalo_costa));
			datosTabla.push(arregloAux);
			
			var tabla:UITable = new UITable(nombreColumnas, datosTabla, 580, 50);
			addChild(tabla);
			tabla.x = 40;
			tabla.y = 100;
			
			arregloAux = new Array();
			datosTabla = new Array();
			nombreColumnas = new Array("Robalo mar profundo	", "Sierra costa	", "Sierra mar profundo	");
			arregloAux.push(getFormatedMoney(datosReporte[posicion].captura_robalo_mar_profundo));
			arregloAux.push(getFormatedMoney(datosReporte[posicion].captura_sierra_costa));
			arregloAux.push(getFormatedMoney(datosReporte[posicion].captura_sierra_mar_proundo));
			
			datosTabla.push(arregloAux);
			var tabla2:UITable = new UITable(nombreColumnas, datosTabla, 580, 50);
			addChild(tabla2);
			tabla2.x = 40;
			tabla2.y = 180;
			
			arregloAux = new Array();
			datosTabla = new Array();
			nombreColumnas = new Array("Valor venta", "Costo operativo", "Balance anterior");
			capturaPargo  = uint(datosReporte[datosReporte.length - 1].captura_pargo_costa) + uint(datosReporte[datosReporte.length - 1].captura_pargo_mar_profundo);
			capturaRobalo = uint(datosReporte[datosReporte.length - 1].captura_robalo_costa) + uint(datosReporte[datosReporte.length - 1].captura_robalo_mar_profundo);
			capturaSierra = uint(datosReporte[datosReporte.length - 1].captura_sierra_costa) + uint(datosReporte[datosReporte.length - 1].captura_sierra_mar_proundo);
			
			for ( var i:uint = 0; i < datosPeces.length; i++ )
			{
				switch(datosPeces[i].nombre)
				{
					case "PARGO":
					{
						valorVenta = valorVenta + capturaPargo * datosPeces[i].precio;
						break;
					}
					case "SIERRA":
					{
						valorVenta = valorVenta + capturaSierra * datosPeces[i].precio;
						break;
					}
					case "ROBALO":
					{
						valorVenta = valorVenta + capturaRobalo * datosPeces[i].precio;
						break;
					}
				}
			}
			
			arregloAux.push(getFormatedMoney(valorVenta));
			arregloAux.push(getFormatedMoney(costoOperativo));
			
			for ( i = 0; i < datosReporte.length - 1 ; i++ )
			{
				balanceAnterior = balanceAnterior + Number(datosReporte[i].balance_general);
			}
			balanceActual = balanceAnterior + Number(datosReporte[datosReporte.length-1].balance_general);
			arregloAux.push(getFormatedMoney(balanceAnterior));
			datosTabla.push(arregloAux);
			
			var tabla3:UITable = new UITable(nombreColumnas, datosTabla, 580, 50);
			addChild(tabla3);
			tabla3.x = 40;
			tabla3.y = 260;
			
			arregloAux = new Array();
			datosTabla = new Array();
			nombreColumnas = new Array("Balance actual");
			arregloAux.push(getFormatedMoney(balanceActual));
			datosTabla.push(arregloAux);
			var tabla4:UITable = new UITable(nombreColumnas, datosTabla, 150, 50);
			addChild(tabla4);
			tabla4.x = 40;
			tabla4.y = 320;
		}
		
	}

}