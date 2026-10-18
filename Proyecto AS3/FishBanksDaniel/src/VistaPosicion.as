package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.StatusEvent;
	import flash.events.TextEvent;
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
	import flash.text.TextField;
	import flash.text.TextFormat;
	 
	public class VistaPosicion extends MovieClip
	{
		
		[Embed(source = 'data/graficos/botones/X.png')] public var XGraph:Class;
		[Embed(source = 'data/graficos/botones/Aceptar.png')] public var aceptarGraph:Class;
		
		[Embed(source = 'data/graficos/chalupa.swf')] public var chalupaGraph:Class;
		[Embed(source = 'data/graficos/panga.swf')] public var pangaGraph:Class;
		[Embed(source = 'data/graficos/pesquero.swf')] public var pesqueroGraph:Class;
		
		public static const CAMBIAR:String = "hacer cambios";
		public static const CERRAR:String = "cerrar sin hacer cambios";
		
		public var numeroChalupasPuerto:Number = 0;
		public var numeroChalupasCosta:Number = 0;
		public var numeroChalupasMarProfundo:Number = 0;
		public var numeroPangasPuerto:Number = 0;
		public var numeroPangasCosta:Number = 0;
		public var numeroPangasMarProfundo:Number = 0;
		public var numeroPesquerosPuerto:Number = 0;
		public var numeroPesquerosCosta:Number = 0;
		public var numeroPesquerosMarProfundo:Number = 0;
		private var totalChalupas:Number = 0;
		private var totalPangas:Number = 0;
		private var totalPesqueros:Number = 0;
		
		private var numeroChalupasPuertoTF:TextField = new TextField();
		private var numeroChalupasCostaTF:TextField = new TextField();
		private var numeroChalupasMarProfundoTF:TextField = new TextField();
		
		private var numeroPangasPuertoTF:TextField = new TextField();
		private var numeroPangasCostaTF:TextField = new TextField();
		private var numeroPangasMarProfundoTF:TextField = new TextField();
		
		private var numeroPesquerosMarProfundoTF:TextField = new TextField();
		private var numeroPesquerosCostaTF:TextField = new TextField();
		private var numeroPesquerosPuertoTF:TextField = new TextField();
		
		private var estiloResto:TextFormat;
		private var hayDecision:Boolean =  false;
		
		public function VistaPosicion(decision:DecisionDTO, barcosXCompaniaVector:Vector.<BarcosXCompaniaDTO>) 
		{
			cargarPosiciones(decision, barcosXCompaniaVector);
			
			var dibujo:Sprite = new Sprite;
			dibujo.graphics.lineStyle(3, 0x000000, 1);
			dibujo.graphics.beginFill(0xFFF9B9, 2);
			dibujo.graphics.drawRect(0,0,640,480);
			dibujo.graphics.endFill();
			addChild(dibujo);
			dibujaLineasCuaderno();
			ponerIconosEmbarcaciones();
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
			pintarVentana();
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
			titulo.text = "Posicionamiento de barcos";
			titulo.x = 10;
			titulo.y = 10;
			titulo.width = 350;
			var estiloTitulo:TextFormat = new TextFormat();
			estiloTitulo.font = "Maiandra GD";
			estiloTitulo.size = 25;
			estiloTitulo.bold = true;
			estiloTitulo.color = 0x0C676B;
			titulo.selectable = false;
			titulo.setTextFormat(estiloTitulo);			
			addChild(titulo);
			
			// estilo text field y texto normal
			estiloResto = new TextFormat();
			estiloResto.font = "Verdana";
			estiloResto.size = 15;
			
			// estilo de los subtitulos
			var estiloSubTitulo:TextFormat = new TextFormat();
			estiloSubTitulo.font = "Maiandra GD";
			estiloSubTitulo.size = 20;
			estiloSubTitulo.bold = true;
			
			// text field titulo chalupas
			var tituloChalupas:TextField = new TextField();
			tituloChalupas.text = "Chalupas";
			tituloChalupas.x = 10;
			tituloChalupas.y = 50;
			tituloChalupas.width = 400;			
			tituloChalupas.selectable = false;
			tituloChalupas.setTextFormat(estiloSubTitulo);			
			addChild(tituloChalupas);
			
			/*
			var numeroChalupasPuertoL:TextField = new TextField();
			numeroChalupasPuertoL.text = String(numeroChalupasPuerto);
			numeroChalupasPuertoL.x = 200;
			numeroChalupasPuertoL.y = 50;
			numeroChalupasPuertoL.width = 400;			
			numeroChalupasPuertoL.selectable = false;
			numeroChalupasPuertoL.setTextFormat(estiloResto);			
			addChild(numeroChalupasPuertoL); 
			
			var numeroChalupasCostaL:TextField = new TextField();
			numeroChalupasCostaL.text = String(numeroChalupasCosta);
			numeroChalupasCostaL.x = 300;
			numeroChalupasCostaL.y = 50;
			numeroChalupasCostaL.width = 400;			
			numeroChalupasCostaL.selectable = false;
			numeroChalupasCostaL.setTextFormat(estiloResto);			
			addChild(numeroChalupasCostaL); 
			
			var numeroChalupasMarProfundoL:TextField = new TextField();
			numeroChalupasMarProfundoL.text = String(numeroChalupasMarProfundo);
			numeroChalupasMarProfundoL.x = 400;
			numeroChalupasMarProfundoL.y = 50;
			numeroChalupasMarProfundoL.width = 400;			
			numeroChalupasMarProfundoL.selectable = false;
			numeroChalupasMarProfundoL.setTextFormat(estiloResto);			
			addChild(numeroChalupasMarProfundoL); 
			*/
			
			var puertoTituloChalupa:TextField = new TextField();
			puertoTituloChalupa.text = "Puerto";
			puertoTituloChalupa.x = 175;
			puertoTituloChalupa.y = 90;
			puertoTituloChalupa.width = 400;			
			puertoTituloChalupa.selectable = false;
			puertoTituloChalupa.setTextFormat(estiloSubTitulo);			
			addChild(puertoTituloChalupa); 
			
			var costaTituloChalupa:TextField = new TextField();
			costaTituloChalupa.text = "Costa";
			costaTituloChalupa.x = 275;
			costaTituloChalupa.y = 90;
			costaTituloChalupa.width = 400;			
			costaTituloChalupa.selectable = false;
			costaTituloChalupa.setTextFormat(estiloSubTitulo);			
			addChild(costaTituloChalupa); 
			
				
			// recuadros chalupas
			var cuadros:Sprite = new Sprite;
			cuadros.graphics.lineStyle(2, 0x000000);
			cuadros.graphics.beginFill(0xFFFFFF, 1);
			cuadros.graphics.drawRect(175, 130, 90, 25);
			cuadros.graphics.drawRect(275, 130, 90, 25);
			cuadros.graphics.endFill();
			addChild(cuadros);
			
			
			numeroChalupasPuertoTF.text = String(numeroChalupasPuerto);
			numeroChalupasPuertoTF.x = 175;
			numeroChalupasPuertoTF.y = 130;
			numeroChalupasPuertoTF.width = 90;			
			//numeroChalupasPuertoTF.type = "input";
			numeroChalupasPuertoTF.selectable = false;
			numeroChalupasPuertoTF.maxChars = 8;
			numeroChalupasPuertoTF.setTextFormat(estiloResto);
			addChild(numeroChalupasPuertoTF); 
			
			
			numeroChalupasCostaTF.text = String(numeroChalupasCosta);
			numeroChalupasCostaTF.x = 275;
			numeroChalupasCostaTF.y = 130;
			numeroChalupasCostaTF.width = 90;			
			numeroChalupasCostaTF.type = "input";
			numeroChalupasCostaTF.maxChars = 8;
			numeroChalupasCostaTF.setTextFormat(estiloResto);	
			numeroChalupasCostaTF.restrict = "0-9";
			addChild(numeroChalupasCostaTF);
			numeroChalupasCostaTF.addEventListener(Event.CHANGE, cambioChalupasCosta);
				
			
			// Pangas
			// text field titulo pangas
			var tituloPangas:TextField = new TextField();
			tituloPangas.text = "Lanchas";
			tituloPangas.x = 10;
			tituloPangas.y = 170;
			tituloPangas.width = 400;			
			tituloPangas.selectable = false;
			tituloPangas.setTextFormat(estiloSubTitulo);			
			addChild(tituloPangas);
			
			/*
			var numeroPangasPuertoL:TextField = new TextField();
			numeroPangasPuertoL.text = String(numeroPangasPuerto);
			numeroPangasPuertoL.x = 200;
			numeroPangasPuertoL.y = 170;
			numeroPangasPuertoL.width = 400;			
			numeroPangasPuertoL.selectable = false;
			numeroPangasPuertoL.setTextFormat(estiloResto);			
			addChild(numeroPangasPuertoL); 
			
			var numeroPangasCostaL:TextField = new TextField();
			numeroPangasCostaL.text = String(numeroPangasCosta);
			numeroPangasCostaL.x = 300;
			numeroPangasCostaL.y = 170;
			numeroPangasCostaL.width = 400;			
			numeroPangasCostaL.selectable = false;
			numeroPangasCostaL.setTextFormat(estiloResto);			
			addChild(numeroPangasCostaL); 
			
			var numeroPangasMarProfundoL:TextField = new TextField();
			numeroPangasMarProfundoL.text = String(numeroPangasMarProfundo);
			numeroPangasMarProfundoL.x = 400;
			numeroPangasMarProfundoL.y = 170;
			numeroPangasMarProfundoL.width = 400;			
			numeroPangasMarProfundoL.selectable = false;
			numeroPangasMarProfundoL.setTextFormat(estiloResto);			
			addChild(numeroPangasMarProfundoL); 
			*/
			
			var puertoTituloPanga:TextField = new TextField();
			puertoTituloPanga.text = "Puerto";
			puertoTituloPanga.x = 175;
			puertoTituloPanga.y = 210;
			puertoTituloPanga.width = 400;			
			puertoTituloPanga.selectable = false;
			puertoTituloPanga.setTextFormat(estiloSubTitulo);			
			addChild(puertoTituloPanga); 
			
			var costaTituloPanga:TextField = new TextField();
			costaTituloPanga.text = "Costa";
			costaTituloPanga.x = 275;
			costaTituloPanga.y = 210;
			costaTituloPanga.width = 400;			
			costaTituloPanga.selectable = false;
			costaTituloPanga.setTextFormat(estiloSubTitulo);			
			addChild(costaTituloPanga); 
			
			var marAdentroTituloPanga:TextField = new TextField();
			marAdentroTituloPanga.text = "Mar profundo";
			marAdentroTituloPanga.x = 375;
			marAdentroTituloPanga.y = 210;
			marAdentroTituloPanga.width = 400;			
			marAdentroTituloPanga.selectable = false;
			marAdentroTituloPanga.setTextFormat(estiloSubTitulo);			
			addChild(marAdentroTituloPanga); 
			
			// recuadros pangas
			
			cuadros.graphics.lineStyle(2, 0x000000);
			cuadros.graphics.beginFill(0xFFFFFF, 1);
			cuadros.graphics.drawRect(175, 250, 90, 25);
			cuadros.graphics.drawRect(275, 250, 90, 25);
			cuadros.graphics.drawRect(375, 250, 90, 25);
			cuadros.graphics.endFill();
			
			
			numeroPangasPuertoTF.text = String(numeroPangasPuerto);
			numeroPangasPuertoTF.x = 175;
			numeroPangasPuertoTF.y = 250;
			numeroPangasPuertoTF.width = 90;			
			//numeroPangasPuertoTF.type = "input";
			numeroPangasPuertoTF.selectable = false;
			numeroPangasPuertoTF.maxChars = 8;
			numeroPangasPuertoTF.setTextFormat(estiloResto);			
			addChild(numeroPangasPuertoTF);
			
			
			
			numeroPangasCostaTF.text = String(numeroPangasCosta);
			numeroPangasCostaTF.x = 275;
			numeroPangasCostaTF.y = 250;
			numeroPangasCostaTF.width = 90;			
			numeroPangasCostaTF.type = "input";
			numeroPangasCostaTF.maxChars = 8;
			numeroPangasCostaTF.setTextFormat(estiloResto);	
			numeroPangasCostaTF.restrict = "0-9";
			addChild(numeroPangasCostaTF); 
			numeroPangasCostaTF.addEventListener(Event.CHANGE, cambioPangasCosta);
			
			
			numeroPangasMarProfundoTF.text = String(numeroPangasMarProfundo);
			numeroPangasMarProfundoTF.x = 375;
			numeroPangasMarProfundoTF.y = 250;
			numeroPangasMarProfundoTF.width = 90;			
			numeroPangasMarProfundoTF.type = "input";
			numeroPangasMarProfundoTF.maxChars = 8;
			numeroPangasMarProfundoTF.setTextFormat(estiloResto);
			numeroPangasMarProfundoTF.restrict = "0-9";
			addChild(numeroPangasMarProfundoTF);
			numeroPangasMarProfundoTF.addEventListener(Event.CHANGE, cambioPangasMarAdentro);
			
			// Pesqueros
			// text field titulo Pesqueros
			var tituloPesqueros:TextField = new TextField();
			tituloPesqueros.text = "Barcos pesqueros";
			tituloPesqueros.x = 10;
			tituloPesqueros.y = 290;
			tituloPesqueros.width = 400;			
			tituloPesqueros.selectable = false;
			tituloPesqueros.setTextFormat(estiloSubTitulo);			
			addChild(tituloPesqueros);
			
			/*
			var numeroPesquerosPuertoL:TextField = new TextField();
			numeroPesquerosPuertoL.text = String(numeroPesquerosPuerto);
			numeroPesquerosPuertoL.x = 200;
			numeroPesquerosPuertoL.y = 290;
			numeroPesquerosPuertoL.width = 400;			
			numeroPesquerosPuertoL.selectable = false;
			numeroPesquerosPuertoL.setTextFormat(estiloResto);			
			addChild(numeroPesquerosPuertoL); 
			
			var numeroPesquerosCostaL:TextField = new TextField();
			numeroPesquerosCostaL.text = String(numeroPesquerosCosta);
			numeroPesquerosCostaL.x = 300;
			numeroPesquerosCostaL.y = 290;
			numeroPesquerosCostaL.width = 400;			
			numeroPesquerosCostaL.selectable = false;
			numeroPesquerosCostaL.setTextFormat(estiloResto);			
			addChild(numeroPesquerosCostaL); 
			
			var numeroPesquerosMarProfundoL:TextField = new TextField();
			numeroPesquerosMarProfundoL.text = String(numeroPesquerosMarProfundo);
			numeroPesquerosMarProfundoL.x = 400;
			numeroPesquerosMarProfundoL.y = 290;
			numeroPesquerosMarProfundoL.width = 400;			
			numeroPesquerosMarProfundoL.selectable = false;
			numeroPesquerosMarProfundoL.setTextFormat(estiloResto);			
			addChild(numeroPesquerosMarProfundoL); 
			*/
			
			var puertoTituloPesquero:TextField = new TextField();
			puertoTituloPesquero.text = "Puerto";
			puertoTituloPesquero.x = 175;
			puertoTituloPesquero.y = 330;
			puertoTituloPesquero.width = 400;			
			puertoTituloPesquero.selectable = false;
			puertoTituloPesquero.setTextFormat(estiloSubTitulo);			
			addChild(puertoTituloPesquero); 
			
			var costaTituloPesquero:TextField = new TextField();
			costaTituloPesquero.text = "Costa";
			costaTituloPesquero.x = 275;
			costaTituloPesquero.y = 330;
			costaTituloPesquero.width = 400;			
			costaTituloPesquero.selectable = false;
			costaTituloPesquero.setTextFormat(estiloSubTitulo);			
			addChild(costaTituloPesquero); 
			
			var marAdentroTituloPesquero:TextField = new TextField();
			marAdentroTituloPesquero.text = "Mar profundo";
			marAdentroTituloPesquero.x = 375;
			marAdentroTituloPesquero.y = 330;
			marAdentroTituloPesquero.width = 400;			
			marAdentroTituloPesquero.selectable = false;
			marAdentroTituloPesquero.setTextFormat(estiloSubTitulo);			
			addChild(marAdentroTituloPesquero); 
			
			// recuadros pesqueros
			
			cuadros.graphics.lineStyle(2, 0x000000);
			cuadros.graphics.beginFill(0xFFFFFF, 1);
			cuadros.graphics.drawRect(175, 370, 90, 25);
			cuadros.graphics.drawRect(275, 370, 90, 25);
			cuadros.graphics.drawRect(375, 370, 90, 25);
			cuadros.graphics.endFill();
			
			numeroPesquerosPuertoTF.text = String(numeroPesquerosPuerto);
			numeroPesquerosPuertoTF.x = 175;
			numeroPesquerosPuertoTF.y = 370;
			numeroPesquerosPuertoTF.width = 90;			
			//numeroPesquerosPuertoTF.type = "input";
			numeroPesquerosPuertoTF.selectable = false;
			numeroPesquerosPuertoTF.maxChars = 8;
			numeroPesquerosPuertoTF.setTextFormat(estiloResto);			
			addChild(numeroPesquerosPuertoTF); 
			
			
			numeroPesquerosCostaTF.text = String(numeroPesquerosCosta);
			numeroPesquerosCostaTF.x = 275;
			numeroPesquerosCostaTF.y = 370;
			numeroPesquerosCostaTF.width = 90;			
			numeroPesquerosCostaTF.type = "input";
			numeroPesquerosCostaTF.maxChars = 8;
			numeroPesquerosCostaTF.setTextFormat(estiloResto);	
			numeroPesquerosCostaTF.restrict = "0-9";
			addChild(numeroPesquerosCostaTF); 
			numeroPesquerosCostaTF.addEventListener(Event.CHANGE, cambioPesquerosCosta);
			
			
			numeroPesquerosMarProfundoTF.text = String(numeroPesquerosMarProfundo);
			numeroPesquerosMarProfundoTF.x = 375;
			numeroPesquerosMarProfundoTF.y = 370;
			numeroPesquerosMarProfundoTF.width = 90;			
			numeroPesquerosMarProfundoTF.type = "input";
			numeroPesquerosMarProfundoTF.maxChars = 8;
			numeroPesquerosMarProfundoTF.setTextFormat(estiloResto);	
			numeroPesquerosMarProfundoTF.restrict = "0-9";
			addChild(numeroPesquerosMarProfundoTF);
			numeroPesquerosMarProfundoTF.addEventListener(Event.CHANGE, cambioPesquerosMarAdentro);
						
			// Boton aceptar
			
			var botonAceptarUp:Bitmap;
			var botonAceptarDown:Bitmap;
			var botonAceptar:SimpleButton;
			
			botonAceptarUp  = new aceptarGraph as Bitmap;
			botonAceptarDown  = new aceptarGraph as Bitmap;
			botonAceptar = new SimpleButton();			
			
			botonAceptarUp.scaleX = botonAceptarUp.scaleY = 0.5;
			botonAceptarDown.scaleX = botonAceptarDown.scaleY = 0.4;
			
			botonAceptar.upState = botonAceptarUp;
			botonAceptar.downState = botonAceptarDown;
			botonAceptar.overState = botonAceptarUp;
			botonAceptar.hitTestState = botonAceptar.upState;
			
			botonAceptarDown.x = 5;
			botonAceptarDown.y = 5;
			
			botonAceptar.x = 500;
			botonAceptar.y = 440;
			
			addChild(botonAceptar);
			botonAceptar.addEventListener(MouseEvent.CLICK, aceptarCambios, false, 0, true);
			botonAceptar.tabEnabled = false;
		}
		
		private function aceptarCambios(e:Event):void 
		{
			numeroChalupasPuerto = new int(numeroChalupasPuertoTF.text);
			numeroChalupasCosta = new int(numeroChalupasCostaTF.text);
			numeroChalupasMarProfundo = 0;
			numeroPangasPuerto = new int(numeroPangasPuertoTF.text);
			numeroPangasCosta = new int(numeroPangasCostaTF.text);
			numeroPangasMarProfundo = new int(numeroPangasMarProfundoTF.text);
			numeroPesquerosPuerto = new int(numeroPesquerosPuertoTF.text);
			numeroPesquerosCosta = new int(numeroPesquerosCostaTF.text);
			numeroPesquerosMarProfundo = new int(numeroPesquerosMarProfundoTF.text);
			dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, "", CAMBIAR));
			// Hacer cambios en la base de datos
		}
		
		private function cambioPangasCosta(e:Event):void 
		{
			if (Number(numeroPangasCostaTF.text) > (totalPangas - Number(numeroPangasMarProfundoTF.text)))
			{
				numeroPangasCostaTF.text = String(totalPangas - Number(numeroPangasMarProfundoTF.text));
				numeroPangasPuertoTF.text = String(totalPangas - (Number(numeroPangasCostaTF.text) + Number(numeroPangasMarProfundoTF.text)));
				numeroPangasPuertoTF.setTextFormat(estiloResto);
			}
			else
			{
				numeroPangasPuertoTF.text = String(totalPangas - (Number(numeroPangasCostaTF.text) + Number(numeroPangasMarProfundoTF.text)));
				numeroPangasPuertoTF.setTextFormat(estiloResto);
			}
		}
		
		private function cambioPangasMarAdentro(e:Event):void 
		{
			if (Number(numeroPangasMarProfundoTF.text) > (totalPangas - Number(numeroPangasCostaTF.text)))
			{
				numeroPangasMarProfundoTF.text = String(totalPangas - Number(numeroPangasCostaTF.text));
				numeroPangasPuertoTF.text = String(totalPangas - (Number(numeroPangasCostaTF.text) + Number(numeroPangasMarProfundoTF.text)));
				numeroPangasPuertoTF.setTextFormat(estiloResto);
			}
			else
			{
				numeroPangasPuertoTF.text = String(totalPangas - (Number(numeroPangasCostaTF.text) + Number(numeroPangasMarProfundoTF.text)));
				numeroPangasPuertoTF.setTextFormat(estiloResto);
			}
		}
		
		private function cambioPesquerosMarAdentro(e:Event):void 
		{
			if (Number(numeroPesquerosMarProfundoTF.text) > (totalPesqueros - Number(numeroPesquerosCostaTF.text)))
			{
				numeroPesquerosMarProfundoTF.text = String(totalPesqueros - Number(numeroPesquerosCostaTF.text));
				numeroPesquerosPuertoTF.text = String(totalPesqueros - (Number(numeroPesquerosCostaTF.text) + Number(numeroPesquerosMarProfundoTF.text)));
				numeroPesquerosPuertoTF.setTextFormat(estiloResto);
			}
			else
			{
				numeroPesquerosPuertoTF.text = String(totalPesqueros - (Number(numeroPesquerosCostaTF.text) + Number(numeroPesquerosMarProfundoTF.text)));
				numeroPesquerosPuertoTF.setTextFormat(estiloResto);
			}
		}
		
		private function cambioPesquerosCosta(e:Event):void 
		{
			if (Number(numeroPesquerosCostaTF.text) > (totalPesqueros - Number(numeroPesquerosMarProfundoTF.text)))
			{
				numeroPesquerosCostaTF.text = String(totalPesqueros - Number(numeroPesquerosMarProfundoTF.text));
				numeroPesquerosPuertoTF.text = String(totalPesqueros - (Number(numeroPesquerosCostaTF.text) + Number(numeroPesquerosMarProfundoTF.text)));
				numeroPesquerosPuertoTF.setTextFormat(estiloResto);
			}
			else
			{
				numeroPesquerosPuertoTF.text = String(totalPesqueros - (Number(numeroPesquerosCostaTF.text) + Number(numeroPesquerosMarProfundoTF.text)));
				numeroPesquerosPuertoTF.setTextFormat(estiloResto);
			}
		}
		
		private function cambioChalupasCosta(e:Event):void 
		{
			if (Number(numeroChalupasCostaTF.text) > (totalChalupas))
			{
				numeroChalupasCostaTF.text = String(totalChalupas);
				numeroChalupasPuertoTF.text = String(totalChalupas - (Number(numeroChalupasCostaTF.text)));
				numeroChalupasPuertoTF.setTextFormat(estiloResto);
			}
			else
			{
				numeroChalupasPuertoTF.text = String(totalChalupas - (Number(numeroChalupasCostaTF.text)));
				numeroChalupasPuertoTF.setTextFormat(estiloResto);
			}
		}
		
		public function cerrar(event:Event):void
		{
			dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, "", CERRAR));
			// Le devuelve el control a lo otro y se muere
		}
		
		private function cargarPosiciones(decision:DecisionDTO, barcosXCompaniaVector:Vector.<BarcosXCompaniaDTO>):void
		{
			// Carga las posiciones de los barcos en las variables
			
			if (decision!=null)
			{
				// se cargan los valores en las variables preiamente mencionadas de la decision capturada
				numeroChalupasPuerto = new int(decision.chalupas_puerto);
				numeroChalupasCosta = new int(decision.chalupas_costa);
				numeroChalupasMarProfundo = new int(decision.chalupas_mar_profundo);
				
				numeroPangasPuerto = new int(decision.panga_puerto);
				numeroPangasCosta = new int(decision.panga_costa);
				numeroPangasMarProfundo = new int(decision.panga_mar_profundo);
				
				numeroPesquerosPuerto = new int(decision.barco_pesquero_puerto);
				numeroPesquerosCosta = new int(decision.barco_pesquero_costa);
				numeroPesquerosMarProfundo = new int(decision.barco_pesquero_mar_profundo);
			}
			else
			{
				var length:uint = barcosXCompaniaVector.length;
				for (var i:int = 0; i < length; i++) {
					switch(barcosXCompaniaVector[i].ubicacion_id) {
						case 0: { //Puerto
							switch (barcosXCompaniaVector[i].tipo_barco_id) {
								case 3: { //Pesquero
									numeroPesquerosPuerto = new int(barcosXCompaniaVector[i].cantidad_barcos);
									break;
								} case 1: { // Chalupa
									numeroChalupasPuerto = new int(barcosXCompaniaVector[i].cantidad_barcos);
									break;
								} case 2: { //Panga
									numeroPangasPuerto = new int(barcosXCompaniaVector[i].cantidad_barcos);
									break;
								}
							}
							break;
						} case 1: { //Costa
							switch (barcosXCompaniaVector[i].tipo_barco_id) {
								case 3: { //Pesquero
									numeroPesquerosCosta = new int(barcosXCompaniaVector[i].cantidad_barcos);
									break;
								} case 1: { // Chalupa
									numeroChalupasCosta = new int(barcosXCompaniaVector[i].cantidad_barcos);
									break;
								} case 2: { //Panga
									numeroPangasCosta = new int(barcosXCompaniaVector[i].cantidad_barcos);
									break;
								}
							}
							break;
						}case 2: { //Mar Profundo
							switch (barcosXCompaniaVector[i].tipo_barco_id) {
								case 3: { //Pesquero
									numeroPesquerosMarProfundo = new int(barcosXCompaniaVector[i].cantidad_barcos);
									break;
								} case 1: { // Chalupa
									numeroChalupasMarProfundo = new int(barcosXCompaniaVector[i].cantidad_barcos);
									break;
								} case 2: { //Panga
									numeroPangasMarProfundo = new int(barcosXCompaniaVector[i].cantidad_barcos);
									break;
								}
							}
							break;
						}
					}
				}
			}
			
			
			totalChalupas = numeroChalupasPuerto + numeroChalupasCosta + numeroChalupasMarProfundo;
			totalPangas = numeroPangasCosta + numeroPangasPuerto + numeroPangasMarProfundo;
			totalPesqueros = numeroPesquerosPuerto + numeroPesquerosCosta + numeroPesquerosMarProfundo;
			
		}
		
		private function ponerIconosEmbarcaciones():void
		{
			var iconoChalupa:MovieClip =  new chalupaGraph as MovieClip;
			iconoChalupa.x = 10;
			iconoChalupa.y = 80;
			iconoChalupa.scaleX = 0.4;
			iconoChalupa.scaleY = 0.4;
			addChild(iconoChalupa);
			
			var iconoPanga:MovieClip = new pangaGraph as MovieClip;
			iconoPanga.scaleX = 0.5;
			iconoPanga.scaleY = 0.5;
			iconoPanga.x = 10;
			iconoPanga.y = 200;
			addChild(iconoPanga);
			
			var iconoPesquero:MovieClip = new pesqueroGraph as MovieClip;
			iconoPesquero.x = 10;
			iconoPesquero.y  = 320;
			iconoPesquero.scaleX = 0.7;
			iconoPesquero.scaleY = 0.7;
			addChild(iconoPesquero);
		}
		
		
		
		
	}

}