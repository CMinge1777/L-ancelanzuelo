package  
{
	/**
	 * ...
	 * @author 
	 */
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
		 
	public class VistaNoticias extends Sprite
	{
		[Embed(source = 'data/graficos/botones/X.png')] public var XGraph:Class;
		public static const CERRAR:String = "cerrar las supernoticias";
		public var motivational:String = "";
		
		public function VistaNoticias(textoMotivacional:String) 
		{
			//motivational = "Muchachos animo y pesquen lo que mas puedan para que lleven cositas a la casa que ustedes son muy pobres";
			motivational = textoMotivacional;
			
			var dibujo:Sprite = new Sprite;
			dibujo.graphics.lineStyle(3, 0x000000, 1);
			dibujo.graphics.beginFill(0xDFDFD2, 2);
			dibujo.graphics.drawRect(0,0,640,480);
			dibujo.graphics.endFill();
			addChild(dibujo);
			
			dibujarPeriodico();
		}
		
		public function dibujarPeriodico():void
		{
						
			// esta funcion dibujara las lineas que lo haran parecer un periodico
			var lineas:Sprite = new Sprite;
			lineas.graphics.lineStyle(5, 0x000000, 1);
			lineas.graphics.moveTo(20, 110);
			lineas.graphics.lineTo(620, 110);
			lineas.graphics.lineStyle(3, 0x000000, 1);
			lineas.graphics.moveTo(300, 140);
			lineas.graphics.lineTo(300, 470);
			addChild(lineas);
			
			var estiloTitulo:TextFormat = new TextFormat();
			estiloTitulo.font = "Arial";
			estiloTitulo.size = 90;
			estiloTitulo.bold = true;
			estiloTitulo.color = 0x000000;
			
			var estilotexto:TextFormat = new TextFormat();
			estilotexto.font = "Arial";
			estilotexto.size = 14;
			estilotexto.bold = false;
			estilotexto.color = 0x000000;
			estilotexto.align = TextFormatAlign.JUSTIFY;
				
			var tituloTF:TextField =  new TextField();
			
			
			tituloTF.text = "PERIODICO";
			tituloTF.x = 10;
			tituloTF.y = 10;
			tituloTF.width = 620;			
			tituloTF.selectable = false;
			tituloTF.setTextFormat(estiloTitulo);	
			addChild(tituloTF);
			
			
			//var txt = "<TEXTFORMAT LEADING='2' TABSTOPS='20, 50, 550'><P ALIGN='left'><FONT FACE='ARIAL' COLOR='#000000'><B>COASTAL</B><BR><TAB><B>Rose</B><BR><TAB>122<TAB>Chateau de Peyrassol &quot;Marie Estelle&quot;, Cotes du Provence Rose, Provence, France 2001<TAB>28<BR><TAB><B>White</B><BR><TAB>103<TAB>Domaine Louis Bovard...";

			var textoNoticia:String = "";
			var randomNoticia:int = Math.floor(Math.random() * (1 + 5 - 1)) + 1;
			switch (randomNoticia)
			{
				case 1:
				{
					textoNoticia = "Para los próximos días se pronostica temperatura de 21 a 30 grados, cielos nublados, posibilidad de chubascos y viento variable.";
					break;
				}
				case 2:
				{
					textoNoticia = "Para los próximos días se pronostican temperaturas de 30 a 37 grados, cielos despejados, posibles vientos fuertes.";
					break;
				}
				case 3:
				{
					textoNoticia = "Para los próximos días se pronostican temperaturas de 35 a 42 grados, cielos despejados, poco viento.";
					break;
				}
				case 4:
				{
					textoNoticia = "Para los próximos días se pronostican temperaturas de 20 a 25 grados, altas probabilidades de tormenta, vientos fuertes.";
					break;
				}
				case 5:
				{
					textoNoticia = "Para los próximos días hay altas probabilidades de tormentas fuertes y oleaje peligroso.";
					break;
				}
			}
			
			
			
			var noticia:TextField =  new TextField();
			noticia.multiline = true;
			noticia.selectable = false;
			noticia.wordWrap = false;
			noticia.condenseWhite = true;
			noticia.width = 260;
			noticia.x = 20;
			noticia.y = 140;			
			noticia.wordWrap = true;
			noticia.text = textoNoticia;
			noticia.setTextFormat(estilotexto);
			addChild(noticia);	
			
			var mensaje:TextField =  new TextField();
			mensaje.multiline = true;
			mensaje.selectable = false;
			mensaje.wordWrap = false;
			mensaje.condenseWhite = true;
			mensaje.width = 280;
			mensaje.x = 320;
			mensaje.y = 140;			
			mensaje.wordWrap = true;
			mensaje.text = motivational;
			mensaje.setTextFormat(estilotexto);
			addChild(mensaje);
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
		}
	
		public function cerrar(event:Event):void
		{
			dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, "", CERRAR));
			// Le devuelve el control a lo otro y se muere
		} 
	}

}