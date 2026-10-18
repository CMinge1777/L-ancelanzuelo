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
	 * @author ...
	 */
	public class VistaPedidos extends MovieClip 
	{
		
		[Embed(source = 'data/graficos/chalupa.swf')] public var chalupaGraph:Class;
		[Embed(source = 'data/graficos/panga.swf')] public var pangaGraph:Class;
		[Embed(source = 'data/graficos/pesquero.swf')] public var pesqueroGraph:Class;
		[Embed(source = 'data/graficos/botones/Comprar.png')] public var ComprarGraph:Class;
		[Embed(source='data/graficos/botones/X.png')] public var XGraph:Class;
		
		//estatus
		public static const COMPRAR:String = "se realizo la compra";
		public static const CERRAR:String = "cierre sin realizar compra";
		
		//datos para updatiar la bd
		public var numChalupas:int;
		public var numPangas:int;
		public var numBarcosPesqueros:int;
		// El dinero de la compañia cuando entro a esta opcion
		private var money:Number;
		private var dineroInicial:Number;
		private var chalupaTF:TextField;
		private var pangaTF:TextField;
		private var pesqueroTF:TextField;
		private var dineroDisponibleTF:TextField;
		// Esto se carga de la bd
		private var valorChalupa:Number;
		private var valorPanga:Number;
		private var valorPesquero:Number;
		private var estiloDinero:TextFormat;
		
		private var hayPedido:Boolean;
		private var chalupasPedidoPrevio:Number;
		private var pangasPedidoPrevio:Number;
		private var pesquerosPedidoPrevio:Number;
		
		public function VistaPedidos(money:Number,tipoBarco:Vector.<TipoBarcoDTO>,pedido:PedidoDTO) 
		{	
			
			for each (var item:TipoBarcoDTO in tipoBarco) {
				switch(item.nombre) {
					case "CHALUPA": {
						valorChalupa = item.precio;
						break;
					} case "PANGA": {
						valorPanga = item.precio;
						break;
					} case "BARCO PESQUERO": {
						valorPesquero = item.precio;
						break;
					}
				}
			}
			
			if (pedido != null) {
				hayPedido = true;
				chalupasPedidoPrevio = pedido.numero_chalupas;
				pangasPedidoPrevio = pedido.numero_pangas;
				pesquerosPedidoPrevio = pedido.numero_barco_pesquero;
			} else {
				hayPedido = false;
				chalupasPedidoPrevio = 0;
				pangasPedidoPrevio = 0;
				pesquerosPedidoPrevio = 0;
			}
			
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
			
			var dibujo:Sprite = new Sprite;
			dibujo.graphics.lineStyle(3, 0x000000, 1);
			dibujo.graphics.beginFill(0xFFF9B9, 2);
			dibujo.graphics.drawRect(0,0,640,480);
			dibujo.graphics.endFill();
			addChild(dibujo);
			
			estiloDinero = new TextFormat();
			estiloDinero.font = "Maiandra GD";
			estiloDinero.size = 20;
			estiloDinero.bold = true;
			
			dineroDisponibleTF = new TextField;
			dineroDisponibleTF.text = "Dinero disponible " + getFormatedMoney(money);
			dineroDisponibleTF.x = 300;
			dineroDisponibleTF.y = 10;
			dineroDisponibleTF.width = 500;
			dineroDisponibleTF.selectable = false;
			dineroDisponibleTF.setTextFormat(estiloDinero);
			addChild(dineroDisponibleTF);
			
			
			// creare una funcioncita para dibujar rayas tipo cuaderno de un gris alphazudo
			dibujaLineasCuaderno();
			agregarTexto();
			
			// eventos de los textfields
			chalupaTF.addEventListener(Event.CHANGE, calculateChalupa);
			pangaTF.addEventListener(Event.CHANGE, calculatePanga);
			pesqueroTF.addEventListener(Event.CHANGE, calculatePesquero);
			
			chalupaTF.tabEnabled = true;
			pangaTF.tabEnabled = true;
			pesqueroTF.tabEnabled = true;
			dineroDisponibleTF.tabEnabled = false;
			
			if (hayPedido)
			{
				cargarPedido();
			}
			else
			{
			}
			// entry point
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
			
			// Recuadro tf chalupa
			//lineas.graphics.moveTo();
			lineas.graphics.lineStyle(2, 0x000000);
			lineas.graphics.beginFill(0xFFFFFF, 1);
			lineas.graphics.drawRect(560, 55, 75, 25);
			lineas.graphics.drawRect(560, 215, 75, 25);
			lineas.graphics.drawRect(560, 335, 75, 25);
			lineas.graphics.endFill();
			
			addChild(lineas);
		}
		
		public function agregarTexto():void
		{
			// Titulo
			var titulo:TextField = new TextField();
			titulo.text = "Pedido de barcos";
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
			
			// estilo de los subtitulos
			var estiloSubTitulo:TextFormat = new TextFormat();
			estiloSubTitulo.font = "Maiandra GD";
			estiloSubTitulo.size = 20;
			estiloSubTitulo.bold = true;
			
			// estilo de los pedidos y precio
			var estiloResto:TextFormat = new TextFormat();
			estiloResto.font = "Verdana";
			estiloResto.size = 15;
			
			// Chalupa
			var tituloChalupa:TextField = new TextField();
			tituloChalupa.text = "Chalupa";
			tituloChalupa.x = 10;
			tituloChalupa.y = 50;
			tituloChalupa.width = 300;			
			tituloChalupa.selectable = false;
			tituloChalupa.setTextFormat(estiloSubTitulo);			
			addChild(tituloChalupa);
			
			var chalupaV:MovieClip = new chalupaGraph as MovieClip;
			chalupaV.x = 90;
			chalupaV.y = 100;
			chalupaV.scaleX = 0.4;
			chalupaV.scaleY = 0.4;
			addChild(chalupaV);
			
			chalupaTF = new TextField();
			chalupaTF.text = "0";
			chalupaTF.x = 560;
			chalupaTF.y = 55;
			chalupaTF.setTextFormat(estiloResto);
			chalupaTF.type = "input";
			chalupaTF.maxChars = 7;
			chalupaTF.restrict = "0-9";
			addChild(chalupaTF);
			
			var precioChalupa:TextField = new TextField();
			precioChalupa.text = "Valor unitario " + getFormatedMoney(valorChalupa);
			precioChalupa.x = 350;
			precioChalupa.y = 90;
			precioChalupa.width = 300;			
			precioChalupa.selectable = false;
			precioChalupa.setTextFormat(estiloResto);			
			addChild(precioChalupa);
			
			// Panga
			var tituloPanga:TextField = new TextField();
			tituloPanga.text = "Lancha";
			tituloPanga.x = 10;
			tituloPanga.y = 210;
			tituloPanga.width = 300;			
			tituloPanga.selectable = false;
			tituloPanga.setTextFormat(estiloSubTitulo);			
			addChild(tituloPanga);
			
			var pangaV:MovieClip = new pangaGraph as MovieClip;
			pangaV.x = 90;
			pangaV.y = 250;
			pangaV.scaleX = 0.5;
			pangaV.scaleY = 0.5;
			addChild(pangaV);
			
			pangaTF = new TextField();
			pangaTF.text = "0";
			pangaTF.x = 560;
			pangaTF.y = 215;
			pangaTF.setTextFormat(estiloResto);
			pangaTF.type = "input";
			pangaTF.maxChars = 7;
			pangaTF.restrict = "0-9";
			addChild(pangaTF);
			
			var precioPanga:TextField = new TextField();
			precioPanga.text = "Valor unitario " + getFormatedMoney(valorPanga);
			precioPanga.x = 350;
			precioPanga.y = 250;
			precioPanga.width = 300;			
			precioPanga.selectable = false;
			precioPanga.setTextFormat(estiloResto);			
			addChild(precioPanga);
			
			// Pesquero
			var tituloPesquero:TextField = new TextField();
			tituloPesquero.text = "Pesquero";
			tituloPesquero.x = 10;
			tituloPesquero.y = 330;
			tituloPesquero.width = 300;			
			tituloPesquero.selectable = false;
			tituloPesquero.setTextFormat(estiloSubTitulo);			
			addChild(tituloPesquero);
			
			var pesqueroV:MovieClip = new pesqueroGraph as MovieClip;
			pesqueroV.x = 90;
			pesqueroV.y = 330;
			addChild(pesqueroV);
			
			pesqueroTF = new TextField();
			pesqueroTF.text = "0";
			pesqueroTF.x = 560;
			pesqueroTF.y = 335;
			pesqueroTF.setTextFormat(estiloResto);
			pesqueroTF.type = "input";
			pesqueroTF.maxChars = 7;
			pesqueroTF.restrict = "0-9";
			addChild(pesqueroTF);
			
			var precioPesquero:TextField = new TextField();
			precioPesquero.text = "Valor unitario " + getFormatedMoney(valorPesquero);
			precioPesquero.x = 350;
			precioPesquero.y = 370;
			precioPesquero.width = 300;			
			precioPesquero.selectable = false;
			precioPesquero.setTextFormat(estiloResto);			
			addChild(precioPesquero);
			
			// Boton compra
			
			var botonCompraUp:Bitmap;
			var botonCompraDown:Bitmap;
			var botonCompra:SimpleButton;
			
			botonCompraUp  = new ComprarGraph as Bitmap;
			botonCompraDown  = new ComprarGraph as Bitmap;
			botonCompra = new SimpleButton();			
			
			botonCompraUp.scaleX = botonCompraUp.scaleY = 0.5;
			botonCompraDown.scaleX = botonCompraDown.scaleY = 0.4;
			
			botonCompra.upState = botonCompraUp;
			botonCompra.downState = botonCompraDown;
			botonCompra.overState = botonCompraUp;
			botonCompra.hitTestState = botonCompra.upState;
			
			botonCompraDown.x = 5;
			botonCompraDown.y = 5;
			
			botonCompra.x = 500;
			botonCompra.y = 440;
			
			addChild(botonCompra);
			botonCompra.addEventListener(MouseEvent.CLICK, realizarCompra, false, 0, true);
			botonCompra.tabEnabled = false;
			
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
		
		public function realizarCompra(event:Event):void
		{
			numChalupas = new int (chalupaTF.text);
			numPangas = new int (pangaTF.text);
			numBarcosPesqueros = new int (pesqueroTF.text);
			dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, "", COMPRAR));
		}
		
		public function cargarPedido():void
		{
			// carga un pedido para que pueda modificarlo
			chalupaTF.text = String(chalupasPedidoPrevio);
			pangaTF.text = String(pangasPedidoPrevio);
			pesqueroTF.text = String(pesquerosPedidoPrevio);
			money = dineroInicial - ((Number(chalupaTF.text) * valorChalupa) + (Number(pangaTF.text) * valorPanga) + (Number(pesqueroTF.text) * valorPesquero));
			dineroDisponibleTF.text = "Dinero disponible " + getFormatedMoney(money);
		}
		
		public function cerrar(event:Event):void 
		{
			dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, "", CERRAR));
			// Le devuelve el control a lo otro y se muere
		}
		
		public function calculateChalupa(event:Event):void
		{
			if ((dineroInicial - ((Number(chalupaTF.text) * valorChalupa) + (Number(pangaTF.text) * valorPanga) + (Number(pesqueroTF.text) * valorPesquero))) < 0)
			{
				// dejar valor mayor posible en text field
				chalupaTF.text = String(Math.floor((dineroInicial - ((Number(pangaTF.text) * valorPanga) + (Number(pesqueroTF.text) * valorPesquero))) / valorChalupa));
			}
			else
			{}
			money = dineroInicial - ((Number(chalupaTF.text) * valorChalupa) + (Number(pangaTF.text) * valorPanga) + (Number(pesqueroTF.text) * valorPesquero)  );
			dineroDisponibleTF.text = "Dinero disponible " + getFormatedMoney(money);
			dineroDisponibleTF.setTextFormat(estiloDinero);
		}
		
		public function calculatePanga(event:Event):void
		{
			if ((dineroInicial - ((Number(chalupaTF.text) * valorChalupa) + (Number(pangaTF.text) * valorPanga) + (Number(pesqueroTF.text) * valorPesquero))) < 0)
			{
				// dejar valor mayor posible en text field
				pangaTF.text = String(Math.floor((dineroInicial - ((Number(chalupaTF.text) * valorChalupa) + (Number(pesqueroTF.text) * valorPesquero))) / valorPanga));
			}
			else
			{}
			money = dineroInicial - ((Number(chalupaTF.text) * valorChalupa) + (Number(pangaTF.text) * valorPanga) + (Number(pesqueroTF.text) * valorPesquero)  );
			dineroDisponibleTF.text = "Dinero disponible " + getFormatedMoney(money);
			dineroDisponibleTF.setTextFormat(estiloDinero);
		}
		
		public function calculatePesquero(event:Event):void
		{
			trace("nuevo valor = " + chalupaTF.text);
			if ((dineroInicial - ((Number(chalupaTF.text) * valorChalupa) + (Number(pangaTF.text) * valorPanga) + (Number(pesqueroTF.text) * valorPesquero))) < 0)
			{
				// dejar valor mayor posible en text field
				pesqueroTF.text = String(Math.floor((dineroInicial - ((Number(pangaTF.text) * valorPanga) + (Number(chalupaTF.text) * valorChalupa))) / valorPesquero));
			}
			else
			{}
			money = dineroInicial - ((Number(chalupaTF.text) * valorChalupa) + (Number(pangaTF.text) * valorPanga) + (Number(pesqueroTF.text) * valorPesquero)  );
			dineroDisponibleTF.text = "Dinero disponible " + getFormatedMoney(money);
			dineroDisponibleTF.setTextFormat(estiloDinero);
		}
		
	}

}