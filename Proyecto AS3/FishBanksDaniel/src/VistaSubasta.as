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
	public class VistaSubasta extends MovieClip
	{
		
		[Embed(source = 'data/graficos/botones/X.png')] public var XGraph:Class;
		[Embed(source = 'data/graficos/botones/Ofertar.png')] public var ofertaGraph:Class;
		[Embed(source = 'data/graficos/chalupa.swf')] public var chalupaGraph:Class;
		[Embed(source = 'data/graficos/panga.swf')] public var pangaGraph:Class;
		[Embed(source = 'data/graficos/pesquero.swf')] public var pesqueroGraph:Class;
		
		//estatus
		public static const OFERTAR:String = "oferto en subasta";
		public static const CERRAR:String = "cierre sin realizar oferta";
		
		//datos para updatiar la bd
		public var oferta:int;
		
		private var subastaActiva:SubastaDTO;
		private var money:Number = 0;
		private var dineroInicial:Number;
		private var ofertarTF:TextField;
		private var dineroDisponibleTF:TextField;
		private var estiloDinero:TextFormat;
		
		// verdadera si no hay subasta, falsa de no exisitir
		private var haySubasta:Boolean = false;
		private var costoSubasta:int =  0;
		private var numeroChalupas:int = 0;
		private var numeroPangas:int = 0;
		private var numeroPesqueros:int = 0;
		
		public function VistaSubasta(subastaActiva:SubastaDTO, money:Number) 
		{
			this.subastaActiva = subastaActiva;
			if (this.subastaActiva != null) {
				if (money <= 0)
			{
				money = 0;
				dineroInicial = 0;
			}
			else
			{
				this.money = money;
				dineroInicial = money;
			}
				costoSubasta = this.subastaActiva.costo;
				numeroChalupas = this.subastaActiva.numero_chalupas;
				numeroPangas = this.subastaActiva.numero_pangas;
				numeroPesqueros  = this.subastaActiva.numero_barco_pesquero;
				haySubasta = true;
			} else {
				haySubasta = false;
			}
			
			var dibujo:Sprite = new Sprite;
			
			
			dibujo.graphics.lineStyle(3, 0x000000, 1);
			dibujo.graphics.beginFill(0xFFF9B9, 2);
			dibujo.graphics.drawRect(0,0,640,480);
			dibujo.graphics.endFill();
			
			
			addChild(dibujo);
			dibujaLineasCuaderno();
			pintarVentana();
			
			if (haySubasta)
			{
				estiloDinero = new TextFormat();
				estiloDinero.font = "Maiandra GD";
				estiloDinero.size = 20;
				estiloDinero.bold = true;
				
				dineroDisponibleTF = new TextField;
				dineroDisponibleTF.text = "Dinero disponible " + money.toString();
				dineroDisponibleTF.x = 300;
				dineroDisponibleTF.y = 10;
				dineroDisponibleTF.width = 300;
				dineroDisponibleTF.selectable = false;
				dineroDisponibleTF.setTextFormat(estiloDinero);
				addChild(dineroDisponibleTF);
			}
			
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
			
			if (haySubasta)
			{
				lineas.graphics.lineStyle(2, 0x000000);
				lineas.graphics.beginFill(0xFFFFFF, 1);
				lineas.graphics.drawRect(380, 440, 110, 25);
				lineas.graphics.endFill();
			}
			
			
			addChild(lineas);
		}
		
		public function pintarVentana():void
		{
			var botonCerrarUp:Bitmap;
			var botonCerrarDown:Bitmap;
			var botonCerrar:SimpleButton;
			
			if(haySubasta)
			{
				// Titulo
				var titulo:TextField = new TextField();
				titulo.text = "Subasta";
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
				
				// estilo text field y texto normal
				var estiloResto:TextFormat = new TextFormat();
				estiloResto.font = "Verdana";
				estiloResto.size = 15;
				
				// recuadro blanco
				
				// text field de oferta
				
				ofertarTF = new TextField();
				ofertarTF.text = "0";
				ofertarTF.x = 380;
				ofertarTF.y = 440;
				ofertarTF.width = 150;
				ofertarTF.setTextFormat(estiloResto);
				ofertarTF.type = "input";
				ofertarTF.maxChars = 10;
				ofertarTF.restrict = "0-9";
				ofertarTF.addEventListener(Event.CHANGE, cambioOferta);
				addChild(ofertarTF);
				
				
				// Boton compra
				
				var botonOfertaUp:Bitmap;
				var botonOfertaDown:Bitmap;
				var botonOferta:SimpleButton;
				
				botonOfertaUp  = new ofertaGraph as Bitmap;
				botonOfertaDown  = new ofertaGraph as Bitmap;
				botonOferta = new SimpleButton();			
				
				botonOfertaUp.scaleX = botonOfertaUp.scaleY = 0.5;
				botonOfertaDown.scaleX = botonOfertaDown.scaleY = 0.4;
				
				botonOferta.upState = botonOfertaUp;
				botonOferta.downState = botonOfertaDown;
				botonOferta.overState = botonOfertaUp;
				botonOferta.hitTestState = botonOferta.upState;
				
				botonOfertaDown.x = 5;
				botonOfertaDown.y = 5;
				
				botonOferta.x = 500;
				botonOferta.y = 440;
				
				addChild(botonOferta);
				botonOferta.addEventListener(MouseEvent.CLICK, realizarOferta, false, 0, true);
				botonOferta.tabEnabled = false;
				
				// estilo de los subtitulos
				var estiloSubTitulo:TextFormat = new TextFormat();
				estiloSubTitulo.font = "Maiandra GD";
				estiloSubTitulo.size = 20;
				estiloSubTitulo.bold = true;
				
				// text field valor base subasta
				var anuncioSubasta:TextField = new TextField();
				anuncioSubasta.text = "Precio base de la subasta " + getFormatedMoney(costoSubasta);
				anuncioSubasta.x = 10;
				anuncioSubasta.y = 90;
				anuncioSubasta.width = 400;			
				anuncioSubasta.selectable = false;
				anuncioSubasta.setTextFormat(estiloSubTitulo);			
				addChild(anuncioSubasta);
				
				// text field contenido
				var contenido:TextField = new TextField();
				contenido.text = "Contenido:";
				contenido.x = 10;
				contenido.y = 130;
				contenido.width = 400;			
				contenido.selectable = false;
				contenido.setTextFormat(estiloSubTitulo);			
				addChild(contenido);
				
				// poner los dibujitos de los barcos
				
				var chalupaV:MovieClip = new chalupaGraph as MovieClip;
				chalupaV.scaleX = 0.5;
				chalupaV.scaleY = 0.5;
				chalupaV.x = 50;
				chalupaV.y = 160;
				addChild(chalupaV);
				
				var pangaV:MovieClip = new pangaGraph as MovieClip;
				pangaV.scaleX = 0.5;
				pangaV.scaleY = 0.5;
				pangaV.x = 220;
				pangaV.y = 160;
				addChild(pangaV);
				
				var pesqueroV:MovieClip = new pesqueroGraph as MovieClip;
				pesqueroV.scaleX = 0.7;
				pesqueroV.scaleY = 0.7;
				pesqueroV.x = 400;
				pesqueroV.y = 160;
				addChild(pesqueroV);
				
				// Estilo cantidades
				var estiloCantidades:TextFormat = new TextFormat();
				estiloCantidades.font = "Verdana";
				estiloCantidades.size = 25;
				estiloCantidades.bold = true;
				
				// Text fields contenidos
				var cantidadChalupas:TextField = new TextField
				cantidadChalupas.text = String(numeroChalupas);
				cantidadChalupas.x = 110;
				cantidadChalupas.y = 250;
				cantidadChalupas.width = 400;			
				cantidadChalupas.selectable = false;
				cantidadChalupas.setTextFormat(estiloCantidades);			
				addChild(cantidadChalupas);
				
				var cantidadPangas:TextField = new TextField
				cantidadPangas.text = String(numeroPangas);
				cantidadPangas.x = 280;
				cantidadPangas.y = 250;
				cantidadPangas.width = 400;			
				cantidadPangas.selectable = false;
				cantidadPangas.setTextFormat(estiloCantidades);			
				addChild(cantidadPangas);
				
				var cantidadPesqueros:TextField = new TextField
				cantidadPesqueros.text = String(numeroPesqueros);
				cantidadPesqueros.x = 460;
				cantidadPesqueros.y = 250;
				cantidadPesqueros.width = 400;			
				cantidadPesqueros.selectable = false;
				cantidadPesqueros.setTextFormat(estiloCantidades);			
				addChild(cantidadPesqueros);
				// Boton Cerrar
						
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
			else
			{
				
				estiloDinero = new TextFormat();
				estiloDinero.font = "Maiandra GD";
				estiloDinero.size = 20;
				estiloDinero.bold = true;
				var noSubasta:TextField = new TextField
				noSubasta.text = "¡No hay subastas en este turno!";
				noSubasta.x = 170;
				noSubasta.y = 200;
				noSubasta.width = 400;			
				noSubasta.selectable = false;
				noSubasta.setTextFormat(estiloDinero);			
				addChild(noSubasta);
				
				// Boton Cerrar
			
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
				
			}
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
		} 
		
		public function realizarOferta(event:Event):void
		{
			oferta = new int(ofertarTF.text);
			dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, "", OFERTAR));
		}
		
		public function cambioOferta(event:Event):void
		{
			if (haySubasta)
			{
				if (dineroInicial - Number(ofertarTF.text) < 0)
				{
					ofertarTF.text = String(dineroInicial);
				}
				else 
				{}
				money = dineroInicial - Number(ofertarTF.text);
				dineroDisponibleTF.text = "Dinero disponible " + money.toString();
				dineroDisponibleTF.setTextFormat(estiloDinero);
			}
			else{}
			
		}
		
	}

}