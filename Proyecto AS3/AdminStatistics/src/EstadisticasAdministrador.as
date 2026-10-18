package  
{
	import adobe.utils.CustomActions;
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	/**
	 * ...
	 * @author juan felipe from ILLUSIONWARE
	 */
	public class EstadisticasAdministrador extends Sprite
	{
		[Embed(source = 'data/graficos/Botones/Aceptar.png')]
		public var Aceptar:Class;
		
		[Embed(source = 'data/graficos/Botones/Copiar.png')]
		public var CopiarAlPortapapeles:Class;
		
		[Embed(source = 'data/graficos/Botones/Balance.png')]
		public var Balance:Class;
		
		[Embed(source = 'data/graficos/Botones/Captura.png')]
		public var Captura:Class;
		
		[Embed(source = 'data/graficos/Botones/Downt.png')]
		public var Downt:Class;
		
		[Embed(source = 'data/graficos/Botones/PargoC.png')]
		public var PoblacionPargo:Class;
		
		[Embed(source = 'data/graficos/Botones/SierraC.png')]
		public var PoblacionSierra:Class;
		
		[Embed(source = 'data/graficos/Botones/RobaloC.png')]
		public var PoblacionRobalo:Class;
		
		[Embed(source = 'data/graficos/Botones/PargoMP.png')]
		public var PoblacionPargoM:Class;
		
		[Embed(source = 'data/graficos/Botones/SierraMP.png')]
		public var PoblacionSierraM:Class;
		
		[Embed(source = 'data/graficos/Botones/RobaloMP.png')]
		public var PoblacionRobaloM:Class;
		
		[Embed(source = 'data/graficos/Botones/Upt.png')]
		public var Upt:Class;
		
		[Embed(source = 'data/graficos/Botones/BarcosC.png')]
		public var BarcosC:Class;
		
		[Embed(source = 'data/graficos/Botones/BarcosMP.png')]
		public var BarcosMP:Class;
		
		[Embed(source = 'data/graficos/Botones/BarcosP.png')]
		public var BarcosP:Class;		
		
		private static const JUEGOS:String = "juegos";
		private static const COMPANIAS:String = "companias";
		private static const CAPTURA:String = "captura";
		private static const BALANCE:String = "balance";
		private static const POBLACION:String = "poblacion";
		private static const TURNO:String = "turno";
		private static const DECISIONES:String = "decisiones";
		
		private var seleccioneJuego:TextField;
		private var formatoTexto:TextFormat;
		private var conexionDB:DataBaseConexion;
		private var consultaActual:String;
		private var botonUp:SimpleButton;
		private var botonDown:SimpleButton;
		private var juegoSeleccionado:TextField;
		private var currentSelectedGame:uint;
		private var juegos:Vector.<JuegoDTO>;
		private var botonAceptar:SimpleButton;	
		private var seleccioneCompania:TextField;
		private var botonUp2:SimpleButton;
		private var botonDown2:SimpleButton;
		private var botonAceptar2:SimpleButton;	
		private var companiaSeleccionada:TextField;
		private var companias:Vector.<CompaniaDTO>;
		private var currentSelectedCompany:uint;
		private var botonBalance:SimpleButton;
		private var botonCaptura:SimpleButton;
		private var seleccioneEstadistica:TextField;
		private var botonPoblacionPargoC:SimpleButton;
		private var botonPoblacionSierraC:SimpleButton;
		private var botonPoblacionRobaloC:SimpleButton;
		private var botonPoblacionPargoM:SimpleButton;
		private var botonPoblacionSierraM:SimpleButton;
		private var botonPoblacionRobaloM:SimpleButton;
		private var datosEstadisticos:Vector.<ReporteDTO>;
		private var graficoEstadisticoLinea:chartMC;
		private var graficoEstadisticoBarra:barChartMC;		
		private var poblacionSeleccionada:uint; // 1:pargo || 2:sierra || 3:robalo
		private var poblacionUno:Vector.<PezDTO>;
		private var poblacionDos:Vector.<PezDTO>;
		private var poblacionRealUno:Vector.<PezDTO>;
		private var poblacionRealDos:Vector.<PezDTO>;
		private var centradoBotonesEstadisticas:uint;
		private var isCoast:Boolean;
		private var csvText:TextField;
		private var copiarAlPortapapeles:SimpleButton;
		private var botonBarcosC:SimpleButton;
		private var botonBarcosP:SimpleButton;
		private var botonBarcosMP:SimpleButton;
		
		public function EstadisticasAdministrador() 
		{
			csvText = new TextField();
			csvText.multiline = true;
			csvText.border = true;
			csvText.width = 600;
			csvText.height = 50;
			csvText.x = 50;
			csvText.y = 525;
			csvText.alwaysShowSelection = true;
			addChild(csvText);
			csvText.addEventListener(MouseEvent.CLICK, copyCSV, false, 0, true);
			
			isCoast = false;
			centradoBotonesEstadisticas = 650;
			
			graficoEstadisticoBarra = new barChartMC;
			graficoEstadisticoLinea = new chartMC;
			
			formatoTexto = new TextFormat();
			formatoTexto.font = "Maiandra GD";
			formatoTexto.size = 25;
			formatoTexto.bold = true;
			formatoTexto.color = 0x0C676B;
	
			seleccioneJuego = new TextField();
			seleccioneJuego.text = "Seleccione el juego";
			seleccioneJuego.setTextFormat(formatoTexto);
			seleccioneJuego.width = seleccioneJuego.textWidth + 12;
			seleccioneJuego.selectable = false;
			
			addChild(seleccioneJuego);
			seleccioneJuego.x = 50;
			seleccioneJuego.y = 50;
			
			juegoSeleccionado = new TextField();
			juegoSeleccionado.border = true;
			juegoSeleccionado.borderColor = 0x0;
			juegoSeleccionado.width  = 80;
			juegoSeleccionado.height = 30;
			juegoSeleccionado.restrict = "0-9";
			juegoSeleccionado.setTextFormat(formatoTexto);
			addChild(juegoSeleccionado);
			juegoSeleccionado.x = 100;
			juegoSeleccionado.y = 100;
			juegoSeleccionado.type = "input";
			
			currentSelectedGame = 0;
			
			botonUp = new SimpleButton();
			botonUp.upState      = new Upt as Bitmap;
			botonUp.downState    = new Upt as Bitmap;
			botonUp.overState    = new Upt as Bitmap;
			botonUp.hitTestState = botonUp.upState;
			botonUp.downState.x  = 10;
			botonUp.downState.y  = 10;
			botonUp.scaleX = botonUp.scaleY = 0.8;
			botonUp.downState.scaleX = botonUp.downState.scaleY = 0.7;
			botonUp.addEventListener(MouseEvent.CLICK, botonClickeado, false, 0, true);
			addChild(botonUp);
			botonUp.x = 190;
			botonUp.y = 100;
			
			botonDown = new SimpleButton();
			botonDown.upState      = new Downt as Bitmap;
			botonDown.downState    = new Downt as Bitmap;
			botonDown.overState    = new Downt as Bitmap;
			botonDown.hitTestState = botonDown.upState;
			botonDown.downState.x  = 10;
			botonDown.downState.y  = 10;
			botonDown.scaleX = botonDown.scaleY = 0.8;
			botonDown.downState.scaleX = botonDown.downState.scaleY = 0.7;
			botonDown.addEventListener(MouseEvent.CLICK, botonClickeado, false, 0, true);
			addChild(botonDown);
			botonDown.x = 200 + botonUp.width;
			botonDown.y = 100;
			
			botonAceptar = new SimpleButton();
			botonAceptar.upState      = new Aceptar as Bitmap;
			botonAceptar.downState    = new Aceptar as Bitmap;
			botonAceptar.overState    = new Aceptar as Bitmap;
			botonAceptar.hitTestState = botonAceptar.upState;
			botonAceptar.downState.x  = 10;
			botonAceptar.downState.y  = 10;
			botonAceptar.scaleX = botonAceptar.scaleY = 0.6;
			botonAceptar.downState.scaleX = botonAceptar.downState.scaleY = 0.7;
			botonAceptar.addEventListener(MouseEvent.CLICK, botonClickeado, false, 0, true);
			addChild(botonAceptar);
			botonAceptar.x = botonDown.x + botonDown.width + 10;
			botonAceptar.y = 100;
			
			
			/**************************SELECCIONAR COMPAÑIA*******************************/
			seleccioneCompania = new TextField();
			seleccioneCompania.text = "Seleccione la compañia";
			seleccioneCompania.setTextFormat(formatoTexto);
			seleccioneCompania.width = seleccioneCompania.textWidth + 12;
			seleccioneCompania.selectable = false;
			addChild(seleccioneCompania);
			seleccioneCompania.x = 50;
			seleccioneCompania.y = 150;
			
			companiaSeleccionada = new TextField();
			companiaSeleccionada.border = true;
			companiaSeleccionada.borderColor = 0x0;
			companiaSeleccionada.width  = 330;
			companiaSeleccionada.height = 30;
			companiaSeleccionada.setTextFormat(formatoTexto);
			addChild(companiaSeleccionada);
			companiaSeleccionada.x = 100;
			companiaSeleccionada.y = 200;			
			
			botonUp2 = new SimpleButton();
			botonUp2.upState      = new Upt as Bitmap;
			botonUp2.downState    = new Upt as Bitmap;
			botonUp2.overState    = new Upt as Bitmap;
			botonUp2.hitTestState = botonUp2.upState;
			botonUp2.downState.x  = 10;
			botonUp2.downState.y  = 10;
			botonUp2.scaleX = botonUp2.scaleY = 0.8;
			botonUp2.downState.scaleX = botonUp2.downState.scaleY = 0.7;
			addChild(botonUp2);
			botonUp2.x = 440;
			botonUp2.y = 200;
			
			botonDown2 = new SimpleButton();
			botonDown2.upState      = new Downt as Bitmap;
			botonDown2.downState    = new Downt as Bitmap;
			botonDown2.overState    = new Downt as Bitmap;
			botonDown2.hitTestState = botonDown2.upState;
			botonDown2.downState.x  = 10;
			botonDown2.downState.y  = 10;
			botonDown2.scaleX = botonDown2.scaleY = 0.8;
			botonDown2.downState.scaleX = botonDown2.downState.scaleY = 0.7;
			addChild(botonDown2);
			botonDown2.x = 450 + botonUp2.width;
			botonDown2.y = 200;
			
			/********************BOTONES PARA SELECCION DE GRAFICAS *****************************/
			
			seleccioneEstadistica = new TextField();
			seleccioneEstadistica.text = "Seleccione la estadistica";
			seleccioneEstadistica.setTextFormat(formatoTexto);
			seleccioneEstadistica.width = seleccioneCompania.textWidth + 12;
			seleccioneEstadistica.selectable = false;
			addChild(seleccioneEstadistica);
			seleccioneEstadistica.x = 510;
			seleccioneEstadistica.y = 0;
			
			
			botonBarcosP = new SimpleButton();
			botonBarcosP.upState      = new BarcosP as Bitmap;
			botonBarcosP.downState    = new BarcosP as Bitmap;
			botonBarcosP.overState    = new BarcosP as Bitmap;
			botonBarcosP.hitTestState = botonBarcosP.upState;
			botonBarcosP.downState.x  = 10;
			botonBarcosP.downState.y  = 10;
			botonBarcosP.scaleX = botonBarcosP.scaleY = 0.7;
			botonBarcosP.downState.scaleX = botonBarcosP.downState.scaleY = 0.9;
			addChild(botonBarcosP);
			botonBarcosP.x = centradoBotonesEstadisticas - botonBarcosP.width / 2 - 70;
			botonBarcosP.y = 40;
			
			botonBarcosC = new SimpleButton();
			botonBarcosC.upState      = new BarcosC as Bitmap;
			botonBarcosC.downState    = new BarcosC as Bitmap;
			botonBarcosC.overState    = new BarcosC as Bitmap;
			botonBarcosC.hitTestState = botonBarcosC.upState;
			botonBarcosC.downState.x  = 10;
			botonBarcosC.downState.y  = 10;
			botonBarcosC.scaleX = botonBarcosC.scaleY = 0.7;
			botonBarcosC.downState.scaleX = botonBarcosC.downState.scaleY = 0.9;
			addChild(botonBarcosC);
			botonBarcosC.x = centradoBotonesEstadisticas - botonBarcosC.width / 2 - 70;
			botonBarcosC.y = 80;
			
			botonBarcosMP = new SimpleButton();
			botonBarcosMP.upState      = new BarcosMP as Bitmap;
			botonBarcosMP.downState    = new BarcosMP as Bitmap;
			botonBarcosMP.overState    = new BarcosMP as Bitmap;
			botonBarcosMP.hitTestState = botonBarcosMP.upState;
			botonBarcosMP.downState.x  = 10;
			botonBarcosMP.downState.y  = 10;
			botonBarcosMP.scaleX = botonBarcosMP.scaleY = 0.7;
			botonBarcosMP.downState.scaleX = botonBarcosMP.downState.scaleY = 0.9;
			addChild(botonBarcosMP);
			botonBarcosMP.x = centradoBotonesEstadisticas - botonBarcosMP.width / 2 - 70;
			botonBarcosMP.y = 120;
			
			botonBalance = new SimpleButton();
			botonBalance.upState      = new Balance as Bitmap;
			botonBalance.downState    = new Balance as Bitmap;
			botonBalance.overState    = new Balance as Bitmap;
			botonBalance.hitTestState = botonBalance.upState;
			botonBalance.downState.x  = 10;
			botonBalance.downState.y  = 10;
			botonBalance.scaleX = botonBalance.scaleY = 0.7;
			botonBalance.downState.scaleX = botonBalance.downState.scaleY = 0.9;
			addChild(botonBalance);
			botonBalance.x = centradoBotonesEstadisticas - botonBalance.width / 2 + 70;
			botonBalance.y = 80;
			
			botonCaptura = new SimpleButton();
			botonCaptura.upState      = new Captura as Bitmap;
			botonCaptura.downState    = new Captura as Bitmap;
			botonCaptura.overState    = new Captura as Bitmap;
			botonCaptura.hitTestState = botonCaptura.upState;
			botonCaptura.downState.x  = 10;
			botonCaptura.downState.y  = 10;
			botonCaptura.scaleX = botonCaptura.scaleY = 0.7;
			botonCaptura.downState.scaleX = botonCaptura.downState.scaleY = 0.9;
			addChild(botonCaptura);
			botonCaptura.x = centradoBotonesEstadisticas - botonCaptura.width / 2 + 70;
			botonCaptura.y = 120;
			
			botonPoblacionSierraC = new SimpleButton();
			botonPoblacionSierraC.upState      = new PoblacionSierra as Bitmap;
			botonPoblacionSierraC.downState    = new PoblacionSierra as Bitmap;
			botonPoblacionSierraC.overState    = new PoblacionSierra as Bitmap;
			botonPoblacionSierraC.hitTestState = botonPoblacionSierraC.upState;
			botonPoblacionSierraC.downState.x  = 10;
			botonPoblacionSierraC.downState.y  = 10;
			botonPoblacionSierraC.scaleX = botonPoblacionSierraC.scaleY = 0.7;
			botonPoblacionSierraC.downState.scaleX = botonPoblacionSierraC.downState.scaleY = 0.9;
			addChild(botonPoblacionSierraC);
			botonPoblacionSierraC.x = centradoBotonesEstadisticas - botonPoblacionSierraC.width / 2 - 70;
			botonPoblacionSierraC.y = 160;
			
			botonPoblacionPargoC = new SimpleButton();
			botonPoblacionPargoC.upState      = new PoblacionPargo as Bitmap;
			botonPoblacionPargoC.downState    = new PoblacionPargo as Bitmap;
			botonPoblacionPargoC.overState    = new PoblacionPargo as Bitmap;
			botonPoblacionPargoC.hitTestState = botonPoblacionPargoC.upState;
			botonPoblacionPargoC.downState.x  = 10;
			botonPoblacionPargoC.downState.y  = 10;
			botonPoblacionPargoC.scaleX = botonPoblacionPargoC.scaleY = 0.7;
			botonPoblacionPargoC.downState.scaleX = botonPoblacionPargoC.downState.scaleY = 0.9;
			addChild(botonPoblacionPargoC);
			botonPoblacionPargoC.x = centradoBotonesEstadisticas - botonPoblacionPargoC.width / 2 - 70;
			botonPoblacionPargoC.y = 170 + botonPoblacionSierraC.height;
			
			botonPoblacionRobaloC = new SimpleButton();
			botonPoblacionRobaloC.upState      = new PoblacionRobalo as Bitmap;
			botonPoblacionRobaloC.downState    = new PoblacionRobalo as Bitmap;
			botonPoblacionRobaloC.overState    = new PoblacionRobalo as Bitmap;
			botonPoblacionRobaloC.hitTestState = botonPoblacionRobaloC.upState;
			botonPoblacionRobaloC.downState.x  = 10;
			botonPoblacionRobaloC.downState.y  = 10;
			botonPoblacionRobaloC.scaleX = botonPoblacionRobaloC.scaleY = 0.7;
			botonPoblacionRobaloC.downState.scaleX = botonPoblacionRobaloC.downState.scaleY = 0.9;
			addChild(botonPoblacionRobaloC);
			botonPoblacionRobaloC.x = centradoBotonesEstadisticas - botonPoblacionRobaloC.width / 2 - 70;
			botonPoblacionRobaloC.y = botonPoblacionPargoC.y + 10 + botonPoblacionPargoC.height;
			
			botonPoblacionSierraM = new SimpleButton();
			botonPoblacionSierraM.upState      = new PoblacionSierraM as Bitmap;
			botonPoblacionSierraM.downState    = new PoblacionSierraM as Bitmap;
			botonPoblacionSierraM.overState    = new PoblacionSierraM as Bitmap;
			botonPoblacionSierraM.hitTestState = botonPoblacionSierraM.upState;
			botonPoblacionSierraM.downState.x  = 10;
			botonPoblacionSierraM.downState.y  = 10;
			botonPoblacionSierraM.scaleX = botonPoblacionSierraM.scaleY = 0.7;
			botonPoblacionSierraM.downState.scaleX = botonPoblacionSierraM.downState.scaleY = 0.9;
			addChild(botonPoblacionSierraM);
			botonPoblacionSierraM.x = centradoBotonesEstadisticas - botonPoblacionSierraM.width / 2 + 70;
			botonPoblacionSierraM.y = 160;
			
			botonPoblacionPargoM = new SimpleButton();
			botonPoblacionPargoM.upState      = new PoblacionPargoM as Bitmap;
			botonPoblacionPargoM.downState    = new PoblacionPargoM as Bitmap;
			botonPoblacionPargoM.overState    = new PoblacionPargoM as Bitmap;
			botonPoblacionPargoM.hitTestState = botonPoblacionPargoM.upState;
			botonPoblacionPargoM.downState.x  = 10;
			botonPoblacionPargoM.downState.y  = 10;
			botonPoblacionPargoM.scaleX = botonPoblacionPargoM.scaleY = 0.7;
			botonPoblacionPargoM.downState.scaleX = botonPoblacionPargoM.downState.scaleY = 0.9;
			addChild(botonPoblacionPargoM);
			botonPoblacionPargoM.x = centradoBotonesEstadisticas - botonPoblacionPargoM.width / 2 + 70;
			botonPoblacionPargoM.y = 170 + botonPoblacionSierraM.height;
			
			botonPoblacionRobaloM = new SimpleButton();
			botonPoblacionRobaloM.upState      = new PoblacionRobaloM as Bitmap;
			botonPoblacionRobaloM.downState    = new PoblacionRobaloM as Bitmap;
			botonPoblacionRobaloM.overState    = new PoblacionRobaloM as Bitmap;
			botonPoblacionRobaloM.hitTestState = botonPoblacionRobaloM.upState;
			botonPoblacionRobaloM.downState.x  = 10;
			botonPoblacionRobaloM.downState.y  = 10;
			botonPoblacionRobaloM.scaleX = botonPoblacionRobaloM.scaleY = 0.7;
			botonPoblacionRobaloM.downState.scaleX = botonPoblacionRobaloM.downState.scaleY = 0.9;
			addChild(botonPoblacionRobaloM);
			botonPoblacionRobaloM.x = centradoBotonesEstadisticas - botonPoblacionRobaloM.width / 2 + 70;
			botonPoblacionRobaloM.y = botonPoblacionPargoM.y + 10 + botonPoblacionPargoM.height;
			
			conexionDB = new DataBaseConexion();
			conexionDB.obtenerJuegos();
			conexionDB.addEventListener(StatusEvent.STATUS, consultaFinalizada, false, 0, true);
			consultaActual = JUEGOS;
			
			
			/********************BOTON PARA COPIAR LAS ESTADISTICAS *****************************/
			copiarAlPortapapeles = new SimpleButton();
			copiarAlPortapapeles.upState      = new CopiarAlPortapapeles as Bitmap;
			copiarAlPortapapeles.downState    = new CopiarAlPortapapeles as Bitmap;
			copiarAlPortapapeles.overState    = new CopiarAlPortapapeles as Bitmap;
			copiarAlPortapapeles.hitTestState = copiarAlPortapapeles.upState;
			copiarAlPortapapeles.downState.x  = 10;
			copiarAlPortapapeles.downState.y  = 10;
			copiarAlPortapapeles.scaleX = copiarAlPortapapeles.scaleY = 0.7;
			copiarAlPortapapeles.downState.scaleX = copiarAlPortapapeles.downState.scaleY = 0.9;
			addChild(copiarAlPortapapeles);
			copiarAlPortapapeles.x = 675;
			copiarAlPortapapeles.y = 535;
			copiarAlPortapapeles.addEventListener(MouseEvent.CLICK, copyCSV, false, 0, true);
		}
		
		private function copyCSV(e:MouseEvent):void 
		{
			csvText.setSelection(0, csvText.text.length)
			System.setClipboard(csvText.text);
		}
		
		private function botonClickeado(e:MouseEvent):void 
		{
			if (e.currentTarget == botonUp && currentSelectedGame < juegos.length-1)
			{
				currentSelectedGame++;
				juegoSeleccionado.text = juegos[currentSelectedGame].juego_id.toString();
				juegoSeleccionado.setTextFormat(formatoTexto);
				return;
			}
			
			if (e.currentTarget == botonDown && currentSelectedGame > 0)
			{
				currentSelectedGame--;
				juegoSeleccionado.text = juegos[currentSelectedGame].juego_id.toString();
				juegoSeleccionado.setTextFormat(formatoTexto);
				return;
			}
			
			if (e.currentTarget == botonAceptar)
			{
				conexionDB.seleccionarCompanias(int(juegoSeleccionado.text));
				conexionDB.addEventListener(StatusEvent.STATUS, consultaFinalizada, false, 0, true);
				consultaActual = COMPANIAS;
				return;
			}
			
			if (e.currentTarget == botonUp2 && currentSelectedCompany < companias.length-1)
			{
				currentSelectedCompany++;
				companiaSeleccionada.text = companias[currentSelectedCompany].nombre.toString();
				companiaSeleccionada.setTextFormat(formatoTexto);
				return;
			}
			
			if (e.currentTarget == botonDown2 && currentSelectedCompany > 0)
			{
				currentSelectedCompany--;
				companiaSeleccionada.text = companias[currentSelectedCompany].nombre.toString();
				companiaSeleccionada.setTextFormat(formatoTexto);
				return;
			}
			if (e.currentTarget == botonPoblacionPargoC || e.currentTarget == botonPoblacionSierraC || e.currentTarget == botonPoblacionRobaloC ||
				e.currentTarget == botonPoblacionPargoM || e.currentTarget == botonPoblacionSierraM || e.currentTarget == botonPoblacionRobaloM )
			{
				if (e.currentTarget == botonPoblacionPargoM || e.currentTarget == botonPoblacionSierraM || e.currentTarget == botonPoblacionRobaloM)
					isCoast = false;
				else
					isCoast = true;
				conexionDB.obtenerPoblacion(int(juegoSeleccionado.text));
				conexionDB.addEventListener(StatusEvent.STATUS, consultaFinalizada, false, 0, true);
				consultaActual = POBLACION;
				if (e.currentTarget == botonPoblacionPargoC || e.currentTarget == botonPoblacionPargoM )
					poblacionSeleccionada = 3;
				if (e.currentTarget == botonPoblacionSierraC || e.currentTarget == botonPoblacionSierraM)
					poblacionSeleccionada = 2;
				if (e.currentTarget == botonPoblacionRobaloC || e.currentTarget == botonPoblacionRobaloM)
					poblacionSeleccionada = 1;
				return;
			}
			if (e.currentTarget == botonCaptura)
			{
				conexionDB.obtenerDatosEstadisticas(int(juegoSeleccionado.text),companiaSeleccionada.text);
				conexionDB.addEventListener(StatusEvent.STATUS, consultaFinalizada, false, 0, true);
				consultaActual = CAPTURA;
				return;
			}
			if (e.currentTarget == botonBalance)
			{
				conexionDB.obtenerDatosEstadisticas(int(juegoSeleccionado.text),companiaSeleccionada.text);
				conexionDB.addEventListener(StatusEvent.STATUS, consultaFinalizada, false, 0, true);
				consultaActual = BALANCE;
				return;
			}
			//if (e.currentTarget == botonBarcosC || e.currentTarget == botonBarcosP || e.currentTarget == botonBarcosMP)
			//{
				//conexionDB.obtenerTurno(int(juegoSeleccionado.text));
				//conexionDB.addEventListener(StatusEvent.STATUS, consultaIntermedia, false, 0, true);
				//consultaActual = TURNO;
				//return;
			//}
		}
		
		private function consultaIntermedia(e:StatusEvent):void 
		{
			if (consultaActual == TURNO)
			{
				//var dtoT:DTOTabla;
				//var ultimoTurno:uint = dtoT.datosFilas[0];
				//conexionDB.obtenerDecisiones(int(juegoSeleccionado.text));
				//conexionDB.addEventListener(StatusEvent.STATUS, consultaFinalizada, false, 0, true);
				//consultaActual = DECISIONES;
				//return;
			}
		}
		
		private function consultaFinalizada(e:StatusEvent):void 
		{
			var dtoT:DTOTabla;
			switch(consultaActual)
			{
				case JUEGOS:
				{
					dtoT = conexionDB.retornarTablaDatos();
					depurarTablaJuegos(dtoT);
					break;
				}
				case COMPANIAS:
				{
					dtoT = conexionDB.retornarTablaDatos();
					depurarTablaCompania(dtoT);
					break;
				}
				case CAPTURA:
				{
					trace("entro");
					dtoT = conexionDB.retornarTablaDatos();
					depurarReportes(dtoT);
					estadisticasCaptura();
					break;
				}
				case BALANCE:
				{
					dtoT = conexionDB.retornarTablaDatos();
					depurarReportes(dtoT);
					estadisticasBalance();
					break;
				}
				case POBLACION:
				{
					dtoT = conexionDB.retornarTablaDatos();
					depurarPoblacion(dtoT);
					estadisticasPoblacion();
					break;
				}
			}
		}
		
		private function depurarPoblacion(dtoT:DTOTabla):void
		{
			var poblacionTotalUno:uint;
			var poblacionTotalDos:uint;
			var length:uint = dtoT.datosFilas.length;
			var tb:PezDTO; 
			var i:uint;
			poblacionRealUno = new Vector.<PezDTO>;
			poblacionRealDos = new Vector.<PezDTO>;
			
			poblacionUno = new Vector.<PezDTO>();
			poblacionDos = new Vector.<PezDTO>();
			
			switch(poblacionSeleccionada)
			{
				case 1:
				{
					for ( i = 0; i < length; i++) 
					{
						tb = new PezDTO();
						if (int(dtoT.datosFilas[i]["TIPO_PEZ_ID"]) == 1 && int(dtoT.datosFilas[i]["UBICACION_ID"]) == 1)
						{
							tb.poblacion = dtoT.datosFilas[i]["POBLACION"];
							tb.turno_id  = dtoT.datosFilas[i]["TURNO_ID"];
							tb.ubicacion_id  = dtoT.datosFilas[i]["UBICACION_ID"];
							poblacionUno.push(tb);
							poblacionTotalUno = poblacionTotalUno + dtoT.datosFilas[i]["POBLACION"];
						}
						if (int(dtoT.datosFilas[i]["TIPO_PEZ_ID"]) == 1 && int(dtoT.datosFilas[i]["UBICACION_ID"]) == 2)
						{
							tb.poblacion = dtoT.datosFilas[i]["POBLACION"];
							tb.turno_id  = dtoT.datosFilas[i]["TURNO_ID"];
							tb.ubicacion_id  = dtoT.datosFilas[i]["UBICACION_ID"];
							poblacionDos.push(tb);
							poblacionTotalDos = poblacionTotalDos + dtoT.datosFilas[i]["POBLACION"];
						}
					}
					break;
				}
				case 2:
				{
					for ( i = 0; i < length; i++) 
					{
						tb = new PezDTO();
						if (int(dtoT.datosFilas[i]["TIPO_PEZ_ID"]) == 2 && int(dtoT.datosFilas[i]["UBICACION_ID"]) == 1)
						{
							tb.poblacion = dtoT.datosFilas[i]["POBLACION"];
							tb.turno_id  = dtoT.datosFilas[i]["TURNO_ID"];
							tb.ubicacion_id  = dtoT.datosFilas[i]["UBICACION_ID"];
							poblacionUno.push(tb);
							poblacionTotalUno = poblacionTotalUno + dtoT.datosFilas[i]["POBLACION"];
						}
						if (int(dtoT.datosFilas[i]["TIPO_PEZ_ID"]) == 2 && int(dtoT.datosFilas[i]["UBICACION_ID"]) == 2)
						{
							tb.poblacion = dtoT.datosFilas[i]["POBLACION"];
							tb.turno_id  = dtoT.datosFilas[i]["TURNO_ID"];
							tb.ubicacion_id  = dtoT.datosFilas[i]["UBICACION_ID"];
							poblacionDos.push(tb);
							poblacionTotalDos = poblacionTotalDos + dtoT.datosFilas[i]["POBLACION"];
						}
					}
					break;
				}
				case 3:
				{
					for ( i = 0; i < length; i++) 
					{
						tb = new PezDTO();
						if (int(dtoT.datosFilas[i]["TIPO_PEZ_ID"]) == 3 && int(dtoT.datosFilas[i]["UBICACION_ID"]) == 1)
						{
							tb.poblacion = dtoT.datosFilas[i]["POBLACION"];
							tb.turno_id  = dtoT.datosFilas[i]["TURNO_ID"];
							tb.ubicacion_id  = dtoT.datosFilas[i]["UBICACION_ID"];
							poblacionUno.push(tb);
							poblacionTotalUno = poblacionTotalUno + dtoT.datosFilas[i]["POBLACION"];
						}
						if (int(dtoT.datosFilas[i]["TIPO_PEZ_ID"]) == 3 && int(dtoT.datosFilas[i]["UBICACION_ID"]) == 2)
						{
							tb.poblacion = dtoT.datosFilas[i]["POBLACION"];
							tb.turno_id  = dtoT.datosFilas[i]["TURNO_ID"];
							tb.ubicacion_id  = dtoT.datosFilas[i]["UBICACION_ID"];
							poblacionDos.push(tb);
							poblacionTotalDos = poblacionTotalDos + dtoT.datosFilas[i]["POBLACION"];
						}
					}
					break;
				}
			}
		}
		
		private function depurarTablaCompania(dtoT:DTOTabla):void
		{
			var length:uint = dtoT.datosFilas.length;
			companias = new Vector.<CompaniaDTO>();
			for (var i:int = 0; i < length; i++) {
				var tb:CompaniaDTO = new CompaniaDTO();
				tb.nombre			   = dtoT.datosFilas[i]["COMPANIA"];
				companias.push(tb);
			}
			if (companias.length > 0)
			{
				companiaSeleccionada.text = companias[0].nombre;
				currentSelectedCompany = 0;
				companiaSeleccionada.setTextFormat(formatoTexto);
				botonDown2.addEventListener(MouseEvent.CLICK, botonClickeado, false, 0, true);
				botonUp2.addEventListener(MouseEvent.CLICK, botonClickeado, false, 0, true);
				botonBalance.addEventListener(MouseEvent.CLICK, botonClickeado, false, 0, true);
				botonCaptura.addEventListener(MouseEvent.CLICK, botonClickeado, false, 0, true);
				botonPoblacionPargoC.addEventListener(MouseEvent.CLICK, botonClickeado, false, 0, true);
				botonPoblacionRobaloC.addEventListener(MouseEvent.CLICK, botonClickeado, false, 0, true);
				botonPoblacionSierraC.addEventListener(MouseEvent.CLICK, botonClickeado, false, 0, true);
				botonPoblacionPargoM.addEventListener(MouseEvent.CLICK, botonClickeado, false, 0, true);
				botonPoblacionRobaloM.addEventListener(MouseEvent.CLICK, botonClickeado, false, 0, true);
				botonPoblacionSierraM.addEventListener(MouseEvent.CLICK, botonClickeado, false, 0, true);
				botonBarcosC.addEventListener(MouseEvent.CLICK, botonClickeado, false, 0, true);
				botonBarcosP.addEventListener(MouseEvent.CLICK, botonClickeado, false, 0, true);
				botonBarcosMP.addEventListener(MouseEvent.CLICK, botonClickeado, false, 0, true);
			}
			else
			{return; }
			
		}
		
		private function depurarTablaJuegos(dtoT:DTOTabla):void
		{
			var length:uint = dtoT.datosFilas.length;
			juegos = new Vector.<JuegoDTO>();
			for (var i:int = 0; i < length; i++) {
				var tb:JuegoDTO = new JuegoDTO();
				tb.juego_id 		= new int(dtoT.datosFilas[i]["JUEGO_ID"]);
				tb.finalizado 		= new int(dtoT.datosFilas[i]["FINALIZADO"]);
				tb.fecha_inicio 	= new Date(dtoT.datosFilas[i]["FECHA_INICIO"]);
				tb.duracion_turnos 	= new int(dtoT.datosFilas[i]["DURACION_TURNOS"]);
				tb.descripcion	 	= dtoT.datosFilas[i]["DESCRIPCION"];
				juegos.push(tb);
			}
			juegoSeleccionado.text = juegos[0].juego_id.toString();
			currentSelectedGame = 0;
			juegoSeleccionado.setTextFormat(formatoTexto);
		}
		
		private function estadisticasPoblacion():void
		{
			var xmlData:ChartXMLConstructor;
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
			
			switch(poblacionSeleccionada)
			{
				case 1:
				{
					if (isCoast)
						xmlData = new ChartXMLConstructor("Robalo costa", "200", "400", "20", ChartXMLConstructor.LINE_CHART);
					else
						xmlData = new ChartXMLConstructor("Robalo mar profundo", "200", "400", "20", ChartXMLConstructor.LINE_CHART);
					break;
				}
				case 2:
				{
					if (isCoast)
						xmlData = new ChartXMLConstructor("Sierra costa", "200", "400", "20", ChartXMLConstructor.LINE_CHART);
					else
						xmlData = new ChartXMLConstructor("Sierra mar profundo", "200", "400", "20", ChartXMLConstructor.LINE_CHART);
					break;
				}
				case 3:
				{
					if (isCoast)
						xmlData = new ChartXMLConstructor("Pargo costa", "200", "400", "20", ChartXMLConstructor.LINE_CHART);
					else
						xmlData = new ChartXMLConstructor("Pargo mar profundo", "200", "400", "20", ChartXMLConstructor.LINE_CHART);
					break;
				}
			}
			graficoEstadisticoLinea  	= new chartMC();
			var debugData:DebugStatisticalData  = new DebugStatisticalData();
			
			addChild(graficoEstadisticoLinea);
			graficoEstadisticoLinea.x = 100;
			
			csvText.text = "juego_id,poblacion_id,tipo_pez_id,turno_id,ubicacion_id\n";
			var pezDTOAux:PezDTO;
			var i:uint;
			
			if (isCoast)
			{
				xmlData.setData(debugData.GetPoblacionData(poblacionUno));
				for ( i = 0; i < poblacionUno.length; i++ )
				{
					pezDTOAux = poblacionUno[i];
					csvText.text = csvText.text + juegoSeleccionado.text + "," + pezDTOAux.poblacion + "," + poblacionSeleccionada + "," + pezDTOAux.turno_id + "," + pezDTOAux.ubicacion_id + "\n";
				}
			}
			else
			{
				xmlData.setData(debugData.GetPoblacionData(poblacionDos));	
				for ( i = 0; i < poblacionDos.length; i++ )
				{
					pezDTOAux = poblacionDos[i];
					csvText.text = csvText.text + juegoSeleccionado.text + "," + pezDTOAux.poblacion + "," + poblacionSeleccionada + "," + pezDTOAux.turno_id + "," + pezDTOAux.ubicacion_id + "\n";
				}
			}
			graficoEstadisticoLinea.loadDataXML(xmlData.getXML());
			graficoEstadisticoLinea.y = 500;
		}
		
		private function estadisticasBalance():void 
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
			
			csvText.text = "balance_general,compañia_nombre,juego_id,turno_id\n";
			var reporteDTOAux:ReporteDTO;
			var i:uint;
			var auxArray:Array = debugData.GetGeneralBalanceData(datosEstadisticos);
			
			for ( i = 1; i < datosEstadisticos.length; i++ )
			{
				reporteDTOAux = datosEstadisticos[i]; 
				csvText.text = csvText.text + auxArray[i][3] + "," + reporteDTOAux.compania_nombre + "," + reporteDTOAux.juego_id + "," + reporteDTOAux.turno_id + "\n";
			}
			
			addChild(graficoEstadisticoLinea);
			graficoEstadisticoLinea.x = 100;
			xmlData.setData(debugData.GetGeneralBalanceData(datosEstadisticos));
			graficoEstadisticoLinea.loadDataXML(xmlData.getXML());
			graficoEstadisticoLinea.y = 500;
		}
		
		private function estadisticasCaptura():void 
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
			
			csvText.text = "captura_pargo_costa,captura_pargo_mar_profundo,captura_robalo_costa,captura_robalo_mar_profundo,captura_sierra_costa,captura_sierra_mar_proundo,compañia_nombre,juego_id,turno_id\n";
			var reporteDTOAux:ReporteDTO;
			var i:uint;
			
			for ( i = 1; i < datosEstadisticos.length; i++ )
			{
				reporteDTOAux = datosEstadisticos[i]; 
				csvText.text = csvText.text + reporteDTOAux.captura_pargo_costa + "," +  reporteDTOAux.captura_pargo_mar_profundo + "," + reporteDTOAux.captura_robalo_costa + "," + reporteDTOAux.captura_robalo_mar_profundo + "," + 
							   reporteDTOAux.captura_sierra_costa + "," + reporteDTOAux.captura_sierra_mar_proundo + "," + reporteDTOAux.compania_nombre + "," + reporteDTOAux.juego_id + "," + reporteDTOAux.turno_id + "\n";
			}
			
			var xmlData:ChartXMLConstructor 	= new ChartXMLConstructor("Estadisticas Captura", "200", "560", "20", ChartXMLConstructor.BAR_CHART);
			graficoEstadisticoBarra	= new barChartMC();
			var debugData:DebugStatisticalData  = new DebugStatisticalData();
			var datosEstadisticosBarra:Vector.<ReporteDTO> = datosEstadisticos.slice(1,datosEstadisticos.length);
			addChild(graficoEstadisticoBarra);
			graficoEstadisticoBarra.x = 100;
			xmlData.setData(debugData.GetFishingReportData(datosEstadisticosBarra));
			graficoEstadisticoBarra.loadDataXML(xmlData.getXML());
			graficoEstadisticoBarra.y = 500;
		}
		
		private function depurarReportes(dtoT:DTOTabla):void 
		{
			var length:uint = dtoT.datosFilas.length;
			datosEstadisticos = new Vector.<ReporteDTO>;
			for (var i:int = 0; i < length; i++) {
				var tb:ReporteDTO = new ReporteDTO();
				tb.turno_id 					= new int(dtoT.datosFilas[i]["TURNO_ID"]);
				tb.juego_id 					= new int(dtoT.datosFilas[i]["JUEGO_ID"]);
				tb.compania_nombre 				= dtoT.datosFilas[i]["COMPANIA_NOMBRE"];
				tb.captura_pargo_costa 			= new int(dtoT.datosFilas[i]["CAPTURA_PARGO_COSTA"]);
				tb.captura_pargo_mar_profundo 	= new int(dtoT.datosFilas[i]["CAPTURA_PARGO_MAR_PROFUNDO"]);
				tb.captura_robalo_costa 		= new int(dtoT.datosFilas[i]["CAPTURA_ROBALO_COSTA"]);
				tb.captura_robalo_mar_profundo 	= new int(dtoT.datosFilas[i]["CAPTURA_ROBALO_MAR_PROFUNDO"]);
				tb.captura_sierra_costa 		= new int(dtoT.datosFilas[i]["CAPTURA_SIERRA_COSTA"]);
				tb.captura_sierra_mar_proundo 	= new int(dtoT.datosFilas[i]["CAPTURA_SIERRA_MAR_PROFUNDO"]);
				tb.balance_general 				= new int(dtoT.datosFilas[i]["BALANCE_GENERAL"]);
				datosEstadisticos.push(tb);
			}
		}
	}
}